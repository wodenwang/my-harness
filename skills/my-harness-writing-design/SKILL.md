---
name: my-harness-writing-design
description: Use when a project needs initial design requirements, a DESIGN.md baseline, a design directory, Product Design visual-target guidance, optional Pencil coordination, or AGENTS.md links to design governance
---

# My Harness Writing Design

## Purpose

Create the design-governance starting point for the current project before product/UI implementation begins. The selected frontend design baseline depends on product scenario: Admin Console uses shadcn/ui + tweakcn, BI dashboards use React + Ant Design Pro + ECharts, and C-end websites/apps leave framework selection to Product Design plus later engineering review. Product Design is the preferred visual-target helper when available; Pencil is optional for complex frontend modules that need explicit human alignment.

## Before Editing

1. Read project governance first: `AGENTS.md`, `CLAUDE.md`, README, and existing docs.
2. Inspect existing `design/`, `DESIGN.md`, Product Design notes, screenshots, URL captures, Figma references, optional Pencil files, and design notes.
3. Preserve existing project rules. Merge design governance; do not overwrite unrelated instructions.
4. If `DESIGN.md` already exists and the user explicitly invoked `my-harness-writing-design`, update or append the my-harness-owned latest design-governance section while preserving project-specific content, brand decisions, accepted deviations, and historical notes.
5. If the project already has `AGENTS.md` and `CLAUDE.md` as synchronized governance files, keep relevant design references synchronized.

## Tool and Dependency Declarations

This skill is explicitly allowed to use design-specific tools and skills when available. Prefer specialized tools over hand-written approximations.

Product Design dependencies:

- Product Design is not required for this skill or for `my-harness`, but it is preferred for frontend visual-target generation when installed.
- If Product Design is installed and the UI scope lacks a visual target, use Product Design `get-context` -> `ideate` -> user selection to create at least three prototype/visual directions and a selected visual target. In target/autopilot mode, a system-recommended direction may be selected automatically only when allowed and must be recorded with rationale.
- For Admin Console work, Product Design prototype/visual directions must be grounded in `DESIGN.md`'s shadcn/ui + tweakcn baseline. Each option must include shadcn component/block mapping, Tailwind token/CSS variable mapping, 8px spacing decisions, state coverage, and any accepted deviation from native shadcn/ui components.
- Product Design focused skills replace gstack `/plan-design-review` and `/design-review` for design-related gates when available; fallback to gstack only when Product Design is unavailable or project governance requires it.
- Product Design `image-to-code` / `url-to-code` belongs in implementation only after `IMPLEMENTATION_PLAN.md` exists and a selected visual target or source URL is available. It should be used to cut the selected prototype into a frontend frame before hand implementation continues.
- Product Design visual QA / `design-qa.md` must compare the rendered implementation with the selected prototype and `DESIGN.md`, record differences, and drive fixes until the result is highly faithful or deviations are explicitly accepted.
- If Product Design is unavailable, do not ask the user to install it; continue with shadcn/ui design governance, existing UI references, screenshots, or optional Pencil when needed.
- Product Design outputs must be recorded under `design/` or referenced from `DESIGN.md` / `design/design-input-<stage>.md` before they influence implementation. For UI-heavy projects, those outputs must converge into a Step 3 approved visual target with approved / selected / system-recommended accepted status, target mockup or reference, choice rationale, and implementation spec extraction.
- Implementation spec extraction must cover layout, navigation, information hierarchy, component inventory, interaction states, loading/empty/error states, responsive behavior, key copy, color tokens, typography, spacing, shadcn component/block mapping when applicable, screenshots, and accepted deviations.
- Frontend implementation, design review, and QA must strictly obey `DESIGN.md` and `design/`, including typography, spacing, technology stack, components, chart library, color tokens, responsive behavior, states, and accessibility.
- If a selected framework such as shadcn/ui, Ant Design Pro, ECharts, or another approved third-party framework conflicts with a prototype, prefer the framework's native components and `DESIGN.md`; the prototype is a visual/reference input, not authority to create a parallel component system.

Creative Production dependencies:

- During design planning and prototype design, if the target system has no clear app/product title, logo, or favicon, use Creative Production `logo-explorer` before finalizing Product Design prototypes.
- Use the existing project/product name as a provisional title when available. In target/autopilot mode, derive a conservative app title from the repo/project name if no title exists; otherwise stop and ask for a title/brand anchor when the title cannot be inferred safely.
- Save or reference selected logo direction, favicon/app-icon direction, title, rejected routes, caveats, and asset paths under `design/`.
- Creative Production logo outputs are directional identity assets unless explicitly polished later; record trademark, generated text, and production-vector caveats in `design/`.

Pencil dependencies:

- Invoke the `pencil-design` skill only when the module is complex enough to need human alignment, when the user explicitly asks for Pencil, or when an existing project governance file requires `.pen` assets.
- Use Pencil App / Pencil MCP tools for `.pen` documents when available, especially for opening, editing, validating, exporting, or inspecting existing Pencil files.
- Use the Pencil CLI when the task needs a generated `.pen` file or exported image and CLI auth is available.
- Do not treat a blank starter `.pen` as an approved prototype. It is only a placeholder until generated or reviewed through Pencil.

Product scenario and frontend framework selection:

- Hard gate: if the user invokes this skill without a clearly stated or discoverable product scenario, do not initialize files. Stop and ask the user to choose the scenario: Admin Console, BI dashboard/data cockpit, or C-end website/app.
- Admin Console / backend management / CRUD console: use `shadcn/ui + tweakcn`. This keeps the existing Admin Console logic unchanged.
- BI chart analysis / analytics dashboard / data cockpit / data big screen: use `React + Ant Design Pro + ECharts`.
- C-end website / consumer app / mobile app / public-facing product: do not lock any frontend framework in this skill. Use Product Design to clarify the brief, visual direction, interaction model, and framework-selection inputs; final framework selection belongs in `plan-eng-review`.
- Do not silently map an unclear request to Admin Console just because this skill has an Admin Console template.
- If the user explicitly requests a framework that conflicts with the scenario, stop and explain the scenario/framework mismatch before writing files.
- Ant Design Pro is supported only for BI dashboards/data cockpits in this skill. Do not recommend Ant Design Pro for normal Admin Console work.

shadcn/ui dependencies and style for Admin Console:

- Use shadcn/ui by default and for all new Admin Console design baselines.
- Existing Admin Console projects that explicitly run `my-harness-writing-design` must receive the latest shadcn/ui governance addendum in `DESIGN.md` without losing their custom business, brand, layout, or accepted-deviation decisions.
- Treat shadcn/ui as open component code plus a code-distribution workflow, not as a sealed component library.
- Preserve shadcn/ui beautiful defaults and use tweakcn as the default theme/style source for zero-to-one Admin Console work when no stronger brand direction exists.
- Use the project's existing shadcn/ui setup if present. If no setup exists, reference official shadcn/ui docs for component names, token conventions, and CLI install patterns.
- Treat shadcn MCP as an important optional implementation aid for browsing, searching, and installing shadcn registry items. Prefer it when configured, but never make it a required dependency for `my-harness`.
- If Codex does not have shadcn MCP configured, do not block the design flow. Fall back to shadcn CLI, official docs, and existing project components.
- Do not silently modify global Codex MCP configuration. If a task requires adding shadcn MCP to `~/.codex/config.toml`, get explicit user authorization first.
- When shadcn MCP or CLI is used, inspect project `components.json`, aliases, style, Tailwind config, registries, and installed components before adding new code.
- Before implementation planning, record whether the project already has `components.json`, a shadcn-compatible `src/components/ui` or equivalent directory, Tailwind configuration, aliases, and registry settings. Missing setup must become an explicit Step 6 planning task, not an implicit excuse to hand-roll UI.
- Do not combine shadcn/ui with Ant Design or another UI framework in the same design baseline unless the user explicitly asks for a migration/interop plan outside this skill's normal baseline.

React + Ant Design Pro + ECharts dependencies and style for BI dashboards:

- Use React as the application framework baseline for BI/dashboard frontends.
- Use Ant Design Pro for page shell, layout, ProComponents, forms, filters, tables, permissions, and enterprise dashboard structure.
- Use ECharts for all primary charts, trends, maps, funnels, scatter plots, composition charts, and interactive analysis views.
- Design around metrics, dimensions, filters, drilldowns, comparison, data freshness, loading/empty/error/partial-data states, and chart performance.
- Do not force BI dashboards into shadcn/ui. BI chart analysis needs Ant Design Pro's dashboard/pro components and ECharts' visualization model.
- Do not use Ant Design Pro as a generic Admin Console replacement in this harness; its supported role here is BI/data cockpit work.

Product Design framework decision for C-end products:

- Use Product Design `get-context` first when product, visual source, or interactivity is unclear.
- Use Product Design `ideate` for visual directions when no source visual exists.
- Record the selected visual target and framework-selection inputs under `design/`.
- Do not lock React, Next.js, Vue, React Native, Flutter, shadcn/ui, Ant Design Pro, or any other framework during this skill unless the user or existing project governance already requires one.
- The final C-end frontend framework choice must be reviewed in `plan-eng-review` using Product Design output, target platform, SEO/content needs, animation complexity, performance constraints, and existing codebase conventions.

shadcn/ui implementation constraints:

- Prioritize shadcn/ui components, existing project components, and existing shadcn code blocks.
- Use Tailwind CSS, CSS variables, and project design tokens; do not introduce another UI framework.
- Product Design `image-to-code` / `url-to-code` output is only a scaffold for Admin Console work. Before completion, generated pages must be refit to shadcn/ui primitives, project components, Tailwind tokens, and the selected theme; do not accept generic React/Tailwind code or non-shadcn UI framework code as final implementation.
- Follow an 8px spacing system by default.
- Do not use random colors. Colors must come from project tokens, tweakcn/shadcn theme decisions, or documented brand decisions.
- Do not use gradients, glassmorphism, large decorative backgrounds, or heavy visual effects unless business or brand requirements explicitly justify them.
- Do not create custom base components casually. Create project-level composed components only when existing components cannot express the business semantics, meaningful duplication is removed, or complex interaction is stabilized.
- Custom components must compose shadcn/ui primitives, Tailwind tokens, and existing project component conventions.

Button design rules:

- List pages may use icon-only buttons for table row actions, toolbar utilities, dense action columns, or similarly compact layouts.
- Any page area with genuinely narrow space may use icon-only buttons, but each icon-only button must have an accessible label and a tooltip when the icon is not universally obvious.
- In all other cases, buttons must use icon + text.
- Button text must not wrap. If a button would need wrapping, treat the area as space-constrained and switch to an icon-only button or redesign the surrounding layout.

Theme and brand inference:

- If the user names a theme color, provides a website, uploads a logo, shares screenshots, or links brand material, analyze that material before finalizing the design baseline.
- Extract dominant colors, accent colors, neutral/background direction, saturation, contrast, typography mood, density, and any obvious industry/brand tone.
- For shadcn/ui, map the result to a tweakcn-compatible theme decision: use an appropriate preset family when it fits, or define a custom CSS-variable token set when no preset is a good match.
- If the material is visually noisy or unsuitable for backend work, keep the admin console conservative and use only the strongest safe brand accent.
- Always record the theme source and decision in `DESIGN.md` or `design/design-input-<stage>.md`.

Recommended order:

1. Read project governance and existing design assets.
2. Resolve product scenario before writing files. If unclear, ask the user and stop.
3. Select frontend baseline from scenario: Admin Console -> shadcn/ui + tweakcn; BI dashboard -> React + Ant Design Pro + ECharts; C-end -> Product Design decides.
4. If Product Design is available and the UI scope lacks a visual target, use Product Design `get-context` -> `ideate` -> at least three options -> user selection; otherwise continue with existing references.
5. If title/logo/favicon is missing, use Creative Production `logo-explorer` or record why it is deferred.
6. Check Pencil availability (`pencil-design` skill, Pencil MCP, or Pencil CLI) only if `.pen` assets are needed for complex alignment.
7. Check selected-framework availability and docs before writing component mappings.
8. Inspect theme/color/material inputs if provided, including websites, logos, screenshots, or explicit color names.
9. Create or update `DESIGN.md`, `design/`, design input notes, optional Pencil assets, and governance links.
10. For existing `DESIGN.md`, add or refresh the my-harness latest design-governance section and leave project-specific sections intact.

## Required Outputs

In the target project root:

- `design/` directory exists.
- `DESIGN.md` exists and describes project-level UI/UX requirements.
- `AGENTS.md` links to `DESIGN.md` and tells agents to inspect `design/` before frontend work.
- `DESIGN.md` explicitly governs typography, spacing, technology stack, component rules, chart rules, colors, responsive behavior, states, accessibility, Product Design prototype options, implementation slicing, and visual QA.
- Existing `DESIGN.md` files keep user/project-specific content and include or refresh a my-harness latest design-governance addendum.

Recommended optional output:

- `design/design-input-<stage>.md` describing the current project phase, visual target, component mapping, and prototype scope.
- Product Design selected visual targets, at least three prototype/visual options, screenshots, links, or `design-qa.md` references under `design/` when Product Design was used.
- Creative Production logo/favicon/title notes or assets under `design/` when the system lacked title, logo, or favicon.
- Pencil `.pen` files and exported screenshots only when complex alignment requires them.

## Naming Rule

Infer names from existing project style first:

1. If `design/` already has files like `<project>-v0.1.0-*.pen`, follow that pattern.
2. Otherwise use `<project-slug>-<stage-slug>-design-baseline.pen`.
3. Infer stage from explicit user instruction, branch name, version files, or existing docs. If unknown, use `v0.1.0`.

Examples:

- `feishu-iam-v0.1.0-admin-console.pen`
- `bpmt-lite-v1.8.0-oauth-console.pen`
- `inventory-admin-v0.1.0-design-baseline.pen`

## Fast Path

From the project root, run:

```bash
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py
```

Windows PowerShell:

```powershell
python "$HOME\.codex\skills\my-harness-writing-design\scripts\harness_write_design.py"
```

Useful options:

```bash
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --stage v0.1.0 --phase admin-console
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --project-name feishu-iam --stage v0.1.0 --phase admin-console
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --product-scenario admin-console --stage v0.1.0 --phase admin-console
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --product-scenario bi-dashboard --stage v0.1.0 --phase data-cockpit
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --product-scenario consumer --stage v0.1.0 --phase mobile-app
```

The script is conservative: it creates missing files, refreshes my-harness-owned marked governance sections in existing `DESIGN.md` / `AGENTS.md`, and preserves project-specific content outside those marked sections. It does not overwrite `.pen` files.

## DESIGN.md Baseline

Use one of the scenario templates:

- `templates/DESIGN.shadcn-admin-console.md` for Admin Console / backend management.
- `templates/DESIGN.ant-design-pro-echarts-bi-dashboard.md` for BI dashboard / data cockpit.
- `templates/DESIGN.product-design-consumer.md` for C-end websites/apps where Product Design decides framework direction.

Adapt these fields before finalizing:

- project name
- product type
- target users
- current phase/version
- required pages
- role/permission examples
- technology stack if already chosen

Keep the selected scenario's core principles unless the user or existing project governance clearly says otherwise.

shadcn/ui selected principles:

- open-code component ownership
- tweakcn as the default shadcn theme/style reference for zero-to-one Admin Console projects
- composition-first UI built from shadcn/ui primitives and project-level wrappers
- Tailwind CSS variables and semantic tokens
- optional shadcn MCP for registry browsing, component search, and installation when configured
- clean minimal beautiful defaults instead of heavy enterprise chrome
- standard Admin Console shell: `AppShell`, `Sidebar`, `TopBar`, `PageHeader`, `FilterBar`, `DataTable`, `Dialog`, `Sheet`, and detail pages
- table-first CRUD with stable status/time/action columns, long text and long ID handling, responsive fallback, and no complex forms inside list cells
- Dialog / Sheet / detail-page selection by interaction complexity; narrow Sheets must not carry heavy workflows such as multi-tab, tree selection, batch binding, or complex permission editing
- button rules: icon-only only for list pages or narrow compact spaces; icon-only buttons need accessible labels and tooltip/title; otherwise use icon + text; no wrapped button labels
- explicit accessibility, focus, keyboard, loading/empty/error/forbidden/success/disabled/pending/readonly states
- design review checks for backend density, stable columns, no button wrapping, no heavy Sheet misuse, no layout overflow, clean console, and no unexpected Network failures
- Product Design visual target as preferred implementation input when available
- Product Design must provide at least three prototype/visual options when no visual target exists
- Product Design output must converge into an approved visual target, not just design directions; record approved / selected / system-recommended accepted status, target mockup/reference, choice rationale, and implementation spec extraction under `design/`
- Product Design Admin Console options must document shadcn component/block mapping, Tailwind token/CSS variable usage, 8px spacing, state coverage, and deviations from native shadcn/ui components
- Creative Production `logo-explorer` should create logo/favicon/title direction when the system lacks brand assets
- frontend implementation should use Product Design `image-to-code` / `url-to-code` to cut the selected prototype into a framework before hand development when applicable
- Product Design generated code for Admin Console must be adapted to shadcn/ui primitives and project Tailwind tokens before completion
- Frontend Fidelity First: UI-heavy projects should run Step 6A frontend fidelity plan, Step 7A mock implementation, Step 9A browser screenshots, Step 10A hard Product Design fidelity gate, and only then Step 6B-11B backend integration / visual regression
- selected third-party framework components take precedence over prototype mismatches
- optional Pencil prototype only for complex modules or human alignment
- Playwright visual QA across desktop/tablet/mobile before claiming frontend completion

BI dashboard selected principles:

- React + Ant Design Pro + ECharts
- metric-first information hierarchy
- Ant Design Pro for layout, ProComponents, forms, filters, tables, permissions, and shell
- ECharts for all core visualizations
- explicit metric definitions, dimensions, time ranges, drilldowns, comparison, loading/empty/error/partial-data states, and performance constraints

C-end selected principles:

- no frontend framework lock inside `writing-design`
- Product Design brief and selected visual target are the design source of truth
- framework-selection inputs are recorded for `plan-eng-review`
- mobile and responsive behavior are first-class

## AGENTS.md Link

Add or merge a short section like:

```markdown
## 设计规范

- 项目级 UI/UX 规则见 `DESIGN.md`。
- 设计制品、视觉目标、截图和设计说明统一放在 `design/`。
- 如果项目还没有 `DESIGN.md`，任何 UI / 前端 / 图表 / App 工作开始前都必须先用 `my-harness-writing-design` 创建。
- 如果显式执行 `my-harness-writing-design` 且项目已有 `DESIGN.md`，必须保守合并 my-harness 最新设计治理补强，保留项目个性化内容，不覆盖业务、品牌或历史设计决策。
- 所有设计、前端规划、实现和 design review 必须严格遵守 `DESIGN.md`，包括字体、间距、技术栈、组件体系、图表库、颜色 token、响应式、状态设计和可访问性。
- Admin Console 的 Product Design 原型和视觉目标必须提供 shadcn/ui 证据：组件 / blocks mapping、Tailwind token / CSS variables 映射、tweakcn 主题依据、8px spacing、状态覆盖，以及非 shadcn UI 框架未被引入的说明。
- 如果使用 Product Design 生成视觉目标，默认至少提供三套原型/视觉方案供选择；目标模式下可选择系统推荐方案，但必须记录推荐理由。对应图片、链接或说明也必须记录到 `design/`。
- 进入设计规划和原型图设计时，如果系统没有明确标题、logo 或 favicon，必须先使用 Creative Production plugin 的 `logo-explorer` 构建 logo / favicon / app icon 方向；已有项目名时可作为临时标题，目标模式下可从 repo/project name 推导保守标题。选中方向、拒绝方案、标题和资产路径记录到 `design/`。
- 做前端开发时，如已有 Product Design 选中原型或视觉目标，先使用 `image-to-code` / `url-to-code` 做原型切割形成前端框架，再按项目代码和组件体系开发；Admin Console 必须把生成骨架改造成 shadcn/ui primitives、项目已有组件和 Tailwind tokens，不得直接提交泛 React/Tailwind 或其他 UI 框架代码。
- UI 密集项目采用前端高保真先行：Step 6A 前端计划引用 Step 3 approved visual target 并抽取 implementation spec；Step 7A 用 mock 先还原布局和交互；Step 9A 先产出浏览器截图；Step 10A 必须记录 target、截图、差异、修复、before/after 和 accepted deviations；Step 6B-11B 再接入后端并做视觉回归。
- 进入 `executing-plans` 或 `subagent-driven-development` 后，Codex 和所有 subagent 必须持续遵守 `AGENTS.md`、`CLAUDE.md`、README、`DESIGN.md`、`DEPLOY.md`、`IMPLEMENTATION_PLAN.md` 和相关 docs/runbooks；subagent brief 必须写明治理约束、允许改动边界和偏差回报要求。
- design review 阶段要严格比对成品和原型图之间的差异，持续修复直到高度还原或偏差被明确接受；`design-qa.md` 记录差异、修复和接受项。
- 若选定 shadcn/ui、Ant Design Pro、ECharts 或其他第三方框架，且原型与已有组件不一致，以前端框架组件和 `DESIGN.md` 为准，原型仅作参考。
- 未安装 Product Design 时使用当前场景的设计基线、已有 UI 参考、截图或必要时 Pencil 协同制品继续推进。
```

If `CLAUDE.md` mirrors `AGENTS.md`, apply the same change there and verify both files remain aligned.

## Optional Pencil Assets

Do not create Pencil assets by default. Prefer Product Design visual targets, screenshots, existing UI references, or `design/design-input-<stage>.md` for normal shadcn/ui frontend work.

Use Pencil only when the module is complex enough to need human alignment, when the user explicitly asks for it, or when project governance requires `.pen` files. When Pencil tooling is unavailable but required, say so clearly in the final result and mark the missing Pencil artifact as follow-up.

## Completion Check

Before reporting done:

- `test -d design`
- `test -f DESIGN.md`
- `rg -n "DESIGN.md|design/" AGENTS.md`
- `rg -n "MY_HARNESS_DESIGN_GOVERNANCE|my-harness 最新设计治理补强" DESIGN.md`
- Record which product scenario was selected and why.
- Record which UI framework baseline was selected and why, or record that Product Design will decide the C-end framework later.
- For Admin Console, record that shadcn/ui was selected and tweakcn was used as the layout/style reference.
- For BI dashboard, record that React + Ant Design Pro + ECharts was selected.
- For C-end, record that no framework was locked and Product Design output will feed `plan-eng-review`.
- Record whether shadcn MCP was available, used, unavailable, or intentionally skipped; if used, record the registry/components/blocks involved.
- Record theme/material source and inferred theme decision when the user provides colors, logo, website, screenshots, or brand material.
- Record whether Creative Production logo/favicon/title exploration was needed, used, unavailable, deferred, or intentionally skipped; if used, record selected route and asset paths.
- Record whether Product Design was used, unavailable, or intentionally skipped; if used, record where the selected visual target or `design-qa.md` evidence lives.
- For UI-heavy projects, record whether Step 3 produced an approved visual target and whether the implementation spec extraction covers layout, components, states, responsive behavior, token mapping, shadcn mapping, screenshots, and accepted deviations.
- For UI-heavy projects, record whether Step 6A/7A/9A/10A/11A frontend fidelity loop and Step 6B-11B backend integration loop are required, deferred, or intentionally skipped with a reason.
- Record whether Pencil tooling was needed, unavailable, skipped, or used; if used, record where `.pen` and exported screenshots live.
- If `CLAUDE.md` exists and is expected to mirror `AGENTS.md`, verify the design section is present there too.

## Common Mistakes

- Creating `DESIGN.md` but forgetting to link it from `AGENTS.md`.
- Overwriting existing governance files instead of merging.
- Treating an existing `DESIGN.md` as automatically up to date. Explicit `my-harness-writing-design` runs must merge the latest my-harness governance addendum while preserving custom project content.
- Treating a normal shadcn/ui screen as requiring Pencil when Product Design, screenshots, existing UI references, or design notes would be enough.
- Treating Product Design as mandatory or requiring the user to install it before continuing.
- Using Product Design outputs without recording them in `design/`.
- Accepting Product Design Admin Console outputs without shadcn component/block mapping, Tailwind token mapping, 8px spacing decisions, and explicit non-shadcn UI framework absence.
- Accepting Product Design output as only a loose design direction instead of an approved visual target with implementation spec extraction.
- Starting backend integration before the frontend/mock UI has passed Step 9A screenshots and Step 10A Product Design fidelity gate for UI-heavy projects.
- Treating Step 10A as a subjective visual review instead of a hard gate with target mockup, screenshots, diff list, fixes, before/after evidence, and accepted deviations.
- Treating a Product Design visual or `design-qa.md` file as a replacement for `DESIGN.md`, functional QA, or code review.
- Hand-editing or guessing around Pencil when Pencil-specific tools are available.
- Treating shadcn MCP as mandatory or blocking the workflow when it is unavailable.
- Silently editing `~/.codex/config.toml` to add shadcn MCP without explicit user authorization.
- Installing registry components through shadcn MCP or CLI without inspecting generated code, dependencies, tokens, and accessibility.
- Treating shadcn MCP as optional in a way that makes shadcn/ui optional for Admin Console. MCP is optional; the Admin Console shadcn/ui baseline is not.
- Accepting unsupported UI framework preferences instead of refusing them.
- Defaulting to Admin Console when the user did not clearly state the product scenario.
- Using Ant Design Pro for Admin Console work; Ant Design Pro is supported here only for BI/data cockpit scenarios.
- Locking a framework for C-end websites/apps before Product Design and `plan-eng-review`.
- Allowing button labels to wrap instead of treating the space as compact and changing the control pattern.
- Letting table action buttons resize rows, wrap, or lose a stable operation-column width.
- Putting long URLs, JSON, permission lists, errors, or IDs directly into tables without truncation, tooltip, copy, or detail placement.
- Using a narrow Sheet for heavy configuration, multi-tab editing, tree selection, batch binding, or complex permission workflows.
- Treating a page as complete without checking 390px mobile, console errors, unexpected Network failures, and responsive overflow.
- Writing component mappings without checking project dependencies, existing code, or selected-framework references.
- Mixing Ant Design Pro and shadcn/ui in a single baseline without explicit migration/interop scope.
- Ignoring user-provided theme colors, websites, logos, screenshots, or brand assets.
- Entering prototype design with no title/logo/favicon and no Creative Production logo/favicon/title exploration or explicit deferral.
- Letting executing-plans or subagents drift from `AGENTS.md`, `DESIGN.md`, `IMPLEMENTATION_PLAN.md`, or other governance docs.
- Copying a brand website's marketing layout into an Admin Console instead of extracting safe color/token direction.
- Starting frontend implementation before design requirements and prototype scope are written.
- Copying `feishu-iam` domain rules, such as Feishu-only auth, into unrelated projects. Reuse its UI/UX baseline, not its product-specific identity rules.
