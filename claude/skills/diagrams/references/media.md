# Rendering a diagram in a medium

The type decides the shape; the medium decides how that shape is drawn.
The consumer (the skill or page that hosts the diagram) decides colors and fonts; nothing here prescribes them.

| Medium | Use for | Owner of the details |
| --- | --- | --- |
| ASCII | chat, terminal, commit-free notes, GitHub markdown | this file |
| inline SVG in HTML | explainers, artifacts, reports, review pages | `diagram-design` (grammar), the consumer (style) |
| archify | explorable, validated diagrams of architecture, workflow, sequence, dataflow or lifecycle; repo-backed diagrams | `archify` |
| Mermaid | only where the destination renders nothing richer | this file |
| exported image | slides, docs, tickets | `diagram-design/references/export.md` |

## ASCII (chat and terminal)

- Inside a code fence, 80 columns at most, real names from the code or domain (no placeholders).
- Box drawing: `+--+` or `┌─┐` boxes, `──>` arrows, `│ ├ └` rails, `┐ ├ ┘` merges for fan-in.
- Put a connector's label on the line (`──── SET ID ───>`), not floating above it.
- One primary direction per diagram, as in every medium.
- Encode status with a word or glyph, never only with position: `✓ ✗ ⚠`, `PASS/FAIL`, `■ ◐ □` for matrix cells, `█ ▓ ░` and sparklines `▁▂▄▆█` for quantities.
- A legend is one line under the drawing.
- Where the terminal renders a Nerd Font, an icon may label a node (icon, then one space, then the word); if unsure of a glyph, use the word.
- Types that do not survive ASCII: treemap, Sankey, scatter and its variants, radar, polar, streamgraph, ridgeline, exploded and axonometric. Use a table, a bar list (`name  ████████ 42%`) or a paragraph instead, and say the richer type exists if the reader wants an HTML version.
- Each type entry gives its ASCII form under "Chat".

## Inline SVG in HTML

Grammar from `diagram-design` (read its `references/primitives-core.md` and the type reference before drawing a new kind):

- **Accessible figure:** `<svg role="img" aria-labelledby="<slug>-title <slug>-desc">` with `<title>` as the first child and a one-sentence `<desc>` about the content. Ids are prefixed per diagram.
- **Paint order:** zones, then connectors, then label masks and labels, then nodes. Connectors sit behind the boxes they join.
- **Node:** an opaque mask rect (so lines behind it disappear), the styled box with a small radius, an optional rectangular type tag (not a pill), the name, and an optional technical sub-label.
- **Connectors:** right angles with rounded corners; straight only when the endpoints share an axis. Each connector gets its own attach point on a shared edge, at least 12px apart; parallel runs at least 12px apart; a single crossing gets a small hop on the less important line. No connector passes behind a box that is not its endpoint.
- **Labels:** 14 characters or fewer, on an opaque mask 6-10px clear of the stroke, beside a vertical segment, never under a node painted later.
- **Markers:** define arrowheads once (accent, default, and any special ones such as a stop bar) in a shared hidden `<svg width="0" height="0" style="position:absolute">`; `display: none` breaks the references.
- **Legend:** a horizontal strip under a hairline at the bottom of the viewBox.
- **Text budget:** about 0.60em per character for sans and 0.62em for mono; check that every label fits its box before trusting the layout.
- **Geometry:** a 4px grid for positions, sizes and gaps.
- **Responsive:** `width: 100%` with a `min-width` near the viewBox width, inside a local `overflow-x: auto` wrapper, so a narrow screen scrolls the figure and never the page. Design the viewBox for the narrowest target (for an iPad mini in portrait, about 680 wide).
- **Themeable:** color nodes through semantic classes on the node group (client, server, data, error, focal, neutral, skipped) that read CSS variables, so a light/dark switch recolors every diagram. archify's role set is a good default.
- **Verify:** render it and look at it at the target width; a passing generator is not a passing diagram.

`pr-explain/assets/starter.html` is a working, themeable implementation of these rules.

## archify

- Five modes: `architecture` (components, boundaries, infrastructure), `workflow` (processes, gates, runbooks, CI/CD, step-by-step life plans), `sequence` (call chains, async traces, back-and-forth between people), `dataflow` (pipelines, lineage, where money or documents go), `lifecycle` (status transitions, retries, waits, terminal states).
- Prefer it when the diagram must be explorable, checked by real-browser gates, exportable, or traced to repository evidence.
- Its authoring defaults are good rules in any medium:
  - lead with the main user journey; name a narrower scope in the title;
  - group only into accurately named subsystems that do not hide ownership, trust, persistence or lifecycle boundaries;
  - put an approval or authorization gate on the node or relationship it affects (a note cannot qualify an unconditional arrow);
  - draw a boundary only for real isolation, ownership, runtime or persistence;
  - place a branch or store directly above or below its owner so the edge is one straight segment;
  - a return edge leaves from the side with no branches;
  - a label may be omitted only when both endpoints fully imply it;
  - a recoverable failure needs a real transition back.
- Workflow: `node <archify>/bin/archify.mjs finalize <type> <candidate.json> <out.html> --quality showcase --json`; see `archify/SKILL.md`.

## Mermaid

- Use only when the destination renders Mermaid and nothing richer (GitHub markdown, some wikis), and only for flowcharts, sequences and state machines.
- Keep every label to one short line; quote labels with punctuation.
- Never inside an HTML artifact or explainer: draw SVG there (Tris, 2026-10-08).
- When someone hands you Mermaid to "make presentable", redraw it, do not render it: read the topology and meaning, then author fresh SVG or archify JSON (`diagram-design/references/import-mermaid.md`, `archify` "Mermaid input").

## Exported images

PNG or SVG export for slides and documents follows `diagram-design/references/export.md` (`scripts/export_svg.py` keeps classes and namespaces ids).
Export only when asked.

## Motion

Optional. The still frame must already carry the whole meaning; motion only orders attention.
At most 8 steps, 12 marked items, 2 moving at once; honor `prefers-reduced-motion` by showing the complete static frame.
Details: `diagram-design/references/animation.md`.
