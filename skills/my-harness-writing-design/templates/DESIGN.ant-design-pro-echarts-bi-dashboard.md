# {{PROJECT_NAME}} BI 数据驾驶舱设计基线

本文档是 `{{PROJECT_NAME}}` 的 BI 图表分析 / 数据驾驶舱设计基线，供 Product Design 视觉目标、前端实现、数据可视化评审和后续 QA 使用。

规则来源优先级：

1. 用户在当前对话中的明确指令
2. 已确认的数据分析目标 / 指标口径 / 业务场景
3. 本 `DESIGN.md`
4. `AGENTS.md` / `CLAUDE.md` / 工程约定
5. 现有实现代码
6. Ant Design Pro / ECharts 官方文档
7. 通用数据可视化最佳实践

硬性执行规则：

- 任何设计、前端规划、实现和 design review 都必须严格遵守本 `DESIGN.md`，包括字体、间距、React + Ant Design Pro + ECharts 技术栈、ProComponents、图表映射、颜色 token、响应式、状态设计和可访问性。
- 如使用 Product Design 生成视觉目标，默认至少提供三套原型/视觉方案供选择；目标模式下可以选择系统推荐方案，但必须记录推荐理由。
- 进入设计规划和原型图设计时，如果系统没有明确标题、logo 或 favicon，必须先使用 Creative Production plugin 的 `logo-explorer` 构建 logo / favicon / app icon 方向，并把选中方向、拒绝方案、标题和资产路径记录到 `design/`。
- 做前端开发时，如已有 Product Design 选中原型或视觉目标，先使用 `image-to-code` / `url-to-code` 做原型切割形成前端框架，再按 Ant Design Pro 和 ECharts 组件/图表体系开发。
- 执行 `IMPLEMENTATION_PLAN.md` 时，Codex 和所有 subagent 必须持续遵守 `AGENTS.md`、`CLAUDE.md`、README、本 `DESIGN.md`、`DEPLOY.md`、`IMPLEMENTATION_PLAN.md` 和相关 docs/runbooks；subagent brief 必须写明治理约束、允许改动边界和偏差回报要求。
- design review 阶段要严格比对成品和原型图之间的差异，持续修复直到高度还原或偏差被明确接受。
- 如果原型与 Ant Design Pro、ProComponents、ECharts 或项目已有组件不一致，以框架组件、图表库和本 `DESIGN.md` 为准；原型仅作视觉和信息架构参考。

## 1. 场景和技术栈

产品场景：`{{PRODUCT_SCENARIO}}`

前端技术组合固定为：

- React
- Ant Design Pro
- ECharts

适用范围：

- BI 图表分析
- 数据驾驶舱
- 数据大屏
- 指标监控
- 经营分析报表
- 多维筛选、联动、下钻和趋势对比

不适用范围：

- 普通 Admin Console / CRUD 管理后台：使用 shadcn/ui + tweakcn。
- C 端网站 / App：不锁定框架，交给 Product Design 决策。

## 2. 设计目标

BI / 数据驾驶舱优先解决业务理解和决策效率，不追求装饰性大屏。

默认目标：

- 指标层级清楚
- 时间范围和筛选条件明确
- 图表可解释
- 异常和趋势突出
- 支持钻取和对比
- 图表状态完整
- 数据口径可追溯
- 大屏和桌面分析场景都能稳定使用

## 3. 信息架构

页面默认结构：

```text
DashboardShell
  ├─ Header / Title / Refresh metadata
  ├─ GlobalFilterBar
  ├─ KPI Summary
  ├─ Chart Grid
  ├─ Detail Table / Drilldown Panel
  └─ Insight / Annotation / Export area
```

每个驾驶舱必须写清：

- 目标用户
- 核心业务问题
- 指标口径
- 时间粒度
- 筛选维度
- 图表清单
- 联动关系
- 下钻路径
- 权限边界
- 数据刷新策略
- 导出/分享要求

## 4. Ant Design Pro 使用规则

Ant Design Pro 用于承载页面骨架、导航、筛选、表格、表单、权限和 ProComponents。

推荐组件：

- `ProLayout`
- `PageContainer`
- `ProCard`
- `ProTable`
- `ProForm`
- `StatisticCard`
- `Segmented`
- `DatePicker.RangePicker`
- `Select` / `TreeSelect`
- `Tabs`
- `Drawer` / `Modal`

约束：

- 不把 Ant Design Pro 当作普通 CRUD 模板照搬；BI 页面必须围绕指标和图表组织。
- 不混用 shadcn/ui 作为同一基线的主 UI 框架。
- 表格用于明细、排名、异常列表和下钻结果，不替代图表表达趋势。
- 表单和筛选必须支持默认值、重置、禁用、加载、错误和权限状态。

## 5. ECharts 使用规则

ECharts 是所有核心图表的默认实现。

图表设计必须明确：

- 图表类型
- x / y / series / legend / tooltip 映射
- 数据单位
- 时间粒度
- 空值和缺失值处理
- 异常值和阈值
- 颜色含义
- 点击、hover、brush、zoom、legend toggle 等交互
- loading / empty / error 状态

常用图表选择：

| 目标 | 推荐图表 |
|---|---|
| 趋势 | Line / Area |
| 构成 | Stacked Bar / Pie 仅少量分类 |
| 排名 | Bar / Horizontal Bar |
| 分布 | Histogram / Boxplot |
| 关系 | Scatter |
| 地理 | Map |
| 漏斗 | Funnel |
| 同比环比 | Line + Bar / Dual Axis |

避免：

- 3D 图表
- 过度渐变
- 无意义动态特效
- 颜色只为装饰
- 饼图分类过多
- 双轴没有明确解释
- 图表无单位、无口径、无 tooltip

## 6. 视觉和主题

默认风格：

- 专业、清晰、数据优先
- 浅色主题优先，必要时支持深色大屏模式
- 使用 Ant Design token 和统一图表色板
- 颜色必须表达业务含义或状态，不随机配色

图表色板：

- 主要指标使用稳定主色
- 成功、警告、危险使用语义色
- 多系列颜色控制在可区分范围内
- 同一指标跨页面保持同一颜色

## 7. 状态设计

每个图表和指标块必须考虑：

- Loading
- Empty
- API error
- Permission denied
- Partial data
- Stale data
- Refreshing
- Filter no result
- Drilldown unavailable
- Export pending / success / failed

不要只设计有完整数据的 happy path。

## 8. 响应式和性能

默认优先级：

1. 1440px desktop
2. 1280px laptop
3. 1920px 大屏
4. 768px tablet

390px mobile 只在业务明确要求移动查看时作为硬约束；否则提供可读降级，不把复杂驾驶舱硬塞进手机屏。

性能要求：

- 大数据量图表使用抽样、聚合或后端预计算
- 图表初始化和 resize 必须稳定
- 避免一次渲染过多图表阻塞首屏
- 长查询必须有 loading 和可取消/重试策略
- 数据刷新必须避免闪烁和布局跳动

## 9. Product Design 和设计制品

如宿主机安装了 Product Design，可用于：

- `get-context` 确认业务问题、指标层级和目标用户
- `ideate` 生成至少三套驾驶舱原型/视觉方向
- `image-to-code` / `url-to-code` 在 `IMPLEMENTATION_PLAN.md` 之后切割选中原型形成前端页面骨架
- `design-qa` 对比视觉目标和实现截图

Product Design 不改变本场景的技术组合：React + Ant Design Pro + ECharts。

所有视觉目标、至少三套原型/视觉方向、截图、图表说明和 `design-qa.md` 必须记录到 `design/`。`design-qa.md` 必须记录成品和原型图差异、严重程度、修复建议和已接受偏差，并驱动修复直到高度还原或偏差被明确接受。

## 10. 完成定义

前端设计可进入实现前，必须满足：

1. 指标口径、维度、时间范围和权限边界明确。
2. 页面结构、图表清单、筛选项、联动和下钻路径明确。
3. 每个图表有 ECharts 映射说明。
4. Ant Design Pro 组件使用边界明确。
5. Loading / Empty / Error / Permission / Partial data 状态完整。
6. 性能和响应式策略明确。
7. 如使用 Product Design，至少三套原型/视觉方案、选中的视觉目标或 `design-qa.md` 证据已记录到 `design/`。
8. 如系统缺少标题、logo 或 favicon，Creative Production `logo-explorer` 的选中方向、拒绝方案、标题和资产路径已记录到 `design/`，或已明确记录延期原因。
9. 前端实现已先用 Product Design `image-to-code` / `url-to-code` 切割选中原型形成页面骨架，或已记录为什么无需切割。
10. `executing-plans` 或 `subagent-driven-development` 已明确要求遵守 `AGENTS.md`、本文件、`IMPLEMENTATION_PLAN.md` 和相关治理文档。
11. 如原型与 Ant Design Pro / ECharts 或项目已有组件不一致，已按框架组件和本文件收敛并记录偏差。
