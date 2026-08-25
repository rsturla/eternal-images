---
name: asd-ste100
description: Rewrite and check technical text against ASD-STE100 Simplified Technical English, a controlled English with short sentences, active voice, simple tenses, and approved words. Use when the user asks to apply STE, simplify technical writing, reduce ambiguity or "AI slop", check STE compliance, or write documentation, comments, or commit messages in a clear controlled style.
---

# ASD-STE100 Simplified Technical English

Simplified Technical English (STE) is a controlled language from the aerospace
industry. It uses a set of writing rules and a dictionary of approved words. The
goal is text that a reader cannot misread, including a non-native reader.

This skill is an unofficial aid. It does not guarantee full compliance. For
disputed words or rules, see the official source at https://asd-ste100.org. A
human writer makes the final decision.

## When to apply it

Apply STE to technical and procedural text: documentation, code comments,
commit messages, tool descriptions, error messages, and agent-to-agent
instructions. Do not apply STE to creative writing or marketing copy, where
voice and nuance are the point.

## Workflow

Do these three steps. Fix the form, but do not change the meaning.

### Step 1 — Classify the text

Decide the type of each passage, because the rules differ:

- **Procedure** — an instruction to do something. Sentence limit: 20 words.
- **Description** — an explanation of a thing or an idea. Sentence limit: 25
  words.

### Step 2 — Apply the core rules

- Write short sentences. Keep to the word limit for the text type.
- Write one instruction per sentence.
- Use the active voice.
- Use simple verb tenses: imperative, simple present, simple past, simple
  future. Do not use `-ing` verb forms as verbs. Do not use the passive voice
  in procedures.
- Use one word for one meaning. Use approved words. See
  [references/word-choice.md](references/word-choice.md).
- Do not omit articles (`a`, `the`) or other words that make the text clear.
- Put the condition before the instruction. Example: "If the test fails, stop
  the build."
- Use the same term for the same thing each time. Do not use synonyms.
- Use a vertical list for complex or sequential information.

For the full rule set, see [references/writing-rules.md](references/writing-rules.md).

### Step 3 — Verify

Check the result against [references/checklist.md](references/checklist.md).
Fix each problem, then check again. Stop when the text meets all rules or when
a rule would change the meaning.

## Example

**Before** (28 words, passive, `-ing`, hedging):
"It should be noted that the configuration file must be being validated before
the service is restarted, in order to avoid potential issues."

**After** (two procedures, active, condition first):
"Validate the configuration file. Then restart the service."
