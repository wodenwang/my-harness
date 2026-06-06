---
name: my-harness-writing-deployment
description: Use when a project needs deployment governance, a DEPLOY.md baseline, versioned Docker Compose install and upgrade rules, database initialization and migration rules, configuration migration rules, or AGENTS.md and CLAUDE.md links to deployment constraints
---

# My Harness Writing Deployment

## Purpose

Create project-level deployment governance before production delivery work begins.

This skill writes a standalone `DEPLOY.md` in the target Codex project and links it from `AGENTS.md` and `CLAUDE.md`, so future development and final deployment must obey the deployment and upgrade contract.

This skill governs the target project. It is not for updating the local `my-harness` plugin; use `my-harness-upgrade` for that.

## Before Editing

1. Read project governance first: `AGENTS.md`, `CLAUDE.md`, README, existing deploy docs, release docs, and current scripts.
2. Inspect existing `Dockerfile`, `docker-compose*.yml`, `install.sh`, `upgrade.sh`, DB schema/migration folders, `.env.example`, and version files.
3. Preserve existing project rules. Merge deployment governance; do not overwrite unrelated instructions.
4. If `AGENTS.md` and `CLAUDE.md` are synchronized governance files, keep deployment references synchronized.

## Required Outputs

In the target project root:

- `DEPLOY.md` exists and describes the project-level deployment and upgrade contract.
- `AGENTS.md` links to `DEPLOY.md` and tells agents to read and enforce it before touching deployment, release, DB schema, DB seed data, migration, Docker, Compose, env, install, or upgrade files.
- `CLAUDE.md` links to `DEPLOY.md` with the same constraint.

Recommended optional output:

- `deploy/` directory exists when the project has no deployment structure yet.
- `deploy/db/init/` exists when Docker Compose includes or will include a DB container.
- `deploy/db/migrations/` exists when the project needs SQL-based release migrations.

## Fast Path

From the target project root, run:

```bash
python3 ~/.codex/skills/my-harness-writing-deployment/scripts/harness_write_deployment.py
```

Useful options:

```bash
python3 ~/.codex/skills/my-harness-writing-deployment/scripts/harness_write_deployment.py --project-name feishu-iam --stage v0.1.0
python3 ~/.codex/skills/my-harness-writing-deployment/scripts/harness_write_deployment.py --create-deploy-dirs
```

The script is conservative: it creates missing files and appends deployment-governance sections to `AGENTS.md` and `CLAUDE.md`; it does not overwrite an existing `DEPLOY.md`.

## DEPLOY.md Baseline

Use `templates/DEPLOY.md` as the default baseline. Adapt these fields before finalizing:

- project name
- current phase/version
- production image registry
- Compose file path
- version source of truth
- DB engine and migration tool, if known
- install and upgrade verification commands

Keep these non-negotiable constraints:

- Project development and final deployment must strictly follow `DEPLOY.md`.
- Production release artifact is a versioned Docker image.
- Production runtime is Docker Compose.
- `install.sh` handles first-time installation only.
- `upgrade.sh` handles version-to-version upgrades only.
- If `install.sh` or `upgrade.sh` is missing, develop the missing script as part of deployment readiness instead of treating deployment as complete.
- Production image tags must be immutable version tags, not `latest`.
- Every production install or upgrade must resolve an explicit target version.
- Every version upgrade and release must validate both `install.sh` and `upgrade.sh` logic.
- If Compose includes a DB container, first install must include initialization SQL that runs during DB container initialization.
- Every release-to-release DB difference must include DDL/data migrations or an explicit migration-tool path.
- Runtime configuration changes must be enforced by `upgrade.sh`; secrets must never be overwritten silently.

## Governance Link

Add or merge this section into both `AGENTS.md` and `CLAUDE.md`:

```markdown
## 部署与升级规范

- 项目级部署和升级规则见 `DEPLOY.md`。
- 项目开发过程中和最终部署过程中，必须严格执行 `DEPLOY.md`。
- 修改 `Dockerfile`、`docker-compose*.yml`、`install.sh`、`upgrade.sh`、`.env.example`、数据库 schema、初始化 SQL、迁移 SQL、release 版本或部署目录前，必须先检查 `DEPLOY.md`。
- 如果项目缺少 `install.sh` 或 `upgrade.sh`，必须先补齐对应脚本，不能把手工部署步骤当作完成状态。
- 每次版本升级和发布前，必须校验 `install.sh` 和 `upgrade.sh` 的逻辑。
- 正式部署以版本为最小管理颗粒度；不得使用 `latest`、未固定镜像 tag 或任意脏状态升级。
- 如实现需要偏离 `DEPLOY.md`，先更新 `DEPLOY.md` 并说明原因，再修改实现。
```

## Completion Check

Before reporting done:

```bash
test -f DEPLOY.md
rg -n "DEPLOY.md|部署与升级规范" AGENTS.md
rg -n "DEPLOY.md|部署与升级规范" CLAUDE.md
```

If deployment directories were requested:

```bash
test -d deploy
test -d deploy/db/init
test -d deploy/db/migrations
```

Record whether `DEPLOY.md` was created or already existed, and whether `AGENTS.md` / `CLAUDE.md` were created or updated.
Record whether `install.sh` and `upgrade.sh` already exist or still need to be developed.

## Common Mistakes

- Writing deployment rules only inside the skill instead of generating `DEPLOY.md` in the target project.
- Forgetting `CLAUDE.md` when the project uses both governance files.
- Treating a project as deployment-ready while `install.sh` or `upgrade.sh` is missing.
- Changing or releasing a version without validating both install and upgrade logic.
- Treating `docker compose up` as a production install process.
- Using `latest` as the production image tag.
- Shipping DB init SQL but no release-to-release migration plan.
- Running all migration files blindly without checking current and target versions.
- Overwriting `.env` and secrets during upgrade.
- Updating version markers before health checks pass.
