---
name: my-harness-autopilot-slice
description: Use when a small, clearly bounded project slice should be advanced through the user's harness loop after Discovery or Brainstorm scope has already been finalized
---

# My Harness Autopilot Slice

## Purpose

Run one small, clearly bounded version slice through the existing `my-harness` SOP in one conversation. This skill repeatedly uses the current `my-harness-next-action` result as the next step's input until the slice is finished or a human handoff gate is reached.

This is an autopilot for narrow execution, not a replacement for product judgment.

## Hard Start Gates

Refuse to start unless all are true:

1. Discovery / Brainstorm gate is already finalized for this task or version slice through `gstack /office-hours`, Superpowers `brainstorming`, or equivalent project evidence.
2. The current slice has a clear boundary, success criteria, and non-goals.
3. The task is small enough to finish without repeated product decisions.
4. Project governance is readable: `AGENTS.md`, `CLAUDE.md`, README, or equivalent docs.
5. The user explicitly asks to run the closed loop/autopilot, not just "what next?"

Refuse if any are true:

- The request is a large version, unclear product direction, broad redesign, multi-subsystem project, or ambiguous roadmap item.
- The project is blank or has not started the `my-harness` loop, and the user explicitly asks to use the `my-harness` framework/process. The correct next action is step 1 Superpowers `brainstorming`, not autopilot.
- The implementation likely needs frequent human decisions.
- The task requires external credentials, production authorization, paid services, manual UI design approval, or unavailable tools before meaningful progress can continue.
- The first required action is still Discovery / Brainstorm gate, product definition, opportunity validation, or open-ended design discovery.

When refusing, state the blocking reason and recommend `my-harness-next-action` or the specific missing planning step.

For the explicit blank/not-started `my-harness` case, recommend Superpowers `brainstorming` to clarify target user, problem, constraints, success criteria, smallest worthwhile slice, non-goals, risks, and candidate approaches.

## Workflow

1. Read project governance and existing artifacts.
2. Confirm Discovery / Brainstorm evidence and scope clarity.
3. Invoke/apply `my-harness-next-action` to classify current state.
4. Execute exactly the recommended next harness action.
5. Re-run `my-harness-next-action`.
6. Continue until complete, refused, blocked, or handed off.

Do not skip gates. Adjacent steps may be executed as a documented phase work package only when `my-harness-next-action` recommends that package and the final evidence table still records each canonical step separately.

If the Discovery / Brainstorm evidence came from Superpowers `brainstorming`, do not treat that as permission to start at `writing-plans` or implementation. The loop must still pass through Product Design planning review, `DESIGN.md`-governed design artifact planning when needed, and `plan-eng-review` before `writing-plans`, unless the slice is extremely simple and the skip reasons for both review gates are explicit.

Product Design focused skills replace gstack `/plan-design-review` and `/design-review` for UI design gates when available. Autopilot may use Product Design focused skills directly when the current UI slice needs planning review, at least three prototype/visual directions, image/url-to-code scaffolding, or visual-fidelity QA evidence. If Product Design is unavailable, do not require installation and continue with the selected design baseline, existing references, screenshots, or optional Pencil for complex human alignment.

For projects already using `my-harness`, autopilot may create or update `.my-harness/` as a quick execution index while it runs. Keep third-party artifacts in native paths: Superpowers plans in `docs/superpowers/` or `IMPLEMENTATION_PLAN.md`, Product Design/Pencil evidence in `design/`, gstack reports in their report directories, deployment governance in `DEPLOY.md`, and release material in project release docs. `.my-harness/` may store links, short summaries, step status, decisions, verification commands, loop metrics, and handoff prompts, but not secrets, copied long reports, or conflicting source-of-truth instructions.

## Codex-Safe Gstack Gate Rule

Codex cannot reliably handle `AskUserQuestion` inside several gstack skills. When autopilot reaches gstack `/office-hours`, `/plan-design-review`, `/plan-eng-review`, `/design-review`, `/qa`, `/review`, `/ship`, `/land-and-deploy`, `/canary`, or any other gstack skill that may ask the user interactively:

- Follow the gstack reasoning flow, but do not enter Plan mode.
- Do not call `AskUserQuestion`, `request_user_input`, or any interactive choice tool.
- Convert every interaction gate into a Markdown decision gate.
- Number decisions as `D1`, `D2`, `D3`.
- Present each decision in a table with options, recommended option, pros, cons, and scope/impact.
- Stop and wait when the user must decide; do not continue into the next harness step.
- Unless the user explicitly asks for edits, keep the step read-only and do not modify project files.
- Make the output structured, clear, and suitable for copying into documentation.

If a gstack step needs a human decision, that Markdown decision gate is the autopilot stopping point. Mark the relevant row as `🎯 当前下一步`, include the decision table under `需要人工决定`, and provide a copyable prompt for continuing after the user chooses.

## Step-Specific Rules

### Design Artifact Gates

If the next action requires a design artifact, visual target, optional Pencil prototype, or meaningful visual design:

1. Use `my-harness-writing-design` to create or verify `DESIGN.md`, `design/`, and starter files before any UI planning, prototype generation, implementation, or design QA.
2. Strictly apply `DESIGN.md` for typography, spacing, technology stack, components, chart libraries, tokens, responsive rules, states, and accessibility.
3. If the target system lacks a clear app/product title, logo, or favicon, use Creative Production `logo-explorer` before finalizing prototypes. Use an existing project/product name as provisional title; in target/autopilot mode, derive a conservative title from the repo/project name when no title exists. Record selected logo direction, favicon/app-icon direction, title, rejected routes, caveats, and asset paths under `design/`.
4. If Product Design is available and there is no visual target, use Product Design `get-context` -> `ideate` to generate at least three prototype/visual options and reach the next required human choice.
5. In target/autopilot mode, choose the Product Design system-recommended option only when the user has allowed automatic selection, and record the selected option plus rationale under `design/`.
6. Stop and hand off to the human for Creative Production route selection, Product Design option selection, optional Pencil confirmation, or design approval when automatic selection is not authorized.

Do not blindly run Pencil CLI or MCP to produce real design work unless the user explicitly asks in this turn, the module is complex enough to need human alignment, and the scope is small enough for this skill.

### Implementation Step

For step 7:

- Use `executing-plans` when the first vertical slice is strongly coupled or file boundaries are unclear.
- Use `subagent-driven-development` only when `IMPLEMENTATION_PLAN.md` has clear independent tasks, ownership, and non-overlapping write scopes.
- Before any implementation work, re-read and obey `AGENTS.md`, `CLAUDE.md`, README, `DESIGN.md`, `DEPLOY.md`, `IMPLEMENTATION_PLAN.md`, and relevant docs/runbooks. If local implementation pressure conflicts with governance, stop and resolve the conflict instead of drifting.
- When using `subagent-driven-development`, every subagent brief must include the relevant governance documents, allowed file boundaries, no-drift requirements for UI/UX/stack/tests/release rules, and a requirement to report compliance plus deviations.
- Before frontend implementation, read `DESIGN.md` and `design/`; do not implement UI that violates the recorded typography, spacing, stack, component, chart, token, responsive, state, or accessibility rules.
- Use Product Design `image-to-code` or `url-to-code` to cut the selected prototype/visual target into a frontend frame when `IMPLEMENTATION_PLAN.md` already exists, a selected visual target or source URL exists, and the work is limited to the first frontend vertical slice.
- If the selected prototype conflicts with shadcn/ui, Ant Design Pro, ECharts, or another project-approved third-party framework, use the framework's native components and `DESIGN.md` as implementation authority. Record accepted visual deviations instead of creating a parallel component system.
- Implement only the first vertical slice. Do not expand into later slices just because the loop is running.

### Review Loops

For Product Design visual QA / `design-review`, `qa`, and `review`, loop until findings are cleared or a stop condition fires:

1. Run the review/QA.
2. If findings exist, fix only in-scope findings.
3. Re-run the same review/QA.
4. Repeat until clear.

Maximum recursion: 10 iterations per review family.

If iteration 10 still has unresolved findings, stop and hand off to the human with:

- remaining findings
- attempted fixes
- likely blocker/root cause
- suggested next manual decision

For Product Design visual QA / design review, compare the rendered implementation against the selected prototype/visual target and `DESIGN.md` on every iteration. Fix meaningful visual, spacing, typography, component, chart, responsive, and state deviations until the result is highly faithful or the deviation is explicitly accepted.

Track review-loop metrics for each family:

- iterations run
- findings discovered
- findings fixed
- findings accepted/deferred by human
- findings remaining
- final status: cleared, accepted, blocked, or handed off

### Verification And Browser Step

Use `gstack /browse` first for browser verification. Use `open-gstack-browser` when visible real-time browser control or human observation is useful. Use Playwright when scripted regression coverage is needed.

### Git, Ship, Land, Deploy

Respect authorization boundaries:

- Do not push, create PRs, merge, tag, release, upload Docker images, or deploy unless the user has explicitly authorized that action.
- If authorization is missing, stop and present the exact proposed action.
- `ship` may prepare materials, but remote or release-changing actions require authorization.
- `land-and-deploy` requires explicit authorization before merge/release/deploy.

## Stop Conditions

Stop immediately and hand off when:

- Discovery / Brainstorm evidence is missing
- scope is too large or ambiguous
- Product Design visual-option selection, prototype selection, Pencil/design confirmation, or other UI approval is needed
- a gstack step reaches a decision point that would normally use `AskUserQuestion`
- a required tool/credential/service is unavailable
- the next action requires explicit user authorization
- a review loop reaches 10 iterations
- a test or runtime failure needs product/architecture judgment beyond the accepted slice
- local context contradicts the plan in a way that changes scope

## Final Summary Is Mandatory

Whether the loop completes, refuses to start, stops for handoff, or fails on a blocker, the final response must summarize every key step that was considered or executed.

Include:

- final outcome: completed, refused, handed off, blocked, or authorization required
- current stopping point
- current phase or phase work package when one was used
- the same `流程执行情况一览：` table shape used by `my-harness-next-action`
- one row for all 15 canonical harness steps, including skipped or inapplicable steps
- exactly one status icon per row, using the `my-harness-next-action` meanings
- a concise execution summary in `证据/原因` for each row
- review-loop metrics for `design-review`, `qa`, and `review` folded into the `证据/原因` text, even if the count is zero or not reached
- verification commands/tools run and their results
- files or artifacts created/changed
- Git state and authorization-sensitive actions that were not taken
- next human action, if any

Use these table statuses exactly:

| Icon | Judgment | Autopilot meaning |
|---|---|---|
| ✅ | 前置已完成 | Concrete evidence proves this step was already complete or was completed by this autopilot run. |
| ⏭️ | 前置无需进行 | This step is explicitly unnecessary, inapplicable, or intentionally skipped for this slice. |
| 🎯 | 当前下一步 | This is where autopilot stopped; it is the next action for handoff, blocker resolution, or required authorization. |
| ⚠️ | 证据不足 | The step is claimed or implied, but evidence is missing, stale, conflicting, or failed verification. |
| ⏳ | 待执行 | This step comes after the stopping point and was not reached. |

If the outcome is `completed` and all applicable gates are closed, do not mark any row as `🎯 当前下一步`; mark completed rows as `✅ 前置已完成` and inapplicable rows as `⏭️ 前置无需进行`, then state that the current slice is closed.

Do not use the older `关键步骤汇总` table. Do not include separate columns for iterations, findings discovered, fixed count, or handoff count. When a step is skipped or inapplicable, still include the row; mark it `⏭️ 前置无需进行`, and explain why in `证据/原因`.

## Required Output On Handoff Or Completion

Use this format:

````markdown
自动闭环结果：<completed/refused/handed-off/blocked/authorization-required>

停止点 / 完成点：
- ...

当前阶段 / 工作包：
- ...

流程执行情况一览：
| 状态 | 步骤 | Harness 动作 | 判断 | 证据/原因 |
|---|---:|---|---|---|
| ✅ | 1 | Discovery / Brainstorm gate | 前置已完成 | 范围已通过 ... 锁定为 ...；无循环。 |
| ⏭️ | 2 | Product Design planning review, fallback gstack `/plan-design-review` | 前置无需进行 | 当前切片不涉及新增产品/交互方向，按已批准范围执行。 |
| ⏭️ | 3 | Design artifact / visual target | 前置无需进行 | 当前切片不涉及 UI；无需新增设计制品。 |
| ⏭️ | 4 | Product Design review of selected design artifact, fallback gstack `/plan-design-review` | 前置无需进行 | 未创建新设计制品，因此无需设计制品复审。 |
| ✅ | 5 | gstack `/plan-eng-review` | 前置已完成 | 工程边界和测试策略已在 ... 锁定。 |
| ✅ | 6 | Superpowers `writing-plans` | 前置已完成 | `IMPLEMENTATION_PLAN.md` 覆盖文件路径、任务、测试和完成标准。 |
| ✅ | 7 | Superpowers `executing-plans` or `subagent-driven-development` | 前置已完成 | 已完成第一个 vertical slice，未扩展后续切片。 |
| ✅ | 8 | Superpowers `verification-before-completion` | 前置已完成 | 已运行 ...，结果通过。 |
| ✅ | 9 | gstack `/browse` verification, optional `open-gstack-browser`, Playwright fallback | 前置已完成 | 已运行 ...，覆盖主路径和关键状态。 |
| ✅ | 10 | Product Design visual QA / design review, fallback gstack `/design-review` | 前置已完成 | 循环 1 次，发现 0 个阻塞问题，无需修复。 |
| ✅ | 11 | gstack `/qa` | 前置已完成 | 循环 1 次，发现 2 个问题，已修复 2 个，无遗留。 |
| 🎯 | 12 | gstack `/review` | 当前下一步 | 循环 10 次后仍有 1 个高风险 finding，需要人工判断是否接受。 |
| ⏳ | 13 | Git closeout / `/ship` preflight | 待执行 | 停止点之后，未执行。 |
| ⏳ | 14 | gstack `/ship` | 待执行 | 停止点之后，未执行；未执行 push/PR/tag/release。 |
| ⏳ | 15 | gstack `/land-and-deploy` | 待执行 | 停止点之后，未执行；未执行 merge/release/deploy。 |

验证与证据：
- ...

文件 / 工件：
- ...

Git / 授权边界：
- ...

需要人工决定：
- ...

可复制的下一步提示词：
```text
...
```
````

## Completion Criteria

The slice is complete only when:

- `my-harness-next-action` reaches the final applicable gate or a project-approved stopping point.
- Fresh verification evidence exists.
- Relevant review/QA loops have cleared or were explicitly accepted by the human.
- Git state and authorization-sensitive actions are reported clearly.

## Common Mistakes

- Starting before the Discovery / Brainstorm gate has fixed the target.
- Starting autopilot on a blank or not-started project where the user explicitly asked to use the `my-harness` framework; that must begin with Superpowers `brainstorming`.
- Running autopilot on a large, unclear version.
- Treating starter design files or blank Pencil files as approved design.
- Starting frontend work before `DESIGN.md` exists for UI work.
- Skipping Creative Production `logo-explorer` when design planning/prototype work lacks title, logo, or favicon.
- Requiring Product Design installation or blocking the SOP when Product Design is unavailable.
- Letting Product Design bypass `DESIGN.md`, `IMPLEMENTATION_PLAN.md`, visual QA, QA, or code review.
- Ignoring `DESIGN.md` typography, spacing, technology stack, component, chart, token, responsive, state, or accessibility requirements.
- Treating a prototype as stronger than shadcn/ui, Ant Design Pro, ECharts, or another selected third-party framework's component model.
- Letting subagents work from narrow task prompts without `AGENTS.md`, `DESIGN.md`, `IMPLEMENTATION_PLAN.md`, allowed file boundaries, and no-drift instructions.
- Moving Superpowers, gstack, Product Design, Pencil, deployment, or release artifacts into `.my-harness/` instead of keeping native paths and indexing them.
- Treating `.my-harness/` as a replacement source of truth rather than an execution index.
- Letting review/QA loops run indefinitely.
- Entering Plan mode or using `AskUserQuestion` / `request_user_input` during a gstack gate in Codex.
- Continuing past a Markdown decision gate before the user chooses a `D1` / `D2` / `D3` option.
- Using the older `关键步骤汇总` table instead of the `my-harness-next-action` style `流程执行情况一览`.
- Expanding the final summary into separate numeric columns for loop statistics. Keep those details in `证据/原因`.
- Omitting loop statistics from `证据/原因` when stopping early or completing successfully.
- Omitting skipped steps from the final table. Include them with `⏭️ 前置无需进行` and a short reason.
- Expanding beyond the first vertical slice.
- Continuing through push/merge/release/deploy without explicit authorization.
