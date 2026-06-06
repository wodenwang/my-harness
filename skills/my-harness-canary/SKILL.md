---
name: my-harness-canary
description: Use when running optional post-deploy canary monitoring against a live production or staging URL, registering findings as GitHub issues, or setting up a recurring Codex canary check after the 15-step harness loop
---

# My Harness Canary

## Purpose

Run an optional post-deploy canary check after the normal 15-step harness loop has landed and deployed.

This skill wraps gstack `/canary` for live environment monitoring. It observes the deployed app, collects evidence, and registers problems as GitHub issues in the current target project. It does not fix the problems it finds.

Use this skill directly when the user wants post-deploy canary testing. It is not step 16 of the required SOP; it is an optional standalone follow-up after step 15.

Reference gstack skill: `/Users/wenzhewang/.codex/vendor/gstack/.agents/skills/gstack-canary/SKILL.md`.

## When To Use

Use this skill when:

- The project has a live production, staging, or preview URL to monitor.
- The user asks for canary, post-deploy monitoring, production smoke monitoring, or scheduled live checks.
- Step 15 `gstack /land-and-deploy` has already run, or the user explicitly provides a live URL and asks for a one-off canary check.
- The user wants detected issues recorded for triage instead of fixed immediately.

Do not use this skill for local QA, pre-landing review, design review, or code investigation. Use the normal harness steps for those.

## Inputs

Required:

- Live URL to monitor, or project evidence that clearly identifies it.
- Current project GitHub repository, resolved from `git remote get-url origin` or `gh repo view`.

Optional:

- Pages to monitor, such as `/`, `/dashboard`, `/settings`.
- Duration, such as `--quick`, `--duration 10m`, or `--duration 30m`.
- Baseline mode, such as `--baseline`.
- Schedule request, such as daily, weekly, every weekday, or after each deploy.

## Core Rules

- Treat gstack `/canary` as the observation engine.
- Follow the gstack canary workflow, but keep it Codex-safe: do not enter Plan mode, do not call `AskUserQuestion`, `request_user_input`, or any interactive choice tool.
- Convert gstack decision points into Markdown `D1` / `D2` / `D3` decision gates only when the user must choose scope, duration, pages, baseline update, or schedule.
- Do not edit application code, configuration, deployment files, tests, or docs to fix findings.
- Writing `.gstack/canary-reports/` evidence is allowed.
- Creating GitHub issues for confirmed findings is required when GitHub is available and authenticated.
- If GitHub is unavailable, output ready-to-create issue titles and bodies instead of silently dropping findings.
- Confirm the GitHub repository before issue creation when the repo cannot be resolved unambiguously.
- Never use the `my-harness` repository as the target just because this skill lives here; issue targets must come from the project being monitored.

## One-Off Canary Flow

1. Read project governance and deployment docs first: `AGENTS.md`, `CLAUDE.md`, `DEPLOY.md`, README, release notes, and recent deployment notes.
2. Resolve the live URL from the user's prompt or project docs.
3. Resolve the target GitHub repo:
   - Prefer `gh repo view --json nameWithOwner -q .nameWithOwner`.
   - Fall back to parsing `git remote get-url origin`.
   - If neither gives a GitHub repo, keep the canary report local and print issue drafts.
4. Run gstack `/canary` semantics against the URL:
   - Use `--quick` for a single-pass check unless the user asked for a duration.
   - Use the requested pages when provided.
   - If pages are missing, monitor homepage plus clearly discoverable primary navigation pages.
   - Keep gstack interaction gates as Markdown decisions, not tool prompts.
5. Save or preserve the gstack canary report under `.gstack/canary-reports/`.
6. Classify persistent findings only:
   - `critical`: page fails to load, auth wall where public access is expected, production-blocking crash.
   - `high`: new console error, broken primary flow, severe rendering failure.
   - `medium`: 2x baseline performance regression, repeated network failure, broken secondary page.
   - `low`: broken non-critical link, cosmetic but production-visible anomaly.
7. For every confirmed finding, create one GitHub issue in the target project.
8. Report the canary verdict, issue links, evidence paths, and anything that could not be registered.

## GitHub Issue Rules

Issue titles must be short and actionable:

```text
[canary][critical] Homepage fails to load after deploy
[canary][high] New console error on /dashboard
[canary][medium] /settings load time regressed from 450ms to 1300ms
```

Issue body shape:

```markdown
## Canary Finding

- URL: <live URL>
- Page: <page path>
- Severity: <critical|high|medium|low>
- Detected at: <ISO timestamp>
- Canary mode: <quick|duration|baseline comparison>
- Baseline: <baseline summary or "no baseline">
- Current: <current observed result>

## Evidence

- Screenshot: <path or attachment note>
- Report: <path to .gstack/canary-reports/...>
- Console/network/perf excerpt: <short summary>

## Expected

<What production users should see.>

## Actual

<What the canary observed.>

## Scope

Created by `my-harness-canary`. This issue is for triage only; the canary step does not modify code or deployment files.
```

Use `gh issue create --repo <owner/repo> --title <title> --body-file <file>` when possible. Do not create duplicate issues for the same page, severity, and finding if an open issue already exists.

## Recurring Canary Flow

If the user asks for a daily, weekly, periodic, scheduled, recurring, or Codex-timer canary:

1. Do not start a recurring task implicitly.
2. Confirm or infer the URL, pages, cadence, timezone, and target GitHub repo.
3. Search for the Codex automation tool first, specifically `automation_update`.
4. Create an automation that wakes Codex and runs this skill with the resolved parameters.
5. The scheduled prompt must include:
   - the live URL
   - pages and duration
   - target GitHub repo
   - "do not fix findings; register confirmed findings as GitHub issues"
   - "output report paths and issue links"

If the automation tool is unavailable, output the exact recurring prompt and cadence for the user to set up manually.

## Recommended Output

```markdown
CANARY RESULT — <url>

Status: HEALTHY / DEGRADED / BROKEN
Mode: quick / duration / baseline
Pages checked: <N>
Report: <path>

Findings:
| Severity | Page | Finding | Evidence | GitHub issue |
|---|---|---|---|---|
| high | /dashboard | New console error after deploy | .gstack/...png | https://github.com/.../issues/123 |

Not changed:
- No application code, deployment config, tests, or docs were modified.

Recurring automation:
- Created / Not requested / Blocked because ...
```

## Completion Check

Before reporting done:

- A canary report exists or the reason it could not be created is stated.
- Every confirmed issue is either linked to a GitHub issue or represented as a ready-to-create issue draft.
- The target repo used for issue creation is shown.
- The final response states that no code or deployment files were modified.
- If a recurring schedule was requested, the automation status is shown.

## Common Mistakes

- Treating this as a required 16th SOP step instead of an optional direct-call skill.
- Fixing canary findings during the canary run.
- Creating issues in `wodenwang/my-harness` instead of the monitored project.
- Alerting on one transient failed check instead of persistent findings.
- Running a long monitor when the user asked for a quick check.
- Starting recurring automation without an explicit user request.
- Reporting "healthy" without screenshots, console/perf evidence, or a stated limitation.
