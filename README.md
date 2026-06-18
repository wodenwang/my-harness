# My Harness

`my-harness` 是一个 Codex workflow plugin，用来把个人项目交付流程固定成一组可复用 skills。它不安装 gstack、Superpowers、Pencil、Product Design 或 Playwright，只负责把这些工具、项目证据和发布门禁组织成清晰路径。

适合六类场景：

- 初始化空白项目或新仓库的 `README.md`、`AGENTS.md` 和第一步 harness handoff。
- 判断项目现在推进到哪一步，下一步该做什么。
- 初始化 UI/产品项目的设计治理和 `design/` 设计制品目录；在 shadcn MCP 可用时辅助组件检索/安装，在 Product Design 可用时生成视觉目标、辅助 frontend slice 实现或产出 `design-qa.md` 证据；Pencil 仅作为复杂协同场景的可选制品。
- 为业务项目生成 `DEPLOY.md` 部署治理文档，并链接到 `AGENTS.md` / `CLAUDE.md`。
- 在部署完成后对线上 URL 做可选金丝雀测试，并把发现的问题登记到当前项目 GitHub issues。
- 在线检查、安装或更新本机 `my-harness` 插件。

## 安装

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/wodenwang/my-harness/v1.4.0/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/wodenwang/my-harness/v1.4.0/scripts/install.ps1 | iex
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
MY_HARNESS_REF=v1.4.0 ~/.codex/plugins/local/my-harness/plugins/my-harness/scripts/upgrade.sh
```

```powershell
$env:MY_HARNESS_REF = "v1.4.0"
& "$HOME\.codex\plugins\local\my-harness\plugins\my-harness\scripts\upgrade.ps1"
```

升级输出会展示：当前版本、目标 ref、目标版本、版本迭代、来源、验证结果和备份路径。`main` 不是默认稳定通道，只有显式指定时才会使用。

## Skills

| Skill | 用途 |
|---|---|
| `my-harness` | 路由入口，判断该使用哪个 harness helper。 |
| `my-harness-initialize-project` | 初始化新项目或空白仓库的基础治理：`README.md`、`AGENTS.md`、设计/部署链接和第一步 harness handoff。 |
| `my-harness-next-action` | 读取项目证据，输出 15 步 SOP 状态表和下一步提示词；提示词会要求执行完成后继续输出进度表和下一步提示词，便于只复制末尾提示词持续推进；第 1 步支持 `office-hours` 或 Superpowers `brainstorming`，但 `brainstorming` 后默认仍需经过 `plan-design-review` 和 `plan-eng-review` 才能进入 `writing-plans`。 |
| `my-harness-writing-design` | 初始化 `DESIGN.md`、`design/` 和设计制品规则；先确认产品场景，Admin Console 使用 shadcn/ui + tweakcn，BI / 数据驾驶舱使用 React + Ant Design Pro + ECharts，C 端网站/App 不锁定框架并交给 Product Design 产出决策输入。 |
| `my-harness-autopilot-slice` | 在 Discovery / Brainstorm gate 已定稿后推进一个小切片，并在人工门禁处停止。 |
| `my-harness-upgrade` | 检查或更新已安装插件，并回读版本、备份和 skill 入口。 |
| `my-harness-writing-deployment` | 生成项目级 `DEPLOY.md`，并链接到 `AGENTS.md` / `CLAUDE.md`；约束版本化 Docker Compose 生产部署、`install.sh` 首次安装、`upgrade.sh` 版本间升级、DB 初始化 SQL、DB DDL/数据迁移、配置迁移和版本门禁。 |
| `my-harness-canary` | 在 15 步 SOP 完成后可选调用 gstack `/canary` 监控线上 URL；只观察和登记 GitHub issues，不修复问题；可按用户要求创建每日/周期性 Codex 定时任务。 |

## 阶段视图

`my-harness` 仍然保留 15 个 step 作为证据编号和交接表，但面向用户说明时按 6 个阶段表达：

| 阶段 | 覆盖 step | 主要目的 |
|---|---:|---|
| 1. 需求和方向澄清 | 1-2 | 确认目标用户、问题、约束、最小切片，并审视早期产品/交互方向。 |
| 2. 设计基线和视觉目标 | 3-4 | 确认设计制品、视觉目标、组件/图表映射，并完成设计输入复审。 |
| 3. 工程方案和实施计划 | 5-6 | 挑战架构、数据流、测试策略和风险，然后写入 `IMPLEMENTATION_PLAN.md`。 |
| 4. 第一个可运行切片 | 7-8 | 实现第一个端到端 vertical slice，并完成基础验证。 |
| 5. 浏览器、视觉、功能 QA | 9-11 | 在真实页面上完成浏览器验证、设计 QA 和功能 QA。 |
| 6. 代码审查、发布、部署 | 12-15 | 完成代码 review、Git closeout / `/ship` preflight、`/ship` 和授权后的 `/land-and-deploy`。 |

`my-harness-next-action` 可以推荐一个阶段工作包，但最终 `流程执行情况一览：` 仍然必须包含全部 15 行。

## Codex 兼容门禁

Codex 当前不能稳定承接 gstack 部分 skill 内部的 `AskUserQuestion`。通过 `my-harness` 调用或推荐调用 gstack `/office-hours`、`/plan-design-review`、`/plan-eng-review`、`/design-review`、`/qa`、`/review`、`/ship`、`/land-and-deploy`、`/canary` 或其他可能交互提问的 skill 时，提示词会要求：

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
请使用 my-harness-initialize-project 为当前空白项目初始化 README.md、AGENTS.md 和第一步 harness handoff。
```

```text
为当前项目初始化设计治理。开始前先确认产品场景；如果我没有明确说明场景，不要初始化文件，先反向询问我是 Admin Console、BI 图表分析 / 数据驾驶舱，还是 C 端网站 / App。
```

```text
请为当前 frontend slice 产出 shadcn/ui 视觉目标：如果 Product Design 可用，使用 get-context -> ideate 生成 3 个方向并等待选择；如果不可用，使用现有 UI 参考、截图或设计说明继续推进。只有复杂协同场景才使用 Pencil。
```

```text
请使用 my-harness-upgrade 检查当前 my-harness 是否有新版本，只检查不更新。
```

```text
请使用 my-harness-writing-deployment 为当前项目生成 DEPLOY.md 部署与升级治理文档，并链接到 AGENTS.md 和 CLAUDE.md。
```

```text
请使用 my-harness-canary 对当前项目线上地址做一次 quick canary。只登记 GitHub issues，不修复发现的问题。
```

```text
请使用 my-harness-canary 为当前项目线上地址设置每日金丝雀检查。每次只登记 GitHub issues，不修复问题。
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
- shadcn MCP（推荐但可选；缺少时使用 shadcn CLI、官方文档和项目已有组件）
- Product Design plugin（推荐但可选；缺少时使用 shadcn/ui 基线、已有 UI 参考、截图或必要时 Pencil 协同制品，不阻塞 `my-harness`）
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

### v1.4.0

- 保留 15 个 step 编号，同时新增 6 个阶段视图：需求方向、设计目标、工程计划、可运行切片、QA、发布部署。
- 将 Step 13 明确为 Git closeout / `/ship` preflight，作为 Step 14 `/ship` 的前置检查，而不是独立发布阶段。
- `my-harness-next-action` 支持推荐阶段工作包，但状态表仍必须保留全部 15 个 step。
- `my-harness-writing-design` 增加产品场景门禁：场景不明确时不得初始化，必须反向询问用户选择 Admin Console、BI 图表分析 / 数据驾驶舱或 C 端网站 / App。
- `my-harness-writing-design` 增加场景化前端基线：Admin Console 使用 shadcn/ui + tweakcn；BI / 数据驾驶舱使用 React + Ant Design Pro + ECharts；C 端网站/App 不锁定框架，交给 Product Design 和后续 `plan-eng-review` 决策。
- 删除 `my-harness-product-design-bridge`，Product Design focused skills 直接进入核心 SOP：Step 3 用 `get-context` -> `ideate` 生成视觉目标，Step 7 可用 `image-to-code` / `url-to-code`，Step 10 可用 `design-qa.md` 作为视觉还原证据。
- 将 Step 3 从固定 Pencil prototype 改为 Design artifact / visual target；Pencil 降级为复杂前端模块、跨人协作或明确需要 `.pen` 的可选协同制品。
- `my-harness-writing-design` 不再默认生成 blank `.pen`，改为生成 `design/design-input-<stage>.md` 并记录 Product Design、截图、URL、Figma 或可选 Pencil 证据。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.4.0`。

### v1.3.0

- 新增 `my-harness-product-design-bridge`，把 Product Design 作为前端设计和实现的可选增强接入：没有视觉目标时可走 `get-context` -> `ideate` -> 用户选择，选中结果作为 Pencil 初稿输入并记录到 `design/`。
- 允许在 `IMPLEMENTATION_PLAN.md` 已存在后，把 Product Design `image-to-code` / `url-to-code` 作为第一个 frontend vertical slice 的实现辅助；`design-qa.md` 可作为 Step 10 前的视觉还原证据，但不替代 QA、review、ship 或 deploy。
- 明确 Product Design 不是 `my-harness` 必需依赖；宿主机未安装时不要求安装，直接降级为原 Pencil-centered 流程。
- 将 shadcn MCP 纳入前端流程：Step 3 辅助组件映射，Step 5 评审 MCP/CLI/registry 策略，Step 6 写入计划，Step 7 用于浏览、搜索和引入组件，Step 10 检查 shadcn composition、8px spacing、token 颜色和自定义组件边界。
- 在 `DESIGN.md` 模板中新增 shadcn/ui 使用硬约束：优先复用 shadcn/ui 和已有组件，使用 Tailwind CSS 与 tokens，默认 8px spacing，不使用随机颜色，不无故渐变，不随意创建自定义基础组件。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.3.0`。

### v1.2.0

- 新增 `my-harness-initialize-project`，用于初始化新项目或空白仓库的基础治理、文档入口和第一步 harness handoff。
- 新增 `my-harness-writing-deployment`，用于生成项目级 `DEPLOY.md` 部署与升级治理文档。
- 新增 `my-harness-canary`，作为 15 步 SOP 之后的可选独立金丝雀测试入口；只登记 GitHub issues，不修复问题，并支持用户显式要求的每日/周期性 Codex 定时任务。
- `scripts/install.sh` 和 `scripts/install.ps1` 默认稳定版本更新为 `v1.2.0`。

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

- 明确 Superpowers `brainstorming` 完成后不得直接跳到 Superpowers `writing-plans`；除非需求极其简单，否则必须先经过 `plan-design-review`、必要的设计制品策划和 `plan-eng-review`。
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
