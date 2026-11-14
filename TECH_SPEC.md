# Technical Specification — Tobías Gutiérrez Portfolio (Flutter Web)

> **Target Project:** `proyectos/portfolio` (Flutter Web, `--base-href "/portfolio/"`)  
> **Deployment URL:** `https://tobishakur.github.io/portfolio/`  
> **Author:** `@arquitecto`  
> **Inputs:** `PORTFOLIO_PROMPT.md`, `proyectos/portfolio/DESIGN_SPEC.md`, `.agents/SQUAD.md`, `@secops` Security Dictamen (Board `#8`)  
> **Scope:** Architectural & implementation blueprint for `@coder`. Zero `.dart` files authored here.

---

## 1. Architectural Strategy (Pragmatic & Modular)

This application is a **static-catalog interactive showcase** with zero backend APIs, zero user authentication, and zero mutable persistence. Over-engineering with `flutter_bloc`, `get_it`, or remote DTOs would add boilerplate without value.

Instead, the architecture enforces **strict separation of concerns** across 3 lean layers:

1. **`core/`**: Immutable Design System tokens (`AppColors`, `AppTextStyles`, `AppSpacing`, `AppTheme`) and testable platform service abstractions (`ExternalLinkLauncher`, `ClipboardService`, `UrlValidator`).
2. **`features/portfolio/domain/` + `data/`**: Pure immutable Dart 3 value models (`PortfolioSectionId`, `ProfileData`, `EngineeringPillar`, `ProjectShowcase`) and a centralized `PortfolioCatalog` data source so UI widgets never hardcode copy, URLs, or asset paths.
3. **`features/portfolio/presentation/`**: A single lightweight `PortfolioNavigationController` (`ChangeNotifier`) consumed via Flutter's native `ListenableBuilder` and constructor-injected dependencies, driving modular section and device-mockup widgets.

### Key Architectural Invariants
- **100% Constructor Dependency Injection:** No widget instantiates `UrlLauncher` or interacts with `Clipboard` directly; all side effects go through interfaces injected at `PortfolioApp` root and mocked with fakes in tests.
- **Dart 3 Exhaustiveness:** Action outcomes (`LinkLaunchResult`, `ClipboardResult`, `CopyEmailState`) use `sealed class` hierarchies with exhaustive `switch` expressions.
- **VM-Safe Web Video Abstraction:** `dart:ui_web` and `package:web` are strictly isolated behind a conditional import (`preview_media_player_stub.dart` vs `preview_media_player_web.dart`) so `flutter test` runs on the Dart VM with zero web-only compilation errors.
- **Zero Forbidden Content:** No mention of FIUBA, university, or student status anywhere in Dart code, tests, comments, assets, or `web/index.html`. Zero raw hex values inside widgets.

---

## 2. Exact File Map (`proyectos/portfolio/`)

```text
proyectos/portfolio/
├── pubspec.yaml
├── analysis_options.yaml
├── web/
│   ├── index.html                                    # Hardened HTML5 entry (en, base-href, referrer, nosniff)
│   └── manifest.json
├── assets/
│   ├── icons/
│   │   ├── nutrilens_icon.png                        # Copied from proyectos/nutrilens_provider/web/icons/Icon-512.png
│   │   └── setpoint_icon.png                         # Copied from tenis_app/web/icons/Icon-512.png
│   ├── images/
│   │   ├── nutrilens_sample_meal.jpg                 # Copied from proyectos/nutrilens_provider/assets/images/sample_meal.jpg
│   │   ├── setpoint_map_zoom.png                     # Copied from capturas_tenis_app/mapa_zoom.png
│   │   ├── setpoint_feed.png                         # Copied from capturas_tenis_app/feed_screen.png
│   │   ├── setpoint_match_doubles.png                # Copied from capturas_tenis_app/partido_detalle_unido_doubles.png
│   │   └── setpoint_filters.png                      # Copied from capturas_tenis_app/filtros_bottom_sheet.png
│   └── videos/                                       # Optional H.264 muted loops (graceful fallback if absent)
├── lib/
│   ├── main.dart                                     # Composition root (DI wiring)
│   ├── app.dart                                      # MaterialApp + dark theme + PortfolioPage
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart                       # Exact palette tokens from DESIGN_SPEC.md
│   │   │   ├── app_text_styles.dart                  # Plus Jakarta Sans + Inter + tabularFigures
│   │   │   ├── app_spacing.dart                      # 4pt/8pt grid, breakpoints, sidebar safe zones
│   │   │   └── app_theme.dart                        # ThemeData.dark() configuration
│   │   └── services/
│   │       ├── url_validator.dart                    # Pure Dart allowlist validator (https + official mailto)
│   │       ├── external_link_launcher.dart           # Abstract interface + UrlLauncher impl + sealed LinkLaunchResult
│   │       └── clipboard_service.dart                # Abstract interface + Flutter Clipboard impl + sealed ClipboardResult
│   └── features/
│       └── portfolio/
│           ├── domain/
│           │   └── entities/
│           │       ├── portfolio_section_id.dart     # Enum: overview, engineering, nutrilens, setpoint
│           │       ├── profile_data.dart             # @immutable ProfileData
│           │       ├── engineering_pillar.dart       # @immutable EngineeringPillar + EngineeringIconKind
│           │       └── project_showcase.dart         # @immutable ProjectShowcase + PreviewScreenSlide
│           ├── data/
│           │   └── portfolio_catalog.dart            # Verified English copy deck & project catalog
│           └── presentation/
│               ├── controllers/
│               │   └── portfolio_navigation_controller.dart  # Scroll sync, section nav, email copy, link feedback
│               ├── screens/
│               │   └── portfolio_page.dart           # LayoutBuilder responsive scaffold + Stack overlays
│               └── widgets/
│                   ├── common/
│                   │   ├── portfolio_action_button.dart      # Primary/Secondary 46px+ interactive buttons
│                   │   ├── tech_stack_chip.dart              # Tabular-numeric stack & test badges
│                   │   └── feedback_toast.dart             # Non-intrusive bottom status toast
│                   ├── navigation/
│                   │   ├── floating_pill_sidebar.dart        # Desktop left pill (MainAxisSize.min, ~226x64px)
│                   │   ├── mobile_bottom_pill_dock.dart      # < 960px centered bottom pill dock
│                   │   └── sidebar_nav_item.dart             # 44x44px hit target + hover tooltip + accent glow
│                   ├── sections/
│                   │   ├── overview_hero_section.dart        # Section 0 (#overview)
│                   │   ├── engineering_approach_section.dart # Section 1 (#engineering, 2x2 matrix)
│                   │   ├── project_showcase_section.dart     # Sections 2 & 3 (#nutrilens, #setpoint, 3-col / responsive)
│                   │   └── portfolio_footer_strip.dart       # Minimal footer strip at bottom of Section 3
│                   └── mockups/
│                       ├── iphone_bezel_frame.dart           # 9:19.5 dark titanium bezel + Dynamic Island
│                       ├── tilted_left_phone_mockup.dart     # 3D perspective Matrix4 + hover settle
│                       ├── interactive_right_phone_mockup.dart # Front iPhone + hover/focus blur + "Try Live Interactive App ↗"
│                       ├── preview_media_player.dart         # Conditional export facade
│                       ├── preview_media_player_stub.dart    # VM/Test fallback: smooth crossfade storyboard
│                       ├── preview_media_player_web.dart     # Web: <video> HtmlElementView + onError storyboard fallback
│                       └── nutrilens_preview_screens.dart    # High-fidelity Flutter UI frames for NutriLens AI
└── test/
    ├── fakes/
    │   ├── fake_external_link_launcher.dart
    │   └── fake_clipboard_service.dart
    ├── core/services/
    │   └── url_validator_test.dart
    └── features/portfolio/
        ├── data/portfolio_catalog_test.dart
        ├── presentation/controllers/portfolio_navigation_controller_test.dart
        ├── presentation/widgets/floating_pill_sidebar_test.dart
        ├── presentation/widgets/interactive_right_phone_mockup_test.dart
        └── presentation/screens/portfolio_page_test.dart
```

---

## 3. Dependencies (`pubspec.yaml`)

Keep third-party packages lean and web-friendly:
- `flutter` (SDK)
- `google_fonts: ^6.2.1` (or workspace-compatible `^8.2.1` as in `nutrilens_provider`, resolving `Plus Jakarta Sans` and `Inter`)
- `url_launcher: ^6.3.1` (standard Flutter Web `_blank` external launch)
- `web: ^1.1.0` (only imported inside `preview_media_player_web.dart` via conditional import)
- Dev: `flutter_test`, `flutter_lints`

> **Font Fallback & Offline Test Safety:** Wrap `GoogleFonts` text styles cleanly and ensure `GoogleFonts.config.allowRuntimeFetching = false` can be toggled in widget tests if needed, or rely on `GoogleFonts` graceful fallback to sans-serif in VM tests so tests never make real network calls or fail offline.

---

## 4. Core Layer (`lib/core/`)

### 4.1 Design Tokens (`lib/core/theme/`)

#### `AppColors` (`app_colors.dart`) — Exact Hex Mapping
| Token | Value | Usage |
|---|---|---|
| `bgCanvas` | `Color(0xFF080A0C)` | Scaffold / root page background |
| `bgSurface` | `Color(0xFF101318)` | Engineering cards, secondary buttons, bezel interior |
| `bgSurfaceElevated` | `Color(0xFF171C23)` | Hover state surface, active stack chips |
| `sidebarBg` | `Color(0xFF050608)` | Pure/deep black Floating Pill Sidebar & Mobile Dock |
| `sidebarBorder` | `Color(0xFF303642)` | `1.75px` solid border on Floating Pill Sidebar & Mobile Dock |
| `bezelFrame` | `Color(0xFF14181F)` | iPhone outer titanium frame (`3px` stroke) |
| `bezelSpecular` | `Color(0x24FFFFFF)` | `rgba(255, 255, 255, 0.14)` `1px` inner edge |
| `borderHairline` | `Color(0x14FFFFFF)` | `rgba(255, 255, 255, 0.08)` default `1px` border |
| `borderFocus` | `Color(0x38FFFFFF)` | `rgba(255, 255, 255, 0.22)` hover/focus border |
| `textPrimary` | `Color(0xFFF4F6F8)` | Headlines, titles, primary buttons |
| `textSecondary` | `Color(0xFF9AA4B2)` | Body copy, problem/solution descriptions |
| `textMuted` | `Color(0xFF7A8594)` | Supporting metadata, footer strip |
| `accentEngineering` | `Color(0xFF34D399)` | Overview & Engineering active indicator |
| `accentNutriLens` | `Color(0xFFD2F07A)` | NutriLens AI Pistachio accent & CTA fill |
| `accentNutriLensDeep` | `Color(0xFF0C4E36)` | NutriLens AI ambient tint (`8–12%` opacity) |
| `accentSetPoint` | `Color(0xFFC8E652)` | SetPoint Volt Lime accent & CTA fill |
| `accentSetPointDeep` | `Color(0xFF229C80)` | SetPoint Court Emerald ambient tint (`8–12%` opacity) |
| `ctaInkOnAccent` | `Color(0xFF080A0C)` | Dark ink on `#F4F6F8`, `#D2F07A`, `#C8E652` buttons |
| `scrimHover` | `Color(0xB8080A0C)` | `rgba(8, 10, 12, 0.72)` blur backdrop scrim |
| `sidebarShadow` | `Color(0xA6000000)` | `rgba(0, 0, 0, 0.65)` elevation shadow (`blurRadius: 24`) |

#### `AppSpacing` (`app_spacing.dart`)
- Breakpoints:
  - `wideDesktop = 1200.0`
  - `desktop = 960.0`
  - `tablet = 600.0`
- Grid & safe zones:
  - `xs = 4.0`, `sm = 8.0`, `md = 16.0`, `lg = 24.0`, `xl = 32.0`, `xxl = 48.0`, `sectionVerticalMobile = 64.0`
  - `sidebarWidth = 64.0`, `sidebarHeight = 226.0`, `sidebarInsetWide = 24.0`, `sidebarInsetCompact = 16.0`
  - `desktopLeftSafePadding = 116.0` (`>= 112px` mandated by `DESIGN_SPEC.md` so content never collides with the left pill)
  - `desktopRightPaddingWide = 64.0`, `desktopRightPaddingCompact = 32.0`
  - `minTouchTarget = 44.0` (`48.0` for primary mobile touch controls)
  - `maxContentWidth = 1280.0`

#### `AppTextStyles` (`app_text_styles.dart`)
- Uses `GoogleFonts.plusJakartaSans` for display/headings (`heroDisplay`, `sectionHeading`, `projectTitle`, `cardTitle`) and `GoogleFonts.inter` for body/labels (`bodyLead`, `bodyDefault`, `labelSmall`).
- Includes `tabularFigures()` helper (`fontFeatures: const [FontFeature.tabularFigures()]`) for numeric badges (`153`, `24`, `0–100`, `16 MB`, `30 req/min`, `177`).
- Minimum font size floor: **`13.0` (`labelSmall`)** everywhere in the app.

### 4.2 Security-Hardened Services (`lib/core/services/`)

#### `UrlValidator` (`url_validator.dart`)
Pure Dart utility enforcing `@secops` Board `#8` rules:
- `static const Set<String> allowedHttpsHosts = {'github.com', 'linkedin.com', 'tobishakur.github.io'};`
- `static const String allowedMailtoEmail = 'tobigutierrez26@gmail.com';`
- `static Uri? parseAllowedUri(String rawUrl)`:
  - Trims input; returns `null` if empty.
  - Parses with `Uri.tryParse(trimmed)`.
  - If `uri.scheme == 'https'`: requires `uri.hasAuthority`, `uri.host.isNotEmpty`, and `allowedHttpsHosts.contains(uri.host.toLowerCase())` (also rejects embedded userinfo `uri.userInfo.isNotEmpty`).
  - If `uri.scheme == 'mailto'`: requires `uri.path.toLowerCase() == allowedMailtoEmail`.
  - Rejects `http`, `javascript`, `data`, `file`, or any unknown host/scheme by returning `null`.

#### `ExternalLinkLauncher` (`external_link_launcher.dart`)
```dart
@immutable
sealed class LinkLaunchResult {
  const LinkLaunchResult();
}

final class LinkLaunchSuccess extends LinkLaunchResult {
  const LinkLaunchSuccess();
}

final class LinkLaunchRejected extends LinkLaunchResult {
  const LinkLaunchRejected();
}

final class LinkLaunchFailure extends LinkLaunchResult {
  const LinkLaunchFailure();
}

abstract interface class ExternalLinkLauncher {
  Future<LinkLaunchResult> openExternal(String url);
}
```
- `UrlLauncherExternalLinkLauncher`:
  1. Calls `UrlValidator.parseAllowedUri(rawUrl)`. If `null`, returns `const LinkLaunchRejected()`.
  2. Calls `launchUrl(uri, mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank')` inside `try/catch`.
  3. Returns `launched ? const LinkLaunchSuccess() : const LinkLaunchFailure()`.
  4. **Never** prints or returns `$e` or `StackTrace`.

#### `ClipboardService` (`clipboard_service.dart`)
```dart
@immutable
sealed class ClipboardResult {
  const ClipboardResult();
}

final class ClipboardSuccess extends ClipboardResult {
  const ClipboardSuccess();
}

final class ClipboardFailure extends ClipboardResult {
  const ClipboardFailure();
}

abstract interface class ClipboardService {
  Future<ClipboardResult> copyText(String text);
}
```
- `FlutterClipboardService`: calls `Clipboard.setData(ClipboardData(text: text))` inside `try/catch`; returns `ClipboardSuccess` or `ClipboardFailure` with zero raw exception leakage.

---

## 5. Domain & Catalog Layer (`lib/features/portfolio/`)

### 5.1 Entities (`domain/entities/`)

#### `PortfolioSectionId` (`portfolio_section_id.dart`)
```dart
enum PortfolioSectionId {
  overview(anchor: 'overview', navLabel: 'Overview'),
  engineering(anchor: 'engineering', navLabel: 'Engineering'),
  nutrilens(anchor: 'nutrilens', navLabel: 'NutriLens AI'),
  setpoint(anchor: 'setpoint', navLabel: 'SetPoint');

  const PortfolioSectionId({required this.anchor, required this.navLabel});
  final String anchor;
  final String navLabel;
}
```

#### `ProfileData` (`profile_data.dart`)
`@immutable` class with `const` constructor:
- `String fullName` (`'Tobías Gutiérrez'`)
- `String roleTitle` (`'Mobile Software Engineer'`)
- `String headlineLine1` (`'Production mobile apps,'`)
- `String headlineLine2` (`'architected end to end.'`)
- `String supportingPitch`
- `String githubUrl` (`'https://github.com/TobiShakur'`)
- `String linkedInUrl` (`'https://linkedin.com/in/tobias-gutierrez'`)
- `String email` (`'tobigutierrez26@gmail.com'`)
- `List<String> verificationMetrics` (`['Flutter & Dart 3', 'Clean Architecture', 'Cloudflare Workers', '177 Automated Tests Shipped']`)

#### `EngineeringPillar` (`engineering_pillar.dart`)
`@immutable` class with `const` constructor:
- `String id`
- `String title`
- `String description`
- `EngineeringIconKind iconKind` (`enum EngineeringIconKind { architecture, security, geospatial, verification }`) — mapped in presentation to custom `1.5px` stroke vector painters/icons.

#### `ProjectShowcase` (`project_showcase.dart`)
`@immutable` class matching every required field:
- `PortfolioSectionId id`
- `String title`
- `String subtitle`
- `String problemStatement`
- `List<EngineeringHighlight> engineeringHighlights` (each with `String title`, `String detail`)
- `List<String> techStack`
- `int testCount`
- `String testLabel` (e.g., `'153 Unit & Widget Tests'`, `'24 Unit & BLoC Tests'`)
- `String liveDemoUrl`
- `String repoUrl`
- `String logoAsset`
- `String leftScreenshotAsset` *(empty string or path; see Section 7 for asset/widget resolution)*
- `List<String> rightPreviewImages`
- `String? videoAsset`
- `Color accentColor`
- `Color deepAccentColor`

### 5.2 Data Source (`data/portfolio_catalog.dart`)
Provides `const PortfolioCatalog`:
- `static const ProfileData profile = ...`
- `static const List<EngineeringPillar> engineeringPillars = ...`
- `static const List<ProjectShowcase> projects = [nutriLens, setPoint]`

All copy comes verbatim from the verified anti-AI-slop English deck in `DESIGN_SPEC.md` Section 3.1 and URLs from `PORTFOLIO_PROMPT.md`:
- NutriLens AI Live Demo: `https://tobishakur.github.io/nutrilens-ai-tracker/`
- NutriLens AI Repo: `https://github.com/TobiShakur/nutrilens-ai-tracker`
- SetPoint Live Demo: `https://tobishakur.github.io/flutter-tennis-matchmaking/`
- SetPoint Repo: `https://github.com/TobiShakur/flutter-tennis-matchmaking`

---

## 6. Presentation Controller & Interaction Logic

### `PortfolioNavigationController` (`ChangeNotifier`)

#### Dependencies (Constructor Injected)
- `required ExternalLinkLauncher linkLauncher`
- `required ClipboardService clipboardService`
- `ScrollController? scrollController` (creates internal `ScrollController` if omitted, disposes only if owned or always disposes if owned)

#### Reactive State (Read-only getters)
- `PortfolioSectionId get activeSection` (default: `PortfolioSectionId.overview`)
- `PortfolioSectionId? get hoveredSidebarSection` (default: `null`)
- `CopyEmailState get copyEmailState` (`sealed class CopyEmailState { CopyEmailIdle, CopyEmailCopied, CopyEmailError }`)
- `String? get toastMessage` (non-null while transient fallback/error toast is visible)
- `ScrollController get scrollController`

#### Scroll Synchronization Strategy
1. **Desktop (`>= 960px`):**
   - Each of the 4 sections has exact height `viewportHeight` (`MediaQuery.sizeOf(context).height`, clamped safely to a reasonable minimum like `680px` only if window height is abnormally short so content never clips vertically—if `viewportHeight >= 680`, exact `viewportHeight` `100vh`). Let's expose `effectiveSectionHeight(double viewportHeight) => viewportHeight >= 680 ? viewportHeight : 680`!
   - On scroll notification / listener:
     - `final index = ((scrollController.offset + sectionHeight * 0.45) / sectionHeight).floor().clamp(0, PortfolioSectionId.values.length - 1);`
     - Updates `_activeSection` and calls `notifyListeners()` **only if changed**.
   - `Future<void> scrollToSection(PortfolioSectionId section, {required bool reduceMotion})`:
     - Immediately updates `_activeSection = section` (or lets smooth scroll settle cleanly without flicker using an `_isProgrammaticScroll` flag while `animateTo` runs).
     - Calls `scrollController.animateTo(section.index * _sectionHeight, duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 650), curve: Curves.easeInOutCubic)`.
2. **Tablet / Mobile (`< 960px`):**
   - Sections use fluid intrinsic height (`minHeight` + `64px` vertical padding) and each section root attaches a `GlobalKey` passed via `sectionKeys[section]`.
   - `scrollToSection` computes target offset using `Scrollable.ensureVisible(ctx, duration: ..., curve: Curves.easeInOutCubic, alignment: 0.0)` when mounted.
   - Scroll listener compares each section key's `RenderBox.localToGlobal(Offset.zero).dy` against `viewportHeight * 0.35` to pick the active section cleanly.

#### Action Methods
1. `Future<void> copyEmail(String email)`:
   - Calls `_clipboardService.copyText(email)`.
   - On `ClipboardSuccess`: sets `_copyEmailState = const CopyEmailCopied()`, notifies listeners, starts `Timer(const Duration(milliseconds: 2200), ...)` resetting to `CopyEmailIdle` (cancels any prior timer first).
   - On `ClipboardFailure`: sets `_copyEmailState = const CopyEmailError()`, triggers transient toast `'Could not copy email'`.
2. `Future<void> openExternalUrl(String url)`:
   - Calls `_linkLauncher.openExternal(url)`.
   - Exhaustive `switch`:
     - `LinkLaunchSuccess()`: no toast.
     - `LinkLaunchFailure()` or `LinkLaunchRejected()`: attempts `_clipboardService.copyText(url)` ONLY if `UrlValidator.parseAllowedUri(url) != null`, then shows transient toast (`'Could not open link — URL copied to clipboard'` or `'Blocked invalid external URL'`), auto-dismissed after `3s` via timer.
3. `dispose()`:
   - Cancels `_copyResetTimer` and `_toastTimer`, removes listener and disposes `_scrollController` (if owned).

---

## 7. Presentation Widgets & Real Asset Strategy

### 7.1 Real Asset Migration Checklist for `@coder`
Copy verified existing assets into `proyectos/portfolio/assets/`:
1. `proyectos/nutrilens_provider/web/icons/Icon-512.png` → `assets/icons/nutrilens_icon.png`
2. `tenis_app/web/icons/Icon-512.png` → `assets/icons/setpoint_icon.png`
3. `proyectos/nutrilens_provider/assets/images/sample_meal.jpg` → `assets/images/nutrilens_sample_meal.jpg`
4. `capturas_tenis_app/mapa_zoom.png` → `assets/images/setpoint_map_zoom.png`
5. `capturas_tenis_app/feed_screen.png` → `assets/images/setpoint_feed.png`
6. `capturas_tenis_app/partido_detalle_unido_doubles.png` → `assets/images/setpoint_match_doubles.png`
7. `capturas_tenis_app/filtros_bottom_sheet.png` → `assets/images/setpoint_filters.png`

### 7.2 Mockup Rendering Strategy (Zero Empty Placeholders)
- **SetPoint (`#setpoint`):**
  - **Left Tilted iPhone (`TiltedLeftPhoneMockup`):** Renders `assets/images/setpoint_map_zoom.png` (`BoxFit.cover` inside clipped `9:19.5` bezel).
  - **Right Interactive iPhone (`InteractiveRightPhoneMockup`):** Checks for optional `assets/videos/setpoint_demo.mp4` on Web; when absent or in VM tests, automatically cycles real PNG screenshots (`setpoint_feed.png`, `setpoint_map_zoom.png`, `setpoint_match_doubles.png`, `setpoint_filters.png`) with `1.4s` crossfade (`4s` hold, paused when `MediaQuery.disableAnimationsOf(context)` is true).
- **NutriLens AI (`#nutrilens`):**
  - Since `capturas_tenis_app/` exists for SetPoint while `nutrilens_provider` currently only has `sample_meal.jpg` and `Icon-512.png` on disk (no static PNG app screenshots yet), `@coder` **MUST NOT** render grey boxes or fake "Screenshot coming soon" text!
  - Instead, implement `NutriLensPreviewScreens` (`nutrilens_preview_screens.dart`) — 3 crisp, pixel-accurate Flutter mini-screens built using the real `assets/icons/nutrilens_icon.png` + `assets/images/nutrilens_sample_meal.jpg` and NutriLens AI's real brand palette (`#080A0C`, `#0C4E36`, `#D2F07A`):
    1. **Left Tilted Screen (`NutriLensHomeRingScreen`):** Daily Calorie/Macro Ring (`1,840 / 2,200 kcal`, Protein/Carbs/Fats bars, Pantry badge) in NutriLens Pistachio `#D2F07A`.
    2. **Right Storyboard Frame 1 (`NutriLensMealScanScreen`):** Displays `nutrilens_sample_meal.jpg` with Gemini Vision detected ingredient pills (`Grilled Chicken`, `Quinoa`, `Avocado`, `Pantry Match ✓`) and `AI Health Score: 88/100`.
    3. **Right Storyboard Frame 2 (`NutriLensPantryScanScreen`):** Barcode & Nutrition Label 3-mode scanner sheet (`Open Food Facts v2 → Gemini Fallback`).
  - Once `nutrilens_demo.mp4` or PNG screenshots are added later, `InteractiveRightPhoneMockup` seamlessly picks them up via `videoAsset` / `rightPreviewImages`.

### 7.3 Navigation Components (`widgets/navigation/`)
- **`FloatingPillSidebar` (`>= 960px`):**
  - Positioned via `Align(alignment: Alignment.centerLeft)` with `Padding(padding: EdgeInsets.only(left: isWide ? 24 : 16))`.
  - Container uses `Column(mainAxisSize: MainAxisSize.min)` — **strictly intrinsic height** (`10px` top padding + `4 * 44px` items + `3 * 10px` gaps + `10px` bottom padding = **`226px`**) and `width: 64px`.
  - Decoration: `color: AppColors.sidebarBg` (`#050608`), `border: Border.all(color: AppColors.sidebarBorder, width: 1.75)`, `borderRadius: BorderRadius.circular(999)`, `boxShadow: [BoxShadow(color: AppColors.sidebarShadow, blurRadius: 24, offset: Offset(0, 12))]`.
  - Items:
    1. `overview`: Minimal monogram/vector glyph (`TG` or precision crosshair icon) — accent `#34D399`.
    2. `engineering`: Clean 4-node architecture/layers vector glyph — accent `#34D399`.
    3. `nutrilens`: `ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/icons/nutrilens_icon.png', width: 40, height: 40))` inside `44x44px` hit target — accent `#D2F07A`.
    4. `setpoint`: `ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/icons/setpoint_icon.png', width: 40, height: 40))` inside `44x44px` hit target — accent `#C8E652`.
  - Hover/Active: `AnimatedContainer` (`200ms`, `Curves.easeOutCubic`) applies `accent.withValues(alpha: 0.16)` fill, `1.5px` border `accent.withValues(alpha: 0.65)`, and `BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 14)`. Hover reveals floating label pill immediately to the right (`150ms` fade + `6px` slide) wrapped in `IgnorePointer` / `ExcludeSemantics` as appropriate so it never causes layout shift.
- **`MobileBottomPillDock` (`< 960px`):**
  - `Align(alignment: Alignment.bottomCenter)` inside `SafeArea(minimum: EdgeInsets.only(bottom: 16))` with `Row(mainAxisSize: MainAxisSize.min)` using the exact `#050608` fill + `1.75px` `#303642` border + `borderRadius: 999`.

### 7.4 Mockup Components (`widgets/mockups/`)
- **`TiltedLeftPhoneMockup`:**
  - Wrapped in `RepaintBoundary` + `MouseRegion` (hover gently settles tilt from `rotateY(0.24)` to `rotateY(0.14)` over `260ms`, `Curves.easeOutCubic`, disabled when `MediaQuery.disableAnimationsOf(context)` is true).
  - Transform: `Matrix4.identity()..setEntry(3, 2, 0.0012)..rotateY(tiltY)..rotateX(-0.04)`, `alignment: Alignment.center`.
- **`InteractiveRightPhoneMockup`:**
  - Wraps screen content in `FocusableActionDetector` + `MouseRegion(cursor: SystemMouseCursors.click)` + `GestureDetector(onTap: onOpenLiveDemo)`.
  - Supports **both** mouse hover (`_isHovered`) and keyboard focus (`_isFocused`) to trigger the blur overlay (`_showOverlay = _isHovered || _isFocused`).
  - **Blur & CTA Overlay (220ms `Curves.easeOutCubic`):**
    - Flutter content path: `ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: showOverlay ? 8 : 0, sigmaY: showOverlay ? 8 : 0))` (using `TweenAnimationBuilder<double>` `0 -> 8` so it animates smoothly without shader pops, skipping `ImageFilter.blur` at `sigma == 0`!).
    - Web `<video>` path: passes `isBlurred: showOverlay` into `PreviewMediaPlayer` so `preview_media_player_web.dart` also toggles CSS `style.filter = 'blur(8px)'` directly on the `<video>` element (ensuring crisp blur even over `HtmlElementView` on CanvasKit!).
    - Dark scrim: `AnimatedOpacity` (`0.0 -> 1.0`) over `ColoredBox(color: AppColors.scrimHover)`.
    - Centered CTA pill: `height: 48`, `padding: EdgeInsets.symmetric(horizontal: 22)`, `borderRadius: 999`, background `project.accentColor` (`#D2F07A` / `#C8E652`), text `'Try Live Interactive App ↗'` in `AppColors.ctaInkOnAccent` (`#080A0C`), `AnimatedScale(scale: showOverlay ? 1.0 : 0.94)`.
    - On `< 960px` (touch devices with no hover): displays the live preview cleanly with a **persistent** high-contrast `'Try Live Interactive App ↗'` pill button directly below (or docked at bottom of) the phone so touch users never rely on hover.

### 7.5 Web Hardening (`web/index.html`)
Follow `@secops` #8 verbatim:
- `<html lang="en">`
- `<base href="$FLUTTER_BASE_HREF">`
- `<meta name="referrer" content="strict-origin-when-cross-origin">`
- `<meta http-equiv="X-Content-Type-Options" content="nosniff">`
- `<meta name="theme-color" content="#080A0C">`
- `<title>Tobías Gutiérrez — Mobile Software Engineer</title>`
- `<meta name="description" content="Tobías Gutiérrez — Mobile Software Engineer. Production Flutter, iOS, and Android applications with Clean Architecture, serverless AI pipelines, and automated test suites.">`
- Zero inline custom JS, zero `eval`, zero mentions of FIUBA/student.

---

## 8. Mandatory Verification & Test Plan (`test/`)

`@coder` must write and pass all tests below (`0` skipped, `0` `flutter analyze` warnings):

### 8.1 Unit Tests
1. **`url_validator_test.dart`:**
   - Accepts official `https://github.com/TobiShakur`, `https://linkedin.com/in/tobias-gutierrez`, `https://tobishakur.github.io/nutrilens-ai-tracker/`, `https://tobishakur.github.io/flutter-tennis-matchmaking/`, and `mailto:tobigutierrez26@gmail.com`.
   - Rejects `http://`, `javascript:alert(1)`, `data:text/html,...`, `file:///etc/passwd`, untrusted hosts (`https://evil.com`), malformed strings, and non-matching `mailto:other@example.com`.
2. **`portfolio_catalog_test.dart`:**
   - Asserts `profile` and all `projects` contain **zero** forbidden words (`FIUBA`, `student`, `universidad`, `university`, AI-slop filler words).
   - Verifies exact URLs from `PORTFOLIO_PROMPT.md` and verified test counts (`153` for NutriLens AI, `24` for SetPoint).
3. **`portfolio_navigation_controller_test.dart`:**
   - Verifies `activeSection` updates accurately when `ScrollController` scrolls across `0`, `1 * vh`, `2 * vh`, `3 * vh`.
   - Verifies `scrollToSection` animates/jumps to exact `index * vh`.
   - Verifies `copyEmail` sets `CopyEmailCopied` and resets back to `CopyEmailIdle` after `2.2s` (using `fake_async` / `WidgetTester` clock or pump).
   - Verifies `openExternalUrl` triggers `FakeExternalLinkLauncher`, and on failure copies URL via `FakeClipboardService` and sets fallback toast without exposing raw exceptions.

### 8.2 Widget Tests
1. **`floating_pill_sidebar_test.dart`:**
   - Verifies `FloatingPillSidebar` wraps items in `Column(mainAxisSize: MainAxisSize.min)` and renders `height <= 240` (intrinsic `~226px`, never stretched to full `900px` viewport height).
   - Verifies all 4 navigation items (`Overview`, `Engineering`, `NutriLens AI`, `SetPoint`) exist with `>= 44x44` hit targets and real `Image.asset` icons for NutriLens AI & SetPoint.
   - Verifies hover reveals floating label tooltip and tap triggers callback for each section.
2. **`interactive_right_phone_mockup_test.dart`:**
   - Verifies hover (`TestGesture` `PointerDeviceKind.mouse` `moveTo`) over the right iPhone reveals `"Try Live Interactive App ↗"` and tapping invokes `onOpenLiveDemo` with exact URL (`https://tobishakur.github.io/nutrilens-ai-tracker/` for NutriLens AI, `https://tobishakur.github.io/flutter-tennis-matchmaking/` for SetPoint).
   - Verifies keyboard focus also reveals the CTA without requiring mouse hover.
3. **`portfolio_page_test.dart`:**
   - Pumps `PortfolioApp` with `FakeExternalLinkLauncher` and `FakeClipboardService` at `1440x900` (Wide Desktop), `1024x768` (Compact Desktop), and `390x844` (Mobile) with **zero RenderFlex overflow errors**.
   - Verifies all 4 sections render (`Overview`, `Engineering Approach`, `NutriLens AI`, `SetPoint`).
   - Verifies clicking each sidebar item updates `activeSection` and scrolls `ScrollController` to that section's offset.
   - Verifies clicking the Copy Email button invokes `FakeClipboardService` with `'tobigutierrez26@gmail.com'` and renders `'Copied ✓'` feedback.
   - Verifies clicking GitHub/LinkedIn/Repo buttons passes exact URLs to `FakeExternalLinkLauncher`.

### 8.3 CLI Acceptance Gates (Mandatory before reporting to `@secops` & `@coordinator`)
1. `flutter analyze` → **0 issues**
2. `flutter test` → **100% pass**
3. `flutter build web --release --base-href "/portfolio/"` → **Exit code 0**
