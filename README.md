# build-workflow-kit

A drop-in way to build apps with Claude Code like a small, disciplined
team. **El Código** plans and codes. **Nitpick** writes the tests first and
decides pass or fail. **You** approve every merge.

**New here? Read [START-HERE.md](START-HERE.md).**

## What's in the kit

| File | What it is |
|---|---|
| `CLAUDE.md` | The workflow and rules. Claude Code reads it automatically in your project. |
| `.claude/agents/nitpick.md` | The Nitpick tester, a Claude Code subagent. |
| `.claude/settings.json` | Blocks the usual ways Claude could merge, push to `main` or force-push. It's a guard rail, not a lock. For a real lock, see "Extra lock" in START-HERE. |
| `templates/.gitignore` | Keeps secrets (`.env`) and test clutter out of git. |
| `templates/smoke_test.bat` + `smoke_test.ps1` | Windows smoke test: starts your real app and checks it. |
| `templates/smoke_test.sh` | The same for Mac/Linux. |
| `templates/FIRST-TASK-PROMPT.md` | Copy-and-paste prompts for features, bugs and first runs. |

Works on its own. If an Open Brain is connected, Claude also uses it for
memory between sessions.
