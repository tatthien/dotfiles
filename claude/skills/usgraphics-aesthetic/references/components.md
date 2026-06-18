# US Graphics Aesthetic DS — Token & Component Reference

Specifics for composing the design system. The canonical CSS is
`assets/usgraphics-aesthetic.css`; this file explains *how to use* what's in it.

## Contents
1. Tokens (palette, semantic aliases, type, space, lines)
2. Component anatomy & examples
3. Re-theming recipe

---

## 1. Tokens

All decisions live in `:root` custom properties so a page can re-theme without
editing components. Prefer the **semantic aliases** over raw spot colors in
page-specific CSS — that's what keeps re-theming a one-liner.

### Palette
| Token | Hex | Role |
|---|---|---|
| `--us-bg` | `#EEEEEE` | gray surround behind the sheet |
| `--us-paper` | `#FFFFFF` | the sheet / cards / cells |
| `--us-fill` | `#EDEDED` | gray fill — table headers, button rests |
| `--us-fill-2` | `#F7F7F7` | faint zebra fill / hover tint |
| `--us-ink` | `#000000` | primary ink (true black) |
| `--us-ink-soft` | `#444444` | secondary text |
| `--us-ink-mute` | `#8A8A8A` | footnotes, disabled, gray UI text |
| `--us-line` | `#CCCCCC` | hairline borders / table cells |
| `--us-line-strong` | `#000000` | heavy frame / emphasis borders |
| `--us-blue` | `#002DCE` | hyperlinks (usgraphics link blue) |
| `--us-green` | `#137752` | "go" buttons, PROD / status tags (usgraphics success) |
| `--us-amber` | `#FFB700` | primary action (black text on gold) |
| `--us-red` | `#E7040F` | alerts, NEW badge (usgraphics error red) |
| `--us-red-bright` | `#FF4136` | active-tab dot / live indicator |

### Semantic aliases (override these to re-theme)
| Alias | Default | Meaning |
|---|---|---|
| `--us-accent` | blue | links / accent |
| `--us-positive` | green | go / ok / live / PROD |
| `--us-negative` | red | alert / stop / error |
| `--us-primary` | amber | the single primary call-to-action |

### Type
System-ui sans is the primary role; monospace is reserved for code. Headings
differ by weight/size, not family.
- `--us-sans` — `system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif` (body, headings, labels, controls)
- `--us-mono` — `ui-monospace, "SF Mono", Menlo, Monaco, Consolas, monospace` (only `code`/`pre`, the `.us-mono` utility, and `.us-kbd`)
- Base body is `13.5px / 1.5`. `.us-h1` 22px, `.us-h2` 16px, `.us-h3` 13.5px — all `font-weight: 700`.

### Space / lines / depth
- Space: `--us-space-1`(6) … `--us-space-5`(56) — tight by design.
- Radius: `--us-radius`(0) everywhere — the sheet is square too. `--us-radius-sheet`
  remains defined for back-compat but is no longer applied.
- `--us-border` (1px `--us-line`, gray hairline), `--us-border-ink` (1px black),
  `--us-border-bold` (1.5px black — the button stroke, matching usgraphics' `.1rem`).
- `--us-shadow` (`2px 2px #ddd`) / `--us-shadow-strong` (`2px 2px #bbb`) — the
  tight, zero-blur flat-gray drop shadow: `--us-shadow` on the sheet, tables, and
  tabs; `--us-shadow-strong` on buttons. The only shadow in the system; never
  substitute a soft/blurred one.
- `--us-ease` (90ms linear — quiet, snappy; no easing curves).

---

## 2. Component anatomy

### Sheet & masthead
```html
<div class="us-sheet">
  <header class="us-masthead">
    <span class="title">U.S. Graphics Company</span>
  </header>
  …
</div>
```
`.us-sheet` is the square, `#888`-hairline-bordered white page on the gray body,
sitting on a flat `2px 2px` shadow (exactly like usgraphics' `body`). For a
flush, full-bleed layout use `.us-wrap` instead (no frame, no surround). The
masthead is just the page/company name in bold — there is no colorbar.

### Navigation (tab strip)
```html
<nav class="us-nav">
  <a class="us-tab active" href="#">Office</a>
  <a class="us-tab" href="#">Products</a>
  <a class="us-tab" href="#">Catalog</a>
</nav>
```
Each `.us-tab` is a square, hairline-bordered button on a flat `2px 2px` gray
shadow; on hover it inverts to a solid black field with white ink. The `.active`
one keeps a white field, gains bold weight, and shows a **red dot** before its
label. Works as `<a>` or `<button>`.

### Section label, headings & rules
```html
<section class="us-section">
  <p class="us-label">Notes <span class="arr"><a href="#">Archive →</a></span></p>
  <hr class="us-rule is-ticked" />
  <h2 class="us-h2">Bare Metal vs. Virtualization</h2>
  <p class="us-lead">Supporting copy in mono, like the rest of the page.</p>
  <hr class="us-rule is-dotted" />
</section>
```
`.us-label` is a small **bold** marker that titles a block; `.arr` styles a
trailing blue link (`Archive →`). Three rules: `.us-rule` (solid hairline),
`.is-dotted` (section divider), `.is-ticked` (the heavier ruler/measure divider
— good directly under a primary label).

### Definition block
```html
<p class="us-def"><b>Graphics</b> — visual representation of information, as in
  graphic art and illustration, in design and manufacture; relentlessly pursuing
  accurate and truthful interpretation.</p>
```
The italic dictionary motif: bold term, em-dash, italic gloss, with a black
left border. Use for a single framing definition near the top, not for body
copy.

### Tables — the core information surface
```html
<!-- key/value spec table -->
<table class="us-table is-keyed">
  <tbody>
    <tr><td>Name</td><td>Neil Panchal</td></tr>
    <tr><td>Occupation</td><td>Proprietor, U.S. Graphics Company</td></tr>
    <tr><td>Employer</td><td><a href="#">U.S. Graphics Company</a></td></tr>
  </tbody>
</table>

<!-- columned data table with a header row -->
<table class="us-table">
  <thead>
    <tr><th>Date</th><th>Title</th><th>Link</th></tr>
  </thead>
  <tbody>
    <tr>
      <td>2026-05-16</td>
      <td>Baremetal vs. Proxmox vs. ESXi Geekbench Scores</td>
      <td><a class="us-btn is-go" href="#">Read →</a></td>
    </tr>
  </tbody>
</table>
```
`<thead>` rows get the gray fill automatically. `.is-keyed` makes the first
column a bold gray label (for spec/property sheets). Rows tint on hover. When
you have facts to present, reach for a table before prose — that's the register.

### Ruled list (the "design philosophy" motif)
```html
<ul class="us-list">
  <li>Emergent over prescribed aesthetics.</li>
  <li>Expose state and inner workings.</li>
  <li>Dense, not sparse.</li>
  <li>Performance <em>is</em> design.</li>
</ul>
```
Each `<li>` is a hairline-ruled row inside a bordered box. Use for enumerated
principles, options, or any flat set that isn't quite a table.

### Cards, figures & grids
```html
<div class="us-grid-4">
  <div class="us-card is-hover">SwissMicros</div>
  <div class="us-card is-hover">Machine Universal</div>
  <div class="us-card is-hover">Function Office</div>
  <div class="us-card is-hover">Made in Democracy</div>
</div>

<figure class="us-fig">
  <div class="body">HAL9000 EXABYTE</div>
  <figcaption>FIG. 1 — type specimen</figcaption>
</figure>
```
`.us-card` is a black-bordered cell; add `.is-hover` for a fill-tint when it's
clickable. `.us-fig` frames an exhibit with a `<figcaption>` (caption it like an
engineering plate: `FIG. 1 — …`). Grids are `.us-grid-2/3/4`, responsive down
to one column.

### Tags, badges & build readout
```html
<span class="us-tag">AZCC ID: 23616171</span>
<span class="us-badge">New!</span>

<!-- the footer build readout: green status + bordered version -->
<span class="build">
  <span class="us-tag is-prod">PROD</span>
  <span class="us-tag is-version">V2.17.4</span>
</span>
```
`.us-tag` is a square-cornered bordered fact chip. `.is-prod` makes it a solid
green status block; `.is-version` is its bordered partner for a build number.
`.us-badge` is the red uppercase alert marker — use rarely, for genuinely new or
urgent things.

### Buttons
```html
<a class="us-btn" href="#">Secondary →</a>
<a class="us-btn is-primary" href="#">Inquiry →</a>   <!-- amber, black ink -->
<a class="us-btn is-go" href="#">Read →</a>           <!-- green, white ink -->
<button class="us-btn" disabled>Unavailable</button>
```
Square-cornered, mono, with a 1.5px black stroke and a flat `2px 2px` gray
shadow. The default button inverts to a solid black field (white ink) on hover;
coloured variants keep their fill and just darken. Usually carry a trailing `→`.
`.is-primary` is the single gold/amber call-to-action per view; `.is-go` is the
affirmative/"open" action (the green `Read →` button used in table rows).

### Callout
```html
<div class="us-callout is-alert"><b>Notice:</b> we're not accepting consignments.</div>
```
A boxed note with a thick colored left border. `.is-alert` = red, `.is-go` =
green, default = black. Use sparingly for the one line a reader must not miss.

### Footer
```html
<footer class="us-footer">
  <span>© 2026 U.S. Graphics, LLC · All rights reserved · Made in U.S.A.</span>
  <span class="build">
    <span class="us-tag is-prod">PROD</span>
    <span class="us-tag is-version">V2.17.4</span>
  </span>
</footer>
```
Uppercase gray mono, separated from the body by a dotted rule. The `.build`
pair seam-joins the status tag and version readout into one unit.

---

## 3. Re-theming recipe

To shift the whole page's accent without touching components, redefine the
aliases in a local `:root` placed **after** the pasted design system:

```html
<style>
  /* …pasted assets/usgraphics-aesthetic.css… */

  /* page override: a "terminal/amber-monitor" variant */
  :root {
    --us-accent: #c77b1a;     /* amber links */
    --us-positive: #c77b1a;
    --us-primary: #1f7a3d;    /* swap primary to green */
  }
</style>
```

Because every component reads `--us-accent` / `--us-positive` /
`--us-negative` / `--us-primary`, this re-skins links, go-buttons, PROD tags,
the active-tab dot, and the primary action in one move. Avoid editing the
component rules directly — that's how a design system rots.

Keep the discipline even when re-theming: **one job per spot color, system-ui
type (mono only for code), square corners, dense and tabular.** Those are what
make it read as US Graphics rather than generic.
