---
name: my-harness-initialize-project
description: Use when initializing a new or empty project repository with baseline governance, README direction, AGENTS.md rules, design/deployment links, and a first harness next-action handoff
---

# My Harness Initialize Project

## Purpose

Initialize a new or mostly empty project so later harness steps have clear governance, artifacts, and routing.

This skill is for project bootstrap. It creates or strengthens the minimum project-facing documents, then hands off to the normal harness loop. It does not replace Discovery / Brainstorm, design review, engineering review, implementation planning, QA, release, or deploy gates.

If the target project is blank or has not yet started using `my-harness`, and the user explicitly asks to use the `my-harness` framework/process, the first harness handoff must be step 1 Superpowers `brainstorming`. Initialization may create governance files, but it must not become a substitute for clarifying the requirements.

## When To Use

Use this skill when:

- The user asks to initialize a new repository or blank project.
- The project has little or no `README.md`, `AGENTS.md`, `CLAUDE.md`, `DESIGN.md`, `DEPLOY.md`, or project structure guidance.
- The user wants a starter governance baseline before implementation.
- The user asks for a repeatable first setup path for future agents.

Do not use this skill to update the installed `my-harness` plugin. Use `my-harness-upgrade` for that.

## Before Editing

1. Inspect the target project root with `pwd`, `git status --short`, and `rg --files`.
2. Read existing `AGENTS.md`, `CLAUDE.md`, `README.md`, `DESIGN.md`, `DEPLOY.md`, and docs before writing.
3. Preserve existing project-specific rules. Merge missing governance; do not overwrite meaningful content.
4. If the user explicitly says "先不要修改代码" or only asks for docs, create documentation only.
5. If the project is not empty, keep edits scoped to missing initialization gaps.

## Required Outputs

At minimum, the target project should have:

- `README.md` with project purpose, local run direction, and current status if known.
- `AGENTS.md` with project-specific agent rules, language preference, verification expectations, and links to design/deployment docs when present.
- A clear next-action handoff that points to the correct harness step.

Recommended when relevant:

- `DESIGN.md` and `design/` through `my-harness-writing-design` for UI/product work.
- `DEPLOY.md` through `my-harness-writing-deployment` for production or Docker/Compose projects.
- `docs/` for project history, architecture notes, or maintenance notes when the project needs durable context.
- `.env.example` only when the stack and required variables are already clear; never invent secrets.
- For projects already using `my-harness`, an optional `.my-harness/` quick index that links to execution evidence without moving third-party artifacts.

## Initialization Flow

1. Classify the project:
   - blank repository
   - documentation-only starter
   - frontend app
   - backend/API service
   - full-stack/product app
   - deployment-focused service
2. Preserve existing rules and files.
3. Create or update `README.md` with:
   - project name
   - purpose
   - current status
   - local development command placeholders only when unknown
   - verification command placeholders only when unknown
4. Create or update `AGENTS.md` with:
   - Chinese communication/documentation default unless project rules say otherwise
   - read `README.md`, `DESIGN.md`, and `DEPLOY.md` before relevant work
   - do not overwrite user changes
   - run fresh verification before claiming completion
   - no push, PR, tag, release, or deploy without explicit authorization
5. If UI/product/chart/app work is in scope and `DESIGN.md` is missing, invoke or recommend `my-harness-writing-design` before any design review, frontend planning, implementation, or visual QA.
6. If deployment/release infrastructure is in scope, invoke or recommend `my-harness-writing-deployment`.
7. If this is a blank or not-started project and the user explicitly asked for `my-harness`, make the next gate step 1 Superpowers `brainstorming`, with a prompt to clarify target user, problem, constraints, success criteria, smallest worthwhile slice, non-goals, risks, and candidate approaches.
8. For a project that already has `my-harness` progress, optionally create or update `.my-harness/index.md` as a quick index of step status, decisions, artifact links, verification commands, and next prompts.
9. Finish with a `my-harness-next-action` style handoff: current SOP status, next gate, and a copyable recommended prompt.

## Conservative Write Rules

- Create missing files when the project is blank or the user asked for initialization.
- Append or merge short sections into existing docs.
- Do not delete or rewrite existing docs wholesale.
- Do not choose a framework, database, cloud provider, or UI kit unless the repo or user already indicates one.
- Do not create application code unless the user explicitly asks for implementation.
- Do not create secrets, credentials, private endpoints, or real production config values.
- Do not move Superpowers, gstack, Product Design, Pencil, deployment, or release artifacts into `.my-harness/`; keep them in their native paths and index them only.

## Completion Check

Before reporting done:

```bash
test -f README.md
test -f AGENTS.md
rg -n "DESIGN.md|DEPLOY.md|verification|验证|发布|release" AGENTS.md README.md
git status --short
```

If `.my-harness/` was created or updated, also check that it contains only links, short summaries, step status, decisions, and handoff notes, and that the referenced third-party artifacts remain in their native paths.

If design or deployment initialization was included, also run the completion checks from `my-harness-writing-design` or `my-harness-writing-deployment`.

## Recommended Output

```markdown
初始化结果：
- README.md: created / updated / preserved
- AGENTS.md: created / updated / preserved
- DESIGN.md / design/: created / not needed / next step
- DEPLOY.md: created / not needed / next step

下一步：
应使用：`my-harness-next-action`
原因：...
推荐提示词：
> ...
```

## Common Mistakes

- Treating initialization as permission to implement the whole app.
- Inventing stack decisions in an empty repository.
- Handing a blank project that explicitly requested `my-harness` directly to implementation, Product Design, or `writing-plans` instead of step 1 Superpowers `brainstorming`.
- Skipping `AGENTS.md`, leaving future agents without project rules.
- Creating design or deployment docs without linking them from governance.
- Treating `.my-harness/` as the home for third-party documents instead of a quick index.
- Claiming the project is ready without a fresh file/status check.
