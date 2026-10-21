# Backend: herdr

The six operations of SKILL.md §2 with [herdr](https://herdr.dev). Each task gets herdr's own **worktree workspace**, linked under the repo's workspace in the sidebar. The TL's own tab stays a single pane.

| Operation | Command |
|---|---|
| Open (branch) | `git fetch -q origin` → `herdr worktree create --cwd <repo> --branch <feat/slug> --base origin/dev --path ../<repo>.worktrees/<slug> --label "<name> · <Model name>" --no-focus` → read the workspace and root pane id from the JSON reply → `herdr agent start <name> --kind claude --pane <root pane> -- --model <model-id> --permission-mode auto` |
| Open (review / research, no branch) | `git worktree add --detach ../<repo>.worktrees/<slug> origin/<branch or dev>` → `herdr worktree open --workspace <TL workspace> --path <it> --label "<name> · <Model name>"` → `herdr agent start …` as above. Never a bare `herdr workspace create`: it makes an unlinked top-level workspace |
| Name | the workspace `--label` carries the model (herdr doesn't show it) |
| Prompt | copy the brief into `<worktree>/.pm/`, then `herdr agent prompt <name> "Brief: .pm/<slug>-001.md (in this worktree) — read it and carry it out. Report in English when done."`; a revision: `"Revision: read .pm/<slug>-002.md …"` (agents message each other the same way) |
| Read | `herdr agent read <name>` (the screen's tail; the report is the last message) |
| Watch | `bash <skill-dir>/scripts/agent-watch.sh --once` as a background command (timeout up to 2 h): exits when a named agent leaves `working` (done, idle, blocked, gone); re-run while agents still work. For one agent right after a prompt, as one background command: first wait until it reports `working` (poll `herdr agent get <name>` for `"agent_status":"working"`, with a timeout), then `herdr agent wait <name> --until done --until blocked --timeout 7200000`. Skip the first step and `herdr agent wait` returns at once, because the agent is still `done` from its last task |
| Close | `herdr workspace close <id>` after the merge or the report; the checkout is removed by `scripts/cleanup-worktrees.sh` |
| List / resume | `herdr agent list`; after a reboot: `herdr worktree open` if the workspace is gone, then `herdr agent start <name> --kind claude --pane <id> -- --model <id> --permission-mode auto --continue` |

- `herdr pane list`, `herdr tab list` and `herdr workspace list` give ids. `idle` and `done` both mean ready for input; `blocked` means a permission or question prompt.
- Don't pass `--trust-repository` routinely; only for a repository the lead has verified.
