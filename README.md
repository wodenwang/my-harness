# My Harness

`my-harness` 是一个 Codex workflow plugin，用来把个人项目交付流程固定成一组可复用 skills。它不安装 gstack、Superpowers、Pencil 或 Playwright，只负责把这些工具、项目证据和发布门禁组织成清晰路径。

适合三类场景：

- 判断项目现在推进到哪一步，下一步该做什么。
- 初始化 UI/产品项目的设计治理和 Pencil starter。
- 在线检查、安装或更新本机 `my-harness` 插件。

## 安装

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.1.1/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.1.1/scripts/install.ps1 | iex
```

默认安装到：

```text
~/.codex/plugins/local/my-harness/plugins/my-harness
~/.codex/plugins/local/my-harness/.agents/plugins/marketplace.json
~/.codex/skills/my-harness*
```

安装指定版本、分支或 commit:

```bash
MY_HARNESS_REF=main curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/main/scripts/install.sh | bash
```

```powershell
$env:MY_HARNESS_REF = "main"
irm https://raw.githubusercontent.com/wodenwang/my-harness/main/scripts/install.ps1 | iex
```

## 更新

只检查，不改文件：

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh --check
```

```powershell
& "$HOME\.codex\plugins\local\my-harness\plugins\my-harness\scripts\upgrade.ps1" -Check
```

更新到最新 GitHub Release / tag:

```bash
~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
```

```powershell
& "$HOME\.codex\plugins\local\my-harness\plugins\my-harness\scripts\upgrade.ps1"
```

更新到指定 ref:

```bash
MY_HARNESS_REF=v1.1.1 ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
```

```powershell
$env:MY_HARNESS_REF = "v1.1.1"
& "$HOME\.codex\plugins\local\my-harness\plugins\my-harness\scripts\upgrade.ps1"
```

升级输出会展示：当前版本、目标 ref、目标版本、版本迭代、来源、验证结果和备份路径。`main` 不是默认稳定通道，只有显式指定时才会使用。

## Skills

| Skill | 用途 |
|---|---|
| `my-harness` | 路由入口，判断该使用哪个 harness helper。 |
| `my-harness-next-action` | 读取项目证据，输出 15 步 SOP 状态表和下一步提示词；提示词会要求执行完成后继续输出进度表和下一步提示词，便于只复制末尾提示词持续推进；第 1 步支持 `office-hours` 或 Superpowers `brainstorming`，但 `brainstorming` 后默认仍需经过 `plan-design-review` 和 `plan-eng-review` 才能进入 `writing-plans`。 |
| `my-harness-writing-design` | 初始化 `DESIGN.md`、`design/`、Pencil starter；Admin Console 统一使用 shadcn/ui + tweakcn，并生成包含布局、导航、表格、按钮、状态、响应式和 QA 门禁的后台 UI 规范。 |
| `my-harness-autopilot-slice` | 在 Discovery / Brainstorm gate 已定稿后推进一个小切片，并在人工门禁处停止。 |
| `my-harness-upgrade` | 检查或更新已安装插件，并回读版本、备份和 skill 入口。 |

## Codex 兼容门禁

Codex 当前不能稳定承接 gstack 部分 skill 内部的 `AskUserQuestion`。通过 `my-harness` 调用或推荐调用 gstack `/office-hours`、`/plan-design-review`、`/plan-eng-review`、`/design-review`、`/qa`、`/review`、`/ship`、`/land-and-deploy` 或其他可能交互提问的 skill 时，提示词会要求：

- 不进入 Plan mode。
- 不调用 `AskUserQuestion`、`request_user_input` 或交互式选择工具。
- 把交互门禁改成 Markdown 决策门禁。
- 决策项使用 `D1`、`D2`、`D3` 编号，并用表格呈现选项、推荐项、pros、cons 和影响范围。
- 需要用户决策时停止等待。
- 除非用户明确要求，否则只读分析，不修改项目文件。
- 输出保持结构化、清晰、适合复制到文档。

常用提示词：

```text
我现在项目推进到哪一步了，下一步该做什么？
```

```text
为当前项目初始化设计治理，默认 shadcn/ui 后台风格。
```

```text
请使用 my-harness-upgrade 检查当前 my-harness 是否有新版本，只检查不更新。
```

## 依赖

必需：

- Codex App / Codex CLI
- Git
- macOS / Linux: Bash、curl、tar、rsync、Python 3
- Windows: PowerShell、tar.exe、Python 3；如可创建 junction/symlink，会优先链接 skill，否则复制 skill 目录

协调但不随插件安装：

- gstack skills
- Superpowers skills
- Pencil / Pencil MCP / Pencil CLI
- Browser、Playwright 或 gstack browse

缺少这些协调工具时，`my-harness` 可以给出阶段判断和下一步建议，但不能声称对应设计、QA、发布或浏览器验证门禁已经完成。

## 维护

源码事实源是本仓库。改动后运行：

```bash
./scripts/verify.sh
./scripts/install-local.sh
```

新增 skill 时同步：

- `skills/<skill-name>/SKILL.md`
- `skills/my-harness/SKILL.md`
- `README.md`
- 必要时更新 `docs/maintenance.md` 或 `docs/project-history.md`

远端 push、tag、GitHub Release 或发布动作必须有明确授权。

## 版本历史

### v1.1.1

- 新增 Codex-safe gstack 门禁契约：通过 harness 推荐 gstack skill 时，不进入 Plan mode，不调用 `AskUserQuestion` / `request_user_input`，改用 Markdown 决策门禁。
- `my-harness-next-action` 的 gstack 提示词模板内置 `D1` / `D2` / `D3` 决策表、推荐项、pros/cons、影响范围、停止等待和默认只读约束。
- `my-harness-autopilot-slice` 遇到 gstack 决策点时停止并交给用户选择，不继续交互式推进。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.1.1`。

### v1.1.0

- 废除 `my-harness-writing-design` 的 Ant Design 模板；未来 Admin Console 设计基线统一使用 shadcn/ui + tweakcn。
- `DESIGN.md` 模板扩展为更完整的后台 UI 验收基线：覆盖 `AppShell`、左侧导航、DataTable 列宽与长 ID、Dialog / Sheet / 独立页选择、表单错误、状态文案、390px mobile、可访问性、design review 和 Playwright QA。
- 设计规范新增按钮规则：列表页或空间较窄场景可使用纯 icon 按钮，其余按钮使用 icon + 文字，纯 icon 按钮必须有可访问标签和 tooltip/title，按钮文案不得换行。
- `my-harness-next-action` 的推荐提示词模板改为分段纯文本，便于阅读和复制。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.1.0`。

### v1.0.6

- `my-harness-next-action` 的末尾推荐提示词现在会自带连续推进要求：执行完毕后输出 `流程执行情况一览：` 15 步进度表，并继续给出下一步可复制提示词。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.0.6`。

### v1.0.5

- 明确 Superpowers `brainstorming` 完成后不得直接跳到 Superpowers `writing-plans`；除非需求极其简单，否则必须先经过 `plan-design-review`、必要的 Pencil 原型策划和 `plan-eng-review`。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.0.5`。

### v1.0.4

- 将已发布的 `v1.0.3` 基线收敛回 `main`，修复发布事实源不一致。
- 修复并强化 `scripts/verify.sh`，自动检查 manifest、changelog、installer 默认 ref 和 README 安装示例。
- 新增 `scripts/check-release-lineage.sh`，用于发布前后检查 main/tag/Release 关系。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.0.4`。

### v1.0.3

- 将第 1 步从固定 `gstack /office-hours` 改为 Discovery / Brainstorm gate。
- 第 1 步默认仍使用 `gstack /office-hours`，但允许在目标和价值已明确时使用 Superpowers `brainstorming` 收敛候选方案/spec。
- 更新 `my-harness-next-action` 和 `my-harness-autopilot-slice` 的证据判断、提示词和启动门禁。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.0.3`。

### v1.0.2

- `my-harness-writing-design` 无显式框架偏好时默认选择 shadcn/ui，而不是 Ant Design。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.0.2`。

### v1.0.1

- 新增 Windows PowerShell 安装脚本 `scripts/install.ps1`。
- 新增 Windows PowerShell 更新脚本 `scripts/upgrade.ps1`。
- `scripts/install.sh` 默认稳定版本更新为 `v1.0.1`。
- README 改为短版公开入口，保留安装、更新、skills、依赖和维护信息。
- 验证脚本检查 Windows 脚本与当前版本 changelog。

### v1.0.0-beta

- 提供公开 one-liner 安装入口。
- 添加 `my-harness-upgrade` 和 `scripts/upgrade.sh`。
- README 补充目的、依赖、约束、安装方法、skills 使用方法和版本历史。
- `my-harness-writing-design` 支持 Ant Design 与 shadcn/ui 两条设计治理 baseline。

### v0.1.0

- 初始化 `my-harness` 插件结构。
- 添加 `my-harness`、`my-harness-next-action`、`my-harness-writing-design`、`my-harness-autopilot-slice`。
- 固化 15 步 gstack + Superpowers + Pencil + browser verification + Git SOP。

## License

MIT
