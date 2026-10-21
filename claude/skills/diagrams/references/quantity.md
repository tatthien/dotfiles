# Quantity: how much, compared to what, changing how

Entry format as in `structure.md`. Exact geometry: `diagram-design/references/type-<name>.md`.

Rules shared by every chart here:

- **The title states the finding** ("The median hides the tail", "One service went the other way"), not the variable names.
- **One focal mark** carries the story; it is the finding, not automatically the largest value. Every other mark is muted.
- **Read-me trio** beside the chart when it goes into an artifact: the headline claim, how to read the encoding, and what the chart does not show.
- **Honest scale:** bars and areas start at zero when magnitude matters; areas are proportional; ramps are monotone; nothing is dropped silently; illustrative numbers are labeled illustrative.
- **Text matches the drawing:** every number in a title, caption or card must equal the plotted value. Check it; published examples have got this wrong.
- **Chat:** most charts become a bar list (`name  ████████ 42%`), a sparkline (`▁▂▄▆█`) or a table.

## Bar (and dumbbell)

- **Answers:** which category is bigger, and which one is the story?
- **Use when:** one value per category; dumbbell for exactly two values per row where the gap is the message.
- **Not for:** trends over many points (Line); signed steps between totals (Waterfall).
- **Grammar:** columns by default, horizontal bars for long labels or more than 8 categories; value label on each bar; faint gridlines; dumbbell rows with two dots on one shared scale.
- **Budget:** 8 bars (2 groups when grouped); dumbbell 4-8 rows.
- **Avoid:** a truncated axis; accent on more than one bar.
- **Chat:** `S5  ████████████ 110  ← record`.
- **Render:** `type-bar.md`.
- **Seen in:** sprint velocity where sprint 5 is the standout; firms needed before a peer comparison shows, main vs a competitor set (PR-20361, I2).

## Waterfall

- **Answers:** how does a start total become an end total through signed contributions?
- **Use when:** budget bridges, headcount deltas, P&L walks; the running total is the story.
- **Not for:** two endpoints only (dumbbell); independent categories (Bar); one quantity splitting (Sankey).
- **Grammar:** totals anchored at the floor; deltas float between running levels; carry lines join adjacent bars; increases filled, decreases hollow; signed labels.
- **Budget:** 3-8 bars including both totals, 1 subtotal, 1 focal bridge.
- **Honesty:** the walk must reconcile (start + deltas = end), and say so.
- **Avoid:** a floating bar with no carry line; sign shown by hue alone.
- **Chat:** a signed list `240 +64 -38 +22 -52 = 236`.
- **Render:** `type-waterfall.md`.
- **Seen in:** cloud budget bridge FY25 to FY26 where storage tiering is the largest saving.

## Line family

- **Answers:** how does it trend, and which series breaks the pattern?
- **Variants:** line (trend over time), slopegraph (exactly two states, before and after), ridgeline (one distribution per series), streamgraph (composition over time, the envelope is the total), bump (rank movement across snapshots).
- **Grammar:** one line per series; the focal series heavier with dots, others thin; area fill only under the focal series; slopegraph labels at both ends; ridgeline ridges on one shared amplitude; bump ranks with `#n` at both ends.
- **Budget:** 4-12 points and 5 series (line); 4-10 series (slopegraph); 3-12 ridges (ridgeline); 2-6 layers (streamgraph); 4-8 series over 3-6 snapshots (bump).
- **Honesty:** no smoothing of sampled data; say what the vertical axis means when it is rank or share, not volume.
- **Avoid:** more than 5 series on a plain line chart; a y axis that hides zero when magnitude matters.
- **Chat:** a sparkline per series, `organic ▁▂▃▅▆█`.
- **Render:** `type-line.md`.
- **Seen in:** weekly signups where organic leads; p95 per service before and after a cache, where one service got slower; latency distributions where checkout has a second peak; CI minutes where the end-to-end suite is all the growth; package downloads where the old default fell from first to last.

## Scatter family

- **Answers:** do two variables move together, and who is the outlier?
- **Variants:** scatter (two variables), bubble (a third value as area), beeswarm (one variable, one dot per item, vertical spread means nothing).
- **Grammar:** axes from zero when position matters; muted points; one focal point labeled; optional dashed trend line or quadrant dividers.
- **Budget:** 5-30 points (scatter); 5-15 bubbles; 20-300 dots (beeswarm) with at most 6 labels.
- **Honesty:** bubble area, not radius, is proportional; a beeswarm legend says the spread is packing, not value; no forced trend line on scattered data.
- **Avoid:** labels on every point.
- **Chat:** a table of the top and bottom items, or a percentile line `p50 105ms · p99 431ms`.
- **Render:** `type-scatter.md`.
- **Seen in:** deploy frequency vs lead time across 12 teams; error rate vs latency with traffic as area, where the riskiest service is not the slowest; 138 checkout requests where the tail is the story.

## Treemap (and marimekko)

- **Answers:** which part dominates the whole, and by how much?
- **Use when:** disk or bundle size, budget breakdowns, share; marimekko for two levels (column width and segment height both shares).
- **Not for:** ranked lists where exact values matter (Bar); containment with no quantity (Nested).
- **Grammar:** squarified cells sorted by size, area equal to share; one ink ramp; one focal cell; slivers too small to label get an info mark and a legend line.
- **Budget:** 4-8 cells (group the tail as "Other"); marimekko 3-8 columns, 2-5 series.
- **Avoid:** stripe layouts; one hue per cell.
- **Chat:** a share list `Asia ██████████ 59%`.
- **Render:** `type-treemap.md`.
- **Seen in:** world population by continent; CI minutes by pipeline and runner, where mobile on macOS is a fifth of all time.

## Sankey

- **Answers:** where does a quantity split and merge across a few stages?
- **Use when:** compute budgets, cost or headcount allocation; band thickness carries the data.
- **Not for:** one narrowing quantity (Pyramid / funnel); more than 3 stages (split).
- **Grammar:** 3 stage columns of node bars sized by quantity; filled ribbons between columns meeting the bars square-on; one focal path; no arrowheads.
- **Budget:** 3 stages, 8 nodes, 12 ribbons.
- **Avoid:** ribbons thinner than readable (merge into "Other"); slanted joins.
- **Chat:** an indented allocation list with totals per level.
- **Render:** `type-sankey.md`.
- **Seen in:** a month of CI minutes, where flaky reruns are the line item worth cutting.

## Pyramid / funnel

- **Answers:** what ranks above what, or where does the count drop off?
- **Use when:** conversion funnels, hierarchies of value or rarity, prioritization ranks.
- **Not for:** non-hierarchical data (Bar or Tree); 7 or more layers.
- **Grammar:** 4-6 stacked layers narrowing toward the apex (pyramid) or downward (funnel); name inside, count or rate beside; one focal layer (apex, bottleneck or conversion step).
- **Budget:** 6 layers, 1 focal.
- **Honesty:** funnel widths proportional to the counts.
- **Avoid:** accent on the base; equal widths for unequal drops.
- **Chat:** decreasing bars with the count beside each stage.
- **Render:** `type-pyramid.md`.
- **Seen in:** a content pyramid where the base funds the apex.

## Polar

- **Answers:** how does one series vary across ordered, cyclic categories?
- **Use when:** demand by hour window, seasonality across 4-8 ordered buckets.
- **Not for:** several series (Radar); non-cyclic categories (Bar).
- **Grammar:** spokes clockwise from the top in input order; one ray per category from a zero center; value labels at the tips; scale rings.
- **Budget:** 4-8 categories, 1 series, 1 focal.
- **Avoid:** filled wedges (area misreads magnitude); sorting categories by value.
- **Chat:** a bar list in the category order.
- **Render:** `type-polar.md`.
- **Seen in:** request demand by UTC window, peaking at 12-15 UTC.

## Radar

- **Answers:** how do a few entities score across a few criteria?
- **Use when:** 3-5 entities on 3-5 normalized criteria (capability matrices, vendor evaluations).
- **Not for:** two entities (a bar chart or two-row table is clearer); more than 5 series.
- **Grammar:** axes on a regular polygon from the top, clockwise; grid rings at even fractions; translucent series polygons; dots only on the focal series.
- **Budget:** 5 axes, 5 series, 1 focal.
- **Avoid:** axes on different native scales without normalizing; an inner ring above zero.
- **Chat:** a score table.
- **Render:** `type-radar.md`.
- **Seen in:** object-storage backends scored on five workload dimensions.

## Heatmap

- **Answers:** which row-by-column combination stands out?
- **Use when:** failure rates by service and sprint, confusion matrices, coverage grids.
- **Not for:** comparing a few values (Bar); trends (Line); categorical yes/no (Access matrix).
- **Grammar:** a grid with row labels on the left and column labels on top; one monotone ink ramp for value; one focal cell in the accent; value text inside cells.
- **Budget:** 3-7 rows, 3-8 columns, 1 focal.
- **Honesty:** name every row and column included; state the ramp range; the focal cell's value is stated, outside the ramp.
- **Avoid:** a hue per row or column; a diverging ramp for unsigned data.
- **Chat:** a grid of `■ ◐ □` or numbers.
- **Render:** `type-heatmap.md`.
- **Seen in:** the week payments went dark (47% CI failures in one sprint).
