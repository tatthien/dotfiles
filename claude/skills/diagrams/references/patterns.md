# Semantic patterns

A pattern describes what a system does; a type describes how the picture is arranged.
Choose a pattern first when behavior, state, enforcement or risk carries the meaning, then draw it with the pattern's nearest type.
Use one primary pattern per figure. A second pattern may lend at most one primitive; if both need full treatment, split overview and detail.
Every pattern must be complete in a single still frame: labels and outcomes never depend on motion or hover.

Source: `diagram-design/references/semantic-patterns.md` (rendering detail and SVG examples live there).

## 1. Fan-in queue / bottleneck

- **Triggers:** several producers converge on one reviewer, service, gate or scarce resource, and the story is arrival rate, queue depth, wait, capacity or backpressure.
- **Must show:** distinct sources; fanned ingress; an ordered queue with visible slots and a count; a capacity or service-rate label with units (`8/hour`, `3 slots`); one constrained service point; admitted and deferred or rejected outcomes.
- **Budget:** 5 sources, 5 queue slots, 1 bottleneck, 2 outcomes, 9 primary nodes. Aggregate extra sources into a named cohort.
- **Avoid:** an equal-width pipeline that hides contention; arrows merged before they can be traced; capacity implied only by box size; "red means overloaded" with no words.
- **Type:** Data flow; Process when service stages dominate rather than sources.
- **Seen in:** diagram-design `example-queue-animated` (review queue).

## 2. Stage framework with semantic slots

- **Triggers:** a lifecycle or operating model asks the same questions at every stage (Question, Input, Governance, Output), and comparing stages matters more than timing.
- **Must show:** ordered stage headers; one slot grid used identically in every stage; explicit empty or "not applicable" slots; stage-to-stage handoff; one primary output per stage.
- **Budget:** 3-6 stages, 3-4 slot kinds, 20 populated cells, 2 lines per cell.
- **Avoid:** each stage inventing its own internal layout; slot meaning carried by position with no labels; shrinking text to fit.
- **Type:** Process; Swimlane only when rows are owners rather than slots.

## 3. Unstructured input to structured artifact

- **Triggers:** dialogue, notes or a rambling request are elicited, normalized and written into a brief, ticket, record or schema.
- **Must show:** a short source excerpt; clarifying questions; extracted field-value pairs; the named transformation; the artifact boundary; at least one provenance link from a statement to a field; unknown fields left visibly unknown.
- **Budget:** 4 exchanges, 6 fields, 1 transformation, 3 provenance links.
- **Avoid:** "AI magic" sparkle between two boxes; fields with no source; inventing certainty for missing facts.
- **Type:** Data flow; Process when elicitation has several ordered gates.

## 4. Paired policy-evaluation traces

- **Triggers:** two otherwise similar requests reach different outcomes, and the reader needs each rule's state and the first point where the two traces diverge. Typical: "why does the PR clear the value while the fix keeps it", "why was user A allowed and user B denied".
- **Must show:** the same ordered rules on both traces; explicit status words plus a symbol or shape: `PASS`, `FAIL`, `SKIPPED` (the rule was applicable but bypassed), `NOT REACHED` (evaluation stopped earlier); the differing inputs; one outcome per trace; a labeled first-divergence marker.
- **Budget:** exactly 2 traces, 3-6 rules, 1 first divergence, 12 status cells.
- **Avoid:** comparing two independently ordered flows; colored dots without words; treating SKIPPED and NOT REACHED as synonyms; highlighting every difference; continuing a stopped trace as if later rules ran.
- **Type:** Flowchart (ordered decision logic); Sequence only when messages between actors and time also matter.
- **Seen in:** diagram-design `example-policy-trace-animated`; PR-20361 explainer, finding I1 (see `use-cases.md`).

## 5. Secure paved road

- **Triggers:** an architecture defines the supported route through trust boundaries; permitted and forbidden ingress, approved and blocked paths, and privileged moments are the point.
- **Must show:** labeled trust boundaries; actors and identities; permitted ingress with a positive label; forbidden ingress that visibly stops at the boundary (a stop mark plus a different line style, not color alone); the approved path; any blocked bypass; the privileged gate; where audit goes.
- **Budget:** 3 trust zones, 8 components, 10 paths, 2 forbidden paths, 1 privileged gate.
- **Avoid:** a dashed box called "security" with no route meaning; a forbidden arrow that crosses into the protected zone; a bypass that visually rejoins the approved route.
- **Type:** Architecture.
- **Seen in:** diagram-design `example-paved-road-animated`; PR-20361 explainer, "a firm list from the browser never reaches the server".

## 6. Governance / control catalog

- **Triggers:** a set of controls must be understood by where it is enforced: authoring, workspace, merge or CI, deploy or runtime.
- **Must show:** enforcement-surface groups; named controls; who enforces (code, platform, human); when (write, merge, deploy, run); the bypass or exception route; coverage gaps.
- **Budget:** 3-5 surfaces, 3-7 controls each, 24 total, 3 attributes per control.
- **Avoid:** 35 tiny pills; grouping by vague theme instead of enforcement point; mixing aspirations with enforced controls.
- **Type:** Layer stack; Access matrix when role permissions, not surfaces, dominate.

## 7. Compensating security layers

- **Triggers:** no layer is perfect; each defense covers a gap left by the previous one, and the residual risk must visibly narrow, transfer or remain.
- **Must show:** the incoming threat; ordered layers with their mitigation and their limitation; the residual risk carried between layers; the final residual risk and the response to it. Use words or decreasing measures, never area alone.
- **Budget:** 3-5 layers, 1 risk thread, 2 mitigations per layer, 1 final residual-risk statement.
- **Avoid:** implying the last layer makes risk zero; treating audit as prevention; equal slabs with no propagation.
- **Type:** Layer stack; Nested when containment boundaries carry the meaning.

## 8. Traceable block decomposition

- **Triggers:** a system decomposes into blocks that someone must cite by a stable ID (compliance, audit, IP record) and trace to the code that implements them.
- **Must show:** a stable dotted ID per block (`PAY-001-02`) as a badge; a noun-phrase block name (the structural element, not an action); parent-child structure only. Inputs, outputs, constraints and implementation paths go in metadata or a registry, not on the canvas.
- **Budget:** the Tree budget (root plus 3 tiers, 5 per level, 9 nodes); split per subsystem beyond that.
- **Avoid:** IDEF0 four-sided boxes; arrows between siblings (that is a dependency graph); verb-phrase names; treating the picture as the full record.
- **Type:** Tree.
- **Seen in:** diagram-design `example-tree-block-decomposition` (payment gateway blocks).

## 9. Lifecycle phase map

- **Triggers:** one subject moves through a few named phases, and waits, retries, cancellation and terminal outcomes matter as much as the happy path.
- **Must show:** a primary phase rail (4-5 phases, in reading order); a separate band for waits and recovery; a separate band for terminal outcomes; labeled transitions; distinct terminal states for cancellation and failure; a labeled re-entry point for every retry.
- **Budget:** 4-5 phases, 2 wait or recovery states, 2 terminal states, 9 states, 10 transitions.
- **Avoid:** actor lifelines disguised as phases; interruption states on the primary rail; cancellation and failure merged into one color; a retry loop with no labeled re-entry; a recovery path that has no real transition back.
- **Type:** State machine; Sequence when actor messages carry the story.
- **Seen in:** diagram-design `example-state-lifecycle`; archify `deployment-release.lifecycle.json`, `agent-run.lifecycle.json`.

## Composition rules

- The pattern specializes statuses, boundaries, queues or propagation; the type still owns the axis, connector grammar, spacing and limits.
- Apply the stricter budget of pattern and type.
- Status and outcome are always readable as text; color, motion and position only reinforce.
