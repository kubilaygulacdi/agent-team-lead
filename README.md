# agent-team-lead

A [Claude Code](https://claude.com/claude-code) skill, packaged as a plugin, that turns a Claude session into the **PM (team lead) of a software project**. You stay the lead: you talk to the PM in chat and make the product decisions. The PM opens one coding agent per task, each in its own git worktree, briefs it, reviews its pull request and merges it. Nothing reaches production without your OK.

It is domain-independent: the same playbook runs a web app, an API, a data pipeline or a mobile app.

```
you (chat) → PM → one agent per task (own worktree, branch off dev) → PR into dev
           → PM reviews the diff (+ an independent review when it is high-stakes)
           → squash-merge into dev → you check dev → dev → main only with your OK
```

## What it gives you

- **A go gate.** Nothing is implemented until you say go for that item. The PM may research first; a go for one item doesn't cover the next. Wording, UI or behaviour you have already seen never changes without asking.
- **One agent per task, isolated.** Each task gets its own worktree and short-lived branch, so several agents can work in parallel without stepping on each other. Briefs name what another agent owns when two could touch the same area.
- **Any harness.** Six operations (open, name, prompt, read, watch, close) on a backend of your choice: Claude Code's built-in sub-agents (nothing to install), or a terminal multiplexer such as [herdr](https://herdr.dev) or tmux when you want to watch and type into each agent.
- **The right model per task.** The strongest model for high-stakes work, architecture, subtle bugs and design; a cheaper one for small mechanical edits; read-only lookups always go to a cheaper sub-agent. The model shows in each agent's name.
- **Self-contained briefs.** Written to a file inside the agent's worktree with your words quoted verbatim, what changes and what stays, the rules, how to verify and when it is done. Revisions follow as numbered files, so the history stays readable and each prompt stays one line.
- **Review that scales with risk.** The PM reads every diff against its brief. PRs that touch the areas your `CLAUDE.md` marks as high-stakes (money, auth, secrets, data integrity, a public contract) also get a fresh-context review before merging. Small changes go through the same PR flow without the ceremony.
- **Clean history and releases.** Squash-merge into `dev`, one commit per PR. Releases go `dev` → `main` as a merge commit, with a tag and a GitHub release that carries the deploy steps.
- **A GitHub bot for agent-written text.** PRs, issues and review comments go out as your GitHub App (`bot-gh`), not as you. It cannot push or merge.
- **Previews.** `main` and `dev` previews on a fixed port pair; agents run their own previews and stop them by PID only.
- **Continuity.** A per-repo `HANDOFF.md` lets a fresh PM session pick up exactly where the last one stopped; your preferences live in the PM's memory; durable project knowledge goes into the area READMEs.
- **New-project setup.** `.pm/` ignored by git, the "How we work" block in `CLAUDE.md`, `dev` as the integration branch, auto-deleted merged branches, the bot installed.

## Install

As a Claude Code plugin (any machine):

```
/plugin marketplace add kubilaygulacdi/agent-team-lead
/plugin install agent-team-lead@agent-team-lead
```

Update later with `/plugin marketplace update agent-team-lead`.

For editing it locally instead, clone the repo and link the skill folder:

```sh
gh repo clone kubilaygulacdi/agent-team-lead <path>/agent-team-lead
ln -s <path>/agent-team-lead/skills/agent-team-lead ~/.claude/skills/agent-team-lead
```

Don't do both on one machine, or the skill loads twice.

## Use

In a Claude Code session inside your repo, ask it to act as your PM, for example *"be the PM for this project"*, *"set up the agent team workflow in this repo"* or *"use the same orchestration as the other project"*. The PM reads `SKILL.md`, asks which backend you want once, sets the repo up if needed, and from then on you just talk to it.

## Contents

| Path | What |
|---|---|
| `skills/agent-team-lead/SKILL.md` | The playbook: flow, opening and running agents (any harness), model per task, briefs, review and merge, the GitHub bot, previews, PM context, setup, session start |
| `…/references/` | Backends: herdr, tmux (the built-in sub-agent backend needs none) |
| `…/scripts/agent-watch.sh` | herdr backend: prints a named agent when it leaves `working`; `--once` exits on the first event (run as a background command) |
| `…/scripts/cleanup-worktrees.sh` | Removes task worktrees and local branches whose PR is merged |
| `…/scripts/bot-gh` | Runs `gh` as a GitHub App (the agents' bot); needs `app-id` and `private-key.pem` next to it, never in this repo |
| `…/templates/` | Brief, PM handoff and the `CLAUDE.md` "How we work" block |

## Requirements

Claude Code (any harness), `git`, `gh`, `python3`, `openssl` (for `bot-gh`). Optional: a terminal multiplexer such as herdr or tmux, if you want to watch agents work.

## License

MIT
