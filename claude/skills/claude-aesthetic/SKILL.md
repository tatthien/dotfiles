---
name: claude-aesthetic
description: >-
  Apply the "Claude aesthetic" design system — an editorial HTML aesthetic with
  ivory paper surfaces, a clay-orange accent, olive + oat secondaries, serif
  display type, monospace eyebrows, and quiet lift-on-hover interactions
  (adapted from thariqs.github.io/html-effectiveness). Use this skill WHENEVER
  building or restyling a self-contained HTML page, interactive explainer, plan
  doc, root-cause write-up, one-pager, dashboard, or prototype that should look
  polished and editorial rather than generic — even if the user doesn't name
  the design system. Trigger on requests like "make this look nice", "style
  this HTML", "apply the Claude aesthetic / Claude style", "build an
  interactive explainer/one-pager", or any time you're about to hand-roll
  ad-hoc CSS for a standalone HTML artifact. Do NOT use for in-app product UI
  that relies on its own component library.
---

# Claude Aesthetic Design System

A small, dependency-free CSS design system in the "unreasonable effectiveness of
HTML" aesthetic. It makes standalone HTML artifacts — explainers, plan docs,
root-cause write-ups, one-pagers — look editorial and considered instead of
default-browser plain or generic-bootstrap busy.

The whole system is one CSS file you bundle into the page. There is no build
step, no JS dependency, no framework. You compose semantic `ds-*` classes and
let the tokens do the work.

## The look, in one breath

Ivory paper background, near-black "slate" ink, a single warm **clay-orange**
accent, **olive** and **oat** as quiet secondaries. **Serif** for display
headings (with clay italic for emphasis), **monospace** for eyebrows / labels /
code, **sans** for body. Cards lift 3px on hover; everything else stays calm.
Lots of whitespace. The restraint is the point — color and serif do the
talking, so don't over-decorate.

## How to apply it (the important part)

**Always inline the CSS into the HTML's `<style>`, never `<link>` to it.**

Steps:

1. Read `assets/claude-aesthetic.css` (the canonical source) and paste its full
   contents into a `<style>` block in the `<head>`.
2. Put any page-specific CSS _after_ the design system, in the same `<style>`
   block, so it can use the `--ds-*` tokens and override where needed.
3. Build the page out of the `ds-*` component classes below. Reach for
   page-specific CSS only for genuinely bespoke pieces (e.g. an animated
   stepper) — and even then, style them with the tokens (`var(--ds-clay)`,
   `var(--ds-border)`, …) so they stay coherent.

A minimal skeleton:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>…</title>
    <style>
      /* paste assets/claude-aesthetic.css here in full */
      /* …then page-specific CSS, using the --ds-* tokens… */
    </style>
  </head>
  <body>
    <div class="ds-wrap">
      <header class="ds-masthead">
        <p class="ds-eyebrow">Section · context</p>
        <h1 class="ds-h1">A headline with an <em>emphasised</em> word</h1>
        <p class="ds-intro">A lead paragraph that frames the page.</p>
      </header>

      <section class="ds-section">
        <div class="ds-sec-head">
          <span class="idx">01</span>
          <h2>First section</h2>
        </div>
        <p class="ds-lead">Supporting copy, indented under the title.</p>
      </section>

      <footer class="ds-footer">
        <span>Footer left</span><span class="k">italic footer note</span>
      </footer>
    </div>
  </body>
</html>
```

## Component vocabulary

Compose these — don't invent parallel ones. Full prop/variant detail and the
token list live in `references/components.md`; read it when you need specifics.

| Class                                                        | Use                                                                   |
| ------------------------------------------------------------ | --------------------------------------------------------------------- |
| `.ds-wrap`                                                   | centered max-width page container                                     |
| `.ds-masthead`                                               | top header band with bottom rule                                      |
| `.ds-section`                                                | a spaced content section                                              |
| `.ds-eyebrow`                                                | mono uppercase label with a clay dash before it                       |
| `.ds-h1`                                                     | serif display heading; `<em>` renders clay italic                     |
| `.ds-intro`                                                  | lead paragraph under the H1                                           |
| `.ds-sec-head` + `.idx` / `h2` / `.count`                    | numbered section header (clay mono index)                             |
| `.ds-lead`                                                   | supporting paragraph, indented to align under a section title         |
| `.ds-panel`                                                  | static paper surface                                                  |
| `.ds-card`                                                   | paper surface that lifts on hover (use for scannable/clickable cells) |
| `.ds-tile` + `.is-accent` / `.is-positive` / `.is-negative`  | cell with a colored top accent                                        |
| `.ds-pill` + `.is-positive` / `.is-negative` / `.is-neutral` | status pill                                                           |
| `.ds-tag`                                                    | outlined metadata chip                                                |
| `.ds-btn` + `.is-primary`                                    | pill button                                                           |
| `.ds-segment`                                                | segmented switch (row of toggles, one `.active`)                      |
| `.ds-callout`                                                | oat band for a single key takeaway                                    |
| `.ds-footer` + `.k` / `.ds-kbd`                              | footer row, italic note, keycap                                       |
| `.ds-grid-2`                                                 | responsive two-column grid                                            |

## Conventions worth holding to

These are what keep it looking like _this_ system rather than drifting:

- **Three type roles, no mixing.** Serif = headings. Mono = eyebrows, section
  indices, labels, code. Sans = body. If you find yourself putting body text in
  serif or a heading in sans, stop.
- **One accent.** Clay carries the page. Olive and oat are seasoning, not
  co-stars. Resist adding new hues — the palette's smallness is why it reads as
  designed.
- **Semantic color via aliases.** "Good/positive" is olive, "bad/negative" is
  clay-d, "primary action/accent" is clay — referenced through
  `--ds-positive` / `--ds-negative` / `--ds-accent`. To re-theme a whole page,
  redefine those aliases in a local `:root` _after_ the pasted system, rather
  than rewriting components. (E.g. a "success" page could point `--ds-accent`
  at olive.)
- **Cards lift, panels don't.** `.ds-card` for things that are scannable or
  clickable; `.ds-panel` for static containers.
- **Let it breathe.** Generous section spacing and the 50px lead indent are
  load-bearing. Packing things tightly is the fastest way to make it look
  cheap.
- **Don't restyle a variant into another.** If no component fits, add a small
  page-specific rule built from the tokens — don't, say, `sx`-hack a pill to
  look like a button.

## Files

- `assets/claude-aesthetic.css` — the canonical design system. Paste it inline.
- `references/components.md` — token reference + per-component anatomy and
  examples. Read for specifics when composing something non-obvious.
