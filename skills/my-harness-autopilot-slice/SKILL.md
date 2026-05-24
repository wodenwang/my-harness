---
name: my-harness-autopilot-slice
description: Use when a small, clearly bounded project slice should be advanced through the user's harness loop after office-hours scope has already been finalized
---

# My Harness Autopilot Slice

## Purpose

Run one small, clearly bounded version slice through the existing `my-harness` SOP in one conversation. This skill repeatedly uses the current `my-harness-next-action` result as the next step's input until the slice is finished or a human handoff gate is reached.

This is an autopilot for narrow execution, not a replacement for product judgment.

## Hard Start Gates

Refuse to start unless all are true:

1. `gstack /office-hours` is already finalized for this task or version slice.
2. The current slice has a clear boundary, success criteria, and non-goals.
3. The task is small enough to finish without repeated product decisions.
4. Project governance is readable: `AGENTS.md`, `CLAUDE.md`, README, or equivalent docs.
5. The user explicitly asks to run the closed loop/autopilot, not just "what next?"

Refuse if any are true:

- The request is a large version, unclear product direction, broad redesign, multi-subsystem project, or ambiguous roadmap item.
- The implementation likely needs frequent human decisions.
- The task requires external credentials, production authorization, paid services, manual UI design approval, or unavailable tools before meaningful progress can continue.
- The first required action is still office-hours, product definition, or open-ended design discovery.

When refusing, state the blocking reason and recommend `my-harness-next-action` or the specific missing planning step.

## Workflow

1. Read project governance and existing artifacts.
2. Confirm office-hours evidence and scope clarity.
3. Invoke/apply `my-harness-next-action` to classify current state.
4. Execute exactly the recommended next harness action.
5. Re-run `my-harness-next-action`.
6. Continue until complete, refused, blocked, or handed off.

Do not skip gates. Do not compress multiple harness steps into one undocumented leap.

## Step-Specific Rules

### Design And Pencil Gates

If the next action requires Pencil prototype creation or meaningful visual design:

1. Use `my-harness-writing-design` to create or verify `DESIGN.md`, `design/`, and starter files.
2. Stop and hand off to the human for Pencil/design confirmation.

Do not blindly run Pencil CLI or MCP to produce real design work unless the user explicitly asks in this turn and the scope is small enough for this skill.

### Implementation Step

For step 7:

- Use `executing-plans` when the first vertical slice is strongly coupled or file boundaries are unclear.
- Use `subagent-driven-development` only when `IMPLEMENTATION_PLAN.md` has clear independent tasks, ownership, and non-overlapping write scopes.
- Implement only the first vertical slice. Do not expand into later slices just because the loop is running.

### Review Loops

For `design-review`, `qa`, and `review`, loop until findings are cleared or a stop condition fires:

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

- office-hours evidence is missing
- scope is too large or ambiguous
- Pencil/design confirmation is needed
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

流程执行情况一览：
| 状态 | 步骤 | Harness 动作 | 判断 | 证据/原因 |
|---|---:|---|---|---|
| ✅ | 1 | gstack `/office-hours` | 前置已完成 | 范围已锁定为 ...；无循环。 |
| ⏭️ | 2 | gstack `/plan-design-review` | 前置无需进行 | 当前切片不涉及新增产品/交互方向，按已批准范围执行。 |
| ⏭️ | 3 | Pencil App prototype | 前置无需进行 | 当前切片不涉及 UI；已有规则允许跳过 Pencil 原型。 |
| ⏭️ | 4 | gstack `/plan-design-review` on prototype | 前置无需进行 | 未创建新原型，因此无需原型复审。 |
| ✅ | 5 | gstack `/plan-eng-review` | 前置已完成 | 工程边界和测试策略已在 ... 锁定。 |
| ✅ | 6 | Superpowers `writing-plans` | 前置已完成 | `IMPLEMENTATION_PLAN.md` 覆盖文件路径、任务、测试和完成标准。 |
| ✅ | 7 | Superpowers `executing-plans` or `subagent-driven-development` | 前置已完成 | 已完成第一个 vertical slice，未扩展后续切片。 |
| ✅ | 8 | Superpowers `verification-before-completion` | 前置已完成 | 已运行 ...，结果通过。 |
| ✅ | 9 | gstack `/browse` verification, optional `open-gstack-browser`, Playwright fallback | 前置已完成 | 已运行 ...，覆盖主路径和关键状态。 |
| ✅ | 10 | gstack `/design-review` | 前置已完成 | 循环 1 次，发现 0 个阻塞问题，无需修复。 |
| ✅ | 11 | gstack `/qa` | 前置已完成 | 循环 1 次，发现 2 个问题，已修复 2 个，无遗留。 |
| 🎯 | 12 | gstack `/review` | 当前下一步 | 循环 10 次后仍有 1 个高风险 finding，需要人工判断是否接受。 |
| ⏳ | 13 | Git closeout | 待执行 | 停止点之后，未执行。 |
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

- Starting before `office-hours` has fixed the target.
- Running autopilot on a large, unclear version.
- Treating Pencil starter files as approved design.
- Letting review/QA loops run indefinitely.
- Using the older `关键步骤汇总` table instead of the `my-harness-next-action` style `流程执行情况一览`.
- Expanding the final summary into separate numeric columns for loop statistics. Keep those details in `证据/原因`.
- Omitting loop statistics from `证据/原因` when stopping early or completing successfully.
- Omitting skipped steps from the final table. Include them with `⏭️ 前置无需进行` and a short reason.
- Expanding beyond the first vertical slice.
- Continuing through push/merge/release/deploy without explicit authorization.
