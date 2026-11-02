# Prompts to paste into Claude Code

Copy one of these, fill in the blanks, and paste it as your message.

## A new feature

```
Follow CLAUDE.md. You are El Código; use the nitpick subagent for all testing.

I want: [describe what you want in plain words, the way you'd tell a friend]
It's done when: [what you will be able to see or do when it works]

Start with Step 0 and show me the plan before writing any tests or code.
```

## A bug

```
Follow CLAUDE.md. You are El Código; use the nitpick subagent for all testing.
This is a bug fix, so the word-for-word evidence rule applies.

What happens: [what you saw, e.g. "the date shows one day early"]
What should happen: [what you expected]
How I got there: [the steps you took, as best you remember]
```

## First time in a project that already exists

```
Follow CLAUDE.md. Before changing anything, read the project and fill in
the "About this project" section of CLAUDE.md as best you can. Then set up a
working smoke test with the nitpick subagent, using the smoke_test files in
the top folder. Show me it passing. Change no app code.
```

## When Claude says the PR is ready

```
Show me in plain English what changed, and paste Nitpick's final verdict.
```

When you're happy with it, open the PR link and click the green **Merge**
button on GitHub. If you're not happy, tell Claude what's wrong.
