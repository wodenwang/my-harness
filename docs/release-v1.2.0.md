# my-harness v1.2.0 Release Notes

Release date: 2026-06-07

`v1.2.0` publishes the new project-initialization, deployment-governance, and optional canary-monitoring skills.

## Changes

- Added `my-harness-initialize-project` for new or empty project bootstrap, including `README.md`, `AGENTS.md`, design/deployment links, and a first harness next-action handoff.
- Added `my-harness-writing-deployment` for project-level `DEPLOY.md` governance, with links from `AGENTS.md` and `CLAUDE.md`.
- The deployment governance covers versioned Docker Compose releases, `install.sh`, `upgrade.sh`, DB initialization SQL, DB DDL/data migrations, configuration migrations, and release-version gates.
- Strengthened generated deployment rules so projects must comply with `DEPLOY.md`, develop missing install/upgrade scripts, and validate install plus upgrade behavior for every release.
- Added `my-harness-canary` as an optional post-step-15 wrapper around gstack `/canary`.
- Canary runs observe live URLs, register confirmed findings as GitHub issues, avoid fixing findings in the canary step, and support explicit Codex timer automation requests.
- Updated router rules, next-action prompts, README, maintenance docs, project history, plugin metadata, and verification coverage for the new skills.
- Installer defaults and README pinned examples now point to `v1.2.0`.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.2.0/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.2.0/scripts/install.ps1 | iex
```

## Verification

Run from the repository root:

```bash
./scripts/verify.sh
./scripts/install-local.sh
```
