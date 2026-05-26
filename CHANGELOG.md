# Changelog

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
