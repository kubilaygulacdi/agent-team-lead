## How we work
- The owner talks to the TL (a Claude session). The TL opens one agent per task in its own git worktree and gives it a brief.
- Branches: `dev` = integration and default branch; `main` = stable release. Branch off `dev` (`feat/…`, `fix/…`, `chore/…`), open the PR into `dev`. Never push to `dev` or `main` directly.
- The TL reviews the PR and merges it into `dev` (squash); PRs touching <high-stakes areas: money, accounts, secrets…> also get an independent fresh-context review. The owner checks `dev`; `dev` → `main` only with the owner's explicit OK.
- Nothing is implemented without the owner's go for that item. Never change UI or behaviour the owner has already seen without asking.
- Agents may message each other directly. Scope changes and owner decisions go through the TL.
- When done, end your turn with a short report: what changed, PR link, how you verified it, what the owner must do, open questions. Durable knowledge goes into the area README, not a diary.
- GitHub text written by an agent (PRs, issues, comments) goes out as the owner's bot: `~/.config/github-bot/bot-gh <gh args>`. The bot can't push or merge: pushing uses git as usual, merging stays with the TL.
