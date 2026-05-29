# Changelog

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
- Required `plan-design-review`, Pencil prototype planning when needed, and `plan-eng-review` after a brainstorming gate unless the request is extremely simple.
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
