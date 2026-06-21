#!/usr/bin/env python3
"""Create project design governance scaffolding for my-harness-writing-design."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path


SKILL_DIR = Path(__file__).resolve().parents[1]
TEMPLATE_PATHS = {
    "shadcn": SKILL_DIR / "templates" / "DESIGN.shadcn-admin-console.md",
    "ant-design-pro-echarts": SKILL_DIR / "templates" / "DESIGN.ant-design-pro-echarts-bi-dashboard.md",
    "product-design-decides": SKILL_DIR / "templates" / "DESIGN.product-design-consumer.md",
}
FRAMEWORK_LABELS = {
    "shadcn": "shadcn/ui",
    "ant-design-pro-echarts": "React + Ant Design Pro + ECharts",
    "product-design-decides": "Product Design decides",
}
FRAMEWORK_ALIASES = {
    "auto": "auto",
    "shadcn": "shadcn",
    "shadcn ui": "shadcn",
    "shadcn/ui": "shadcn",
    "shadcn-ui": "shadcn",
    "ant design pro": "ant-design-pro-echarts",
    "ant-design-pro": "ant-design-pro-echarts",
    "antd pro": "ant-design-pro-echarts",
    "antd-pro": "ant-design-pro-echarts",
    "ant design pro + echarts": "ant-design-pro-echarts",
    "react + ant design pro + echarts": "ant-design-pro-echarts",
    "echarts": "ant-design-pro-echarts",
    "bi": "ant-design-pro-echarts",
    "bi-dashboard": "ant-design-pro-echarts",
    "product design": "product-design-decides",
    "product-design": "product-design-decides",
    "product-design-decides": "product-design-decides",
    "consumer": "product-design-decides",
    "c端": "product-design-decides",
    "c-end": "product-design-decides",
}
SCENARIO_ALIASES = {
    "auto": "auto",
    "admin": "admin-console",
    "admin-console": "admin-console",
    "console": "admin-console",
    "management": "admin-console",
    "backend": "admin-console",
    "bi": "bi-dashboard",
    "bi-dashboard": "bi-dashboard",
    "dashboard": "bi-dashboard",
    "analytics": "bi-dashboard",
    "data-dashboard": "bi-dashboard",
    "数据驾驶舱": "bi-dashboard",
    "驾驶舱": "bi-dashboard",
    "图表分析": "bi-dashboard",
    "consumer": "consumer",
    "consumer-app": "consumer",
    "consumer-site": "consumer",
    "c端": "consumer",
    "c-end": "consumer",
    "website": "consumer",
    "app": "consumer",
}
SCENARIO_FRAMEWORKS = {
    "admin-console": "shadcn",
    "bi-dashboard": "ant-design-pro-echarts",
    "consumer": "product-design-decides",
}
SCENARIO_LABELS = {
    "admin-console": "Admin Console / 后台管理系统",
    "bi-dashboard": "BI 图表分析 / 数据驾驶舱",
    "consumer": "C 端网站 / App",
}
FRAMEWORK_METADATA = {
    "shadcn": {
        "interface_type": "企业级后台管理系统 / Admin Console",
        "component_mapping_label": "shadcn/ui component composition",
        "design_direction": "从零到一默认以 tweakcn 作为 shadcn/ui 主题与后台视觉参考；以 Tailwind CSS variables 和可组合组件实现，不引入第三方 UI 框架。",
        "style_reference": "tweakcn",
        "framework_note": "如宿主机已配置 shadcn MCP，可优先用它浏览、搜索和引入 shadcn registry 组件；未配置时使用 shadcn CLI、官方文档和项目已有组件继续推进，不阻塞设计流程。",
    },
    "ant-design-pro-echarts": {
        "interface_type": "BI 图表分析 / 数据驾驶舱",
        "component_mapping_label": "Ant Design Pro layout + ECharts visualization mapping",
        "design_direction": "BI / 数据驾驶舱默认采用 React + Ant Design Pro + ECharts；用 Ant Design Pro 承载页面骨架、筛选、表格和管理能力，用 ECharts 承载图表、趋势、地图和多维分析。",
        "style_reference": "Ant Design Pro + ECharts",
        "framework_note": "不要把 BI 驾驶舱强行套成 shadcn 管理后台；图表、指标卡、联动筛选、下钻和大屏性能策略必须围绕 ECharts 与数据分析体验设计。",
    },
    "product-design-decides": {
        "interface_type": "C 端网站 / App",
        "component_mapping_label": "Product Design visual direction and framework decision",
        "design_direction": "C 端网站或 App 不锁定前端技术框架；先由 Product Design 产出视觉方向、交互模型和体验约束，再在工程评审中根据目标平台、动效、内容、性能和团队栈决定实现框架。",
        "style_reference": "Product Design",
        "framework_note": "不要默认使用 shadcn、Ant Design Pro 或其他管理后台框架；Product Design 的 brief、ideate、选中视觉目标和 design-qa 证据是后续技术选型输入。",
    },
}

DESIGN_GOVERNANCE_START = "<!-- MY_HARNESS_DESIGN_GOVERNANCE_START -->"
DESIGN_GOVERNANCE_END = "<!-- MY_HARNESS_DESIGN_GOVERNANCE_END -->"
AGENTS_DESIGN_START = "<!-- MY_HARNESS_AGENTS_DESIGN_START -->"
AGENTS_DESIGN_END = "<!-- MY_HARNESS_AGENTS_DESIGN_END -->"


def run(cmd: list[str], cwd: Path) -> str:
    try:
        return subprocess.check_output(cmd, cwd=cwd, text=True, stderr=subprocess.DEVNULL).strip()
    except Exception:
        return ""


def slug(value: str) -> str:
    value = value.strip().lower()
    value = re.sub(r"[^a-z0-9._-]+", "-", value)
    value = re.sub(r"-+", "-", value).strip("-")
    return value or "project"


def infer_project_name(root: Path, explicit: str | None) -> str:
    if explicit:
        return explicit
    return root.name


def infer_stage(root: Path, explicit: str | None) -> str:
    if explicit:
        return explicit

    branch = run(["git", "branch", "--show-current"], root)
    match = re.search(r"v\d+(?:\.\d+){1,3}", branch)
    if match:
        return match.group(0)

    package_json = root / "package.json"
    if package_json.exists():
        try:
            data = json.loads(package_json.read_text(encoding="utf-8"))
            version = data.get("version")
            if version:
                return f"v{version}"
        except Exception:
            pass

    pyproject = root / "pyproject.toml"
    if pyproject.exists():
        text = pyproject.read_text(encoding="utf-8", errors="ignore")
        match = re.search(r'(?m)^version\s*=\s*["\']([^"\']+)["\']', text)
        if match:
            return f"v{match.group(1)}"

    return "v0.1.0"


def infer_phase(explicit: str | None) -> str:
    return explicit or "design-baseline"


def normalize_ui_framework(explicit: str | None) -> str | None:
    if not explicit:
        return None

    value = explicit.strip().lower()
    framework = FRAMEWORK_ALIASES.get(value)
    if framework == "auto":
        return None
    if not framework:
        allowed = ", ".join(FRAMEWORK_LABELS.values())
        raise ValueError(f"unsupported UI framework: {explicit!r}; supported values: {allowed}")
    return framework


def infer_product_scenario(
    explicit: str | None,
    project_name: str,
    phase: str,
    root: Path,
    explicit_framework: str | None,
) -> str | None:
    if explicit:
        value = explicit.strip().lower()
        scenario = SCENARIO_ALIASES.get(value)
        if not scenario:
            allowed = ", ".join(sorted(set(SCENARIO_ALIASES.values())))
            raise ValueError(f"unsupported product scenario: {explicit!r}; supported values: {allowed}")
        if scenario != "auto":
            return scenario

    if explicit_framework:
        for scenario, framework in SCENARIO_FRAMEWORKS.items():
            if framework == explicit_framework:
                return scenario

    haystack = " ".join([project_name, phase, root.name]).lower()
    admin_keywords = ["admin", "console", "后台", "管理台", "管理后台", "管理系统", "控制台", "cms"]
    bi_keywords = ["bi", "dashboard", "analytics", "analysis", "report", "reporting", "chart", "echarts", "驾驶舱", "数据大屏", "数据看板", "图表", "分析"]
    consumer_keywords = ["consumer", "c端", "c-end", "website", "consumer-app", "consumer-site", "mobile", "landing", "官网", "小程序", "用户端"]

    if any(keyword in haystack for keyword in admin_keywords):
        return "admin-console"
    if any(keyword in haystack for keyword in bi_keywords):
        return "bi-dashboard"
    if any(keyword in haystack for keyword in consumer_keywords):
        return "consumer"
    return None


def resolve_framework(scenario: str, explicit_framework: str | None) -> str:
    expected = SCENARIO_FRAMEWORKS[scenario]
    if not explicit_framework:
        return expected
    if explicit_framework != expected:
        raise ValueError(
            f"framework {FRAMEWORK_LABELS[explicit_framework]!r} does not match scenario "
            f"{SCENARIO_LABELS[scenario]!r}; expected {FRAMEWORK_LABELS[expected]!r}"
        )
    return explicit_framework


def render_template(project_name: str, stage: str, product_scenario: str, ui_framework: str) -> str:
    template = TEMPLATE_PATHS[ui_framework].read_text(encoding="utf-8")
    return (
        template.replace("{{PROJECT_NAME}}", project_name)
        .replace("{{STAGE}}", stage)
        .replace("{{UI_FRAMEWORK}}", FRAMEWORK_LABELS[ui_framework])
        .replace("{{PRODUCT_SCENARIO}}", SCENARIO_LABELS[product_scenario])
    )


def create_design_input(
    path: Path,
    project_name: str,
    stage: str,
    phase: str,
    product_scenario: str,
    ui_framework: str,
    theme_source: str | None,
) -> bool:
    if path.exists():
        return False

    framework_label = FRAMEWORK_LABELS[ui_framework]
    metadata = FRAMEWORK_METADATA[ui_framework]
    component_mapping_label = metadata["component_mapping_label"]
    design_direction = metadata["design_direction"]
    style_reference = metadata["style_reference"]
    framework_note = metadata["framework_note"]
    theme_source_text = theme_source or "未提供；使用所选产品场景和框架的默认设计方向。"

    content = f"""# {project_name} {stage} 设计输入文档

状态：DRAFT_FOR_DESIGN_ARTIFACT
适用阶段：{stage}
设计对象：{phase}
产品场景：{SCENARIO_LABELS[product_scenario]}
界面类型：{metadata["interface_type"]}
UI 框架：{framework_label}
风格参考：{style_reference}
主题/品牌素材来源：{theme_source_text}

## 1. 设计目标

- 说明本阶段要跑通的主路径。
- 说明目标用户、关键操作和成功标准。
- {design_direction}
- 如用户提供官网、logo、截图、主题色或品牌素材，先解析主色、辅助色、背景倾向、对比度、饱和度和品牌气质，再选择合适主题模板。
- 按钮默认使用 icon + 文字；仅列表页或空间较窄的紧凑区域可使用纯 icon 按钮，并补充可访问标签和必要 tooltip；按钮文字不得换行。
- 如宿主机安装了 Product Design，默认可用其 get-context -> ideate 分支生成至少 3 个原型/视觉方向并等待用户选择；目标模式下可选择系统推荐方案，但必须记录推荐依据；选中视觉目标后记录到 design/。
- Step 3 必须留下 approved visual target，不只是“设计方向”；记录 approved / selected / system-recommended accepted 状态、target mockup 或引用、选择理由和 implementation spec extraction。
- 如果系统没有明确标题、logo 或 favicon，先使用 Creative Production plugin 的 logo-explorer 构建 logo / favicon / app icon 方向；已有项目名时可作为临时标题，目标模式下可从 repo/project name 推导保守标题；选中方向、拒绝方案、标题和资产路径记录到 design/。
- 如 Product Design 未安装，不要求安装；使用当前场景设计基线、已有 UI 参考、截图或设计说明继续推进。
- 只有复杂前端模块、跨人协作或多页面/多状态交互需要明确对齐时，才使用 Pencil 产出 .pen 原型和导出截图。
- {framework_note}
- 如果是 Admin Console，Product Design 原型或视觉目标必须附带 shadcn/ui 证据：页面骨架、shadcn components / blocks 清单、Tailwind token / CSS variables 映射、8px spacing 决策、禁用的非 shadcn UI 框架，以及无法使用标准组件时的偏差说明。
- 如已有 Product Design 选中原型或视觉目标，前端开发时先用 image-to-code / url-to-code 做原型切割形成前端框架，再结合项目代码和组件体系开发。
- UI 密集项目采用前端高保真先行：Step 6A 前端计划引用 approved visual target 并抽取 implementation spec；Step 7A 用 mock 先还原布局、交互、状态和响应式；Step 9A 先产出浏览器截图；Step 10A 用 target、截图、差异、修复、before/after 和 accepted deviations 做硬门禁；Step 6B-11B 再接入后端并做视觉回归。
- 执行 IMPLEMENTATION_PLAN.md 时，Codex 和所有 subagent 必须持续遵守 AGENTS.md、CLAUDE.md、README、DESIGN.md、DEPLOY.md、IMPLEMENTATION_PLAN.md 和相关 docs/runbooks；subagent brief 必须写明治理约束、允许改动边界和偏差回报要求。
- 设计 review 阶段必须比对成品和原型图差异，持续修复直到高度还原或偏差被明确接受。
- 如果原型与 shadcn/ui、Ant Design Pro、ECharts 或其他选定第三方框架的已有组件不一致，以前端框架组件和 DESIGN.md 为准，原型仅作视觉和信息架构参考。
- 默认遵循 8px spacing system，不使用随机颜色，不无故使用渐变或玻璃拟态，不随意创建自定义基础组件。

## 2. 页面范围

本阶段必须覆盖：

1. 待补充页面
2. 待补充页面
3. 待补充页面

不在本阶段范围：

- 待补充

## 3. 页面要求

每个页面必须写清：

- 页面用途
- {component_mapping_label}
- Table columns
- Filter fields
- Toolbar actions
- Row actions
- Drawer / Modal interactions
- Form fields
- Permission rules
- Loading / Empty / Error states
- Theme token decision
- Brand/material interpretation
- Implementation notes
- Product Design visual target reference, if used
- Approved visual target status, target mockup/reference, and implementation spec extraction
- Frontend Fidelity First evidence: Step 6A/7A/9A/10A/11A frontend mock loop and Step 6B-11B backend integration loop decision
- Creative Production logo/favicon/title route, if used
- Framework/component source and fallback decision
- Admin Console shadcn evidence, if applicable: `components.json` status, `src/components/ui` status, planned shadcn components / blocks, Tailwind token source, and non-shadcn UI framework absence or approved migration reason
"""
    path.write_text(content, encoding="utf-8")
    return True


def latest_design_governance_section(product_scenario: str, ui_framework: str) -> str:
    scenario_label = SCENARIO_LABELS[product_scenario]
    framework_label = FRAMEWORK_LABELS[ui_framework]

    admin_extra = ""
    if product_scenario == "admin-console":
        admin_extra = """

### Admin Console shadcn/ui 硬门禁

- 设计制品和 Product Design 原型必须以 shadcn/ui + tweakcn + Tailwind CSS variables 为视觉语言，不得产出 Ant Design、Material UI、Chakra、Arco、Element、Bootstrap、Tailwind UI 或自造大型 Design System 风格的后台稿。
- 每个页面必须记录 shadcn component / block mapping：`AppShell`、`Sidebar`、`TopBar`、`PageHeader`、`FilterBar`、`DataTable`、`Dialog`、`Sheet`、`Form`、`DropdownMenu`、`Tabs`、`Toast` 等实际使用或明确不使用的组件。
- 原型稿必须记录 Tailwind token / CSS variable 映射：`background`、`foreground`、`card`、`primary`、`secondary`、`muted`、`accent`、`destructive`、`border`、`input`、`ring`、`sidebar` 和图表 token；禁止在页面稿或实现中散落随机颜色。
- 原型稿必须说明 8px spacing、表格列宽、长文本 / 长 ID 处理、按钮 icon+text / icon-only 选择、Dialog / Sheet / detail page 选择，以及 loading / empty / error / forbidden / disabled / pending / readonly 状态。
- 如果 shadcn MCP 可用，Step 3 用它查 components / blocks 并记录来源；不可用时使用 shadcn CLI、官方文档和项目已有组件，不得把 MCP 不可用解释成可以不用 shadcn/ui。
- Step 6 `IMPLEMENTATION_PLAN.md` 必须检查 `components.json`、Tailwind 配置、`src/components/ui` 或项目等价组件目录，并列出需要新增或复用的 shadcn components / blocks、命令、目标文件、fallback 和代码审查点。
- Step 7 实现必须以 shadcn/ui primitives、项目已有组件和 Tailwind tokens 为底座。Product Design `image-to-code` / `url-to-code` 生成的代码只能作为骨架，完成前必须改造成项目 shadcn/ui 组件体系，不得直接提交泛 React/Tailwind 或其他 UI 框架代码。
"""

    return f"""{DESIGN_GOVERNANCE_START}
## my-harness 最新设计治理补强

本节由 `my-harness-writing-design` 维护。再次显式执行该 skill 时，可以刷新本节以合入 my-harness 最新要求；本节外的项目个性化设计决策、品牌规则和历史说明必须保留。

- 当前产品场景：{scenario_label}。
- 当前 UI 框架基线：{framework_label}。
- 任何 UI / 前端 / 图表 / App 工作都必须先读取本 `DESIGN.md` 和 `design/`，再进入 Product Design、工程规划、实现或 QA。
- Product Design 原型、截图、URL capture、Figma 或设计说明必须记录到 `design/`，并说明它如何遵守本文件；只说“风格参考”不算完成。
- 当原型与选定框架组件冲突时，以选定框架组件、项目已有组件和本 `DESIGN.md` 为准；原型只作为视觉与信息架构参考，不能授权创建平行组件体系。
- Step 4 / Step 10 设计评审必须逐项检查字体、字号、间距、颜色 token、布局密度、组件形态、状态覆盖、响应式、可访问性，以及框架组件复用情况。

### 前端高保真先行门禁

- Step 3 必须留下 approved visual target，不只是“设计方向”。记录 approved / selected / system-recommended accepted 状态、target mockup 或引用、选择理由和 implementation spec extraction。
- implementation spec extraction 必须覆盖布局结构、导航、信息层级、组件清单、交互状态、loading / empty / error 状态、响应式、关键 copy、颜色 token、字体、间距、截图计划和 accepted deviations；Admin Console 还必须覆盖 shadcn component/block mapping 和 Tailwind token / CSS variable mapping。
- Step 6A frontend fidelity plan 必须引用 Step 3 approved visual target，明确 mock API / fixture / MSW / local data strategy、页面/路由/状态、截图路径和 `design-qa.md` 或设计评审记录路径。
- Step 7A frontend mock implementation 以还原 approved visual target 为第一优先级，代码洁癖后置；Product Design `image-to-code` / `url-to-code` 只能作为 scaffold，完成 Step 10A 前必须回到 shadcn/ui、项目已有组件和 Tailwind tokens。
- Step 9A 必须在 Step 10A 前执行 browser verification，保留关键桌面/移动视口、主路径交互和空/错/加载状态截图；没有截图证据不得进入 Step 10A。
- Step 10A 是 Product Design 高保真硬门禁，必须记录 target mockup/reference、browser screenshots、差异列表、严重级别、修复记录、before/after 截图或可复核说明，以及 accepted deviations。
- Step 6B-11B 在后端/API/真实数据接入后重新跑 integration verification、browser verification、visual regression 和 full functional QA；真实数据不得破坏已批准的布局和交互。
{admin_extra}
{DESIGN_GOVERNANCE_END}
"""


def upsert_marked_section(text: str, section: str, start: str, end: str) -> tuple[str, bool]:
    pattern = re.compile(rf"{re.escape(start)}.*?{re.escape(end)}", re.DOTALL)
    if pattern.search(text):
        updated = pattern.sub(section.rstrip(), text)
        return updated, updated != text
    updated = text.rstrip() + "\n\n" + section.rstrip() + "\n"
    return updated, True


def ensure_design_doc_with_framework(root: Path, project_name: str, stage: str, product_scenario: str, ui_framework: str) -> bool:
    path = root / "DESIGN.md"
    section = latest_design_governance_section(product_scenario, ui_framework)
    if path.exists():
        text = path.read_text(encoding="utf-8", errors="ignore")
        updated, changed = upsert_marked_section(text, section, DESIGN_GOVERNANCE_START, DESIGN_GOVERNANCE_END)
        if changed:
            path.write_text(updated, encoding="utf-8")
        return changed
    path.write_text(
        render_template(project_name, stage, product_scenario, ui_framework).rstrip() + "\n\n" + section,
        encoding="utf-8",
    )
    return True


def agents_design_section() -> str:
    return f"""{AGENTS_DESIGN_START}
## 设计规范

- 项目级 UI/UX 规则见 `DESIGN.md`。
- 设计制品、视觉目标、截图和设计说明统一放在 `design/`。
- 如果项目还没有 `DESIGN.md`，任何 UI / 前端 / 图表 / App 工作开始前都必须先用 `my-harness-writing-design` 创建。
- 如果显式执行 `my-harness-writing-design` 且项目已有 `DESIGN.md`，必须保守合并 my-harness 最新设计治理补强，保留项目个性化内容，不覆盖业务、品牌或历史设计决策。
- 前端框架按产品场景选择：Admin Console 使用 shadcn/ui + tweakcn；BI 图表分析 / 数据驾驶舱使用 React + Ant Design Pro + ECharts；C 端网站 / App 不锁定框架，由 Product Design 产出视觉方向后再在工程评审中决策。
- 所有设计、前端规划、实现和 design review 必须严格遵守 `DESIGN.md`，包括字体、间距、技术栈、组件体系、图表库、颜色 token、响应式、状态设计和可访问性。
- Admin Console 的 Product Design 原型和视觉目标必须提供 shadcn/ui 证据：组件 / blocks mapping、Tailwind token / CSS variables 映射、tweakcn 主题依据、8px spacing、状态覆盖，以及非 shadcn UI 框架未被引入的说明。
- 如果使用 Product Design 生成视觉目标，默认至少提供三套原型/视觉方案供选择；目标模式下可选择系统推荐方案，但必须记录推荐理由。对应图片、链接或说明也必须记录到 `design/`。
- 进入设计规划和原型图设计时，如果系统没有明确标题、logo 或 favicon，必须先使用 Creative Production plugin 的 `logo-explorer` 构建 logo / favicon / app icon 方向；已有项目名时可作为临时标题，目标模式下可从 repo/project name 推导保守标题。选中方向、拒绝方案、标题和资产路径记录到 `design/`。
- Product Design 结果必须收敛成 Step 3 approved visual target，而不是只留下设计方向；记录 target mockup/reference、选择理由和 implementation spec extraction。
- 做前端开发时，如已有 Product Design 选中原型或视觉目标，先使用 `image-to-code` / `url-to-code` 做原型切割形成前端框架，再按项目代码和组件体系开发；Admin Console 必须把生成骨架改造成 shadcn/ui primitives、项目已有组件和 Tailwind tokens，不得直接提交泛 React/Tailwind 或其他 UI 框架代码。
- UI 密集项目采用前端高保真先行：Step 6A 前端计划引用 approved visual target 并抽取 implementation spec；Step 7A 用 mock 先还原布局和交互；Step 9A 先产出浏览器截图；Step 10A 必须记录 target、截图、差异、修复、before/after 和 accepted deviations；Step 6B-11B 再接入后端并做视觉回归。
- 进入 `executing-plans` 或 `subagent-driven-development` 后，Codex 和所有 subagent 必须持续遵守 `AGENTS.md`、`CLAUDE.md`、README、`DESIGN.md`、`DEPLOY.md`、`IMPLEMENTATION_PLAN.md` 和相关 docs/runbooks；subagent brief 必须写明治理约束、允许改动边界和偏差回报要求。
- design review 阶段要严格比对成品和原型图之间的差异，持续修复直到高度还原或偏差被明确接受；`design-qa.md` 记录差异、修复和接受项。
- 若选定 shadcn/ui、Ant Design Pro、ECharts 或其他第三方框架，且原型与已有组件不一致，以前端框架组件和 `DESIGN.md` 为准，原型仅作参考。
- 未安装 Product Design 时使用当前场景的设计基线、已有 UI 参考、截图或必要时 Pencil 协同制品继续推进。
{AGENTS_DESIGN_END}
"""


def ensure_agents_link(path: Path) -> bool:
    section = agents_design_section()
    if path.exists():
        text = path.read_text(encoding="utf-8", errors="ignore")
        updated, changed = upsert_marked_section(text, section, AGENTS_DESIGN_START, AGENTS_DESIGN_END)
        if changed:
            path.write_text(updated, encoding="utf-8")
        return changed

    path.write_text("# 项目 AI 开发规范\n" + section, encoding="utf-8")
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description="Create project design governance scaffold.")
    parser.add_argument("--root", default=".", help="Project root. Default: current directory.")
    parser.add_argument("--project-name", help="Project display name. Default: directory name.")
    parser.add_argument("--stage", help="Project phase/version, such as v0.1.0.")
    parser.add_argument("--phase", help="Design phase slug, such as admin-console.")
    parser.add_argument(
        "--product-scenario",
        default="auto",
        help="Product scenario. Supported: auto, admin-console, bi-dashboard, consumer. Default: auto.",
    )
    parser.add_argument(
        "--ui-framework",
        default="auto",
        help="UI framework preference. Supported: auto, shadcn, ant-design-pro-echarts, product-design-decides. Default: auto.",
    )
    parser.add_argument(
        "--theme-source",
        help="Optional theme or brand source note, such as a color, logo, website, or screenshot reference.",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    project_name = infer_project_name(root, args.project_name)
    stage = infer_stage(root, args.stage)
    phase = infer_phase(args.phase)
    try:
        explicit_framework = normalize_ui_framework(args.ui_framework)
        product_scenario = infer_product_scenario(args.product_scenario, project_name, phase, root, explicit_framework)
        if not product_scenario:
            raise ValueError(
                "product scenario is unclear; rerun with --product-scenario admin-console, "
                "--product-scenario bi-dashboard, or --product-scenario consumer"
            )
        ui_framework = resolve_framework(product_scenario, explicit_framework)
    except ValueError as exc:
        parser.error(str(exc))

    design_dir = root / "design"
    design_dir.mkdir(exist_ok=True)

    stage_slug = slug(stage)

    input_path = design_dir / f"design-input-{stage_slug}.md"

    changes = []
    if ensure_design_doc_with_framework(root, project_name, stage, product_scenario, ui_framework):
        changes.append("created or updated DESIGN.md")
    if create_design_input(input_path, project_name, stage, phase, product_scenario, ui_framework, args.theme_source):
        changes.append(f"created {input_path.relative_to(root)}")
    if ensure_agents_link(root / "AGENTS.md"):
        changes.append("updated AGENTS.md")

    claude_path = root / "CLAUDE.md"
    if claude_path.exists() and ensure_agents_link(claude_path):
        changes.append("updated CLAUDE.md")

    if changes:
        print("Harness design scaffold changes:")
        for change in changes:
            print(f"- {change}")
    else:
        print("Harness design scaffold already present; no changes made.")

    print("\nVerification:")
    print(f"- design_dir={design_dir}")
    print(f"- design_doc={root / 'DESIGN.md'}")
    print(f"- design_input={input_path}")
    print(f"- agents={root / 'AGENTS.md'}")
    print(f"- product_scenario={SCENARIO_LABELS[product_scenario]}")
    print(f"- ui_framework={FRAMEWORK_LABELS[ui_framework]}")
    print(f"- theme_source={args.theme_source or 'default'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
