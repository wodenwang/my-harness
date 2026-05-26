# Release Checklist

Use this checklist before publishing a new version.

| Check | Command / Evidence |
|---|---|
| Manifest JSON is valid | `./scripts/verify.sh` |
| Skill names match directories | `./scripts/verify.sh` |
| README skill list is current | manual check |
| README dependency and constraint sections are current | manual check |
| SOP copies are synchronized | manual check across README, AGENTS, docs, and skills |
| Public installer is executable | `test -x scripts/install.sh` |
| Public upgrader is executable | `test -x scripts/upgrade.sh` |
| Windows installer exists | `test -f scripts/install.ps1` |
| Windows upgrader exists | `test -f scripts/upgrade.ps1` |
| Local plugin install works | `./scripts/install-local.sh` |
| Public installer works in temporary Codex home | `CODEX_HOME="$(mktemp -d)" MY_HARNESS_REF=<tag-or-branch> bash scripts/install.sh` |
| Windows scripts parse | `pwsh -NoProfile -Command '[scriptblock]::Create((Get-Content -Raw scripts/install.ps1)) > $null; [scriptblock]::Create((Get-Content -Raw scripts/upgrade.ps1)) > $null'`, when PowerShell is available |
| Upgrade check explains version iteration | `~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh --check` |
| Upgrade smoke test works in temporary Codex home | install into temp `CODEX_HOME`, then run `MY_HARNESS_ARCHIVE_URL=<archive> scripts/upgrade.sh` |
| Global skill symlinks point to installed plugin | `ls -l ~/.codex/skills/my-harness*` |
| Changelog updated | `CHANGELOG.md` |
| Git state reviewed | `git status --short --branch` |
| Tag does not already exist | `git tag -l <tag>` and `git ls-remote --tags origin <tag>` |

Do not push, tag, create releases, or publish marketplace updates without explicit user authorization.
