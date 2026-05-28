# my-harness v1.0.5 Release Notes

Release date: 2026-05-28

## Scope

`v1.0.5` tightens the Discovery / Brainstorm gate so Superpowers `brainstorming` cannot be treated as an approved implementation plan.

## Highlights

- Superpowers `brainstorming` output is documented as candidate input only.
- After a brainstorming gate, `my-harness-next-action` requires `plan-design-review`, Pencil prototype planning when needed, and `plan-eng-review` before `writing-plans`, unless the request is extremely simple.
- `my-harness-autopilot-slice` now follows the same guard and will not start directly at planning or implementation after brainstorming.
- Installer defaults and README pinned examples now point to `v1.0.5`.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.0.5/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.0.5/scripts/install.ps1 | iex
```

## Verification

Release checks used:

```bash
./scripts/verify.sh
./scripts/check-release-lineage.sh --pre-release
./scripts/install-local.sh
CODEX_HOME="$(mktemp -d)" MY_HARNESS_REF=v1.0.5 MY_HARNESS_ARCHIVE_URL="file://<local-archive>" bash scripts/install.sh
```

Post-release lineage should be checked after the tag and GitHub Release are published.
