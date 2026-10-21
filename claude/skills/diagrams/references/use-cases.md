# Use cases: real subjects and the type that fit

A lookup from "the thing I need to show" to a precedent.
Sources: the 70 `diagram-design` examples (`assets/example-*-full.html`), the 16 `archify` example scenarios (`examples/*.json`), and Tris's own work (marked **Persuit**).
When a precedent fits, open its example file for the exact look; when none fits, route by question in `SKILL.md`.

## Lessons the examples teach (apply them everywhere)

1. **Title the finding, not the variables.** "The median hides the tail", "The biggest risk is not the slowest service", "One pipeline on one runner is a fifth of all CI time", "Where the extra build minutes went". A reader who reads only the title still leaves with the point.
2. **Focal is editorial.** The accent marks the finding (the regression, the risky edge, the gate, the cycle), not the biggest number or the first sorted item. Examples say why in words: "it is the finding, not the first sorted column".
3. **Pair the picture with a read-me trio.** Most examples carry three cards: the headline claim; how to read the encoding ("height is share, so the ridges compare shape"); and what the chart does not show ("a population snapshot, not a growth picture").
4. **Explain any encoding a reader could misread** in the legend: "vertical spread is packing, not value", "spacing is proportional to time", "illustrative figures".
5. **Text must match the drawing.** Checking the examples found a card average that did not match its bars, "three gates" over two diamonds, Gantt dates that disagree with the bars, card numbers that differ from the drawn values. Re-read every number and count in the prose against the figure.
6. **Every branch ends somewhere.** archify's own examples include a retry path with no exit, an escalation with no outcome, and a consent gate the main flow bypasses. Trace each path to an outcome, and draw a bypass as a bypass.
7. **Name the unwanted cells too.** The consultant 2x2 names every scenario and the org chart lists its setup gaps; showing the gaps is part of the truth.
8. **Uneven is honest.** Uneven tree breadth, uneven lane step counts and empty quadrants are kept, not padded.

## By subject

### Requests, APIs and runtime

| Subject | Type | Why it fit | Source |
| --- | --- | --- | --- |
| Read path through CDN and origin | Architecture | zones plus one primary path, dashed cached return | dd `architecture` |
| Every tool lands in or reads from one store | Architecture (zoned) | the hub is the focal node | dd `datalake` |
| A value travels browser to server to SQL, a client field is refused | Architecture + secure paved road | the forbidden ingress stops at the boundary | **Persuit** PR-20361 |
| Bearer call with refresh on 401 | Sequence with alt frame | branching inside a call order | dd `sequence-oauth` |
| Cold-cache page request, async beacon | Sequence | time order plus fire-and-forget | dd `sequence` |
| Async job: 202, retry, webhook, polling | Sequence | two observation paths over time | archify `async-job-roundtrip` |
| Where the service runs, replicas, versions, ports | Deployment | placement is the decision | dd `deployment`, archify `production-deployment` |
| Users, CDN, API, cache, DB, queue on AWS | Architecture with boundaries | region and security-group boundaries | archify `web-app` |

### Change, review and migration

| Subject | Type | Why it fit | Source |
| --- | --- | --- | --- |
| Queue replaces direct dispatch | Architecture delta | stable ids, ledger of changes | dd `architecture-delta` |
| Fraud gate added before payment | Architecture delta (base vs head) | moved edge, removed cache | archify `checkout-platform.*` |
| A rule pasted in two places vs one helper | Architecture delta | ADDED helper, CHANGED queries | **Persuit** PR-20361 P1 |
| Why the PR clears a value and the fix keeps it | Paired policy traces | same rules, first divergence | **Persuit** PR-20361 I1 |
| Why one request is allowed and another denied | Paired policy traces | PASS, FAIL, SKIPPED, NOT REACHED | dd `policy-trace-animated` |
| Which disclosure path needs which ingredient | Access matrix (needs / either / no) | one shared column shows the common root, one focal cell shows what is new | **Persuit** PR-20361 I2 |
| Who sees what before and after a PR | Access matrix with a before/after toggle | changed cells outlined | **Persuit** PR-20361 |

### Data and pipelines

| Subject | Type | Why it fit | Source |
| --- | --- | --- | --- |
| Raw records become a trusted table across roles | Data flow | role lanes, typed payloads, one focal handoff | dd `data-flow` |
| Event stream with dead-letter queue and audited replay | Data flow | failure paths are first-class | archify `event-stream` |
| Product analytics with a consent gate | Data flow | shows a gate the main flow bypasses | archify `product-analytics` |
| Raw to aggregated tiers of one dataset | Medallion | quality rises by tier | dd `medallion` |
| What plugs into a data platform, over which protocol | DP integration | sources, platform, consumers | dd `dp-integration` |
| Data stack phase by phase on Kubernetes | High-level | phase banner plus cross-cutting bars | dd `high-level` |
| Tables, keys, delete rules | Database schema | column-level foreign keys | dd `db-schema` |
| Entities and cardinality | ER | aggregate root plus join | dd `er` |
| Interface, implementations, composition | UML class | the contract callers depend on | dd `uml-class` |

### Engineering metrics

| Subject | Type | Source |
| --- | --- | --- |
| Sprint velocity, one standout sprint | Bar | dd `bar` |
| Signups by channel over 8 weeks | Line | dd `line` |
| p95 before and after a cache, one regression | Slopegraph | dd `slopegraph` |
| Latency shape per service (second peak) | Ridgeline | dd `ridgeline` |
| CI minutes per pipeline over 12 weeks | Streamgraph | dd `streamgraph` |
| Package downloads rank over quarters | Bump | dd `bump` |
| Deploy frequency vs lead time | Scatter | dd `scatter` |
| Error rate vs latency, traffic as area | Bubble | dd `bubble` |
| 138 requests, the tail | Beeswarm | dd `beeswarm` |
| CI failure rate by service and sprint | Heatmap | dd `heatmap` |
| CI minutes by pipeline and runner OS | Marimekko | dd `marimekko` |
| A month of CI minutes split into outcomes | Sankey | dd `sankey` |
| Cloud budget bridge between two years | Waterfall | dd `waterfall` |
| Firms needed before a comparison shows, main vs set | Bar (horizontal, direct labels) | **Persuit** PR-20361 I2 |

### Processes, teams and plans

| Subject | Type | Source |
| --- | --- | --- |
| Publishing an article across four roles | Swimlane | dd `swimlane` |
| Order fulfillment, payload per step | Process | dd `process` |
| Incident response runbook, release with canary and rollback | Workflow (swimlane-like) | archify `incident-response`, `release-delivery` |
| Agent request with an approval gate | Workflow | archify `agent-tool-call` |
| Article or newsletter lifecycle | State machine / lifecycle phase map | dd `state`, `state-lifecycle` |
| Release or agent run with waits, retries, terminals | Lifecycle | archify `deployment-release`, `agent-run` |
| Team board over its WIP limit | Kanban | dd `kanban` |
| 12-week launch with a design-review gate | Gantt | dd `gantt` |
| First release cut of a reporting tool | Story map | dd `story-map` |
| Trial to paid, the trough stage | User journey | dd `journey` |
| Agent team owners and routing | Org chart | dd `org-chart` |
| Review queue under a spike | Fan-in queue pattern | dd `queue-animated` |
| Company operating loop with one human gate | Loop | dd `loop` |
| A feature's history of PRs | Timeline (vertical list when events cluster) | **Persuit** PR-20361 |

### Strategy, risk and structure

| Subject | Type | Source |
| --- | --- | --- |
| Content ideas by impact x effort | Quadrant | dd `quadrant` |
| Four futures of work (remote x AI) | Consultant 2x2 | dd `quadrant-consultant` |
| Value chain and what is commoditizing | Wardley | dd `wardley` |
| Root cause of a latency incident | Fishbone | dd `fishbone` |
| Approved deploys vs a blocked bypass | Secure paved road | dd `paved-road-animated` |
| Product tests (desirable, feasible, viable) | Venn | dd `venn` |
| One set inside another, the difference revealed | Containment with member dots | **Persuit** PR-20361 P5-2 |
| Storage backends on five criteria | Radar | dd `radar` |
| Demand by UTC window | Polar | dd `polar` |
| Content output by rarity | Pyramid | dd `pyramid` |
| Guidance scopes from global to project | Nested | dd `nested` |
| AI app stack, where differentiation lives | Layer stack | dd `layers` |
| Monorepo packages, fan-in and one cycle | Dependency graph | dd `dependency` |
| Skill library taxonomy | Tree | dd `tree` |
| Payment gateway blocks with stable ids | Tree, traceable decomposition | dd `tree-block-decomposition` |
| Legacy reporting landscape before a platform | IT current-state | dd `it-state` |

### Physical and everyday subjects

| Subject | Type | Source |
| --- | --- | --- |
| Phone teardown, unboxing order, app stack as parts | Exploded axonometric | dd `exploded-*` |
| Office floor, phased campus | Axonometric plan | dd `axonometric-plan*` |
| Remaining public holidays this year | Workflow with everyday icons | archify `holiday-planning` |

`dd` = `diagram-design/assets/example-<name>-full.html`; archify = `archify/examples/<name>.*.json`.
