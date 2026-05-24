# Release Checklist

Use this checklist before publishing a new version.

| Check | Command / Evidence |
|---|---|
| Manifest JSON is valid | `./scripts/verify.sh` |
| Skill names match directories | `./scripts/verify.sh` |
| README skill list is current | manual check |
| SOP copies are synchronized | manual check across README, AGENTS, docs, and skills |
| Local plugin install works | `./scripts/install-local.sh` |
| Global skill symlinks point to installed plugin | `ls -l ~/.codex/skills/my-harness*` |
| Changelog updated | `CHANGELOG.md` |
| Git state reviewed | `git status --short --branch` |

Do not push, tag, create releases, or publish marketplace updates without explicit user authorization.
