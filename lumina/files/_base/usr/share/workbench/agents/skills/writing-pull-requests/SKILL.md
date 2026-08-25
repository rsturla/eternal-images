---
name: writing-pull-requests
description: Write a clear, readable pull request title and body that a reviewer understands fast. Use when the user opens a pull request, asks for a PR description, drafts a merge request, or wants to improve a PR body. Covers the title, the why/what/how-to-test/risks structure, reviewer guidance, and size.
---

# Writing pull requests

A good pull request body gives the reviewer a mental model of the change. It
answers why, what, and how to test. It reduces review time and back-and-forth.

Write the body in ASD-STE100 Simplified Technical English. For the style rules,
use the `asd-ste100` skill.

## Workflow

### Step 1 — Write the title

- Use the Conventional Commits form: `type(scope): summary`.
- Use the imperative mood. Example: "fix token refresh on 401", not "fixed".
- Name the component and the effect. Keep it to 50 characters or fewer.

### Step 2 — Write the body

Use these sections. Keep each one short. See
[references/template.md](references/template.md) for a copy-ready template and
[references/examples.md](references/examples.md) for good and bad examples.

- **Why** — the problem or the goal. State the motivation, not only a ticket
  link.
- **What** — the main changes, as a bulleted list.
- **How to test** — the exact steps, commands, or checks the reviewer runs.
- **Risks and follow-ups** — breaking changes, migrations, and later work.
- **Links** — related issues or documents. Example: "Closes #123".

### Step 3 — Guide the reviewer

- Point to the files or the parts that need the most attention.
- Separate mechanical changes from logic changes. Say which parts are a
  rename, a format, or a generated change, so the reviewer can skim them.
- Add a screenshot or a short video for a user-interface change.

### Step 4 — Check the result

- Keep the body scannable. Use headings and bullets, not long paragraphs.
- Aim for 200 to 400 words. Add more only for a large change.
- Do not paste large diffs or execution traces. If the change is too big to
  explain, split the pull request.
- Read the body as if you were the reviewer. Fix each unclear part.

## Keep the pull request small

- Keep each pull request on one topic.
- Aim for a small diff. Review quality drops after about 400 changed lines.
- Put the tests in the same pull request as the code they cover.
