---
name: my-harness-writing-design
description: Use when a project needs initial design requirements, a DESIGN.md baseline, a design directory, Pencil prototype starter files, or AGENTS.md links to design governance
---

# My Harness Writing Design

## Purpose

Create the design-governance starting point for the current project before product/UI implementation begins. The default baseline is a shadcn/ui-compatible Admin Console style using tweakcn as the default theme/style reference.

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

UI framework selection:

- Supported UI frameworks are only `ant-design` and `shadcn`.
- If the user does not explicitly prefer a UI framework, choose `shadcn`.
- If the user explicitly prefers Ant Design, antd, or Ant, choose `ant-design`.
- If the user explicitly prefers shadcn or shadcn/ui, choose `shadcn`.
- If the user explicitly asks for any other frontend UI framework, directly refuse that framework request and say this skill currently supports only Ant Design and shadcn/ui.
- Do not silently map unsupported preferences such as Material UI, Chakra UI, Arco Design, Element Plus, Bootstrap, Tailwind UI, Radix-only, or a custom design system into either supported framework.
- For a zero-to-one Admin Console with no strong user preference, choose `shadcn` and use tweakcn as the default shadcn theme/style reference.
- If the user explicitly chooses Ant Design for a zero-to-one Admin Console but gives no strong theme preference, use Ant Design Pro as the default admin framework/layout/style reference.

Ant Design dependencies and style:

- Use Ant Design when the user explicitly chooses it as the component and interaction baseline for Admin Console / enterprise backend projects.
- Preserve Ant Design default style by default: use Ant Design Pro's admin layout/page-template style, official token system, and default blue primary direction unless the project already has a confirmed brand theme.
- If an Ant Design skill, CLI helper, design-system checker, or project-local Ant Design guideline exists, invoke it before finalizing component mappings.
- If no local Ant Design helper exists, use the project's installed Ant Design version, existing code, or official Ant Design documentation as the source for component names and patterns.
- Do not invent a custom design system when Ant Design has a standard component that fits the pattern.

shadcn/ui dependencies and style:

- Use shadcn/ui by default unless the user explicitly chooses Ant Design.
- Treat shadcn/ui as open component code plus a code-distribution workflow, not as a sealed component library.
- Preserve shadcn/ui beautiful defaults and use tweakcn as the default theme/style source for zero-to-one Admin Console work when no stronger brand direction exists.
- Use the project's existing shadcn/ui setup if present. If no setup exists, reference official shadcn/ui docs for component names, token conventions, and CLI install patterns.
- Do not combine shadcn/ui with Ant Design or another UI framework in the same design baseline unless the user explicitly asks for a migration/interop plan.

Theme and brand inference:

- If the user names a theme color, provides a website, uploads a logo, shares screenshots, or links brand material, analyze that material before finalizing the design baseline.
- Extract dominant colors, accent colors, neutral/background direction, saturation, contrast, typography mood, density, and any obvious industry/brand tone.
- For Ant Design, map the result to Ant Design token decisions such as `colorPrimary`, functional colors, page background, border/radius direction, and whether to stay on Ant Design Pro default blue.
- For shadcn/ui, map the result to a tweakcn-compatible theme decision: use an appropriate preset family when it fits, or define a custom CSS-variable token set when no preset is a good match.
- If the material is visually noisy or unsuitable for backend work, keep the admin console conservative and use only the strongest safe brand accent.
- Always record the theme source and decision in `DESIGN.md` or `design/pencil-input-<stage>.md`.

Recommended order:

1. Read project governance and existing design assets.
2. Check Pencil availability (`pencil-design` skill, Pencil MCP, or Pencil CLI) if `.pen` assets are needed.
3. Resolve UI framework preference using the supported-framework rule above.
4. Check selected framework availability (project dependency, local guideline, skill, CLI, or docs) before writing component mappings.
5. Inspect theme/color/material inputs if provided, including websites, logos, screenshots, or explicit color names.
6. Create or update `DESIGN.md`, `design/`, Pencil starter/assets, and governance links.

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
python3 ~/.codex/skills/my-harness-writing-design/scripts/harness_write_design.py --ui-framework shadcn --stage v0.1.0 --phase admin-console
```

The script is conservative: it creates missing files and appends a design-governance section to `AGENTS.md`; it does not overwrite existing `DESIGN.md` or `.pen` files unless explicitly extended later.

## DESIGN.md Baseline

Use `templates/DESIGN.shadcn-admin-console.md` as the default shadcn/ui content. Use `templates/DESIGN.admin-console.md` only when the user explicitly prefers Ant Design. Adapt these fields before finalizing:

- project name
- product type
- target users
- current phase/version
- required pages
- role/permission examples
- technology stack if already chosen

Keep the selected framework's core principles unless the project clearly is not an enterprise backend tool.

Ant Design default principles:

- table-first CRUD
- Ant Design Pro admin console layout/style for zero-to-one projects
- Ant Design component mapping
- compact enterprise information density
- complete states: loading, empty, error, no permission, validation, confirmation
- Pencil prototype as implementation input
- Playwright visual QA before claiming frontend completion

shadcn/ui selected principles:

- open-code component ownership
- tweakcn as the default shadcn theme/style reference for zero-to-one Admin Console projects
- composition-first UI built from shadcn/ui primitives and project-level wrappers
- Tailwind CSS variables and semantic tokens
- clean minimal beautiful defaults instead of heavy enterprise chrome
- explicit accessibility, focus, keyboard, empty/loading/error states
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
- Record which UI framework was selected and why.
- Record which admin layout/style reference was selected: Ant Design Pro for Ant Design, tweakcn for shadcn/ui.
- Record theme/material source and inferred theme decision when the user provides colors, logo, website, screenshots, or brand material.
- Record whether Pencil tooling and selected-framework references were available and used.
- If `CLAUDE.md` exists and is expected to mirror `AGENTS.md`, verify the design section is present there too.

## Common Mistakes

- Creating `DESIGN.md` but forgetting to link it from `AGENTS.md`.
- Overwriting existing governance files instead of merging.
- Creating screenshots without a `.pen` source.
- Hand-editing or guessing around Pencil when Pencil-specific tools are available.
- Accepting unsupported UI framework preferences instead of refusing them.
- Defaulting to Ant Design when the user has not explicitly asked for it.
- Writing component mappings without checking project dependencies, existing code, or selected-framework references.
- Mixing Ant Design and shadcn/ui in a single baseline without explicit migration/interop scope.
- Ignoring user-provided theme colors, websites, logos, screenshots, or brand assets.
- Copying a brand website's marketing layout into an Admin Console instead of extracting safe color/token direction.
- Starting frontend implementation before design requirements and prototype scope are written.
- Copying `feishu-iam` domain rules, such as Feishu-only auth, into unrelated projects. Reuse its UI/UX baseline, not its product-specific identity rules.
