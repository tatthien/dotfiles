---
name: usgraphics-aesthetic
description: >-
  Apply the "US Graphics aesthetic" — an engineering-documentation HTML design
  system: white paper sheet on gray, true-black ink, system-ui sans (mono only
  for code), hairline/dotted rules, bordered tables with gray header rows,
  tab-strip nav with a red active dot, blue links, amber primary + green "go"
  buttons, square corners, one flat shadow. Dense, flat, explicit — a technical
  spec sheet, not an editorial page. Use WHENEVER building or restyling a
  self-contained HTML page, spec sheet, changelog, status board, data table,
  catalog, README, one-pager, or prototype that should read like precise
  engineering documentation — even if the user doesn't name the system. Triggers:
  "make this look technical / like a spec sheet", "apply the US Graphics /
  usgraphics style", "clean technical documentation page", or any standalone HTML
  artifact you'd otherwise hand-roll ad-hoc CSS for in that register. Do NOT use
  for in-app product UI on its own component library, or for an airy editorial
  serif look (use claude-aesthetic instead).
---

# US Graphics Aesthetic Design System

A dependency-free CSS system in the "engineering graphics" register: white paper
on a gray surround, **true-black ink**, **system-ui sans** (mono only for
`code`), **bordered tables with gray header rows** and ruled lists, **hairline +
dotted rules**, **tab-strip nav** (active tab marked with a red dot). Links are
blue; primary actions amber, "go" actions green, alerts red — each spot color
with one job. Square corners, one tight flat shadow, dense spacing, no motion.
The density is the point — "as complex as it needs to be," the opposite of
minimalism.

## How to apply

**Always inline the CSS into a `<style>` block — never `<link>` to it.**

1. Paste the full contents of `assets/usgraphics-aesthetic.css` into a `<style>`
   in `<head>`.
2. Put any page-specific CSS *after* it in the same block, built from the
   `--us-*` tokens so it stays coherent.
3. Compose the page from the `us-*` classes below; reach for custom CSS only for
   genuinely bespoke pieces, still styled with the tokens.

Minimal skeleton:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>…</title>
    <style>
      /* paste assets/usgraphics-aesthetic.css here in full, then page CSS */
    </style>
  </head>
  <body>
    <div class="us-sheet">
      <header class="us-masthead"><span class="title">Example Co.</span></header>
      <nav class="us-nav">
        <a class="us-tab active" href="#">Office</a>
        <a class="us-tab" href="#">Products</a>
      </nav>
      <section class="us-section">
        <p class="us-label">Office</p>
        <hr class="us-rule is-ticked" />
        <p class="us-def"><b>Graphics</b> — accurate visual representation of information.</p>
        <a class="us-btn is-primary" href="#">Inquiry →</a>
      </section>
      <footer class="us-footer">
        <span>© 2026 Example Co. · Made in U.S.A.</span>
        <span class="build">
          <span class="us-tag is-prod">PROD</span>
          <span class="us-tag is-version">V2.17.4</span>
        </span>
      </footer>
    </div>
  </body>
</html>
```

## Component vocabulary

Compose these — don't invent parallel ones. Per-component anatomy, examples, and
the full token list are in `references/components.md`; read it for specifics.

| Class | Use |
|---|---|
| `.us-sheet` / `.us-wrap` | framed white page on gray / flush container (no frame) |
| `.us-masthead` + `.title` | header band with bold page/company name |
| `.us-nav` + `.us-tab` (`.active`) | tab strip; active tab shows a red dot |
| `.us-section` | spaced content section |
| `.us-label` (+ `.arr`) | bold section marker; `.arr` = trailing blue link |
| `.us-h1` / `.us-h2` / `.us-h3` | bold sans headings (differ by weight + size only) |
| `.us-rule` + `.is-dotted` / `.is-ticked` | hairline / dotted / ruler-tick divider |
| `.us-def` | italic definition block (`<b>Term</b> — gloss`) |
| `.us-lead` | supporting paragraph |
| `.us-table` + `.is-keyed` | bordered table, gray `<thead>`; `.is-keyed` = label/value |
| `.us-list` | ruled list — each `<li>` a hairline row |
| `.us-card` + `.is-hover` | bordered cell; `.is-hover` tints on hover |
| `.us-fig` + `.body` + `<figcaption>` | bordered figure exhibit with caption |
| `.us-grid-2` / `-3` / `-4` | responsive bordered-cell grids |
| `.us-tag` + `.is-prod` / `.is-version` | fact chip; green status + paired build number |
| `.us-badge` | red uppercase alert badge (`NEW!`) |
| `.us-btn` + `.is-primary` / `.is-go` | action button (amber primary / green go) |
| `.us-callout` + `.is-alert` / `.is-go` | boxed note with colored left border |
| `.us-footer` + `.build` / `.us-kbd` | uppercase footer; build-tag pair; mono keycap |

## Conventions (what keeps it looking like *this* system)

- **One type family: system-ui sans** for everything; headings differ only by
  weight + size. Mono (`--us-mono`) only for `code`/`pre`, `.us-mono`, `.us-kbd`.
  No serif, no second sans, no webfont `@import`.
- **Facts go in tables and ruled lists**, not prose. Reach for `.us-table` /
  `.us-list` for any key/value or enumerated set — tabular is the default register.
- **One job per spot color:** blue = links, green = go/live/PROD, amber = the
  single primary action, red = alerts + active-tab dot. Don't cross wires or add hues.
- **Square corners; hairline borders; one shadow.** Radius 0 everywhere (sheet
  included). 1px borders; buttons take 1.5px (`--us-border-bold`). The only depth
  cue is a tight `2px 2px` zero-blur flat-gray shadow (`--us-shadow` #ddd on
  sheet/tables/tabs, `--us-shadow-strong` #bbb on buttons). Never a soft/blurred shadow.
- **Rules:** `.is-dotted` divides sections, `.is-ticked` is the heavier divider
  under a primary label, plain `.us-rule` is a solid hairline.
- **Hover inverts; nothing moves.** Buttons/tabs flip to solid black + white ink;
  colored buttons keep their fill and just darken; links drop underline, stay blue.
  No slides, fades, or lifts. Selection is shown explicitly (red dot, tag, border).
- **Re-theme via aliases**, not components: redefine `--us-accent` /
  `--us-positive` / `--us-negative` / `--us-primary` in a local `:root` *after*
  the pasted system. See the recipe in `references/components.md`.
- **If no component fits**, add a small token-built rule — don't hack a tag into a
  button or a card into a table.

## Files

- `assets/usgraphics-aesthetic.css` — canonical design system; paste inline.
- `references/components.md` — token reference + per-component anatomy/examples.
