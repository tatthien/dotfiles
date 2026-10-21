# Flow: how it moves, decides, or changes state

Entry format as in `structure.md`. Exact geometry: `diagram-design/references/type-<name>.md`.

## Flowchart

- **Answers:** which branch is taken, under which condition, and where does each branch end?
- **Use when:** decision logic, triage, routing, algorithms, "should I...?" questions; paired policy traces (pattern 4) when two cases diverge.
- **Not for:** messages between actors (Sequence); a subject's states (State machine); who does each step (Swimlane).
- **Grammar:** top to bottom; shape carries the kind: rounded terminal (start, end), rectangle (step), diamond (decision with at most 3 exits), small dot (merge); every exit of a decision labeled, conventionally YES to the side and NO below.
- **Must show:** a label on every decision exit; an end for every branch (no dangling path).
- **Budget:** about 9 nodes; decisions with at most 3 exits.
- **Avoid:** color used to mean node kind (shape does that); a 4-way diamond (nest decisions instead); unlabeled branches; a "retry" path with no exit.
- **Chat:** `[step] ──> <decision?> ──YES──> [step]` with `│ NO` dropping below.
- **Render:** `type-flowchart.md`; archify `workflow`.
- **Seen in:** "should you write this as a skill?" triage (accent on the happy path only); request validation with a token check (imported from Mermaid); lead intake with a NO · FIX rework loop (imported from Excalidraw); policy trace where a sensitive write fails at the data-class rule; PR vs fix deciding whether to clear a URL value (PR-20361, I1).

## Sequence

- **Answers:** who calls whom, in what order, and what comes back?
- **Use when:** request and response flows, protocols, auth and token refresh, API call traces, async jobs, incident reconstructions, back-and-forth between people.
- **Not for:** a subject's progress through states (State machine); ownership of steps (Swimlane).
- **Grammar:** actors in a row at the top, lifelines below; time flows down; messages are horizontal arrows labeled with the call; returns dashed; async uses a different head (open or filled, consistently); activation bars show who holds control; one alt, opt or loop frame with guard labels for branching.
- **Must show:** every message labeled; returns distinguishable from calls; async distinguishable from sync; guards on every branch region.
- **Budget:** 5 lifelines, 12 messages, 1 combined frame, 2 alt regions, nesting depth 1.
- **Honesty:** a message drawn before another must actually happen before it; if something does not block, say so in the drawing, not only in a note.
- **Avoid:** upward arrows; activation bars that never close; if/else as free-floating arrows with no frame.
- **Chat:** actors as columns, one row per message: `Client ──GET /x──> API`, `API - - 200 - -> Client`.
- **Render:** `type-sequence.md`; archify `sequence`.
- **Seen in:** bearer call with refresh on 401 (alt frame); cold-cache article request (edge stores the render); async job round trip with 202, retry and webhook (archify); cache-miss dashboard request (archify).

## State machine

- **Answers:** which states exist, which events move between them, and which outcomes are final?
- **Use when:** order status, auth state, job queues, publication lifecycles; the lifecycle phase map (pattern 9) when one subject's phases, waits and outcomes are the story.
- **Not for:** messages between actors (Sequence).
- **Grammar:** states as rounded boxes along the dominant direction; start as a filled dot, end as a ringed dot; transitions labeled `event [guard] / action`; self-loops above the state; for a phase map, a primary rail plus a wait or recovery band and a terminal band.
- **Must show:** every transition labeled; terminal states distinct (cancelled vs failed); a real transition back for every recoverable failure; no state without a way in.
- **Budget:** about 9 states; transitions at most twice the states (more means two machines).
- **Avoid:** "from any state" arrows drawn from every state; unlabeled transitions; waits or retries placed on the primary rail.
- **Chat:** `[Draft] ──SUBMIT──> [Review] ──APPROVE──> [Published]` with a dashed `REJECT` loop back.
- **Render:** `type-state.md`; archify `lifecycle`.
- **Seen in:** article lifecycle with a reject loop; newsletter publication with approval and delivery-retry detours; deployment release with approval wait and automatic rollback (archify); agent run with retries and expiry (archify).

## Swimlane

- **Answers:** who does each step, and where does work change hands?
- **Use when:** cross-functional processes, RACI-style flows, vendor handoffs, release pipelines.
- **Not for:** flows where data types and tools matter (Process); ownership without order (Org chart).
- **Grammar:** one lane per actor, labeled at the edge; each step inside the lane of the actor who performs it; arrows show the flow; cross-lane handoffs are the important edges.
- **Must show:** every lane labeled; every step in exactly one lane; the risky handoff marked.
- **Budget:** 5 lanes.
- **Avoid:** a step spanning two lanes; arrows snaking back and forth.
- **Chat:** one row per lane `AUTHOR | [Draft] ─> [Open PR]`, handoffs as vertical arrows between rows.
- **Render:** `type-swimlane.md`; archify `workflow` with lanes.
- **Seen in:** publishing an article, where the editor-to-CI deploy trigger is the edge humans cannot undo; incident response runbook (archify); release delivery with canary and rollback (archify).

## Process

- **Answers:** who does each step, with which data going in and out, using which tool?
- **Use when:** multi-actor business processes where payload and tooling change at each step; the stage framework pattern (pattern 2).
- **Not for:** flows where data and tools do not matter (Swimlane).
- **Grammar:** actor lanes by numbered step columns; each step shows a role, a title, `input → output` and a tool; connectors leave the right edge and enter the next step; empty cells stay empty.
- **Must show:** numbered steps; the payload change at each handoff.
- **Budget:** 6 lanes, 12 steps, 1 focal step.
- **Avoid:** placeholder boxes in empty cells; diagonal arrows.
- **Chat:** a table with steps as columns and lanes as rows.
- **Render:** `type-process.md`.
- **Seen in:** order fulfillment across four teams, where stock allocation turns a verified order into a pick list.

## Data flow

- **Answers:** how does data move through a pipeline, and who owns each stage?
- **Use when:** ingest to publish pipelines across roles; the fan-in queue and unstructured-to-structured patterns (patterns 1 and 3); "where money or documents go".
- **Not for:** business processes without data types (Swimlane).
- **Grammar:** role lanes by step columns; each node shows a role, a title and its input and output data types; one labeled focal handoff; governance triggers dashed.
- **Must show:** the data type at each step; who owns each step; the handoff that matters.
- **Budget:** 4 lanes, 6 steps, 1 labeled arrow.
- **Honesty:** a gate drawn on the path must actually be on the path; if the main flow bypasses it, draw the bypass.
- **Avoid:** placeholder boxes; more than one labeled arrow.
- **Chat:** `[Capture] ─LS─> [Land] ─DB─> [Clean] ─TB─> [Publish]` with the owner under each.
- **Render:** `type-data-flow.md`; archify `dataflow`.
- **Seen in:** role-scoped analytics pipeline where raw records become a trusted table; product analytics with a consent gate (archify, where the gate is bypassed by the main flow); order event stream with a dead-letter queue and audited replay (archify); review queue under a traffic spike (fan-in pattern).

## Loop

- **Answers:** which cycle reinforces itself, and what state accumulates at its center?
- **Use when:** flywheels, operating rhythms, feedback loops with a shared memory or hub.
- **Not for:** a path that ends or branches to an outcome (Flowchart).
- **Grammar:** 5-8 stations on one ring, clockwise from the top; ring arrows between stations; dashed write-back spokes from each station into one central hub; at most one focal station.
- **Must show:** the hub; the write-backs (they are the point); where the human decision sits.
- **Budget:** 5-8 stations, 1 hub, 1 focal station.
- **Avoid:** two hubs; solid spokes; mixed straight and curved ring segments.
- **Chat:** a ring of `[station]` with `↻` and `──> (hub)` lines; or a numbered cycle list ending "→ back to 1".
- **Render:** `type-loop.md`.
- **Seen in:** the self-improving loop (capture, research, decide, act, measure, learn) with one human gate.
