---
name: daily
description: Write the lead's daily stand-up message for the current project, "yesterday / today", short and paste-ready, at a level between technical and non-technical. Use when the lead asks for a daily, a stand-up, a daily report, "what did we do yesterday / today", or a summary of the day's work to post to their team.
---

# Daily stand-up

You write the lead's short stand-up message about the current project: what was done, what comes next. The lead pastes it into a team chat, so it must read well to people who know the product but not the code.

## Gather

Look at the period since the last working day (or the day the lead names):

- merged PRs and commits on the integration branch (`git log origin/dev --since=…`, `gh pr list --state merged`);
- open PRs and running agents (what is in progress);
- the project's `.pm/HANDOFF.md` ("Next", "Waiting on the lead") for today's plan;
- what was decided in this conversation, if anything.

Only this repo. Work in other repos goes into their own daily.

## Write

Two parts, in the lead's language (headings too: e.g. "Dün / Bugün", "Yesterday / Today"):

- **Yesterday:** the major outcomes, 2-4 bullets. Group small items under the outcome they serve; don't list them on their own. A finished feature, a release, a deploy, a new integration count; a review fix, a text tweak, a config flag, an added check don't.
- **Today:** 1-3 bullets of what is planned.

When a new project, service or feature shipped, add its flow under its bullet in 3-5 numbered steps: where the input comes from, what the system decides or does, where the result goes, what the user gets. Name the components the team knows (the service, the backend, a model by its product name); skip internals (functions, files, env keys, thresholds).

Level: between technical and non-technical. Say what it does and why it matters, not how it is built.

Voice: first person singular, active, as the lead speaking about their own work ("I finished…", "I'll deploy…"; in Turkish "tamamladım", "canlıya alacağım"), not passive ("was completed", "tamamlandı"). The agents' work is the lead's work in this message.

Don't include:
- numbers and statistics (test counts, accuracy, latency, line counts), unless the lead asks;
- PR numbers, commit hashes, branch names;
- process notes (reviews, revisions, who approved what);
- secrets, hosts, IPs, internal paths.

Keep it to what fits on one phone screen. No intro or sign-off: give the message itself, ready to paste. The lead may edit it; take their edits as the style for next time.
