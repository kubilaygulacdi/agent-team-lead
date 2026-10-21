# agent-team-lead

A [Claude Code](https://claude.com/claude-code) skill that lets one Claude session act as the **team lead (TL)** of your software project.

You tell the TL what you want. The TL hands each task to its own coding agent, checks the result and merges it. You only make the decisions.

## How it works

1. You describe a task in chat.
2. The TL writes a short brief and starts a coding agent for it, in its own git worktree and branch.
3. The agent does the work and opens a pull request.
4. The TL reviews the pull request. Risky changes (security, money, data, public APIs) also get a second, independent review.
5. The TL merges it into `dev`. You check `dev`.
6. When you say so, `dev` is released to `main`.

Nothing is built without your go, and nothing reaches `main` without your OK.

## Why use it

- **Parallel work without chaos:** every task runs in its own worktree, so several agents can work at once.
- **The right model for each task:** the strongest model for risky or tricky work, a cheaper one for small edits and lookups. Each agent's name shows its model, so you always see which one is working.
- **Review on every change:** each pull request is checked before it is merged; the risky ones are checked twice.
- **A clean history:** one commit per pull request, tagged releases.
- **Works with any setup:** Claude Code's built-in sub-agents, or terminal tools such as herdr and tmux if you want to watch the agents work.
- **Picks up where it left off:** a handoff file lets a new session continue the project.

## Install

```
/plugin marketplace add kubilaygulacdi/agent-team-lead
/plugin install agent-team-lead@agent-team-lead
```

Update later with `/plugin marketplace update agent-team-lead`.

## Use

Open Claude Code in your project and say something like *"be the team lead for this project"*. The first time, it asks a few questions and sets the repo up. After that you just talk to it.

## What's inside

- `skills/agent-team-lead/SKILL.md`: the playbook the TL follows.
- `references/`: how to run agents with herdr or tmux.
- `scripts/`: watch agents, clean up merged worktrees, post to GitHub as a bot.
- `templates/`: brief, handoff and `CLAUDE.md` templates.

## Requirements

Claude Code, `git` and the GitHub CLI (`gh`). Optional: herdr or tmux; `python3` and `openssl` for the GitHub bot script.

## License

MIT
