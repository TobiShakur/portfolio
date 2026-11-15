# Design & UX Specification — Tobías Gutiérrez Portfolio (Flutter Web)

> **Target Stack:** Flutter Web (`proyectos/portfolio`)  
> **Deployment URL:** `https://tobishakur.github.io/portfolio/`  
> **Author:** `@disenador` (aligned with `ui-ux-pro-max` + `taste-skill` + `.agents/SQUAD.md`)  
> **Status:** Ready for Tobías Review → `@coder` Implementation

---

## 0. Strategic Direction & Strict Content Guardrails

### Visual Direction: *"The Quiet Instrument — Dark Engineering"*
Inspired by **Linear** and **Vercel** engineering surfaces: deep obsidian/soot dark canvas, opaque tonal surface steps, `1px` crisp structural hairlines, tabular-numeral metrics, generous negative space, and surgical accent color shifts tailored to each shipped product.

### Mandatory Guardrails (Zero Exceptions)
| Rule | Requirement |
|---|---|
| **Language** | **100% English** across all UI labels, headlines, descriptions, tooltips, buttons, metadata, and alt text. |
| **Title & Identity** | **Tobías Gutiérrez — Mobile Software Engineer**. **FORBIDDEN:** Never mention FIUBA, university, or student status anywhere in copy, metadata, or comments. |
| **Anti-AI-Slop Voice** | Zero filler verbs/adjectives (*"unlock"*, *"supercharge"*, *"seamless"*, *"elevate"*, *"effortless"*, *"cutting-edge"*, *"passionate developer"*). No *"not just X, it's Y"*, no tricolon slogans (*"Fast. Simple. Secure."*), no decorative `01/02/03` numbering, no eyebrow badges (*"Introducing"*, *"Available for work"* pulsing dots), no purple/indigo gradients, and no emojis as UI icons. |
| **Core Narrative** | Focus directly on **what real product/engineering problems Tobías solves** and **how the systems are built and verified**. |
| **Proof Integrity** | Only verified facts and numbers from shipped codebases (`153 Unit & Widget Tests` in NutriLens AI, `24 Unit & BLoC Tests` in SetPoint, `16 MB` / `30 req/min` Worker limits, etc.). |

---

## 1. Stage 1 — Wireframe Kit & Spatial Architecture

### 1.1 Viewport Cadence (`100vh` Full-Viewport Sections)
On Desktop (`>= 960px`), the page is structured as **5 distinct `100vh` (`MediaQuery.sizeOf(context).height`) sections** driven by a single `ScrollController` with smooth programmatic snap-scroll on sidebar click (plus optional soft wheel/snap assist that never hijacks inner scrolling on smaller viewports).

| Index | Section ID | Viewport Height | Purpose |
|---|---|---|---|
| `0` | `#overview` | `100vh` | **Hero — Direct Freelance Pitch, CTAs & Key Flutter/Dart Hiring Stack** |
| `1` | `#how-i-help` | `100vh` | **How I Help Teams — Vertical `1 → 2 → 3 → 4` Delivery Stepper** |
| `2` | `#stack` | `100vh` | **Core Stack & Deliverables — Concise 2×2 Engineering Matrix** |
| `3` | `#nutrilens` | `100vh` | **NutriLens AI** — Wide-Center (`22/54/24`) Showcase + Live Demo Portal |
| `4` | `#setpoint` | `100vh` | **SetPoint** — Wide-Center (`22/54/24`) Showcase + Live Demo Portal + Minimal Footer |

### 1.2 Spacing Grid (`4pt / 8pt` Rhythm) & Safe Zones
- **Base Unit:** `8.0` (`4.0` micro-gaps inside chips/badges).
- **Desktop Left Sidebar Safe Zone:** The compact Floating Pill Sidebar is positioned via `Align(alignment: Alignment.centerLeft)` with `margin: EdgeInsets.only(left: 24)` (`16px` on `960–1199px`), intrinsic width `~64px` (`44px` items + `8px` horizontal padding) and intrinsic height `MainAxisSize.min` (`~268px` — **never** full viewport height). It occupies roughly `x: 24px .. 88px` in the vertical middle only. Therefore, **all desktop section content containers MUST enforce `paddingLeft >= 112px`** so content never collides with the sidebar at `1280px`, `1440px`, or `1920px`.
- **Touch Target Minimum:** Every interactive element (sidebar pills, CTA buttons, GitHub/LinkedIn/Email links, mobile live-demo buttons) **must be `>= 44x44px`** (`48x48px` on mobile touch viewports).

### 1.3 Desktop Wireframe Blueprints (`>= 1200px` & `960–1199px`)

#### Floating Left Pill Sidebar (Compact, Vertically Centered Overlay)
```text
  Viewport Left Edge (0px)
  |
  |  (empty space above — does NOT stretch to top)
  |
  |   +-------+   <-- marginLeft: 24px, Alignment.centerLeft
  |   | (TG)  |       Section 0: Overview (Hero)       [44x44px]
  |   |  (•)  |       Section 1: How I Help (Stepper)  [44x44px]
  |   | (--)  |       Section 2: Core Stack            [44x44px]
  |   | [NL]  |       Section 3: NutriLens AI          [44x44px, Icon-512.png]
  |   | [SP]  |       Section 4: SetPoint              [44x44px, Icon-512.png]
  |   +-------+   <-- MainAxisSize.min (~268px inner / ~272px outer), borderRadius: 999
  |                   Fill: #050608 (deep black) | Border: 1.75px solid #303642
  |  (empty space below — does NOT stretch to bottom)
```
- **Intrinsic Sizing (`MainAxisSize.min`):** Height equals strictly `topPadding (8) + 5 × item (44) + 4 × gap (8) + bottomPadding (8) = 268px` (+ `3.5px` border = `~272px`, never `Expanded` or full-height column).
- **On Hover:** Item emits a subtle accent-tinted background + border glow, and reveals a floating label tooltip immediately to the right (`left: 100px`, e.g., `Overview`, `How I Help`, `Core Stack`, `NutriLens AI`, `SetPoint`).
- **On Active Section:** Smoothly highlighted pill ring + accent indicator matching the active section's token.

#### Section 1: Clean Hero & Core Hiring Stack (`100vh`)
Single breathable center-aligned column (`maxWidth: 960px`, `paddingLeft: 116px`) without distracting side cards: `TOBÍAS GUTIÉRREZ · MOBILE SOFTWARE ENGINEER · GMT-3`, exact 2-line `FittedBox` H1 (`Flutter & native apps, / from Figma to the stores.`), crisp 2-line client subtitle, primary contact CTAs, and an 8-chip Flutter/Dart hiring bar (`Flutter`, `Dart 3`, `BLoC / Riverpod`, `Firebase`, `REST & AI APIs`, `iOS & Android`, `Figma`, `GitHub Actions`).

#### Section 2: How I Help Teams — Vertical Stepper `1 → 2 → 3 → 4` (`100vh`)
Minimal vertical timeline (`32x32` numbered nodes linked by `1.5px` `#2A313D` line, `maxWidth: 740px`): (1) End-to-End Mobile Delivery, (2) Backend & AI Included for MVPs, (3) Clean Architecture & Automated QA, (4) Direct Overlap & Bilingual Communication.

#### Section 3: Core Stack & Deliverables (`100vh`)
Simplified 2×2 capability matrix (`#101318`, `1px borderHairline`, concise 1–2 line summary + embedded `TechBrandIcon` badges) without repeating Section 2.

#### Sections 4 & 5: App Showcases (`100vh` each — NutriLens AI & SetPoint, `flex: 22 / 54 / 24`)
Widened showcase (`maxWidth: 1360px`, `paddingLeft: 112px`, `paddingRight: 40px`) giving the center narrative **~39% more horizontal space (`flex: 54`, `~580–650px`)** with 1–2 line problem, **3 concise highlights**, single-line `Scope • Try in 10s:` hint, and responsive phone sizing so bottom CTAs remain 100% unclipped above `PortfolioFooterStrip` even at `1280×720`.

### 1.4 Responsive Breakpoints & Mobile Adaptation
| Breakpoint | Width | Navigation | Section Height | App Showcase Layout |
|---|---|---|---|---|
| **Wide Desktop** | `>= 1200px` | Left Floating Pill (`24px` inset) | `100vh` exact | 3-column row (`22% / 54% / 24%`, phones scaled to fit height without clipping footer CTAs at `1280×720`) |
| **Compact Desktop** | `960px – 1199px` | Left Floating Pill (`16px` inset) | `100vh` exact | 3-column row with tighter phone scale (`~220x475px`) and `20px` column gaps |
| **Tablet** | `600px – 959px` | Bottom Floating Pill Dock (`bottom: 16px`, centered) | `minHeight: 100vh` (natural scroll) | Top: Center Project Info (`maxWidth: 640px`). Bottom: 2-column Phone Row (Static Screen + Interactive Live Preview with visible CTA) |
| **Mobile** | `< 600px` | Bottom Floating Pill Dock (`height: 56px`, safe-area padding) | Natural content height + `64px` vertical padding | Single column: 1. Project Header & Problem/Solutions -> 2. Front-facing iPhone Preview with **persistent bottom `"Try Live Interactive App ↗"` pill button** (no hover-only dependency!) -> 3. Secondary Screen Showcase + GitHub CTA. |

### 1.5 Four Required Visual States (Component Resilience)
1. **Idle:** All text legible (`>= 4.5:1`), static tilted screenshot crisp, looping preview active in front iPhone, sidebar highlights active section.
2. **Loading / Buffering (Media & Video Preview):** While the Web video preview initializes or buffers, the right iPhone renders the app's high-res poster screenshot (`placeholder` frame) inside the bezel with a subtle top shimmer bar (`2px` accent progress line) — **CLS = 0** (exact `9:19.5` aspect ratio box reserved upfront).
3. **Empty / Missing Video Fallback (Progressive Enhancement):** If a video file fails to load or is temporarily unavailable in a browser codec, the right iPhone smoothly cycles an automated crossfade storyboard of 3–4 real app screens (`1.4s` crossfade, `4s` hold, paused under `prefers-reduced-motion`) so the mockup never shows a broken video player or blank black rectangle.
4. **Error / Offline Link & Clipboard Feedback:** External URL launch failures show a non-intrusive bottom floating toast (`"Could not open link — URL copied to clipboard"`). Clicking Email copies `tobigutierrez26@gmail.com` with instant inline state swap (`"Copied ✓"` for `2.2s`).

---

## 2. Stage 2 — Design Tokens (Colors, Typography, Surfaces)

### 2.1 Color Palette (`AppColors`)
Strictly opaque tonal dark steps + project-authentic accents (zero violet/indigo gradients, zero raw hexes inside widgets).

| Token | Hex / Value | Role | WCAG Contrast vs Canvas |
|---|---|---|---|
| `bgCanvas` | `#080A0C` | Primary page ground (Deep Soot Obsidian) | — |
| `bgSurface` | `#101318` | Engineering cards, secondary chips, device bezel interior | — |
| `bgSurfaceElevated` | `#171C23` | Hover surface step, active chips | — |
| `sidebarBg` | `#050608` | Floating Pill Sidebar pure/deep black capsule fill | — |
| `sidebarBorder` | `#303642` | Floating Pill Sidebar crisp solid grey border (`1.75px`) | — |
| `borderHairline` | `rgba(255, 255, 255, 0.08)` | Default `1px` card & container hairline | — |
| `borderFocus` | `rgba(255, 255, 255, 0.22)` | Hover/focus structural border | — |
| `textPrimary` | `#F4F6F8` | Headlines, project titles, primary labels | **17.4 : 1** (AAA) |
| `textSecondary` | `#9AA4B2` | Body copy, problem/solution descriptions | **7.5 : 1** (AAA) |
| `textMuted` | `#7A8594` | Supporting metadata, footer caption | **5.0 : 1** (AA) |
| `accentEngineering` | `#34D399` | Active indicator for Overview / Engineering sections | **10.6 : 1** |
| `accentNutriLens` | `#D2F07A` | NutriLens AI real brand Pistachio (from `AppColors.pistachio`) | **15.1 : 1** |
| `accentNutriLensDeep` | `#0C4E36` | NutriLens AI ambient surface tint (`8–12%` opacity) | — |
| `accentSetPoint` | `#C8E652` | SetPoint real brand Volt Lime (from `AppTheme.accentLimeColor`) | **14.2 : 1** |
| `accentSetPointDeep` | `#229C80` | SetPoint Court Emerald ambient tint (`8–12%` opacity) | — |
| `ctaInkOnAccent` | `#080A0C` | High-contrast dark ink on Pistachio / Volt Lime buttons | **> 14 : 1** |
| `scrimHover` | `rgba(8, 10, 12, 0.72)` | Blur backdrop scrim on interactive iPhone hover | — |

### 2.2 Typography System (`AppTextStyles`)
Using `google_fonts` (`Plus Jakarta Sans` + `Inter`) with `fontFeatures: [FontFeature.tabularFigures()]` on numeric metrics (`153`, `24`, `0–100`, `16 MB`, `30 req/min`).

| Role | Font Family | Weight | Desktop Size | Mobile Size | Line Height | Letter Spacing |
|---|---|---|---|---|---|---|
| `heroDisplay` | `Plus Jakarta Sans` | `700` (Bold) | `56px` (`clamp 44..60`) | `34px` | `1.06` | `-0.035em` |
| `sectionHeading` | `Plus Jakarta Sans` | `700` (Bold) | `36px` | `28px` | `1.14` | `-0.025em` |
| `projectTitle` | `Plus Jakarta Sans` | `700` (Bold) | `32px` | `26px` | `1.15` | `-0.02em` |
| `cardTitle` | `Plus Jakarta Sans` | `600` (SemiBold) | `18px` | `17px` | `1.30` | `-0.01em` |
| `bodyLead` | `Inter` | `400` (Regular) | `18px` | `16px` | `1.55` | `0` |
| `bodyDefault` | `Inter` | `400` (Regular) | `15px` | `15px` | `1.55` | `0` |
| `labelSmall` | `Inter` | `500` (Medium) | `13px` | `13px` | `1.35` | `+0.01em` |

*Strict floor:* **No text smaller than `13px`** anywhere in the UI (`taste-skill` legibility rule).

---

## 3. Stage 3 — Components, English Copy Deck & Micro-Animations

### 3.1 Complete English Copy Deck (Anti-AI-Slop Verified)

#### Section 1: Hero (`#overview`)
- **Identity Line:** `Tobías Gutiérrez — Mobile Software Engineer`
- **H1 Headline (2 lines max):**
  `Production mobile apps,`
  `architected end to end.`
- **Supporting Sentence:**
  `I build Flutter, iOS, and Android software backed by Firebase cloud backends, serverless AI proxies, and automated test suites.`
- **Primary Button:** `Explore Projects` (with down-arrow vector icon, scrolls to Section 2/3)
- **Direct Links:** `GitHub` · `LinkedIn` · `tobigutierrez26@gmail.com` *(click opens `mailto:` + adjacent `Copy` button)*
- **Core Stack Logo Strip (replaces plain grey line — `TechBrandIcon` SVG + `14px` `#D1D5DB` label):**
  `Flutter` · `Dart` · `Firebase` · `Cloudflare` · `Gemini AI` · `iOS` · `Android`
- **Right Column — Production Snapshot Card (`>= 1100px` side-by-side, stacked below on `< 1100px`):**
  - Header: `PRODUCTION SNAPSHOT` (`13px`, `accentEngineering` `#34D399`)
  - Row 1 — `Platforms`: `iOS (App Store) · Android · Flutter Web`
  - Row 2 — `Cloud & Backend`: `Firebase (Auth · Firestore · Functions · FCM) · Cloudflare Workers`
  - Row 3 — `Live Interactive Demos`: `NutriLens AI ↗` · `SetPoint ↗` *(clickable buttons scrolling to Section 3/4 or launching live URL)*
  - Row 4 — `Verified Quality`: `177 Automated Tests · Clean Architecture (BLoC / MVVM)`

#### Section 2: Capabilities & Cloud Stack (`#engineering`)
- **Section Title:** `Capabilities & Cloud Stack`
- **Subtitle:** `What I ship for startups and product teams—from Figma prototypes to cloud-backed stores.`
- **Card 1 — End-to-End Mobile Apps**
  - Copy (2 lines max): `Pixel-accurate Flutter apps for iOS and Android built from Figma specs with responsive, 60fps UI.`
  - Micro-pills (`TechBrandIcon`): `Flutter`, `Dart 3`, `iOS`, `Android`, `Figma`
- **Card 2 — Firebase & Cloud Backends**
  - Copy (2 lines max): `Production auth, real-time Firestore streams, Cloud Functions, Storage rules, and FCM / APNs push delivery.`
  - Micro-pills (`TechBrandIcon`): `Firebase`, `Firestore`, `Cloud Functions`, `FCM / APNs`
- **Card 3 — Secure AI & Edge APIs**
  - Copy (2 lines max): `Serverless Cloudflare Worker proxies keeping LLM keys off client bundles with CORS, allowlists, and rate limits.`
  - Micro-pills (`TechBrandIcon`): `Gemini AI`, `Cloudflare`, `REST APIs`
- **Card 4 — Offline-First, Maps & QA**
  - Copy (2 lines max): `Clustered OpenStreetMap viewports, local persistence fallbacks, automated tests, and CI/CD store delivery.`
  - Micro-pills (`TechBrandIcon`): `OpenStreetMap`, `GitHub Actions`, `177 Tests`
- **Bottom Ecosystem Bar (`CORE ECOSYSTEM`):**
  Grouped horizontal pill strip with embedded vector `TechBrandIcon` (`18px`) + label (`13px–14px`):
  `Flutter` · `Dart` · `Firebase` · `Cloudflare` · `Gemini AI` · `iOS` · `Android` · `Figma` · `OpenStreetMap` · `GitHub Actions`

#### Section 3: NutriLens AI (`#nutrilens`)
- **Title:** `NutriLens AI`
- **Subtitle:** `Pantry-First Meal & Macro Tracker`
- **The Problem:**
  `Most calorie trackers fail on home-cooked meals—forcing tedious manual weighing or falling back to generic database averages that ignore the actual brands in your kitchen.`
- **Key Engineering Solutions:**
  - **3-Mode Pantry Scanning:** Register ingredients once via barcode (**Open Food Facts API v2** with **Gemini** fallback), package front photo, or nutrition label OCR, with brand-conflict resolution.
  - **Home-Cooked Meal Matching:** Snap a prepared dish and Gemini Vision cross-references detected ingredients against your personal pantry for accurate macros.
  - **On-Demand AI Health Score (0–100):** Evaluates macro balance and micronutrient density with written rationale (`?/100` on manual meals) and stale-edit recalculation.
  - **Instant Web Demo & Serverless Proxy:** Includes built-in **Sample** meal testing, live **EN / ES** switching, and a **Cloudflare Worker** proxy (`Origin` CORS, model allowlist, `16 MB` cap, `30 req/min` IP limit).
- **Stack Chips:** `Dart & Flutter` · `Clean Architecture` · `MVVM + Provider` · `Gemini Vision` · `Open Food Facts v2` · `Cloudflare Workers` · `153 Unit & Widget Tests`
- **Links:** `View Source on GitHub ↗` (`https://github.com/TobiShakur/nutrilens-ai-tracker`) · `Open Live Demo ↗` (`https://tobishakur.github.io/nutrilens-ai-tracker/`)
- **Right iPhone Hover CTA:** `Try Live Interactive App ↗`

#### Section 4: SetPoint (`#setpoint`)
- **Title:** `SetPoint`
- **Subtitle:** `Mobile Tennis Matchmaking Platform`
- **The Problem:**
  `Organizing tennis matches over group chats breaks down quickly—mismatched skill levels, unclear court surfaces, and manual headcounts waste hours every week.`
- **Key Engineering Solutions:**
  - **Dual Feed & Map Clustering:** Switch seamlessly between a match feed and an interactive **OpenStreetMap** viewport with proximity clustering and `5–20 km` radius filtering.
  - **Real-Time Multi-Criteria Filtering:** Filter live by game mode (Singles / Doubles), court surface (Clay, Hard, Grass), and 5-tier player skill level.
  - **Tactical Court & Match Chat:** Dynamic surface-themed `1v1` / `2v2` court formations plus participant-only chat with App Store-compliant UGC moderation (report & block).
  - **Offline-Resilient BLoC Architecture:** Strict **Clean Architecture + BLoC 8.1** with Dart 3 `sealed` domain errors and deterministic offline mock repositories.
- **Stack Chips:** `Dart 3 & Flutter` · `Clean Architecture` · `BLoC 8.1` · `OpenStreetMap + Clustering` · `Dark Glassmorphism` · `24 Unit & BLoC Tests`
- **Links:** `View Source on GitHub ↗` (`https://github.com/TobiShakur/flutter-tennis-matchmaking`) · `Open Live Demo ↗` (`https://tobishakur.github.io/flutter-tennis-matchmaking/`)
- **Right iPhone Hover CTA:** `Try Live Interactive App ↗`
- **Minimal Footer Strip (bottom of Section 4):** `Tobías Gutiérrez · Mobile Software Engineer · GitHub · LinkedIn · Email`

### 3.2 Component & Animation Specifications

| Component | Visual Spec | Interaction & Animation (`duration`, `curve`) |
|---|---|---|
| **Floating Pill Sidebar** | Positioned via `Align(alignment: Alignment.centerLeft)` with `margin: EdgeInsets.only(left: 24)` (`16px` on compact desktop). **Intrinsic size (`MainAxisSize.min`, NEVER full height):** `padding: EdgeInsets.all(10)`, `4` items (`44x44px` hit target each) separated by `SizedBox(height: 10)` -> total intrinsic height `~226px`, width `~64px`. Pill shape `borderRadius: BorderRadius.circular(999)` (`32px` radius), solid deep-black fill `sidebarBg` (`#050608`), crisp `1.75px` solid grey border `sidebarBorder` (`#303642`), and subtle elevation shadow (`rgba(0,0,0,0.65)`, `blurRadius: 24`). App icons (`40x40px` visual inside `44x44px` target) clipped with `ClipRRect(borderRadius: 12)`. Mobile (`< 960px`) adapts into a centered compact horizontal bottom pill dock (`MainAxisSize.min`, same `#050608` fill + `1.75px` `#303642` border). | Active/Hover: `AnimatedContainer` (`200ms`, `Curves.easeOutCubic`) tints item background to `accent.withValues(alpha: 0.16)`, item ring to `1.5px` `accent.withValues(alpha: 0.65)`, and subtle item glow `BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 14)`. Hover reveals right-floating label pill tooltip (`150ms` fade + `6px` slide). Click smooth-scrolls (`650ms`, `Curves.easeInOutCubic`). |
| **Tilted Left iPhone Mockup** | Aspect `9:19.5` (e.g., `245x530px` on `1440px` desktop). Dark titanium bezel (`#14181F`, `3px` stroke, `1px` inner specular edge `rgba(255,255,255,0.14)`), Dynamic Island pill (`74x20px`). **Mandatory `topSafeArea: 32px` clearance below Dynamic Island** so app headers/toggles (`NutriLens AI`, `Lista \| Mapa`) are never overlapped. Inner media uses `BoxFit.contain` + `Alignment.topCenter` on matching screen background (`#FFFFFF` / `#0E1311`) so **zero horizontal text cropping** occurs. Transform: `Matrix4.identity()..setEntry(3, 2, 0.0012)..rotateY(0.24)..rotateX(-0.04)`. | Subtle hover settle (`260ms`, `Curves.easeOutCubic`): gently reduces tilt from `0.24` to `0.14 rad` and lifts opacity/bezel sheen slightly—zero layout shift (`CLS = 0`). Wrapped in `RepaintBoundary`. |
| **Front Right iPhone (Video + Blur CTA)** | Aspect `9:19.5` (e.g., `260x563px` on `1440px` desktop). Upright (`0 deg`), titanium bezel, Dynamic Island with **`topSafeArea: 32px` top inset**, subtle ambient radial glow behind frame (`10%` opacity of app accent). For SetPoint, frame/render inner screens at exact `9:19.5` proportions (or `BoxFit.contain` on `#0E1311` ground + English UI) so zero text is clipped at the sides. Directly beneath the bezel on desktop, show a subtle `13px` caption (`Hover to launch live demo ↗`, `textSecondary`). | **Hover / Keyboard Focus (`MouseRegion` + `FocusNode`):** Over `220ms` (`Curves.easeOutCubic`), inner preview animates `ImageFilter.blur(sigmaX: 0 -> 8, sigmaY: 0 -> 8)`, dark scrim `0.0 -> 0.72` fades in, and centered pill CTA (`height: 48px`, `padding: 0 22px`, `borderRadius: 999`, solid app accent background `#D2F07A` / `#C8E652`, `#080A0C` text) scales `0.94 -> 1.0` and fades `0.0 -> 1.0`. Cursor becomes `SystemMouseCursors.click`. |
| **TechBrandIcon (Embedded Vector Brand Logos)** | Pure embedded vector paths (`CustomPainter` or bundled SVG strings — **zero external network requests**!) for 10 brands: `Flutter`, `Dart`, `Firebase`, `Cloudflare`, `Gemini AI`, `Apple / iOS`, `Android`, `Figma`, `OpenStreetMap`, `GitHub Actions`. Rendered at `16px–20px` inside clean `#101318` / `#171C23` chips (`1px borderHairline`, `borderRadius: 999` or `8px`) with crisp `#D1D5DB` / brand-tinted fill. | Hover (`160ms`, `Curves.easeOutCubic`): chip surface shifts from `bgSurface` to `bgSurfaceElevated` and border brightens to `borderFocus` / brand tint. |
| **Primary & Secondary Buttons** | Primary: solid high-contrast `#F4F6F8` with `#080A0C` ink (or app accent on hover CTA), `height: 46px`, `borderRadius: 999` (pill) or `10px` (rectangular Linear style — pick **one**: `borderRadius: 10px` for action buttons and `999px` strictly for pills/chips/sidebar!). Secondary: `#101318` fill, `1px borderHairline`, `height: 46px`. | Hover (`160ms`, `Curves.easeOutCubic`): background shifts 1 tonal step (`bgSurface -> bgSurfaceElevated`) and border brightens to `borderFocus`. No bouncy scale overshoot. |
| **Reduced Motion Compliance** | Respect `MediaQuery.disableAnimationsOf(context)` / `prefers-reduced-motion`. | Instant state transitions (`Duration.zero` or `80ms` opacity fade), disable 3D hover tilt shift, pause auto-cycling fallback slides on first frame. |

---

## 4. Asset Manifest & Preparation Checklist for `@coder`

### Assets Already Verified in Workspace
1. **NutriLens AI App Icon:** `proyectos/nutrilens_provider/web/icons/Icon-512.png` (Copy to `proyectos/portfolio/assets/icons/nutrilens_icon.png`)
2. **SetPoint App Icon:** `tenis_app/web/icons/Icon-512.png` (Copy to `proyectos/portfolio/assets/icons/setpoint_icon.png`)
3. **SetPoint Real Screenshots:** `capturas_tenis_app/` contains 11 real screens, notably:
   - `capturas_tenis_app/mapa_zoom.png` (Ideal for SetPoint Left Tilted iPhone — OpenStreetMap + custom tennis markers + dark glass overlay)
   - `capturas_tenis_app/feed_screen.png` (Ideal for SetPoint secondary / storyboard frame)
   - `capturas_tenis_app/partido_detalle_unido_doubles.png` & `capturas_tenis_app/filtros_bottom_sheet.png`

### Assets to Supply / Generate for Full Polish
1. **NutriLens AI Static Key Screen (`assets/images/nutrilens_screen_main.png`):** Export/capture 1–3 high-resolution (`1170x2532` or `390x844` @3x) screenshots from `nutrilens_provider` (e.g., Home Daily Ring + Pantry-matched Meal Detail / Health Score sheet).
2. **Looping Demo Videos (`assets/videos/nutrilens_demo.mp4` & `assets/videos/setpoint_demo.mp4`):**
   - Lightweight muted H.264 `.mp4` (or `.webm`) clips (`8–12s` loop, `<= 2–4 MB` each for fast GitHub Pages load, rendered via HTML5 `<video autoplay loop muted playsinline>` inside Flutter Web `HtmlElementView` so autoplay works reliably in Chrome/Safari/Edge without `video_player` codec hiccups!).
   - **Built-in Fallback:** Until `.mp4` clips are dropped in (or if a browser blocks video), `@coder` should implement the **automatic crossfade storyboard** using each app's real screenshots (`nutrilens_screen_*.png` and `capturas_tenis_app/*.png`) so the portfolio renders 100% complete and animated right out of the box.

---

## 5. Implementation Notes for `@coder` (Flutter Web Best Practices)
- **Web Video Playback:** Prefer a clean platform view (`ui_web.platformViewRegistry` registering a native `<video autoplay loop muted playsinline>` element with `object-fit: cover`) wrapped in `IgnorePointer` beneath the Flutter `MouseRegion` + `BackdropFilter` hover overlay. Note: Test `BackdropFilter` over `HtmlElementView` on Flutter Web (CanvasKit); if CanvasKit `BackdropFilter` doesn't blur the DOM `<video>` element directly on Web, apply CSS `filter: blur(8px)` directly via JS/DOM style toggle or `AnimatedOpacity` scrim + CSS class on hover so the blur effect is **guaranteed crisp across Chrome, Safari, and Firefox**!
- **Base Href for GitHub Pages:** Build with `flutter build web --release --base-href "/portfolio/"`.
- **Single-Responsibility Widgets:** Keep tokens in `lib/core/theme/` (`app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart`), data models in `lib/features/portfolio/domain/` (or clean static domain catalog), and responsive layouts via `LayoutBuilder` with zero hardcoded pixel overflows.
- **Verification Target:** `flutter analyze` (`0 issues`) + widget tests verifying responsive breakpoints (`1440x900`, `1024x768`, `390x844`), sidebar scroll navigation, email copy feedback, hover/focus CTA visibility, and zero mentions of forbidden profile strings.
