# agent-team-lead

A [Claude Code](https://claude.com/claude-code) skill: a domain-independent playbook for running a software project as a PM (team lead) agent that leads coding agents in [herdr](https://herdr.dev) worktree workspaces.

The lead talks to the PM in chat. The PM opens one agent per task in its own git worktree with a brief, reviews the PR and squash-merges it into `dev`; `dev` → `main` only with the lead's OK.

## Install

```sh
git clone git@github.com:kubilaygulacdi/agent-team-lead.git ~/Desktop/git-personal/agent-team-lead
ln -s ~/Desktop/git-personal/agent-team-lead ~/.claude/skills/agent-team-lead
```

The skill paths in `SKILL.md` assume it lives at `~/.claude/skills/agent-team-lead/`.

## Contents

| Path | What |
|---|---|
| `SKILL.md` | The playbook: flow, opening agents in herdr, model per task, briefs, review and merge, the GitHub bot, previews, PM context, setup, session start |
| `scripts/agent-watch.sh` | Prints a named herdr agent when it leaves `working`; `--once` exits on the first event (run as a background command) |
| `scripts/cleanup-worktrees.sh` | Removes task worktrees and local branches whose PR is merged |
| `scripts/bot-gh` | Runs `gh` as a GitHub App (the agents' bot); needs `app-id` and `private-key.pem` next to it, never in this repo |
| `templates/` | Brief, PM handoff and the `CLAUDE.md` "How we work" block |

## Requirements

herdr, Claude Code, `gh`, `git`, `python3`, `openssl` (for `bot-gh`).
