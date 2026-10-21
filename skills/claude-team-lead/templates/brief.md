# <slug>-001 — <one-line title>

Lead (<YYYY-MM-DD>): "<the lead's words, verbatim>"

## What changes
- …

## What stays (don't touch)
- …

## Rules
- Branch `<feat/slug>` off `origin/dev`, worktree `../<repo>.worktrees/<slug>` (ready). PR → `dev` through the bot (`~/.config/github-bot/bot-gh pr create --base dev …`).
- Follow the repo's `CLAUDE.md`. No new dependencies or services without asking the TL.
- Tests: unit tests for the logic, typecheck + lint. Update the area README if behaviour changes.
- Sub-agents: pure data pulling / web lookups go to a Sonnet sub-agent; start its `description` with the model and version (`Sonnet 5.5 · …`); the label is display only, the `model` parameter picks the model.
- Preview on a free feature port (never the main/dev pair); stop it when done by its own PID — never `pkill`/`killall` a dev server.

## Verify
- <what to open / run, and what must be true>

## Done when
PR open, checks pass, short report as your last message: what changed, PR link, how you verified it, what the lead must do, open questions.
