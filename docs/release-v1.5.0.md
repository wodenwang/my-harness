# my-harness v1.5.0 Release Notes

## Summary

`v1.5.0` publishes the Frontend Fidelity First release for `my-harness`.

This release makes UI-heavy work such as CRM, Portal, Admin Console, dashboards, and apps follow a frontend-first mock loop before backend integration. It also strengthens old-project `DESIGN.md` refresh behavior and makes Admin Console shadcn/ui compliance harder to skip.

## What's New

- Step 3 now requires an approved visual target, not just a design direction. The target must include source/rationale, target mockup or reference, and implementation spec extraction.
- UI-heavy projects now use Step 6A-11A as a Frontend Fidelity Loop: frontend plan, mock implementation, frontend verification, browser screenshots, Product Design high-fidelity gate, and mock functional QA.
- Backend/API/real-data integration moves to Step 6B-11B after frontend fidelity passes, then reruns integration verification, browser verification, visual regression, and full functional QA.
- Step 9A browser screenshots are now required before Step 10A. Without screenshots, the Product Design fidelity gate has no evidence.
- Step 10A is now a hard gate with target mockup/reference, browser screenshots, differences, fixes, before/after evidence, and accepted deviations.
- Existing projects that explicitly run `my-harness-writing-design` now receive the latest Frontend Fidelity First governance addendum in `DESIGN.md` while preserving project-specific design content.
- Admin Console Product Design and implementation guidance now requires shadcn/ui + tweakcn evidence, Tailwind token/CSS variable mapping, 8px spacing, and explicit non-shadcn UI framework exclusion.
- Product Design `image-to-code` / `url-to-code` remains scaffold only. Admin Console completion must refit generated output to shadcn/ui primitives, project components, and Tailwind tokens.

## Compatibility

- The canonical 15-step evidence ledger is unchanged.
- Step 6A-11A and Step 6B-11B are evidence sub-loops inside Step 6-11, not new canonical steps.
- Product Design remains optional as an installed dependency. If unavailable, use the selected design baseline, existing UI references, screenshots, or optional Pencil when human alignment requires it.
- shadcn MCP remains optional tooling. It is not an excuse to skip the Admin Console shadcn/ui + tweakcn baseline.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.5.0/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.5.0/scripts/install.ps1 | iex
```

## Verification

Release validation should include:

```bash
./scripts/verify.sh
git diff --check
bash -n scripts/install.sh scripts/upgrade.sh scripts/install-local.sh scripts/verify.sh scripts/check-release-lineage.sh
./scripts/check-release-lineage.sh --pre-release
./scripts/install-local.sh
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/verify.sh
./scripts/check-release-lineage.sh --post-release
```
