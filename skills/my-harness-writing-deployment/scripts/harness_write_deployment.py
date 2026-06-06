#!/usr/bin/env python3
"""Create project deployment governance scaffolding for my-harness-writing-deployment."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path


SKILL_DIR = Path(__file__).resolve().parents[1]
TEMPLATE_PATH = SKILL_DIR / "templates" / "DEPLOY.md"


def run(cmd: list[str], cwd: Path) -> str:
    try:
        return subprocess.check_output(cmd, cwd=cwd, text=True, stderr=subprocess.DEVNULL).strip()
    except Exception:
        return ""


def infer_project_name(root: Path, explicit: str | None) -> str:
    return explicit or root.name


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
            version = json.loads(package_json.read_text(encoding="utf-8")).get("version")
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

    version_file = root / "VERSION"
    if version_file.exists():
        version = version_file.read_text(encoding="utf-8", errors="ignore").strip()
        if version:
            return version if version.startswith("v") else f"v{version}"

    return "v0.1.0"


def render_template(project_name: str, stage: str) -> str:
    template = TEMPLATE_PATH.read_text(encoding="utf-8")
    return template.replace("{{PROJECT_NAME}}", project_name).replace("{{STAGE}}", stage)


def ensure_deploy_doc(root: Path, project_name: str, stage: str) -> bool:
    path = root / "DEPLOY.md"
    if path.exists():
        return False
    path.write_text(render_template(project_name, stage), encoding="utf-8")
    return True


def ensure_governance_link(path: Path) -> bool:
    required_lines = [
        "- 项目级部署和升级规则见 `DEPLOY.md`。",
        "- 项目开发过程中和最终部署过程中，必须严格执行 `DEPLOY.md`。",
        "- 修改 `Dockerfile`、`docker-compose*.yml`、`install.sh`、`upgrade.sh`、`.env.example`、数据库 schema、初始化 SQL、迁移 SQL、release 版本或部署目录前，必须先检查 `DEPLOY.md`。",
        "- 如果项目缺少 `install.sh` 或 `upgrade.sh`，必须先补齐对应脚本，不能把手工部署步骤当作完成状态。",
        "- 每次版本升级和发布前，必须校验 `install.sh` 和 `upgrade.sh` 的逻辑。",
        "- 正式部署以版本为最小管理颗粒度；不得使用 `latest`、未固定镜像 tag 或任意脏状态升级。",
        "- 如实现需要偏离 `DEPLOY.md`，先更新 `DEPLOY.md` 并说明原因，再修改实现。",
    ]
    section = "\n## 部署与升级规范\n\n" + "\n".join(required_lines) + "\n"

    if path.exists():
        text = path.read_text(encoding="utf-8", errors="ignore")
        if "DEPLOY.md" in text and "部署与升级规范" in text:
            missing = [line for line in required_lines if line not in text]
            if not missing:
                return False
            supplement = "\n\n### 部署与升级规范补充\n\n" + "\n".join(missing) + "\n"
            path.write_text(text.rstrip() + supplement, encoding="utf-8")
            return True
        path.write_text(text.rstrip() + "\n" + section, encoding="utf-8")
        return True

    path.write_text("# 项目 AI 开发规范\n" + section, encoding="utf-8")
    return True


def ensure_deploy_dirs(root: Path) -> list[str]:
    created: list[str] = []
    for relative in ["deploy", "deploy/db/init", "deploy/db/migrations", "deploy/config"]:
        path = root / relative
        if not path.exists():
            path.mkdir(parents=True, exist_ok=True)
            created.append(relative)
    return created


def main() -> int:
    parser = argparse.ArgumentParser(description="Create project deployment governance scaffold.")
    parser.add_argument("--root", default=".", help="Project root. Default: current directory.")
    parser.add_argument("--project-name", help="Project display name. Default: directory name.")
    parser.add_argument("--stage", help="Project phase/version, such as v0.1.0.")
    parser.add_argument(
        "--create-deploy-dirs",
        action="store_true",
        help="Also create deploy/, deploy/db/init/, deploy/db/migrations/, and deploy/config/ if missing.",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    project_name = infer_project_name(root, args.project_name)
    stage = infer_stage(root, args.stage)

    changes = []
    if ensure_deploy_doc(root, project_name, stage):
        changes.append("created DEPLOY.md")
    if ensure_governance_link(root / "AGENTS.md"):
        changes.append("updated AGENTS.md")
    if ensure_governance_link(root / "CLAUDE.md"):
        changes.append("updated CLAUDE.md")
    if args.create_deploy_dirs:
        for relative in ensure_deploy_dirs(root):
            changes.append(f"created {relative}/")

    if changes:
        print("Harness deployment scaffold changes:")
        for change in changes:
            print(f"- {change}")
    else:
        print("Harness deployment scaffold already present; no changes made.")

    print("\nVerification:")
    print(f"- deploy_doc={root / 'DEPLOY.md'}")
    print(f"- agents={root / 'AGENTS.md'}")
    print(f"- claude={root / 'CLAUDE.md'}")
    print(f"- install_sh_exists={(root / 'install.sh').exists() or (root / 'scripts' / 'install.sh').exists()}")
    print(f"- upgrade_sh_exists={(root / 'upgrade.sh').exists() or (root / 'scripts' / 'upgrade.sh').exists()}")
    print(f"- stage={stage}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
