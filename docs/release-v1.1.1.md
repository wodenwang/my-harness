# my-harness v1.1.1 Release Notes

Release date: 2026-05-30

`v1.1.1` adds a Codex compatibility contract for gstack skills that may ask interactive questions.

## Changes

- Added a Codex-safe gstack gate rule to project governance and harness routing.
- Updated `my-harness-next-action` so gstack prompt templates require:
  - no Plan mode;
  - no `AskUserQuestion`, `request_user_input`, or interactive choice tools;
  - Markdown decision gates with `D1` / `D2` / `D3`;
  - tables with options, recommendation, pros, cons, and impact;
  - stop-and-wait behavior when the user must decide;
  - read-only analysis unless the user explicitly asks for file edits;
  - structured output suitable for documentation.
- Updated `my-harness-autopilot-slice` so gstack decision points become handoff points instead of interactive continuation.
- Documented the compatibility behavior in README and project history.
- Installer defaults and README pinned examples now point to `v1.1.1`.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.1.1/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.1.1/scripts/install.ps1 | iex
```

## Verification

Run from the repository root:

```bash
./scripts/verify.sh
./scripts/install-local.sh
```
