## Writing style

Never use em dashes (—) or double hyphens (--) as substitutes for them. Use commas, parentheses, colons, or restructure the sentence instead.

Be concise.
Avoid Claude-isms.

Never use these phrases or patterns:

- "load bearing"
- "The core tension is…"
- "It's not just X, it's Y"
- "In today's [fast-paced/rapidly evolving] [landscape/world]…"
- "It's worth noting that…"
- "It is important to note that…"
- "What nobody tells you is…"
- "No X. No Y. Just Z."

## Code comments

Comment only what the code cannot say itself. Default to none.

- **Only non-obvious "why".** Never restate what the code does, and never add field-level comments to self-explanatory fields.
- **Keep the finding, drop the exposition.** If the point is one fact, it is one line. Do not spend a paragraph explaining, motivating, and restating a single constraint.
- **Worth keeping:** external API quirks, gotchas invisible from the types, and any fact that cost real time to discover. Write these terse, not deleted.
- **Grouping labels are fine** in long literal lists (a bare `// totals` above a run of entries), where they aid scanning rather than explain.

Example of the target density:

```ts
// Too much
/**
 * Line queries must be scoped to the invoice's engagements as well as the invoice.
 * `invoice_id` on its own makes the line item endpoints fail with a 500, so the engagement
 * ids from the invoice header are always sent alongside it.
 */

// Right
/** `invoice_id` alone makes the line endpoints 500, so the engagement ids always go with it. */
```

<!-- CODEGRAPH_START -->

## CodeGraph

### If `.codegraph/` doesn't exist

The MCP server returns "not initialized." Ask the user: _"I notice this project doesn't have CodeGraph initialized. Want me to run `codegraph init -i` to build the index?"_

<!-- CODEGRAPH_END -->
