---
name: diagrams
description: The knowledge base for choosing and designing diagrams and charts, independent of any UI, theme or renderer. Which diagram type answers which question (44 types, from architecture, sequence, flowchart, state machine and swimlane to timeline, ER, heatmap, Sankey, Venn, quadrant and Wardley), behavior-first semantic patterns (paired policy traces, secure paved road, lifecycle phase map, ...), layout grammar, complexity budgets, honesty rules, anti-patterns, real use cases, and how to render each type in a given medium (ASCII in chat, inline SVG in HTML, archify JSON, Mermaid only where nothing else renders). Use it before drawing anything whose structure is not obvious, whenever a diagram goes into an artifact, HTML page, doc, PR or slide, and whenever another skill (pr-explain, pr-explain-artifact, pr-description, plan-dev, explain-better, lavish, playground, explain-diff-html, codebase-to-course, archify, diagram-design) must decide WHAT to draw before HOW. Also use it when the user asks which diagram fits, how to visualize something, or why a diagram is confusing. Skip it for a one-glance box-and-arrow sketch in chat.
---

# Diagrams

The knowledge layer for every diagram and chart: what to draw, why, and how it must read.
No colors, fonts, pixel sizes or markup live here. Renderers own those; consumers own their style.

```
 reader's question -> pattern? -> type -> budget -> medium -> taste gate
```

## Where this skill sits

| Layer | Skill | Owns |
| --- | --- | --- |
| knowledge | **diagrams** (this) | selection, abstract grammar, budgets, honesty rules, anti-patterns, use cases |
| renderer | `diagram-design` | editorial SVG/HTML, style tokens, exact coordinates per type, geometry verifiers |
| renderer | `archify` | validated, explorable HTML from typed JSON for 5 modes, repository evidence |
| renderer | chat | ASCII inside a code fence (`references/media.md`) |
| consumers | `pr-explain` (ASCII, SVG), `pr-explain-artifact` (SVG; its badge flow stays HTML), `pr-description` (GitHub Mermaid), `plan-dev` (ASCII), `explain-better` (ASCII, SVG), `explain-diff-html` (HTML, SVG), `playground` (SVG), `lavish`, `codebase-to-course`, any answer with structure | their own look and feel |

The consumer decides the look. This skill decides the shape.
For exact geometry the renderer's reference wins; if this skill contradicts `diagram-design/references/type-*.md` on rendering, fix this skill.

## Step 0: should it be a diagram at all?

The highest-quality move is usually deletion.

- A single shape is a sentence. A list of things is bullets. Attribute-only before/after is a table.
- If a three-column table carries the same information, use the table.
- Draw when the reader must hold several relationships, an order, a containment, a quantity or a position at once.

## Step 1: write the reader's question in one line

A diagram answers one question. Two questions make two diagrams (an overview and a detail).

- "How does a set id travel from the browser to the SQL?" is one diagram.
- "...and who is allowed to read it?" is a second one.

The question names the dominant axis (path, order, state, containment, quantity, position), and the axis picks the type.

## Step 2: behavior first, then layout

When behavior, state, enforcement or risk carries the meaning, choose one semantic pattern before the visual type.
The pattern decides which primitives must appear (statuses, stop marks, queues, residual risk); the type decides the layout.
Full text, budgets and static fallbacks: `references/patterns.md`.

| The reader must understand... | Pattern | Type |
| --- | --- | --- |
| many arrivals competing for finite capacity | fan-in queue / bottleneck | Data flow |
| the same questions, inputs, controls and outputs across stages | stage framework with semantic slots | Process |
| a loose conversation becoming a structured record | unstructured input to structured artifact | Data flow |
| why two decisions differ and where they first diverge | paired policy-evaluation traces | Flowchart |
| which routes cross a trust boundary and which are blocked | secure paved road | Architecture |
| which controls apply at each enforcement surface | governance / control catalog | Layer stack |
| how defenses reduce risk and what remains | compensating security layers | Layer stack |
| a citable decomposition traced to its implementation | traceable block decomposition | Tree |
| one subject's phases, waits, retries and outcomes | lifecycle phase map | State machine |

## Step 3: pick the type from the question

Each family file holds one entry per type: what it answers, use when, not for, grammar, must show, budget, honesty, anti-patterns, its ASCII form, which renderer draws it, and real use cases.

**Structure: what is it made of, how do the parts connect, where does it run?** (`references/structure.md`)

| Question | Type |
| --- | --- |
| What are the components and how do they connect? | Architecture |
| What changed between two versions of a system? | Architecture delta |
| Where does the software actually run? | Deployment |
| What depends on what, with shared dependencies or a cycle? | Dependency graph |
| Parent to children, one parent each? | Tree |
| Who owns what, and where does work escalate? | Org chart |
| What sits inside what (scope, blast radius)? | Nested |
| Which abstraction level sits on which? | Layer stack |
| What is this physical object made of? | Exploded axonometric |
| What is where on a floor or site? | Axonometric plan |
| Which entities exist, with what cardinality? | ER / data model |
| Which tables, columns, keys and indexes? | Database schema |
| Which classes inherit, compose or depend? | UML class |
| A data stack end to end on a cluster | High-level |
| What plugs into a data platform, over which wire? | DP integration |
| Which storage tier holds which quality of data? | Medallion |
| The legacy landscape a proposal replaces | IT current-state |

**Flow: how does it move, decide, or change state?** (`references/flow.md`)

| Question | Type |
| --- | --- |
| Which branch is taken, under which condition? | Flowchart |
| Who calls whom, in what order, and what comes back? | Sequence |
| Which states exist and which events move between them? | State machine |
| Who does which step, and where are the handoffs? | Swimlane |
| Who does which step, with which data and tools? | Process |
| How does data move through a pipeline across roles? | Data flow |
| Which cycle reinforces itself through a shared hub? | Loop |

**Time and plans: when, in what order, what is in progress?** (`references/time.md`)

| Question | Type |
| --- | --- |
| What happened when? | Timeline |
| Which tasks run when, overlapping how? | Gantt |
| What is queued, moving or stuck right now? | Kanban |
| What does one persona do and feel at each stage? | User journey |
| What is the whole story, and where is the first release cut? | Story map |

**Quantity: how much, compared to what, changing how?** (`references/quantity.md`)

| Question | Type |
| --- | --- |
| Which category is bigger? (two values per row: dumbbell) | Bar |
| How does a start total become an end total? | Waterfall |
| How does it trend? (two states: slopegraph; distributions: ridgeline; composition: streamgraph; ranks: bump) | Line family |
| Do two variables move together? (third value: bubble; one variable, many items: beeswarm) | Scatter family |
| Which part dominates the whole? (two levels: marimekko) | Treemap |
| Where does a quantity split and merge? | Sankey |
| Where does the count drop off, or what ranks above what? | Pyramid / funnel |
| One series across cyclic categories | Polar |
| A few entities scored on a few criteria | Radar |
| Which row-by-column combination stands out? | Heatmap |

**Sets, matrices, positioning, causes** (`references/sets-matrices.md`)

| Question | Type |
| --- | --- |
| What do these sets share? | Venn |
| Who may do what, on which resource? | Access matrix (DP security matrix) |
| Where does each item sit on two axes? | Quadrant |
| How evolved is each part of a value chain? | Wardley map |
| What causes this one effect? | Fishbone |

When two types seem to fit, pick the dominant axis. A pattern may add primitives, never a second layout grammar.
For subjects nobody has drawn before, `references/use-cases.md` shows real subjects mapped to the type that fit.

## Step 4: respect the budget

- Default ceiling per diagram: 9 nodes, 12 connectors, 2 focal accents, 2 annotation callouts. Target density about 4 out of 10.
- Each type entry states its own limits; apply the stricter of the pattern budget and the type budget.
- Over budget: split into an overview and a detail. Never shrink text, never drop an edge silently.

## Step 5: pick the medium

| Destination | Medium | Notes |
| --- | --- | --- |
| chat or terminal answer | ASCII in a code fence | `references/media.md`, "ASCII" |
| HTML page or artifact | inline SVG, diagram-design grammar, consumer's style | `references/media.md`, "SVG in HTML" |
| explorable, validated or repo-backed architecture / workflow / sequence / dataflow / lifecycle | `archify` | `references/media.md`, "archify" |
| GitHub markdown (PR body, README) | ASCII in a fence, or Mermaid when a picture beats a table | never Mermaid inside an HTML artifact |
| slide, doc or image | diagram-design export (PNG/SVG) | export only on request |

## Rules that hold in every medium

- **One direction.** Pick left-to-right or top-down for the primary flow and hold it.
- **Focal means one or two.** The accent marks the one or two elements the question is about. Accent on everything is accent on nothing.
- **Every connector carries information.** If layout already says it, delete the line. Label every branch of a decision.
- **Right angles.** Connectors between off-axis nodes bend at right angles with a rounded corner; diagonals only where a type says so (fishbone bones, Wardley links).
- **Labels never sit on a line.** Beside or above it, with a visible gap; short, and in capitals in drawn media.
- **Never color alone.** Status, kind and change also show as text, shape, dash or a badge, so the diagram survives grayscale, color blindness and ASCII.
- **Honest geometry.** Bars start at zero when magnitude matters; areas are proportional to the value; time is spaced as it happened; sets that differ in size are drawn different; no row or column is dropped silently.
- **Legend outside the drawing**, covering every style used and nothing else. A chart with direct labels needs none.
- **Static meaning first.** Motion and interaction are optional layers; the still frame must carry the whole meaning.
- **A text equivalent exists**: a title plus a one-sentence description of the content (not the geometry), or a caption that says the same.
- **Title the finding.** "The median hides the tail" beats "Latency distribution". The accent marks that finding, which is not automatically the biggest value.
- **Every path ends.** Each branch, retry and escalation reaches an outcome; a gate the main flow can bypass is drawn as bypassed.

## Presenting a diagram in an artifact

Beside a diagram in a page, report or explainer, give the reader three short things (the "read-me trio" the best examples use):
the headline claim; how to read the encoding (what position, width, color or dash means); and what the diagram does not show.
Explain in the legend any encoding a reader could misread ("spread is packing, not value", "illustrative figures").

## Taste gate (before delivering)

- [ ] I can state the reader's question in one line, and the diagram answers exactly that.
- [ ] A table or paragraph would not do the same job.
- [ ] Pattern chosen first when behavior, state, enforcement or risk matters.
- [ ] The type's "must show" items are all present.
- [ ] Within budget; otherwise split.
- [ ] Remove test: no node, connector or label can go without losing meaning; no two nodes always travel together.
- [ ] One or two focal elements, and I can say why each is focal.
- [ ] Nothing depends on color alone; every branch and every non-obvious connector is labeled.
- [ ] Honest scale, spacing and areas; nothing dropped silently.
- [ ] Every number and count in the title, caption or cards matches the drawing (published examples get this wrong).
- [ ] Every branch, retry and escalation reaches an outcome.
- [ ] Rendered through the medium's rules in `references/media.md`, and looked at, not just generated.

## References

| File | Read when |
| --- | --- |
| `references/patterns.md` | behavior, state, enforcement or risk carries the meaning |
| `references/structure.md` | components, topology, ownership, containment, data models |
| `references/flow.md` | decisions, messages, states, handoffs, pipelines, cycles |
| `references/time.md` | history, plans, work in progress, journeys, release slicing |
| `references/quantity.md` | any chart of numbers |
| `references/sets-matrices.md` | overlap, permissions, two-axis positioning, evolution, root cause |
| `references/media.md` | rendering in chat, HTML, archify, Mermaid, export |
| `references/use-cases.md` | looking for a precedent: which type fit a similar subject |

Sources: synthesized on 2026-10-08 from `diagram-design` 2.6 (its SKILL.md, semantic patterns, 44 type references and 70 examples) and `archify` 3.0 (its modes, authoring defaults and example scenarios), plus Tris's preferences from the PR-20361 explainer.
