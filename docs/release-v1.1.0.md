# my-harness v1.1.0 Release Notes

Release date: 2026-05-29

`v1.1.0` updates the design-governance baseline and next-action prompt readability.

## Changes

- `my-harness-writing-design` no longer uses the Ant Design template.
- New Admin Console design baselines use shadcn/ui with tweakcn as the default style reference.
- The generated `DESIGN.md` baseline now includes stricter executable UI rules:
  - standard `AppShell` / `Sidebar` / `TopBar` / content layout;
  - sidebar hierarchy, active states, collapsed tooltips, and mobile Drawer behavior;
  - DataTable column stability, operation-column stability, long text/long ID handling, and responsive fallback;
  - Dialog / Sheet / detail-page selection rules, including a ban on narrow Sheet usage for heavy interactions;
  - form-level API errors, sensitive-error redaction, state coverage, request id display, accessibility, and responsive checks;
  - design-review and Playwright QA gates, including console and unexpected Network failure checks.
- Button rules are also part of the generated design baseline:
  - list pages or genuinely narrow compact layouts may use icon-only buttons;
  - all other buttons use icon + text;
  - icon-only buttons require accessible labels and tooltip/title;
  - button labels must not wrap.
- `my-harness-next-action` prompt templates are formatted as readable plain-text paragraphs instead of dense one-line table cells.
- Installer defaults and README pinned examples now point to `v1.1.0`.

## Install

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.1.0/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.1.0/scripts/install.ps1 | iex
```

## Verification

Run from the repository root:

```bash
./scripts/verify.sh
./scripts/install-local.sh
```
