---
name: my-harness-writing-design
description: Use when a project needs initial design requirements, a DESIGN.md baseline, a design directory, Pencil prototype starter files, or AGENTS.md links to design governance
---

# My Harness Writing Design

## Purpose

Create the design-governance starting point for the current project before product/UI implementation begins. The default and only active Admin Console baseline is a shadcn/ui-compatible style using tweakcn as the default theme/style reference.

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

Product Design optional dependency:

- Product Design is not required for this skill or for `my-harness`.
- If Product Design is installed, `my-harness-product-design-bridge` may be used to create a visual target before Pencil work, seed a Pencil draft from a selected ImageGen option, or produce `design-qa.md` as supporting evidence before `gstack /design-review`.
- If Product Design is unavailable, do not ask the user to install it; continue with the original Pencil-centered design governance.
- Product Design outputs must be recorded under `design/` or referenced from `DESIGN.md` / `design/pencil-input-<stage>.md` before they influence implementation.
- Product Design outputs do not replace `.pen` source files, exported Pencil screenshots, or project-level `DESIGN.md` unless the project explicitly adopts a different design governance rule.

UI framework selection:

- Supported UI framework is `shadcn` / shadcn/ui only.
- If the user does not explicitly prefer a UI framework, choose `shadcn`.
- If the user explicitly prefers shadcn or shadcn/ui, choose `shadcn`.
- If the user explicitly asks for Ant Design, antd, Ant, or any other frontend UI framework, directly refuse that framework request and say this skill currently supports only shadcn/ui.
- Do not silently map unsupported preferences such as Ant Design, Material UI, Chakra UI, Arco Design, Element Plus, Bootstrap, Tailwind UI, Radix-only, or a custom design system into shadcn/ui.
- For a zero-to-one Admin Console with no strong user preference, choose `shadcn` and use tweakcn as the default shadcn theme/style reference.

shadcn/ui dependencies and style:

- Use shadcn/ui by default and for all new Admin Console design baselines.
- Treat shadcn/ui as open component code plus a code-distribution workflow, not as a sealed component library.
- Preserve shadcn/ui beautiful defaults and use tweakcn as the default theme/style source for zero-to-one Admin Console work when no stronger brand direction exists.
- Use the project's existing shadcn/ui setup if present. If no setup exists, reference official shadcn/ui docs for component names, token conventions, and CLI install patterns.
- Treat shadcn MCP as an important optional implementation aid for browsing, searching, and installing shadcn registry items. Prefer it when configured, but never make it a required dependency for `my-harness`.
- If Codex does not have shadcn MCP configured, do not block the design flow. Fall back to shadcn CLI, official docs, and existing project components.
- Do not silently modify global Codex MCP configuration. If a task requires adding shadcn MCP to `~/.codex/config.toml`, get explicit user authorization first.
- When shadcn MCP or CLI is used, inspect project `components.json`, aliases, style, Tailwind config, registries, and installed components before adding new code.
- Do not combine shadcn/ui with Ant Design or another UI framework in the same design baseline unless the user explicitly asks for a migration/interop plan outside this skill's normal baseline.

shadcn/ui implementation constraints:

- Prioritize shadcn/ui components, existing project components, and existing shadcn code blocks.
- Use Tailwind CSS, CSS variables, and project design tokens; do not introduce another UI framework.
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
- Always record the theme source and decision in `DESIGN.md` or `design/pencil-input-<stage>.md`.

Recommended order:

1. Read project governance and existing design assets.
2. Check Pencil availability (`pencil-design` skill, Pencil MCP, or Pencil CLI) if `.pen` assets are needed.
3. If Product Design is available and the UI scope lacks a visual target, optionally route through `my-harness-product-design-bridge`; otherwise continue without it.
4. Resolve UI framework preference using the shadcn/ui-only rule above.
5. Check shadcn/ui availability (project dependency, local guideline, shadcn MCP, CLI, or docs) before writing component mappings.
6. Inspect theme/color/material inputs if provided, including websites, logos, screenshots, or explicit color names.
7. Create or update `DESIGN.md`, `design/`, Pencil starter/assets, and governance links.

## Required Outputs

In the target project root:

- `design/` directory exists.
- A blank Pencil starter file exists under `design/`.
- `DESIGN.md` exists and describes project-level UI/UX requirements.
- `AGENTS.md` links to `DESIGN.md` and tells agents to inspect `design/` before frontend work.

Recommended optional output:

- `design/pencil-input-<stage>.md` describing the current project phase and prototype scope.
- Product Design selected visual targets, screenshots, links, or `design-qa.md` references under `design/` when that optional branch was used.

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

Use `templates/DESIGN.shadcn-admin-console.md` as the default and only Admin Console content. Adapt these fields before finalizing:

- project name
- product type
- target users
- current phase/version
- required pages
- role/permission examples
- technology stack if already chosen

Keep the selected framework's core principles unless the project clearly is not an enterprise backend tool.

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
- Pencil prototype as implementation input
- optional Product Design visual target as Pencil input, not as a replacement for Pencil governance
- Playwright visual QA across desktop/tablet/mobile before claiming frontend completion

## AGENTS.md Link

Add or merge a short section like:

```markdown
## 设计规范

- 项目级 UI/UX 规则见 `DESIGN.md`。
- Pencil 原型、截图和设计说明统一放在 `design/`。
- 如果使用 Product Design 生成视觉目标或 `design-qa.md`，对应图片、链接或说明也必须记录到 `design/`；未安装 Product Design 时直接走原 Pencil 流程。
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
- Record that shadcn/ui was selected and tweakcn was used as the Admin Console layout/style reference.
- Record whether shadcn MCP was available, used, unavailable, or intentionally skipped; if used, record the registry/components/blocks involved.
- Record theme/material source and inferred theme decision when the user provides colors, logo, website, screenshots, or brand material.
- Record whether Pencil tooling and selected-framework references were available and used.
- Record whether Product Design was used, unavailable, or intentionally skipped; if used, record where the selected visual target or `design-qa.md` evidence lives.
- If `CLAUDE.md` exists and is expected to mirror `AGENTS.md`, verify the design section is present there too.

## Common Mistakes

- Creating `DESIGN.md` but forgetting to link it from `AGENTS.md`.
- Overwriting existing governance files instead of merging.
- Creating screenshots without a `.pen` source.
- Treating Product Design as mandatory or requiring the user to install it before continuing.
- Using Product Design outputs without recording them in `design/`.
- Treating a Product Design visual or `design-qa.md` file as a replacement for Pencil, `DESIGN.md`, `gstack /design-review`, functional QA, or code review.
- Hand-editing or guessing around Pencil when Pencil-specific tools are available.
- Treating shadcn MCP as mandatory or blocking the workflow when it is unavailable.
- Silently editing `~/.codex/config.toml` to add shadcn MCP without explicit user authorization.
- Installing registry components through shadcn MCP or CLI without inspecting generated code, dependencies, tokens, and accessibility.
- Accepting unsupported UI framework preferences instead of refusing them.
- Using the retired Ant Design template or recommending Ant Design for new Admin Console work.
- Allowing button labels to wrap instead of treating the space as compact and changing the control pattern.
- Letting table action buttons resize rows, wrap, or lose a stable operation-column width.
- Putting long URLs, JSON, permission lists, errors, or IDs directly into tables without truncation, tooltip, copy, or detail placement.
- Using a narrow Sheet for heavy configuration, multi-tab editing, tree selection, batch binding, or complex permission workflows.
- Treating a page as complete without checking 390px mobile, console errors, unexpected Network failures, and responsive overflow.
- Writing component mappings without checking project dependencies, existing code, or selected-framework references.
- Mixing Ant Design and shadcn/ui in a single baseline without explicit migration/interop scope.
- Ignoring user-provided theme colors, websites, logos, screenshots, or brand assets.
- Copying a brand website's marketing layout into an Admin Console instead of extracting safe color/token direction.
- Starting frontend implementation before design requirements and prototype scope are written.
- Copying `feishu-iam` domain rules, such as Feishu-only auth, into unrelated projects. Reuse its UI/UX baseline, not its product-specific identity rules.
