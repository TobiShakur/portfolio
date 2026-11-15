# Performance Engineering Report — `tobias-portfolio-web`

**Live URL:** `https://tobias-portfolio-web.web.app`  
**Debug HUD URL:** `https://tobias-portfolio-web.web.app/?perf=1`  
**Keyboard Shortcut:** `Ctrl + Shift + P` or `Alt + P` (toggles `PerfDebugOverlay` anytime; zero runtime overhead when hidden)

---

## 1. Telemetry & Debug Tooling Implemented

### 1.1 Browser-Level Boot & Resource Instrumentation (`window.__portfolioPerf`)
- **Files:** `web/index.html`, `web/flutter_bootstrap.js`
- **Captured Timeline Marks & Stage Durations (`performance.now()` + `PerformanceObserver`):**
  - `htmlFirstPaintMs` — First Paint / First Contentful Paint (`first-contentful-paint` / `first-paint`) of the HTML `#initial-loader` curtain.
  - `engineLoadMs` — `_flutter.loader.load` start through `engineInitializer.initializeEngine()` completion (WASM/Skwasm bootstrap & download).
  - `dartBootMs` — `appRunner.runApp()` execution time.
  - `assetsAndFontsMs` — Time from `runApp()` completion until Dart dispatches `portfolio-ready`.
  - `totalReadyMs` — Total wall time from navigation `timeOrigin` until `portfolio-ready` opens `#initial-loader` (`readySource`: `'flutter'` vs `'fallback-timeout'`).
- **Network & Memory Breakdown (`performance.getEntriesByType('resource')` + `performance.memory`):**
  - `transferSizeKb` and `decodedBodySizeKb` segmented by `wasm`, `js`, `images`, `fonts`, and `other`.
  - Distinguishes **cache hits** (`transferSize === 0 && decodedBodySize > 0`), **network transfers**, and **opaque cross-origin CDN entries** (`transferSize === 0 && decodedBodySize === 0`, e.g., `gstatic.com` `skwasm.wasm` without `Timing-Allow-Origin`).
  - `jsHeapUsedMb` / `jsHeapTotalMb` via `performance.memory` (Chromium/Edge/Brave; gracefully falls back to `Chromium only` on Firefox/Safari).
  - Exposes `window.__portfolioPerf.snapshot()` and `window.__portfolioPerf.snapshotJson()` for live polling from Flutter Web (`dart:js_interop`).

### 1.2 In-App DevTools HUD (`PerfDebugOverlay`)
- **Files:**
  - `lib/core/services/perf_telemetry_models.dart`
  - `lib/core/services/perf_telemetry_service.dart` / `_web.dart` / `_stub.dart`
  - `lib/features/portfolio/presentation/widgets/debug/perf_debug_overlay.dart`
- **Features:**
  - **Zero-overhead default:** Renders `SizedBox.shrink()` when inactive; `SchedulerBinding.instance.addTimingsCallback` is registered only while the HUD is open.
  - **Boot Timeline:** Proportional stacked stage bar + per-stage `ms` table + renderer (`skwasm`) and `readySource` badges. Automatically polls until `totalReadyMs` settles when opened via `?perf=1`.
  - **Memory & Network:** `JS Heap (MB)`, live Flutter `Raster Cache` (`PaintingBinding.instance.imageCache` image count & MB), `Network Transfer (KB)` / `Decoded Body (KB)`, cache-hit badge, and per-type pills (`wasm`, `js`, `images`, `fonts`).
  - **Live FPS & Frame Timing:** Rolling 60-frame window computing average `FPS`, `UI Build ms`, `GPU Raster ms`, and `Jank (>16.6ms)` count.
  - **Baseline vs. Current Comparator (`localStorage` key `portfolio_perf_baseline_v1`):** `Save as Baseline`, `Clear`, and `Refresh` actions display signed percentage/unit deltas next to every metric (green `#34D399` for improvements, red `#F87171` for regressions).

---

## 2. Optimizations Applied

### 2.1 Round 1 — WebP Asset Optimization, `ImageCache` Deduplication & `RepaintBoundary` Isolation
1. **Asset Compression & Right-Sizing (`assets/` -> WebP):**
   - `nutrilens_sample_meal`: JPG `1200×896` (`976.9 KB`) -> WebP `640×478` (`74.1 KB`, **-92.4%**)
   - `setpoint_map_zoom`: PNG `504×833` (`387.0 KB`) -> WebP `504×833` (`67.2 KB`, **-82.6%**)
   - `setpoint_match_doubles`: PNG `504×834` (`327.1 KB`) -> WebP `504×834` (`39.6 KB`, **-87.9%**)
   - `setpoint_feed`: PNG `503×834` (`172.6 KB`) -> WebP `503×834` (`36.5 KB`, **-78.8%**)
   - `setpoint_filters`: PNG `502×832` (`49.8 KB`) -> WebP `502×832` (`18.8 KB`, **-62.3%**)
   - `nutrilens_icon`: PNG `512×512` (`207.8 KB`) -> WebP `128×128` (`3.6 KB`, **-98.3%**)
   - `setpoint_icon`: PNG `512×512` (`296.8 KB`) -> WebP `128×128` (`2.8 KB`, **-99.1%**)
   - **Total `assets/` images (7 files):** **`2,418.0 KB` -> `242.6 KB` (`-90.0%`, -2.12 MB)**.
2. **Eliminated Duplicate Icon `ImageCache` Keys:** Removed mismatched `cacheWidth` overrides on `128×128` icons (`sidebar_nav_item.dart`, `project_showcase_section.dart`, `nutrilens_preview_screens.dart`) so all icon widgets share the single precached entry.
3. **`RepaintBoundary` & Rebuild Isolation:**
   - Wrapped `InteractiveRightPhoneMockup` and `StoryboardPreviewPlayer`'s `AnimatedSwitcher` in `RepaintBoundary` and hoisted `PreviewMediaPlayer` into `TweenAnimationBuilder.child`.
   - Removed redundant `notifyListeners()` in `PortfolioNavigationController.setHoveredSidebarSection` and scoped `ListenableBuilder` + `RepaintBoundary` on `_AmbientCanvasGlow`, `FloatingPillSidebar`, and `MobileBottomPillDock`.

### 2.2 Round 2 — Unblocking the Curtain & Bundling Subsetted Local Fonts
1. **Non-Blocking Deferred Precache (`lib/app.dart`):**
   - `_awaitInitialAssetsAndNotify()` now awaits **only** `addPostFrameCallback` + the 2 icons visible in the initial Hero/Sidebar viewport (`nutrilens_icon.webp` `3.6 KB` + `setpoint_icon.webp` `2.8 KB` = **`6.4 KB`**) before calling `notifyPortfolioReady()`.
   - Off-screen Section 3 & 4 screenshots (`nutrilens_sample_meal.webp`, `setpoint_map_zoom.webp`, `setpoint_feed.webp`) are precached asynchronously (`unawaited(_precacheDeferredProjectImages())`) **after** the curtain opens.
2. **Subsetted Same-Origin Local Fonts (`assets/fonts/` + `pubspec.yaml`):**
   - Removed `google_fonts` dependency (and unused `fonts.googleapis.com` CSS `<link>`/`preconnect` tags in `web/index.html`), eliminating 12 runtime font requests (`835.6 KB` transferred / `1,548.9 KB` decoded).
   - Bundled subsetted static `.ttf` weights locally in `assets/fonts/` (`Inter` 400/500/600/700 at ~`50.3 KB` each + `Plus Jakarta Sans` 600/700 at `24.9 KB` each = **`251.1 KB` on disk**, **`109.2 KB` Brotli-transferred** from same-origin Firebase Hosting with `Cache-Control: immutable`).
   - Registered both families in `pubspec.yaml` under `fonts:`, updated `AppTextStyles` (`app_text_styles.dart`), and set `fontFamily: 'Inter'` in `AppTheme.dark()` (`app_theme.dart`).

---

## 3. Measured Progression: Baseline -> Round 1 -> Round 2 (Headless Edge CDP @ `https://tobias-portfolio-web.web.app`)

### 3.1 Cold Cache Comparison (Network Cache Disabled)
| Metric | Baseline (Pre-Perf) | Round 1 (WebP + Boundaries) | Round 2 (Deferred Precache + Local Subset Fonts) | Total Change (Baseline / R1 -> R2) |
|---|---:|---:|---:|---:|
| **Image Assets on Disk** | `2,418.0 KB` | `242.6 KB` | `242.6 KB` | **-90.0% (-2,175.4 KB)** |
| **Critical Images Before Curtain** | `2,037.0 KB` (5 imgs) | `185.0 KB` (5 imgs) | **`6.4 KB` (2 icons)** | **-99.7% (-2,030.6 KB)** |
| **`main.dart.wasm` Transfer / Decoded** | `498.3 KB` / `1,711.8 KB` | `515.3 KB` / `1,760.9 KB` | **`503.2 KB` / `1,724.0 KB`** | `-12.1 KB` vs R1 (removed `google_fonts`) |
| **Fonts Network Transfer / Decoded** | `835.4 KB` / `1,548.6 KB` | `835.6 KB` / `1,548.9 KB` | **`175.8 KB` / `321.5 KB`** | **-79.0% transfer / -79.2% decoded** |
| **Total Cold Network Transfer** | ~`3,400+ KB` *(est. w/ 2 MB imgs)* | `1,557.8–1,569.6 KB` | **`885.7 KB`** | **-43.6% vs R1** |
| **Total Cold Decoded Body** | ~`5,400+ KB` | `3,562.2–3,575.1 KB` | **`2,297.4 KB`** | **-35.7% vs R1** |
| **`assetsAndFontsMs`** | — *(uninstrumented)* | `702.6–1,513.7 ms` | **`765.2 ms`** | Consistently well below `1500ms` timeout |
| **`totalReadyMs` (`portfolio-ready`)** | ~`3,856 ms` *(est. before 580ms leave)* | `1,600.2–4,222.0 ms` | **`3,425.0 ms`** *(incl. 1.94s cold TLS/WASM)* | Cold network variance; `dartBootMs: 11.6 ms` |
| **`loaderGoneWallMs` (DOM removed)** | `4,436 ms` | `2,287–4,945 ms` | **`4,066 ms`** | — |
| **Cold `JS Heap` (Used / Total)** | `12.30 / 29.96 MB` | `10.59 / 28.17 MB` | **`7.98 / 12.68 MB`** | **-35.1% used / -57.7% total heap** |

### 3.2 Warm Cache Comparison (`https://tobias-portfolio-web.web.app/?perf=1`)
| Metric | Round 1 (Warm `?perf=1`) | Round 2 (Warm `?perf=1`) | Delta (R1 -> R2) |
|---|---:|---:|---:|
| **`htmlFirstPaintMs` (FCP)** | `408 ms` | **`264 ms`** | **-35.3% (-144 ms)** |
| **`engineLoadMs` (`skwasm`)** | `109.6 ms` | `140.9 ms` | `+31.3 ms` |
| **`dartBootMs` (`runApp`)** | `0.8 ms` | `3.5 ms` | `+2.7 ms` |
| **`assetsAndFontsMs`** | `471.3 ms` | **`310.8 ms`** | **-34.1% (-160.5 ms)** |
| **`totalReadyMs` (`portfolio-ready`)** | `1,200.3 ms` | **`874.9 ms`** | **-27.1% (-325.4 ms)** |
| **`loaderGoneWallMs` (DOM removed)** | `1,811 ms` | **`1,462 ms`** | **-19.3% (-349 ms)** |
| **Network Transfer** | `7.9 KB` (`21` cached) | **`7.8 KB`** (`18` cached, `wasm/images/fonts = 0 KB`) | **99.7% cached** |
| **Decoded Body** | `3,561.3 KB` | **`2,296.5 KB`** | **-35.5% (-1,264.8 KB)** |
| **`JS Heap` (at `totalReadyMs`)** | `18.26 / 51.95 MB` | **`13.81 / 21.48 MB`** | **-24.4% used / -58.7% total** |
| **`JS Heap` (HUD rendered + settled)** | `24.1 / 56.6 MB` | **`12.9 / 21.4 MB`** | **-46.5% used / -62.2% total** |
| **Live FPS / Jank (settled)** | — | **`Idle (60.0)` / `0/0` jank** | Verified clean |

---

## 4. Automated Verification

- `flutter analyze`: **0 issues**.
- `flutter test`: **21/21 passed** (including `perf_telemetry_models_test.dart` and `perf_debug_overlay_test.dart`).
- `flutter build web --release --wasm`: **exit code 0** (`skwasm` active, `52 files in build/web`).
- Live Edge CDP (`https://tobias-portfolio-web.web.app` & `?perf=1`): **0 console errors**, **0 uncaught exceptions**, `window.__portfolioPerf.snapshot()` populated, `PerfDebugOverlay` verified rendered with all timeline stages, memory/network buckets, and frame timings.

---

## 5. Round 5 — Deterministic `390×844 @2x` Media Pipeline & Live Visual Audit (`?v=r5`)

### 5.1 Capture & WebP Optimization (`assets/images/`)
Replaced NutriLens's synthetic canvas mockup (`NutriLensPreviewScreens`) and mismatched/cropped captures (`nutrilens_sample_meal.webp` `640×478`, `setpoint_map_zoom.webp` `504×833`) with **8 authentic `390×844 @2x` (`624×1350`, exact `9:19.5` bezel ratio)** WebP screenshots captured from the live deployed web apps via Headless Edge CDP (`--lang=en-US`, forcing NutriLens `en` locale via `localStorage['flutter.nutrilens_locale_v1']`):

| App | Asset | Resolution | Raw PNG | Optimized WebP (`q87`) | Role |
|---|---|---:|---:|---:|---|
| **NutriLens AI (EN)** | `nutrilens_dashboard.webp` | `624×1350` | `170.3 KB` | **`51.2 KB`** | Left tilted iPhone + Storyboard Step 1 |
| **NutriLens AI (EN)** | `nutrilens_scan.webp` | `624×1350` | `646.8 KB` | **`40.4 KB`** | Storyboard Step 2 (Vision scan sample) |
| **NutriLens AI (EN)** | `nutrilens_analysis.webp` | `624×1350` | `151.1 KB` | **`42.9 KB`** | Storyboard Step 3 (Macros & 94/100 Health Score) |
| **NutriLens AI (EN)** | `nutrilens_pantry.webp` | `624×1350` | `184.2 KB` | **`55.2 KB`** | Storyboard Step 4 (`My Pantry`) |
| **SetPoint** | `setpoint_map.webp` | `624×1350` | `791.2 KB` | **`82.1 KB`** | Left tilted iPhone (OSM BA map + cluster `3` + pin) |
| **SetPoint** | `setpoint_feed.webp` | `624×1350` | `454.5 KB` | **`60.3 KB`** | Storyboard Step 1 (Match feed, zero clipping) |
| **SetPoint** | `setpoint_filters.webp` | `624×1350` | `164.7 KB` | **`39.8 KB`** | Storyboard Step 2 (Multi-criteria filters sheet) |
| **SetPoint** | `setpoint_match_doubles.webp` | `624×1350` | `662.2 KB` | **`50.1 KB`** | Storyboard Step 3 (`Dobles Clásico en Recoleta`) |
| **Total (8 assets)** | — | `9:19.5` | `3,225.0 KB` | **`422.0 KB`** | **-86.9%** vs raw captures |

*(Note: WebM `MediaRecorder` probing showed Flutter Web encapsulates `<canvas>` in `flt-glass-pane` shadow DOM and video compression softens 9px mobile UI copy; static `624×1350` WebP storyboards deliver superior retina text sharpness at `422.0 KB` total across Safari & Chromium while keeping `assets/` precaching deferred post-`portfolio-ready`.)*

### 5.2 Round 5 Live Telemetry (`Headless Edge CDP @ 1440×900`, `?v=r5`)
| Target / Mode | `htmlFirstPaintMs` | `engineLoadMs` | `dartBootMs` | `assetsAndFontsMs` | `totalReadyMs` | Transfer / Decoded | `JS Heap` |
|---|---:|---:|---:|---:|---:|---:|---:|
| **Firebase Hosting (Cold)** | `328 ms` | `1,505.0 ms` | `10.0 ms` | `628.9 ms` | **`2,652.2 ms`** | `941.8 KB` / `2,354.8 KB` *(Hero+initial)* | `7.64 / 13.83 MB` |
| **GitHub Pages (Cold)** | `440 ms` | `997.3 ms` | `8.2 ms` | `639.3 ms` | **`2,217.1 ms`** | `1,104.4 KB` / `2,354.8 KB` | `8.91 / 14.45 MB` |
| **Firebase Hosting (Warm `?perf=1`)** | `228 ms` | `1,477.0 ms` | `1.0 ms` | `292.0 ms` | **`2,176.0 ms`** | `519.3 KB` / `2,353.9 KB` (`15` cached) | `8.1 / 22.3 MB` |

- **Post-Deploy Verification (`r5`):**
  - `flutter analyze`: **0 issues** (`No issues found!`).
  - `flutter test`: **22/22 passed**.
  - Live visual audit at `1440×900` (`https://tobias-portfolio-web.web.app` & `https://tobishakur.github.io/portfolio/`): **0 console errors**, **0 uncaught exceptions**; all 4 iPhone mockups across Sections 3 (`NutriLens AI`) and 4 (`SetPoint`) confirmed sharp, centered, and unclipped, with `PerfDebugOverlay` (`?perf=1`) active at `Idle (60.0) FPS / 0/0 jank`.

---

## 6. Round 6 — Commercial Hero/Capabilities Layout & Disjoint Mockup Carousels (`?v=r6`)

- **UI/Content Polish Verified Visually (`1440×900`):**
  - **Hero:** 2-line H1 (`Flutter & native apps, / from Figma to the stores.`) with `HOW I HELP TEAMS` card + `GMT-3` overlap.
  - **Capabilities:** 4 deliverable cards + balanced 3-column `ENGAGEMENT MODES` bar (eliminating the orphan `GitHub Actions` chip).
  - **Sections 3 & 4 (`NutriLens AI` & `SetPoint`):** Disjoint left/right phone screens (left fixed on Dashboard / Map; right rotating `Scan -> Analysis -> Pantry` and `Feed -> Filters -> Match Detail`) + `Scope` & `Try in 10s` box.
- **Round 6 Live Telemetry (`Headless Edge CDP @ 1440×900`, `?v=r6`):**
  - **Firebase Hosting (Cold):** `htmlFirstPaintMs: 328 ms`, `engineLoadMs: 2,503.7 ms`, `dartBootMs: 12.3 ms`, `assetsAndFontsMs: 945.7 ms`, `totalReadyMs: 4,025.8 ms`, `942.7 KB` transfer (`2,359.7 KB` decoded), `JS Heap 7.61 / 14.02 MB`, `0` console errors / `0` exceptions.
  - **Firebase Hosting (Warm `?perf=1`):** `htmlFirstPaintMs: 300 ms`, `engineLoadMs: 1,228.7 ms`, `dartBootMs: 1.2 ms`, `assetsAndFontsMs: 825.7 ms`, `totalReadyMs: 2,472.5 ms`, `15` cached resources (`images: 0 / 245.5 KB`, `fonts: 0.45 / 321.5 KB`), `520.2 KB` transfer.
  - **GitHub Pages (Cold):** `htmlFirstPaintMs: 452 ms`, `engineLoadMs: 1,794.3 ms`, `dartBootMs: 7.1 ms`, `assetsAndFontsMs: 683.5 ms`, `totalReadyMs: 3,185.7 ms`, `1,106.1 KB` transfer (`2,359.7 KB` decoded), `JS Heap 8.29 / 14.18 MB`, `0` console errors / `0` exceptions.
- **Local Verification (`?v=r6`):** `flutter analyze` (`0 issues`), `flutter test` (`23/23 passed`).
