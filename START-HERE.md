# Start here: build like a real team

You've built a basic brain. This kit is the next step: a way to build apps
with Claude Code that doesn't fall apart the first time a real person uses
them.

## What you get

| | |
|---|---|
| **El Código** | Claude in your main chat. Plans and writes the code. |
| **Nitpick** | A second Claude that only tests. It writes the tests *before* the code exists, then decides pass or fail. It isn't allowed to change your app. |
| **You** | The approver. Nothing goes live until you click **Merge** yourself. Claude is blocked from doing it. |

The flow is the same every time: **plan → tests first → build → test until
it passes → a pull request waits for you → you merge.**

### Why bother

AI code that "passes the tests" still breaks in real life. A real project
had 785 passing tests, and every real-world use still failed. The tests
never started the app the way a user does. This kit forces one more check,
the **smoke test**. It starts your actual app, uses it for real, and checks
the result. Nothing counts as done until that passes.

## Words you'll see

| Word | Meaning |
|---|---|
| **main** | The official version of your project. |
| **branch** | A safe copy where new work happens, so `main` isn't touched until you approve. |
| **commit** | A saved checkpoint of changes, with a note saying what changed. |
| **pull request (PR)** | A page on GitHub that shows a branch's changes and asks "merge these into main?" |
| **merge** | Accept the PR. The changes become part of `main`. |
| **unit test** | A tiny automatic check of one piece, like "does 105 minutes print as 1h45m?" |
| **smoke test** | One automatic run of the whole real app, start to finish. |
| **subagent** | A second Claude that the main one hands a job to. Nitpick is one. |

## What you need

1. **Claude Code**, either the desktop app's Code tab or the terminal
   version.
2. **A GitHub account** (free).
3. **A project folder.** It can be brand new and empty.

You do **not** need to know git. Claude runs all of it.

## Set it up (about 10 minutes)

Do these one at a time.

**Step 1. Get the kit files.** On the kit's GitHub page, click the green
**Code** button, then **Download ZIP**. Unzip it, rename the unzipped folder
to `kit`, and move that `kit` folder **inside** your project folder. Don't
copy the files out of it. Claude will do that carefully in Step 3, so
nothing of yours gets overwritten.

> If the kit link shows "404", the kit is private. Ask whoever shared it to
> add you, or to send you the ZIP.

**Step 2. Open your project in Claude Code and connect GitHub.** Paste:

```
Check that git and the GitHub command-line tool (gh) are installed and that
I'm signed in to GitHub. Install anything missing. If this folder isn't a
git repository yet, make it one. If it has no GitHub repository yet, create
a private one. Don't commit anything yet.
```

If Claude says you need to sign in, it will give you one command,
`gh auth login`. That's the one step you do yourself, because it's your
password. Follow the prompts in your browser, then tell Claude "done".

**Step 3. Set up the kit.** Paste:

```
Set up the build-workflow kit from the kit/ folder. Copy into this project:
CLAUDE.md, .claude/agents/nitpick.md, .claude/settings.json, and everything
in kit/templates/ (including .gitignore) into the top folder. If any of
those files already exist here, merge the kit's version into mine and keep
what was there; never overwrite. Then delete the kit/ folder. Fill in
"About this project" in CLAUDE.md by asking me, one question at a time.
Commit on a new branch, push it, and tell me what you did.
```

**Step 4. Close Claude Code and open it again.** That's how it notices the
Nitpick helper and the merge block.

**Extra lock (optional, recommended).** The merge block in
`.claude/settings.json` stops the usual commands, but it's a guard rail,
not a lock. For a real lock, ask Claude:

```
Turn on branch protection for main on GitHub so changes can only arrive
through an approved pull request. If my plan doesn't allow it, tell me.
```

On a private repository this needs GitHub Pro. Students get it free with
the GitHub Student Developer Pack. Public repositories have it for free.

That's the setup.

## Use it

Open `FIRST-TASK-PROMPT.md` and pick a prompt: a new feature, a bug, or
first time in an existing project. Fill in the blanks and paste it.

What you'll see, in order:

1. **A plan in plain English.** Read it. Say "go", or say what's wrong.
2. **Nitpick's tests, failing.** That's correct, because nothing is built
   yet.
3. **El Código building, then Nitpick re-testing.** This may loop a few
   times. That's the system working.
4. **A link to the pull request.** Ask for a plain-English summary and
   Nitpick's verdict.
5. **You click Merge** on GitHub, or tell Claude what to change.

## The rules you'll see Claude follow

- It never works directly on `main`. It always uses a branch.
- It can't merge. You do.
- "Unit tests pass" is not "done". The smoke test must pass too.
- On a bug fix, you see the failing result before the fix and the passing
  result after, pasted exactly.
- If it fails twice on the same idea, it must stop and test that idea
  before trying again.

If Claude skips one of these, say: **"Follow CLAUDE.md."**

## Got an Open Brain connected?

Then Claude will check your brain at the start ("what was I working on?")
and save decisions as it goes. Nothing to set up. It's already in
`CLAUDE.md`.

## When something goes wrong

| What you see | What to do |
|---|---|
| Claude didn't use Nitpick | Say: "Use the nitpick subagent for testing, as CLAUDE.md says." If it says there's no such agent, close and reopen Claude Code (Step 4). |
| Smoke test: "something is already running" | An old copy of your app is still open. Ask Claude: "Stop the old copy of the app and run the smoke test again." |
| Smoke test: "app did not answer" or "crashed" | The settings at the top of `smoke_test.ps1` (or `.sh`) may not match how your app starts. Ask Claude: "Fix the smoke test settings so it starts the app the way I do." |
| Claude says merging is blocked | That's the kit working. Open the PR link and click **Merge** yourself. |
