---
name: write-plainly
description: Write or revise AI-generated prose so it is clear, direct, concise, and easy to understand without losing accuracy. Use when a user asks to simplify, clarify, humanize, de-jargon, tighten, summarize, explain for a novice or child, create a TL;DR, improve an AI answer, or rewrite prose or Markdown in plain language. Preserve technical material and source structure when editing existing content.
---

# Write Plainly

Produce the finished response in plain language. Improve readability without changing meaning, weakening important caveats, or inventing details.

## Choose the mode

- Use **plain** by default: keep the useful information while making it easier to read.
- Use **TL;DR** when the user asks for a summary: aim for half the original length or less and keep the key facts, decisions, actions, numbers, and constraints.
- Use **child-friendly** when the user asks for "ELI5," "like I'm five," or similar: use very simple words, short sentences, a warm tone, and accurate comparisons. Do not turn a safety-critical or technical answer into a misleading analogy.
- Follow any explicit audience, tone, length, format, or language request instead of these defaults.

## Apply the workflow

1. Identify the message, passage, file, or requested answer to improve. Treat the user's question as context; do not rewrite or answer it again when the task is to transform supplied text.
2. Extract the non-negotiable content: facts, names, numbers, dates, decisions, conditions, warnings, citations, links, paths, commands, identifiers, and requested actions.
3. Rewrite the prose in the selected mode. Put the outcome first. Prefer familiar words, active voice, concrete verbs, short sentences, and short paragraphs.
4. Keep necessary technical terms when simpler wording would be less precise. Define the term briefly on first use when the audience may not know it.
5. Run a silent integrity check against the source or gathered facts. Restore anything important that was lost or altered.
6. Return only the finished content unless the user asks for commentary, a comparison, or an explanation of the edits.

## Preserve exact material

- Keep facts, names, numbers, dates, paths, commands, identifiers, URLs, citations, and quoted output accurate.
- Keep uncertainty, scope limits, prerequisites, exceptions, and safety warnings. Do not make a qualified claim sound certain.
- Leave fenced code blocks unchanged unless the user explicitly asks to edit code.
- Preserve inline code exactly unless correcting it is part of the request.
- Preserve Markdown headings, lists, tables, links, and YAML frontmatter when rewriting a document. Rewrite prose inside the structure; keep link targets and frontmatter values unchanged.
- Keep the source language unless the user requests another language. When translating prose, keep code, identifiers, paths, commands, and link targets unchanged.

## Improve readability

- Remove throat-clearing, repetition, inflated phrasing, needless hedges, and meta-commentary.
- Break up long sentences and dense paragraphs.
- Prefer a short list only when the items are genuinely parallel or easier to scan as steps.
- Retain examples that materially improve understanding; remove decorative examples in TL;DR mode.
- Avoid talking down to the reader. Plain language should feel capable and natural, not childish, unless child-friendly mode was requested.
- Avoid labels such as "Here is the rewritten version" unless they help distinguish multiple requested outputs.

## Handle new answers

When the user asks a question rather than supplying text, draft the answer directly in plain language. Do not create a dense answer and then append a second rewrite. Preserve the depth needed to solve the task; simplify the expression, not the reasoning.
