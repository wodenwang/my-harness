# my-harness v1.4.1 Release Notes

## Summary

`v1.4.1` publishes a workflow-hardening release for `my-harness`.

This release makes design governance stricter, makes Product Design the preferred design gate when available, adds a clear first-step rule for blank projects that explicitly request `my-harness`, and introduces `.my-harness/` as an optional execution index for projects already using the workflow.

## What's New

- UI / frontend / chart / app work must create or verify `DESIGN.md` through `my-harness-writing-design` before design review, frontend planning, implementation, or visual QA.
- Product Design focused skills replace gstack `/plan-design-review` and `/design-review` for design-related gates when Product Design is available.
- Product Design planning and frontend work must provide at least three prototype/visual options; target/autopilot mode may choose the system-recommended option with recorded rationale.
- Frontend slices with a selected Product Design prototype must use `image-to-code` / `url-to-code` for prototype slicing after `IMPLEMENTATION_PLAN.md` exists.
- Design review must compare the implemented UI against the selected prototype and `DESIGN.md`, then keep fixing until highly faithful or deviations are explicitly accepted.
- Creative Production `logo-explorer` is required during design planning/prototype design when the target system lacks an app/product title, logo, or favicon.
- `executing-plans` and `subagent-driven-development` prompts must keep Codex and subagents aligned with `AGENTS.md`, `DESIGN.md`, `IMPLEMENTATION_PLAN.md`, and related governance docs.
- Blank or not-started projects that explicitly ask for the `my-harness` framework/process now begin at step 1 with Superpowers `brainstorming`.
- Projects already using `my-harness` may create `.my-harness/` as a quick execution index while keeping Superpowers, gstack, Product Design, Pencil, deployment, and release artifacts in their native directories.

## Compatibility

- The canonical 15 step numbers are unchanged.
- Product Design remains optional. If unavailable, use the selected design baseline, existing UI references, screenshots, or optional Pencil for complex alignment.
- Third-party artifacts remain in their native paths; `.my-harness/` is an index and execution log, not a source-of-truth replacement.
- When shadcn/ui, Ant Design Pro, ECharts, or another selected framework conflicts with a prototype, the framework components and `DESIGN.md` take precedence.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.4.1/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.4.1/scripts/install.ps1 | iex
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
