# US Graphics Aesthetic — Token & Component Reference

How to use what's in `assets/usgraphics-aesthetic.css`. Prefer the semantic
aliases over raw spot colors in page CSS — that keeps re-theming a one-liner.

## 1. Tokens

### Palette
| Token | Hex | Role |
|---|---|---|
| `--us-bg` | `#EEEEEE` | gray surround behind the sheet |
| `--us-paper` | `#FFFFFF` | sheet / cards / cells |
| `--us-fill` | `#EDEDED` | gray fill — table headers, button rests |
| `--us-fill-2` | `#F7F7F7` | zebra fill / hover tint |
| `--us-ink` | `#000000` | primary ink (true black) |
| `--us-ink-soft` | `#444444` | secondary text |
| `--us-ink-mute` | `#8A8A8A` | footnotes, disabled, gray UI text |
| `--us-line` | `#CCCCCC` | hairline borders / table cells |
| `--us-line-strong` | `#000000` | heavy frame / emphasis borders |
| `--us-blue` | `#002DCE` | hyperlinks |
| `--us-green` | `#137752` | "go" buttons, PROD / status tags |
| `--us-amber` | `#FFB700` | primary action (black text on gold) |
| `--us-red` | `#E7040F` | alerts, NEW badge |
| `--us-red-bright` | `#FF4136` | active-tab dot / live indicator |

### Semantic aliases (override these to re-theme)
`--us-accent`→blue (links) · `--us-positive`→green (go/ok/live/PROD) ·
`--us-negative`→red (alert/error) · `--us-primary`→amber (single CTA).

### Type
- `--us-sans` — `system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif` (body, headings, labels, controls)
- `--us-mono` — `ui-monospace, "SF Mono", Menlo, Monaco, Consolas, monospace` (only `code`/`pre`, `.us-mono`, `.us-kbd`)
- Base `13.5px/1.5`. `.us-h1` 22px, `.us-h2` 16px, `.us-h3` 13.5px — all `font-weight:700`.

### Space / lines / depth
- Space `--us-space-1`(6) … `--us-space-5`(56). Radius `--us-radius`(0) everywhere.
- `--us-border` (1px gray), `--us-border-ink` (1px black), `--us-border-bold` (1.5px black, button stroke).
- `--us-shadow` (`2px 2px #ddd`, sheet/tables/tabs) / `--us-shadow-strong` (`2px 2px #bbb`, buttons) — the only shadow; never soft/blurred.
- `--us-ease` (90ms linear).

---

## 2. Component anatomy

### Sheet & masthead
```html
<div class="us-sheet">
  <header class="us-masthead"><span class="title">U.S. Graphics Company</span></header>
  …
</div>
```
`.us-sheet` = square hairline-bordered white page on the gray body with a flat
`2px 2px` shadow. Use `.us-wrap` for a flush, full-bleed layout (no frame). The
masthead is just the bold page/company name — no colorbar.

### Navigation (tab strip)
```html
<nav class="us-nav">
  <a class="us-tab active" href="#">Office</a>
  <a class="us-tab" href="#">Products</a>
</nav>
```
Each `.us-tab` inverts to solid black + white ink on hover. `.active` keeps a
white field, gains bold weight, and shows a red dot. Works as `<a>` or `<button>`.

### Section label, headings & rules
```html
<section class="us-section">
  <p class="us-label">Notes <span class="arr"><a href="#">Archive →</a></span></p>
  <hr class="us-rule is-ticked" />
  <h2 class="us-h2">Bare Metal vs. Virtualization</h2>
  <p class="us-lead">Supporting copy.</p>
  <hr class="us-rule is-dotted" />
</section>
```
`.us-label` = small bold block title; `.arr` styles a trailing blue link. Rules:
`.us-rule` (solid hairline), `.is-dotted` (section divider), `.is-ticked`
(heavier ruler divider, good under a primary label).

### Definition block
```html
<p class="us-def"><b>Graphics</b> — visual representation of information,
  relentlessly pursuing accurate interpretation.</p>
```
Italic dictionary motif (bold term, em-dash, italic gloss, black left border).
Use once near the top for framing, not for body copy.

### Tables — the core information surface
```html
<table class="us-table is-keyed">          <!-- key/value spec table -->
  <tbody>
    <tr><td>Name</td><td>Neil Panchal</td></tr>
    <tr><td>Employer</td><td><a href="#">U.S. Graphics Company</a></td></tr>
  </tbody>
</table>

<table class="us-table">                    <!-- columned data table -->
  <thead><tr><th>Date</th><th>Title</th><th>Link</th></tr></thead>
  <tbody>
    <tr>
      <td>2026-05-16</td>
      <td>Geekbench Scores</td>
      <td><a class="us-btn is-go" href="#">Read →</a></td>
    </tr>
  </tbody>
</table>
```
`<thead>` rows get the gray fill automatically. `.is-keyed` makes the first
column a bold gray label. Rows tint on hover. Prefer a table over prose.

### Ruled list
```html
<ul class="us-list">
  <li>Emergent over prescribed aesthetics.</li>
  <li>Dense, not sparse.</li>
  <li>Performance <em>is</em> design.</li>
</ul>
```
Each `<li>` is a hairline row in a bordered box. Use for principles, options, or
any flat set that isn't quite a table.

### Cards, figures & grids
```html
<div class="us-grid-4">
  <div class="us-card is-hover">SwissMicros</div>
  <div class="us-card is-hover">Machine Universal</div>
</div>

<figure class="us-fig">
  <div class="body">HAL9000 EXABYTE</div>
  <figcaption>FIG. 1 — type specimen</figcaption>
</figure>
```
`.us-card` = black-bordered cell; `.is-hover` tints it when clickable. `.us-fig`
frames an exhibit; caption like a plate (`FIG. 1 — …`). Grids `.us-grid-2/3/4`
collapse to one column.

### Tags, badges & build readout
```html
<span class="us-tag">AZCC ID: 23616171</span>
<span class="us-badge">New!</span>

<span class="build">
  <span class="us-tag is-prod">PROD</span>
  <span class="us-tag is-version">V2.17.4</span>
</span>
```
`.us-tag` = bordered fact chip. `.is-prod` = solid green status block;
`.is-version` = its bordered build-number partner. `.us-badge` = red uppercase
alert marker, use rarely.

### Buttons
```html
<a class="us-btn" href="#">Secondary →</a>
<a class="us-btn is-primary" href="#">Inquiry →</a>   <!-- amber, black ink -->
<a class="us-btn is-go" href="#">Read →</a>           <!-- green, white ink -->
<button class="us-btn" disabled>Unavailable</button>
```
Square, 1.5px black stroke, flat `2px 2px` shadow, usually a trailing `→`.
Default inverts to solid black on hover; colored variants keep fill, just darken.
`.is-primary` is the single amber CTA per view; `.is-go` is the affirmative action.

### Callout
```html
<div class="us-callout is-alert"><b>Notice:</b> we're not accepting consignments.</div>
```
Boxed note with a thick colored left border. `.is-alert` = red, `.is-go` = green,
default = black. Use sparingly for the one line a reader must not miss.

### Footer
```html
<footer class="us-footer">
  <span>© 2026 U.S. Graphics, LLC · Made in U.S.A.</span>
  <span class="build">
    <span class="us-tag is-prod">PROD</span>
    <span class="us-tag is-version">V2.17.4</span>
  </span>
</footer>
```
Uppercase gray, separated from the body by a dotted rule. `.build` seam-joins the
status tag and version readout.

---

## 3. Re-theming recipe

Redefine the aliases in a local `:root` **after** the pasted system — this
re-skins links, go-buttons, PROD tags, the active-tab dot, and the primary action
in one move:

```html
<style>
  /* …pasted assets/usgraphics-aesthetic.css… */
  :root {
    --us-accent: #c77b1a;     /* amber links */
    --us-positive: #c77b1a;
    --us-primary: #1f7a3d;    /* primary → green */
  }
</style>
```

Don't edit component rules directly. Keep the discipline: one job per spot color,
system-ui type (mono only for code), square corners, dense and tabular.
