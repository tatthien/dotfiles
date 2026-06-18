---
name: usgraphics-aesthetic
description: >-
  Apply the "US Graphics aesthetic" design system — an engineering-documentation
  HTML aesthetic with white paper surfaces, true-black ink, system-ui sans
  type (monospace only for code), hairline + dotted rules, bordered data
  tables with gray header rows, tab-style navigation with a red active dot,
  classic-blue links, green "go" buttons, amber
  primary buttons, and build/version tags (adapted from usgraphics.com and
  neil.computer). Dense, flat, explicit — a technical spec sheet, not an
  editorial page. Use this skill WHENEVER building or restyling a self-contained
  HTML page, spec sheet, changelog, status board, data table, catalog, README,
  one-pager, or prototype that should read like precise engineering
  documentation rather than generic — even if the user doesn't name the design
  system. Trigger on requests like "make this look technical / like a spec
  sheet", "apply the US Graphics / usgraphics style", "build a clean
  technical documentation page", or any time you're about to hand-roll ad-hoc
  CSS for a standalone HTML artifact in that engineering-manual register. Do NOT
  use for in-app product UI that relies on its own component library, or when an
  airy editorial serif look is wanted (use claude-aesthetic for that).
---

# US Graphics Aesthetic Design System

A small, dependency-free CSS design system in the "engineering graphics"
aesthetic. It makes standalone HTML artifacts — spec sheets, changelogs, status
boards, catalogs, data tables, READMEs — look like precise technical
documentation instead of default-browser plain or generic-bootstrap busy.

The whole system is one CSS file you bundle into the page. There is no build
step, no JS dependency, no framework. You compose semantic `us-*` classes and
let the tokens do the work.

## The look, in one breath

White paper on a gray surround, **true-black ink**, **system-ui sans type**
(monospace reserved for `code` only). Information lives in **bordered tables
with gray header rows** and **ruled lists**. **Hairline and dotted rules**
separate sections. Navigation is a row of **tab buttons** that invert to solid
black on hover, the active one marked with a **red dot**. Links are
**classic blue**; primary actions are **amber/gold**, "go" actions **green**,
alerts **red** — each spot color with exactly one job. Square corners, a tight
flat shadow, dense spacing, no gratuitous motion. Dense, not sparse. Explicit,
not implicit. Flat, not hierarchical. The density is the point — this aesthetic
is "as complex as it needs to be," the opposite of minimalism.

## How to apply it (the important part)

**Always inline the CSS into the HTML's `<style>`, never `<link>` to it.**

Steps:

1. Read `assets/usgraphics-aesthetic.css` (the canonical source) and paste its
   full contents into a `<style>` block in the `<head>`.
2. Put any page-specific CSS _after_ the design system, in the same `<style>`
   block, so it can use the `--us-*` tokens and override where needed.
3. Build the page out of the `us-*` component classes below. Reach for
   page-specific CSS only for genuinely bespoke pieces — and even then, style
   them with the tokens (`var(--us-ink)`, `var(--us-line)`, `var(--us-green)`,
   …) so they stay coherent.

A minimal skeleton:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>…</title>
    <style>
      /* paste assets/usgraphics-aesthetic.css here in full */
      /* …then page-specific CSS, using the --us-* tokens… */
    </style>
  </head>
  <body>
    <div class="us-sheet">
      <header class="us-masthead">
        <span class="title">Example Co.</span>
      </header>

      <nav class="us-nav">
        <a class="us-tab active" href="#">Office</a>
        <a class="us-tab" href="#">Products</a>
        <a class="us-tab" href="#">Catalog</a>
      </nav>

      <section class="us-section">
        <p class="us-label">Office</p>
        <hr class="us-rule is-ticked" />
        <p class="us-def"><b>Graphics</b> — visual representation of
          information, relentlessly pursuing accurate interpretation.</p>
        <p class="us-lead">Engineering graphics for professionals.</p>
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

Compose these — don't invent parallel ones. Full prop/variant detail and the
token list live in `references/components.md`; read it when you need specifics.

| Class                                              | Use                                                                |
| -------------------------------------------------- | ------------------------------------------------------------------ |
| `.us-sheet`                                        | framed white page floating on the gray surround                    |
| `.us-wrap`                                          | flush centered container (no frame) — alternative to `.us-sheet`   |
| `.us-masthead` + `.title`                          | header band: the page / company name in bold                       |
| `.us-nav` + `.us-tab` (`.active`)                  | tab-strip nav; the active tab shows a red dot                      |
| `.us-section`                                       | a spaced content section                                           |
| `.us-label` (+ `.arr`)                             | bold section marker; `.arr` is a blue inline link like `Archive →` |
| `.us-h1` / `.us-h2` / `.us-h3`                     | bold sans headings (differ by weight + size only)                  |
| `.us-rule` + `.is-dotted` / `.is-ticked`           | hairline / dotted / ruler-tick divider                             |
| `.us-def`                                           | italic dictionary definition block (`<b>Term</b> — gloss`)         |
| `.us-lead`                                          | supporting paragraph                                               |
| `.us-table` + `.is-keyed`                          | bordered data table with gray `<thead>`; `.is-keyed` = label/value |
| `.us-list`                                          | ruled list — each `<li>` a hairline row                            |
| `.us-card` + `.is-hover`                           | bordered cell; `.is-hover` adds a fill-tint on hover               |
| `.us-fig` + `.body` + `<figcaption>`               | bordered figure exhibit with a caption (e.g. `FIG. 1`)             |
| `.us-grid-2` / `.us-grid-3` / `.us-grid-4`         | responsive bordered-cell grids                                     |
| `.us-tag` + `.is-prod` / `.is-version`             | bordered fact chip; status block + paired build number             |
| `.us-badge`                                         | red uppercase alert badge (`NEW!`)                                 |
| `.us-btn` + `.is-primary` / `.is-go`               | rectangular action button (amber primary / green go)               |
| `.us-callout` + `.is-alert` / `.is-go`             | boxed note with a colored left border                              |
| `.us-footer` + `.build` / `.us-kbd`                | uppercase sans footer; build-tag pair; mono keycap                 |

## Conventions worth holding to

These are what keep it looking like _this_ system rather than drifting:

- **One type family: system-ui sans.** Everything is the system sans — body,
  headings, labels, data, controls. Headings differ only by **weight and size**,
  never by family. Monospace (`var(--us-mono)`) is reserved for `code`/`pre`,
  the `.us-mono` utility, and the `.us-kbd` keycap; don't introduce a serif or a
  second sans anywhere.
- **Information goes in tables and ruled lists.** When you have facts, key/value
  pairs, or an enumerated set, reach for `.us-table` / `.us-list` before prose.
  Dense and tabular is the register — paragraphs are the exception.
- **Spot colors each have one job.** Blue = links. Green = "go"/live/PROD.
  Amber = the single primary action. Red = alerts and the active-tab dot. Don't
  cross the wires (no green links, no amber alerts) and don't add new hues — the
  restraint is what reads as engineered.
- **Square corners; hairline borders; one flat shadow.** Radius is 0 everywhere —
  even the sheet (usgraphics has no rounded frame), and no pill shapes. Tables,
  cells, the sheet, and tabs use 1px borders; buttons take a slightly heavier
  1.5px stroke (`var(--us-border-bold)`, matching usgraphics' `.1rem`). The one
  depth cue is a **tight `2px 2px` flat-gray drop shadow with zero blur** —
  `var(--us-shadow)` (#ddd) on the sheet/tables/tabs, `var(--us-shadow-strong)`
  (#bbb) on buttons. That hard 2px shadow is the *only* shadow in the system;
  never reach for a soft/blurred `box-shadow`.
- **Dotted rules divide, ticked rules measure.** Use `.us-rule.is-dotted`
  between sections, `.us-rule.is-ticked` as the heavier "engineering" divider
  under a primary label, plain `.us-rule` for a solid hairline.
- **Hover inverts; nothing moves.** A button or tab on hover flips to a **solid
  black field with white ink** (usgraphics' signature interaction) — the hard
  shadow stays put and nothing translates or lifts. Coloured buttons
  (`.is-primary` gold, `.is-go` green) keep their fill and just darken slightly;
  links drop their underline but stay blue. No fills-to-gray, slides, or fades.
  Selected state is shown explicitly: the red dot on the active tab, a tag, or a
  border.
- **Semantic color via aliases.** "go/positive" is green, "alert/negative" is
  red, "primary action" is amber, "link/accent" is blue — referenced through
  `--us-positive` / `--us-negative` / `--us-primary` / `--us-accent`. To
  re-theme, redefine those aliases in a local `:root` _after_ the pasted system
  rather than rewriting components.
- **Don't restyle a variant into another.** If no component fits, add a small
  page-specific rule built from the tokens — don't hack a tag to look like a
  button or a card to look like a table.

## Files

- `assets/usgraphics-aesthetic.css` — the canonical design system. Paste it
  inline.
- `references/components.md` — token reference + per-component anatomy and
  examples. Read for specifics when composing something non-obvious.

> Note on the typeface: the body type is the platform **system-ui** sans
> (`--us-sans`), so it renders natively everywhere with no webfont to load.
> Monospace (`--us-mono`) is used only for `code`/`pre`, the `.us-mono` utility,
> and the `.us-kbd` keycap. Don't add a webfont `@import`/CDN link.
