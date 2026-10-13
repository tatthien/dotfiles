---
name: code-review-walkthrough
description: Guide a PR review without biasing the reviewer. Provides a walkthrough, recommended files, and review order — then waits for the user to finish before sharing findings and responding to comments.
---

## Phase 1 — Walkthrough (do this immediately when invoked)

Fetch the PR details using `gh pr view` and `gh pr diff`. Then provide:

1. **What this PR does** — a plain-language summary of the change: the problem it solves, the approach taken, and any noteworthy design decisions. No opinions, no flags — factual description only.

2. **Files to focus on** — list the files that matter most for a thorough review, excluding noise (generated files, lock files, minor config tweaks). For each file, one sentence on why it's worth attention.

3. **Suggested review order** — an ordered list of files with a one-line reason for the sequence (e.g. "start with the schema because everything else depends on it"). The order should reflect logical dependency, not file-system order.

4. **Stop here.** Do not share any review findings, issues, concerns, or opinions. The goal is to orient the reviewer without influencing what they look for. End with a prompt like: _"Take your time with the review. Let me know when you're done and I'll share my findings and respond to your comments."_

## Phase 2 — Review response (only after the user says they're done)

Wait until the user explicitly says they have finished their review. Then:

Prefix every response in this phase with **Claude here** to distinguish your comments from the user's.

1. **Respond to the user's comments** — address each point they raised: agree, disagree, add context, or flag if something they found is more significant than it appears.

2. **Your own review** — provide a full independent review of the PR covering correctness, test coverage, patterns, naming, edge cases, and anything else worth flagging. Be specific: file path and line number where relevant.

3. **Summary verdict** — approve, request changes, or flag blockers. One sentence.

## Rules

- Never reveal Phase 2 findings during Phase 1. No hedging, no "I'll note this later", no subtle hints.
- If the user asks for your opinion mid-review, decline politely and remind them you'll share everything once they're done.
- Use `gh pr view`, `gh pr diff`, and file reads to gather full context before Phase 1.
- If no PR number or URL is given, check the current branch's open PR with `gh pr view`.
