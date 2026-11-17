# Plan `unslop` sobre `r10` — Portfolio Web Tobías Gutiérrez

> **Auditoría sobre build live `r10`:** `https://tobias-portfolio-web.web.app/` (`1440×900` + `390×844`, `0` excepciones de consola)  
> **Metodología:** `unslop` (`SKILL.md`, `references/signs.md`, `references/tokens.md`, `references/visuals.md`, `references/refs.md`) — *unslop by Damir Sokolovsky (`@heydamir`), CC BY 4.0*  
> **Alcance:** Solo auditoría y plan de pulido. No se modificó código `.dart` ni `DESIGN_SPEC.md`.

---

## 1. Lo Que NO Se Toca (Decisiones Fijadas por Tobías en `r10`)

Todas las pasadas respetan estrictamente las 4 decisiones estructurales consolidadas en `r10`:
1. **Hero (`#overview`):** Tarjeta derecha con switcher (`NutriLens AI`, `SetPoint`, `MatchUp`) mostrando las **3 capturas chicas horizontales redondeadas**.
2. **Proyectos (`#nutrilens` y `#setpoint`):** Líneas divisorias arriba y abajo + **2 filas horizontales moviéndose suave de fondo** (`HorizontalFilmstripBackdrop`) + **celular único al frente** con `< x / 4 >` rápido (`2.2s`).
3. **Capabilities (`#capabilities`):** Fondo oscuro limpio sin glow verde difuminado + **botones de logos de plataformas solo con borde**.
4. **Sin flechas en las últimas 2 secciones:** `WideSectionChevron` presente solo en `#overview`, `#nutrilens` y `#setpoint` (ausente en `#capabilities` y `#contact`).

---

## 2. Audit (`signs.md`) — Señales de Slop Presentes en `r10`

Diagnóstico honesto de `r10`: **Slop medio-bajo ("Polish / Refinement mode")** — la estructura ya tiene sentido, pero el cromo brilla demasiado, la tipografía pesa `700` en todos los títulos, quedan glows radiales y rótulos en mayúsculas heredados, y hay **1 colisión visual real** arriba a la derecha en `#nutrilens` / `#setpoint`.

### Surfaces & Color
- **Mancha radial verde detrás del Hero y Showcases** (`portfolio_page.dart#L305-L331`, visible en `r10_1440_sec0_overview.png` y `r10_390_01_overview.png`): `_AmbientCanvasGlow` sigue proyectando `RadialGradient` verde/turquesa (`alpha: 0.08`) sobre `#overview`, `#nutrilens` y `#setpoint`.
- **Halos de color (`boxShadow`) alrededor de dispositivos y navegación:**
  - `iphone_bezel_frame.dart#L44-L50` + `interactive_right_phone_mockup.dart#L115` (`showAmbientGlow: true`): proyecta halo verde/lima (`blurRadius: 54.0`, `alpha: 0.12`).
  - `sidebar_nav_item.dart#L99-L122` (`r10_1440_sec0_overview.png`, `sec1`, `sec2`): ítem activo de la píldora izquierda brilla con fondo acento `16%`, borde saturado `65%` y `BoxShadow(blurRadius: 14, alpha: 0.25)`.
- **Cromo gritón compitiendo con el contenido (`concept_switcher_menu.dart#L218-L223`, `mobile_top_app_bar.dart#L226-L242`):** En `r10_1440_sec0_overview.png` arriba a la derecha y en `r10_390_01_overview.png`, el botón seleccionado **`[ A · Wall ]`** usa relleno sólido brillante `accentEngineering` (`#34D399`), robando atención al Hero H1 y a las capturas de NutriLens.
- **Rampa neutra sin tinte unificado + hexes sueltos:** `app_colors.dart` mezcla `#080A0C` / `#101318` / `#171C23` / `#303642` / `#262D38` / `#1E242E` con hexes hardcodeados en widgets (`0xFF0B0E12` en `overview_hero_section.dart#L1303` y `capabilities_section.dart#L209`; `0xFF2B323D`, `0xFF525D6E`, `0xFFE2E8F0` en `capabilities_section.dart#L370, L393`).
- **Botones de logos con 10 colores saturados (`capabilities_section.dart#L387` en `r10_1440_sec3_capabilities.png`):** Los 10 botones de `CORE PLATFORMS & TOOLING` mezclan 10 colores distintos en fila (cian, naranja, amarillo, verde neón, blanco, azul), fragmentando la lectura sobre `#capabilities`.

### Type
- **Encabezados pesados (`FontWeight.w700` en todos los títulos):** `app_text_styles.dart#L15, L27, L39` (`heroDisplay`, `sectionHeading`, `projectTitle`) y `#L83/L243/L283` usan `w700`. Con `letterSpacing: size * -0.035` (`-1.96px` en `56px`), `Production Flutter apps` se ve comprimido y pesadote (`unslop` exige `400–500` para títulos, `600` solo como máximo énfasis puntual). *(Nota: `pubspec.yaml` actualmente incluye `Plus Jakarta Sans` solo en `600/700`, mientras `Inter` tiene `400/500/600/700`)*.
- **Etiquetas en MAYÚSCULAS con tracking ancho (`r10_1440_sec1/2/3`):**
  - `project_showcase_section.dart#L766-L776` (`portfolio_catalog.dart#L139-L140, L191-L192`): `01 · NUTRILENS AI` · `MOBILE VISION & SERVERLESS EDGE` (en `r10_1440_sec1_nutrilens.png` y `sec2_setpoint.png`).
  - `portfolio_catalog.dart#L86`: `CLIENT PRODUCTION DELIVERY · APPLE APP STORE (5.0★)` (`r10_1440_sec3_capabilities.png`).
  - `capabilities_section.dart#L100-L105`: `CORE PLATFORMS & TOOLING` con `letterSpacing: 1.2` (`r10_1440_sec3_capabilities.png`).
  - Concepto B (`project_showcase_section.dart#L836, L853, L952, L980`, `overview_hero_section.dart#L273, L283, L760`): `THE GAP`, `ARCHITECTURE`, `SELECT SHIPPED PROOF`, `153 TESTS`.
- **Tracking negativo en texto chico:** `app_text_styles.dart#L103` (`buttonLabel` `14px` tiene `letterSpacing: -0.1`) y `sidebar_nav_item.dart#L220` (`'TG'` `13px` tiene `letterSpacing: -0.4`).

### Icons & Decorative Glyphs
- **Glifos Unicode / estrella / flechas mezclados en texto UI:** `5.0★`, `Explore Work ↓`, `Jump ↓`, `Open Live Demo ↗`, `View Source on GitHub ↗`, `Launch Live Demo ↗`, `Back to top ↑` y `• ` literal en `project_showcase_section.dart#L654` / `#L1038` en lugar de íconos vectoriales uniformes (`16px`, stroke `1.5`, color de rol de texto).
- **Puntos decorativos de estado:** En `sidebar_nav_item.dart#L170-L176` (`• Overview` en `r10_1440_overview_tab.png`) y `mobile_top_app_bar.dart#L307-L316` (`• Overview ▾` en `r10_390_01_overview.png`), un círculo verde de `6px` acompaña a texto que no es un monitor en vivo.

### Spacing
- **Valores fuera de grilla `4px`:**
  - `overview_hero_section.dart`: paddings/gaps `58.0`, `72.0`, `14.0`, `18.0`, `10.0`, `11.0`, `6.0`, `22.0`, `36.0`, `26.0`.
  - `capabilities_section.dart`: `borderWidth: 1.15`, paddings `9.0`, `14.0`, `11.0`, `18.0`, `22.0`, `fontSize: 13.5 / 15.5 / 16.5 / 18.5`.
  - `project_showcase_section.dart`: `top: 6.0`, `bottom: 10.0`, `SizedBox(height: 14.0)`.

### Copy
- **Puntos finales en titulares, subtítulos y líneas cortas (`signs.md`):**
  - Hero H1: `'with backend & AI built in.'` (Concepts A/B/C terminan los 3 H1 con punto final, `portfolio_catalog.dart#L71, L75, L79`).
  - `capabilitiesSectionSubtitle`: termina en punto (`portfolio_catalog.dart#L13`), aunque sea 1 sola frase corta.
  - `closingSubcopy` (`#L18`) y subheads/filas cortas.
- **Dato duplicado dentro del mismo banner (`capabilities_section.dart` en `r10_1440_sec3_capabilities.png`):** `APPLE APP STORE (5.0★)` aparece arriba a la izquierda y otra vez `App Store 5.0★` a la derecha en la misma caja de `MatchUp`.
- **Exceso de verbosidad en bullets de proyectos (`r10_1440_sec1/2`):** En cada proyecto coexisten icono + título + subtítulo + problema + 3 párrafos largos con viñeta + metadata line + 2 botones + barra superior `01 · NUTRILENS AI`.

### Components, Layout & Visuals
1. **BUG VISUAL LIVE — Colisión detrás del switcher arriba a la derecha (`r10_1440_sec1_nutrilens.png` y `sec2_setpoint.png`):**
   - En `#nutrilens` y `#setpoint`, el botón `|| Pause bg` de `_EditorialTopTagStrip` (`project_showcase_section.dart#L785-L790`) queda **tapado/encimado directamente por detrás de `ConceptSwitcherMenu`** en la esquina superior derecha. Además duplica el botón de pausa `[ ⏸ ]` que ya está debajo del celular.
2. **Fila de CTAs del Hero se rompe `3 + 1` en desktop (`r10_1440_sec0_overview.png`):**
   - Hay 4 cajas/botones en la misma fila (`Explore Work ↓`, `tobigutierrez26@gmail.com | Copy`, `GitHub ↗`, `LinkedIn ↗`), provocando que **`LinkedIn ↗` quede huérfano solo en la segunda línea**.
3. **Hero `A` mezcla fondo diagonal residual detrás del switcher (`r10_1440_sec0_overview.png` y `r10_390_01_overview.png`):**
   - `overview_hero_section.dart#L146-L154` todavía dibuja `DiagonalScreenWallBackdrop` atrás de `#overview`, generando capturas inclinadas borrosas cortadas justo debajo de `ConceptSwitcherMenu` mientras la mitad izquierda es plana. Como el Hero ya tiene las **3 capturas reales nítidas en el switcher derecho**, el muro diagonal atrás compite como ruido visual.
4. **Tabs del Hero Switcher se rompen `2 + 1` en mobile (`r10_390_01_overview.png`, `r10_390_04_scroll.png`):**
   - `Wrap` en `_HeroAppDeckSwitcher` (`overview_hero_section.dart#L669-L692`) parte `MatchUp 5.0★` a una segunda línea y las capturas de `180px` quedan con banda vacía debajo.
5. **Botón redundante `Jump ↓` en la tarjeta Hero (`overview_hero_section.dart#L721-L727`):**
   - La tarjeta derecha tiene dos botones cuando `Open live demo` basta (y tocar la sección o scrollear ya baja al caso).
6. **Blur overlay accidental en scroll táctil mobile (`r10_390_07_scroll.png`):**
   - `MouseRegion` sobre `InteractiveRightPhoneMockup` dispara el estado blur `"Launch Live Demo"` al scrollear/tocar en mobile (`< 600px`), tapando la pantalla de la app cuando el botón sólido `Open Live Demo` ya está visible debajo.

---

## 3. Direction (`unslop` — 5 Líneas Obligatorias)

- **Product.** Portfolio and direct-hiring showcase for Tobías Gutiérrez, a solo mobile software engineer shipping Flutter iOS/Android apps, Firebase backends, edge AI proxies, and App Store releases.
- **Character.** Measured, structural, quietly confident (`technical, exact, unhurried` — engineered rather than decorated).
- **World.** Mobile hardware workbench at night: dark anodized aluminum (`Ink` obsidian ramp), precision drafting hairlines (`8%`), and real phone displays carrying the only light and color in the frame.
- **Moments.** Three live UI stages carry all visual color and richness: the 3-screen horizontal showcase deck inside the Hero switcher, and the two live cycling phone stages (`NutriLens AI`, `SetPoint`) anchored over subdued horizontal filmstrips.
- **Signature.** Continuous `1px` top-and-bottom drafting rules enclosing each project plate paired with a single `56×12px` wide hairline chevron below `#overview`, `#nutrilens`, and `#setpoint`.

---

## 4. Plan Exacto en 9 Pasadas (Listo para `@coder`)

> **Orden estricto (`unslop`):** Spacing → Color → Icons → Copy → Type → Layout → Details → Visuals → Motion.

### Pasada 1 — `Spacing` (Grilla estricta de `4px`)
- En `app_spacing.dart`, `overview_hero_section.dart`, `project_showcase_section.dart`, `capabilities_section.dart`, `closing_contact_section.dart` y `concept_switcher_menu.dart`: eliminar todo valor impar o fuera de grilla (`6`, `9`, `10`, `11`, `14`, `18`, `22`, `26`, `36`, `58`, `72`, `1.15px`) y alinear a la escala **`4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96, 128`**:
  - Hero padding top/bottom desktop: `64.0` / `16.0` (compact `<780px`: `48.0` / `8.0`); mobile: `24.0` / `24.0`.
  - Gaps dentro de grupos (ej. título -> subtítulo, barra -> lista): `8.0` o `12.0`. Entre bloques (ej. pitch -> CTAs -> ledger): `20.0` o `24.0`.
  - Cards y botones: paddings múltiplos de `4` (`horizontal: 12` o `16`, `vertical: 8` o `12`; switcher card `padding: 20.0`; banner MatchUp `padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0)`).
  - Borde hairline estándar en toda la app: **`1.0`** (nunca `1.15`, `0.75` ni `1.75` en sidebar; sidebar border `1.0` sólido).
  - Anchos de caja en listas (`Capabilities` `01..04`, `Project` bullets): misma altura/padding vertical (`12.0`) y columna fija para los índices (`width: 28.0` para `'01'..'04'`) así todos los títulos empiezan en el mismo eje X exacto.

### Pasada 2 — `Color` (Rampa única `Ink` + Quiet Chrome)
Reemplazar tokens actuales en `app_colors.dart` y eliminar hexes inline en widgets:
- **Rampa neutra `Ink` (tinte frío sutil de hardware nocturno):**
  - `sidebarBg` / deepest: **`#07080D`**
  - `bgCanvas`: **`#0B0D14`** *(o mantener `#080A0C` si se busca negro más profundo — lo clave es usar UNA sola rampa consistente: `#07080D` -> `#0B0D14` -> `#11141C` -> `#1A1E28`!)*
  - `bgSurface` (cards, switcher, banner MatchUp): **`#11141C`**
  - `bgSurfaceElevated` (hover row, tab activa, secondary active): **`#1A1E28`**
  - `textPrimary`: **`#EEF0F5`**
  - `textSecondary`: **`#A3A9B8`**
  - `textMuted`: **`#7A8296`**
  - `borderHairline`: **`Color(0x14EEF0F5)`** (`8%` primary ink)
  - `borderFocus`: **`Color(0x2EEEF0F5)`** (`18%` primary ink)
  - `swissGridBorder` / `swissCellBorder`: **`Color(0x24EEF0F5)`** / **`Color(0x14EEF0F5)`**
- **Acentos quirúrgicos (uno por rol, cero saturación en el cromo):**
  - `accentEngineering` (semantic / verified `5.0` badge / keyboard focus ring): **`#4CC38A`** (de `tokens.md`, sobrio dentro de `Ink`).
  - `accentNutriLens`: **`#D2F07A`** (exclusivo botón primario y acento de NutriLens).
  - `accentSetPoint`: **`#C8E652`** (exclusivo botón primario y acento de SetPoint).
  - **Botón primario del Hero y `#contact`:** `#EEF0F5` sólido con tinta `#07080D` (`off-white on ink`).
- **Eliminación total de glows y manchas radiales:**
  - Borrar `_AmbientCanvasGlow` en `portfolio_page.dart` (`Scaffold.backgroundColor: AppColors.bgCanvas` sólido en las 5 secciones, `0` gradientes radiales).
  - `IphoneBezelFrame`: `showAmbientGlow: false` (solo sombra neutra `Color(0x73000000)` `blurRadius: 28`, `offset: Offset(0, 14)`).
  - `SidebarNavItem` & `ConceptSwitcherMenu` & `MobileTopAppBar`: el estado **activo** usa **`bgSurfaceElevated` (`#1A1E28`) + borde `1px` `borderFocus` + texto `#EEF0F5`** (**nunca** relleno verde menta brillante en `A · Wall` ni halo verde `blurRadius: 14` en la sidebar!).
  - **`Capabilities` 10 botones de plataforma:** borde `1.0px` `borderFocus` (`#242938`), fondo `Colors.transparent`, íconos en **monocromo `textSecondary` (`#A3A9B8`) -> `textPrimary` (`#EEF0F5`) en hover** (usando `ColorFilter.mode(iconColor, BlendMode.srcIn)` sobre `TechBrandIcon` — cero arcoíris de 10 colores!).

### Pasada 3 — `Icons` (Cero glifos decorativos · Stroke uniforme `1.5`)
- **Sacar Unicode `★`, `↓`, `↑`, `↗` y `'• '` de los strings de UI** donde van en botones/links/headers:
  - Reemplazar por íconos `Icons.*` / vectoriales uniformes de **`16.0px`** (stroke `1.5` o rounded/outlined clean) en el color del texto (`ctaInkOnAccent`, `textPrimary` o `textSecondary`) con gap fijo **`8.0px`**:
    - `Open Live Demo` + `Icons.north_east_rounded` (`16px`)
    - `View Source on GitHub` + `Icons.north_east_rounded` (`15px`) o link plano
    - `Explore Work` + `Icons.arrow_downward_rounded` (`16px`)
    - `MatchUp` rating: texto limpio `5.0 on App Store` (o `Icons.star_border_rounded` `14px` en `#4CC38A` — sin emoji `★`).
    - Bullets de proyectos (`project_showcase_section.dart#L654, L1038`): quitar `'• '` ASCII; usar padding izquierdo o separador limpio (`12px` gap vertical, título `#EEF0F5` + detalle `#A3A9B8`).
  - **Sacar el punto verde decorativo de `6px`** del tooltip de `SidebarNavItem` (`#L170-L176`) y de `_MobileSectionMenuTrigger` (`#L307-L316`).

### Pasada 4 — `Copy` (Corto, sin puntos en titulares, cero repetición)
- **Quitar puntos finales en headlines, subheads y filas cortas (`signs.md`):**
  - Hero A H1: `'Production Flutter apps,\nwith backend & AI built in'` (sin punto)
  - Hero B H1: `'Flutter systems\nshipped end to end'` (sin punto)
  - Hero C H1: `'Flutter & cloud apps,\nshipped to real users'` (sin punto)
  - Capabilities subtitle: `'Full product ownership from architecture to store release'` (corto, sin punto, sin guión redundante).
  - Contact heading: `'Need a mobile engineer who owns the whole stack?'` (OK) · subcopy: `'Available for Upwork MVPs, Figma-to-Flutter builds, and remote teams (GMT-3, EN / ES)'` (sin punto).
- **Eliminar redundancia en banner `MatchUp` (`capabilities`):**
  - Izquierda etiqueta: `'Client production · Apple App Store'` (sentence case!)
  - Derecha specs: `'iOS (5.0 rated) · Android'` / `'Flutter · Provider · Firebase · Google Maps · AdMob'` (no repite `App Store 5.0` dos veces!).
- **Limpiar metadatos y texto de proyectos (`NutriLens AI`, `SetPoint`):**
  - Convertir tags de sección en **sentence case**: `'01 · NutriLens AI — Mobile vision & edge API'` y `'02 · SetPoint — Geolocation & BLoC architecture'`.
  - Acortar 15–20% las descripciones de los 3 puntos técnicos de cada proyecto para lectura instantánea en 2 líneas máx. cada uno (manteniendo `Open Food Facts v2`, `16 MB`, `30 req/min`, `153 tests`, `24 tests` intactos).
  - En Hover overlay del celular (`InteractiveRightPhoneMockup`): `'Open live demo'` (sentence case, sin `↗` dentro del pill si lleva ícono limpio `15px`).

### Pasada 5 — `Type` (Pesos `400/500`, cero uppercase tracked, escalas claras)
- **Eliminar `FontWeight.w700` de todos los headings y botones (`tokens.md`):**
  - Bajar `Plus Jakarta Sans` de `w700` a **`w500` (Medium)** — requiere sumar `PlusJakartaSans-Medium.ttf` en `assets/fonts/` + `pubspec.yaml` (o usar `Inter` `FontWeight.w500` para display/headings mientras no se agregue `.ttf`; **recomendado: bundled `PlusJakartaSans-Medium.ttf` (`w500`) + `JetBrainsMono-Regular.ttf` (`w400`, `12–13px`) para cifras/coordenadas tabulares**).
  - Pesos finales permitidos en toda la app: **`400` (body/secondary)** y **`500` (headings/titles/buttons/labels)**; `w600` solo si hace falta contraste mínimo en CTA pequeño. Cero `w700–w900`.
- **Escala tipográfica exacta (`app_text_styles.dart`):**
  - `heroDisplay`: `56.0` desktop (`48.0` compact `<780`, `36.0` mobile), `height: 1.06`, `letterSpacing: -0.025 * size` (`-1.4px`), `w500`.
  - `sectionHeading`: `32.0` desktop (`28.0` mobile), `height: 1.15`, `letterSpacing: -0.02 * size`, `w500`.
  - `projectTitle`: `30.0` desktop (`26.0` mobile), `height: 1.15`, `letterSpacing: -0.02 * size`, `w500`.
  - `bodyLead`: `18.0` desktop (`16.0` mobile), `height: 1.55`, `letterSpacing: 0.0`, `w400`.
  - `bodyDefault`: `15.0`, `height: 1.55`, `letterSpacing: 0.0`, `w400`.
  - `buttonLabel`: `14.0`, `height: 1.2`, **`letterSpacing: 0.0`** (corrigiendo `-0.1`), `w500`.
  - `labelSmall` / meta: `13.0`, `height: 1.4`, **`letterSpacing: 0.0`** (o `+0.01em` / `0.13` en muted), `w400` / `w500`, `tabularFigures` en métricas.
- **Zero all-caps tracked:** Convertir **`CORE PLATFORMS & TOOLING`**, **`CLIENT PRODUCTION DELIVERY`**, **`01 · NUTRILENS AI`**, **`THE GAP`**, **`ARCHITECTURE`**, **`SELECT SHIPPED PROOF`**, **`ENG-PORTFOLIO // BUENOS AIRES`** a **sentence case limpio** (`Core platforms & tooling`, `Client production · Apple App Store`, `01 · NutriLens AI`, etc.) con `letterSpacing: 0.0`.

### Pasada 6 — `Layout` (Hero sin botón huérfano, cero colisiones arriba-derecha)
1. **Arreglar fila de CTAs del Hero (`overview_hero_section.dart#L463-L499`, fin del botón `LinkedIn` huérfano):**
   - Dejar **1 acción primaria + 1 acción secundaria** en la fila de botones:
     - Primario (`#EEF0F5` fill, `#07080D` ink, `height: 44.0`): `Explore work` + ícono `↓` (`16px`).
     - Secundario (`#11141C` fill, `1px borderHairline`, `height: 44.0`): `_EmailCopyChip` (`tobigutierrez26@gmail.com  Copy`).
   - Mover `GitHub` y `LinkedIn` a **links textuales tranquilos (`44px` hit target sin caja ni borde de botón)** en la fila inferior integrada con las métricas:
     `App Store (5.0) · 177 automated tests · US East & EU overlap   ·   GitHub ↗   LinkedIn ↗`
   - Resultado: **2 botones alineados en 1 sola línea** tanto en `1440×900` como en `1280×720` y `390×844`!
2. **Eliminar colisión del top-right en `#nutrilens` & `#setpoint` (`r10_1440_sec1/2`):**
   - Quitar `_PauseMotionButton` de `_EditorialTopTagStrip` (que chocaba tapado detrás de `ConceptSwitcherMenu`!). El control `[ ⏸ ]` ya vive visible y accesible centrado debajo del teléfono (`[ ‹ ] 1 / 4 [ › ] [ ⏸ ]`), y controla tanto el auto-avance del celular como el fondo horizontal `HorizontalFilmstripBackdrop`.
3. **Arreglar tabs del Hero Switcher en Mobile (`r10_390_01_overview.png`):**
   - Cambiar `Wrap` por un **segmented control en `Row` única (`height: 40.0`, `3` segmentos `Expanded` con padding `4.0`)**: `NutriLens`, `SetPoint`, `MatchUp`. Entra en **1 sola fila horizontal** tanto en `390px` como en `1440px`!
   - Eliminar el botón redundante `Jump ↓` al pie de la card Hero; dejar: `meta (153 tests · Edge API)` a la izquierda + 1 botón `Open live demo` a la derecha (`Row` equilibrada en 1 línea).
4. **Centrado vertical del Hero split:** Alinear verticalmente (`CrossAxisAlignment.center`) la columna de texto izquierda contra la tarjeta derecha de `_HeroAppDeckSwitcher`, ajustando altura del preview a `252px` (`1440`) / `208px` (`1280`) / `184px` (`390`).

### Pasada 7 — `Details` (Radios anidados + estados quietos)
- **Nested Radius exacto (`tokens.md`: `inner = outer - padding`, min `4`):**
  - `_HeroAppDeckSwitcher` card exterior: `radius: 16.0`, `padding: 16.0` (mobile/compact) o `20.0` (desktop); segmented bar interior o tiles internos `radius: 10.0` / `12.0` (`20 - 8 = 12`, `16 - 4 = 12`).
  - `_ConceptSegmentButton` dentro de pill exterior `radius: 12.0`, `padding: 4.0` → tab interior **`radius: 8.0`** (`12 - 4 = 8` exacto!).
  - Botones de acción (`Explore work`, `Open live demo`, `Copy`): **`radius: 8.0`** en Concepto A (`6.0` en B, `999.0` o `10.0` en C — manteniendo coherencia dentro de cada concepto).
  - `_OutlinedPlatformButton` en `#capabilities`: **`radius: 8.0`**, `padding: horizontal 12, vertical 8` (4px grid), borde `1.0px` `Color(0x24EEF0F5)` (`hover -> Color(0x47EEF0F5)`).
- **Focus Ring WCAG 2.2 uniforme:** Borde `2.0px` sólido `accentEngineering` (`#4CC38A`) o `#EEF0F5` únicamente en `_isFocused` (`keyboard Tab`), sin `spreadRadius` borroso.

### Pasada 8 — `Visuals` (Hacer que los 3 productos brillen solos)
- **Hero limpio (`overview_hero_section.dart#L141-L159`):** Quitar `DiagonalScreenWallBackdrop` de atrás del Hero en Concepto A! Dejar el canvas `#0B0D14` (o `#080A0C`) en calma total para que las **3 capturas reales horizontales** del switcher derecho sean el único punto brillante (`One bright element`).
- **Showcase Mobile sin blur accidental (`interactive_right_phone_mockup.dart`):** En `< 600px`, desactivar el overlay de blur por hover (`enableHoverOverlay: width >= AppSpacing.tablet`), porque en móvil el botón sólido `Open Live Demo` está inmediatamente debajo y el toque/scroll en `390×844` debe dejar ver la pantalla de la app nítida (`r10_390_07_scroll.png`).
- **Capturas Hero Switcher (`_ProofPreviewFrame`):** Subir ligeramente el contraste del contenedor que envuelve las 3 miniaturas (`#07080D` + borde `1px Color(0x1AEEF0F5)`, `padding: 12.0` alrededor del trío horizontal) y asegurar `gap: 12.0` desktop / `8.0` mobile (`4px` grid!) con `borderRadius: 12.0`.

### Pasada 9 — `Motion` (Una curva `unslop`, `2.2s` en teléfono, backdrops chill intactos)
- **Estandarizar curva única (`tokens.md`):** Reemplazar `Curves.easeOutCubic` / `Curves.easeInOut` en botones, switcher, hover overlay, chevrons y crossfade del teléfono por **`const Cubic(0.22, 1.0, 0.36, 1.0)`**.
- **Duraciones disciplinadas:**
  - Hover / press / toggles (`ConceptSwitcherMenu`, `_OutlinedPlatformButton`, `PortfolioActionButton`, `WideSectionChevron`): **`150ms`**.
  - Overlay hover en celular desktop: **`180ms`**.
  - **Teléfono frontal en `#nutrilens` & `#setpoint` (decisión de Tobías mantenida):** mantener ciclo **`2200ms` (`2.2s`)** con crossfade **`440ms`** en `Cubic(0.22, 1.0, 0.36, 1.0)`.
  - **2 filas horizontales chill en `#nutrilens` & `#setpoint` (decisión de Tobías mantenida):** mantener `HorizontalFilmstripBackdrop` (`-12 / +10` o `-14 / +12 px/s` constante, pausable con `[ ⏸ ]` y `disableAnimationsOf`, aislado en `RepaintBoundary` + `cacheWidth: 180`).
  - **Remover animación continua innecesaria:** al quitar `_AmbientCanvasGlow` y `DiagonalScreenWallBackdrop` del Hero `#overview`, el Hero queda **100% estático y ultra-rápido (`0` repaints por segundo en reposo)** mientras los proyectos mantienen sus 2 filas chill!

---

## 5. Impacto Esperado para Tobías

1. **Primera pantalla (`1440×900` y `390×844`):** Desaparece el smog verde del fondo, desaparece el botón verde mint gritón de arriba a la derecha, desaparece el botón `LinkedIn` huérfano en línea 2, y las **3 capturas reales** en el Hero switcher ganan todo el protagonismo.
2. **Proyectos (`#nutrilens`, `#setpoint`):** Conservan intactas las líneas divisorias arriba/abajo, las 2 filas horizontales chill atrás y el celular único a `2.2s` con `< x / 4 >`, pero eliminan la colisión oculta detrás de `ConceptSwitcherMenu` arriba a la derecha, el halo fosforescente alrededor del bezel y los textos en mayúsculas con viñetas ASCII.
3. **`#capabilities`:** Sin glow verde, con tipografía liviana `w500`, filas alineadas en eje X exacto de `4px`, banner MatchUp sin texto repetido y **10 botones de plataforma solo con borde e ícono monocromo elegante**.
4. **Cero pérdida de funcionalidades:** Todos los links, tests (`153` + `24`), demos live, `ConceptSwitcherMenu` (`A/B/C + Mix`), `WideSectionChevron` (`solo en #overview, #nutrilens, #setpoint`) y scroll por secciones siguen intactos.
