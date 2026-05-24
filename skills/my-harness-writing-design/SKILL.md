---
name: my-harness-writing-design
description: Use when a project needs initial design requirements, a DESIGN.md baseline, a design directory, Pencil prototype starter files, or AGENTS.md links to design governance
---

# My Harness Writing Design

## Purpose

Create the design-governance starting point for the current project before product/UI implementation begins. The default baseline is an Ant Design-compatible Admin Console style derived from `feishu-iam`.

## Before Editing

1. Read project governance first: `AGENTS.md`, `CLAUDE.md`, README, and existing docs.
2. Inspect existing `design/`, `DESIGN.md`, Pencil files, screenshots, and design notes.
3. Preserve existing project rules. Merge design governance; do not overwrite unrelated instructions.
4. If the project already has `AGENTS.md` and `CLAUDE.md` as synchronized governance files, keep relevant design references synchronized.

## Tool and Dependency Declarations

This skill is explicitly allowed to use design-specific tools and skills when available. Prefer specialized tools over hand-written approximations.

Pencil dependencies:

- Invoke the `pencil-design` skill when creating or iterating visual prototypes, mockups, app screens, or `.pen` assets.
- Use Pencil App / Pencil MCP tools for `.pen` documents when available, especially for opening, editing, validating, exporting, or inspecting existing Pencil files.
- Use the Pencil CLI when the task needs a generated `.pen` file or exported image and CLI auth is available.
- Do not treat a blank starter `.pen` as an approved prototype. It is only a placeholder until generated or reviewed through Pencil.

Ant Design dependencies:

- Use Ant Design as the default component and interaction baseline for Admin Console / enterprise backend projects.
- If an Ant Design skill, CLI helper, design-system checker, or project-local Ant Design guideline exists, invoke it before finalizing component mappings.
- If no local Ant Design helper exists, use the project's installed Ant Design version, existing code, or official Ant Design documentation as the source for component names and patterns.
- Do not invent a custom design system when Ant Design has a standard component that fits the pattern.

Recommended order:

1. Read project governance and existing design assets.
2. Check Pencil availability (`pencil-design` skill, Pencil MCP, or Pencil CLI) if `.pen` assets are needed.
3. Check Ant Design availability (project dependency, local guideline, skill, CLI, or docs) before writing component mappings.
4. Create or update `DESIGN.md`, `design/`, Pencil starter/assets, and governance links.

## Required Outputs

In the target project root:

- `design/` directory exists.
- A blank Pencil starter file exists under `design/`.
- `DESIGN.md` exists and describes project-level UI/UX requirements.
- `AGENTS.md` links to `DESIGN.md` and tells agents to inspect `design/` before frontend work.

Recommended optional output:

- `design/pencil-input-<stage>.md` describing the current project phase and prototype scope.

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
python3 /Users/wenzhewang/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py
```

Useful options:

```bash
python3 /Users/wenzhewang/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --stage v0.1.0 --phase admin-console
python3 /Users/wenzhewang/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --project-name feishu-iam --stage v0.1.0 --phase admin-console
```

The script is conservative: it creates missing files and appends a design-governance section to `AGENTS.md`; it does not overwrite existing `DESIGN.md` or `.pen` files unless explicitly extended later.

## DESIGN.md Baseline

Use `templates/DESIGN.admin-console.md` as the default content. Adapt these fields before finalizing:

- project name
- product type
- target users
- current phase/version
- required pages
- role/permission examples
- technology stack if already chosen

Keep the core principles unless the project clearly is not an enterprise backend tool:

- table-first CRUD
- Ant Design component mapping
- compact enterprise information density
- complete states: loading, empty, error, no permission, validation, confirmation
- Pencil prototype as implementation input
- Playwright visual QA before claiming frontend completion

## AGENTS.md Link

Add or merge a short section like:

```markdown
## 设计规范

- 项目级 UI/UX 规则见 `DESIGN.md`。
- Pencil 原型、截图和设计说明统一放在 `design/`。
- 开始前端实现前，必须先检查 `DESIGN.md` 和 `design/`。
- 已确认 Pencil 原型优先于临场自由重设计；如需偏离，先说明原因并获得确认。
```

If `CLAUDE.md` mirrors `AGENTS.md`, apply the same change there and verify both files remain aligned.

## Pencil Starter

Prefer creating a real blank Pencil document through available Pencil tooling. If only a filesystem starter is needed, create a minimal blank `.pen` with one 1440x900 frame and no UI elements. Do not treat the blank file as an approved prototype.

When Pencil tooling is unavailable, say so clearly in the final result and mark the starter as a placeholder requiring Pencil follow-up.

## Completion Check

Before reporting done:

- `test -d design`
- `test -f DESIGN.md`
- `find design -maxdepth 1 -name '*.pen' -print`
- `rg -n "DESIGN.md|design/" AGENTS.md`
- Record whether Pencil tooling and Ant Design references were available and used.
- If `CLAUDE.md` exists and is expected to mirror `AGENTS.md`, verify the design section is present there too.

## Common Mistakes

- Creating `DESIGN.md` but forgetting to link it from `AGENTS.md`.
- Overwriting existing governance files instead of merging.
- Creating screenshots without a `.pen` source.
- Hand-editing or guessing around Pencil when Pencil-specific tools are available.
- Writing Ant Design component mappings without checking project dependencies, existing code, or available Ant Design references.
- Starting frontend implementation before design requirements and prototype scope are written.
- Copying `feishu-iam` domain rules, such as Feishu-only auth, into unrelated projects. Reuse its UI/UX baseline, not its product-specific identity rules.
