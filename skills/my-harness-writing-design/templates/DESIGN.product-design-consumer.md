# {{PROJECT_NAME}} C 端产品设计基线

本文档是 `{{PROJECT_NAME}}` 的 C 端网站 / App 设计基线。该场景不预设前端框架，技术选择交给 Product Design 视觉方向、交互模型和后续工程评审共同决定。

规则来源优先级：

1. 用户在当前对话中的明确指令
2. Product Design 已确认 brief、视觉方向和用户选择
3. 本 `DESIGN.md`
4. `AGENTS.md` / `CLAUDE.md` / 工程约定
5. 现有实现代码或品牌资产
6. 通用 C 端产品体验最佳实践

## 1. 场景和技术栈

产品场景：`{{PRODUCT_SCENARIO}}`

前端框架：不在本阶段锁定。

Product Design 必须先产出：

- 目标用户和核心任务
- 品牌与视觉方向
- 信息架构
- 核心页面 / 流程
- 交互深度
- 响应式或平台目标
- 选中的视觉目标

工程评审再根据以下因素决定框架：

- Web / H5 / Native / 小程序 / 跨端目标
- SEO 和内容分发需求
- 动效复杂度
- 表单和交易链路复杂度
- 性能与离线要求
- 现有项目技术栈
- 团队维护成本

## 2. Product Design 工作流

没有明确视觉目标时，默认使用：

1. Product Design `get-context`
2. Product Design `ideate`
3. 用户选择一个方向
4. 将选中图、说明、截图或链接记录到 `design/`
5. 后续 `plan-design-review` 审查选中设计制品

如果已有 URL、截图、Figma、品牌资产或现有 UI，可直接作为 Product Design 输入。

不要在 Product Design brief 尚未确认、视觉目标尚未选择前锁定 React、Next.js、Vue、React Native、Flutter、shadcn、Ant Design Pro 或其他框架。

## 3. 设计目标

C 端产品优先考虑：

- 首屏理解
- 转化路径
- 内容节奏
- 情绪和品牌识别
- 移动端可用性
- 表单和操作阻力
- 真实素材和视觉可信度
- 加载、失败和返回路径

默认不是：

- 管理后台
- BI 驾驶舱
- 大量表格和筛选器
- 企业控制台布局

## 4. 必备页面和状态

每个 C 端项目必须按实际业务写清：

- 首页 / 首屏
- 核心转化路径
- 内容详情
- 登录 / 注册 / 授权，如果需要
- 购买 / 预约 / 提交 / 咨询，如果需要
- 个人中心或设置，如果需要
- Empty / Loading / Error
- No permission / Auth expired
- Payment / Submit pending
- Success / Failure

## 5. 视觉和内容规则

Product Design 视觉目标必须明确：

- 品牌气质
- 色彩方向
- 字体方向
- 图片 / 视频 / 插画使用方式
- 信息密度
- CTA 层级
- 响应式断点
- 交互动效要求

不要使用管理后台式的表格、FilterBar、Sidebar 或密集 card 网格，除非产品本身就是面向专业用户的工具型 C 端产品。

## 6. 技术选型输入

进入 `plan-eng-review` 前，设计制品至少要给工程评审提供：

- 目标平台：Web、H5、iOS、Android、小程序或跨端
- 首屏内容和 SEO 需求
- 页面数量和路由复杂度
- 动效复杂度
- 表单/支付/媒体/地图/聊天等特殊能力
- 图片和视频资产策略
- 性能目标
- 无障碍目标

工程评审再决定框架和构建方式。

## 7. QA 要求

实现后必须检查：

- 移动端 390px
- 常见桌面宽度
- 首屏内容是否明确
- CTA 是否可点击且不遮挡
- 图片/视频是否真实加载
- 字体、间距、颜色是否贴近视觉目标
- Loading / Error / Empty / Success 状态
- 表单校验和失败恢复
- Console / Network 是否有明显问题
- 如有源视觉目标，使用 Product Design `design-qa` 生成或更新 `design-qa.md`

## 8. 完成定义

前端设计可进入实现前，必须满足：

1. Product Design brief 已确认，或已有可用视觉来源。
2. 选中的视觉目标、截图、URL、Figma 或说明已记录到 `design/`。
3. 页面范围、核心路径、状态和响应式要求明确。
4. 技术框架尚未被设计阶段硬编码，除非用户或现有项目已经明确指定。
5. 后续 `plan-eng-review` 会基于视觉目标和工程约束做最终技术选型。
