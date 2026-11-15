# Especificación de 3 Conceptos Anti-Slop (`r8`) — Portfolio Web Tobías Gutiérrez

> **Autor:** `@disenador-2`  
> **Destinatarios:** Tobías Gutiérrez (evaluación en vivo) · `@coder` (implementación) · `@perf` & `@secops` (auditoría FPS/capturas)  
> **Inspiración directa:** Referencia subida por Tobías (`media_1794720704549_f171ef24.jpg` — grilla diagonal de pantallas móviles con ritmo continuo) + diagnóstico de [`DESIGN_REVIEW_2.md`](file:///c:/Users/ik/.gemini/antigravity/scratch/mobile_sprint/proyectos/portfolio/DESIGN_REVIEW_2.md) + `taste-skill` + `ui-ux-pro-max` + `wcag-audit-patterns`.  
> **Guardrails obligatorios:** 100% inglés en toda la UI pública, cero menciones a FIUBA/universidad/estado académico, solo métricas reales verificadas (`153` + `24` = `177` tests, **MatchUp** Apple App Store `5.0★`), piso tipográfico `>= 13px`, targets interactivos `>= 44×44px` (`48px` mobile).

---

## 0. Qué Resuelve Esta Entrega (`r7 → r8`)

Este documento define **un sistema de página único de 4 Actos / 5 Anclas** con **3 conceptos visuales realmente distintos** que Tobías puede alternar en vivo desde un **Concept Switcher Menu** (o mezclar Hero de un concepto + Proyectos de otro mediante URL `?concept=a|b|c` o `?hero=a&work=c`):

1. **Elimina todo "AI Slop" de `r7`:** Se eliminan las dos secciones de texto redundantes de `100vh` (`How I Help Teams` con círculos `1→4` y `Core Stack` con 4 rectángulos `2×2` idénticos), los eyebrows tracked all-caps y el Hero vacío al `65%`.
2. **Sube las apps reales al primer pantallazo y suma prueba comercial:** Todo concepto muestra producto/evidencia real above-the-fold en el Hero, encierra cada proyecto con **líneas divisorias horizontales arriba y abajo**, integra un **fondo de pantallas reales moviéndose suave ("chill")** aislado con `RepaintBoundary`, incorpora **MatchUp (`Apple App Store · 5.0★`)** y remata con un bloque `#contact` accesible.
3. **Integra `WideSectionChevron` + Snap Scroll inteligente en Desktop:** Una flecha ancha y baja (`56×12px`) debajo de cada sección para avanzar con un click o con scroll suave por sección (sin bloquear scrolling interno en viewports compactos ni móviles).
4. **Arregla las colisiones de `< 960px` y fallos WCAG 2.2:** Reemplaza el `MobileBottomPillDock` flotante por una barra superior fija opaca de `56px` en el layout, corrige foco visible (`>= 3:1`), accesibilidad de teclado en footer, `Semantics(header: true)`, pausa del movimiento y elimina la franja negra superior artificial en `IphoneBezelFrame`.

---

## 1. Arquitectura Global Compartida (Todos los Conceptos)

### 1.1 Mapa de Secciones (4 Actos, 5 Paradas de Scroll Limpias)

El usuario llega primero al **Hero** y pasa **inmediatamente** al primer producto real en el scroll `1` (`100vh` en desktop), sin atravesar `1,800px` de texto repetido:

| Parada | Anchor (`PortfolioSectionId`) | Label Nav | Altura Desktop (`>= 960px`) | Contenido & Rol |
|---|---|---|---|---|
| **0** | `#overview` | `Overview` | `max(viewportH, 680)` (`100vh`) | **Hero (Acto 0)** — Cambia estructuralmente según `heroConcept` (`A`, `B` o `C`). Incluye `WideSectionChevron` abajo. |
| **1** | `#nutrilens` | `NutriLens AI` | `max(viewportH, 680)` (`100vh`) | **Proyecto 1 (Acto 1A)** — Enmarcado con líneas arriba/abajo + fondo chill + demo interactiva (`153 Tests`). Incluye `WideSectionChevron` abajo. |
| **2** | `#setpoint` | `SetPoint` | `max(viewportH, 680)` (`100vh`) | **Proyecto 2 (Acto 1B)** — Enmarcado con líneas arriba/abajo + fondo chill + demo interactiva (`24 Tests`). Incluye `WideSectionChevron` abajo. |
| **3** | `#capabilities` | `Capabilities` | `max(viewportH, 680)` (`100vh`) | **Prueba Comercial + Stack Fusionado (Acto 2)** — Arriba: placa horizontal verificada de **`MatchUp — Apple App Store (5.0★)`**. Abajo: **4 filas indexadas** fusionando `How I Help` + `Core Stack` (cero cards `2×2`, cero círculos `1→4`). Cabe holgado en `1280×720` (`<= 580px` contenido). Incluye `WideSectionChevron` abajo. |
| **4** | `#contact` | `Contact` | Compacta (`~320px–360px` en Desktop, natural en Mobile) | **Cierre Comercial & Footer (Acto 3)** — CTA directo de contratación/email, `GitHub ↗`, `LinkedIn ↗`, links accesibles `>= 44×44px` y micro-chevron invertido `Back to top ↑`. |

### 1.2 Una Sola Ancla Izquierda Unificada (Regla `taste-skill` Pass 4)
Terminar con los 4 márgenes distintos de `r7` (`356 / 396 / 196 / 400px`). En **Desktop `>= 960px`**, todos los bloques de contenido comparten un único contenedor base:
- `maxWidth: 1240.0` centrado en el área útil después del safe-zone izquierdo de la sidebar (`paddingLeft: isWideDesktop ? 120.0 : 100.0`, `paddingRight: isWideDesktop ? 64.0 : 32.0`).
- **Excepción intencional:** Las **líneas divisorias horizontales de proyecto** (`ProjectBoundaryRule`) y los **fondos cinéticos de pantallas** corren **edge-to-edge (`100%` del ancho)** para que el enmarcado editorial se perciba limpio de punta a punta de la pantalla, mientras el contenido interno respeta estrictamente el riel izquierdo único.

---

## 2. Los 3 Conceptos Visuales (`PortfolioConceptId`)

Todos heredan los tokens base de `AppColors` (`#080A0C` canvas, `#F4F6F8` primary ink, `#9AA4B2` secondary, `#34D399` engineering, `#D2F07A` NutriLens, `#C8E652` SetPoint, `Plus Jakarta Sans` + `Inter`), pero **transforman por completo composición, grilla, tratamiento de borde, botón y mecánica del fondo cinético**:

### Matriz Comparativa Rápida

| Dimensión | `A` — Editorial Kinetic Wall | `B` — Swiss Grid / Technical Studio | `C` — Spatial Kinetic Stage |
|---|---|---|---|
| **Referencia / Espíritu** | Directo sobre `media_1794720704549_f171ef24.jpg` + estudio mobile editorial | Manual técnico / Linear / Vercel / Teenage Engineering (`1px` arquitectura ortogonal) | Showcase flagship moderno (Apple / Arc / Stripe Mobile) con profundidad atmosférica |
| **Hero (`#overview`)** | Split asimétrico `54% / 46%`: pitch izquierda + **Live App Deck Switcher** derecha (`NutriLens / SetPoint / MatchUp`) sobre muro diagonal lento | **Grilla técnica `2×2` de punta a punta** con divisores `1px` (`58%` display + `42%` Spec Table interactiva) + strip inferior de 4 métricas tabulares | Header editorial centrado arriba (`maxWidth: 760`) + **Tríptico interactivo de 3 productos abajo** (`NutriLens -6°` · `SetPoint 0°` · `MatchUp 5.0★ +6°`) |
| **Fondo Chill en Proyectos** | **Muro diagonal `-26°`** de 3 columnas contra-desplazándose (`+14 / -16 / +12 px/s`) a **`15%` opacidad** + scrim direccional | **Contact-sheet ortogonal horizontal** (`12 px/s`) desaturado (`~25%` sat, **`14%` opacidad**) acotado dentro de la columna derecha del grid | **2 columnas verticales paralelas** contra-desplazándose (`+14 / -14 px/s`) a **`18%` opacidad** con `ShaderMask` arriba y abajo |
| **Líneas Arriba / Abajo** | Líneas continuas `1px` (`rgba(255,255,255,0.14)`) + tag de coordenada en esquina superior (`01 / NUTRILENS AI`) | Reglas arquitectónicas `1px` sólidas (`#262D38`) + **barra superior de spec** + **divisor vertical `1px`** entre columnas | Hairlines `1px` con **gradiente radial lateral** (`0% -> 24% blanco -> 0%`) + spotlight sutil del color de la app tras el stage |
| **Simetría en Proyectos** | Split `50% / 50%` editorial: narrativa izquierda + 1 iPhone focal + tarjeta secundaria superpuesta + controles `‹ 1/4 ›` | **Alternancia L/R obligatoria**: `NutriLens AI` (Texto IZQ / Stage DER) → `SetPoint` (**Stage IZQ / Texto DER**) | Split `44% / 56%`: columna narrativa izquierda con **espina vertical acento `2px`** + stage multi-columna derecha |
| **Radio de Botones** | `10px` técnico suave | `6px` rectángulo nítido estilo consola | `999px` píldora fluida |

---

### 2.1 Concepto A — `Editorial Kinetic Wall` (`?concept=a`)

> **Cuándo gana:** Es la traducción directa de la referencia de Tobías (`media_1794720704549_f171ef24.jpg`). Impacta visualmente apenas carga la página porque las capturas móviles reales aparecen en perspectiva diagonal suave detrás del Hero y los proyectos sin saturar la lectura.

#### Wireframe Desktop (`1440×900`) — Hero A
```text
+---------------------------------------------------------------------------------+
| [Sidebar]  (fondo diagonal -26° muy sutil 12% + vignette oscura izq 95%->45%)  |
|  [TG]                                                         [A·Wall|B|C | Mix]|
|  [NL]    Tobías Gutiérrez — Mobile Software Engineer · GMT-3                    |
|  [SP]                                     +-----------------------------------+ |
|  [EQ]    Production Flutter apps,         | [NutriLens] [SetPoint] [MatchUp★] | |
|  [@ ]    with backend & AI built in.      |                                   | |
|                                           |       +-------------------+       | |
|          I build iOS, Android, and Web    |       |  Preview Frame    |       | |
|          products end to end—combining    |       |  (Interactive     |       | |
|          60fps Flutter UI, Firebase,      |       |   screen / proof) |       | |
|          AI proxies, and automated QA.    |       +-------------------+       | |
|                                           |  153 Tests · Cloudflare Edge API  | |
|          [ Explore Work ↓ ]               |  [ Open Live Demo ↗ ]  Jump ↓     | |
|          [tobigutierrez26@gmail.com |Copy]+-----------------------------------+ |
|          GitHub ↗   LinkedIn ↗                                                  |
|                                                                                 |
|          App Store Shipped (5.0★) · 177 Automated Tests · US East & EU Overlap  |
|                                  \_________/  (56x12px WideSectionChevron)      |
+---------------------------------------------------------------------------------+
```

#### Wireframe Desktop (`1440×900`) — Proyecto en Concepto A (`#nutrilens` / `#setpoint`)
```text
================================================================================== 1px top hairline
01 · NUTRILENS AI                              MOBILE VISION & SERVERLESS EDGE  || [⏸ Pause bg]
  (Detrás de toda la lámina: 3 pistas diagonales -26° moviéndose lento al 15% + scrim 94% izq)

  [NL]  NutriLens AI                                    +---------------+
        Pantry-First Meal & Macro Tracker               |               |  +----------+
                                                        |   Foreground  |  | Tucked   |
        Calorie trackers fail on home-cooked meals—     |    iPhone     |  | 2nd card |
        forcing manual weighing instead of matching     |    Bezel      |  | (+16px X |
        the actual brands in your kitchen.              | (Hover blur → |  |  -18px Y)|
                                                        |  Launch Demo) |  +----------+
        • 3-Mode Pantry Scanning: Barcode (Open Food    |               |
          Facts v2 + Gemini), pack photo, label OCR.    +---------------+
        • Home-Cooked Match & Score: Gemini Vision       ‹  [1 / 4]  ›   Hover/click → Demo
          cross-references pantry & scores 0–100.
        • Zero-Key Edge Proxy: Cloudflare Worker with
          CORS, allowlists, 16 MB & 30 req/min caps.

        Solo End-to-End · MVVM + Provider · 153 Automated Tests

        [ Open Live Demo ↗ ] (sólido #D2F07A)   [ View Source on GitHub ↗ ]
                                  \_________/
================================================================================== 1px bottom hairline
```

#### Parámetros Técnicos Exactos — `DiagonalScreenWall` (Concepto A)
- **Transformación:** `Transform.rotate(angle: -26 * math.pi / 180)` dentro de un `ClipRect` + `RepaintBoundary` de ancho/alto `1.45×` el contenedor (para evitar esquinas vacías al rotar).
- **Columnas:** `3` columnas paralelas de `156px` de ancho con `18px` de gap entre sí (`mainAxisSpacing: 18px`). En mobile `< 600px`, usar `2` columnas más chicas (`112px` ancho, `12%` opacidad) para no distraer.
- **Tiles de captura:** `AspectRatio(aspectRatio: AppSpacing.phoneAspectRatio)` con `ClipRRect(borderRadius: 18)` y borde `1px rgba(255,255,255,0.10)`. Usar `Image.asset(..., cacheWidth: 260, filterQuality: FilterQuality.low)`.
- **Velocidad "chill":** Columna 0: `+14 px/s` hacia abajo; Columna 1: `-16 px/s` hacia arriba; Columna 2: `+12 px/s` hacia abajo. Calculado con `AnimationController.repeat(period: Duration(seconds: 32))` + módulo sobre la altura de un ciclo completo (`tileHeight + gap`).
- **Scrim de legibilidad obligatorio:** Superponer encima del `RepaintBoundary` diagonal un `Container` (`IgnorePointer`) con:
  - Gradiente horizontal `LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, stops: [0.0, 0.48, 0.85, 1.0], colors: [Color(0xF5080A0C), Color(0xEC080A0C), Color(0x88080A0C), Color(0xD9080A0C)])`.
  - Viñeta vertical superior/inferior (`28px` fade hacia `#080A0C` pegado a las líneas divisorias).
  - Opacidad global de las capturas antes del scrim: **`0.34`** (luego atenuado por el scrim da `~15–18%` visible detrás de la zona derecha y `< 3%` bajo el texto blanco `#F4F6F8`). Resultado: **legibilidad AAA + profundidad cinematográfica real**.

---

### 2.2 Concepto B — `Swiss Grid / Technical Studio` (`?concept=b`)

> **Cuándo gana:** Si Tobías quiere proyectar máxima madurez de **Staff / Senior Systems Engineer** estilo **Linear / Vercel**. Elimina cualquier rastro de "landing con tarjetitas" y convierte la página en una hoja de especificación arquitectónica viva donde cada línea `1px` organiza la mirada.

#### Wireframe Desktop (`1440×900`) — Hero B
```text
+---------------------------------------------------------------------------------+
| [Sidebar]  ENG-PORTFOLIO // BUENOS AIRES (GMT-3)     [ B·Grid | A | C | Mix ]   |
+------------------------------------------------------+--------------------------+
|                                                      | SELECT SHIPPED PROOF     |
|  Tobías Gutiérrez — Mobile Software Engineer         |--------------------------|
|                                                      | > 01 NutriLens AI [153T] |
|  Flutter systems                                     |   02 SetPoint     [ 24T] |
|  shipped end to end.                                 |   03 MatchUp      [5.0★] |
|                                                      |--------------------------|
|  I architect and ship production iOS, Android,       |  +--------------------+  |
|  and Web apps solo—UI at 60fps, Firebase &           |  |  Preview / Proof   |  |
|  Cloudflare backends, and automated test suites.     |  |  (switches live    |  |
|                                                      |  |   on click/hover)  |  |
|  [ View Selected Work ↓ ]                            |  +--------------------+  |
|  [ tobigutierrez26@gmail.com | Copy ]                |  MVVM · Cloudflare Proxy |
|  GitHub ↗   LinkedIn ↗                               |  [ Open Live Demo ↗ ]    |
+------------------------------------------------------+--------------------------+
| PLATFORMS: iOS · Android · Web  |  CLOUD: Firebase · Workers  |  QA: 177 Tests  |
+---------------------------------------------------------------------------------+
                                  \_________/
```

#### Wireframe Desktop (`1440×900`) — Proyectos B con Alternancia `L/R` y Filmstrip Ortogonal
- **`#nutrilens` (`PROJECT 01`):** Columna IZQ Narrativa (`46%`) `|` Columna DER Stage (`54%`).
- **`#setpoint` (`PROJECT 02`):** **INVERTIDO!** Columna IZQ Stage (`54%`) `|` Columna DER Narrativa (`46%`).
```text
================================================================================== 1px #262D38
 PROJECT 01 // NUTRILENS AI          MVVM + PROVIDER          153 TESTS       [↗]
---------------------------------------------------------------------------------- 1px #1E242E
                                       |  (Horizontal orthogonal filmstrip strip
  [NL] NutriLens AI                    |   moving slowly at 12px/s across this cell,
       Pantry-First Meal Tracker       |   desaturated 25% + 14% opacity behind...)
                                       |
  THE GAP                              |             +---------------+
  Calorie trackers fail on home-cooked |             |   Crisp Upright|
  meals—forcing manual weighing        |             |    Bezel Frame |
  instead of matching kitchen brands.  |             |  (Hover blur → |
                                       |             |   Launch Demo) |
  ARCHITECTURE                         |             +---------------+
  01  3-Mode Pantry Scanning           |
  02  Pantry-Matched Gemini Vision     +------------------------------------------
  03  Cloudflare Worker (30 req/min)   | [01] [02] [03] [04]   [⏸]  Launch Demo ↗
                                       |
  [ Open Live Demo ↗ ]  GitHub ↗       |
================================================================================== 1px #262D38
                                  \_________/
```

#### Parámetros Técnicos Exactos — `HorizontalFilmstripBackdrop` (Concepto B)
- **Ubicación:** Estricto dentro de la celda Stage (`ClipRect` + `RepaintBoundary`, nunca sangra sobre el texto de la columna vecina gracias al divisor vertical `1px` `#1E242E`).
- **Movimiento:** 2 filas horizontales paralelas de pantallas (`~125px` ancho × `270px` alto, gap `14px`): fila superior avanza `-12 px/s` (izquierda), fila inferior `+10 px/s` (derecha).
- **Tratamiento cromático:** `ColorFiltered` con matriz de desaturación suave (`25%` saturación) + opacidad **`0.15`**, sin rotación, dando efecto contact-sheet de arquitectura detrás del `IphoneBezelFrame` central opaco.
- **Controles:** En la barra inferior de la celda Stage (`height: 44px`, `borderTop: 1px #1E242E`), botones numéricos tabulares `[01] [02] [03] [04]` + botón `Pause / Play` (`>= 44×44px`).

---

### 2.3 Concepto C — `Spatial Kinetic Stage` (`?concept=c`)

> **Cuándo gana:** Si Tobías quiere el look de **producto consumer mobile contemporáneo** (como los sitios de lanzamiento de apps top en App Store / Product Hunt). Rompe por completo el esquema izquierda-derecha en el Hero colocando un **tríptico interactivo horizontal** de las 3 apps abajo del headline, y usa **2 columnas verticales contra-desplazándose ("parallax columns")** en cada proyecto.

#### Wireframe Desktop (`1440×900`) — Hero C
```text
+---------------------------------------------------------------------------------+
| [Sidebar]                                                   [ C·Stage|A|B | Mix ]|
|                                                                                 |
|               Tobías Gutiérrez — Mobile Software Engineer · GMT-3               |
|                                                                                 |
|                        Flutter & cloud apps,                                    |
|                        shipped to real users.                                   |
|                                                                                 |
|        Solo end-to-end delivery: 60fps iOS/Android UI, Firebase backends,       |
|        Cloudflare AI proxies, and automated test suites.                        |
|                                                                                 |
|     ( Explore Work ↓ )   ( tobigutierrez26@gmail.com · Copy )   GitHub ↗ · In ↗ |
|                                                                                 |
|     +--------------------+   +--------------------+   +--------------------+    |
|     |  NutriLens AI      |   |  SetPoint          |   |  MatchUp           |    |
|     |  [nutrilens_dash]  |   |  [setpoint_map]    |   |  Apple App Store   |    |
|     |  153 Tests · AI    |   |  24 Tests · Maps   |   |  5.0★ · Client App |    |
|     +--------------------+   +--------------------+   +--------------------+    |
|        (tilted -4°)               (upright 0°)             (tilted +4°)         |
|                                  \_________/                                    |
+---------------------------------------------------------------------------------+
```
*(En `1280×720`, el Hero C reduce `heroDisplay` a `48px` y el tríptico a `230px` de alto para entrar entero arriba de `WideSectionChevron` con `0px` de clipping).*

#### Wireframe Desktop (`1440×900`) — Proyecto en Concepto C (`#nutrilens` / `#setpoint`)
```text
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 1px Gradient Hairline Divider ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  [NL]  NutriLens AI                                 +---[Col 1 ↓]---+ +---[Col 2 ↑]---+
        Pantry-First Meal & Macro Tracker            | (ShaderMask   | |   ShaderMask  |
                                                     |  fade top/btm)| |  18% opacity  |
  |  Calorie trackers fail on home-cooked meals—     |       +---------------+         |
  |  forcing manual weighing instead of matching     |       |               |         |
  |  the actual brands in your kitchen.              |       |  Foreground   |         |
  (2px vertical spine in #D2F07A)                    |       |  Hero iPhone  |         |
                                                     |       |  (Interactive)|         |
  • 3-Mode Pantry Scanning (Barcode / OCR / Vision)  |       +---------------+         |
  • Pantry-Matched Meals & 0–100 AI Health Score     |  ( < )  • • • •  ( > )  [⏸]     |
  • Cloudflare Worker Proxy (CORS · 30 req/min)      +-------------------------------+

  Solo End-to-End · 153 Unit & Widget Tests

  ( Open Live Demo ↗ ) (pill #D2F07A)   ( View Source on GitHub ↗ )

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 1px Gradient Hairline Divider ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                  \_________/
```

#### Parámetros Técnicos Exactos — `ParallaxColumnsBackdrop` (Concepto C)
- **Ubicación:** Columna derecha (`56%` ancho), detrás del único `IphoneBezelFrame` protagonista.
- **Columnas:** 2 columnas paralelas verticales (`~148px` ancho c/u, gap `16px`) moviéndose en sentidos opuestos: columna IZQ sube `-14 px/s`, columna DER baja `+14 px/s`.
- **Máscara de desvanecimiento suave (`ShaderMask`):** Aplicada a las 2 columnas para que las pantallas se disuelvan orgánicamente a `0%` de opacidad antes de tocar las líneas divisorias superior e inferior (`stops: [0.0, 0.16, 0.84, 1.0]`).

---

## 3. Acto 2 & Acto 3 Compartidos (`#capabilities` + `MatchUp 5.0★` + `#contact`)

Para que Tobías compare **manzanas con manzanas** en Hero y Proyectos sin volver a inflar la página con 1,800px repetidos, `#capabilities` y `#contact` reemplazan por completo a `HowIHelpSection` y `EngineeringApproachSection` usando una estructura editorial limpia (adaptando solo bordes/radios de botón/hairline según el concepto activo):

### 3.1 `#capabilities` — Client Proof (`MatchUp`) + 4 Index Rows (`<= 580px` altura total en Desktop)

#### Banda Superior — Prueba Comercial (`MatchUp — Apple App Store 5.0★`)
Contenedor horizontal único (`padding: 18px 24px`, `#101318`, `1px` borde según concepto — `10px` en A, `6px` en B, `16px` en C):
- **Izquierda (`flex: 60`):**
  - Etiqueta tabular (`13px`, `#34D399` engineering green): `CLIENT PRODUCTION DELIVERY  ·  APPLE APP STORE (5.0★)`
  - Título (`20px` Bold Plus Jakarta Sans): `MatchUp — Cross-Platform Social Sports App (iOS & Android)`
  - Summary (`14px` Inter `#9AA4B2`, max 2 líneas): `Built solo from Figma specs: Google & Phone OTP Auth, real-time Firestore chat, Google Maps custom markers, FCM & APNs push notifications, Cloud Functions, deep linking, and AdMob monetization.`
- **Derecha (`flex: 40`, alineado en 2 líneas limpias sin saturar de pill chips):**
  - `Platforms: iOS (App Store 5.0★) · Android`
  - `Stack: Flutter · Provider · Firebase · Google Maps · AdMob`

*(Nota de asset futuro: En cuanto Tobías exporte capturas en alta resolución de MatchUp según [`upwork/matchup-app.md`](file:///c:/Users/ik/.gemini/antigravity/scratch/mobile_sprint/upwork/matchup-app.md), el Hero Switcher de Concepto A/B y el Tríptico de Concepto C mostrarán la tarjeta comercial `App Store 5.0★` lista para cambiar por captura real).*

#### Banda Principal — 4 Filas Indexadas (`Capabilities & Stack`)
Reemplaza las 4 cards `2×2` y el stepper `1→4` con **4 filas limpias separadas por `1px borderHairline`** (hover `#101318`, sin cajas rectangulares apiladas):

| # | Columna Título (`28%`) | Columna Ingeniería (`44%`) | Columna Tech Specs (`28%`, alineada derecha) |
|---|---|---|---|
| **01** | `Cross-Platform UI & Native` | `Pixel-accurate Flutter apps for iOS, Android, and Web built from Figma specs at 60fps.` | `Flutter · Dart 3 · Swift/Kotlin · Figma` |
| **02** | `Firebase & Cloud Backends` | `Production auth, real-time Firestore streams, Cloud Functions, Storage rules, and FCM / APNs push delivery.` | `Firebase · Firestore · Functions · FCM/APNs` |
| **03** | `AI & Serverless Edge APIs` | `Cloudflare Worker proxies keeping LLM API keys off client bundles with Origin CORS, allowlists, and rate limits.` | `Gemini Vision · Cloudflare Workers · REST` |
| **04** | `Architecture, QA & Overlap` | `Clean Architecture (BLoC / Riverpod / MVVM), CI/CD pipelines, 177 automated tests, and direct GMT-3 overlap (EN/ES).` | `BLoC / Riverpod · GitHub Actions · 177 Tests` |

*(Verificación tipográfica de `r7`: `"CI/CD pipelines"` evita el corte feo `"CI/ / CD"` de `r7`, y el subtítulo de sección `"Full product ownership from architecture to store release—no separate backend hire required."` se lee limpio sin palabra huérfana `"release."`).*

### 3.2 `#contact` — Banda de Cierre Comercial & Footer Accesible (`~320px`)

```text
================================================================================== 1px hairline top
  Need a mobile engineer who owns the whole stack?
  Available for Upwork MVPs, Figma-to-Flutter builds, and remote product teams (GMT-3 · EN/ES).

  [ Copy tobigutierrez26@gmail.com ] (46px primary)    [ Open Email App ↗ ]    GitHub ↗   LinkedIn ↗
---------------------------------------------------------------------------------- 1px hairline
  Tobías Gutiérrez — Mobile Software Engineer                    [ ^ Back to top ] (44x44px hit)
==================================================================================
```
- **Regla WCAG crítica en `#contact`:** Cada link (`GitHub ↗`, `LinkedIn ↗`, `Back to top`) debe usar `FocusableActionDetector` + `Semantics(link: true)` / `Semantics(button: true)` con área táctil mínima **`44×44px`** y anillo de foco visible `2px` (`#34D399` / `#F4F6F8`).

---

## 4. Especificación de Componentes Nuevos y Fixes Críticos

### 4.1 `ConceptSwitcherMenu` + Soporte `?concept=` / `?hero=` / `?work=`
- **Estado (`PortfolioConceptController extends ChangeNotifier`):**
  - `PortfolioConceptId heroConcept` (default: `PortfolioConceptId.editorialWall`)
  - `PortfolioConceptId workConcept` (default: `PortfolioConceptId.editorialWall`)
  - `bool isMixExpanded` (default: `false`)
  - `bool get isMixed => heroConcept != workConcept`
  - Métodos:
    - `selectUnifiedConcept(PortfolioConceptId id)` -> setea `heroConcept = id`, `workConcept = id`, cierra mix si quiere o mantiene limpio, sincroniza URL `?concept=a|b|c`.
    - `setHeroConcept(PortfolioConceptId id)` / `setWorkConcept(PortfolioConceptId id)` -> actualiza individualmente y sincroniza URL (`?hero=a&work=c` si difieren, o `?concept=a` si coinciden).
- **Parsing inicial de URL (en `app.dart` / `main.dart`):**
  - Leer `Uri.base.queryParameters`:
    - `concept`: `a` -> `editorialWall`, `b` -> `swissGrid`, `c` -> `kineticStage`.
    - `hero` / `work`: pisan individualmente `heroConcept` / `workConcept` si son válidos (`a|b|c`).
- **UI Desktop (`>= 960px`):**
  - Posicionado en `Align(alignment: Alignment.topRight)` con `padding: EdgeInsets.only(top: 18, right: 24)` (`RepaintBoundary`).
  - Contenedor `height: 44px`, fondo `Color(0xEB0A0D12)`, borde `1px AppColors.borderFocus`, `borderRadius: 12px`, sombra sutil.
  - Interior:
    - 3 botones segmentados: `A · Wall`, `B · Grid`, `C · Stage` (en `< 1120px`: `A`, `B`, `C`). Si `isMixed`, muestra badge indicador sutil (ej. `A` resaltado con etiqueta `Hero` / `Work` o pill secundario `A+C`).
    - Divisor vertical `1px` (`height: 20px`).
    - Botón `Mix` (`minWidth: 44px`, `height: 44px`): abre popover debajo (`hero: [A][B][C]`, `work: [A][B][C]`, `Sync matching`).
- **UI Mobile / Tablet (`< 960px`):**
  - Va integrado dentro de la **barra superior fija opaca de `56px`** (nunca superpuesto sobre contenido). Muestra a la derecha `[ A | B | C ]` compacto (`40×44px` por tab).

### 4.2 `WideSectionChevron` (Flecha Ancha y Baja)
- **Geometría exacta:**
  - `SizedBox(width: 80, height: 44)` como hitbox interactiva (`MouseRegion` + `FocusableActionDetector` + `Semantics(button: true)`).
  - `CustomPaint(size: Size(56, 12))` centrado adentro:
    - Trazo `M 2 2 -> L 28 10 -> L 54 2` (o invertido `M 2 10 -> L 28 2 -> L 54 10` en `#contact`), `strokeWidth: 1.5`, `StrokeCap.round`, `StrokeJoin.round`.
  - Color base: `AppColors.textMuted` (`#7A8594`, `5.30:1` sobre `#080A0C` — cumple WCAG 1.4.11 UI `>= 3:1`).
  - Hover / Focus: color pasa a `AppColors.textPrimary` (`#F4F6F8`), `AnimatedSlide` / transform `+3px` vertical en `180ms Curves.easeOutCubic`, y en foco por teclado muestra `outline` de `2px` en `activeAccentColor` con `borderRadius: 8px`.

### 4.3 Scroll Inteligente por Sección en Desktop (`>= 960px`)
- Reemplazar cálculo fijo `section.index * _sectionHeight` por posiciones medidas reales de `GlobalKey` (con fallback a `sectionHeight` mientras monta) para soportar correctamente `#contact` (`~340px` al final, alineado a `maxScrollExtent`).
- Wrapper `Listener(onPointerSignal: ...)` alrededor del `SingleChildScrollView` solo cuando `isDesktop && !reduceMotion`:
  - **Regla anti-secuestro de scroll (Crucial):** Antes de snappear, calcular el `top` y `bottom` de la sección activa respecto al viewport. Si una sección excepcionalmente excede `viewportHeight` (ej. ventana muy baja `< 680px`) y el usuario todavía no llegó al borde de salida de esa sección, **NO interceptar** — dejar fluir el scroll nativo.
  - Cuando el usuario está encajado en una sección que cabe en el viewport y manda impulso de rueda/trackpad (`event.scrollDelta.dy.abs() >= 18.0`) fuera de cooldown (`520ms` mientras `_isSnapAnimating`), animar suavemente a `activeSection + 1` o `activeSection - 1` (`560ms`, `Curves.easeOutCubic`).
  - También agregar soporte de teclado `LogicalKeyboardKey.pageDown` / `pageUp` para saltar limpio entre secciones.

### 4.4 Navegación Responsive Sin Colisiones (`< 960px` vs `>= 960px`)
- **Desktop (`>= 960px`):** Mantener `FloatingPillSidebar` compacto a la izquierda, pero actualizar sus ítems a **5 paradas reales con íconos consistentes** (sin mezclar wireframes ambiguos):
  1. `TG` (`Overview`)
  2. `NL` (`NutriLens AI` — `nutrilens_icon.webp`)
  3. `SP` (`SetPoint` — `setpoint_icon.webp`)
  4. `Capabilities & MatchUp` (ícono wireframe consistente de capas/módulos `1.5px`)
  5. `Contact` (ícono wireframe consistente de sobre/mail `1.5px`)
  - Agregar `FocusNode` + anillo visible `2px` en `SidebarNavItem` para cumplir WCAG 2.4.7.
- **Mobile & Tablet (`< 960px`) — ELIMINAR `MobileBottomPillDock` flotante:**
  - En `< 960px`, `PortfolioPage` renderiza:
    ```text
    Column(
      children: [
        MobileTopAppBar(height: 56px, bg: #080A0C, borderBottom: 1px borderHairline),
        Expanded(child: SingleChildScrollView(...)),
      ],
    )
    ```
  - **Presupuesto exacto de ancho en `MobileTopAppBar` (cero overflow hasta `360px`):**
    - **`Tablet (600–959px)`:** Izquierda `[TG]` + links `Overview · Work · Stack · Contact`; derecha `[ A | B | C | Mix ]`.
    - **`Mobile (< 600px, ej. 390×844)`:** Nunca amontonar 4 botones de sección al lado del switcher porque excede `360px`. Usar solo:
      - Izquierda (`Flexible`): `[TG]` (`44×44px`) + **Section Dropdown / Sheet Pill** (`minWidth: 112px`, `height: 44px`, muestra sección activa ej. `Overview ▾`, y al tocar abre popover/sheet con las 5 secciones + toggle opcional de `Mix Hero / Projects`).
      - Derecha: **`[ A | B | C ]` segmented pill** (`3 × 40px` = `128px` ancho total × `44px` hitbox). Suma total `< 325px` → margen seguro en `360px` y `390px`.
  - **Adaptación Responsive por Concepto (`< 600px`):**
    - **Hero A / B / C en `390×844`:** Pitch vertical compacto (padding horizontal `20px`) + CTA `Explore Work ↓` + chip integrado `Email | Copy` en una fila limpia + links `GitHub ↗ · LinkedIn ↗`. Abajo del pitch: Concepto A apila su `HeroAppDeckSwitcher` compacto (`~240px` alto) sobre pared diagonal a `12%` (`2` columnas de `112px`); Concepto B elimina el divisor vertical y apila la tabla spec `01/02/03` con bordes `1px` y strip `2×2`; Concepto C alinea el header a la izquierda y muestra un peek horizontal deslizable de 3 tarjetas (`NutriLens`, `SetPoint`, `MatchUp 5.0★`).
    - **Showcase Mobile (`< 600px`):** Mostrar **1 solo `IphoneBezelFrame` interactivo** (`width: 248px`) con barra de controles debajo (`‹  1 / 4  ›  ·  [Pause]` + botón sólido primario `Open Live Demo ↗` + secundario `GitHub ↗`). Reduce el alto móvil por proyecto de **`~1,800px` a `~880px`**.
    - **Capabilities Mobile (`< 600px`):** Cada fila indexada (`01..04`) apila `Número + Título` -> `Descripción` -> `Tech Specs` verticalmente (nunca tabla horizontal `28/44/28` apretada en `390px`).

### 4.5 Fix del Bezel (`IphoneBezelFrame`) + Rendimiento GPU (`@perf`)
1. **Eliminar corte negro superior en `IphoneBezelFrame`:**
   - Reemplazar `Column([ColoredBox(bgCanvas, topSafeArea), AspectRatio(child)])` por un único `AspectRatio(aspectRatio: AppSpacing.phoneAspectRatio)` donde la imagen/contenido ocupa el screen completo y el Dynamic Island flota como overlay (`Positioned(top: islandTop)`), o permitir `Color statusBarColor` por captura (`AppColors.nutriScaffold` `#F6F8F5` para dashboard/pantry, `AppColors.nutriForestSlot` `#185B47` para scan/analysis, `#FFFFFF` / `#0E1311` según captura de SetPoint) para evitar la franja `#080A0C` cortando UI clara.
2. **Garantía 60fps (`RepaintBoundary` + Viewport Paging):**
   - Toda pared o columna animada vive dentro de su propio `RepaintBoundary`.
   - Pasar `cacheWidth: 260` y `filterQuality: FilterQuality.low` a las imágenes repetidas en los fondos animados (los frames principales en primer plano mantienen resolución nítida completa).
   - **Animación condicional por visibilidad:** Cada fondo animado de sección recibe `isSectionVisible: bool` (activo solo cuando esa sección está dentro de `±1.2 × viewportHeight` del scroll actual) + respeta `reduceMotion || isPausedByUser`. Así nunca corren 3 animaciones invisibles al mismo tiempo.
   - Zero `BackdropFilter` sobre los fondos animados; el único blur queda reservado al estado hover del `IphoneBezelFrame` interactivo en primer plano.
3. **Nota de Assets / Idioma (`PORTFOLIO_PROMPT.md`):**
   - Los fondos cinéticos y mockups utilizan desde el día 1 los 8 `.webp` ya presentes en `proyectos/portfolio/assets/images/` (`nutrilens_dashboard.webp`, `nutrilens_scan.webp`, `nutrilens_analysis.webp`, `nutrilens_pantry.webp`, `setpoint_map.webp`, `setpoint_feed.webp`, `setpoint_filters.webp`, `setpoint_match_doubles.webp`) + `assets/icons/{nutrilens_icon,setpoint_icon}.webp`.
   - **Recordatorio P0 paralelo (para Tobías / captura de assets):** Re-exportar esos 8 `.webp` con datos de muestra 100% en inglés (eliminando `"¡Bienvenido, Tobías!"`, `"Falta 1"`, `"Huevos de campo"`, `"Palta Hass"`) y sumar 1–2 capturas de `MatchUp` cuando estén disponibles; el código diseñado aquí los levantará por drop-in sin cambiar arquitectura.

---

## 5. Deck de Copy Verificado (100% Inglés · Anti-AI-Slop)

*(Listo para copiar en `PortfolioCatalog` — cero buzzwords, cero menciones académicas, métricas reales).*

- **Identity Line:** `Tobías Gutiérrez — Mobile Software Engineer · GMT-3`
- **Hero H1 (Concept A):** `Production Flutter apps,` / `with backend & AI built in.`
- **Hero H1 (Concept B):** `Flutter systems` / `shipped end to end.`
- **Hero H1 (Concept C):** `Flutter & cloud apps,` / `shipped to real users.`
- **Hero Supporting Pitch:** `I build iOS, Android, and Web products solo—combining 60fps Flutter UI, Firebase backends, serverless AI proxies, and automated test suites.`
- **Hero Proof Ledger:** `App Store Shipped (5.0★)` · `177 Automated Tests` · `US East & EU Overlap`
- **Primary CTAs:**
  - Hero: `Explore Work ↓` (o `View Selected Work ↓`) + `tobigutierrez26@gmail.com` (`Copy` integrado) + `GitHub ↗` + `LinkedIn ↗`
  - Showcases: Primario sólido en acento de app **`Open Live Demo ↗`** + secundario **`View Source on GitHub ↗`** + Hover overlay corto en 1 sola línea: **`Launch Live Demo ↗`** (reemplaza `"Try Live Interactive / App ↗"`).
- **MatchUp Client Proof Strip (`#capabilities`):**
  - Badge/Label: `CLIENT PRODUCTION DELIVERY · APPLE APP STORE (5.0★)`
  - Title: `MatchUp — Cross-Platform Social Sports App (iOS & Android)`
  - Summary: `Built solo from Figma specs: Google & Phone OTP Auth, real-time Firestore chat, Google Maps custom markers, FCM & APNs push notifications, Cloud Functions, deep linking, and AdMob monetization.`
- **Capabilities Section Header:**
  - Title: `Capabilities & Stack`
  - Subtitle: `Full product ownership from architecture to store release—no separate backend hire required.`
- **Closing Contact Band (`#contact`):**
  - Heading: `Need a mobile engineer who owns the whole stack?`
  - Subcopy: `Available for Upwork MVPs, Figma-to-Flutter builds, and remote product teams (GMT-3 · EN/ES).`
  - Primary CTA: `Copy tobigutierrez26@gmail.com` · Secondary: `Open Email ↗` · `GitHub ↗` · `LinkedIn ↗`

---

## 6. Checklist de Aceptación para `@coder` y `@perf`

- [ ] Enum `PortfolioConceptId` (`editorialWall`, `swissGrid`, `kineticStage`) + controlador conectado a URL (`?concept=a|b|c`, `?hero=a|b|c`, `?work=a|b|c`) sin recargar la página.
- [ ] `ConceptSwitcherMenu` visible arriba a la derecha en desktop (con soporte de **Mix Hero/Work**) y dentro de la barra superior fija opaca de `56px` en `< 960px` (cero `MobileBottomPillDock` tapando contenido).
- [ ] Hero (`#overview`) y Showcases (`#nutrilens`, `#setpoint`) implementan visualmente las **3 variantes reales** (`A`, `B`, `C`), todas con **líneas divisorias arriba y abajo** en proyectos y **fondo chill animado con `RepaintBoundary` + `cacheWidth` + pause + pausa fuera de viewport**.
- [ ] `WideSectionChevron` (`56×12px` visual dentro de hitbox `80×44px`) en cada sección + snap scroll inteligente en desktop que nunca traba viewports bajos.
- [ ] Secciones `HowIHelpSection` y `EngineeringApproachSection` consolidadas en `CapabilitiesSection` (con placa **`MatchUp 5.0★`** + 4 filas indexadas) + nuevo `ClosingContactSection` (`#contact`), manteniendo 1 ancla izquierda consistente.
- [ ] `IphoneBezelFrame` sin corte negro superior artificial + controles `‹ / › / Pause` + hover pill en 1 línea (`Launch Live Demo ↗`).
- [ ] WCAG 2.2 AA completo: `2px` focus ring visible al tabular (`PortfolioActionButton`, `SidebarNavItem`, `WideSectionChevron`, `ConceptSwitcherMenu`), `_FooterLink` focuseable con `Semantics(link: true)` y `>= 44×44px`, `Semantics(header: true)` en H1/H2.
- [ ] Tests unitarios/widget (`flutter test` 100% pass) cubriendo switcher `A/B/C`, mix `?hero=&work=`, `WideSectionChevron`, pausa/reduced-motion del fondo animado, zero overflow en `1440×900`, `1280×720`, `768×1024`, `390×844` + `flutter analyze` (`0 issues`) + `?v=r8` + verificación `@perf` (`60fps`, `0` errores de consola).
