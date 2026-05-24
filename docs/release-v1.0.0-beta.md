# my-harness v1.0.0-beta Release Notes

Release date: 2026-05-24

## Scope

`v1.0.0-beta` is the first public beta release of `my-harness` as a Codex workflow plugin.

This release focuses on:

- public one-liner installation
- README clarity for new users
- dependency and constraint disclosure
- Ant Design and shadcn/ui design-governance baselines
- online upgrade checks with explicit version iteration
- release hygiene for future plugin publication

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.0.0-beta/scripts/install.sh | bash
```

## Included Skills

- `my-harness`
- `my-harness-next-action`
- `my-harness-writing-design`
- `my-harness-autopilot-slice`
- `my-harness-upgrade`

## Notes

`my-harness` coordinates external tools but does not install them. gstack, Superpowers, Pencil, Browser/Playwright, Ant Design, and shadcn/ui availability should be treated as project or machine-level prerequisites depending on the workflow being run.

Remote publish actions for this release are:

1. push release-prep commit
2. create tag `v1.0.0-beta`
3. create GitHub Release from this note and `CHANGELOG.md`
4. verify the public one-liner against the tag
