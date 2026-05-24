#!/usr/bin/env python3
"""Create project design governance scaffolding for my-harness-writing-design."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path


SKILL_DIR = Path(__file__).resolve().parents[1]
TEMPLATE_PATH = SKILL_DIR / "templates" / "DESIGN.admin-console.md"


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


def render_template(project_name: str, stage: str) -> str:
    template = TEMPLATE_PATH.read_text(encoding="utf-8")
    return template.replace("{{PROJECT_NAME}}", project_name).replace("{{STAGE}}", stage)


def create_blank_pen(path: Path, project_name: str, stage: str) -> bool:
    if path.exists():
        return False

    document = {
        "version": "2.11",
        "children": [
            {
                "type": "frame",
                "id": "blankDesignFrame",
                "x": 0,
                "y": 0,
                "name": f"{project_name} {stage} Blank Design Board",
                "clip": True,
                "width": 1440,
                "height": 900,
                "fill": "#f5f5f5",
                "layout": "none",
                "children": [],
            }
        ],
    }
    path.write_text(json.dumps(document, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return True


def create_pencil_input(path: Path, project_name: str, stage: str, phase: str) -> bool:
    if path.exists():
        return False

    content = f"""# {project_name} {stage} Pencil 原型输入文档

状态：DRAFT_FOR_PENCIL
适用阶段：{stage}
设计对象：{phase}
界面类型：企业级后台管理系统 / Admin Console

## 1. 设计目标

- 说明本阶段要跑通的主路径。
- 说明目标用户、关键操作和成功标准。
- 保持 Ant Design-compatible，不做营销页或装饰性 Dashboard。

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
- Ant Design component mapping
- Table columns
- Filter fields
- Toolbar actions
- Row actions
- Drawer / Modal interactions
- Form fields
- Permission rules
- Loading / Empty / Error states
- Implementation notes
"""
    path.write_text(content, encoding="utf-8")
    return True


def ensure_design_doc(root: Path, project_name: str, stage: str) -> bool:
    path = root / "DESIGN.md"
    if path.exists():
        return False
    path.write_text(render_template(project_name, stage), encoding="utf-8")
    return True


def ensure_agents_link(path: Path) -> bool:
    section = """\n## 设计规范\n\n- 项目级 UI/UX 规则见 `DESIGN.md`。\n- Pencil 原型、截图和设计说明统一放在 `design/`。\n- 开始前端实现前，必须先检查 `DESIGN.md` 和 `design/`。\n- 已确认 Pencil 原型优先于临场自由重设计；如需偏离，先说明原因并获得确认。\n"""

    if path.exists():
        text = path.read_text(encoding="utf-8", errors="ignore")
        if "DESIGN.md" in text and "design/" in text:
            return False
        path.write_text(text.rstrip() + "\n" + section, encoding="utf-8")
        return True

    path.write_text("# 项目 AI 开发规范\n" + section, encoding="utf-8")
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description="Create project design governance scaffold.")
    parser.add_argument("--root", default=".", help="Project root. Default: current directory.")
    parser.add_argument("--project-name", help="Project display name. Default: directory name.")
    parser.add_argument("--stage", help="Project phase/version, such as v0.1.0.")
    parser.add_argument("--phase", help="Design phase slug, such as admin-console.")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    project_name = infer_project_name(root, args.project_name)
    stage = infer_stage(root, args.stage)
    phase = infer_phase(args.phase)

    design_dir = root / "design"
    design_dir.mkdir(exist_ok=True)

    project_slug = slug(project_name)
    stage_slug = slug(stage)
    phase_slug = slug(phase)

    pen_path = design_dir / f"{project_slug}-{stage_slug}-{phase_slug}.pen"
    input_path = design_dir / f"pencil-input-{stage_slug}.md"

    changes = []
    if ensure_design_doc(root, project_name, stage):
        changes.append("created DESIGN.md")
    if create_blank_pen(pen_path, project_name, stage):
        changes.append(f"created {pen_path.relative_to(root)}")
    if create_pencil_input(input_path, project_name, stage, phase):
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
    print(f"- pen_file={pen_path}")
    print(f"- pencil_input={input_path}")
    print(f"- agents={root / 'AGENTS.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
