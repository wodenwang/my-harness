# my-harness v1.3.0 Release Notes

## Summary

`v1.3.0` publishes the frontend-design enhancement release for `my-harness`.

This release keeps the canonical 15-step SOP unchanged while adding optional Product Design and shadcn MCP guidance inside the existing frontend design, planning, implementation, and QA gates.

## What's New

- Added `my-harness-product-design-bridge` for optional Product Design routing.
- Product Design can now help create a frontend visual target through `get-context` -> `ideate` -> user selection, with the selected target recorded under `design/` and used as Pencil input.
- Product Design `image-to-code` and `url-to-code` are allowed only inside step 7 after `IMPLEMENTATION_PLAN.md` exists and only for the first frontend vertical slice.
- Product Design `design-qa.md` may support step 10 as visual-fidelity evidence, but does not replace verification, browser checks, design review, QA, code review, ship, or deploy gates.
- Added shadcn MCP guidance across the frontend flow:
  - Step 3: component mapping for design governance.
  - Step 5: MCP / CLI / registry strategy in engineering review.
  - Step 6: component/block install tasks in `IMPLEMENTATION_PLAN.md`.
  - Step 7: implementation-time registry browsing, search, and install.
  - Step 10: design review checks for composition, tokens, spacing, and custom component boundaries.
- Expanded the shadcn Admin Console `DESIGN.md` template with stricter shadcn/ui implementation constraints:
  - reuse shadcn/ui and existing project components first
  - use Tailwind CSS, CSS variables, and project design tokens
  - follow an 8px spacing system by default
  - avoid random colors and unnecessary gradients
  - create custom base components only when justified

## Compatibility

- Product Design is optional. If it is unavailable, `my-harness` falls back to the original Pencil-centered flow.
- shadcn MCP is recommended but optional. If it is unavailable, use shadcn CLI, official docs, and existing project components.
- The 15-step SOP is unchanged.
- No automatic global Codex MCP configuration changes are made.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.3.0/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.3.0/scripts/install.ps1 | iex
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
```
