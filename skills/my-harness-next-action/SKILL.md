---
name: my-harness-next-action
description: Use when advancing a project through gstack, Superpowers, Pencil, browser verification, Git, ship, land, or deploy and the current phase or next harness action is unclear
---

# My Harness Next Action

## Core Rule

Answer one question: "What is the next harness action?" Do not restart the workflow from step 1 unless evidence shows no usable prior state.

First read project governance (`AGENTS.md`, `CLAUDE.md`, README/runbooks) and the live workspace evidence. Then classify the highest completed step, name the immediate next action, and provide a prompt the user can reuse.

## Evidence To Check

Use the cheapest relevant evidence first:

- Governance: project `AGENTS.md`, `CLAUDE.md`, release/runbook docs.
- Planning: `IMPLEMENTATION_PLAN.md`, `docs/superpowers/`, `design/`, Pencil `.pen`, exported screenshots.
- Implementation: `git status`, recent commits, changed files, running app, test scripts.
- Verification: test/lint/build logs, gstack `/browse` findings, Playwright screenshots, QA/design-review/review notes.
- Release: version files, CHANGELOG/release notes, tags, PR state, deployment/canary notes.

If evidence conflicts, trust newest concrete artifacts over older plans. If a step is claimed but has no artifact or verification, mark it "claimed, not proven" and recommend the first missing gate.

## Classification Flow

1. Find the last step with concrete evidence.
2. Check whether that step's completion gate is satisfied.
3. If not satisfied, recommend finishing that same step.
4. If satisfied, recommend the next step in the sequence.
5. Mark every canonical step with a status icon before answering.
6. If all applicable steps are complete, report that the SOP is closed and do not recommend restarting the Discovery / Brainstorm gate.
7. Include no more than one optional catch-up action unless a blocker makes it necessary.

### Brainstorm Gate Rule

If step 1 was completed with Superpowers `brainstorming`, do not jump directly to step 6 `writing-plans`. A completed brainstorm is only candidate input for later reviews, even when it already contains frontend, backend, or end-to-end implementation ideas.

After a Superpowers `brainstorming` gate, the next required actions are:

1. step 2 `gstack /plan-design-review` to challenge product, interaction, frontend approach, information architecture, and state design;
2. step 3 Pencil prototype planning when the scope needs UI or interaction evidence;
3. step 4 prototype review when a Pencil prototype was created;
4. step 5 `gstack /plan-eng-review` to challenge architecture, data flow, boundaries, tests, performance, permissions, and release risk;
5. only then step 6 Superpowers `writing-plans`.

Mark steps 2 and 5 as `⏭️ 前置无需进行` only when the current request is extremely simple, has no meaningful product/interaction ambiguity, and has no engineering architecture or risk decisions to challenge. In that case, state the skip reason explicitly in the table. "The brainstorm already proposed an implementation plan" is not a valid skip reason.

### Codex-Safe Gstack Gate Rule

Codex cannot reliably handle `AskUserQuestion` inside several gstack skills. Whenever the recommended next action uses gstack `/office-hours`, `/plan-design-review`, `/plan-eng-review`, `/design-review`, `/qa`, `/review`, `/ship`, `/land-and-deploy`, or any other gstack skill that may ask the user interactively, the recommended prompt must include the following guard:

```text
Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

If a gstack step reaches a decision point, the next-action result must treat that decision as the current stopping point instead of continuing the harness loop.

## Status Icons

Use these exact icons in the overview table:

| Icon | Status | Meaning |
|---|---|---|
| ✅ | 前置已完成 | Concrete evidence proves this step is complete. |
| ⏭️ | 前置无需进行 | This step is not required for the current project/scope, or the project has an explicit rule to skip it. |
| 🎯 | 当前下一步 | This is the immediate recommended harness action. |
| ⚠️ | 证据不足 | The step is claimed or implied, but evidence is missing, stale, or conflicting. Treat this as the first gate to resolve if it blocks the next action. |
| ⏳ | 待执行 | This step comes after the current next action. |

Do not use vague labels like "done?" or "maybe". Each step must have exactly one icon and a short evidence note.

## Closed-Loop Completion

If the evidence shows all applicable SOP steps are complete, or the project has reached an explicitly approved final stopping point:

- Say clearly: `当前 SOP 已闭环。`
- Do not mark any step as `🎯 当前下一步`.
- Do not recommend `gstack /office-hours` or Superpowers `brainstorming` to start a new loop.
- Still provide the full 15-step overview table.
- Mark completed steps as `✅ 前置已完成`.
- Mark intentionally skipped or inapplicable steps as `⏭️ 前置无需进行`.
- If any step lacks evidence, the SOP is not closed; mark the first missing gate as `⚠️ 证据不足` instead.
- In the "下一步 harness 动作" section, write `无。当前 SOP 已闭环。`
- Omit the copyable prompt block unless there is a genuine optional follow-up requested by the user.

## Canonical Sequence

| Step | Harness action | Completion evidence |
| -: | - | - |
| 1 | Discovery / Brainstorm gate: gstack `/office-hours` or Superpowers `brainstorming` | clarified target user, problem, constraints, smallest worthwhile slice, candidate approach, and questions for later review; use `office-hours` by default for new product/scope discovery, and use `brainstorming` when value and target are already clear but the candidate design/spec needs convergence |
| 2 | gstack `/plan-design-review` | early product/interaction/frontend direction reviewed; required after Superpowers `brainstorming` unless the request is extremely simple |
| 3 | Pencil App prototype | `.pen` source, screenshot/export, design notes |
| 4 | gstack `/plan-design-review` on prototype | prototype review findings resolved or accepted |
| 5 | gstack `/plan-eng-review` | architecture, data flow, risks, test strategy locked; required after Superpowers `brainstorming` unless the request is extremely simple |
| 6 | Superpowers `writing-plans` | `IMPLEMENTATION_PLAN.md` with paths, tasks, tests, done criteria |
| 7 | Superpowers `executing-plans` or `subagent-driven-development` | first vertical slice implemented end to end; use `subagent-driven-development` only when the slice has clear independent tasks and non-overlapping file boundaries |
| 8 | Superpowers `verification-before-completion` | fresh tests/build/lint/manual evidence |
| 9 | gstack `/browse` verification, optional `open-gstack-browser`, Playwright fallback | use `/browse` for fast headless QA evidence; use `open-gstack-browser` when a visible real-time browser window, sidebar activity feed, or human-observable control is needed; use Playwright for scripted regression fallback |
| 10 | gstack `/design-review` | UI/interaction QA findings fixed or explicitly accepted |
| 11 | gstack `/qa` | systematic functional QA and rerun evidence |
| 12 | gstack `/review` | pre-landing diff review with risks/test gaps addressed |
| 13 | Git closeout | clean intended diff, commit boundary, status/remote state known |
| 14 | gstack `/ship` | release/PR/tag/materials prepared according to project rules |
| 15 | gstack `/land-and-deploy` | authorized merge/release/deploy plus canary or health check |

## Recommended Output

Use this shape:

```markdown
当前判断：第 N 步「...」已完成/未完成；现在应执行第 M 步「...」。

流程执行情况一览：
| 状态 | 步骤 | Harness 动作 | 判断 | 证据/原因 |
|---|---:|---|---|---|
| ✅ | 1 | Discovery / Brainstorm gate | 前置已完成 | ... |
| ⏭️ | 2 | gstack `/plan-design-review` | 前置无需进行 | ... |
| 🎯 | 3 | Pencil App prototype | 当前下一步 | ... |
| ⏳ | 4 | gstack `/plan-design-review` on prototype | 待执行 | ... |

证据：
- ...

下一步 harness 动作：
...

推荐提示词：
```text
请使用 ...

执行完毕后，请按照 my-harness 规定的流程输出 `流程执行情况一览：` 15 步进度表，并在末尾继续给出下一步可直接复制执行的 `推荐提示词`。

这个末尾提示词必须同时包含本句要求，让用户后续只需要复制末尾提示词继续推进，不需要重新询问 next action。
```

注意：
- ...
```

The overview table is mandatory whenever the user asks what to do next through this skill. Use the section title `流程执行情况一览：`. It must cover all 15 canonical steps, not only the current step. Clearly distinguish `✅ 前置已完成` from `⏭️ 前置无需进行`.

If the SOP is already closed, use the same overview-table format but replace the next-action section with:

```markdown
下一步 harness 动作：
无。当前 SOP 已闭环。
```

The recommended prompt must be easy to copy in one action:

- Put the final prompt in a standalone fenced `text` code block.
- Put only the prompt inside that code block; do not include bullets, explanations, quotes, or surrounding prose inside it.
- Resolve bracketed placeholders from project evidence when possible.
- If two prompt variants are genuinely needed, use two separate `text` code blocks with short labels outside the blocks.
- The prompt itself must be self-chaining: besides naming the immediate next harness action, it must require the executor to output the `流程执行情况一览：` 15-step progress table after finishing and to place the next copyable `推荐提示词` at the end.
- Format the prompt as readable plain text with short paragraphs and line breaks. Do not add complex Markdown structure, headings, bold text, tables, or nested bullets inside the prompt block.
- The final paragraph of every recommended prompt must preserve this handoff requirement so the user can keep copying the last prompt after each step without asking `my-harness-next-action` again.
- Use this exact suffix unless the SOP is already closed:

```text
执行完毕后，请按照 my-harness 规定的流程输出 `流程执行情况一览：` 15 步进度表，并在末尾继续给出下一步可直接复制执行的 `推荐提示词`。

这个末尾提示词必须同时包含本句要求，让用户后续只需要复制末尾提示词继续推进，不需要重新询问 next action。
```

## Prompt Templates

Replace bracketed fields before use.

Step 1:

```text
请执行 Discovery / Brainstorm gate，帮我澄清 [项目/版本/功能]。

如果还不确定是否值得做、用户是谁或范围多大，默认使用 gstack /office-hours。
如果目标和价值已经明确、需要候选方案或 spec 收敛，使用 Superpowers brainstorming。

请输出目标用户、核心问题、约束、最小可行切片、候选方案、是否值得做，以及后续 plan-design-review 和 plan-eng-review 需要挑战的问题。

注意：brainstorming 即便产出前后端实现方案，也只是候选输入。除非需求极其简单，否则下一步不得直接进入 writing-plans。

Codex 兼容要求：
如果使用 gstack /office-hours，按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 2:

```text
请使用 gstack /plan-design-review 审视 [项目/功能] 的早期产品、交互和前端方案。

重点指出关键体验风险、信息架构、主路径、空/错/加载状态，并给出进入 Pencil 原型前的修改建议。

若上一步使用了 Superpowers brainstorming，请重新挑战其中的方案，不要把 brainstorm 输出当作已批准设计。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 3:

```text
请使用 Pencil App 为 [项目/功能] 产出 shadcn/ui 风格原型。

保存 .pen 源文件，导出关键页面截图，并写一份简短设计说明到 design/。
```

Step 4:

```text
请使用 gstack /plan-design-review 审查 design/ 中的 Pencil 原型和截图。

按阻塞、重要、可选分类给出问题，并迭代到没有关键设计阻塞。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 5:

```text
请使用 gstack /plan-eng-review 评审 [项目/功能] 的工程方案。

锁定架构、数据流、边界条件、测试策略、性能风险、权限/安全边界和发布风险。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 6:

```text
请使用 Superpowers writing-plans 为 [项目/功能] 生成 IMPLEMENTATION_PLAN.md。

计划必须包含明确文件路径、任务拆分、测试命令、预期输出和完成标准。
```

Step 7:

```text
请使用 Superpowers executing-plans 或 subagent-driven-development，实现 IMPLEMENTATION_PLAN.md 的第一个 vertical slice。

如果任务强耦合或文件边界不清晰，用 executing-plans。
如果已拆成可并行、边界清晰、互不踩代码的任务，用 subagent-driven-development。

无论哪种方式，都只完成第一个 vertical slice。要求可运行、可验证、端到端闭环，不展开后续切片。
```

Step 8:

```text
请使用 Superpowers verification-before-completion 对当前 vertical slice 做完成门禁。

运行新鲜的测试、构建、lint 或手动验证，并整理证据。没有证据不要声称完成。
```

Step 9:

```text
请优先使用 gstack /browse 验证当前实现。

覆盖关键页面、主路径、空/错/加载状态和桌面/移动视口。

如果需要可视化实时观察、侧边栏活动流或人工跟看操作过程，补充使用 gstack open-gstack-browser。
记录 console/network 问题，保留截图，并在需要脚本化回归时补 Playwright 检查。

Codex 兼容要求：
如果任何 gstack 浏览器验证步骤需要用户决策，按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 10:

```text
请使用 gstack /design-review 对已实现界面做视觉和交互 QA。

重点检查层级、间距、响应式、文案、状态和可访问性，并修复高优先级问题。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 11:

```text
请使用 gstack /qa 对当前功能做系统化功能 QA。

按风险优先级记录问题、修复、重新验证，并输出可复核结果。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 12:

```text
请使用 gstack /review 做落地前代码审查。

检查 diff 风险、测试缺口、数据/权限/安全边界和可维护性问题。先列 finding，再给总结。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 13:

```text
请做 Git 收口。

检查 git status、diff、未提交、未 push、未 pull 状态，整理提交边界和发布材料。

不要在未获授权时 push、merge 或 release。
```

Step 14:

```text
请使用 gstack /ship 做最终收口。

整理 WIP、确认 diff、运行必要验证、准备提交、版本、CHANGELOG 和发布说明，并按项目规则处理 push/PR。

需要授权的动作先确认。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 15:

```text
请使用 gstack /land-and-deploy 在获得授权后完成合并、release、tag、部署等待和线上健康验证。

如果是 Docker 部署，还要构建、tag 并上传镜像后做 canary。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

## Common Mistakes

- Recommending step 1 because the conversation lacks context while the repo has artifacts. Inspect the repo first.
- Treating Superpowers `brainstorming` output as approved design or as permission to skip directly to `writing-plans`. Step 1 produces candidate input; later `plan-design-review`, Pencil review when needed, and `plan-eng-review` still challenge it unless the request is extremely simple.
- Marking `plan-design-review` or `plan-eng-review` unnecessary after `brainstorming` because the brainstorm already proposed frontend/backend implementation details.
- Recommending a gstack prompt in Codex without the Codex-safe Markdown decision-gate guard.
- Continuing past a gstack decision point instead of stopping with `D1` / `D2` / `D3` Markdown decision tables.
- Treating a written plan as implementation. Step 6 does not imply step 7.
- Using `subagent-driven-development` before `IMPLEMENTATION_PLAN.md` has clear task boundaries, ownership, and non-overlapping write scopes.
- Treating implementation as completion without fresh verification. Step 7 must flow into step 8.
- Skipping gstack `/browse` and design QA for UI work because automated tests passed.
- Calling `ship`, `land`, or `deploy` without checking authorization, clean diff, release materials, and remote state.
