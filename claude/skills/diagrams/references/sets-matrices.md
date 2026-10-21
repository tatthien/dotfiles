# Sets, matrices, positioning and causes

Entry format as in `structure.md`. Exact geometry: `diagram-design/references/type-<name>.md`.

## Venn

- **Answers:** what do these sets share, and which intersection matters?
- **Use when:** overlaps of concepts or domains; "where A meets B"; desirable x feasible x viable frames.
- **Not for:** 4 or more sets (use a matrix); containment, where one set lies wholly inside another (draw the inner set inside the outer and show members as dots, so the difference is visible).
- **Grammar:** 2-3 translucent circles whose tints compound in overlaps; set names outside the circles; region labels inside; one focal intersection.
- **Must show:** every region labeled or obviously empty.
- **Budget:** 3 circles, 1 focal region.
- **Honesty:** equal radii only for comparable sets.
- **Avoid:** labels on circle strokes; circles that do not overlap when overlap is the point.
- **Chat:** a small table of regions and their members.
- **Render:** `type-venn.md`.
- **Seen in:** desirable x feasible x viable, where each two-of-three overlap names a failure mode; a competitor set A inside set A+X, where the one member outside A is what a subtraction reveals (PR-20361, P5-2).

## Access matrix (DP security matrix)

- **Answers:** who may do what, on which resource, and which rule is the critical one?
- **Use when:** roles by components or actions; before/after permission changes; "which attack needs which ingredient" style cross-tabs of categorical values.
- **Not for:** who talks to what over which protocol (DP integration); how permissions are granted (Process or Sequence).
- **Grammar:** a grid with no connectors: row labels for resources or actions, column banners for roles; each cell holds a value from a closed vocabulary (for example full, write, read, none, or needs, either, no) with its own fill; one focal cell; a legend strip of the levels used.
- **Must show:** a value in every cell (omitted means "none", stated); the focal cell's reason.
- **Budget:** 2-6 columns, 2-14 rows, 1 focal cell.
- **Avoid:** arrows anywhere; whole-row or whole-column tints; free-form levels.
- **Chat:** a table with `■ ◐ □` cells and a legend line.
- **Render:** `type-dp-security-matrix.md`.
- **Seen in:** data platform access where external partners stop at the BI layer; who sees competitor sets before and after a PR, and what each disclosure attack needs (PR-20361).

## Quadrant

- **Answers:** where does each item sit on two axes, and which one do we act on?
- **Variants:** plotted (items as dots by impact x effort) and consultant 2x2 (four named scenario cells).
- **Grammar:** a 2x2 with labeled axis ends; items as labeled dots placed off the axis lines; one focal item or cell; the consultant variant names every cell, even the unwanted ones.
- **Budget:** 12 items (plotted); 4 cells, 1 focal (consultant).
- **Avoid:** four filled quadrants in four colors; items on an axis line; unnamed axes.
- **Chat:** a 2x2 box with items in the cells.
- **Render:** `type-quadrant.md`.
- **Seen in:** content ideas by impact x effort with one item to start tomorrow; workplace 2030 scenarios (remote x AI) with one bet.

## Wardley map

- **Answers:** how evolved is each part of a value chain, and what is about to move?
- **Use when:** build vs buy, where differentiation lives, what is commoditizing.
- **Not for:** runtime connections (Architecture); a numeric maturity score.
- **Grammar:** vertical axis from visible to the user (top) to invisible (bottom); horizontal axis in four evolution bands (genesis, custom-built, product, commodity); components as dots with labels; dependency links without arrowheads; a dashed movement arrow toward commodity for what is moving.
- **Budget:** 9 components, 12 links, 2 movement arrows.
- **Avoid:** a numeric maturity axis; components with no link; arrows pointing right to left.
- **Chat:** a table of component, visibility, evolution band, moving or not.
- **Render:** `type-wardley.md`.
- **Seen in:** an AI assistant product where agent orchestration is moving from custom-built toward product.

## Fishbone

- **Answers:** what caused this one observed effect?
- **Use when:** post-mortems and root-cause analysis where the investigation itself must be visible.
- **Not for:** a chronology of failures (Timeline or Sequence).
- **Grammar:** a spine into the effect box at the head; category bones alternating above and below; sub-cause ticks with short labels; the confirmed root-cause bone accented.
- **Must show:** the effect stated as an observed symptom, not a fix; every bone with at least one sub-cause; which cause was confirmed.
- **Budget:** 5-6 bones, 3 sub-causes each, 18 total.
- **Avoid:** a bone with no sub-causes; accenting several bones.
- **Chat:** an indented list under the effect, confirmed cause marked `✓ root`.
- **Render:** `type-fishbone.md`.
- **Seen in:** checkout p99 latency 4x for 90 minutes, root cause a missing index.
