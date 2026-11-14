# Tobías Gutiérrez — Mobile Software Engineer Portfolio

Production Flutter Web portfolio showcasing mobile software engineering work, cloud architecture, and live interactive product demos.

- **Live Portfolio (Firebase Hosting):** https://tobias-portfolio-web.web.app
- **Live Portfolio (GitHub Pages):** https://tobishakur.github.io/portfolio/
- **Performance Telemetry HUD:** Append `?perf=1` or press `Ctrl + Shift + P` / `Alt + P`

---

## Featured Projects

### NutriLens AI — Pantry-First Meal & Macro Tracker
- **Live Interactive App:** https://tobishakur.github.io/nutrilens-ai-tracker/
- **Repository:** https://github.com/TobiShakur/nutrilens-ai-tracker
- **Highlights:** 3-mode pantry scanning (Open Food Facts v2 + Gemini fallback, package front, nutrition OCR), prepared-meal pantry cross-matching, on-demand AI Health Score (`0–100`), Cloudflare Worker AI edge proxy (`Origin` CORS, model allowlist, `16 MB` cap, `30 req/min` IP rate limit), and **153 unit & widget tests**.

### SetPoint — Mobile Tennis Matchmaking Platform
- **Live Interactive App:** https://tobishakur.github.io/flutter-tennis-matchmaking/
- **Repository:** https://github.com/TobiShakur/flutter-tennis-matchmaking
- **Highlights:** Dual match feed & clustered OpenStreetMap viewport (`5–20 km` radius), live surface/skill/mode filtering, `1v1` / `2v2` tactical court views, participant-only chat with App Store-compliant UGC moderation, Clean Architecture + BLoC 8.1, and **24 unit & BLoC tests**.

---

## Architecture & Engineering Highlights

- **Flutter Web Wasm (`skwasm`) + Sub-Second Boot:**
  - Bundled subsetted `Plus Jakarta Sans` and `Inter` font assets (`251 KB` total) with zero runtime `fonts.gstatic.com` dependencies.
  - Synchronized HTML loader (`#initial-loader`) dismissed via `portfolio-ready` after first frame and initial viewport icon precache (`6.4 KB`), with project screenshots deferred in background.
- **Zero-Request Vector Brand Icons (`TechBrandIcon`):**
  - Pure Flutter `CustomPaint` logos for Flutter, Dart, Firebase, Cloudflare, Gemini AI, iOS, Android, Figma, OpenStreetMap, and GitHub Actions.
- **Security & Validation:**
  - Strict external URL allowlist (`UrlValidator`), `noopener`-safe `LaunchMode.externalApplication`, and `no-cache, must-revalidate` HTTP caching rules on unhashed build artifacts (`main.dart.mjs`, `main.dart.wasm`, `flutter_bootstrap.js`) to prevent stale Wasm import mismatches across releases.
- **Built-In Performance Telemetry (`PerfDebugOverlay`):**
  - Browser-level `window.__portfolioPerf` stage timings, network/cache breakdown, JS Heap tracking, live 60-frame FPS/Build/Raster metrics, and `localStorage` baseline delta comparison.

---

## Local Verification & Build

```bash
flutter analyze
flutter test
flutter build web --release --wasm
```

For GitHub Pages deployment under `/portfolio/`:

```bash
flutter build web --release --wasm --base-href "/portfolio/"
```
