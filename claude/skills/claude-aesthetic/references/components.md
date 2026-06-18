# Claude Aesthetic DS — Token & Component Reference

Specifics for composing the design system. The canonical CSS is
`assets/claude-aesthetic.css`; this file explains *how to use* what's in it.

## Contents
1. Tokens (palette, semantic aliases, type, space, radius, lines/motion)
2. Component anatomy & examples
3. Re-theming recipe

---

## 1. Tokens

All decisions live in `:root` custom properties so a page can re-theme without
editing components. Prefer the **semantic aliases** over raw palette values in
page-specific CSS — that's what keeps re-theming a one-liner.

### Palette
| Token | Hex | Role |
|---|---|---|
| `--ds-ivory` | `#FAF9F5` | page background |
| `--ds-paper` | `#FFFFFF` | cards / panels |
| `--ds-slate` | `#141413` | primary ink |
| `--ds-clay` | `#D97757` | primary accent (orange) |
| `--ds-clay-d` | `#B85C3E` | darker clay — accent text / negative semantic |
| `--ds-oat` | `#E3DACC` | warm fill / underlines |
| `--ds-olive` | `#788C5D` | secondary accent / positive semantic |
| `--ds-g100…g700` | greys | `g100` lightest fill → `g700` dark text |

### Semantic aliases (override these to re-theme)
| Alias | Default | Meaning |
|---|---|---|
| `--ds-accent` | clay | primary accent |
| `--ds-accent-text` | clay-d | accent text on light surfaces |
| `--ds-positive` | olive | success / "on" / "unlocked" |
| `--ds-positive-soft` | `#EAEFE2` | tinted positive background |
| `--ds-negative` | clay-d | failure / "off" / "locked" |
| `--ds-negative-soft` | `#F6E7E0` | tinted negative background |

### Type
- `--ds-serif` — `ui-serif, Georgia, "Times New Roman", Times, serif` (headings)
- `--ds-sans` — system stack (body)
- `--ds-mono` — `ui-monospace, "SF Mono", Menlo…` (eyebrows, labels, code)

### Space / radius / lines
- Space: `--ds-space-1`(8) … `--ds-space-5`(72)
- Radius: `--ds-radius-sm`(6) `--ds-radius`(10) `--ds-radius-lg`(14) `--ds-radius-pill`(999)
- `--ds-border` (1.5px g300), `--ds-border-strong` (1.5px slate)
- `--ds-shadow-hover` (the card lift shadow), `--ds-ease` (150ms ease)

---

## 2. Component anatomy

### Masthead
```html
<header class="ds-masthead">
  <p class="ds-eyebrow">DEV-1234 · Context · Kind</p>
  <h1 class="ds-h1">The headline, with one <em>emphasised</em> word</h1>
  <p class="ds-intro">One-sentence framing of what this page is.</p>
  <!-- optional metadata row -->
  <div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:24px;">
    <span class="ds-tag"><b>Scope:</b> …</span>
    <span class="ds-tag"><b>Status:</b> …</span>
  </div>
</header>
```
`.ds-eyebrow` draws a 24px clay dash before the text via `::before`. `.ds-h1 em`
is the only place italic-clay emphasis belongs — use it on a single word, not a
whole phrase.

### Numbered section
```html
<section class="ds-section">
  <div class="ds-sec-head">
    <span class="idx">01</span>
    <h2>Section title</h2>
    <span class="count">3 items</span> <!-- optional -->
  </div>
  <p class="ds-lead">Supporting copy. Indented 50px to sit under the title.</p>
</section>
```
The `.idx` is clay monospace and fixed-width (34px) so titles align. Two-digit
zero-padded indices (`01`, `02`) read best.

### Surfaces — panel vs card vs tile
- `.ds-panel` — static container. Use to wrap a figure or a block that isn't
  itself a list item.
- `.ds-card` — lifts 3px + shadow + slate border on hover. Use for grid cells
  that are scannable or link-like. Hover is disabled on touch automatically.
- `.ds-tile` — a g100 cell with a 4px colored top stripe via `.is-accent` /
  `.is-positive` / `.is-negative`. Its `h3` is auto mono-uppercase. Good for
  labeled "concept" cells inside a panel.

```html
<div class="ds-grid-2">
  <div class="ds-card">…</div>
  <div class="ds-card">…</div>
</div>

<div class="ds-panel">
  <div class="ds-tile is-positive"><h3>Job A</h3><p>…</p></div>
</div>
```

### Pills & tags
```html
<span class="ds-pill is-positive">UNLOCKED</span>
<span class="ds-pill is-negative">LOCKED</span>
<span class="ds-pill is-neutral">N/A</span>
<span class="ds-tag"><b>Label:</b> value</span>
```
`.ds-pill` = filled status chip (slate by default). `.ds-tag` = outlined
metadata chip on paper. Don't use a tag where you mean a pill or vice-versa —
pills signal *state*, tags signal *facts*.

### Controls
```html
<div class="ds-segment" role="tablist">
  <button class="active is-negative">Before</button>
  <button class="is-positive">After</button>
</div>

<button class="ds-btn">Secondary</button>
<button class="ds-btn is-primary">Primary action</button>
```
`.ds-segment` is a one-of-N toggle: give the selected button `.active`; add
`.is-positive` / `.is-negative` so the active state takes that semantic color.
`.ds-btn` is a quiet pill button; `.is-primary` makes it solid clay. Toggle
`.active` and `disabled` from JS as needed.

### Callout
```html
<div class="ds-callout"><b>Key takeaway:</b> the one thing to remember.</div>
```
Oat band with a clay border. Use **once or twice** per page for the single most
important line — its scarcity is what makes it land.

### Footer
```html
<footer class="ds-footer">
  <span>Generated from <span class="ds-kbd">source.md</span></span>
  <span class="k">an italic closing note</span>
</footer>
```

---

## 3. Re-theming recipe

To shift the whole page's accent without touching components, redefine the
aliases in a local `:root` placed **after** the pasted design system:

```html
<style>
  /* …pasted assets/claude-aesthetic.css… */

  /* page override: make olive the primary accent for a "success" page */
  :root {
    --ds-accent: var(--ds-olive);
    --ds-accent-text: #5c6e45;
  }
</style>
```

Because every component reads `--ds-accent` / `--ds-positive` / `--ds-negative`,
this re-skins eyebrow dashes, section indices, primary buttons, tile stripes,
and callout borders in one move. Avoid editing the component rules directly —
that's how a design system rots.
