#!/usr/bin/env bash
# Print "<agent>: <state>" whenever a herdr agent leaves `working` (idle, blocked, done, gone).
# Silent while nothing changes.
# Usage: bash agent-watch.sh [--once] [interval_seconds]
#   --once: exit after the first event. Run it as a background Bash command (up to 2 h) and re-run
#           it after handling the event: one wake-up per event, no expiry notices.
#   without: stream every event (for a Monitor, which expires after 30 min).
# Only named agents count (`herdr agent start <name>`): the TL and other sessions have no name.
ONCE=0; [ "${1:-}" = "--once" ] && { ONCE=1; shift; }
INTERVAL="${1:-15}"
hit=0
declare -A prev
while true; do
  snap=$(herdr agent list 2>/dev/null | python3 -c '
import sys, json
for a in json.load(sys.stdin)["result"]["agents"]:
    if a.get("name"): print(a["name"], a.get("agent_status"))
' 2>/dev/null) || { sleep "$INTERVAL"; continue; }
  declare -A now=()
  while read -r name state; do
    [ -z "$name" ] && continue
    now[$name]=$state
    if [ "${prev[$name]:-}" != "$state" ] && [ "$state" != "working" ] && [ -n "${prev[$name]+x}" ]; then echo "$name: $state"; hit=1; fi
  done <<< "$snap"
  for name in "${!prev[@]}"; do [ -z "${now[$name]+x}" ] && { echo "$name: gone"; hit=1; }; done
  [ "$ONCE" = 1 ] && [ "$hit" = 1 ] && exit 0
  prev=(); for k in "${!now[@]}"; do prev[$k]=${now[$k]}; done
  unset now
  sleep "$INTERVAL"
done
