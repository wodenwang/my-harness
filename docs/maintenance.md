# Maintenance Guide

## Add A Skill

1. Create `skills/my-harness-<verb>-<object>/SKILL.md`.
2. Add frontmatter:

   ```markdown
   ---
   name: my-harness-<verb>-<object>
   description: Use when ...
   ---
   ```

3. Include:
   - purpose
   - when to use
   - evidence or inputs to inspect
   - exact output shape
   - write/edit safety rules
   - completion checks
   - common mistakes
4. Update `skills/my-harness/SKILL.md`.
5. Update `README.md`.
6. Run `./scripts/verify.sh`.
7. Run `./scripts/install-local.sh` before local dogfooding.

## Update SOP Steps

When changing the canonical harness flow, update all of these files in the same change:

- `README.md`
- `AGENTS.md`
- `docs/project-history.md`
- `skills/my-harness/SKILL.md`
- `skills/my-harness-next-action/SKILL.md`
- `skills/my-harness-autopilot-slice/SKILL.md`

Then run:

```bash
./scripts/verify.sh
```

Step numbers are the evidence ledger. If a change introduces user-facing phase grouping or work-package language, keep the 15 canonical step rows intact and update the phase view in the same files. Do not remove or renumber steps just because adjacent steps can be executed together.

For UI-heavy projects, preserve the Frontend Fidelity First interpretation of Step 6-11: Step 6A-11A is the frontend/mock high-fidelity loop, and Step 6B-11B is the backend/API/real-data integration loop. These are evidence sub-loops inside existing steps, not new canonical step numbers. Future SOP changes must keep Step 3 as an approved visual target with implementation spec extraction, Step 9A screenshots before Step 10A, and Step 10A as a hard Product Design fidelity gate with target, screenshots, differences, fixes, before/after evidence, and accepted deviations.

## Product Design Frontend Guidance

Product Design integration is maintained directly inside the core harness skills. There is no separate bridge skill.

Rules:

- Do not add Product Design as a required dependency for `my-harness`.
- If Product Design is unavailable, the framework must fall back to shadcn/ui design governance, existing UI references, screenshots, or optional Pencil for complex alignment.
- If a UI / frontend / chart / app project has no `DESIGN.md`, the flow must first use or recommend `my-harness-writing-design` before design review, frontend planning, implementation, or visual QA.
- If a user explicitly runs `my-harness-writing-design` in an existing project that already has `DESIGN.md`, the script must refresh the my-harness-owned latest governance section while preserving project-specific content, brand decisions, accepted deviations, and history outside that section.
- When Product Design is available, it replaces gstack `/plan-design-review` and `/design-review` for design-related gates; keep gstack only as fallback.
- Product Design `ideate` must provide at least three prototype/visual options for planning design and frontend work. Target/autopilot mode may choose the system-recommended option only when allowed and with recorded rationale.
- Product Design output for UI-heavy projects must converge into an approved visual target, not only design directions. Record target mockup/reference, choice rationale, and implementation spec extraction under `design/`.
- Admin Console Product Design outputs must prove shadcn/ui grounding with component/block mapping, Tailwind token/CSS variable mapping, 8px spacing, state coverage, and explicit exclusion of unapproved non-shadcn UI frameworks.
- Step 6A frontend plans must reference the approved visual target and define mock data/API strategy plus screenshot/design-QA evidence. Step 7A may prioritize fidelity before code cleanup, but completion must return to shadcn/ui or the selected component system. Step 9A must run before Step 10A. Backend integration waits for the frontend fidelity gate, then reruns Step 9B/10B/11B.
- Keep the 15-step SOP unchanged; Product Design is used directly inside design, implementation, or visual QA stages.
- Keep Pencil optional unless a target project explicitly records a `.pen` requirement or the UI module needs human alignment.
- Step 3 is `Design artifact / visual target`, not mandatory Pencil work.
- Keep `image-to-code` / `url-to-code` behind `IMPLEMENTATION_PLAN.md`, and require it for frontend prototype slicing when a selected Product Design visual target exists.
- Keep Product Design visual QA / `design-qa.md` as supporting evidence for step 10; it must compare implementation to the prototype and `DESIGN.md`, drive fixes until highly faithful or accepted, and must not replace verification, QA, review, ship, or deploy.
- If the target system lacks an app/product title, logo, or favicon during design planning or prototype design, use Creative Production `logo-explorer` and record selected directions and asset paths under `design/`.
- Step 7 prompts must require Codex and any subagents to continuously follow `AGENTS.md`, `CLAUDE.md`, README, `DESIGN.md`, `DEPLOY.md`, `IMPLEMENTATION_PLAN.md`, and relevant docs/runbooks. Subagent briefs must include governance constraints, allowed file boundaries, no-drift requirements, and deviation reporting.
- Every design-related stage must strictly follow `DESIGN.md`, including typography, spacing, technology stack, components, chart libraries, colors, responsive rules, states, and accessibility.
- When shadcn/ui, Ant Design Pro, ECharts, or another selected third-party framework conflicts with a prototype, framework components and `DESIGN.md` take precedence; the prototype is only a reference.
- For Admin Console work, Product Design `image-to-code` / `url-to-code` output is only a scaffold. Step 7 must refit it to shadcn/ui primitives, project components, Tailwind tokens, and the selected theme before completion.

When changing Product Design guidance, update:

- `skills/my-harness/SKILL.md`
- `skills/my-harness-next-action/SKILL.md`
- `skills/my-harness-writing-design/SKILL.md`
- `skills/my-harness-autopilot-slice/SKILL.md`
- `README.md`
- `docs/project-history.md`
- `CHANGELOG.md`

When changing Creative Production brand-asset guidance or step 7 governance/no-drift guidance, update the same core SOP files plus `skills/my-harness-writing-design/scripts/harness_write_design.py` and the `DESIGN.md` templates.

Then run:

```bash
./scripts/verify.sh
```

## Writing Design Scenario Guidance

`my-harness-writing-design` must choose the design baseline from the product scenario.

Rules:

- If product scenario is unclear, do not initialize files. Ask the user to choose Admin Console, BI dashboard/data cockpit, or C-end website/app.
- Admin Console / backend management uses shadcn/ui + tweakcn.
- BI chart analysis / analytics dashboard / data cockpit uses React + Ant Design Pro + ECharts.
- C-end website/app does not lock a frontend framework in `writing-design`; Product Design output feeds the later `plan-eng-review` framework decision.
- Ant Design Pro is supported here only for BI/data cockpit scenarios, not normal Admin Console work.

When changing scenario guidance, update:

- `skills/my-harness-writing-design/SKILL.md`
- `skills/my-harness-writing-design/scripts/harness_write_design.py`
- `skills/my-harness-writing-design/templates/`
- `skills/my-harness-next-action/SKILL.md`
- `skills/my-harness/SKILL.md`
- `README.md`
- `docs/project-history.md`
- `CHANGELOG.md`

Then run:

```bash
./scripts/verify.sh
```

## shadcn MCP Guidance

shadcn MCP is an important optional helper for shadcn/ui frontend work. Maintain it as a recommended tool, not a hard dependency.

Rules:

- Do not block the `my-harness` SOP when shadcn MCP is unavailable.
- Fall back to shadcn CLI, official shadcn docs, and existing project components.
- Keep the distinction explicit: shadcn MCP is optional tooling, but the Admin Console shadcn/ui + tweakcn baseline is mandatory unless the project has an explicit migration/interop decision.
- Do not silently edit global Codex MCP configuration; adding shadcn MCP to `~/.codex/config.toml` requires explicit user authorization.
- Keep component discovery and install work behind the normal gates: design component mapping, `plan-eng-review`, `IMPLEMENTATION_PLAN.md`, implementation, and design review.
- Generated or installed registry code must still be inspected for dependencies, tokens, accessibility, responsive behavior, and project conventions.
- Step 6 plans for Admin Console work must check `components.json`, Tailwind config, aliases, registry settings, `src/components/ui` or an equivalent component directory, and must record missing setup as implementation work rather than hand-rolling UI.

When changing shadcn MCP guidance, update:

- `skills/my-harness-writing-design/SKILL.md`
- `skills/my-harness-writing-design/templates/DESIGN.shadcn-admin-console.md`
- `skills/my-harness-next-action/SKILL.md`
- `skills/my-harness/SKILL.md`
- `README.md`
- `docs/project-history.md`
- `CHANGELOG.md`

Then run:

```bash
./scripts/verify.sh
```

## Local Dogfooding

Use the source repo as the edit point:

```bash
cd /Users/wenzhewang/my_plugin/my-harness
./scripts/verify.sh
./scripts/install-local.sh
```

After installation, confirm the symlinks:

```bash
ls -l ~/.codex/skills/my-harness*
```

## Upgrade Workflow

Online updates are handled by `my-harness-upgrade` plus the platform script:

- macOS / Linux: `scripts/upgrade.sh`
- Windows PowerShell: `scripts/upgrade.ps1`

Version terms must stay consistent:

- Current version: installed plugin `.codex-plugin/plugin.json`.
- Target ref: GitHub tag, branch, or commit; omitted means latest GitHub Release/tag.
- Target version: downloaded target archive `.codex-plugin/plugin.json`.
- Version iteration: current version to target version.

Check without changing local files:

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh --check
```

Apply the latest stable update:

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
```

Apply a pinned update:

```bash
MY_HARNESS_REF=<tag-or-branch> ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
```

Windows PowerShell examples:

```powershell
& "$HOME\.codex\plugins\local\my-harness\plugins\my-harness\scripts\upgrade.ps1" -Check
$env:MY_HARNESS_REF = "v1.5.0"
& "$HOME\.codex\plugins\local\my-harness\plugins\my-harness\scripts\upgrade.ps1"
```

After an update, always verify:

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/verify.sh
ls -l ~/.codex/skills/my-harness*
```

## Project Initialization Workflow

New or mostly empty target projects are initialized through `my-harness-initialize-project`.

Use it to create or strengthen the first project-facing governance surface:

- `README.md` with purpose, status, and local/verification placeholders when unknown
- `AGENTS.md` with agent rules, verification expectations, and no unauthorized release/push/deploy actions
- links to `DESIGN.md` and `DEPLOY.md` when those governance files are created or already present
- a final handoff to `my-harness-next-action`

Keep this separate from implementation work. The initializer must not invent a stack, create secrets, or build the app unless the user explicitly asks for implementation.

If a blank, mostly blank, or not-started target project explicitly asks to use the `my-harness` framework/process, the first harness handoff must be step 1 Superpowers `brainstorming`. Use it to clarify the target user, problem, constraints, success criteria, smallest worthwhile slice, non-goals, risks, and candidate approaches before design artifacts, implementation plans, QA, or autopilot. Initialization can still add `README.md` / `AGENTS.md`, but it does not replace the first brainstorm gate.

For target projects that already use `my-harness`, `.my-harness/` may be created as a quick execution index:

- `.my-harness/index.md` for the current 15-step status, phase, evidence links, and next prompt
- `.my-harness/status.md` for a short live summary when useful
- `.my-harness/runs/<date-or-slice>.md` for per-slice notes, decisions, verification commands, and review-loop counts

Do not move third-party artifacts into `.my-harness/`. Superpowers plans stay in `docs/superpowers/` or `IMPLEMENTATION_PLAN.md`; gstack reports stay in their report directories; Product Design, Pencil, screenshots, and visual targets stay in `design/`; deployment governance stays in `DEPLOY.md`; release notes stay in the project's release docs. `.my-harness/` only links and summarizes, and must not contain secrets or conflicting source-of-truth instructions.

## Project Deploy / Upgrade Workflow

Project-level production deployment governance is handled by `my-harness-writing-deployment`.

Use it for target projects that need:

- versioned Docker images as the release artifact
- Docker Compose as the production runtime
- `install.sh` for first-time initialization
- `upgrade.sh` for version-to-version upgrades
- DB initialization SQL for first install when Compose includes a DB container
- DB DDL/data migration SQL or a mature migration tool for every release gap
- runtime configuration migration checks during upgrade

The skill writes or preserves `DEPLOY.md`, then links the deployment constraint from `AGENTS.md` and `CLAUDE.md`. Keep this separate from `my-harness-upgrade`, which only updates the local `my-harness` plugin installation.

The generated governance must also require strict `DEPLOY.md` compliance during development and final deployment, require missing `install.sh` / `upgrade.sh` scripts to be developed, and require both install and upgrade logic to be validated for every version upgrade and release.

## Optional Post-Deploy Canary Workflow

Post-deploy canary monitoring is handled by `my-harness-canary`.

Use it after step 15 when a target project needs extra confidence on a live production, staging, or preview URL. Keep it separate from `land-and-deploy`: the required SOP still has 15 steps, and canary is an optional direct-call follow-up.

The skill wraps gstack `/canary` and must stay observational:

- save canary report evidence under `.gstack/canary-reports/` when available
- create GitHub issues for confirmed findings in the monitored project
- do not modify code, tests, deployment files, docs, or runtime config to fix findings
- confirm the target GitHub repo when it cannot be resolved unambiguously
- support explicit user requests for daily or periodic Codex automation, but never start recurring checks by default

## Release Checklist

Before a public release:

1. Update `.codex-plugin/plugin.json` version.
2. Update `CHANGELOG.md`.
3. Update `README.md`, including dependencies, constraints, install methods, skill usage, and version history.
4. Check `scripts/install.sh` and `scripts/install.ps1` default to the intended public ref.
5. Run `./scripts/check-release-lineage.sh --pre-release`.
6. Check `scripts/upgrade.sh --check` and `scripts/upgrade.ps1 -Check` report the expected current and target version terms where the platform is available.
7. Run `./scripts/verify.sh`.
8. Run `./scripts/install-local.sh` and smoke test in a fresh Codex session.
9. Run a temporary-home installer smoke test:

   ```bash
   CODEX_HOME="$(mktemp -d)" MY_HARNESS_REF=<tag-or-branch> bash scripts/install.sh
   ```

10. Run a temporary-home upgrade smoke test against the intended archive or ref.
11. Commit the release.
12. Push, tag, and create GitHub Release only after explicit authorization.
13. Run `./scripts/check-release-lineage.sh --post-release`.
