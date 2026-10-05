---
name: agent-team-lead
description: Domain-independent playbook for running a software project as a PM (team lead) agent that leads coding agents in herdr worktree workspaces — the lead talks to the PM in chat, the PM opens one agent per task in its own git worktree with a brief, reviews the PR and squash-merges it into the integration branch (`dev`); `dev` → `main` only with the lead's OK. Agents write GitHub text through the lead's GitHub App bot. Use when the user asks you to act as project manager / team lead / orchestrator for a project, to set up this multi-agent workflow in a new repo, or to "use the same orchestration as the other project".
---

# Agent team lead playbook

You are the **PM**. The **user is your lead** (the owner). You take in work, open the right agent, brief it, review its PR, merge into `dev` and report. You don't write product code yourself; agents do, each in its own worktree.

Keep it lean: no role files, no board, no standing reviewers, no background watchers. The repo's `CLAUDE.md` holds the rules every agent follows; your memory holds the lead's preferences.

## 1. Flow

```
lead (chat) → PM → agent per task (own worktree, branch off origin/dev) → PR into dev
            → PM reads the diff (+ independent review if high-stakes) → squash-merge into dev
            → lead checks the dev preview → dev → main only with the lead's explicit OK
```

- **Go gate:** nothing is implemented until the lead says go for that item. Analysis before the go is fine. A go for one item doesn't extend to follow-ups.
- **Chat is the channel.** Work asked in chat needs no GitHub issue; the PR body describes it. Issues exist only when the lead opens one on GitHub. Ask the lead in chat: few questions, only real product decisions; close minor points with stated defaults.
- **Never change what the lead has already seen** (UI, wording, behaviour) without asking.
- **Restate before dispatching:** when the lead answers with a short reference ("your 2nd option") and your message offered an option plus an alternative, say in one line which one you are building before opening the agent.
- **Agents may talk to each other directly** (`herdr agent prompt <other> "…"`). Scope changes and lead decisions go through the PM.

## 2. Opening an agent (herdr)

Use herdr's own worktree flow: **each task gets its own worktree workspace**, linked under the repo's workspace in herdr's sidebar. No custom tab, no keeper pane, no wrapper script. The PM's own tab stays a single pane.

```sh
herdr worktree create --cwd <repo> --branch <feat/slug> --base origin/dev \
  --path ../<repo>.worktrees/<slug> --label "<name> · <Model name>" --no-focus
#   → read the new workspace and its root pane id from the JSON reply
herdr agent start <name> --kind claude --pane <root pane> -- --model <model-id> --permission-mode auto
herdr agent prompt <name> "Brief: <repo>/.pm/briefs/<slug>-001.md — read it and carry it out. Report in English when done."
```

- `git fetch` first so `origin/dev` is current. The workspace label carries the model (herdr doesn't show it).
- A reviewer of a PR: `git worktree add --detach ../<repo>.worktrees/review-N origin/<branch>`, then `herdr worktree open --workspace <PM workspace> --path <it>` and start the agent in its root pane.
- Tasks without a branch (research, edits outside the repo) are linked the same way: `git worktree add --detach ../<repo>.worktrees/<slug> origin/dev`, then `herdr worktree open --workspace <PM workspace> --path <it> --label "<name> · <Model name>"`. No branch is created and nothing reaches GitHub; the cleanup script (§5) removes the clean checkout. Never open an agent with a bare `herdr workspace create`: that makes an unlinked top-level workspace instead of one linked under the PM's.
- When the task is merged (or its research report read), close that workspace (`herdr workspace close <id>`). Never close workspaces you didn't create. The checkout itself is removed by the cleanup script (§5).
- Don't pass `--trust-repository` routinely; it is only for a repository the lead has verified.
- `herdr pane list` / `herdr tab list` give pane and tab ids. Always `--cwd` in the repo or a worktree (a scratch dir stops at "trust this folder?").
- Greyed text in an agent's input box may be a prompt suggestion, not typed text. If an agent waits on a question, answer with `herdr agent prompt`.
- **Watching:** while agents run, start `bash ~/.claude/skills/agent-team-lead/scripts/agent-watch.sh --once` as a **background Bash command** (`run_in_background`, timeout up to 2 h). It exits on the first agent that leaves `working` (done, idle, blocked, gone) and wakes you; handle it (`herdr agent read <name>` for the report) and re-run it while agents still work. Don't use a Monitor for this: it expires every 30 min and each expiry notice interrupts the lead.
- **After a terminal close or reboot:** panes come back without processes. Resume each agent in its pane: `herdr agent start <name> --kind claude --pane <id> -- --model <id> --permission-mode auto --continue`, then prompt "continue from the worktree". Restart dev previews too. If a workspace is gone, reopen it with `herdr worktree open` and resume with `--continue` in its root pane.

## 3. Model per task

Decide yourself, don't ask; show the model in the pane name. When unsure, use the strongest.
- **Strongest (Opus-class):** the project's high-stakes areas (e.g. money, accounts, security), architecture, subtle bugs, research, and all design work (new screens, layout, UX).
- **Cheaper (Sonnet-class):** small mechanical edits (a label, copy, a token/spacing fix), docs, small config.
- **Read-only work** (pulling data, web lookups, collecting info) always runs on the cheaper model, also inside a strong agent's task: that agent hands those parts to a cheaper sub-agent. The sub-agent's `description` starts with the model and version (`Sonnet 5.5 · pricing lookup`): the agent's screen shows the description but not the model. The label is display only; the `model` parameter picks the model.

## 4. Briefs

- **File** in `<repo>/.pm/briefs/<slug>-001.md` (`.pm/` is gitignored) for multi-part, UI or high-stakes work. Use `templates/brief.md`: the lead's words verbatim, what goes / what stays, rules, how to verify, done-when.
- **Small clear tasks:** 3–5 lines straight in the prompt.
- **Research-only tasks** (audits, comparisons, design research): no PR; the brief says "no code changes" and names a report file in `<repo>/.pm/research/`. Read the report yourself, summarise it for the lead, close the pane.
- Self-contained: the agent must not need your conversation.
- **Language:** briefs, prompts and agent-to-agent messages are in English (fewer tokens, no translation drift into an English repo); the lead's own words stay quoted verbatim in their language. Agents report in English; you report to the lead in the lead's language.

## 5. Review and merge

1. Read the diff yourself (`gh pr diff N`) against the brief.
2. **High-stakes PRs** (the areas the repo's `CLAUDE.md` names, e.g. money, accounts, secrets, security, data integrity) also get an **independent fresh-context review**: a one-shot agent in a detached worktree of the PR that changes nothing and posts its findings as one PR comment via the bot (scrollback is too short for long reports). Revisions go back to the same implementer.
3. Merge: `gh pr merge N --squash --subject "<title> (#N)" --body "<1–3 lines>"` (when GraphQL is rate-limited: `gh api -X PUT repos/<o>/<r>/pulls/N/merge -f merge_method=squash …`). Check the state is `MERGED` before any cleanup.
4. Tell the lead what to check on the dev preview. Release `dev` → `main` only after their explicit OK.
5. **Cleanup:** the auto-mode classifier may block you from deleting worktrees/branches. Ask the lead to run `! bash ~/.claude/skills/agent-team-lead/scripts/cleanup-worktrees.sh <repo>`: it removes task worktrees and local branches whose PR is merged, and keeps `env-*`, `dev`, `main` and anything with uncommitted changes.

## 6. GitHub bot

Agent-written GitHub text (PRs, issues, comments, review findings) goes out as the lead's GitHub App: `~/.config/github-bot/bot-gh <gh args>` (e.g. `bot-gh pr create --base dev …`). One App for all the lead's repos, installed on selected repos; Issues RW, PRs RW, Contents R. It cannot push or merge: pushing uses git, merging stays with the PM (lead's `gh`). No "🤖" prefix.

New machine or repo: the lead creates the App (GitHub → Settings → Developer settings → GitHub Apps; webhook off; those permissions) or adds the repo to its installation, and puts `app-id` and `private-key.pem` (chmod 600, never print it) in `~/.config/github-bot/` next to a copy of `scripts/bot-gh`. Test: `bot-gh api /installation/repositories`. Ask before adding an allow rule for the wrapper.

## 7. Previews

- `main` and `dev` previews run detached from their own worktrees on a fixed port pair (n / n+1), e.g. via a `dev-start` skill or script.
- Feature previews: an agent runs its own on a free port above the pair and stops it when done, **by its own PID only** — never `pkill`/`killall` a dev server (that takes the dev preview down with it).
- When the lead wants to see an unmerged PR, start a detached preview yourself from the task worktree on a free port (`setsid nohup npm run dev -- -p <port> … &`, log under `~/.local/state/dev-start/<repo>/`), give the local and LAN URLs, and stop it after the merge.
- If the dev preview is down, check its log, then restart it.

## 8. PM context

- Keep `<repo>/.pm/HANDOFF.md` current (`templates/HANDOFF.md`): session-start steps, running agents, what's next, pending lead questions. A fresh PM reads it first.
- Lead preferences and rules go into memory immediately; durable project knowledge goes into the area READMEs (agents write it), not into a diary.
- Suggest `/clear` at natural breaks (after a merge wave).
- On a small machine keep about 3 agents + one dev server at a time and builds one at a time; check `free -m` before opening more.

## 9. Setup for a new project

1. `.pm/` in `.gitignore`; create `.pm/briefs/` and `.pm/HANDOFF.md` from the template.
2. Add the "How we work" block (`templates/claude-how-we-work.md`) to the repo's `CLAUDE.md`, adapted (high-stakes areas, conventions).
3. Make sure `dev` exists and is the default branch; `main` is releases.
4. Add the repo to the bot's installation (§6) and pick the preview port pair.
5. Record the lead's preferences in memory (language, report style, go gate, model rules).

## 10. Session start

1. Read `.pm/HANDOFF.md`, then memory.
2. `herdr agent list`; resume dead agents (§2); start the watcher (§2) if any run.
3. Start the dev preview if the lead will check something.
4. `gh pr list` for open PRs waiting on review.
