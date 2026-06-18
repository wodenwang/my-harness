# Project History

This document captures the useful decisions from the initial one-conversation build of `my-harness`.

## Origin

The plugin started as a way to answer one recurring question during project delivery:

> I am pushing a project forward, but I do not know where I am in the harness. What should I do next?

The first implementation packaged that answer into `my-harness-next-action`, then grew into a plugin so future harness helpers could live under one namespace.

## Core Decisions

- The plugin is called `my-harness`.
- Skill names use `my-harness-*`.
- The router skill is `my-harness`.
- The next-action skill is `my-harness-next-action`.
- The design-governance skill is `my-harness-writing-design`.
- The bounded closed-loop execution skill is `my-harness-autopilot-slice`.
- The online update skill is `my-harness-upgrade`.
- The project bootstrap skill is `my-harness-initialize-project`.
- The project-level deployment and upgrade governance skill is `my-harness-writing-deployment`.
- The optional post-deploy canary skill is `my-harness-canary`.

## Canonical Flow

The 15 step numbers are retained as the evidence ledger. User-facing explanations may group them into phases:

| Phase | Steps | Purpose |
|---|---:|---|
| 1. Discovery and direction | 1-2 | Clarify target, value, constraints, and early product/interaction direction. |
| 2. Design baseline and visual target | 3-4 | Create or confirm the design artifact / visual target and review it before engineering planning. |
| 3. Engineering plan | 5-6 | Review architecture and risks, then write the executable implementation plan. |
| 4. First runnable slice | 7-8 | Implement and verify the first end-to-end vertical slice. |
| 5. Browser, visual, and functional QA | 9-11 | Validate the running app through browser verification, design review, and functional QA. |
| 6. Review, ship, and deploy | 12-15 | Review the diff, run Git closeout as `/ship` preflight, prepare shipping materials, and land/deploy after authorization. |

Phase packages are recommendation conveniences only. Status reports must keep all 15 rows.

| Step | Harness action |
|---:|---|
| 1 | Discovery / Brainstorm gate: gstack `/office-hours` or Superpowers `brainstorming` |
| 2 | gstack `/plan-design-review` |
| 3 | Design artifact / visual target |
| 4 | gstack `/plan-design-review` on selected design artifact |
| 5 | gstack `/plan-eng-review` |
| 6 | Superpowers `writing-plans` |
| 7 | Superpowers `executing-plans` or `subagent-driven-development` |
| 8 | Superpowers `verification-before-completion` |
| 9 | gstack `/browse`, optional `open-gstack-browser`, Playwright fallback |
| 10 | gstack `/design-review` |
| 11 | gstack `/qa` |
| 12 | gstack `/review` |
| 13 | Git closeout / `/ship` preflight |
| 14 | gstack `/ship` |
| 15 | gstack `/land-and-deploy` |

Optional after step 15: `my-harness-canary` can be invoked directly for post-deploy gstack `/canary` monitoring. It is not part of the required 15-step table and does not block SOP closure.

Frontend design enhancement inside the existing 15 steps: Product Design focused skills can be used directly when installed and a UI slice needs a visual target, Product Design-assisted `image-to-code` / `url-to-code`, or `design-qa.md` evidence. It is not a new canonical step and does not block SOP closure when unavailable.

## Important Behavior Contracts

- `my-harness-next-action` must inspect artifacts before recommending step 1.
- Step 1 is a Discovery / Brainstorm gate: default to gstack `/office-hours` for new product, version, or opportunity discovery; accept Superpowers `brainstorming` evidence when value and target are already clear and the work needs candidate design/spec convergence.
- Step 1 output is a candidate input for later review, not an approved design. `plan-design-review` and `plan-eng-review` still challenge the product, interaction, and engineering assumptions.
- When step 1 used Superpowers `brainstorming`, the next action cannot jump directly to Superpowers `writing-plans`. The workflow must run `plan-design-review` for product/interaction/frontend planning, create or confirm a design artifact / visual target when needed, and run `plan-eng-review` for engineering planning before step 6, unless the request is extremely simple enough that both reviews are unnecessary.
- Even if Superpowers `brainstorming` already produced frontend and backend implementation ideas, those ideas remain candidate inputs for `plan-design-review` and `plan-eng-review`, not approved plans.
- From `v1.1.1`, all harness-generated gstack prompts must be Codex-safe: do not enter Plan mode, do not call `AskUserQuestion` or `request_user_input`, convert interaction points into Markdown decision gates, number decisions as `D1` / `D2` / `D3`, show options/recommendation/pros/cons/impact in tables, stop when the user must decide, and stay read-only unless the user explicitly asks for file edits.
- If the SOP is already closed, it must say `当前 SOP 已闭环。` and provide the full status table instead of starting a new Discovery / Brainstorm loop.
- The next-action table must include all 15 steps and use the agreed emoji status markers.
- `my-harness-next-action` may recommend a phase work package such as steps 9-11 QA or steps 5-6 engineering plan, but it must still preserve all 15 step rows and identify the first incomplete or blocked row.
- Step 13 is Git closeout / `/ship` preflight. It gathers diff, status, commit boundary, remote state, and authorization-sensitive actions before Step 14. It does not replace `gstack /ship`.
- Recommended prompts must be standalone fenced `text` blocks.
- Recommended prompts must be self-chaining: after naming the immediate action, they must require the executor to output the `流程执行情况一览：` 15-step table and a new copyable final prompt after finishing, so the user can keep copying the last prompt without asking next-action again.
- `my-harness-writing-design` creates design-governance scaffolding and may use Product Design, shadcn MCP, and optional Pencil tooling when available.
- Product Design is optional but preferred for frontend visual targets when installed. If the host Codex does not have the Product Design plugin, `my-harness` must not require installation; continue with shadcn/ui design governance, existing UI references, screenshots, or optional Pencil for complex alignment.
- When Product Design is available and no frontend visual target exists, the preferred design branch is `get-context` -> `ideate` -> user selects one option. The selected visual target must be recorded under `design/` and is first-class step 3 evidence.
- Product Design `image-to-code` and `url-to-code` are allowed only inside step 7 after `IMPLEMENTATION_PLAN.md` exists and only for the first frontend vertical slice. They must not bypass Superpowers planning or expand scope.
- Product Design `design-qa.md` may support step 10 as visual-fidelity evidence, but it does not replace step 8 verification, step 9 browser checks, step 10 `gstack /design-review`, step 11 QA, step 12 review, step 14 ship, or step 15 land/deploy.
- From `v1.1.0`, `my-harness-writing-design` no longer uses the Ant Design template. New Admin Console design baselines use shadcn/ui with tweakcn as the default style reference.
- `my-harness-writing-design` now chooses frontend design baseline by product scenario. Admin Console remains shadcn/ui + tweakcn; BI chart analysis, analytics dashboards, and data cockpits use React + Ant Design Pro + ECharts; C-end websites/apps do not lock a framework and use Product Design output as input for later engineering review.
- If the product scenario is unclear, `my-harness-writing-design` must stop and ask the user to choose Admin Console, BI dashboard/data cockpit, or C-end website/app before writing files.
- shadcn MCP is an important optional tool for shadcn/ui frontend work. Use it when configured to browse, search, inspect, and install registry components and blocks; if unavailable, fall back to shadcn CLI, official docs, and existing project components.
- shadcn MCP fits the SOP in five places: step 3 for design artifact component mapping, step 5 for engineering review of MCP/CLI/registry strategy and fallback, step 6 for recording component/block install tasks in `IMPLEMENTATION_PLAN.md`, step 7 for implementation, and step 10 for checking shadcn composition, tokens, spacing, and custom component boundaries.
- The shadcn/ui design baseline requires reuse before custom components, Tailwind CSS and project tokens, 8px spacing by default, no random colors, no unnecessary gradients or glassmorphism, and no casual custom base components.
- Unsupported UI framework preferences, including Ant Design, Material UI, Chakra UI, Arco Design, Element Plus, Bootstrap, Tailwind UI, Radix-only, and custom large design systems, are refused by this skill instead of being silently mapped.
- From `v1.1.0`, the shadcn/ui design baseline is an executable Admin Console UI checklist: it covers `AppShell`, sidebar hierarchy, PageHeader, FilterBar, DataTable column stability, long ID handling, Dialog / Sheet / detail-page selection, form errors, state coverage, responsive checks, accessibility, design review, and Playwright QA.
- Button rules are part of the design baseline: list pages or genuinely narrow compact layouts may use icon-only buttons; icon-only buttons require accessible labels and tooltip/title; all other buttons use icon + text; button labels must not wrap.
- Theme colors, websites, logos, screenshots, or brand assets must be parsed into safe admin-console theme tokens instead of copied as marketing-page visuals.
- `my-harness-autopilot-slice` is only for small, bounded work after the Discovery / Brainstorm gate is finalized.
- Autopilot loops `design-review`, `qa`, and `review` until clear, accepted, blocked, or 10 iterations.
- Autopilot must summarize completion, refusal, handoff, blocker, and authorization-required exits with the same `流程执行情况一览` table style as `my-harness-next-action`: all 15 steps, fixed emoji statuses, and loop metrics folded into `证据/原因` instead of separate numeric columns; skipped steps must still be listed with `⏭️ 前置无需进行` and the skip reason.
- `my-harness-upgrade` must distinguish current version, target ref, target version, and version iteration before applying updates.
- Plugin updates use `scripts/upgrade.sh` on macOS/Linux and `scripts/upgrade.ps1` on Windows; the skill coordinates checks, applies user-requested updates, and verifies manifest plus `~/.codex/skills/my-harness*` entries afterward.
- Stable updates default to the latest GitHub Release/tag. Updating from `main` requires explicit `MY_HARNESS_REF=main` or an equivalent user instruction.
- `my-harness-initialize-project` is for new or mostly empty target repositories. It creates or strengthens `README.md`, `AGENTS.md`, links to design/deployment governance when relevant, and hands off to `my-harness-next-action`; it must not invent stack decisions or implement the app unless the user explicitly asks.
- `my-harness-writing-deployment` governs target project deployment, not plugin updates. Like `my-harness-writing-design`, it writes a standalone project document: `DEPLOY.md`, then links it from `AGENTS.md` and `CLAUDE.md`. It requires production deployment to be version-granular: Docker image tags are pinned to release versions, Docker Compose is the runtime, `install.sh` handles first install, `upgrade.sh` handles only explicit version-to-version upgrades, and DB/config changes are part of the same upgrade gate.
- When a Compose deployment includes a DB container, first install must include DB initialization SQL and later releases must provide DB DDL/data migrations or use a mature migration framework with an explicit release-to-release path.
- The generated `DEPLOY.md` contract applies during project development and final deployment. Missing `install.sh` / `upgrade.sh` scripts must be developed, and every version upgrade or release must validate both install and upgrade logic.
- `my-harness-canary` wraps gstack `/canary` for live production, staging, or preview URLs after deployment. It observes and reports only: confirmed findings are registered as GitHub issues in the monitored project, and code or deployment fixes are left to later triage.
- Recurring canary checks are opt-in only. When the user asks for daily or periodic monitoring, the skill should use Codex automation/timer tooling to schedule repeated runs with the same no-fix, issue-registration contract.
