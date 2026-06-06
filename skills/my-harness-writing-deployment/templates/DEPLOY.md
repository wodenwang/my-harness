# {{PROJECT_NAME}} 部署与升级规范

状态：DEPLOYMENT_BASELINE
适用阶段：{{STAGE}}

本文件是项目级部署和升级治理事实源。所有涉及生产镜像、Docker Compose、安装脚本、升级脚本、数据库初始化、数据库迁移、运行参数、发布版本和部署目录的改动，必须先遵守本文件。

## 1. 核心原则

- 项目开发过程中和最终部署过程中，必须严格执行本文件。
- 正式部署以版本为最小管理颗粒度。
- 项目最终发布形态是版本化 Docker image。
- 生产运行形态是 Docker Compose。
- `install.sh` 只负责首次初始化安装。
- `upgrade.sh` 只负责已安装版本到目标版本的升级。
- 如果项目缺少 `install.sh` 或 `upgrade.sh`，必须先开发并验证缺失脚本，不能用手工步骤替代。
- 生产镜像必须使用不可变版本 tag，例如 `ghcr.io/<org>/<app>:v1.2.3`，不得使用 `latest` 作为正式部署输入。
- 每次安装或升级必须解析明确目标版本，并在成功后写入安装版本标记。
- 每次版本升级和发布前，必须校验 `install.sh` 和 `upgrade.sh` 的逻辑。
- 数据库结构、初始化数据、运行参数和应用镜像属于同一个版本升级面，不允许只升级其中一部分后声称完成。

## 2. 推荐文件结构

```text
.
├── DEPLOY.md
├── install.sh
├── upgrade.sh
├── docker-compose.yml
├── .env.example
├── deploy/
│   ├── db/
│   │   ├── init/
│   │   └── migrations/
│   └── config/
└── .deploy/
    └── version
```

如果项目已有等价目录，可沿用现有路径，但职责必须一致。

## 3. 版本模型

需要区分以下概念：

- 当前安装版本：从 `.deploy/version`、数据库 schema version 表或等价状态读取。
- 目标版本：本次安装或升级要达到的 release 版本。
- 镜像版本：与 release 版本一致的 Docker image tag。
- Compose 版本：目标 release 携带的 `docker-compose.yml` 和 `.env.example`。
- DB 版本：最后成功应用的数据库迁移版本。
- 配置版本：目标 release 需要的运行参数集合。

安装或升级完成后，当前安装版本、DB 版本和配置版本必须与目标版本收敛。

## 4. `install.sh` 合同

如果项目还没有 `install.sh`，必须在进入正式部署前开发该脚本。

`install.sh` 必须：

1. 检查是否已经存在安装版本标记；默认拒绝重复初始化。
2. 解析目标版本，或解析一个稳定 release 版本。
3. 拉取或加载目标版本 Docker image。
4. 校验 `docker-compose.yml` 中所有生产镜像均固定到版本 tag。
5. 基于 `.env.example` 检查运行参数；不得静默生成或覆盖 secret。
6. 如果 Compose 包含 DB 容器，准备初始化 SQL，并确保 DB 容器首次初始化时自动执行。
7. 启动 Docker Compose。
8. 执行健康检查和必要 smoke test。
9. 仅在全部成功后写入 `.deploy/version` 和 DB/schema version 标记。

## 5. DB 初始化

当 Docker Compose 中存在数据库容器时，首次安装必须提供初始化 SQL。

推荐路径：

```text
deploy/db/init/
```

要求：

- 初始化 SQL 必须能在 DB 容器首次初始化时自动执行。
- Postgres/MySQL 等官方镜像优先使用 `/docker-entrypoint-initdb.d/`。
- 初始化 SQL 应包含基础 schema、必要 seed/reference data 和 schema version 初始化。
- 初始化路径只服务首次安装，不替代后续版本迁移。

## 6. `upgrade.sh` 合同

如果项目还没有 `upgrade.sh`，必须在进入正式部署前开发该脚本。

`upgrade.sh` 必须：

1. 在修改任何文件前读取当前安装版本和目标版本。
2. 默认拒绝同版本升级、降级和未声明的跨版本跳跃。
3. 对有状态部署要求或执行数据库备份。
4. 拉取目标版本 image 和目标 Compose 资产。
5. 按版本顺序执行 DB DDL/data migration。
6. 执行必要的配置迁移和 `.env` 校验。
7. 重启或滚动更新 Docker Compose 服务。
8. 执行健康检查、smoke test 和迁移后校验 SQL。
9. 仅在全部成功后更新 `.deploy/version`、DB/schema version 和配置版本标记。

`upgrade.sh` 不得简单执行“目录下所有 SQL 文件”。它必须知道当前版本、目标版本和精确迁移路径。

## 7. DB 版本迁移

每次 release 之间的数据库差异都必须提供迁移材料。

推荐命名：

```text
deploy/db/migrations/
  v1.2.0__v1.3.0.sql
  v1.3.0__v1.4.0.sql
  v1.4.0__v1.4.1.sql
```

每个迁移必须包含或说明：

- DDL 结构变化。
- 必要的数据 SQL。
- 事务策略。
- 前置条件检查。
- 迁移后验证查询。
- 幂等性说明，或明确标注不可重复执行。
- schema version 更新点，且只能在迁移成功后更新。

如果项目使用 Flyway、Liquibase、Prisma Migrate、Alembic、Rails migrations、Django migrations、Knex migrations 等成熟迁移工具，可以沿用工具，但仍必须在 release 文档或升级脚本中明确版本间迁移路径。

## 8. 配置升级

当 release 新增、删除、重命名或改变运行参数语义时，必须纳入 `upgrade.sh`。

要求：

- 对比当前 `.env` 和目标 `.env.example`。
- 保留语义未变的用户值。
- 报告新增必填变量。
- 报告删除、重命名或语义变化的变量。
- 仅在文档明确允许时添加安全默认值。
- 不得静默覆盖 secret。

## 9. 发布与验证门禁

每次版本升级和发布，都必须校验首次安装逻辑和版本升级逻辑；不能只验证当前运行容器。

每个正式版本至少需要验证：

```bash
bash -n install.sh
bash -n upgrade.sh
docker compose config
```

如项目包含 DB：

```bash
# 使用一次性 DB/volume 验证首次初始化 SQL
# 使用上一版本 fixture 验证 upgrade.sh 的版本间迁移
```

完成声明必须包含：

- 目标版本。
- Docker image tag。
- Compose 文件路径。
- 当前版本到目标版本的升级路径。
- DB 初始化或迁移验证证据。
- 配置迁移验证证据。
- 服务健康检查或 smoke test 证据。

## 10. Agent 约束

- 修改部署相关文件前必须先读本文件。
- 开发过程中涉及部署、DB、配置或版本发布的实现，必须持续遵守本文件。
- 缺少 `install.sh` 或 `upgrade.sh` 时，必须补齐脚本，而不是只写文档或手工命令。
- 每次版本升级和发布前，必须重新校验 `install.sh` 和 `upgrade.sh` 的逻辑。
- 若实现需要偏离本文件，先更新本文件并说明原因。
- 不得把“手工执行 SQL”当作可重复升级路径。
- 不得在没有新鲜验证证据时声称部署或升级流程完成。
