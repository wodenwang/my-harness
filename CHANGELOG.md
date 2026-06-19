# Changelog

## 1.4.1 - 2026-06-19

- Required UI / frontend / chart / app work to create or verify `DESIGN.md` through `my-harness-writing-design` before design review, frontend planning, implementation, or visual QA.
- Updated Product Design guidance so Product Design focused skills replace gstack `/plan-design-review` and `/design-review` for design-related gates when available.
- Required Product Design planning and frontend work to provide at least three prototype/visual options, with target/autopilot mode allowed to choose the system-recommended option only with recorded rationale.
- Required frontend slices with a selected Product Design prototype to use `image-to-code` / `url-to-code` for prototype slicing after `IMPLEMENTATION_PLAN.md` exists.
- Required design review to compare the implemented UI against the selected prototype and `DESIGN.md`, then keep fixing until highly faithful or deviations are explicitly accepted.
- Clarified that shadcn/ui, Ant Design Pro, ECharts, and other selected framework components take precedence when a prototype conflicts with the framework's component model.
- Required Creative Production `logo-explorer` during design planning/prototype design when a target system lacks an app/product title, logo, or favicon.
- Required `executing-plans` and `subagent-driven-development` prompts to keep Codex and subagents continuously aligned with `AGENTS.md`, `DESIGN.md`, `IMPLEMENTATION_PLAN.md`, and related governance docs.
- Required blank or not-started projects that explicitly ask for the `my-harness` framework/process to begin at step 1 with Superpowers `brainstorming`.
- Added optional `.my-harness/` execution indexing for projects already using `my-harness`, while keeping Superpowers, gstack, Product Design, Pencil, deployment, and release artifacts in their native directories.
- Updated installer defaults to `v1.4.1`.

## 1.4.0 - 2026-06-18

- Added a six-phase user-facing view over the canonical 15-step SOP while preserving all step numbers as the evidence ledger.
- Reframed step 13 as Git closeout / `/ship` preflight, with step 14 `gstack /ship` retaining the final shipping closeout.
- Updated `my-harness-next-action` to allow phase work-package recommendations while still requiring the full 15-row `流程执行情况一览：` table.
- Added a product-scenario gate to `my-harness-writing-design`: if the scenario is unclear, it must stop and ask whether the project is an Admin Console, BI dashboard/data cockpit, or C-end website/app before initializing files.
- Added scenario-based frontend baselines: Admin Console uses shadcn/ui + tweakcn, BI dashboard/data cockpit uses React + Ant Design Pro + ECharts, and C-end website/app leaves framework selection to Product Design plus `plan-eng-review`.
- Removed `my-harness-product-design-bridge`; Product Design focused skills are now used directly inside the core SOP.
- Changed step 3 from fixed Pencil prototype work to `Design artifact / visual target`, with Product Design `get-context` -> `ideate` as the preferred path when available.
- Downgraded Pencil to an optional artifact for complex frontend modules, human alignment, or explicit `.pen` requirements.
- Updated `my-harness-writing-design` to create `design/design-input-<stage>.md` instead of a blank `.pen` by default.
- Updated installer defaults to `v1.4.0`.

## 1.3.0 - 2026-06-13

- Added `my-harness-product-design-bridge` as an optional Product Design integration for frontend slices. It can route visual-target discovery through `get-context` -> `ideate` -> user selection, record the selected visual target under `design/`, and keep Pencil as the formal design-governance artifact.
- Allowed Product Design `image-to-code` / `url-to-code` as implementation helpers only inside step 7 after `IMPLEMENTATION_PLAN.md` exists, and allowed `design-qa.md` as supporting evidence before step 10 without replacing verification, browser checks, design review, QA, code review, ship, or deploy gates.
- Documented Product Design as a non-required dependency: if unavailable, `my-harness` must not require installation and must fall back to the original Pencil-centered flow.
- Added shadcn MCP guidance across the frontend flow: use it as an important optional tool for component/block discovery, registry access, and installation when configured; fall back to shadcn CLI, official docs, and existing components when unavailable.
- Expanded the shadcn Admin Console `DESIGN.md` template with strict shadcn/ui implementation constraints: reuse shadcn and project components, use Tailwind CSS and tokens, follow 8px spacing, avoid random colors and unnecessary gradients, and create custom base components only when justified.
- Updated installer defaults to `v1.3.0`.

## 1.2.0 - 2026-06-07

- Added `my-harness-initialize-project` for new or empty project bootstrap. It creates or strengthens `README.md`, `AGENTS.md`, design/deployment links, and a first harness next-action handoff.
- Added `my-harness-writing-deployment` for project-level deployment governance. It generates `DEPLOY.md`, links it from `AGENTS.md` and `CLAUDE.md`, and covers versioned Docker Compose deployment, `install.sh`, `upgrade.sh`, DB initialization SQL, DB DDL/data migrations, configuration migrations, and release-version gates.
- Strengthened the generated deployment governance to require strict `DEPLOY.md` compliance during development and final deployment, require missing `install.sh` / `upgrade.sh` scripts to be developed, and require install plus upgrade logic validation for every version upgrade and release.
- Added `my-harness-canary` as an optional post-step-15 wrapper around gstack `/canary`; it monitors live URLs, registers confirmed findings as GitHub issues, does not fix findings, and supports explicit Codex timer automation requests.
- Updated the router, next-action prompt rules, README, maintenance guide, project history, plugin metadata, and verification script to include the new skills.
- Updated installer defaults to `v1.2.0`.

## 1.1.1 - 2026-05-30

- Added a Codex-safe gstack gate contract for harness-recommended gstack skills that may use `AskUserQuestion`.
- Updated `my-harness-next-action` gstack prompt templates to require Markdown decision gates with `D1` / `D2` / `D3`, recommendation tables, no Plan mode, no `AskUserQuestion` / `request_user_input`, read-only behavior unless explicitly authorized, and stop-on-decision handoff.
- Updated `my-harness-autopilot-slice` to stop at gstack decision points and hand off with Markdown decision tables instead of continuing interactively.
- Documented the Codex compatibility rule in governance, router, README, and project history.
- Updated installer defaults to `v1.1.1`.

## 1.1.0 - 2026-05-29

- Retired the `my-harness-writing-design` Ant Design template; new Admin Console design baselines now use shadcn/ui + tweakcn only.
- Expanded the shadcn/ui Admin Console `DESIGN.md` baseline with executable UI rules for AppShell layout, sidebar navigation, DataTable columns, long IDs, Dialog/Sheet/detail-page selection, form errors, state coverage, responsive checks, accessibility, design review, and Playwright QA.
- Added design baseline button rules: list pages or narrow compact areas may use icon-only buttons, other buttons use icon + text, icon-only buttons require accessible labels and tooltip/title, and button labels must not wrap.
- Reformatted `my-harness-next-action` prompt templates into readable plain-text paragraphs.
- Updated installer defaults to `v1.1.0`.

## 1.0.6 - 2026-05-29

- Required `my-harness-next-action` recommended prompts to be self-chaining: after the next action is executed, the executor must output the 15-step `流程执行情况一览：` table and another copyable final prompt.
- Documented the self-chaining next-action prompt contract in README and project history.
- Updated installer defaults to `v1.0.6`.

## 1.0.5 - 2026-05-28

- Clarified that Superpowers `brainstorming` output is candidate input only and must not jump directly to Superpowers `writing-plans`.
- Required `plan-design-review`, design artifact planning when needed, and `plan-eng-review` after a brainstorming gate unless the request is extremely simple.
- Updated installer defaults to `v1.0.5`.

## 1.0.4 - 2026-05-28

- Reconciled the release lineage so `main` can advance from `v1.0.1` to the already published `v1.0.3` baseline before this patch release.
- Fixed `scripts/verify.sh` to read the manifest version into shell checks instead of relying on an unset shell variable.
- Added release consistency checks for installer defaults, README examples, changelog sections, and release-lineage pre/post gates.
- Updated installer defaults to `v1.0.4`.

## 1.0.3 - 2026-05-27

- Changed the first harness step from a fixed `gstack /office-hours` action to a Discovery / Brainstorm gate.
- Kept `gstack /office-hours` as the default for new product or scope discovery, while allowing Superpowers `brainstorming` when the value and target are already clear and the work needs candidate design/spec convergence.
- Updated `my-harness-next-action` and `my-harness-autopilot-slice` evidence rules, prompt templates, and start gates for the new first-step semantics.
- Updated installer defaults to `v1.0.3`.

## 1.0.2 - 2026-05-26

- Changed `my-harness-writing-design` to default to shadcn/ui when no UI framework preference is provided.
- Updated installer defaults to `v1.0.2`.

## 1.0.1 - 2026-05-26

- Added Windows PowerShell installer `scripts/install.ps1`.
- Added Windows PowerShell upgrader `scripts/upgrade.ps1`.
- Updated `scripts/install.sh` to default to `v1.0.1`.
- Reworked `README.md` into a shorter public entry document.
- Updated verification to require Windows scripts and a changelog section for the current manifest version.

## 1.0.0-beta - 2026-05-24

- Added public one-liner installation through `scripts/install.sh`.
- Added `my-harness-upgrade` for checking and applying online plugin updates.
- Added `scripts/upgrade.sh` with current version, target ref, target version, version-iteration output, backup creation, verification, and symlink readback.
- Reworked `README.md` with purpose, install methods, dependencies, constraints, skill usage, SOP, maintenance, and version history.
- Updated plugin metadata to `1.0.0-beta`.
- Updated `my-harness-writing-design` to support a strict UI framework choice between Ant Design and shadcn/ui.
- Kept Ant Design as the default when no explicit user preference is provided, using Ant Design default style.
- Added a shadcn/ui `DESIGN.md` template and script support for `--ui-framework shadcn`.
- Documented refusal behavior for unsupported UI framework preferences.
- Added Ant Design Pro and tweakcn as backend-management style references in their respective design templates.
- Clarified zero-to-one Admin Console defaults: Ant Design uses Ant Design Pro layout/style, shadcn/ui uses tweakcn theme/style.
- Added theme-material inference rules for explicit colors, websites, logos, screenshots, and brand assets.

## 0.1.0 - 2026-05-24

- Initial public project structure for `my-harness`.
- Added plugin manifest and four skills:
  - `my-harness`
  - `my-harness-next-action`
  - `my-harness-writing-design`
  - `my-harness-autopilot-slice`
- Captured the canonical 15-step gstack + Superpowers + Pencil + browser verification + Git SOP.
- Added local install and verification scripts.
- Added project governance and maintenance docs.
