import type { EngineInterface, Register } from "claude-code";

const MODEL = "sonnet";
const MIN_WORDS = 4;
const PREVIEW_CHARS = 72;
const YES = "Yes, polish it";
const NO = "No, send as is";
// Only a prompt starting with this goes to the enhancer (the prefix is stripped); others are sent untouched.
const ASK_PREFIX = ">>";

const SYSTEM = `You rewrite prompts that a developer is about to send to Claude Code, a coding agent working in their repository.

Make the prompt clearer and more actionable: state the goal, the scope, any constraints, and what a finished result looks like. Keep every fact, file path, name and requirement the developer gave, keep their intent and voice, and do not invent details they did not give. If the prompt is already clear, return it almost unchanged.

Reply with the rewritten prompt only: no preamble, no quotes, no explanation.`;

export const register: Register = (on) => {
  on("prompt.submit", async ($, e, next) => {
    const typed = e.text.trim();
    if (e.origin.kind !== "composer" || !typed.startsWith(ASK_PREFIX))
      return next(e);

    const text = typed.slice(ASK_PREFIX.length).trimStart();
    if (!text) return next(e);
    const words = text.split(/\s+/).length;
    // A plugin's resubmission loses attachments, extra context and @file expansion, so those prompts go straight through.
    const canResubmit =
      !e.attachments?.length && !e.context?.length && !/(^|\s)@\S/.test(text);
    if (text.startsWith("/") || words < MIN_WORDS || !canResubmit)
      return next({ ...e, text });

    // A hook may not wait on the person (its budget is 10s), so the prompt is held and the dialog answered after.
    void confirm($, e.text, text);

    return {
      drop: "Held for the prompt enhancer: answer its question, or press Esc to keep editing.",
    };
  }).catch(($, e, next) => next(e));
};

// Asks in Claude Code's own question dialog; Esc (which rejects the ask) puts the prompt back to edit, as typed.
async function confirm($: EngineInterface, typed: string, original: string) {
  let answer: string;
  try {
    answer = await $.ui.ask(
      `“${preview(original)}”\nPolish this prompt before it goes out?`,
      { header: "Prompt", options: [YES, NO] },
    );
  } catch {
    await $.prompt.fill({ text: typed });
    return;
  }

  if (answer === YES) return polish($, original);
  if (answer !== NO) {
    // Text typed under "Type something" is not an answer to send or polish; the prompt goes back to edit.
    await $.prompt.fill({ text: typed });
    return;
  }
  await send($, original);
}

async function polish($: EngineInterface, original: string) {
  $.ui.status("Polishing your prompt…");
  const result = await $.model
    .complete({
      model: MODEL,
      system: SYSTEM,
      prompt: original,
      maxTokens: 4096,
      effort: "low",
    })
    .catch(() => ({
      isAnswered: false as const,
      reason: "request refused",
    }));
  $.ui.status(undefined);
  if (result.isAnswered && result.text.trim()) {
    const improved = result.text.trim();
    $.ui.log(`Improved prompt:\n${improved}`);
    // The person reviews it in the box; their own Enter sends it, as it has no prefix.
    const filled = await $.prompt.fill({ text: improved, mode: "replace" });
    if (!filled.isFilled) {
      $.ui.toast(
        "Could not put the improved prompt in the prompt box; it is in the transcript above.",
      );
    }
    return;
  }
  $.ui.toast(
    `Could not improve the prompt (${result.isAnswered ? "empty reply" : result.reason}); sent it as typed.`,
  );
  await send($, original);
}

async function send($: EngineInterface, text: string) {
  await $.prompt.submit({ text, asUser: true });
  // The held prompt's text comes back into the box after the drop, so it is cleared once sent.
  await $.prompt.fill({ text: "" });
}

function preview(text: string) {
  const flat = text.replace(/\s+/g, " ").trim();
  return flat.length > PREVIEW_CHARS
    ? `${flat.slice(0, PREVIEW_CHARS - 1)}…`
    : flat;
}
