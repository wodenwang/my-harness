# My Harness 项目治理

本仓库是 `my-harness` Codex 插件的源码项目。后续维护、发布和分享都以本目录为事实源。

## 沟通和文档

- 默认使用中文沟通和撰写维护记录。
- 技术标识、skill 名称、命令、路径、错误信息保留英文。
- 面向公开使用者的 README 默认使用中文；具体命令、路径、skill 名称、技能提示词和英文专有名词可以保留英文。

## 源码边界

- 插件源码位于本仓库根目录。
- Codex 插件元数据位于 `.codex-plugin/plugin.json`。
- 技能统一放在 `skills/<skill-name>/SKILL.md`。
- 允许每个技能拥有自己的 `scripts/`、`templates/`、`references/`。
- 不要提交 `__pycache__`、`.pyc`、临时截图、运行日志或本机私有配置。

## 命名规则

- 插件名固定为 `my-harness`。
- 所有子技能使用 `my-harness-*` 前缀。
- 新技能优先使用 `my-harness-<verb>-<object>`。
- 新增技能后必须同步更新：
  - `skills/my-harness/SKILL.md` 路由表
  - `README.md` skill table
  - 如有流程变化，更新 `docs/project-history.md` 或 `docs/maintenance.md`

## 维护流程

1. 修改前先读相关 `SKILL.md` 和 README。
2. 保持每个 skill 单一职责，不把多个阶段揉进一个巨大 skill。
3. 技能 frontmatter `description` 必须以 `Use when` 开头。
4. 对会写文件的技能，说明保守合并规则、不会覆盖什么、完成检查是什么。
5. 修改后运行 `./scripts/verify.sh`。
6. 如需在本机试用，运行 `./scripts/install-local.sh` 同步到 Codex 本地插件目录。

## 发布边界

- 不自动 push、创建 release、打 tag 或发布新版本，除非用户明确授权。
- 公开仓库发布前必须确认 README、LICENSE、manifest、验证脚本和 skill 列表同步。
- 版本号以 `.codex-plugin/plugin.json` 为准；发布说明记录在 `CHANGELOG.md`。

## My Harness SOP 事实源

当前标准闭环仍保留 15 个 step 编号，编号用于证据、交接和闭环判断。面向用户说明和执行推荐时，可以合并成 6 个阶段：

| 阶段 | 覆盖 step | 用户视角 |
|---|---:|---|
| 1. 需求和方向澄清 | 1-2 | 确认是否值得做、给谁用、最小切片是什么，并挑战早期产品/交互方向。 |
| 2. 设计基线和视觉目标 | 3-4 | 创建或确认设计制品、视觉目标、组件/图表映射，并完成设计输入复审。 |
| 3. 工程方案和实施计划 | 5-6 | 挑战架构、数据流、测试、风险，然后生成可执行计划。 |
| 4. 第一个可运行切片 | 7-8 | 实现第一个端到端 vertical slice，并用新鲜证据验证。 |
| 5. 浏览器、视觉、功能 QA | 9-11 | 在真实页面上完成浏览器验证、视觉/交互 QA 和系统化功能 QA。 |
| 6. 代码审查、发布、部署 | 12-15 | 做 diff review、Git closeout 作为 `/ship` 前置检查、准备发布，并在授权后落地部署和线上验证。 |

阶段可以作为执行工作包被推荐，但 `流程执行情况一览：` 必须保留全部 15 个 step 行。

当前 15 step 标准闭环为：

1. Discovery / Brainstorm gate：默认使用 gstack `/office-hours`；如果项目价值和目标已经明确、需要方案或 spec 收敛，可使用 Superpowers `brainstorming`
2. gstack `/plan-design-review`
3. Design artifact / visual target：默认优先使用 Product Design `get-context` -> `ideate` -> 用户选择；已有截图、URL、Figma、现有 UI 或设计说明时可直接作为视觉目标；只有复杂前端模块或需要人类协同对齐时才使用 Pencil prototype
4. gstack `/plan-design-review` on selected design artifact
5. gstack `/plan-eng-review`
6. Superpowers `writing-plans`
7. Superpowers `executing-plans` or `subagent-driven-development`
8. Superpowers `verification-before-completion`
9. gstack `/browse` verification, optional `open-gstack-browser`, Playwright fallback
10. gstack `/design-review`
11. gstack `/qa`
12. gstack `/review`
13. Git closeout / `/ship` preflight
14. gstack `/ship`
15. gstack `/land-and-deploy`

可选独立步骤：15 步完成后，如果用户需要线上金丝雀测试，直接调用 `my-harness-canary`。这不是必做的第 16 步，不阻塞 SOP 闭环；发现问题只登记到当前项目 GitHub issues，不在 canary 步骤中修复。

前端设计默认增强：如果宿主机安装了 Product Design 插件，且当前 UI 切片需要视觉目标、`image-to-code` / `url-to-code` 辅助实现或 `design-qa.md` 视觉还原证据，直接在对应 SOP 步骤中使用 Product Design focused skills，不再通过独立 bridge skill。没有视觉目标时，设计阶段默认走 Product Design `get-context` -> `ideate` -> 用户选择；选中结果记录到 `design/`。实现阶段只有在 `IMPLEMENTATION_PLAN.md` 已存在后，才允许使用 Product Design `image-to-code` / `url-to-code` 作为第一个 frontend vertical slice 的实现辅助。Product Design 不是 `my-harness` 必需依赖；未安装时不要求安装，改用 shadcn/ui 设计基线、已有 UI 参考、截图或必要时 Pencil 协同制品继续推进。

shadcn MCP 是前端开发的重要可选工具：Step 3 可用于组件映射，Step 5 评审 MCP/CLI/registry 策略和 fallback，Step 6 写入 `IMPLEMENTATION_PLAN.md`，Step 7 用于浏览、搜索和引入组件，Step 10 检查 shadcn composition、8px spacing、token 颜色和自定义组件边界。未配置 shadcn MCP 时不阻塞流程，改用 shadcn CLI、官方文档和项目已有组件。

`my-harness-writing-design` 必须先确认产品场景再写文件。场景不明确时不得初始化，必须反向询问用户选择 Admin Console、BI 图表分析 / 数据驾驶舱或 C 端网站 / App。Admin Console 使用 shadcn/ui + tweakcn；BI 图表分析 / 数据驾驶舱使用 React + Ant Design Pro + ECharts；C 端网站 / App 不在 writing-design 中锁定框架，由 Product Design 产出视觉和框架选择输入，并在后续 `plan-eng-review` 中决策。

如果第 1 步使用了 Superpowers `brainstorming`，完成该门禁后不能直接进入 Superpowers `writing-plans`。除非当前需求极其简单、简单到无需设计评审和工程评审，否则必须先使用 `plan-design-review` 挑战产品、交互和前端方案，必要时创建 Product Design 视觉目标或 Pencil 协同制品，再使用 `plan-eng-review` 挑战工程方案，最后才能进入 `writing-plans`。

即便 Superpowers `brainstorming` 已经产出前后端实现方案，也只把它当作候选输入，后续仍要用 `plan-design-review` 和 `plan-eng-review` 重新挑战并打磨最佳方案。

## Codex-safe gstack 门禁

Codex 当前不能稳定承接 gstack 某些 skill 内部的 `AskUserQuestion` 交互。通过 `my-harness` 调用或推荐调用 gstack `/office-hours`、`/plan-design-review`、`/plan-eng-review`、`/design-review`、`/qa`、`/review`、`/ship`、`/land-and-deploy`、`/canary` 或其他可能使用 `AskUserQuestion` 的 skill 时，必须使用 Markdown 决策门禁：

- 按 gstack 流程分析当前任务，但不要进入 Plan mode。
- 不要调用 `AskUserQuestion`、`request_user_input` 或任何交互式选择工具。
- 所有交互门禁改为 Markdown 决策门禁。
- 决策项使用 `D1`、`D2`、`D3` 编号。
- 每个决策项用表格呈现选项、推荐项、pros、cons、影响范围。
- 在需要用户决策时停止等待，不继续执行后续阶段。
- 除非用户明确要求修改文件，否则只读分析，不修改项目文件。
- 输出必须结构化、清晰、适合复制到文档。
