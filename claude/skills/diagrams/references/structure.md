# Structure: what it is made of, how the parts connect, where it runs

Entry format: **Answers** (the reader's question) · **Use when** · **Not for** (with the better type) · **Grammar** (how the picture is organized, renderer-neutral) · **Must show** · **Budget** · **Honesty** where it matters · **Avoid** · **Chat** (ASCII form) · **Render** (where exact geometry lives) · **Seen in** (real examples).
Exact coordinates live in `diagram-design/references/type-<name>.md`; examples in `diagram-design/assets/example-<name>-full.html`.

## Architecture

- **Answers:** what are the components, and how does a request or value travel between them?
- **Use when:** system overviews, request paths, integration maps, infrastructure topology, "follow one id from the browser to the database".
- **Not for:** two versions of the system (Architecture delta); placement on hosts with replicas and versions (Deployment); order of messages over time (Sequence).
- **Grammar:** components grouped into at most 3 zones by tier or trust boundary; one primary direction (left to right or top down); connectors as right-angle routes carrying a short label (protocol, action, payload); returns and async dashed.
- **Must show:** every zone named; the primary path distinguishable from secondary ones; labels on every connector whose meaning the endpoints do not imply.
- **Budget:** 9 nodes, 12 connectors, 3 zones, 1-2 focal (the primary integration point, store or decision).
- **Avoid:** every box accented; a bidirectional arrow where one direction is obvious; a legend floating inside the drawing; a "security" box with no route meaning (use the secure paved road pattern).
- **Chat:** zones as labeled `+--+` boxes side by side, nodes inside, `──LABEL──>` between them.
- **Render:** `type-architecture.md`; archify `architecture`.
- **Seen in:** content site in production (edge absorbs reads, origin renders on miss); open data lake stack (every tool lands in or reads from one store); order platform request path (imported from draw.io); sample web app on AWS (archify); competitor-set request flow (PR-20361).

## Architecture delta

- **Answers:** what changed between two versions of a system, and what stayed?
- **Use when:** migrations, service extraction, replacing direct calls with a queue, a reviewer's "today vs proposed" sketch.
- **Not for:** attribute-only changes (a table); a single snapshot (Architecture); deployment phases (Timeline).
- **Grammar:** three panels read Before, Changes, After; both snapshots share size and grid; a retained component keeps its Before position unless the change is a move; the center is a short ledger, one line per changed object, starting with the change word (ADDED, REMOVED, CHANGED, MOVED, REWIRED).
- **Must show:** stable names or ids in both snapshots; a non-color marker per change (`+`, `-`, `Δ`, dashed ghost); a ledger entry for every changed object and none for unchanged ones.
- **Budget:** 8 unique components, 10 relationships, 8 ledger entries.
- **Avoid:** two independently arranged snapshots that fake movement; a ledger that says only "updated"; color-only status.
- **Chat:** two columns `BEFORE | AFTER` with the same rows, plus `+ ~ -` markers and a one-line note per change.
- **Render:** `type-architecture-delta.md`; archify `architecture` base/head pair.
- **Seen in:** order fulfilment with a durable queue replacing direct dispatch; checkout platform adding a fraud gate (archify base vs head); one shared peer-cohort helper replacing two pasted SQL copies (PR-20361, P1).

## Deployment

- **Answers:** where does the software actually run?
- **Use when:** the placement decision matters: zones, hosts, pods, managed services, replica counts, versions, ports.
- **Not for:** logical architecture with hostnames bolted on (Architecture).
- **Grammar:** three levels of nesting: environment or network zones, infrastructure nodes with a type tag, artifact chips with a version; network paths labeled with protocol and port; replication dashed.
- **Must show:** zone boundaries between environments; replica counts; a version on every artifact; ports on network paths.
- **Budget:** 3 zones, 6 infrastructure nodes, 9 artifacts, 8 paths, 2 focal.
- **Avoid:** two environments mixed without a boundary; artifacts without versions.
- **Chat:** nested boxes `[zone [node x3 (artifact v1.2)]]`, paths as `──TLS:5432──>`.
- **Render:** `type-deployment.md`; archify `architecture` with region and security-group boundaries.
- **Seen in:** checkout service in production (one primary database is the single point of failure); production deployment with ownership tags per node (archify).

## Dependency graph

- **Answers:** what depends on what, when a node has several parents or there is a cycle?
- **Use when:** packages in a monorepo, services, modules; reading fan-in; finding the one cycle.
- **Not for:** single-parent hierarchies (Tree).
- **Grammar:** nodes in rank rows by dependency depth, forward edges pointing one way; a fan-in count badge per node; the cycle as one dashed back-edge routed around the outside and labeled.
- **Must show:** rank order; fan-in counts; every cycle labeled.
- **Budget:** 9 nodes, 14 edges, 4 ranks, 1 highlighted cycle.
- **Avoid:** a hairball with no ranking; forward edges pointing against the rank direction.
- **Chat:** rank rows top to bottom, `──>` with `┐ ├ ┘` merges for shared dependencies, `⟲ CYCLE` on the back-edge.
- **Render:** `type-dependency.md`.
- **Seen in:** TypeScript monorepo where one shared-types package has four dependents and one cycle.

## Tree

- **Answers:** what are the children of each parent?
- **Use when:** taxonomies, file trees, decision breakdowns, skill libraries; citable block decomposition (pattern 8).
- **Not for:** multi-parent structures (Dependency graph); ownership and routing (Org chart).
- **Grammar:** root at top (or left); orthogonal bus connectors (parent drop, sibling bus, child drops); tiers aligned.
- **Must show:** every level; uneven breadth left uneven when that is the truth.
- **Budget:** depth 4 (root plus 3), breadth 5 per level, 1 focal.
- **Avoid:** diagonal connectors; skipped levels; 5 or more levels on one page.
- **Chat:** an indented tree with `├─` and `└─`, one-line note per entry.
- **Render:** `type-tree.md`.
- **Seen in:** a skill taxonomy (one root, three categories, uneven leaves); payment gateway blocks with stable ids.

## Org chart / responsibility map

- **Answers:** who owns what, how is work routed in, and where does it escalate?
- **Use when:** human or agent teams, support routing, escalation maps; the question is ownership, not just hierarchy.
- **Not for:** generic hierarchy (Tree); what happens next (Swimlane).
- **Grammar:** a front door at the top, then tiers of teams and owners on an orthogonal bus; each node shows a name, how to invoke it (handle, queue, trigger) and a few scope words; owners not yet live are dashed; gaps listed in a side strip.
- **Must show:** the front door; invocation per owner; gaps shown, not hidden.
- **Budget:** 12 nodes, 4 tiers, 5 reports per parent, 1 focal, 2 side callouts.
- **Avoid:** identical boxes for every person; unavailable owners drawn as active.
- **Chat:** indented tree with `@handle` per node and a `GAPS:` line.
- **Render:** `type-org-chart.md`.
- **Seen in:** an agent team responsibility map with a front-door router and three setup gaps.

## Nested containment

- **Answers:** what sits inside what, from broadest scope to most specific?
- **Use when:** scopes, trust zones, config inheritance, folder scoping, blast radius.
- **Not for:** content inside the rings that is not part of the hierarchy (a sibling diagram).
- **Grammar:** concentric rounded rectangles with even inset; each level labeled on its top edge; emphasis rises inward; the focal level is the innermost one being discussed.
- **Must show:** every level named; the reading direction (outside-in) stated.
- **Budget:** 6 levels.
- **Avoid:** uneven padding; accent on several levels.
- **Chat:** nested `+--+` boxes with the label in each top border.
- **Render:** `type-nested.md`.
- **Seen in:** project guidance hierarchy, where the innermost folder inherits every instruction above it.

## Layer stack

- **Answers:** which abstraction level sits on which, and which layer matters most?
- **Use when:** tech stacks, OSI-style models, memory hierarchies; governance catalogs and compensating security layers (patterns 6 and 7).
- **Not for:** things that are not actually hierarchical (Swimlane or Architecture).
- **Grammar:** 4-6 full-width bands stacked vertically, each with an index (L1..L5), a name and a note; a direction axis outside the stack; one focal band.
- **Must show:** the order and what the direction means (abstraction to silicon, request to storage).
- **Budget:** 6 layers.
- **Avoid:** skipped numbering; a different color per layer.
- **Chat:** stacked boxes, callers above callees, index on the left.
- **Render:** `type-layers.md`.
- **Seen in:** AI app stack where the agent harness, not the model, is where differentiation lives.

## Exploded axonometric

- **Answers:** what is this physical object made of, and in what order do the parts come apart?
- **Use when:** device teardowns, unboxing order, a stack drawn as physical parts.
- **Not for:** ordered abstraction levels with notes (Layer stack); connections (Architecture).
- **Grammar:** 2-5 parts as solid slabs pulled apart along one vertical axis with equal gaps; labels in one side column with horizontal leaders; no arrows.
- **Must show:** every part labeled; the focal part.
- **Budget:** 5 parts, 1 focal.
- **Avoid:** outline-only parts; exploding along two axes; unequal gaps.
- **Chat:** none; use a layer stack or a list.
- **Render:** `type-exploded.md`.
- **Seen in:** phone teardown (the logic board is the phone); speaker unboxing in the order you see it; a three-layer app stack.

## Axonometric plan

- **Answers:** what is where on one floor or site, and how is each space used?
- **Use when:** office floors, campuses, phased building plans.
- **Not for:** containment without geography (Nested); where software runs (Deployment); a list of rooms (a table).
- **Grammar:** a 2:1 angled view of one plate; rooms or buildings as low prisms painted back to front; walls cut at desk height; horizontal tags with a name and one fact (capacity, phase).
- **Must show:** every tagged space; the one space under discussion.
- **Budget:** 8 tagged spaces, 1 focal.
- **Avoid:** full-height walls that hide rooms; a numbered key instead of tags.
- **Chat:** none; use a table.
- **Render:** `type-axonometric-plan.md`.
- **Seen in:** level 3 office (the meeting room under discussion); a north campus built in three phases.

## ER / data model

- **Answers:** which entities exist, how they relate, with what cardinality?
- **Use when:** conceptual and logical models, API resources, domain models.
- **Not for:** physical tables with types and indexes (Database schema); classes with operations (UML class).
- **Grammar:** entity boxes with a name header and one field per line (`#` primary key, `→` foreign key); relationship lines with cardinality at both ends and an optional verb label; related entities clustered so lines stay short.
- **Must show:** cardinality at both ends; the aggregate root when there is one.
- **Budget:** 8 entities.
- **Avoid:** an arrow for every foreign key on a large model; inconsistent cardinality notation.
- **Chat:** boxes with field lists, `1 ──WRITES── N` between them.
- **Render:** `type-er.md`.
- **Seen in:** content platform model with Article as the aggregate root and a many-to-many join.

## Database schema

- **Answers:** which physical tables, columns, keys, indexes and delete rules exist?
- **Use when:** migrations, reviewing a real database, when the SQL type or `ON DELETE` behavior is the point.
- **Not for:** domain modeling (ER).
- **Grammar:** a table per box with `schema.table` header, column rows (name, type, constraint chips PK FK UQ NN), an optional indexes section; foreign keys drawn column to column and labeled with their delete rule; non-default schemas in a dashed group.
- **Must show:** delete rules on every foreign key; truncated columns marked "+ N more".
- **Budget:** 5 tables, 8 columns shown per table, 6 foreign keys.
- **Avoid:** every column of every table; box-to-box foreign keys; unlabeled foreign keys.
- **Chat:** a table per block with columns listed, `orders.id <── order_items.order_id (CASCADE)`.
- **Render:** `type-db-schema.md`.
- **Seen in:** commerce schema where only order deletion cascades.

## UML class

- **Answers:** what do classes own, inherit, implement or depend on?
- **Use when:** object models where operations and inheritance or composition are the point.
- **Not for:** entities and cardinality only (ER); other UML diagrams (Sequence, State machine).
- **Grammar:** class boxes split into name, attributes and operations; relationship markers: hollow triangle (extends, implements), filled diamond (composition), hollow diamond (aggregation), open arrow (association or dependency), dashed lines for dependency and realization; multiplicities at the ends.
- **Must show:** the interface or contract that callers depend on; multiplicities on associations.
- **Budget:** 7 classes, 8 relationships, 5 members per compartment.
- **Avoid:** getters and setters as operations; composition and aggregation used interchangeably.
- **Chat:** boxes with members, relationship words on the lines (`implements`, `owns 1..*`).
- **Render:** `type-uml-class.md`.
- **Seen in:** payments domain where the service depends only on a PaymentMethod interface.

## High-level (data stack on a cluster)

- **Answers:** what is the end-to-end data stack, phase by phase, on its orchestrator?
- **Use when:** ingestion, storage, query, analytics and visualization deployed on Kubernetes or similar.
- **Grammar:** a banner of phase chevrons across the top; one component under each phase inside the cluster boundary; sources in a dashed zone on the left; cross-cutting concerns (orchestration, identity, monitoring) as full-width bars, optionally paired with a vertical chevron strip.
- **Budget:** 1 focal node, 3 outgoing edges per node.
- **Avoid:** omitting the phase banner; a node off its phase.
- **Chat:** a row of phases with one component under each, bars below.
- **Render:** `type-high-level.md`.
- **Seen in:** open-source data stack (NiFi, MinIO, Trino, notebooks, Superset) with Airflow and identity as bars.

## DP integration

- **Answers:** what plugs into the platform, what plugs out, over which wire?
- **Use when:** sources on the left, consumer surfaces on the right, the platform zone in the middle; the protocol matters.
- **Not for:** how data moves through phases over time (Data flow, Medallion).
- **Grammar:** source column, platform zone with bars and component rows, consumer column; connectors labeled with the protocol; shared services (identity, logging) as footer bands connected to the zone, never to one tool.
- **Budget:** typically 14-20 nodes (an allowed exception), exactly 2 focal components.
- **Avoid:** collapsing distinct sources into one node; a footer wired to a single tool.
- **Chat:** three columns `SOURCES | PLATFORM | CONSUMERS` with protocol words on the arrows.
- **Render:** `type-dp-integration.md`.
- **Seen in:** generic data platform: CRM over REST, POS as CSV, events into storage, a query engine serving BI and a partner API.

## Medallion

- **Answers:** which storage tier holds which quality of the data, who writes it, and how is it promoted?
- **Use when:** raw, anonymized, staging, aggregated and archive tiers of the same dataset.
- **Not for:** role lanes in a workflow (Process); the cluster architecture (High-level).
- **Grammar:** tier cards left to right (header, bucket, tool, format, writer, examples); promotion arcs over the top labeled with the transformation; archive dashed.
- **Budget:** 3-6 tiers, exactly 1 focal tier.
- **Avoid:** bidirectional promotion; dashed "cold" styling on a non-archive tier.
- **Chat:** a row of tiers with `──MASK IDS──>` style promotions.
- **Render:** `type-medallion.md`.
- **Seen in:** five-tier e-commerce analytics storage where the aggregated tier is the query surface.

## IT current-state

- **Answers:** what does the legacy landscape look like, and where is the friction a proposal will remove?
- **Use when:** the before picture of a modernization: departments or phases, file handoffs, manual steps, pain points.
- **Grammar:** 2-4 zones in reading order, 1-5 systems each; connectors labeled with the handoff format (CSV, EMAIL, COPY); external systems dashed; the system that survives styled distinctly.
- **Budget:** 16 components, 2 focal (the worst bottlenecks).
- **Avoid:** accenting every pain point; diagonal arrows.
- **Chat:** zones as boxes, handoffs as `──CSV──>`, `⚠` on the bottlenecks.
- **Render:** `type-it-state.md`.
- **Seen in:** legacy retail reporting: shared drive with no versioning, portal refreshed by hand, PDFs by email.
