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
6. If all applicable steps are complete, report that the SOP is closed and do not recommend restarting at office-hours.
7. Include no more than one optional catch-up action unless a blocker makes it necessary.

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
- Do not recommend `gstack /office-hours` to start a new loop.
- Still provide the full 15-step overview table.
- Mark completed steps as `✅ 前置已完成`.
- Mark intentionally skipped or inapplicable steps as `⏭️ 前置无需进行`.
- If any step lacks evidence, the SOP is not closed; mark the first missing gate as `⚠️ 证据不足` instead.
- In the "下一步 harness 动作" section, write `无。当前 SOP 已闭环。`
- Omit the copyable prompt block unless there is a genuine optional follow-up requested by the user.

## Canonical Sequence

| Step | Harness action | Completion evidence |
| -: | - | - |
| 1 | gstack `/office-hours` | clarified goal, user, constraints, smallest worthwhile slice |
| 2 | gstack `/plan-design-review` | early product/interaction direction reviewed |
| 3 | Pencil App prototype | `.pen` source, screenshot/export, design notes |
| 4 | gstack `/plan-design-review` on prototype | prototype review findings resolved or accepted |
| 5 | gstack `/plan-eng-review` | architecture, data flow, risks, test strategy locked |
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
| ✅ | 1 | gstack `/office-hours` | 前置已完成 | ... |
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

## Prompt Templates

Replace bracketed fields before use.

| Next step | Suggested prompt |
| -: | - |
| 1 | `请使用 gstack /office-hours 帮我澄清 [项目/版本/功能]：目标用户、核心痛点、约束、最小可行切片、是否值得做，并输出可进入设计评审的结论。` |
| 2 | `请使用 gstack /plan-design-review 审视 [项目/功能] 的早期产品和交互方向，指出关键体验风险、信息架构、主路径、空/错/加载状态，并给出进入 Pencil 原型前的修改建议。` |
| 3 | `请使用 Pencil App 为 [项目/功能] 产出 Ant Design 风格原型，保存 .pen 源文件、导出关键页面截图，并写一份简短设计说明到 design/。` |
| 4 | `请使用 gstack /plan-design-review 审查 design/ 中的 Pencil 原型和截图，按阻塞/重要/可选分类给出问题，并迭代到没有关键设计阻塞。` |
| 5 | `请使用 gstack /plan-eng-review 评审 [项目/功能] 的工程方案，锁定架构、数据流、边界条件、测试策略、性能风险、权限/安全边界和发布风险。` |
| 6 | `请使用 Superpowers writing-plans 为 [项目/功能] 生成 IMPLEMENTATION_PLAN.md，包含明确文件路径、任务拆分、测试命令、预期输出和完成标准。` |
| 7 | `请使用 Superpowers executing-plans 或 subagent-driven-development 实现 IMPLEMENTATION_PLAN.md 的第一个 vertical slice：如果任务强耦合或文件边界不清晰，用 executing-plans；如果已拆成可并行、边界清晰、互不踩代码的任务，用 subagent-driven-development。无论哪种方式，都只完成第一个 vertical slice，要求可运行、可验证、端到端闭环，不展开后续切片。` |
| 8 | `请使用 Superpowers verification-before-completion 对当前 vertical slice 做完成门禁，运行新鲜的测试/构建/lint/手动验证，并整理证据；没有证据不要声称完成。` |
| 9 | `请优先使用 gstack /browse 验证当前实现，覆盖关键页面、主路径、空/错/加载状态和桌面/移动视口；如果需要可视化实时观察、侧边栏活动流或人工跟看操作过程，补充使用 gstack open-gstack-browser；记录 console/network 问题、保留截图，并在需要脚本化回归时补 Playwright 检查。` |
| 10 | `请使用 gstack /design-review 对已实现界面做视觉和交互 QA，重点检查层级、间距、响应式、文案、状态和可访问性，并修复高优先级问题。` |
| 11 | `请使用 gstack /qa 对当前功能做系统化功能 QA，按风险优先级记录问题、修复、重新验证，并输出可复核结果。` |
| 12 | `请使用 gstack /review 做落地前代码审查，检查 diff 风险、测试缺口、数据/权限/安全边界和可维护性问题，先列 finding 再给总结。` |
| 13 | `请做 Git 收口：检查 git status、diff、未提交/未 push/未 pull 状态，整理提交边界和发布材料；不要在未获授权时 push、merge 或 release。` |
| 14 | `请使用 gstack /ship 做最终收口：整理 WIP、确认 diff、运行必要验证、准备提交/版本/CHANGELOG/发布说明，并按项目规则处理 push/PR；需要授权的动作先确认。` |
| 15 | `请使用 gstack /land-and-deploy 在获得授权后完成合并、release、tag、部署等待和线上健康验证；如果是 Docker 部署，还要构建、tag 并上传镜像后做 canary。` |

## Common Mistakes

- Recommending step 1 because the conversation lacks context while the repo has artifacts. Inspect the repo first.
- Treating a written plan as implementation. Step 6 does not imply step 7.
- Using `subagent-driven-development` before `IMPLEMENTATION_PLAN.md` has clear task boundaries, ownership, and non-overlapping write scopes.
- Treating implementation as completion without fresh verification. Step 7 must flow into step 8.
- Skipping gstack `/browse` and design QA for UI work because automated tests passed.
- Calling `ship`, `land`, or `deploy` without checking authorization, clean diff, release materials, and remote state.
