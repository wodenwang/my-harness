# My Harness

`my-harness` 是一个 Codex 插件，用来把个人项目交付流程固化成可复用的 skills。它围绕 gstack、Superpowers、Pencil、浏览器验证和 Git 收口，帮助 Codex 判断项目当前阶段、推荐下一步动作、初始化设计治理，并在合适时推进小切片。

它不是一个通用脚手架，也不是 gstack / Superpowers / Pencil 的发行包。它的定位是 **workflow harness**：把已有工具、项目证据和交付门禁组织成一条清晰的执行路径。

## 快速安装

普通用户推荐使用 one-liner 安装 `v1.0.0-beta`：

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.0.0-beta/scripts/install.sh | bash
```

安装脚本会把插件放到：

```text
~/.codex/plugins/local/my-harness/plugins/my-harness
```

并创建本地 marketplace：

```text
~/.codex/plugins/local/my-harness/.agents/plugins/marketplace.json
```

同时会在 `~/.codex/skills/` 下创建这些 skill symlink：

```text
my-harness
my-harness-next-action
my-harness-writing-design
my-harness-autopilot-slice
my-harness-upgrade
```

安装后可以检查：

```bash
ls -l ~/.codex/skills/my-harness*
```

如果要安装其他分支或版本：

```bash
MY_HARNESS_REF=main curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/main/scripts/install.sh | bash
```

## 在线更新

已安装用户推荐使用 `my-harness-upgrade`，它会先展示当前版本、目标 ref、目标版本和版本迭代，再执行更新和验证。

只检查最新可用版本，不改本机文件：

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh --check
```

更新到最新 GitHub Release 或最新 tag：

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
```

更新到指定 tag、branch 或 commit：

```bash
MY_HARNESS_REF=v1.0.1 ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
MY_HARNESS_REF=main ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
```

版本概念：

| 概念 | 含义 |
|---|---|
| 当前版本 | 本机已安装插件 `.codex-plugin/plugin.json` 中的 `version` |
| 目标 ref | GitHub tag、branch 或 commit；未指定时解析 latest GitHub Release/tag |
| 目标版本 | 下载目标 ref 后，其 `.codex-plugin/plugin.json` 中的 `version` |
| 版本迭代 | 当前版本到目标版本的变化，例如 `1.0.0-beta -> 1.0.1` |
| 更新来源 | GitHub Release/tag/branch/commit，或测试时显式覆盖的 archive URL |

`main` 不是默认稳定通道。只有明确指定 `MY_HARNESS_REF=main` 时才会从 `main` 更新。

## 依赖与约束

`my-harness` 是 Codex workflow plugin，不会自动安装它依赖或协调的外部工具。

### 必需依赖

| 依赖 | 用途 |
|---|---|
| Codex App / Codex CLI | 加载 plugin、发现 skills、执行项目工作流 |
| Git | 读取项目状态、确认提交边界、支持 release closeout |
| Bash / curl / tar / rsync / Python 3 | one-liner 安装、本地同步、在线更新和 manifest 校验 |

### 强依赖但不随插件安装

| 依赖 | 用途 | 缺失时行为 |
|---|---|---|
| gstack skills | `/office-hours`、`/plan-design-review`、`/design-review`、`/qa`、`/review`、`/ship`、`/land-and-deploy` | `my-harness-next-action` 仍可判断阶段，但不能完整执行对应门禁 |
| Superpowers skills | `writing-plans`、`executing-plans`、`verification-before-completion`、`subagent-driven-development` | 可给出下一步建议，但实现、计划或验证阶段需要人工替代 |
| Pencil / Pencil MCP / Pencil CLI | 产出和审查 `.pen` 原型、导出截图 | 只能创建 starter 文件和设计输入文档，不能声称原型完成 |
| Browser / Playwright / gstack browse | 浏览器检查、视觉 QA、交互验证 | 只能记录验证缺口，不能把 UI 工作判定为完成 |

### 设计框架约束

`my-harness-writing-design` 目前只支持两条 UI baseline：

| UI baseline | 触发条件 | 默认风格 |
|---|---|---|
| Ant Design | 默认选择；用户未明确指定 UI 框架时使用 | Ant Design Pro 后台布局、Ant Design 默认 token |
| shadcn/ui | 只有用户明确选择 shadcn 或 shadcn/ui 时使用 | tweakcn 风格主题、Tailwind CSS variables、composition-first |

不支持把以下框架静默映射为 Ant Design 或 shadcn/ui：

- Material UI
- Chakra UI
- Arco Design
- Element Plus
- Bootstrap
- Tailwind UI
- Radix-only
- 自定义大型 Design System

如果用户明确要求这些框架，skill 应拒绝并要求在 Ant Design 与 shadcn/ui 中二选一，除非当前任务明确是迁移、兼容或互操作方案。

### 发布与权限约束

- `my-harness` 不会自动 push、merge、tag、release 或 deploy。
- `/ship` 和 `/land-and-deploy` 相关远端动作必须获得明确授权。
- `my-harness-writing-design` 创建的空白 `.pen` 只是 starter，不等于已完成 Pencil 原型。
- `my-harness-autopilot-slice` 只适合 `office-hours` 已定稿之后的小切片，不适合大版本、开放式产品设计或多系统重构。

## 快速开始

安装后，在 Codex 中可以直接使用这些提示词：

```text
我现在项目推进到哪一步了，下一步该做什么？
```

```text
为当前项目初始化设计治理，默认 Ant Design 后台风格。
```

```text
为当前项目初始化设计治理，我明确选择 shadcn/ui。
```

```text
office-hours 已经定稿，请按 my-harness autopilot 推进这个小切片，在需要人工确认的门禁处停止。
```

## Skills 使用方法

| Skill | 用途 | 典型输入 | 典型输出 |
|---|---|---|---|
| `my-harness` | 路由技能，用来判断当前应该调用哪个 harness helper | “我应该用哪个 my-harness skill？” | 推荐 skill、原因、下一步提示词 |
| `my-harness-next-action` | 读取项目证据，判断当前 SOP 步骤 | 项目目录、治理文件、git 状态、验证记录 | 完整 15 步状态表、当前下一步、可复制提示词 |
| `my-harness-writing-design` | 初始化项目设计治理 | UI 框架偏好、阶段名、主题素材、项目根目录 | `DESIGN.md`、`design/`、Pencil starter、`AGENTS.md` 设计链接 |
| `my-harness-autopilot-slice` | 在 `office-hours` 已定稿后推进一个小切片 | 明确的小切片范围、成功标准、非目标 | 逐步执行汇总、验证证据、人工交接点 |
| `my-harness-upgrade` | 在线更新本机 `my-harness` 插件 | 目标版本、tag、branch，或只检查最新版本 | 当前版本、目标版本、版本迭代、验证证据、备份路径 |

### `my-harness`

用于协调其他 harness skills。适合在你知道要推进项目、但不确定该调用哪个 helper 时使用。

示例：

```text
这个项目接下来应该用哪个 my-harness skill？请给我推荐。
```

### `my-harness-next-action`

用于回答一个问题：当前项目下一步应该做什么。它会先看项目治理、计划、设计、实现、验证和 release 证据，再输出完整状态表。

示例：

```text
使用 my-harness-next-action 判断当前项目推进到哪一步，并给我下一步提示词。
```

### `my-harness-writing-design`

用于在 UI / 产品实现前建立设计治理。默认选择 Ant Design；只有用户明确选择 shadcn 或 shadcn/ui 时才使用 shadcn/ui baseline。

本 skill 可以配合脚本使用：

```bash
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --stage v0.1.0 --phase admin-console
```

明确使用 shadcn/ui：

```bash
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --ui-framework shadcn --stage v0.1.0 --phase admin-console
```

带主题素材说明：

```bash
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --theme-source "logo + 官网主色 #1677ff" --stage v0.1.0 --phase admin-console
```

### `my-harness-autopilot-slice`

用于小而边界清晰的版本切片。它要求 `office-hours` 已经定稿，并会在需要产品判断、Pencil 设计确认、远端发布授权或其他人工门禁时停止。

示例：

```text
office-hours 已经定稿，范围是只完成登录页第一条端到端链路。请使用 my-harness-autopilot-slice 推进，遇到人工授权门禁就停止。
```

### `my-harness-upgrade`

用于更新本机已安装的 `my-harness` 插件。它默认检查最新 GitHub Release/tag，也支持指定 tag、branch 或 commit。

示例：

```text
请使用 my-harness-upgrade 检查当前 my-harness 是否有新版本，只检查不更新。
```

```text
请使用 my-harness-upgrade 把本机 my-harness 更新到最新稳定版本，并回读当前版本、目标版本和 symlink 状态。
```

```text
请使用 my-harness-upgrade 更新到 MY_HARNESS_REF=main，并说明这次版本号是否变化。
```

## 标准 SOP

`my-harness` 的默认闭环是：

1. gstack `/office-hours`
2. gstack `/plan-design-review`
3. Pencil prototype
4. gstack `/plan-design-review` on prototype
5. gstack `/plan-eng-review`
6. Superpowers `writing-plans`
7. Superpowers `executing-plans` or `subagent-driven-development`
8. Superpowers `verification-before-completion`
9. gstack `/browse` verification, optional `open-gstack-browser`, Playwright fallback
10. gstack `/design-review`
11. gstack `/qa`
12. gstack `/review`
13. Git closeout
14. gstack `/ship`
15. gstack `/land-and-deploy`

这条 SOP 是默认交付路径，不代表每个项目都必须完整执行。`my-harness-next-action` 会根据项目证据判断哪些步骤已完成、无需、证据不足或待执行。

## 安装原理

Codex 插件发现依赖本地 marketplace。`scripts/install.sh` 会把 GitHub tag 下载到本地，并生成以下结构：

```text
~/.codex/plugins/local/my-harness/
  .agents/plugins/marketplace.json
  plugins/my-harness/
    .codex-plugin/plugin.json
    skills/
      my-harness/
      my-harness-next-action/
      my-harness-writing-design/
      my-harness-autopilot-slice/
```

它还会尝试在 `~/.codex/config.toml` 中追加缺失的插件配置：

```toml
[plugins."my-harness@my-harness"]
enabled = true

[marketplaces.my-harness]
source_type = "local"
source = "/Users/you/.codex/plugins/local/my-harness"
```

如果你的 Codex 配置已经包含这些段落，安装脚本不会重复追加。

## 维护者指南

本仓库是源码事实源。维护者从 checkout 安装时使用：

```bash
./scripts/verify.sh
./scripts/install-local.sh
```

新增 harness helper 时：

1. Create `skills/my-harness-<verb>-<object>/SKILL.md`.
2. Update `skills/my-harness/SKILL.md` routing.
3. Update this README skill table，并保持 README 主体为中文。
4. Add helper scripts/templates inside that skill directory when needed.
5. Run `./scripts/verify.sh`.
6. Run `./scripts/install-local.sh` for local dogfooding.
7. If the helper affects online updates, run `./scripts/upgrade.sh --check` against a temporary test archive or released ref.

发布前检查：

```bash
./scripts/verify.sh
./scripts/install-local.sh
ls -l ~/.codex/skills/my-harness*
```

远端发布动作，包括 push、tag、GitHub Release，都需要明确授权。

## 版本历史

### v1.0.0-beta

- 提供公开 one-liner 安装入口。
- 添加 `my-harness-upgrade` 和 `scripts/upgrade.sh`，支持在线检查和更新本机插件。
- 升级输出明确区分当前版本、目标 ref、目标版本和版本迭代，并在应用更新后回读 manifest 与 skill symlink。
- 重构 README，补充目的、依赖、约束、安装方法、skills 使用方法和版本历史。
- `my-harness-writing-design` 支持 Ant Design 与 shadcn/ui 两条设计治理 baseline。
- 默认 Ant Design + Ant Design Pro 后台风格；明确选择 shadcn/ui 时使用 tweakcn 风格 baseline。
- 增加主题素材解析规则，避免直接复制营销页视觉。

### v0.1.0

- 初始化 `my-harness` 插件结构。
- 添加四个 skills：`my-harness`、`my-harness-next-action`、`my-harness-writing-design`、`my-harness-autopilot-slice`。
- 固化 15 步 gstack + Superpowers + Pencil + browser verification + Git SOP。

## License

MIT
