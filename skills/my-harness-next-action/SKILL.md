---
name: my-harness-next-action
description: Use when advancing a project through gstack, Superpowers, Product Design, optional Pencil, browser verification, Git, ship, land, or deploy and the current phase or next harness action is unclear
---

# My Harness Next Action

## Core Rule

Answer one question: "What is the next harness action?" Do not restart the workflow from step 1 unless evidence shows no usable prior state.

First read project governance (`AGENTS.md`, `CLAUDE.md`, README/runbooks) and the live workspace evidence. Then classify the highest completed step, name the immediate next action, and provide a prompt the user can reuse.

## Evidence To Check

Use the cheapest relevant evidence first:

- Governance: project `AGENTS.md`, `CLAUDE.md`, release/runbook docs.
- Harness process: optional `.my-harness/`, `.my-harness/index.md`, `.my-harness/runs/`, or equivalent execution index. Treat these as pointers and evidence summaries, not as replacements for third-party artifacts.
- Planning: `DESIGN.md`, `IMPLEMENTATION_PLAN.md`, `docs/superpowers/`, `design/`, Product Design visual targets or brief notes, screenshots, URL captures, Figma references, optional Pencil `.pen` files, and exported screenshots.
- Implementation: `git status`, recent commits, changed files, running app, test scripts.
- Verification: test/lint/build logs, gstack `/browse` findings, Playwright screenshots, optional `design-qa.md`, QA/design-review/review notes.
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
8. Treat `my-harness-canary` as an optional direct-call follow-up after step 15, not as a required step for SOP closure.
9. When adjacent steps are ready to run together, recommend the phase work package while still preserving each step as a separate row in the status table.

### Brainstorm Gate Rule

If the target project is blank, mostly blank, or has not yet started the `my-harness` loop, and the user explicitly asks to use the `my-harness` framework/process, guide the user into step 1 with Superpowers `brainstorming`. Do not jump to `my-harness-initialize-project`, Product Design, `writing-plans`, implementation, or QA as the first harness action.

Use this rule when there is no concrete evidence of prior harness progress, such as no `流程执行情况一览`, no `.my-harness/` index, no `IMPLEMENTATION_PLAN.md`, no `docs/superpowers/` planning artifact, no design/review/QA evidence, and no completed step records. The first step must clarify target user, problem, constraints, success criteria, smallest worthwhile slice, non-goals, risks, and candidate approaches. If governance files are also missing, mention that initialization can happen after or alongside the first-step handoff, but the harness loop starts with Superpowers `brainstorming`.

If step 1 was completed with Superpowers `brainstorming`, do not jump directly to step 6 `writing-plans`. A completed brainstorm is only candidate input for later reviews, even when it already contains frontend, backend, or end-to-end implementation ideas.

After a Superpowers `brainstorming` gate, the next required actions are:

1. step 2 Product Design planning review to challenge product, interaction, frontend approach, information architecture, state design, and `DESIGN.md` fit;
2. step 3 design artifact / visual target planning when the scope needs UI or interaction evidence;
3. step 4 Product Design review of the selected design artifact when a Product Design visual target, screenshot, URL capture, Figma reference, design note, or Pencil prototype was created;
4. step 5 `gstack /plan-eng-review` to challenge architecture, data flow, boundaries, tests, performance, permissions, and release risk;
5. only then step 6 Superpowers `writing-plans`.

Mark steps 2 and 5 as `⏭️ 前置无需进行` only when the current request is extremely simple, has no meaningful product/interaction ambiguity, and has no engineering architecture or risk decisions to challenge. In that case, state the skip reason explicitly in the table. "The brainstorm already proposed an implementation plan" is not a valid skip reason.

### DESIGN.md Governance Rule

For any UI, frontend, interaction, visual design, dashboard, or app surface:

- If the target project has no `DESIGN.md`, the next design-related action must first invoke or recommend `my-harness-writing-design` to create `DESIGN.md`, `design/`, and governance links before Product Design review, frontend planning, implementation, or visual QA.
- If the user explicitly invokes `my-harness-writing-design` and the target project already has `DESIGN.md`, the action must refresh the my-harness-owned latest design-governance addendum while preserving project-specific content, brand decisions, accepted deviations, and historical notes.
- Every design-related gate must read and obey `DESIGN.md` and `design/` strictly, including typography, spacing, layout density, color tokens, responsive rules, technology stack, component rules, chart rules, and state coverage.
- During design planning and prototype design, if the system has no app/product title, logo, or favicon, use the Creative Production plugin before finalizing prototypes. Prefer Creative Production `logo-explorer` to create identity directions and favicon/app-icon concepts; use the project/product name as a provisional title when available, and in target/autopilot mode derive a conservative title from the repo/project name if no title exists. Record selected logo, favicon direction, title, rejected routes, and asset paths under `design/`.
- If `DESIGN.md` conflicts with a prototype, user-selected visual target, or generated code, surface the conflict and use `DESIGN.md` plus the selected frontend framework's component model as the implementation authority unless the user explicitly updates the design governance.
- If the selected frontend framework is shadcn/ui, Ant Design Pro, ECharts, or another project-approved third-party framework, and the prototype does not match available framework components, prefer the framework's native components and composition rules. The prototype remains a visual/reference target, not permission to invent a parallel component system.
- For Admin Console / backend management work, shadcn MCP is optional but shadcn/ui is not optional. The design and implementation evidence must show shadcn component/block mapping, Tailwind token/CSS variable usage, 8px spacing decisions, and no unapproved non-shadcn UI framework.

### Product Design Frontend Rule

Product Design can enhance frontend work but does not add, remove, or renumber canonical SOP steps. It no longer needs a separate `my-harness-product-design-bridge` skill; call Product Design focused skills directly when they are available and appropriate.

- Product Design focused skills replace gstack `/plan-design-review` and gstack `/design-review` for design-related gates when Product Design is available. Use gstack design gates only as fallback when Product Design is unavailable or project governance explicitly requires gstack.
- For planning design and frontend work, Product Design must provide at least three prototype/visual directions for user selection. In target/autopilot mode, the executor may choose the system-recommended direction, but must record the choice and rationale under `design/`.
- For Admin Console work, Product Design directions must explicitly follow the shadcn/ui + tweakcn design language from `DESIGN.md`; each selected or recommended option must include shadcn component/block mapping, Tailwind token mapping, state coverage, and accepted deviations from native shadcn/ui components.
- If a UI slice has no visual target and Product Design is available, recommend Product Design `get-context` -> `ideate` -> user selection as step 3 evidence.
- If Product Design is unavailable, do not ask the user to install it and do not mark the SOP blocked. Continue with the shadcn/ui design baseline, existing UI references, screenshots, or optional Pencil only when human alignment requires it.
- Product Design outputs are first-class design artifacts when recorded under `design/`. Pencil is optional and used for complex modules, multi-step interaction alignment, or explicit human review needs.
- Product Design `image-to-code` / `url-to-code` must be used for frontend slice scaffolding when Product Design has a selected prototype/visual target and step 6 has produced `IMPLEMENTATION_PLAN.md`; the generated frame is then adapted to the project codebase and selected UI framework.
- Product Design visual QA must compare the implemented UI against the selected prototype or visual target, record differences, and drive fix/review loops until the implementation is highly faithful or deviations are explicitly accepted.

### Frontend Fidelity First Rule

For UI-heavy projects such as CRM, Portal, Admin Console, dashboards, or apps, step 6-11 should normally run as two evidence loops without renumbering the canonical SOP.

- Step 3 must leave an approved visual target, not just a design direction. It must include approved / selected / system-recommended accepted status, target mockup or reference, and implementation spec extraction.
- Step 6A frontend writing plan must reference the step 3 approved visual target and extract implementation spec: layout, routes, components, interactions, states, responsive behavior, token mapping, and screenshot/design-QA evidence paths.
- Step 7A frontend mock implementation prioritizes fidelity first, then code cleanup, and must finish on shadcn/ui or the selected project component system. Product Design generated code is scaffold only.
- Step 8A verifies the frontend/mock slice with fresh tests, lint, build, typecheck, or manual evidence.
- Step 9A browser verification must run before Step 10A because Product Design QA needs screenshots as evidence.
- Step 10A is a hard Product Design fidelity gate with target mockup, screenshots, differences, fixes, before/after evidence, and accepted deviations.
- Step 11A runs frontend/mock functional QA.
- Step 6B-11B integrate backend and real data, then rerun integration verification, browser verification, visual regression, and functional QA so real data does not break layout or interaction.

### My-Harness Execution Index Rule

For projects that already use `my-harness`, the executor may create or update `.my-harness/` to preserve the execution process and provide a quick index. Keep it small and navigational.

- Suggested files: `.my-harness/README.md`, `.my-harness/index.md`, `.my-harness/status.md`, and `.my-harness/runs/<date-or-slice>.md`.
- The index may record step status, phase, selected prompts, decisions, artifact links, verification commands, review loop counts, and handoff notes.
- Do not move or duplicate third-party source-of-truth documents into `.my-harness/`.
- Superpowers documents stay in their Superpowers/project-standard location such as `docs/superpowers/` or `IMPLEMENTATION_PLAN.md`.
- gstack reports, Product Design artifacts, Pencil files, browser screenshots, deployment docs, and release notes stay in their native directories or project-standard paths such as `.gstack/`, `design/`, `DEPLOY.md`, `CHANGELOG.md`, or release docs.
- `.my-harness/` may link to those artifacts and summarize them briefly, but it must not contain secrets, credentials, long copied reports, or conflicting instructions.

### Codex-Safe Gstack Gate Rule

Codex cannot reliably handle `AskUserQuestion` inside several gstack skills. Whenever the recommended next action uses gstack `/office-hours`, `/plan-design-review`, `/plan-eng-review`, `/design-review`, `/qa`, `/review`, `/ship`, `/land-and-deploy`, `/canary`, or any other gstack skill that may ask the user interactively, the recommended prompt must include the following guard:

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

## Phase Work Packages

The 15 canonical steps remain the source of truth for evidence, status, and handoff prompts. For user-facing guidance, group adjacent steps into phases:

| Phase | Steps | When to recommend as one package |
|---|---:|---|
| 1. Discovery and direction | 1-2 | Use when the scope, user, problem, or early product/interaction direction is still unsettled. |
| 2. Design baseline and visual target | 3-4 | Use when the next work is to create/confirm a visual target and review that target before engineering planning. |
| 3. Engineering plan | 5-6 | Use when architecture review can flow directly into `IMPLEMENTATION_PLAN.md`, provided no decision gate blocks the review. |
| 4. First runnable slice | 7-8 | Use when a planned first vertical slice can be implemented and immediately verified in the same bounded pass. |
| 5. Browser, visual, and functional QA | 9-11 | Use when a running UI exists and browser verification, design review, and functional QA can be executed as one QA pass with separate evidence. |
| 6. Review, ship, and deploy | 12-15 | Use when the implementation is verified and the remaining work is diff review, Git closeout as `/ship` preflight, shipping materials, and authorized land/deploy. |

Do not collapse evidence. A phase package is only a recommendation convenience; the `流程执行情况一览：` table must still include all 15 rows and the first incomplete or blocked row must remain visible.

## Canonical Sequence

| Step | Harness action | Completion evidence |
| -: | - | - |
| 1 | Discovery / Brainstorm gate: gstack `/office-hours` or Superpowers `brainstorming` | clarified target user, problem, constraints, smallest worthwhile slice, candidate approach, and questions for later review; use `office-hours` by default for new product/scope discovery, use `brainstorming` when value and target are already clear but the candidate design/spec needs convergence, and use Superpowers `brainstorming` first when a blank/not-started project explicitly asks to use the `my-harness` framework |
| 2 | Product Design planning review, fallback gstack `/plan-design-review` only when Product Design is unavailable | early product/interaction/frontend direction reviewed against `DESIGN.md`; required after Superpowers `brainstorming` unless the request is extremely simple |
| 3 | Design artifact / approved visual target | `DESIGN.md` exists for UI work and is refreshed with the latest my-harness governance addendum when `my-harness-writing-design` is explicitly run; missing app/product title, logo, or favicon is resolved through Creative Production `logo-explorer`; Product Design selected visual target with at least three prototype/visual directions, source screenshot, URL capture, Figma frame, existing UI reference, design notes, or optional Pencil `.pen` when complex human alignment is needed; artifact is recorded under `design/` with approved / selected / system-recommended accepted status, target mockup or reference, choice rationale, and implementation spec extraction; Admin Console visual targets include shadcn component/block mapping, Tailwind token / CSS variable mapping, state coverage, and no unapproved non-shadcn UI framework |
| 4 | Product Design review of selected design artifact, fallback gstack `/plan-design-review` only when Product Design is unavailable | design artifact review findings resolved or accepted; selected prototype is checked against `DESIGN.md` before engineering planning |
| 5 | gstack `/plan-eng-review` | architecture, data flow, risks, test strategy locked; required after Superpowers `brainstorming` unless the request is extremely simple |
| 6 | Superpowers `writing-plans` | `IMPLEMENTATION_PLAN.md` with paths, tasks, tests, done criteria; for UI-heavy projects, Step 6A writes the frontend fidelity plan first and must reference the step 3 approved visual target, extract implementation spec, define mock data/API strategy, screenshot paths, and design QA evidence; after Step 10A/11A passes, Step 6B writes backend/API integration planning that protects the approved UI |
| 7 | Superpowers `executing-plans` or `subagent-driven-development` | first vertical slice implemented end to end; Codex and any subagents continuously follow `AGENTS.md`, `CLAUDE.md`, `DESIGN.md`, `IMPLEMENTATION_PLAN.md`, and relevant governance docs; for UI-heavy projects, Step 7A implements the frontend/mock slice with fidelity first and final shadcn/ui or selected component-system compliance; Product Design `image-to-code` / `url-to-code` is scaffold only; Step 7B integrates backend/API/real data after frontend fidelity passes |
| 8 | Superpowers `verification-before-completion` | fresh tests/build/lint/manual evidence; for UI-heavy projects, Step 8A verifies the frontend/mock slice and Step 8B verifies backend/integration |
| 9 | gstack `/browse` verification, optional `open-gstack-browser`, Playwright fallback | use `/browse` for fast headless QA evidence; use `open-gstack-browser` when a visible real-time browser window, sidebar activity feed, or human-observable control is needed; use Playwright for scripted regression fallback; for UI-heavy projects, Step 9A browser screenshots must run before Step 10A, and Step 9B reruns browser verification with real backend/data |
| 10 | Product Design visual QA / design review, fallback gstack `/design-review` only when Product Design is unavailable | implemented UI compared against the selected prototype/approved visual target and `DESIGN.md`; for UI-heavy projects, Step 10A is a hard fidelity gate with target mockup, screenshots, differences, fixes, before/after evidence, and accepted deviations; Step 10B reruns visual regression after backend integration, full gate if layout/data density/interaction changed |
| 11 | gstack `/qa` | systematic functional QA and rerun evidence; for UI-heavy projects, Step 11A covers frontend/mock interaction QA and Step 11B covers full functional QA with real backend/data |
| 12 | gstack `/review` | pre-landing diff review with risks/test gaps addressed |
| 13 | Git closeout / `/ship` preflight | clean intended diff, commit boundary, status/remote state known, and authorization-sensitive actions identified before `/ship` |
| 14 | gstack `/ship` | final Git/release closeout, release/PR/tag/materials prepared according to project rules, and no push/PR/tag/release performed without authorization |
| 15 | gstack `/land-and-deploy` | authorized merge/release/deploy plus required production health check |

Optional post-closeout action: `my-harness-canary` runs gstack `/canary` against a live URL after step 15. It is a direct-call skill, not a canonical table row. It observes production or staging, writes canary evidence, and registers confirmed findings as GitHub issues without editing code.

Frontend design action: Product Design focused skills can be used directly inside the existing step flow when installed. They are not required for SOP closure; when unavailable, use shadcn/ui design governance, existing UI references, screenshots, or optional Pencil for complex alignment.

## Recommended Output

Use this shape:

```markdown
当前判断：第 N 步「...」已完成/未完成；现在应执行第 M 步「...」。

当前阶段：第 X 阶段「...」。

流程执行情况一览：
| 状态 | 步骤 | Harness 动作 | 判断 | 证据/原因 |
|---|---:|---|---|---|
| ✅ | 1 | Discovery / Brainstorm gate | 前置已完成 | ... |
| ⏭️ | 2 | Product Design planning review, fallback gstack `/plan-design-review` | 前置无需进行 | ... |
| 🎯 | 3 | Design artifact / visual target | 当前下一步 | ... |
| ⏳ | 4 | Product Design review of selected design artifact, fallback gstack `/plan-design-review` | 待执行 | ... |

证据：
- ...

下一步 harness 动作：
...

推荐提示词：
```text
请使用 ...

执行完毕后，请按照 my-harness 规定的流程输出 `流程执行情况一览：` 15 步进度表，并在末尾继续给出下一步可直接复制执行的 `推荐提示词`。

如果项目已经在使用 my-harness，请创建或更新 `.my-harness/` 快速索引，记录步骤状态、关键决策、证据链接、验证命令和下一步提示词。Superpowers、gstack、Product Design、Pencil 等第三方技能生成的文档必须继续保留在其规范目录中，`.my-harness/` 只保存链接和简短摘要。

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

If the user asks for extra post-deploy confidence, production monitoring, or recurring checks after the SOP is closed, recommend `my-harness-canary` as an optional follow-up instead of reopening the 15-step loop.

The recommended prompt must be easy to copy in one action:

- Put the final prompt in a standalone fenced `text` code block.
- Put only the prompt inside that code block; do not include bullets, explanations, quotes, or surrounding prose inside it.
- Resolve bracketed placeholders from project evidence when possible.
- If two prompt variants are genuinely needed, use two separate `text` code blocks with short labels outside the blocks.
- The prompt itself must be self-chaining: besides naming the immediate next harness action, it must require the executor to output the `流程执行情况一览：` 15-step progress table after finishing and to place the next copyable `推荐提示词` at the end.
- If the project already uses `my-harness`, every non-closed recommended prompt must ask the executor to create or update `.my-harness/` as a quick index when useful, while keeping third-party artifacts in their native paths.
- If the project is blank or has not started the `my-harness` loop and the user explicitly asked for the `my-harness` framework, the step 1 prompt must name Superpowers `brainstorming` as the first harness action.
- Format the prompt as readable plain text with short paragraphs and line breaks. Do not add complex Markdown structure, headings, bold text, tables, or nested bullets inside the prompt block.
- The final paragraph of every recommended prompt must preserve this handoff requirement so the user can keep copying the last prompt after each step without asking `my-harness-next-action` again.
- Use this exact suffix unless the SOP is already closed:

```text
执行完毕后，请按照 my-harness 规定的流程输出 `流程执行情况一览：` 15 步进度表，并在末尾继续给出下一步可直接复制执行的 `推荐提示词`。

如果项目已经在使用 my-harness，请创建或更新 `.my-harness/` 快速索引，记录步骤状态、关键决策、证据链接、验证命令和下一步提示词。Superpowers、gstack、Product Design、Pencil 等第三方技能生成的文档必须继续保留在其规范目录中，`.my-harness/` 只保存链接和简短摘要。

这个末尾提示词必须同时包含本句要求，让用户后续只需要复制末尾提示词继续推进，不需要重新询问 next action。
```

## Prompt Templates

Replace bracketed fields before use.

Step 1:

```text
请执行 Discovery / Brainstorm gate，帮我澄清 [项目/版本/功能]。

如果当前是空白项目，或尚未开始使用 my-harness 流程，并且用户明确要求使用 my-harness 框架，请先使用 Superpowers brainstorming 进入第 1 步，沟通清楚目标用户、核心问题、约束、成功标准、最小值得做切片、非目标、风险和候选方案。不要直接进入 initialize、writing-plans、设计制品、实现或 QA。

如果还不确定是否值得做、用户是谁或范围多大，默认使用 gstack /office-hours。
如果目标和价值已经明确、需要候选方案或 spec 收敛，使用 Superpowers brainstorming。

请输出目标用户、核心问题、约束、最小可行切片、候选方案、是否值得做，以及后续 Product Design planning review 和 plan-eng-review 需要挑战的问题。

如果项目已经在使用 my-harness，可以创建或更新 .my-harness/ 作为执行过程快速索引，记录步骤状态、决策、证据链接和下一步提示词。第三方技能生成的文档必须继续放在其规范目录中，例如 Superpowers 的 docs/superpowers/ 或 IMPLEMENTATION_PLAN.md、gstack 的报告目录、Product Design/Pencil 的 design/；.my-harness/ 只保存链接和简短摘要，不替代源文档。

注意：brainstorming 即便产出前后端实现方案，也只是候选输入。除非需求极其简单，否则下一步不得直接进入 writing-plans。

Codex 兼容要求：
如果使用 gstack /office-hours，按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 2:

```text
请使用 Product Design focused skills 审视 [项目/功能] 的早期产品、交互和前端方案；只有 Product Design 不可用时，才 fallback 到 gstack /plan-design-review。

如果这是 UI / 前端 / 图表 / App 工作，先检查项目根目录是否存在 DESIGN.md。若不存在，必须先调用或推荐 my-harness-writing-design 创建 DESIGN.md、design/ 和 AGENTS.md 设计规范链接，再继续设计评审。

评审必须严格遵循 DESIGN.md 和 design/ 中的所有要求，包括字体、字号、间距、技术栈、组件体系、图表库、颜色 token、响应式、状态设计和可访问性。

重点指出关键体验风险、信息架构、主路径、空/错/加载状态，并给出进入设计制品 / 视觉目标阶段前的修改建议。若涉及前端方案，必须要求后续 Product Design ideate 至少提供三套原型/视觉方案供用户选择；目标模式下可以选择系统推荐方案，但必须记录选择理由。

若上一步使用了 Superpowers brainstorming，请重新挑战其中的方案，不要把 brainstorm 输出当作已批准设计。

Codex 兼容要求：
如果 fallback 到 gstack /plan-design-review，按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 3:

```text
请为 [项目/功能] 产出设计制品 / approved visual target，并把结果记录到 design/。不要只输出“设计方向”。

如果这是 UI / 前端 / 图表 / App 工作，先检查项目根目录是否存在 DESIGN.md。若不存在，必须先使用 my-harness-writing-design 创建 DESIGN.md、design/ 和 AGENTS.md 设计规范链接，再继续产出视觉目标。

如果用户显式要求执行 my-harness-writing-design，且项目已经有 DESIGN.md，不要跳过；必须保守合并 my-harness 最新设计治理补强，保留项目已有的业务、品牌、布局、个性化规范和历史设计决策。

后续所有设计制品必须严格遵循 DESIGN.md，包括字体、间距、技术栈选型、组件体系、图表库、颜色 token、状态设计、响应式和可访问性。

开始前必须先确认产品场景；如果当前项目或我的描述没有明确场景，不要初始化文件，先反向询问我选择：Admin Console、BI 图表分析 / 数据驾驶舱、或 C 端网站 / App。

进入设计规划和原型图设计时，检查系统是否已有明确 app/product title、logo 和 favicon。如果缺少标题、logo 或 favicon，先使用 Creative Production plugin 的 logo-explorer 构建 logo / favicon / app icon 方向；已有项目名时可作为临时标题，目标模式下可从 repo/project name 推导一个保守标题。选中的 logo、favicon 方向、标题、被拒绝方案和资产路径必须记录到 design/，再继续 Product Design 原型。

场景对应前端基线：
Admin Console / 后台管理：使用 shadcn/ui + tweakcn。
BI 图表分析 / 数据驾驶舱：使用 React + Ant Design Pro + ECharts。
C 端网站 / App：不锁定框架，交给 Product Design 产出视觉方向和框架选择输入，后续在 plan-eng-review 中决策。

如果宿主机已安装 Product Design 插件，且当前还没有明确视觉目标，默认使用 Product Design get-context -> ideate -> 用户选择，生成至少 3 个原型/视觉方向并等待我选择。目标模式下可以选择系统推荐方案，但必须把推荐依据、选中的图、说明或引用保存或记录到 design/，并标记为 approved / selected / system-recommended accepted。

如果已有截图、URL、Figma、现有 UI 或足够清晰的设计说明，可直接把它们作为视觉目标记录到 design/，但必须补齐 approved visual target 记录和 implementation spec extraction。

如果 Product Design 不可用，不要要求我安装；使用当前场景的设计基线、已有 UI 参考、截图或设计说明继续推进。C 端场景如果缺少 Product Design 和视觉来源，应停止并要求补充视觉方向或参考。

只有当前模块足够复杂、需要人类协同对齐多页面/多状态/复杂交互时，才使用 Pencil App 产出 .pen 原型和导出截图。

如果是 Admin Console，shadcn/ui + tweakcn 是强制设计语言。Product Design 产出的每套原型/视觉方向必须包含 shadcn component / block mapping、Tailwind token / CSS variables 映射、8px spacing 决策、状态覆盖、Dialog / Sheet / detail page 选择、按钮规则、以及非 shadcn UI 框架未被引入的说明。

如果是 Admin Console 且宿主机已配置 shadcn MCP，可用它浏览和搜索 shadcn components / blocks 来辅助组件映射；未配置时使用 shadcn 官方文档、CLI 和项目已有组件，不阻塞原型工作。注意：shadcn MCP 可选不等于 shadcn/ui 可选。

如果是 BI 图表分析 / 数据驾驶舱，必须写清 Ant Design Pro 页面骨架、ECharts 图表映射、指标口径、筛选、联动、下钻、loading/empty/error/partial-data 状态和性能要求。

如果选定 shadcn/ui、Ant Design Pro、ECharts 或其他第三方框架，且原型和框架现有组件不一致，以前端框架组件、组合方式和 DESIGN.md 为准；原型只作为视觉和信息架构参考，不得因此自造一套平行组件系统。

输出必须包含：产品场景、DESIGN.md 遵循情况、framework baseline 或 Product Design 决策状态、至少三套方案或系统推荐方案依据、approved visual target 来源、target mockup 或引用、选择理由、implementation spec extraction、页面/组件范围、component/chart mapping、关键状态、响应式要求、是否需要 Pencil、以及下一步 Product Design 设计制品评审输入。Admin Console 还必须输出 shadcn component / block mapping、Tailwind token / CSS variable 映射、tweakcn 主题依据、shadcn MCP/CLI/文档来源、8px spacing、非 shadcn UI 框架排除情况和实现前需要检查的 shadcn 项目文件。implementation spec extraction 至少覆盖布局结构、导航、信息层级、交互状态、空/错/加载状态、关键 copy、颜色 token、字体、间距、响应式断点和验收截图计划。
```

Step 4:

```text
请使用 Product Design focused skills 审查 design/ 中已选定的设计制品 / 视觉目标；只有 Product Design 不可用时，才 fallback 到 gstack /plan-design-review。

设计制品可以是 Product Design 选中图、源截图、URL capture、Figma frame、现有 UI 参考、设计说明，或复杂协同场景下的 Pencil 原型。

审查必须严格比对 DESIGN.md 和选中原型/视觉目标，覆盖字体、间距、技术栈、组件体系、图表库、颜色 token、状态设计、响应式和可访问性。

如果是 Admin Console，必须额外审查选中原型是否符合 shadcn/ui + tweakcn：是否有具体 components / blocks mapping、是否使用 Tailwind token / CSS variables、是否遵守 8px spacing、是否避免随机颜色和无必要渐变、是否避免 Ant Design / Material UI / Chakra / Arco / Element / Bootstrap / Tailwind UI 等非授权 UI 框架视觉语言。

按阻塞、重要、可选分类给出问题，并迭代到没有关键设计阻塞。如果选定框架组件与原型不一致，以框架组件和 DESIGN.md 为准，并记录接受的偏差。

Codex 兼容要求：
如果 fallback 到 gstack /plan-design-review，按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 5:

```text
请使用 gstack /plan-eng-review 评审 [项目/功能] 的工程方案。

锁定架构、数据流、边界条件、测试策略、性能风险、权限/安全边界和发布风险。

如果是 Admin Console / 后台管理前端，必须按 shadcn/ui + tweakcn 评审，而不是只在计划已经写了 shadcn 时才评审。检查是否已有 components.json、Tailwind config、aliases、src/components/ui 或等价目录、registry 来源、是否允许使用 MCP 浏览/安装组件、CLI fallback 是什么、生成代码如何审查、是否遵守 8px spacing、token 颜色、无随机颜色、无无必要渐变和不随意创建自定义基础组件。

如果包含任何前端实现，必须评审 DESIGN.md、design/、Product Design 选中原型和第三方框架组件之间的一致性。若原型与 shadcn/ui、Ant Design Pro、ECharts 或其他选定框架组件不一致，以框架组件和 DESIGN.md 为准，原型作为参考并记录偏差。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 6:

```text
请使用 Superpowers writing-plans 为 [项目/功能] 生成 IMPLEMENTATION_PLAN.md。

计划必须包含明确文件路径、任务拆分、测试命令、预期输出和完成标准。

先判断当前是否为 CRM、Portal、Admin Console、dashboard、App 等 UI 密集项目：

如果是 UI 密集项目，本次优先写 Step 6A frontend fidelity plan，而不是一次性写前后端全量计划。Step 6A 必须引用 Step 3 approved visual target，并抽取 implementation spec：布局结构、路由、页面范围、组件清单、交互状态、空/错/加载状态、响应式断点、copy、颜色 token、字体、间距、shadcn component/block mapping、Tailwind token / CSS variable mapping、mock API / fixture / MSW / local data strategy、浏览器截图路径和 design QA 记录路径。计划要明确 Step 7A 用 mock 先还原，Step 8A 验证，Step 9A 截图，Step 10A 高保真门禁，Step 11A mock QA。等 Step 10A/11A 通过后，再写 Step 6B backend/API integration plan。

如果不是 UI 密集项目，或只是简单后端/脚本工作，可以写普通 Step 6 计划，但仍要说明为什么不需要 6A/6B 双循环。

如果包含前端实现，计划必须先要求读取 DESIGN.md 和 design/，并把字体、间距、技术栈、组件体系、图表库、颜色 token、响应式、状态设计和可访问性要求写入完成标准。

如果是 Admin Console / 后台管理前端，计划必须把 shadcn/ui + tweakcn 作为实现基线，即使 shadcn MCP 未配置也不能降级成泛 Tailwind 或其他 UI 框架。计划必须先检查 components.json、Tailwind 配置、aliases、src/components/ui 或等价组件目录、已安装 shadcn components / blocks 和现有项目 wrapper。

计划必须要求实现阶段全程遵守 AGENTS.md、CLAUDE.md、README、DESIGN.md、DEPLOY.md、IMPLEMENTATION_PLAN.md 和相关 docs/runbooks；如果使用 subagent-driven-development，每个 subagent brief 都必须显式包含这些治理文件、允许修改的文件边界、禁止偏离设计/工程规范的要求，以及回报规范遵循情况。

如果已有 Product Design 选中原型或视觉目标，计划必须写清如何使用 Product Design image-to-code 或 url-to-code 先切割原型形成前端框架，再按项目代码结构和选定组件库进行开发。

如果选定 shadcn/ui、Ant Design Pro、ECharts 或其他第三方框架，计划必须声明：当原型和框架已有组件不一致时，以前端框架组件和 DESIGN.md 为准，原型仅作视觉和信息架构参考。

如果包含 Admin Console 或其他 shadcn/ui 前端实现，计划还必须写清：需要使用的 shadcn components / blocks、是否使用 shadcn MCP 或 shadcn CLI、对应安装/查看命令、目标文件、fallback、代码审查点、8px spacing、design tokens、颜色来源、禁止随意自定义基础组件、禁止引入非授权 UI 框架，以及 Product Design 生成代码如何改造成 shadcn/ui 组件体系。Step 7A 可以先以还原为优先，代码洁癖后置，但完成 Step 10A 前必须回到 shadcn/ui primitives、项目已有组件和 Tailwind tokens。
```

Step 7:

```text
请使用 Superpowers executing-plans 或 subagent-driven-development，实现 IMPLEMENTATION_PLAN.md 的第一个 vertical slice。

开始前必须重新读取并遵守 AGENTS.md、CLAUDE.md、README、DESIGN.md、DEPLOY.md、IMPLEMENTATION_PLAN.md 和相关 docs/runbooks。实现过程中要持续对照这些规范，不得因为局部实现方便而偏离。如果发现计划、代码和治理文档冲突，先停下说明冲突并按项目治理优先级处理。

如果任务强耦合或文件边界不清晰，用 executing-plans。
如果已拆成可并行、边界清晰、互不踩代码的任务，用 subagent-driven-development。

如果使用 subagent-driven-development，每个 subagent 的任务说明必须带上 AGENTS.md、DESIGN.md、IMPLEMENTATION_PLAN.md 和相关治理文件约束，明确允许改动范围、禁止偏离 UI/UX/技术栈/测试/发布规则，并要求 subagent 回报遵循情况和任何偏差。

如果这是 frontend vertical slice，且 IMPLEMENTATION_PLAN.md 已明确文件路径、任务、测试和完成标准，可在实现过程中直接使用 Product Design image-to-code 或 url-to-code 辅助实现；但必须已有选中的视觉目标或 URL，且不得扩大到后续 slice。

frontend vertical slice 开始前必须读取 DESIGN.md 和 design/，并严格执行其中每一项要求，包括字体、间距、技术栈、组件体系、图表库、颜色 token、响应式、状态设计和可访问性。

如果当前执行的是 UI 密集项目的 Step 7A frontend mock implementation，先以高度还原 Step 3 approved visual target 为第一优先级，用 mock API、fixtures、MSW 或 local data 打通布局、导航、交互、空/错/加载状态和响应式。代码洁癖可以后置到同一轮收尾，但不得牺牲交互和布局还原；进入 Step 10A 前必须完成 shadcn/ui 或选定组件体系回归。

如果当前执行的是 Step 7B backend/API integration，不得重写已通过 Step 10A 的布局和交互。真实 API、权限、错误状态和数据密度接入后，任何 UI 变化都必须被记录为视觉回归风险，并留给 Step 9B/10B 验证。

如果已有 Product Design 选中原型或视觉目标，必须先使用 Product Design image-to-code 或 url-to-code 做原型切割，形成前端框架或页面骨架，再在项目现有代码和组件体系内开发。

如果这是 Admin Console / 后台管理前端，Product Design image-to-code 或 url-to-code 生成内容只能作为骨架。完成前必须改造成 shadcn/ui primitives、项目已有组件、Tailwind tokens 和 tweakcn/shadcn 主题变量；不得直接提交泛 React/Tailwind 组件、随机颜色、非 token 样式或未授权 UI 框架代码。

如果项目已配置 shadcn MCP，优先用 shadcn MCP 浏览、搜索、查看并引入计划中列出的 shadcn components / blocks；如果未配置，不要阻塞，实现时改用 shadcn CLI、官方文档和项目已有组件。

使用 shadcn MCP 或 CLI 引入组件后，必须检查生成代码、依赖、tokens、可访问性和响应式，不要盲装后直接提交。

如果 Admin Console 项目尚未初始化 shadcn/ui，必须按 IMPLEMENTATION_PLAN.md 中的任务先建立或补齐 shadcn/Tailwind 基线；不要因为项目缺少 components.json 就手写一套平行 UI。

如果原型与 shadcn/ui、Ant Design Pro、ECharts 或其他选定框架的已有组件不一致，以框架组件、项目已有组件和 DESIGN.md 为准；原型仅作视觉参考，不得因此创建平行组件体系。

无论哪种方式，都只完成第一个 vertical slice。要求可运行、可验证、端到端闭环，不展开后续切片。

完成前必须复核本次改动是否仍符合 AGENTS.md 和 DESIGN.md 等规范要求；发现偏差要立即修正或记录为需人工确认的偏差，不得直接声称完成。
```

Step 8:

```text
请使用 Superpowers verification-before-completion 对当前 vertical slice 做完成门禁。

运行新鲜的测试、构建、lint 或手动验证，并整理证据。没有证据不要声称完成。

如果当前是 UI 密集项目的 Step 8A，验证范围是 frontend/mock slice：typecheck、lint、unit/component tests、build、mock e2e 或明确的手动验证。不要把后端未完成当成 Step 8A 阻塞，但必须记录 mock 边界。

如果当前是 Step 8B，验证范围是 backend/API/integration slice：服务端测试、契约测试、迁移/权限检查、真实 API 调用、前后端集成构建或端到端验证。
```

Step 9:

```text
请优先使用 gstack /browse 验证当前实现。

覆盖关键页面、主路径、空/错/加载状态和桌面/移动视口。

如果当前是 UI 密集项目的 Step 9A，必须在 Step 10A Product Design 高保真门禁前执行。没有浏览器截图、交互路径和关键状态证据，不得进入 Step 10A。截图至少覆盖桌面和移动视口、主路径、关键 hover/focus/open/submit 交互，以及 empty/error/loading 状态。

如果当前是 Step 9B，必须使用真实后端或真实集成链路重新检查页面、数据密度、权限/错误状态和响应式；重点确认真实数据没有撑破布局、遮挡操作、破坏表格列宽或改变交互路径。

如果需要可视化实时观察、侧边栏活动流或人工跟看操作过程，补充使用 gstack open-gstack-browser。
记录 console/network 问题，保留截图，并在需要脚本化回归时补 Playwright 检查。

Codex 兼容要求：
如果任何 gstack 浏览器验证步骤需要用户决策，按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 10:

```text
请使用 Product Design focused skills 对已实现界面做视觉还原和交互 QA；只有 Product Design 不可用时，才 fallback 到 gstack /design-review。

必须读取 DESIGN.md、design/ 中的选中原型/视觉目标，以及当前已渲染实现截图。逐项比对字体、字号、间距、颜色 token、布局密度、组件形态、图表映射、响应式、状态设计、文案和可访问性。

如果当前是 UI 密集项目的 Step 10A，这一步是硬门禁，不是“看起来不错”。必须基于 Step 9A 截图和 Step 3 approved visual target 输出 target mockup/reference、browser screenshots、差异列表、严重级别、修复记录、before/after 截图或可复核说明，以及 accepted deviations。没有这些证据，不得标记 Step 10A 完成。

如果当前是 Step 10B，后端真实数据接入后必须做视觉回归。若 UI、布局、数据密度、状态或交互没有变化，可做 light visual regression 并说明依据；若发生任何相关变化，必须重新跑完整 Product Design gate，包含 target、截图、diff、fix、before/after 和 accepted deviations。

如果当前有 Product Design 源视觉目标和已渲染实现，使用 Product Design design-qa 生成或更新 design-qa.md，记录成品和原型图之间的差异、严重程度、修复建议和已接受偏差。

持续修复并重新比对，直到实现高度还原选中原型和 DESIGN.md，或偏差已被明确接受。

design-qa.md 不能替代功能 QA、代码 review 或后续 ship/deploy 门禁。

如果是 shadcn/ui 前端，请额外检查是否优先复用 shadcn/ui 和项目已有组件、是否遵守 8px spacing、是否使用 token 颜色、是否避免随机颜色和无必要渐变、是否避免随意创建自定义基础组件。

如果是 Ant Design Pro + ECharts 前端，请额外检查是否使用 Ant Design Pro 页面骨架、ProComponents 和 ECharts 映射，且图表口径、legend、tooltip、loading/empty/error/partial-data 状态符合 DESIGN.md。

当原型与选定框架已有组件不一致时，以前端框架组件、项目已有组件和 DESIGN.md 为准；原型仅作参考。所有偏差必须记录到 design-qa.md 或设计评审记录。

重点检查层级、间距、响应式、文案、状态和可访问性，并修复高优先级问题。

Codex 兼容要求：
如果 fallback 到 gstack /design-review，按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 11:

```text
请使用 gstack /qa 对当前功能做系统化功能 QA。

按风险优先级记录问题、修复、重新验证，并输出可复核结果。

如果当前是 UI 密集项目的 Step 11A，QA 范围是 frontend/mock functional QA，重点验证 mock 模式下导航、筛选、表格、表单、弹窗、抽屉、空/错/加载状态和响应式交互闭环。

如果当前是 Step 11B，QA 范围是完整真实后端功能 QA，重点验证权限、API 错误、真实数据边界、并发/重复提交、数据刷新、分页、搜索、导入导出或其他业务链路。

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
请做 Step 13 Git closeout / gstack /ship preflight。

检查 git status、diff、未提交、未 push、未 pull 状态，整理提交边界、远端状态、版本材料、CHANGELOG/发布说明缺口和后续 /ship 需要确认的授权动作。

这一步是 /ship 前置检查，不单独替代 gstack /ship。不要在未获授权时 push、创建 PR、merge、tag、release、上传镜像或 deploy。

执行完毕后，请按照 my-harness 规定的流程输出 `流程执行情况一览：` 15 步进度表，并在末尾继续给出下一步可直接复制执行的 `推荐提示词`。

如果项目已经在使用 my-harness，请创建或更新 `.my-harness/` 快速索引，记录步骤状态、关键决策、证据链接、验证命令和下一步提示词。Superpowers、gstack、Product Design、Pencil 等第三方技能生成的文档必须继续保留在其规范目录中，`.my-harness/` 只保存链接和简短摘要。

这个末尾提示词必须同时包含本句要求，让用户后续只需要复制末尾提示词继续推进，不需要重新询问 next action。
```

Step 14:

```text
请使用 gstack /ship 做最终收口。

整理 WIP、复核 Step 13 Git closeout 结论、确认 diff、运行必要验证、准备提交、版本、CHANGELOG 和发布说明，并按项目规则处理 push/PR。

需要授权的动作先确认。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

Step 15:

```text
请使用 gstack /land-and-deploy 在获得授权后完成合并、release、tag、部署等待和线上健康验证。

如果是 Docker 部署，还要构建、tag 并上传镜像，并完成部署流程要求的健康检查。

如果我后续还需要独立金丝雀监控，请不要把它混入第 15 步；改为直接调用 my-harness-canary。

Codex 兼容要求：
按 gstack 流程执行当前任务，但不要进入 Plan mode，也不要调用 AskUserQuestion、request_user_input 或任何交互式选择工具。

所有交互门禁都改为 Markdown 决策门禁，使用 D1/D2/D3 编号。每个决策项用表格呈现选项、推荐项、pros、cons 和影响范围。

在需要我决策时停止等待，不要继续进入下一阶段。除非我明确要求，否则只读分析，不修改项目文件。输出必须结构化、清晰、适合复制到文档。
```

## Common Mistakes

- Recommending step 1 because the conversation lacks context while the repo has artifacts. Inspect the repo first.
- Letting a blank or not-started project that explicitly asks for the `my-harness` framework skip the first Superpowers `brainstorming` gate.
- Treating Superpowers `brainstorming` output as approved design or as permission to skip directly to `writing-plans`. Step 1 produces candidate input; later Product Design planning review, design artifact review when needed, and `plan-eng-review` still challenge it unless the request is extremely simple.
- Marking Product Design planning review or `plan-eng-review` unnecessary after `brainstorming` because the brainstorm already proposed frontend/backend implementation details.
- Recommending a gstack prompt in Codex without the Codex-safe Markdown decision-gate guard.
- Continuing past a gstack decision point instead of stopping with `D1` / `D2` / `D3` Markdown decision tables.
- Treating Product Design as required infrastructure. It is preferred for visual targets when available, but optional; if unavailable, continue with shadcn/ui design governance, existing references, screenshots, or optional Pencil for complex alignment.
- Entering design planning or prototype design without title/logo/favicon and without using Creative Production `logo-explorer` or explicitly recording a deferral.
- Using Product Design `image-to-code` or `url-to-code` before `IMPLEMENTATION_PLAN.md` exists.
- Treating Product Design `design-qa.md` as a replacement for functional QA, code review, ship, or deploy.
- Treating shadcn MCP as mandatory. It is important when configured, but the fallback is shadcn CLI, official docs, and existing project components.
- Treating shadcn MCP as optional in a way that makes shadcn/ui optional for Admin Console. MCP is optional; the Admin Console shadcn/ui baseline is not.
- Using shadcn MCP or CLI to install components without recording the component source in the plan and reviewing the generated code.
- Accepting Product Design Admin Console prototypes that do not include shadcn component/block mapping, Tailwind token mapping, spacing decisions, state coverage, and explicit exclusion of non-shadcn UI frameworks.
- Accepting Product Design `image-to-code` / `url-to-code` output as final Admin Console implementation without refitting it to shadcn/ui primitives and project Tailwind tokens.
- Treating a written plan as implementation. Step 6 does not imply step 7.
- Using `subagent-driven-development` before `IMPLEMENTATION_PLAN.md` has clear task boundaries, ownership, and non-overlapping write scopes.
- Treating implementation as completion without fresh verification. Step 7 must flow into step 8.
- Letting `executing-plans` or subagents drift from `AGENTS.md`, `DESIGN.md`, `IMPLEMENTATION_PLAN.md`, or related governance docs.
- Sending subagents briefs without governance constraints, allowed file boundaries, no-drift requirements, and deviation reporting.
- Moving Superpowers, gstack, Product Design, Pencil, deployment, or release artifacts into `.my-harness/` instead of keeping them in native paths and indexing them.
- Treating `.my-harness/` as a second source of truth instead of a quick index and execution log.
- Skipping gstack `/browse` and design QA for UI work because automated tests passed.
- Calling `ship`, `land`, or `deploy` without checking authorization, clean diff, release materials, and remote state.
- Treating optional post-deploy `my-harness-canary` as a required step 16 in the canonical table.
