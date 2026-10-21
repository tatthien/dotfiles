# Time and plans: when, in what order, what is in progress

Entry format as in `structure.md`. Exact geometry: `diagram-design/references/type-<name>.md`.

## Timeline

- **Answers:** what happened when, and which moment mattered?
- **Use when:** release history, incident timelines, milestones, a feature's lineage of PRs.
- **Grammar:** one baseline; ticks at real time boundaries with dates; events as small dots, labels alternating above and below on short drops; major milestones larger and accented; optional ghost year numerals behind.
- **Must show:** an axis with units; the milestone that matters.
- **Honesty:** spacing follows real elapsed time; when events cluster (two events two days apart after months of gap), break the axis visibly or use a vertical list that makes no claim of scale.
- **Avoid:** equal spacing for unequal intervals; crowded labels with no offset.
- **Chat:** a left-to-right line with labeled ticks, or a dated vertical list.
- **Render:** `type-timeline.md`.
- **Seen in:** fourteen months of a design system (version 3 set the complexity budget); the PR lineage behind a feature (PR-20361 explainer, drawn as a vertical list because two events were two days apart).

## Gantt

- **Answers:** which tasks run when, overlapping how, and which one gates the rest?
- **Use when:** project plans, roadmaps, launch schedules with phases and a critical gate.
- **Grammar:** task labels in a left column grouped under phase headers; time axis across; one bar per task row; the focal task or gate accented; an optional dashed "today" or milestone line.
- **Must show:** the gate or critical task; phase grouping.
- **Budget:** 12 tasks, 5 parallel tracks per phase.
- **Honesty:** bar positions must match the dates stated anywhere in the text.
- **Avoid:** dates printed inside bars; more than 12 tasks.
- **Chat:** rows with `█` bars over a week ruler.
- **Render:** `type-gantt.md`.
- **Seen in:** a 12-week product launch where design review in week 8 is the gate.

## Kanban

- **Answers:** what is queued, moving, stuck or done right now, and where is a WIP limit breached?
- **Use when:** a snapshot of work in progress.
- **Not for:** any flow or handoff: a board has no arrows (Swimlane or Process).
- **Grammar:** up to 5 columns with a header and a WIP chip (`4/3`); cards with id and owner; card states default, blocked, waiting, done; blocked cards marked with more than color.
- **Must show:** WIP limits on in-process columns; the blocked card and why.
- **Budget:** 5 columns, 4 cards per column, 12 cards.
- **Avoid:** arrows between cards; in-process columns without limits.
- **Chat:** columns per status, one short card per line, `⚠ blocked` marker.
- **Render:** `type-kanban.md`.
- **Seen in:** a platform team board over its WIP limit because one ticket waits on a vendor window.

## User journey

- **Answers:** what does one persona do at each stage, and how does it feel?
- **Use when:** onboarding, trial-to-paid, support experiences; a sentiment can be named for each stage.
- **Not for:** system flows with no human (Architecture, Data flow).
- **Grammar:** stage columns; a sentiment curve on three named levels (high, neutral, low); rows for actions and touchpoints; pain markers under the trough stage.
- **Must show:** the sentiment curve (it is load-bearing); the trough and its cause.
- **Budget:** 6 stages, 3 content rows, 2 pain markers.
- **Avoid:** a numeric sentiment axis; emoji as sentiment.
- **Chat:** stage row, then a sparkline of sentiment `▆▇▅▁▃`, then the pain note.
- **Render:** `type-journey.md`.
- **Seen in:** trial to paid in the first week, where hitting the free-tier limit with no warning is the trough.

## Story map

- **Answers:** what is the whole user story, and where is the first release cut?
- **Use when:** slicing an epic into releases; narrative left to right, priority top to bottom.
- **Not for:** state of work (Kanban); one persona's feelings (User journey).
- **Grammar:** backbone activities across the top in narrative order; walking-skeleton steps beneath; release slice bands with story cards; a full-width release-cut line under the first slice; the riskiest story marked.
- **Must show:** the release cut; the riskiest story and which side of the cut it falls on.
- **Budget:** 5 activities, 3 slices, 12 stories.
- **Avoid:** columns ordered by priority instead of narrative; slices named by date instead of outcome.
- **Chat:** activities as column headers, slices as rows, `═══ RELEASE CUT ═══` line.
- **Render:** `type-story-map.md`.
- **Seen in:** a reporting tool's first release, where row-level permissions (the riskiest story) falls just after the cut.
