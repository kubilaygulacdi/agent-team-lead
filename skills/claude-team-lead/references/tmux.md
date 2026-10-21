# Backend: tmux

The six operations of SKILL.md §2 with plain tmux, one window per agent in the lead's session.

| Operation | Command |
|---|---|
| Open | `git fetch -q origin && git -C <repo> worktree add -b <feat/slug> ../<repo>.worktrees/<slug> origin/dev` (or `--detach` for reviews/research) → `tmux new-window -d -n "<name> · <Model name>" -c ../<repo>.worktrees/<slug> "claude --model <model-id> --permission-mode auto"` |
| Name | the window name carries the model |
| Prompt | `tmux send-keys -t "<window>" -l "<text>"` then `tmux send-keys -t "<window>" Enter` (wait a few seconds after Open so Claude is ready) |
| Read | `tmux capture-pane -p -t "<window>" -S -200` |
| Watch | no agent state in tmux: run a background loop that captures the pane every ~20 s and exits when the screen stops changing for ~1 min or shows Claude's input prompt with no spinner; or have the brief end with `touch <worktree>/.agent-done` and wait for that file |
| Close | `tmux kill-window -t "<window>"`; the checkout is removed by `scripts/cleanup-worktrees.sh` |
| Resume | in the worktree: `claude --continue` |
