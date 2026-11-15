# Auditoría UI/UX Independiente (`r7`) y Propuesta Alternativa — Portfolio Web Tobías Gutiérrez

> **Rol:** `@disenador-2` (Segunda opinión independiente, sin sesgo previo)  
> **Sitio auditado en vivo:** `https://tobias-portfolio-web.web.app/` (build `r7`, renderer `skwasm`)  
> **Metodología y Skills aplicadas:** `taste-skill` (14 passes + registro de tells + rúbrica calibrada), `ui-ux-pro-max` (`pro-rules` + `quick-reference`), `ui-ux-designer`, `ui-visual-validator` (evidencia directa sobre screenshots reales) y `wcag-audit-patterns` (WCAG 2.2 AA).  
> **Viewports capturados e inspeccionados:** `1440×900` (7 capturas incl. hover sidebar, hover mockup y tab de teclado), `1280×720` (5 capturas), `768×1024` (2 capturas) y `390×844` (15 capturas de scroll completo y navegación por dock), contrastadas contra las 4 capturas previas de `r6`.  
> **Alcance:** Solo auditoría y propuesta. No se modificó ningún archivo `.dart` ni `DESIGN_SPEC.md`.

---

## 1. Resumen Ejecutivo & Scorecard (`taste-skill / critique.md`)

Desde lo técnico y de performance, el portfolio está impecable: carga rápido en WASM, tiene `0` errores de runtime en consola, los mockups WebP `624×1350` son nítidos y el contraste de la tipografía principal sobre `#080A0C` es excelente.

Sin embargo, **evaluado como producto de diseño y herramienta de conversión para clientes de Upwork / recruiters internacionales**, `r7` está estancado en un **look de template dark genérico con fricciones reales de usabilidad en mobile/tablet y accesibilidad**. Al sacar la tarjeta derecha del Hero en `r7` sin reemplazarla por una prueba visual ni ajustar la grilla, el primer pantallazo perdió autoridad y dejó dos tercios de la pantalla en negro vacío, mientras que las dos secciones siguientes repiten exactamente el mismo discurso antes de mostrar una sola línea de trabajo real.

```text
ROUND r7 (Live Audit — tobias-portfolio-web.web.app)
Seen in one second:
  White two-line headline floating in the middle of an mostly-empty black canvas,
  flanked by a tiny vertical pill bar on the far left.

Idea (one sentence):
  Clean dark developer landing page with two identical dual-iPhone Flutter showcases.
  (Fails Pass 3 "Cover the logo": swap Tobías's name for any senior Flutter freelancer
  and the entire layout and value pitch still apply unchanged.)

Live thing:
  Two external live web demos (NutriLens AI / SetPoint) plus an auto-rotating 3-screen
  slideshow inside the right phone bezel and a Copy Email button. Nothing truly live or
  interactive above the fold on the page itself.

Layout words by section:
  overview = centered-narrow text block (no media)
  how-i-help = centered-narrow vertical numbered list
  core-stack = 2x2 identical icon-card grid
  nutrilens = 3-col split (tilted-phone / dense-text / right-phone)
  setpoint = 3-col split (tilted-phone / dense-text / right-phone)  <-- consecutive repeat

Scores (Awwwards-calibrated):
  design 6.5 · usability 5.8 · creativity 5.5 · content 6.5 -> overall 6.0 (capped <= 6.0)

Caps applied (taste-skill critique.md §3):
  - Mobile & Tablet bottom pill dock collides directly on top of headings and body copy
    across scroll positions -> usability capped <= 6.0.
  - Consecutive repeated showcase layouts, 2x2 icon-topped card grid, tracked all-caps
    eyebrow labels, 1px outlined boxes, and index numbering (1/2/3/4) -> overall capped <= 6.5.
  - Pass 3 fails (generic category pitch in Hero) -> creativity capped <= 6.0.

Top three problems (most visible first):
  1. [r7_390_01_top..08.png, r7_768_hero.png] MobileBottomPillDock floats directly over
     section titles ("How I Help Teams", "Cross-Platform UI & Native"), paragraphs, and
     phone previews on every viewport < 960px, while each mobile showcase stretches ~1,800px.
  2. [r7_1440_sec0_overview.png] Removing the right Hero card in r7 left ~65% of the
     1440x900 first screen as empty #080A0C ground with zero visual proof, zero live product
     preview, and 4 mismatched left-edge anchor lines down the page (356px / 396px / 196px / 400px).
  3. [r7_1440_sec1_how_i_help.png + r7_1440_sec2_core_stack.png + r7_1440_sec3/4] Two full
     100vh text-only sections (1,800px) repeat the exact same capabilities before showing any app,
     and the app mockups themselves display Spanish UI inside an English-only portfolio while
     omitting Tobías's shipped 5.0-star Apple App Store app (MatchUp).
```

---

## 2. Evolución `r6 → r7`: Qué Mejoró y Qué Empeoró

Comparando las 4 capturas de `r6` (`media_1794716125059_d1e5393e.jpg`, `media_1794716139265_4cdf0a4f.jpg`, `media_1794716003327_42aeae1b.jpg`, `media_1794715978017_b6645fdc.jpg`) contra el sitio live actual (`r7`):

### Lo que `r7` sí resolvió bien
1. **Fin del recorte en `1280×720` (SetPoint + Footer):** En `r6` (`media_1794715978017_b6645fdc.jpg`), los botones `View Source on GitHub ↗` y `Open Live Demo ↗` de SetPoint quedaban cortados por el footer. En `r7_1280_sec4_setpoint.png` se verifica visualmente que ambos botones quedan completamente visibles y con aire encima del `PortfolioFooterStrip`.
2. **Captura limpia de entrada en NutriLens (`nutrilens_scan.webp`):** Reemplazar el spinner infinito `"Analyzing nutrients..."` de `r6` por la vista `"No photo handy? Try sample meal"` (`r7_768_nutrilens.png`) comunica muchísimo mejor que la web demo se puede probar en 10 segundos sin subir foto.
3. **Columna central de proyectos más respirada:** Pasar de 4 a 3 bullets (`flex: 21/56/23`) en `r7_1440_sec3_nutrilens.png` y `r7_1440_sec4_setpoint.png` mejoró la lectura respecto al bloque apretado de `r6`.
4. **Eliminación de la barra redundante `ENGAGEMENT MODES`:** En `r6` (`media_1794716139265_4cdf0a4f.jpg`) había una quinta caja abajo de las 4 cards que repetía lo mismo; sacarla redujo ruido visual en la Sección 2.

### Lo que `r7` dejó roto o más débil que en `r6`
1. **Un Hero amputado sin reemplazo visual:** En `r6`, la tarjeta derecha `HOW I HELP TEAMS` era densa y competía con el H1, pero al menos equilibraba el viewport `1440×900` y ofrecía links directos a `NutriLens AI ↗` y `SetPoint ↗` + la métrica `177 automated tests` above the fold. En `r7_1440_sec0_overview.png`, se sacó la tarjeta derecha y el Hero quedó como una isla angosta (`~660px` útiles dentro de `1440px`) rodeada de un vacío negro gigante, **sin métricas, sin capturas y sin links directos a las apps**.
2. **El contenido movido a Sección 1 creó redundancia severa con Sección 2:** Al convertir la ex-tarjeta derecha en una sección completa de `100vh` (`How I Help Teams`), ahora el visitante atraviesa **1,800px de scroll (Sección 1 + Sección 2)** leyendo las mismas 4 ideas dos veces antes de ver el primer producto real.

---

## 3. Conversión & Primeros 5 Segundos (Ojo de Cliente Upwork / Tech Recruiter)

Evaluación directa pensando en un founder estadounidense o recruiter remoto que abre el link desde una propuesta de Upwork o LinkedIn y decide en **5 segundos** si te entrevista:

1. **Promesa vs. Evidencia (Gap de Credibilidad):**
   - El H1 promete: **`Flutter & native apps, from Figma to the stores.`**
   - Pero en todo el portfolio **no hay ni una sola mención a una app publicada en App Store o Play Store**, ni código nativo Swift/Kotlin visible. Los dos únicos casos mostrados son `NutriLens AI` y `SetPoint` (ambos proyectos propios en GitHub Pages).
   - Lo más insólito es que según [`upwork/matchup-app.md`](file:///c:/Users/ik/.gemini/antigravity/scratch/mobile_sprint/upwork/matchup-app.md), **sí tenés un proyecto comercial real entregado a cliente y publicado en el Apple App Store con calificación 5.0★ (`MatchUp`)**, con Google/Phone Auth, Firestore, Cloud Functions, FCM & APNs Push, Google Maps y AdMob. Ocultar tu prueba comercial real de App Store mientras tu H1 dice *"to the stores"* es dejar plata sobre la mesa.
2. **Falla la prueba de diferenciación ("Cover the logo"):**
   - Si tapás `TOBÍAS GUTIÉRREZ`, el Hero (`"Flutter & native apps, from Figma to the stores."` + `"I build production iOS, Android, and Web apps..."` + 8 chips genéricos) podría ser de **cualquier desarrollador Flutter de nivel intermedio**. No comunica por qué vos resolvés el problema mejor que otros 30 postulantes: que entregás **producto completo solo** (UI 60fps + Firebase/Cloudflare backend + IA con Vision + tests automatizados + stores) con overlap horario directo para EE.UU./UE.
3. **Cero prueba tangible above-the-fold:**
   - En los primeros 5 segundos en `1440×900` (`r7_1440_sec0_overview.png`), el visitante no ve ni una pantalla de tus apps, ni un solo número (`177 tests`, `App Store`), ni una demo clicable sin scrollear.
4. **Inconsistencia de idioma en los mockups (`PORTFOLIO_PROMPT.md`):**
   - El portfolio exige ser **100% en inglés**, y el copy alrededor de los teléfonos está en inglés perfecto. Sin embargo, adentro de los mockups en producción:
     - **SetPoint (`r7_1440_sec4_setpoint.png`, `r7_1280_sec4_setpoint.png`, `r7_390_setpoint_phones.png`):** Todo el UI interno visible está en español: *"Lista | Mapa"*, *"Ubicación actual: Av. 9 de Julio, Obelisco"*, *"4 Partidos cerca"*, *"¡Bienvenido, Tobías!"*, *"Dobles Clásico en Recoleta"*, *"Falta 1"*, *"Mis partidos"*, *"Cuenta"*, *"Unirme al Partido"*.
     - **NutriLens AI (`r7_1440_sec3_nutrilens.png`, `r7_1280_sec3_nutrilens.png`):** Aunque la UI de navegación está en inglés (`My Pantry`, `Breakfast`, `Health Score`), la lista de ingredientes y comidas está cargada en español (*"Huevos de campo"*, *"Avena tradicional (Quáker)"*, *"Pechuga de pollo"*, *"Pan integral 100% (Fargo)"*, *"Palta Hass"*, *"Queso untable light (Finlandia)"*).
   - Para un cliente angloparlante que hace zoom en los teléfonos, ver la interfaz en español choca con el posicionamiento internacional del portfolio.

---

## 4. Auditoría Sección por Sección (Evidencia Visual `r7`)

### 4.1 Sección 0 — `Overview` (`r7_1440_sec0_overview.png`, `r7_1280_sec0_overview.png`, `r7_390_01_top.png`)
- **Desaprovechamiento espacial (`1440×900`):** El bloque de contenido ocupa apenas ~`46%` del ancho y ~`39%` del alto del viewport. Todo el tercio superior, inferior y la mitad derecha son fondo oscuro `#080A0C` vacío (con un radial glow verde casi imperceptible). Según `taste-skill` (`layout.md §5`), dejar más de la mitad de la primera pantalla en ground vacío se percibe como un "agujero" (*hole*), no como espacio negativo intencional.
- **Identidad minimizada al revés:** Tu nombre (`TOBÍAS GUTIÉRREZ · MOBILE SOFTWARE ENGINEER · GMT-3`) está seteado en **`13px` mayúsculas con tracking ancho (`letterSpacing: 1.4`)**, que es el tamaño más pequeño de toda la página y un *eyebrow tell* clásico (`tells.md §2`). En `390×844` (`r7_390_01_top.png`) ese eyebrow se parte en dos líneas cortando `"MOBILE SOFTWARE / ENGINEER"`.
- **Fila de CTAs saturada y sin jerarquía clara:** Hay 5 botones en el mismo nivel horizontal (`Explore Projects ↓`, `GitHub ↗`, `LinkedIn ↗`, `tobigutierrez26@gmail.com`, `Copy`). En mobile (`r7_390_01_top.png`) se parten en **3 filas de botones**. Además, tener el email entero como un botón rectangular de `46px` de alto y otro botón `Copy` al lado compite visualmente con la acción primaria y parece un control de formulario suelto.
- **Fila de chips "deshilachada":** Debajo de la línea `1px`, hay 8 chips que caen como **6 arriba y 2 huérfanos abajo (`Figma`, `GitHub Actions`)** tanto en `1440×900` como en `1280×720`. Es el mismo desbalance que existía en `r6`.

### 4.2 Sección 1 — `How I Help Teams` (`r7_1440_sec1_how_i_help.png`, `r7_1280_sec1_how_i_help.png`, `r7_390_05.png`)
- **Inconsistencia de sistema:** Lleva el eyebrow verde all-caps `WORKING TOGETHER`, igual que Overview, pero Sección 2 (`Core Stack`) no tiene eyebrow.
- **Error semántico de componente (Timeline para contenido no secuencial):** Los nodos circulares `1 — 2 — 3 — 4` unidos por una línea vertical sugieren un proceso cronológico en 4 etapas. En realidad, los 4 ítems son **capacidades paralelas** (`Delivery`, `Backend & AI`, `Architecture & QA`, `Timezone & Language`). Visualmente promete un workflow, pero entrega una lista de features.
- **Baja visibilidad de la línea conectora y ancho angosto:** En `1440×900`, el stepper (`maxWidth: 740`) queda contenido en la parte central-izquierda con la mitad derecha del viewport completamente vacía. La línea `#2A313D` sobre `#080A0C` tiene contraste **`1.52:1`** y casi desaparece en monitores estándar.
- **Redundancia grave con Sección 2:** Repite punto por punto (*Figma specs*, *Firebase Auth/Firestore/Functions/Push*, *Cloudflare AI proxies*, *BLoC/Provider/Riverpod*, *177 automated tests*) exactamente lo que vuelve a aparecer 900px más abajo en `Core Stack & Deliverables`.

### 4.3 Sección 2 — `Core Stack & Deliverables` (`r7_1440_sec2_core_stack.png`, `r7_1280_sec2_core_stack.png`, `r7_390_08.png`)
- **Look de template genérico ("2×2 Icon Cards"):** Cuatro rectángulos `#101318` con borde de `1px`, ícono verde arriba a la izquierda, 2 líneas de descripción gris y fila de pill chips. En el estudio de `taste-skill` (`research.md §6`), las grillas de cards idénticas con ícono + texto son uno de los indicadores más fuertes de sitios promedio/template (`26%` en sitios débiles vs `7%` en top).
- **Quiebres tipográficos feos en las capturas:**
  - El subtítulo de la sección deja una palabra huérfana sola en la segunda línea (`"...and automated / release."`) tanto en `r7_1440_sec2_core_stack.png` como en `r7_1280_sec2_core_stack.png`.
  - En la card 4 (`Maps, State & Automated QA`), el término `"CI/CD"` se rompe en medio de la barra (`"...persistence fallbacks, CI/ / CD, and automated tests."`), un corte tipográfico descuidado visible en ambos tamaños desktop.
- **Inconsistencia dentro de los chips:** En la card 2 (`Firebase & Cloud Backends`), `Firebase` y `Firestore` aparecen pegados con **el mismo ícono de llama naranja**, mientras `Cloud Functions` y `FCM / APNs` no tienen ícono. Y en la card 4, `177 Tests` aparece como un chip neutro sin marca al lado de dos chips con logo.

### 4.4 Secciones 3 & 4 — `NutriLens AI` y `SetPoint` (`r7_1440_sec3_nutrilens.png`, `r7_1440_sec4_setpoint.png`, `r7_1280_sec3/4`, `r7_390_*`)
- **Dos secciones consecutivas idénticas (`Sameness`):** `NutriLens AI` y `SetPoint` replican exactamente la misma estructura `21/56/23` (`iPhone inclinado | columna central densa | iPhone recto`), una inmediatamente detrás de la otra.
- **Saturación de micro-elementos en la columna central:** En `~580px` de ancho se apilan **14 elementos** entre logo, título, subtítulo, 2 eyebrows all-caps (`THE PROBLEM`, `HOW IT'S BUILT`), párrafo, 3 bullets en negrita+gris, 5–6 chips en dos filas, línea destacada en color acento (`Solo End-to-End · 153 Tests • Try in 10s...`) y 2 botones. Aunque `153 Tests` ya tiene su chip resaltado con borde lima, vuelve a repetirse 12px más abajo en `Solo End-to-End · 153 Tests`.
- **Jerarquía de botones plana y copy triplicado:**
  - `View Source on GitHub ↗` y `Open Live Demo ↗` usan exactamente el mismo botón secundario oscuro (`#101318`). No queda claro cuál es la acción primaria.
  - Para abrir la misma demo web coexisten 3 textos distintos en el mismo bloque: `Open Live Demo ↗` (botón), `Hover to launch live demo ↗` (caption bajo el iPhone) y `Try Live Interactive App ↗` (pill sobre el blur).
  - En `r7_1440_sec3_nutrilens_hover.png` y `r7_390_setpoint_phones.png`, el pill CTA `#D2F07A` / `#C8E652` dentro del teléfono no entra en una línea y parte `"Try Live Interactive / App ↗"` dejando `"App ↗"` huérfana en el segundo renglón.
- **Franja negra artificial dentro del Bezel (`iphone_bezel_frame.dart`):** Arriba de cada captura hay un bloque sólido `#080A0C` de `26–32px` detrás de la Dynamic Island (`r7_1440_sec3_nutrilens.png`, `r7_1440_sec4_setpoint.png`). Como las pantallas de NutriLens (verde bosque `#185B47` o blanco `#F6F8F5`) y el mapa de SetPoint (celeste/blanco OSM) son claras o de color propio, esa franja negra genera un corte horizontal recto poco natural debajo de la Dynamic Island en vez de respetar la safe-area nativa de cada app.
- **Mobile infinito (~1,800px por proyecto):** En `390×844`, cada proyecto apila columna de texto + 2 teléfonos verticales completos (`240px` + `210px` de ancho, uno encima del otro) + botón GitHub, obligando a scrollear más de 2 pantallas enteras por proyecto (`r7_390_nutrilens_top.png` → `phones.png`, `r7_390_setpoint_top.png` → `real_footer.png`).

### 4.5 Navegación (`FloatingPillSidebar` & `MobileBottomPillDock`) y Footer
- **Sidebar Desktop (`r7_1440_sidebar_hover.png`):**
  - Mezcla **3 estilos visuales** dentro de la misma cápsula vertical: letras (`TG`), dos íconos wireframe outline de `1.5px` (Steps y Layers), y dos íconos raster full-color cuadrados (`NutriLens`, `SetPoint`).
  - Sin hacer hover, los íconos 2 y 3 son ambiguos ("mystery meat navigation"): un visitante no sabe qué sección es cada una hasta apoyar el cursor.
- **Dock Inferior Mobile/Tablet (`r7_390_01_top..08.png`, `r7_768_hero.png`, `r7_768_nutrilens.png`) — BUG VISUAL CRÍTICO:**
  - En todos los viewports `< 960px`, la píldora inferior flotante flota sin barrera opaca **directamente encima del contenido scrolleado**.
  - En `r7_390_01_top.png` corta a la mitad el H2 `"How I Help Teams"`; en `r7_390_04.png` tapa el paso `4`; en `r7_390_07.png` tapa `"Cross-Platform UI & Native"`; en `r7_768_hero.png` tapa el paso `2`; en `r7_768_nutrilens.png` tapa la tab bar de los mockups.
- **Footer (`r7_1440_sec4_setpoint.png`):** Es una tira mínima de `13px` apretada debajo de SetPoint, sin cierre comercial para convertir al visitante que llegó hasta el final del portfolio.

---

## 5. Tipografía, Alineaciones (`Edges`) y Auditoría WCAG 2.2

### 5.1 Desalineación de Anclajes X entre Secciones (Desktop `1440×900`)
Al seguir el borde izquierdo de los encabezados bajando por la página en `1440px`, cada sección usa un `maxWidth` distinto (`960`, `880`, `1280`, `1360`), desplazando el eje izquierdo en **4 posiciones distintas**:
1. **Hero (`Overview`):** `maxWidth: 960` con `leftPad: 116` → el H1 arranca aprox. en **`x ≈ 356px`**.
2. **How I Help Teams:** `maxWidth: 880` con `leftPad: 116` → el H2 arranca aprox. en **`x ≈ 396px`** (`+40px` corrido a la derecha respecto al Hero).
3. **Core Stack:** `maxWidth: 1280` con `leftPad: 116` → el H2 arranca aprox. en **`x ≈ 196px`** (`-200px` corrido a la izquierda).
4. **Showcases:** `maxWidth: 1360` en 3 columnas `21/56/23` → el título del proyecto arranca recién en **`x ≈ 400px`**.

*(Regla `taste-skill` Pass 4: un sitio diseñado usa 2 o 3 líneas de anclaje consistentes en toda la página, no un eje distinto por sección).*

### 5.2 Medición Exacta de Contrastes (`AppColors` — WCAG 2.1 / 2.2)

| Par medido (`foreground` / `background`) | Uso en el Portfolio | Ratio medido | Estado WCAG 2.2 |
|---|---|---:|---|
| `#F4F6F8` sobre `#080A0C` | `textPrimary` sobre `bgCanvas` | **18.30 : 1** | Pasa AAA (≥ 7:1) |
| `#9AA4B2` sobre `#080A0C` | `textSecondary` sobre `bgCanvas` | **7.86 : 1** | Pasa AAA |
| `#9AA4B2` sobre `#101318` | `textSecondary` en cards/botones | **7.38 : 1** | Pasa AAA |
| `#7A8594` sobre `#080A0C` | `textMuted` en footer | **5.30 : 1** | Pasa AA (≥ 4.5:1) |
| `#7A8594` sobre `#101318` | `textMuted` sobre superficie | **4.97 : 1** | Pasa AA |
| `#34D399` sobre `#080A0C` | `accentEngineering` | **10.31 : 1** | Pasa AAA |
| `#D2F07A` sobre `#080A0C` | `accentNutriLens` | **15.57 : 1** | Pasa AAA |
| `#C8E652` sobre `#080A0C` | `accentSetPoint` | **14.07 : 1** | Pasa AAA |
| `#080A0C` sobre `#D2F07A` / `#C8E652` | CTA ink sobre pill acento | **15.57 / 14.07 : 1** | Pasa AAA |
| `#101318` vs `#080A0C` | Paso tonal card vs fondo | **1.07 : 1** | Muy sutil / casi plano |
| `rgba(255,255,255,0.08)` sobre `#080A0C` | `borderHairline` de botones secundarios y cards | **1.18 : 1** | **Bajo** (< 3:1 para límites de botones UI) |
| `#2A313D` sobre `#080A0C` | Línea vertical del timeline `1→4` | **1.52 : 1** | **Bajo** (casi invisible en pantallas medias) |
| `#303642` sobre `#050608` | Borde del `FloatingPillSidebar` | **1.67 : 1** | Bajo (depende de sombra) |

### 5.3 Fallos Funcionales de Accesibilidad Detectados en Vivo (WCAG 2.2)
1. **WCAG 2.4.7 Focus Visible (Level AA) — FALLA (`r7_1440_keyboard_tab.png`):** Al tabular 7 veces en el Hero, no hay ningún indicador visual perceptible de foco. En `portfolio_action_button.dart`, el botón primario pasa de `#F4F6F8` a `#FFFFFF` (`1.09:1` de cambio — invisible) y el secundario cambia el borde al 22% de blanco (`borderFocus`), muy por debajo de un `outline` de `2px` con contraste `≥ 3:1`.
2. **WCAG 2.1.1 Keyboard (Level A) — FALLA (`portfolio_footer_strip.dart`):** `_FooterLink` (`GitHub`, `LinkedIn`, `Email`) usa `GestureDetector` sin `FocusableActionDetector` ni `Semantics(link: true)`. Es imposible acceder a los links del footer mediante teclado (`Tab`).
3. **WCAG 2.4.11 Focus Not Obscured (Level AA, WCAG 2.2) — FALLA (`r7_390_*` / `r7_768_*`):** `MobileBottomPillDock` flota encima del viewport inferior tapando botones, links y headings mientras se navega o scrollea.
4. **WCAG 2.2.2 Pause, Stop, Hide (Level A) — FALLA (`interactive_right_phone_mockup.dart`):** El carrusel de capturas rota automáticamente cada 4s sin controles visibles de pausa ni navegación manual (`Prev` / `Next`), dificultando leer los detalles de cada pantalla.
5. **WCAG 1.3.1 Info and Relationships / 4.1.2 Name, Role, Value — PARCIAL:** La inspección CDP confirmó `domH1Count: 0` y árbol semántico vacío antes de activación manual; dentro de Flutter, el H1 está partido en dos `Text` independientes sin `Semantics(header: true)` ni `MergeSemantics`, y los H2 tampoco declaran rol semántico de `header: true`.
6. **WCAG 2.5.8 Target Size — REVISAR FOOTER:** En `portfolio_footer_strip.dart`, `_FooterLink` tiene `padding: symmetric(horizontal: 4, vertical: 6)` sobre texto de `13px`, resultando en un área clickeable menor a `44×44px` en mobile.

---

## 6. Propuesta Alternativa Completa (Para Llevar el Portfolio a 8.5+)

La propuesta mantiene exactamente tu stack visual base (**Dark Engineering** `#080A0C`, tipografía `Plus Jakarta Sans` + `Inter`, acentos quirúrgicos por app) y respeta 100% las reglas de [`PORTFOLIO_PROMPT.md`](file:///c:/Users/ik/.gemini/antigravity/scratch/mobile_sprint/PORTFOLIO_PROMPT.md) (100% inglés, cero menciones a FIUBA/universidad, solo datos reales verificados).

### 6.1 Arquitectura Propuesta: De 5 Secciones Redundantes a 4 Actos con Ritmo Variado

| # | Sección | Rol en la conversión | Cambio clave vs `r7` |
|---|---|---|---|
| **0** | `#overview` — **Asymmetric Hero + Live App Switcher** | Impactar en < 5s mostrando **producto real** y diferenciación backend+IA+App Store | Termina con el 65% vacío de `r7`; incluye selector interactivo vivo de 3 apps (`NutriLens AI`, `SetPoint`, `MatchUp`) a la derecha |
| **1** | `#work` — **Selected Work (Layouts Alternados)** | Probar capacidad técnica real con 2 casos profundos + 1 caso comercial App Store | **NutriLens AI** (texto izq / stage der) → **SetPoint** (stage izq / texto der, invertido!) → **MatchUp** (banner/strip compacto de App Store 5.0★) |
| **2** | `#capabilities` — **How We Work & Stack (Index Rows)** | Fusionar `How I Help` + `Core Stack` sin repetir ni usar 4 cards genéricas | Reemplaza Sección 1 + Sección 2 (~1,800px) por 1 sola sección estilo filas indexadas (`Linear`/`Vercel`) sin cajas `1px` repetidas |
| **3** | `#contact` — **Closing CTA & Footer** | Convertir la visita al final de la lectura | Cierre diseñado con headline directo, CTA único de email/copia y links accesibles `>= 44px` |

---

### 6.2 Wireframes Concretos (`1440×900` Desktop & `390×844` Mobile)

#### Desktop (`1440×900`) — Hero Asimétrico `52% / 48%` (Una Sola Ancla Izquierda `x = 128px`)
```text
+-----------------------------------------------------------------------------------+
| [Nav]                                                                             |
|  TG  |  Work  ·  Capabilities  ·  Contact                     [ Copy Email / Hire ]|
| (Nota: o Sidebar pill izquierdo refinado con iconos consistentes + tooltips claros)|
+-----------------------------------------------------------------------------------+
|                                                                                   |
|  Tobías Gutiérrez — Mobile Software Engineer                  +-----------------+ |
|  Buenos Aires (GMT-3 · Full US East & EU Overlap)             | [NutriLens][SP] | |
|                                                               |   [MatchUp ★]   | |
|  Production Flutter apps,                                     |                 | |
|  with backend & AI built in.                                  |   +---------+   | |
|                                                               |   | Live    |   | |
|  I build iOS, Android, and Web apps solo—from Figma specs     |   | Phone   |   | |
|  to Firebase cloud, Cloudflare AI proxies, and App Store      |   | Preview |   | |
|  releases.                                                    |   | (EN UI) |   | |
|                                                               |   +---------+   | |
|  [ View Selected Work ↓ ]   [ Email / Copy ]   GitHub ↗   LinkedIn ↗              |
|                                                               |   [Open Live ↗] | |
|  App Store Shipped (5.0★)  ·  177 Automated Tests  ·  EN/ES   +-----------------+ |
+-----------------------------------------------------------------------------------+
```
*Por qué funciona mejor que `r7`:**
- **Cumple la regla del Hero (`taste-skill`):** El lado derecho muestra producto real ocupando >40% del viewport con un **Live App Switcher** (la "One Live Thing"): tocás `NutriLens AI`, `SetPoint` o `MatchUp` y previsualizás cada app ahí mismo sin scrollear.
- **Unifica la jerarquía de CTAs:** 1 botón primario sólido + `Copy Email` compacto + 2 text links (`GitHub ↗`, `LinkedIn ↗`) en una sola línea limpia, sin 5 cajas compitiendo.
- **Elimina el eyebrow tracked verde:** Tu nombre y timezone van en `15px` sentence-case legible, y las 3 pruebas reales reemplazan a los 8 chips desparejos (`6 + 2`).

#### Desktop — Sección 2 Fusionada (`#capabilities` — Index Rows en vez de 4 Cards + Stepper)
```text
+-----------------------------------------------------------------------------------+
|  HOW WE WORK & STACK                                                              |
|  One engineer owning UI, backend, and release QA.                                 |
|                                                                                   |
|  0→1 Mobile MVPs           Figma specs to 60fps iOS, Android & Flutter Web apps   |
|                            Flutter · Dart 3 · Swift/Kotlin Bridges · Figma        |
|  -------------------------------------------------------------------------------  |
|  Backend & AI Included     No separate backend hire: auth, real-time DB & edge AI |
|                            Firebase (Auth, Firestore, Functions, FCM/APNs)        |
|                            Cloudflare Workers · Gemini Vision · REST APIs         |
|  -------------------------------------------------------------------------------  |
|  Architecture & QA         Predictable state machines and automated CI gates      |
|                            Clean Architecture · BLoC / Riverpod / MVVM · 177 Tests|
|  -------------------------------------------------------------------------------  |
|  Remote & Freelance Ready  Direct overlap (GMT-3), weekly testable web builds     |
|                            Full US East & EU Overlap · English & Spanish          |
+-----------------------------------------------------------------------------------+
```
*(Separado por espacio generoso y escalón tonal de hover en cada fila, sin 4 rectángulos `1px` idénticos ni círculos numerados `1→4` que confunden orden temporal).*

#### Mobile (`390×844`) — Barra Superior Opaca (Cero Colisiones) + Showcase Compacto
```text
+------------------------------------+
| [TG]     Work · Stack · Contact    |  <-- Sticky top bar opaca #080A0C (56px),
+------------------------------------+      NUNCA flota encima de títulos ni mockups!
|                                    |
|  Tobías Gutiérrez                  |
|  Mobile Software Engineer · GMT-3  |
|                                    |
|  Production Flutter apps,          |
|  with backend & AI built in.       |
|                                    |
|  I build iOS, Android, and Web     |
|  apps solo—from Figma to Firebase, |
|  AI proxies, and App Store launch. |
|                                    |
|  [ View Live Work ↓ ]              |
|  tobigutierrez26@gmail.com [Copy]  |
|  GitHub ↗  ·  LinkedIn ↗           |
|                                    |
|  +------------------------------+  |
|  | [NutriLens] [SetPoint] [App★]|  |  <-- Preview compacta ya visible en el
|  |   (Pantalla principal app)   |  |      segundo scroll sin esperar 2,000px!
|  +------------------------------+  |
+------------------------------------+
```
*Y dentro de cada Project Showcase en Mobile:* mostrar **un solo mockup interactivo con swipe/tabs entre las 3-4 pantallas** (`< 1 / 4 >`) en vez de apilar dos iPhones gigantes verticales uno abajo del otro (`~1,800px` → pasa a `~850px`, mitad del scroll y mucho más ágil con el pulgar!).

---

### 6.3 Copy Deck Alternativo en Inglés (Listo para Usar — Anti-AI-Slop)

#### Section 0: Hero (`#overview`)
- **Identity Line (Sentence case, `15px`, `#F4F6F8` / `#9AA4B2`):**
  `Tobías Gutiérrez — Mobile Software Engineer · GMT-3`
- **H1 (`2 lines max`, `56px` desktop / `34px` mobile):**
  `Production Flutter apps,`
  `with backend & AI built in.`
- **Supporting Paragraph (`18px` desktop / `16px` mobile):**
  `I ship iOS, Android, and Web products end to end—combining 60fps Flutter UI, Firebase cloud backends, serverless AI proxies, and automated tests.`
- **Primary CTA:** `View Live Work ↓`
- **Secondary Action:** `Copy Email` (o botón compacto `tobigutierrez26@gmail.com` con icono copiar integrado en un solo control, no 2 botones separados!)
- **Text Links:** `GitHub ↗` · `LinkedIn ↗`
- **Hero Proof Strip (`14px`, `tabular-nums`, sin bordes de chips):**
  `App Store Shipped (5.0★)` · `177 Automated Tests` · `US East & EU Overlap`

#### Section 1: Selected Work (`#work`)
- **Section Heading:** `Selected Work`
- **Project 1 — NutriLens AI** *(Layout: Texto izquierda 46% / Dual-Screen Stage derecha 54%)*
  - **Title:** `NutriLens AI`
  - **Subtitle:** `Pantry-First Meal & Macro Tracker`
  - **Problem (1 oración corta):** `Calorie trackers fail on home-cooked meals—forcing manual weighing instead of matching the brands in your kitchen.`
  - **Key Engineering (3 bullets concisos, 1.5 líneas max c/u):**
    - `3-Mode Pantry Scanning:` `Barcode lookup (Open Food Facts v2 + Gemini fallback), front-of-pack recognition, and label OCR.`
    - `Pantry-Matched Vision & Score:` `Gemini Vision cross-references plated meals against your pantry and scores 0–100 macro balance.`
    - `Zero-Key Edge Proxy:` `Cloudflare Worker isolates Gemini API keys with Origin CORS, model allowlists, 16 MB caps, and 30 req/min rate limits.`
  - **Metadata Line:** `Solo End-to-End · MVVM + Provider · 153 Unit & Widget Tests`
  - **Primary CTA (solid `#D2F07A`, `#080A0C` ink):** `Open Live Demo ↗` *(Try Camera → "Sample")*
  - **Secondary Link:** `View Source on GitHub ↗`

- **Project 2 — SetPoint** *(Layout INVERTIDO: Stage izquierda 54% / Texto derecha 46%)*
  - **Title:** `SetPoint`
  - **Subtitle:** `Mobile Tennis Matchmaking Platform`
  - **Problem:** `Organizing tennis over group chats breaks down—mismatched skill levels, unclear court surfaces, and manual headcounts waste hours.`
  - **Key Engineering:**
    - `Dual Feed & Map Clustering:` `Real-time match feed paired with OpenStreetMap clustering and 5–20 km radius filters.`
    - `Live Criteria & Court Tactics:` `Filter by format (Singles/Doubles), surface, and 5-tier skill with 1v1 / 2v2 court views.`
    - `Offline-Resilient BLoC:` `Clean Architecture + BLoC 8.1 with Dart 3 sealed domain errors and UGC report/block moderation.`
  - **Metadata Line:** `Solo End-to-End · Clean Architecture + BLoC 8.1 · 24 Unit & BLoC Tests`
  - **Primary CTA (solid `#C8E652`, `#080A0C` ink):** `Open Live Demo ↗` *(Switch List / Map & filter)*
  - **Secondary Link:** `View Source on GitHub ↗`

- **Project 3 (Comercial Proof Card/Strip) — MatchUp (Client Delivery · Apple App Store)**
  - **Title:** `MatchUp — Commercial Client App (Published on Apple App Store · 5.0★)`
  - **Summary:** `End-to-end Flutter & Firebase mobile product built from Figma specs: Google & Phone OTP Auth, real-time Firestore chat, Google Maps custom markers, FCM/APNs push notifications, Cloud Functions, deep linking, and AdMob monetization.`
  - **Deliverable Tag:** `iOS (App Store) & Android · Flutter + Provider + Firebase`

#### Section 2: Capabilities & Engagement (`#capabilities`)
- **Heading:** `Capabilities & Engagement`
- **Subtitle:** `Full product ownership from architecture to store release—no separate backend hire required.`
- **4 Index Rows (Sin cards ni timeline vertical `1→4`):**
  1. `Cross-Platform UI & Native` — `Pixel-accurate Flutter apps for iOS, Android, and Web built from Figma specs at 60fps.` (`Flutter · Dart 3 · iOS · Android · Figma`)
  2. `Firebase & Cloud Backends` — `Production Auth, real-time Firestore streams, Cloud Functions, Storage rules, and FCM / APNs push delivery.` (`Firebase · Firestore · Cloud Functions · FCM / APNs`)
  3. `AI & Serverless Edge APIs` — `Cloudflare Worker proxies keeping LLM keys off client bundles with strict CORS, allowlists, and rate limits.` (`Gemini Vision · Cloudflare Workers · REST APIs`)
  4. `Architecture, QA & Overlap` — `Clean Architecture (BLoC / Riverpod / MVVM), CI/CD via GitHub Actions, 177 automated tests, and direct GMT-3 overlap (EN/ES).` (`BLoC / Riverpod · GitHub Actions · 177 Tests · GMT-3`)

#### Section 3: Closing CTA & Footer (`#contact`)
- **Heading:** `Need a mobile engineer who owns the whole stack?`
- **Subcopy:** `Available for Upwork MVPs, Figma-to-Flutter builds, and remote product teams (GMT-3 · EN/ES).`
- **Primary CTA:** `Copy tobigutierrez26@gmail.com` (con botón directo `Open Email ↗`)
- **Footer Links (accessible `>= 44×44px`):** `GitHub ↗` · `LinkedIn ↗` · `Email` · `Tobías Gutiérrez — Mobile Software Engineer`

---

## 7. Plan de Acción Priorizado (Para Pasar al Implementador si Tobías Aprueba)

Ordenado estrictamente por impacto visual y de conversión (siguiendo `taste-skill/references/critique.md §5`):

### Prioridad P0 — Fixes Críticos de Usabilidad, Accesibilidad y Consistencia (Inmediatos)
1. **Eliminar colisiones del `MobileBottomPillDock` (`< 960px`):** Reemplazarlo por una barra sticky superior opaca (`56px`, `#080A0C` + borde inferior sutil) o reservar un dock bar sólido en el `Scaffold` (`bottomNavigationBar`) para que nunca flote tapando títulos ni textos.
2. **Accesibilidad WCAG 2.2 real:**
   - Añadir foco visible (`2px` `#34D399` o `#F4F6F8`, contraste `>= 3:1`) en `PortfolioActionButton`, `SidebarNavItem` y controles de mockup.
   - Envolver `_FooterLink` (`portfolio_footer_strip.dart`) en `FocusableActionDetector` + `Semantics(link: true)` con hit target `>= 44×44px`.
   - Agregar `Semantics(header: true)` a H1 (unificado) y H2, y agregar controles `‹` / `›` / `Pause` al storyboard derecho.
3. **Re-capturar los mockups de SetPoint y NutriLens 100% en inglés:** Quitar los textos en español (`"¡Bienvenido, Tobías!"`, `"Falta 1"`, `"Polvo de ladrillo"`, `"Huevos de campo"`, `"Palta Hass"`) de las capturas mostradas en el portfolio para alinear 100% con [`PORTFOLIO_PROMPT.md`](file:///c:/Users/ik/.gemini/antigravity/scratch/mobile_sprint/PORTFOLIO_PROMPT.md).
4. **Corregir la franja negra superior dentro del `IphoneBezelFrame`:** Igualar el color del safe-area superior al header de cada app (o superponer la Dynamic Island sobre el header real) para evitar el corte negro recto encima de pantallas blancas/verdes/mapa.

### Prioridad P1 — Conversión y Jerarquía Visual (Alto Impacto)
5. **Agregar un Live App Switcher en el lado derecho del Hero (`1440×900` / `1280×720`):** Cerrar el vacío del 65% de `r7` mostrando tus apps reales desde el segundo 1, e incorporar **MatchUp (Apple App Store 5.0★)** como prueba comercial verificable.
6. **Diferenciar CTAs y limpiar micro-ruido:** Unificar el botón de Demo en cada showcase (`Open Live Demo ↗` sólido en color acento como primario, `View Source on GitHub ↗` subordinado; arreglar el wrap `"Try Live Interactive / App ↗"` acortándolo a `"Launch Live Demo ↗"` para que entre en 1 línea). Eliminar la repetición del conteo de tests entre chip y meta-línea.
7. **Corregir quiebres tipográficos y anclas X:** Unificar el `maxWidth` y margen izquierdo en todas las secciones (`1` sola ancla izquierda), evitar `"CI/ / CD"` con non-breaking hyphen o reescritura (`CI/CD pipelines`) y evitar la huérfana `"release."` en el subtítulo de Core Stack.

### Prioridad P2 — Salto Estético Anti-Template (`6.0 → 8.5+`)
8. **Fusionar `How I Help Teams` + `Core Stack` en una sola sección de Index Rows (`#capabilities`)** y **alternar el layout de `SetPoint` respecto a `NutriLens AI`** (izq/der invertido o tira de 3 pantallas), eliminando los 4 rectángulos `2×2` idénticos, los eyebrows tracked all-caps y el stepper `1→4` semánticamente erróneo.
9. **Agregar sección de cierre (`#contact`)** y compactar el mobile showcase a **1 iPhone interactivo con selector de pantallas** para bajar la longitud del scroll móvil a la mitad.
