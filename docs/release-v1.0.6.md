# my-harness v1.0.6 Release Notes

Release date: 2026-05-29

## Scope

`v1.0.6` makes `my-harness-next-action` prompts self-chaining, so a user can keep copying the final prompt after each harness step without asking next-action again.

## Highlights

- Recommended prompts now include the immediate next harness action plus a required handoff clause.
- After finishing a prompted action, the executor must output the `流程执行情况一览：` 15-step table and put the next copyable `推荐提示词` at the end.
- README and project-history behavior contracts document the self-chaining prompt rule.
- Installer defaults and README pinned examples now point to `v1.0.6`.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.0.6/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.0.6/scripts/install.ps1 | iex
```

## Verification

Release checks used:

```bash
./scripts/verify.sh
git diff --check
./scripts/install-local.sh
```

Post-release lineage should be checked after the tag and GitHub Release are published.
