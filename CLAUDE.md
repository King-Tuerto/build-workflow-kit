# How we build in this project

<!--
  KIT FILE: copy this file into the top folder of your project.
  Fill in the "About this project" section below. Leave the rest as it is
  until you have run a few builds and know what you want to change.
-->

## About this project

- **What it is:** _one sentence. Example: "A web page where my club members sign up for events."_
- **Who uses it:** _example: "Me and about 20 club members, on their phones."_
- **How to start it on my computer:** _examples: `npm start`, then open http://localhost:3000. For a plain HTML site: `npx --yes http-server -p 3000 -c-1`. If you don't know, write "unknown" and El Código will find out and fill this in. If there's no app yet, write "nothing yet"._
- **Where it lives online (if anywhere):** _example: GitHub Pages, Vercel, "not online yet"._
- **The approver:** _your name. You are the only one who merges._

## Who does what

There are three roles. Claude plays the first two. You are the third.

| Role | Who | Owns |
|---|---|---|
| **El Código** | The main Claude Code session | The plan, the design and the code. |
| **Nitpick** | The `nitpick` subagent (`.claude/agents/nitpick.md`) | The tests and the pass/fail verdict. Nitpick does not write app code. |
| **Approver** | The human who owns this project | The merge. Nothing merges without the approver's explicit "yes". |

Nitpick runs as a separate subagent on purpose. A tester who wrote the code
grades their own homework. Keep the roles separate even when the task
looks small.

## The workflow (every code change)

**Step 0: Branch.** Create a branch with a clear name, such as
`feature/event-signup` or `fix/date-shows-wrong-day`. Never commit to
`main`. All work happens on the branch.

**Step 1: El Código plans.**
- Read the request, the existing code and anything relevant.
- Split the work into small pieces. Each piece leaves the app working and
  has its own "done when..." line.
- Show the plan to the approver in plain English before writing tests or
  code.
- If the request is unclear, ask the approver **one** question, in plain
  language.

**Step 2: Nitpick designs the tests.** El Código sends the plan to Nitpick.
Nitpick writes:

- **Unit tests** for each piece: small, fast checks of one behaviour.
- **A smoke test** (`smoke_test.bat` on Windows, `smoke_test.sh` on
  Mac/Linux). It starts the real app the way a user would, talks to it for
  real, and checks the result. A smoke test must never use mocks or fake
  servers.
- **A browser walk-through** if the change touches anything a person clicks
  through. It runs with the browser console open and covers the happy path,
  one error path and realistic data.

Tests come **before** the code. They must fail at this point, because
nothing is built yet. Nitpick shows El Código the failing output.

**Step 3: El Código builds** each piece until its tests pass. El Código
runs the tests while working, but does not declare a piece done; Nitpick
does.

**Step 4: Nitpick tests.**
- Nitpick runs the full suite (unit tests, smoke test, and the walk-through
  where it applies).
- Any failure goes back to El Código with the exact output.
- Repeat until everything passes, subject to the **retry limit** below.

**Step 5: Hold the PR.**
- El Código opens a pull request. It says what changed, how it was tested
  and Nitpick's verdict, with output pasted word for word.
- El Código gives the approver the PR link and a plain-English summary, then
  stops.
- **The approver merges it themselves**, with the green "Merge" button on
  the PR page on GitHub. Claude is blocked from merging
  (`.claude/settings.json`) so that this step can't be skipped.

**Step 6: After merge, check the live thing.** If the app is online, confirm
the new version is actually live by opening it or checking its version. Do
not just assume. A push is not a deploy.

## Rules that always apply

1. **Never work on `main`.** Branch first, every time.
2. **The PR waits for the approver.** No self-merging, no auto-merge, and no
   pushing to `main`, by any route (command line, GitHub tools, or a
   workaround). `.claude/settings.json` blocks the common commands. Never
   remove those blocks or look for a way around them.
3. **Passing unit tests are not enough.** Nothing is "done" until the smoke
   test passes against the real running app. **If there is no app yet,** the
   first piece of work creates the smallest page that runs, plus its smoke
   test, before anything else.
4. **Retry limit.** If two fixes built on the same assumption fail the same
   Nitpick test, El Código may not try a third. First write the assumption
   down in one sentence and test it directly. Then report what that showed
   and continue.
5. **Word-for-word evidence on bug fixes.**
   - Reproduce the bug first.
   - Commit a test or script that fails, then commit the fix separately on
     top.
   - The hand-off pastes the failing output and the passing output exactly
     as printed, never a summary.
   - If the bug can't be reproduced, stop and tell the approver.
6. **Tests use the real shape of the data.** Before a test inserts or reads
   database rows, check the real column names in the real database. Never
   guess them from memory.
7. **Claude runs git.** The approver should never need to type a git
   command. Commit and push at the end of any session that changed files.
8. **Talk to the approver in plain English.** Give steps one at a time.
   Explain any word a non-programmer wouldn't know. Never ask the approver to
   do something Claude can do itself.
9. **No secrets in files.** API keys and passwords go in a `.env` file
   (listed in `.gitignore`) or the hosting service's secret settings, never
   in code or commits. Before every commit, check that no key or password is
   in the changes.

## If an Open Brain is connected (optional)

If this Claude Code session has Open Brain tools (`search_thoughts`,
`add_thought`):

- At the start of a session, search the brain for this project's name and
  say what was last worked on.
- Save important decisions as they happen.
- At the end, save a short update: what was built, what works, what's
  broken and what's next.

If no brain is connected, skip this section.
