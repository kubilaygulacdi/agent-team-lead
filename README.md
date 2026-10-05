# agent-team-lead

A [Claude Code](https://claude.com/claude-code) skill, packaged as a plugin: a domain-independent playbook for running a software project as a PM (team lead) agent that leads coding agents, one per task in its own git worktree, in any harness.

The lead talks to the PM in chat. The PM opens one agent per task in its own git worktree with a brief, reviews the PR and squash-merges it into `dev`; `dev` → `main` only with the lead's OK.

## Install

As a Claude Code plugin (any machine):

```
/plugin marketplace add kubilaygulacdi/agent-team-lead
/plugin install agent-team-lead@agent-team-lead
```

Update later with `/plugin marketplace update agent-team-lead`.

For editing it locally instead, clone the repo and link the skill folder:

```sh
gh repo clone kubilaygulacdi/agent-team-lead ~/Desktop/git-personal/agent-team-lead
ln -s ~/Desktop/git-personal/agent-team-lead/skills/agent-team-lead ~/.claude/skills/agent-team-lead
```

Don't do both on one machine, or the skill loads twice.

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

Claude Code (any harness), `git`, `gh`, `python3`, `openssl` (for `bot-gh`). Optional: a terminal multiplexer such as herdr or tmux, if the lead wants to watch agents work.
