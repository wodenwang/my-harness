# my-harness v1.0.1 Release Notes

`v1.0.1` turns `my-harness` into a cross-platform install/update release and trims the public README.

## Highlights

- Windows users can install with `scripts/install.ps1`.
- Windows users can check or apply updates with `scripts/upgrade.ps1`.
- macOS / Linux installer default now points to `v1.0.1`.
- README is shorter and focused on value, install, update, skills, dependencies, and maintenance.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.0.1/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.0.1/scripts/install.ps1 | iex
```

## Verification

Release checks used:

```bash
./scripts/verify.sh
./scripts/install-local.sh
CODEX_HOME="$(mktemp -d)" MY_HARNESS_ARCHIVE_URL="file://<archive>" MY_HARNESS_REF=v1.0.1 bash scripts/install.sh
```

PowerShell scripts were added for Windows support. Run `scripts/install.ps1` and `scripts/upgrade.ps1 -Check` on Windows or PowerShell Core when available.
