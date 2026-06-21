# Frontend Fidelity First Design

## 背景

`my-harness` 已经把 Product Design、`DESIGN.md`、shadcn/ui、browser verification 和 design review 纳入 15 步闭环，但实际做 CRM、Portal、Admin Console 这类后台管理项目时，仍然容易在两个地方跑偏：

- Step 3 留下的是“设计方向”或普通原型说明，而不是可验收的 approved visual target。
- Step 6-11 按传统端到端 vertical slice 推进时，前端还原、mock 状态、浏览器截图和 Product Design 高保真 QA 被放到后面，等真实后端接入后才发现布局和交互偏差。

本次改造的目标是把“前端先行 + mock + Product Design 高保真门禁”纳入 my-harness 默认 UI 工作流，借鉴 gstack 的关键做法：approved mockup、implementation spec extraction、真实浏览器截图、差异清单、before/after 修复证据、必要时 target mockup 和 fidelity-over-code-elegance。

## 候选方案

### 方案 A：只增强提示词

在 `my-harness-next-action` 和 README 中补充“前端先行”的建议，但不改变 Step 6-11 的完成定义。

优点是改动最小、风险低。缺点是仍然依赖执行者自觉，Step 9/10 很可能继续滞后，无法形成硬门禁。

### 方案 B：在现有 15 步内引入前端/后端 A-B 双循环

保留 15 个 canonical step 编号，把 Step 6-11 对 UI 项目细化为两轮：

- Step 6A-11A：Frontend Fidelity Loop。前端先用 mock 打通完整界面和交互，先过浏览器截图和 Product Design 高保真门禁。
- Step 6B-11B：Backend Integration Loop。后端和真实数据接入后再次跑浏览器、视觉回归和功能 QA，防止真实数据破坏布局和交互。

优点是最符合当前 my-harness 的证据账本，不打破 15 步闭环，也能直接落入 `writing-plans` / `executing-plans` 两轮计划。缺点是文档和 next-action 需要更明确，避免用户误解为新增正式 Step 编号。

### 方案 C：新增 `my-harness-frontend-fidelity-first` skill

独立 skill 专门处理前端先行和高保真门禁。

优点是入口显眼。缺点是增加路由复杂度，和 `my-harness-next-action`、`my-harness-writing-design` 重叠，容易形成第二套流程。

## 决策

采用方案 B。

`my-harness` 继续保留 15 个 step 作为唯一 canonical evidence ledger。对于 UI / frontend / dashboard / app 工作，特别是 CRM、Portal、Admin Console，Step 6-11 必须支持前端优先的 A/B 双循环。A/B 是 Step 6-11 内的执行轮次和证据子项，不是新编号，也不替代 Step 12-15。

## 目标行为

### Step 3：approved visual target

Step 3 必须留下 approved visual target，而不是仅留下“设计方向”。合格目标至少包含：

- 选中的视觉目标来源：Product Design 原型图、截图、URL capture、Figma frame、现有 UI reference、Pencil 导出图或明确设计说明。
- 目标状态：approved / selected / system-recommended accepted，并记录选择理由。
- implementation spec extraction：页面布局、导航结构、信息层级、组件清单、交互状态、响应式断点、空/错/加载状态、关键 copy、颜色 token、字体、间距。
- Admin Console 必须包含 shadcn/ui component/block mapping、Tailwind token / CSS variable mapping、tweakcn 主题依据、8px spacing 规则和非 shadcn UI 框架排除说明。
- 必要时保存 target mockup，供 Step 10A/10B 对比。

### Step 6A：frontend fidelity plan

Step 6A 是第一轮 Superpowers `writing-plans`，产出前端高保真计划。计划必须引用 Step 3 approved visual target，并把目标抽取成可执行 implementation spec。

计划内容至少包括：

- routes、页面、布局、导航、状态和主要交互。
- mock API / fixture / MSW / local data strategy。
- shadcn/ui primitives、blocks、项目已有组件、Tailwind tokens、CSS variables。
- Product Design `image-to-code` / `url-to-code` 只作为还原脚手架的使用边界。
- 截图证据路径、浏览器视口、交互路径、design QA 记录路径。
- 明确完成标准：先高保真、再整理代码，最终必须回到 shadcn/ui 和项目组件体系。

### Step 7A：frontend mock implementation

Step 7A 执行前端计划。执行优先级是先还原 approved visual target，再清理工程实现。允许用 Product Design 生成代码作为 scaffold，但完成前必须回到 shadcn/ui primitives、项目已有组件和 Tailwind token。

Step 7A 不应等待真实后端完成。它用 mock 数据覆盖目标页面、主要交互、空/错/加载状态和响应式布局。

### Step 8A / 9A / 10A / 11A：frontend gates

Step 8A 跑前端相关 verification，例如 typecheck、lint、unit test、mock e2e、build。

Step 9A 必须提前介入。没有 browser screenshot，就没有 Step 10A 的验收证据。至少覆盖关键桌面和移动视口、主路径交互、空/错/加载状态，并保存截图或报告。

Step 10A 是 Product Design 高保真硬门禁，不是“看起来不错”。必须包含：

- target visual / mockup 引用。
- browser screenshots。
- 差异列表和严重级别。
- 修复记录。
- before/after 截图或可复核说明。
- 明确 accepted deviations。

Step 11A 是 frontend/mock functional QA，确认 mock 模式下关键交互闭环。

### Step 6B-11B：backend integration loop

前端高保真通过后，再进入后端与真实数据集成轮：

- Step 6B：后端 / API / integration writing plan，引用 6A/10A 结论，保护已批准 UI。
- Step 7B：后端实现、API contract、mock 替换、错误处理和权限/数据链路。
- Step 8B：integration verification。
- Step 9B：真实链路浏览器验证。
- Step 10B：视觉回归。若 UI 未改变，可做 light visual regression；若布局、数据密度、状态或交互变化，必须跑完整 Product Design gate。
- Step 11B：真实后端下的系统化功能 QA。

Step 12-15 保持不变。

## 非目标

- 不新增正式 Step 16，也不把 Step 6-11 永久拆成新的 canonical 编号。
- 不新增独立 skill，除非后续发现 next-action 和 writing-design 承载不了。
- 不要求 Product Design、shadcn MCP 在所有环境强制安装；缺失时仍允许 fallback，但证据要求和设计基线不能放松。
- 不要求所有非 UI 后端任务走 A/B 双循环。

## 需要改动的组件

- `skills/my-harness/SKILL.md`：路由和 Current Harness Loop 增加 Frontend Fidelity First 规则。
- `skills/my-harness-next-action/SKILL.md`：分类、canonical sequence、Step 3/6/7/9/10/11 提示词增加 A/B 双循环和硬门禁证据。
- `skills/my-harness-writing-design/SKILL.md`：设计治理补强要求 approved visual target 和 implementation spec extraction。
- `skills/my-harness-writing-design/templates/DESIGN.shadcn-admin-console.md`：模板增加前端先行、mock、浏览器截图和高保真门禁。
- `skills/my-harness-writing-design/scripts/harness_write_design.py`：老项目合并 addendum 增加 Frontend Fidelity First 段。
- `AGENTS.md`、`README.md`、`CHANGELOG.md`、`docs/maintenance.md`、`docs/project-history.md`：同步用户可见规则和维护记录。

## 验收

- 文档中明确 Step 3 是 approved visual target，不只是 design direction。
- Step 6A / 7A / 9A / 10A / 6B-11B 在 router、next-action 和 README 中可见。
- Admin Console 仍然强制 shadcn/ui + tweakcn，Product Design 代码只作 scaffold。
- 老项目显式执行 `my-harness-writing-design` 时，现有 `DESIGN.md` 会合入最新 Frontend Fidelity First addendum，同时保留个性化内容。
- `./scripts/verify.sh` 通过。
- `git diff --check` 通过。
- 临时旧项目回归确认 marker 不重复、个性化内容保留、新 addendum 出现。
