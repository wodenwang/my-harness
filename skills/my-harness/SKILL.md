---
name: my-harness
description: Use when coordinating personal harness workflows, choosing among harness skills, extending the user's gstack Superpowers Product Design optional Pencil browser verification Git delivery loop, or deciding where a new harness helper belongs
---

# My Harness

## Purpose

This is the router skill for the user's personal project-delivery harness. It groups small, single-purpose harness skills instead of growing one large workflow document.

## Routing

| Situation | Use |
|---|---|
| User is unsure where the project is in the delivery loop | `my-harness-next-action` |
| User needs the next gstack / Superpowers / Product Design / optional Pencil / browser verification / Git action and a prompt | `my-harness-next-action` |
| User needs to initialize a new or mostly empty project repository with baseline governance | `my-harness-initialize-project` |
| Project needs starter `README.md`, `AGENTS.md`, design/deployment links, and first harness handoff | `my-harness-initialize-project` |
| Project needs design governance before UI work | `my-harness-writing-design` |
| Project needs `DESIGN.md`, `design/`, design artifact guidance, optional Pencil coordination, or AGENTS design links | `my-harness-writing-design` |
| Project needs a shadcn/ui Admin Console design baseline | `my-harness-writing-design` |
| Project needs a BI dashboard, chart analytics, data cockpit, or data big screen design baseline | `my-harness-writing-design` |
| Project needs C-end website/app design governance without locking a frontend framework | `my-harness-writing-design` |
| User wants a clear small slice to run through the whole SOP automatically after Discovery / Brainstorm gate is finalized | `my-harness-autopilot-slice` |
| User wants to update, upgrade, version-check, or refresh the installed `my-harness` plugin from GitHub | `my-harness-upgrade` |
| Project needs `DEPLOY.md`, versioned Docker Compose deployment governance, `install.sh` / `upgrade.sh` rules, DB init SQL, DB migrations, config migration rules, or AGENTS / CLAUDE deployment links | `my-harness-writing-deployment` |
| User wants optional post-deploy canary monitoring on a live URL, with findings registered as GitHub issues and no fixes applied | `my-harness-canary` |
| User wants daily, weekly, or recurring Codex-timer canary checks after deployment | `my-harness-canary` |
| User wants to add another recurring harness helper | Create a new focused skill under this plugin, then update this routing table |

## Current Harness Loop

The 15 step numbers are the canonical evidence ledger. For user-facing guidance, group them into phases so the flow feels like a small set of work packages rather than 15 unrelated commands.

| Phase | Steps | User-facing purpose |
|---|---:|---|
| 1. Discovery and direction | 1-2 | Clarify whether the work is worth doing, who it serves, what the smallest useful slice is, and whether the early product/interaction direction survives review. |
| 2. Design baseline and visual target | 3-4 | Create or confirm the design artifact, visual target, component/chart mapping, and review the chosen design input before engineering planning. |
| 3. Engineering plan | 5-6 | Challenge architecture, data flow, risks, tests, and then write the executable implementation plan. |
| 4. First runnable slice | 7-8 | Implement the first end-to-end vertical slice and verify it with fresh evidence. |
| 5. Browser, visual, and functional QA | 9-11 | Validate the real app in browser, review UI/interaction quality, and run systematic functional QA. |
| 6. Review, ship, and deploy | 12-15 | Review the diff, perform Git closeout as ship preflight, prepare release materials, and land/deploy with health verification after authorization. |

`my-harness-next-action` may recommend a whole phase work package when adjacent steps are ready to run together, but the final status table must still keep all 15 rows.

1. Discovery / Brainstorm gate: gstack `/office-hours` by default, or Superpowers `brainstorming` when value and target are already clear and the work needs candidate design/spec convergence
2. gstack `/plan-design-review`
3. Design artifact / visual target: Product Design `get-context` -> `ideate` -> user selection by default when no visual target exists; existing screenshots, URL captures, Figma frames, current UI, or design notes may also qualify; Pencil prototype is optional for complex modules or human alignment
4. gstack `/plan-design-review` on selected design artifact
5. gstack `/plan-eng-review`
6. Superpowers `writing-plans`
7. Superpowers `executing-plans` or `subagent-driven-development`
8. Superpowers `verification-before-completion`
9. gstack `/browse` verification, with `open-gstack-browser` when visible real-time browser control is needed and Playwright for scripted fallback/regression
10. gstack `/design-review`
11. gstack `/qa`
12. gstack `/review`
13. Git closeout / `/ship` preflight
14. gstack `/ship`
15. gstack `/land-and-deploy`

Optional after step 15: run `my-harness-canary` directly when the user wants post-deploy canary monitoring for a live production, staging, or preview URL. This optional follow-up is not required for SOP closure. Canary findings are recorded as GitHub issues in the monitored project; do not fix them during the canary step.

Frontend design rule: when Product Design is installed and the current UI slice would benefit from visual exploration or visual-fidelity implementation, use its focused skills directly inside the 15-step table. Product Design may create a visual target in step 3 through `get-context` -> `ideate` -> user selection, assist `image-to-code` / `url-to-code` inside step 7 after `IMPLEMENTATION_PLAN.md` exists, or provide `design-qa.md` evidence before step 10. If Product Design is unavailable, do not require installation; continue with the shadcn/ui design baseline, existing UI references, screenshots, or Pencil only when human alignment requires it.

Frontend framework baseline: `my-harness-writing-design` must first resolve product scenario. Admin Console uses shadcn/ui + tweakcn. BI chart analysis, analytics dashboards, and data cockpits use React + Ant Design Pro + ECharts. C-end websites/apps do not lock a framework in writing-design; Product Design output feeds the later `plan-eng-review` framework decision. If the scenario is unclear, ask and stop before initializing files.

Optional shadcn MCP enhancement: when shadcn MCP is configured and the selected scenario is Admin Console, use it as the preferred shadcn/ui registry tool for browsing, searching, inspecting, and installing components or blocks during frontend work. It fits inside existing steps: step 3 component mapping, step 5 engineering review of MCP/CLI/registry strategy, step 6 implementation planning, step 7 component installation/integration, and step 10 design review. If shadcn MCP is unavailable, do not block the SOP; fall back to shadcn CLI, official docs, and existing project components.

When step 1 used Superpowers `brainstorming`, completing that gate does not make the work ready for Superpowers `writing-plans`. The next action must still move through `plan-design-review`, a design artifact or visual target when needed, and `plan-eng-review` before step 6, unless the current request is extremely simple enough that both design and engineering plan reviews are genuinely unnecessary.

Even if the brainstorming output already includes frontend and backend implementation ideas, treat them as candidate inputs. Use `plan-design-review` and `plan-eng-review` to challenge and improve the product, frontend, and engineering plan before writing `IMPLEMENTATION_PLAN.md`.

## Codex-Safe Gstack Gate Rule

Codex cannot reliably handle `AskUserQuestion` inside several gstack skills. Whenever this harness routes to or recommends gstack `/office-hours`, `/plan-design-review`, `/plan-eng-review`, `/design-review`, `/qa`, `/review`, `/ship`, `/land-and-deploy`, `/canary`, or any other gstack skill that may ask the user interactively:

- Follow the gstack reasoning flow, but do not enter Plan mode.
- Do not call `AskUserQuestion`, `request_user_input`, or any interactive choice tool.
- Convert every interaction gate into a Markdown decision gate.
- Number decisions as `D1`, `D2`, `D3`.
- Present each decision in a table with options, recommended option, pros, cons, and scope/impact.
- Stop and wait when the user must decide; do not continue into the next stage.
- Unless the user explicitly asks for edits, keep the step read-only and do not modify project files.
- Make the output structured, clear, and suitable for copying into documentation.

## Extension Rule

Add a new harness skill when the helper has a distinct job, trigger, artifacts, and completion check. Do not merge unrelated phases into one skill just because they share the harness name.

Preferred naming:

- `my-harness-<verb>-<object>`
- Examples: `my-harness-next-action`, `my-harness-writing-design`, `my-harness-autopilot-slice`, `my-harness-upgrade`, `my-harness-release-closeout`, `my-harness-checkpoint`

Each new skill should include:

- trigger-only frontmatter description beginning with `Use when`
- required evidence or inputs
- exact outputs
- conservative write rules
- verification commands or checks
- common mistakes

## Output Style

When used as a router, answer briefly:

```markdown
应使用：`<skill-name>`
原因：...
下一步：...
推荐提示词：
> ...
```
