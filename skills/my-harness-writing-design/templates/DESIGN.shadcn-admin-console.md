# {{PROJECT_NAME}} shadcn/ui 设计系统基线

本文档是 `{{PROJECT_NAME}}` 的视觉与交互设计基线，供 Pencil 原型、前端实现和后续设计评审使用。

规则来源优先级：

1. 用户在当前对话中的明确指令
2. 已确认的 Pencil 原型
3. `AGENTS.md` / `CLAUDE.md`
4. `docs/` 下的项目文档
5. 现有实现代码
6. shadcn/ui 官方文档
7. 通用前端最佳实践

本文件只描述 UI/UX 与设计系统规则。领域、安全、后端、Agent 行为等规则仍以 `AGENTS.md` 为准。

UI 框架选择：

- 当前模板：shadcn/ui。
- 使用条件：只有用户明确倾向 shadcn 或 shadcn/ui 时才选择本模板。
- 默认规则：用户没有明确 UI 框架倾向时，不使用本模板，改用 Ant Design 默认模板。
- 从零到一规则：如果用户明确选择 shadcn/ui，但没有明确后台主题倾向，默认采用 tweakcn 作为主题框架、整体视觉和后台 layout 风格参考。
- 拒绝规则：本 harness 目前只支持 Ant Design 与 shadcn/ui。如果用户要求 Material UI、Chakra UI、Arco Design、Element Plus、Bootstrap、Tailwind UI、Radix-only 或自定义大型 Design System，应拒绝并要求用户在 Ant Design 与 shadcn/ui 中二选一。
- 混用规则：不要把 Ant Design 和 shadcn/ui 混在同一套设计基线中，除非当前任务明确是迁移或过渡方案。

官方参考：

- shadcn/ui Introduction：https://ui.shadcn.com/docs
- shadcn/ui Theming：https://ui.shadcn.com/docs/theming
- shadcn/ui Data Table：https://ui.shadcn.com/docs/components/data-table
- shadcn/ui Card：https://ui.shadcn.com/docs/components/card
- tweakcn：https://tweakcn.com/

## 1. 产品类型

`{{PROJECT_NAME}}` 默认按企业级 Admin Console / 后台管理系统进行设计，除非用户或项目文档明确说明不是后台系统。

目标用户：

- 业务管理员
- 平台管理员
- 运维人员
- 需要高频处理数据、配置、权限和状态的内部用户

设计目标：

- 干净、克制、可组合
- 明确的组件 ownership
- 可访问性优先
- 表格、表单、筛选、详情和操作状态完整
- 适合现代 React / Next.js / Tailwind 项目
- 可维护性优先于视觉创意

本项目默认不是：

- 营销官网
- 落地页
- 消费者产品
- Dribbble 风格概念稿
- 大量装饰卡片堆叠的 Dashboard

## 2. shadcn/ui 风格解析

shadcn/ui 的核心不是传统 NPM 组件库，而是一套可复制进项目、由项目直接拥有的组件代码和分发方式。它的设计倾向是 open code、composition、beautiful defaults 和 AI-ready：组件默认好看、可访问、彼此统一，但最终代码在项目内，可以被团队直接调整。

### 官方原则到落地规则

| 原则 | 本项目落地要求 |
|---|---|
| Open Code | 组件代码进入项目后由项目维护；不要把 shadcn/ui 当黑盒库使用。 |
| Composition | 页面由小型可组合 primitives 和项目级 wrapper 组成，避免巨型万能组件。 |
| Distribution | 使用 shadcn CLI / registry 思路增量引入需要的组件，不一次性复制无关组件。 |
| Beautiful Defaults | 默认保持干净、极简、可访问、低装饰的视觉效果，不过早自定义主题。 |
| AI-Ready | 组件 API、目录和命名保持一致，便于 Agent 读取、复用和修改。 |

### 默认视觉倾向

- 使用 neutral base color 与语义 token，保持黑白灰为主、少量 primary/action 强调。
- 使用 `background` / `foreground`、`card` / `card-foreground`、`primary` / `primary-foreground` 等成对语义 token。
- 使用 CSS variables 作为主题事实源；不要在页面中散落硬编码颜色。
- 圆角、边框、focus ring、input、popover、sidebar 等都通过 token 控制。
- 页面气质应干净、安静、现代，避免 heavy enterprise chrome。
- 不使用大面积渐变、玻璃拟态、过度阴影、装饰图标圆圈或 hero 式排版。
- 卡片只用于真实需要分组的 panel、表单、设置块、统计块或 item，不把整页 section 套进层层卡片。

### tweakcn 后台主题倾向

shadcn/ui 项目的后台视觉主题从零到一时默认采用 tweakcn 的主题编辑、预设和后台预览倾向，但不要把主题选择变成随意换皮。

可参考的方向：

- 主题以 shadcn/ui token 和 Tailwind CSS variables 为事实源，优先调整 `:root` / `.dark` 变量，而不是在页面组件里写零散颜色。
- 允许在明确品牌需求下使用 tweakcn 风格的预设作为起点，例如 modern minimal、amethyst haze、catppuccin、claude、caffeine 等，但必须先检查对比度、状态色和后台可读性。
- 主题应覆盖 background、foreground、card、popover、primary、secondary、muted、accent、destructive、border、input、ring、chart 和 sidebar token。
- 主题调整必须同时检查 light / dark、sidebar、table、form、dialog、popover、chart 和 empty/error/loading states。
- 对后台管理系统，默认选择克制、专业、长时间可读的主题；避免 cyberpunk、neo brutalism、过强高饱和或高阴影主题作为默认后台风格。
- 使用实时预览和代码导出思路固化主题：最终落地应是可复制、可审查的 CSS variables / Tailwind theme 变更，而不是只保留截图。

默认后台布局：

- 使用 shadcn/tweakcn 风格的 `AppShell`：左侧 `Sidebar`、顶部 `TopBar`、内容区 `PageHeader` + 主体面板。
- Sidebar、card、table、form、dialog、popover、chart 和 empty/error/loading states 必须共用同一套 CSS variables。
- 页面结构保持清爽：标题区、筛选/工具区、DataTable 或 FormPanel、Sheet/Dialog/DetailPanel。
- 默认主题从 modern minimal 方向开始：中性色底、清晰边框、适度圆角、稳定 focus ring、少量 primary/accent。
- 如果项目品牌需要更强性格，可以从 tweakcn 预设中选择接近的方向，但必须保留后台可读性。

### 主题素材解析规则

如果用户提供主题色、官网、logo、截图或品牌素材，必须先解析再选择 tweakcn 主题模板，不要直接照搬营销页视觉。

解析步骤：

1. 提取主色、辅助色、中性色、背景色、危险/成功/警告色倾向。
2. 判断品牌气质：稳重、科技、医疗、金融、教育、消费、开发者工具等。
3. 检查色彩是否适合后台长时间使用：对比度、饱和度、light/dark 可读性、状态色冲突。
4. 映射到 shadcn/tweakcn token：background、foreground、card、popover、primary、secondary、muted、accent、destructive、border、input、ring、chart 和 sidebar。
5. 如果素材来自官网或营销页，只提取安全的品牌 token，不复制 hero、渐变、大图、装饰图形或营销式排版。

默认决策：

- 没有素材：使用 tweakcn 的 modern minimal / neutral admin 方向。
- 只有明确主题色：选择接近该色相的 tweakcn 预设或生成 custom token set，并校正对比度。
- 有 logo：从 logo 提取主色和强调色；如果 logo 色过亮或过饱和，用作 accent，不直接作为大面积背景。
- 有官网：提取品牌色、字体气质和图形语言，但后台仍保持 tweakcn/shadcn 的信息架构和组件组合。
- 没有合适预设：使用 tweakcn-compatible custom CSS variables，不强行套不匹配的 preset。

## 3. 设计原则

### 组合优先

shadcn/ui 页面应由 primitives、可复用 project components 和业务页面组合而成。

优先结构：

```text
PageShell
  |
  v
PageHeader
  |
  v
FilterBar / Toolbar
  |
  v
DataTable / DetailPanel / FormPanel
```

默认避免：

- 每页直接堆大量 Tailwind class 且无项目级抽象
- 复制多个相似但不一致的 card/table/form 实现
- 只为视觉差异创建一套并行组件体系
- 把业务逻辑塞进低层 UI primitives

### 表格仍是后台核心

后台列表页仍以数据表格为核心，但 shadcn/ui 的 Data Table 应按可组合方式实现。

适用页面：

- 资源管理
- 用户与组织
- 角色与权限
- 订单、任务、记录、审计日志
- 配置列表

表格能力通常由 `Table` primitives、TanStack Table、项目级 `DataTable` wrapper、列定义、筛选控件和分页控件组合完成。

### 操作路径清晰

后台用户每天重复使用系统。页面应该让用户快速完成任务，而不是欣赏视觉效果。

优先级：

1. 快速扫读
2. 操作清晰
3. 布局可预测
4. 数据状态可靠
5. 表单高效
6. 权限明确
7. 错误可恢复
8. 组件组合一致

### 状态完整

每个主要页面都必须考虑：

- 正常数据状态
- Empty state
- Loading state / Skeleton state
- API error state
- No permission state
- Form validation error state
- Delete confirmation state
- Batch operation confirmation state
- Search no results state
- Disabled operation state

不要只设计 happy path。

## 4. 组件体系

UI 组件体系使用 shadcn/ui。

推荐技术栈：

- React 或 Next.js
- TypeScript
- Tailwind CSS
- shadcn/ui
- Radix-backed shadcn components
- lucide-react icons
- TanStack Query
- TanStack Table
- React Hook Form 或 TanStack Form
- Zod 或项目已有 schema validator
- Playwright

不要混用其他 UI 框架：

- Ant Design
- Material UI
- Chakra UI
- Arco Design
- Element Plus
- Bootstrap
- 自定义大型 Design System

## 5. shadcn/ui 组件映射

| UI 模式 | shadcn/ui / 推荐组合 |
|---|---|
| 应用整体布局 | project `AppShell` + `Sidebar` + CSS grid/flex |
| 左侧导航 | `Sidebar` + `NavigationMenu` 或 project nav item |
| 顶部栏 | project `TopBar` + `Button` + `DropdownMenu` |
| 面包屑 | `Breadcrumb` |
| 页面标题区 | project `PageHeader` |
| 指标卡片 | `Card` + project metric component |
| 数据表格 | `Table` + TanStack Table + project `DataTable` |
| 查询筛选区 | `Input` + `Select` + `DatePicker` + `Button` |
| 新增 / 编辑面板 | `Sheet` 或 `Dialog` + form components |
| 确认操作 | `AlertDialog` |
| 状态展示 | `Badge` |
| 详情展示 | `Card` / `Item` / project definition list |
| Tab 页面 | `Tabs` |
| 分步流程 | project stepper，必要时自定义 |
| 上传 | project upload component 或框架生态组件 |
| 权限选择 | `Checkbox` + `ScrollArea` + project tree/list |
| 命令式搜索 | `Command` |
| 通知反馈 | `Sonner` / `Toast` |
| 空状态 | `Empty` 或 project `EmptyState` |
| 加载状态 | `Skeleton` / `Spinner` |
| Tooltip | `Tooltip` |
| 下拉菜单 | `DropdownMenu` |

如果 shadcn/ui 已有合适组件，不优先编写大量自定义 primitives；如果缺少企业组件，应在项目级 wrapper 中组合实现。

## 6. 标准列表页结构

所有 CRUD 列表页默认使用以下结构：

```text
PageHeader
  |
  v
FilterBar
  |
  v
Toolbar
  |
  v
DataTable
  |
  v
Pagination / selected row summary
```

### PageHeader

包含：

- 页面标题
- 简短说明
- Breadcrumb
- 必要时显示主操作按钮

标题应说明当前区域是什么，不使用营销文案。

### FilterBar

默认展示 3-4 个核心筛选项。

常用字段：

- Keyword `Input`
- Status `Select`
- Type `Select`
- Date range picker
- Search `Button`
- Reset `Button`
- Advanced filters `Collapsible`

筛选项过多时，次要条件放入 `Collapsible` 或 `Popover`，不要把首屏挤满。

### Toolbar

常用操作：

- Primary create `Button`
- Batch actions `DropdownMenu`
- Export / import actions
- Refresh icon button
- Column visibility menu

危险操作必须使用 `AlertDialog` 二次确认。

### DataTable

默认能力：

- typed columns
- pagination
- sorting
- filtering
- row selection
- selected row summary
- column visibility
- fixed or clearly grouped action column
- loading / skeleton state
- empty state
- error state

默认避免：

- 深层嵌套表格
- 表格单元格中嵌入复杂表单
- 大量自定义 row rendering
- drag sorting + virtual scroll + sticky columns 的复杂组合
- 非标准 row actions

## 7. 新增 / 编辑 / 详情交互

Admin Console 默认交互模式：

| 场景 | 推荐模式 |
|---|---|
| 简单新增 | `Sheet + form` |
| 简单编辑 | `Sheet + form` |
| 详情查看 | `Sheet` 或 detail page |
| 删除 | `AlertDialog` |
| 启用 / 禁用 | `AlertDialog` 或 inline confirm |
| 批量操作 | `AlertDialog` confirmation |
| 多字段复杂表单 | Full page form |
| 多步骤流程 | Full page stepper |
| 复杂配置 | Full page 或 `Tabs` |

简单新增和编辑通常打开右侧 `Sheet`。字段很多、包含多个分组、流程包含多个步骤或用户需要专注处理复杂任务时，优先使用 full page form。

## 8. 表单规范

业务表单优先使用 shadcn/ui form primitives 加 React Hook Form / TanStack Form / Zod 组合。

规则：

- 表单字段必须有清晰 `Label`。
- 必填字段必须明确标识。
- 错误信息靠近对应字段。
- helper text 使用 `muted-foreground`，不要和错误信息混淆。
- Submit buttons 位置保持一致。
- 提交过程中必须有 loading state。
- 防止重复提交。
- 成功和失败必须有反馈。
- 不要把 validation logic 分散写在多个组件内部。

TypeScript 项目中必须清晰定义 request types、response types、form values 和 validation schema。

## 9. 视觉密度

默认使用现代后台的中等信息密度：比传统 Ant Design 后台更轻，但不能低密度到影响工作效率。

推荐值：

- Page padding：24px
- Panel gap：16px 或 24px
- Data table row height：约 40-48px
- Normal content font size：14px
- Card radius：使用 `--radius` 派生值，不在单页硬编码
- Icon button：尺寸稳定，hover/focus 不改变布局

避免大面积留白、大型营销式标题、装饰性分区和层层嵌套卡片。

## 10. Theme Token

使用 shadcn/ui + Tailwind CSS variables。

默认 token 方向：

| Token | 方向 |
|---|---|
| `background` / `foreground` | 页面背景与默认文字 |
| `card` / `card-foreground` | 卡片、panel、设置块 |
| `popover` / `popover-foreground` | Popover、DropdownMenu、ContextMenu |
| `primary` / `primary-foreground` | 高强调操作、选中态、active accent |
| `secondary` / `secondary-foreground` | 次级操作和辅助 surface |
| `muted` / `muted-foreground` | 说明、placeholder、空状态、弱文本 |
| `accent` / `accent-foreground` | hover、focus、selected item |
| `destructive` | 危险操作、错误强调 |
| `border` | 默认边框、分隔线 |
| `input` | 表单控件边框和输入 surface |
| `ring` | focus ring |
| `chart-1` ... `chart-5` | 图表色板 |
| `sidebar` 系列 | Sidebar surface、text、active、border、focus |
| `radius` | 全局圆角比例 |

不要在页面中随意硬编码颜色。如果需要自定义颜色，必须集中定义在 global CSS token 和 Tailwind theme 暴露层。

## 11. 权限与 RBAC UI

页面实现必须考虑：

- Menu visibility
- Route access
- Button-level permissions
- Field-level read-only logic
- Operation confirmation
- Audit logging needs

权限判断不要硬编码分散在组件中。

优先使用：

- permission helpers
- permission hooks
- route metadata
- centralized guards

## 12. 项目级组件

构建大量页面前，应先创建或复用项目级组件。

推荐抽象：

- `AppShell`
- `PageHeader`
- `FilterBar`
- `DataTable`
- `DataTableToolbar`
- `FormSheet`
- `StatusBadge`
- `ConfirmAction`
- `PermissionGuard`
- `EmptyState`
- `ErrorState`

规则：

1. 不要在每个页面重复实现 table / filter / form 模式。
2. 不要让每个页面直接堆 shadcn/ui primitives 和 Tailwind class。
3. 重复模式必须封装为项目级组件。
4. 业务页面应只关注业务字段和业务动作。

## 13. 推荐前端目录结构

```text
src/
  app/
  components/
    ui/
    app-shell/
    page-header/
    data-table/
    form-sheet/
    status-badge/
    confirm-action/
    permission-guard/
    empty-state/
    error-state/
  features/
  services/
  hooks/
  types/
  utils/
  router/
  mocks/
```

如果项目后续形成成熟结构，遵守现有结构。不要无明确理由重构目录。

## 14. API 与数据请求 UI 规则

Server state 统一使用 TanStack Query 管理。

推荐模式：

```text
services/applications.ts
hooks/useApplications.ts
features/applications/ApplicationsPage.tsx
```

列表页必须支持：

- pagination
- filters
- sorting
- loading state
- error state
- mutation 后 refresh

不要在 UI 组件中到处分散写 fetch calls。

## 15. Mock Data

如果后端 API 未准备好：

- 使用 mock services。
- mock data 必须放在 UI 组件外部。
- 不要在 page JSX 中硬编码大量数据。
- mock data shape 应尽量接近预期 backend DTO。
- mock-only code 必须有清晰标记。

## 16. 响应式规范

至少考虑：

- 1440px desktop
- 1280px laptop
- 768px tablet

若页面会被手机访问，还需考虑 375px mobile。

规则：

- Desktop：Sidebar 固定，表格信息完整展示。
- Laptop：保留 Sidebar，次要筛选项收起。
- Tablet：Sidebar 可折叠，表格保留关键列，详情进入 Sheet。
- Mobile：表单单列，触控目标不小于 44px，表格改为关键列或紧凑列表。

页面不得出现无意义水平滚动。

## 17. 可访问性

必须考虑：

- 所有交互控件支持键盘访问。
- `focus-visible` / `ring` 清晰可见。
- 不使用 `outline: none` 且无替代焦点样式。
- 状态不只靠颜色表达，必须有文字或图标。
- 表单错误靠近对应字段。
- Dialog / Sheet 打开后焦点进入容器，关闭后返回触发按钮。
- 危险操作有确认。
- 触控目标不小于 44px。
- 对比度满足 WCAG AA，正文 4.5:1，大字和 UI 组件 3:1。

## 18. 禁止或不推荐模式

除非业务明确要求，避免：

- 异形卡片
- 大量渐变背景
- 玻璃拟态
- 过度装饰性的 Dashboard
- 非标准悬浮操作按钮
- 高度定制化表格行
- 复杂动画
- 非常规导航模型
- 不必要的自定义 CSS 覆盖
- 影响后台操作效率的大面积留白
- Purple / violet / indigo 渐变
- 三列 feature grid
- 装饰性图标圆圈
- 大 hero
- 营销式 slogan
- 为了“shadcn 风格”把所有内容都放进 card

## 19. Pencil 原型要求

Pencil 原型、截图和设计说明统一放在项目根目录 `design/`。

开始实现前端页面前必须：

1. 检查 `design/` 是否存在 Pencil 原型、截图或设计说明。
2. 遵守已确认的 Pencil 页面布局、组件结构、信息密度和交互方式。
3. 不在实现阶段自由重设计 UI。
4. 如果 Pencil 设计与 shadcn/ui 实现边界冲突，说明冲突点，并选择最接近 shadcn/ui composition 的可维护实现方式。
5. 原型未确认前，不直接开始前端页面开发，除非用户明确要求。

每个 Pencil 页面必须包含：

- 页面名称
- 页面用途
- shadcn/ui component composition
- Data table columns
- Filter fields
- Toolbar actions
- Row actions
- Sheet / Dialog interactions
- Form fields
- Permission rules
- Loading / Empty / Error states
- Implementation notes

仅有截图不够，必须同时有实现说明。

## 20. Playwright 视觉 QA

条件允许时，使用 Playwright 做前端验证。

至少检查：

- 1440px desktop
- 1280px laptop
- 768px tablet

每个已实现页面应检查：

- Layout 是否符合 Pencil 原型
- Sidebar 行为是否正确
- Header 和 Breadcrumb 是否正确
- FilterBar 对齐是否正确
- DataTable columns 和 actions 是否可见
- Sheet / Dialog 交互是否可用
- Empty / Loading / Error states 是否存在
- focus ring 是否可见
- 浏览器 console 是否有明显错误

如果页面没有打开并做视觉检查，不应认为前端工作完成。

## 21. 当前阶段设计注意

当前阶段：`{{STAGE}}`

本阶段应先写清楚：

- 目标用户
- 主路径
- 页面清单
- 不在本阶段范围内的内容
- 权限边界
- 数据表格列
- 查询筛选项
- Sheet / Dialog / 表单交互
- Loading / Empty / Error / No permission 状态

## 22. 设计完成定义

前端设计可进入实现前，必须满足：

1. `DESIGN.md` 已存在并被遵守。
2. `design/pencil-input-{{STAGE}}.md` 或对应阶段输入文档已确认。
3. `design/` 下存在已确认 Pencil 原型或截图与说明。
4. 页面级说明包含组件组合、表格列、筛选项、操作、状态和权限规则。
5. 如需偏离本文件，必须说明原因并获得确认。
