# my-harness v1.4.0 Release Notes

## Summary

`v1.4.0` publishes the phase-view and scenario-based frontend design release for `my-harness`.

This release keeps the canonical 15-step SOP as the evidence ledger, while presenting the workflow to users as six clearer work phases.

## What's New

- Added a six-phase user-facing view over the 15-step SOP:
  - discovery and direction
  - design baseline and visual target
  - engineering plan
  - first runnable slice
  - browser, visual, and functional QA
  - review, ship, and deploy
- Updated `my-harness-next-action` so it may recommend a phase work package while still requiring the full 15-row `流程执行情况一览：` table.
- Reframed step 13 as Git closeout / `gstack /ship` preflight. Step 14 `gstack /ship` remains the final shipping closeout.
- Removed `my-harness-product-design-bridge`; Product Design focused skills are now used directly inside the core SOP.
- Changed step 3 from fixed Pencil prototype work to `Design artifact / visual target`.
- Added product-scenario gating to `my-harness-writing-design`:
  - Admin Console: shadcn/ui + tweakcn
  - BI dashboard / data cockpit: React + Ant Design Pro + ECharts
  - C-end website/app: no framework lock in writing-design; Product Design output feeds `plan-eng-review`
- Updated `my-harness-writing-design` to create `design/design-input-<stage>.md` instead of a blank `.pen` by default.

## Compatibility

- The canonical 15 step numbers are unchanged.
- Product Design is optional. If unavailable, use the selected scenario's design baseline, existing UI references, screenshots, or optional Pencil for complex alignment.
- Pencil is optional and reserved for complex frontend modules, human alignment, or explicit `.pen` requirements.
- Step 13 does not replace `gstack /ship`; it is the preflight evidence gate before step 14.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.4.0/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.4.0/scripts/install.ps1 | iex
```

## Verification

Release validation should include:

```bash
./scripts/verify.sh
git diff --check
bash -n scripts/install.sh scripts/upgrade.sh scripts/install-local.sh scripts/verify.sh
./scripts/check-release-lineage.sh --pre-release
./scripts/install-local.sh
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/verify.sh
./scripts/check-release-lineage.sh --post-release
```
