---
name: my-harness
description: Use when coordinating personal harness workflows, choosing among harness skills, extending the user's gstack Superpowers Pencil browser verification Git delivery loop, or deciding where a new harness helper belongs
---

# My Harness

## Purpose

This is the router skill for the user's personal project-delivery harness. It groups small, single-purpose harness skills instead of growing one large workflow document.

## Routing

| Situation | Use |
|---|---|
| User is unsure where the project is in the delivery loop | `my-harness-next-action` |
| User needs the next gstack / Superpowers / Pencil / browser verification / Git action and a prompt | `my-harness-next-action` |
| Project needs design governance before UI work | `my-harness-writing-design` |
| Project needs `DESIGN.md`, `design/`, a Pencil starter, or AGENTS design links | `my-harness-writing-design` |
| Project needs Ant Design vs shadcn/ui design-template selection | `my-harness-writing-design` |
| User wants a clear small slice to run through the whole SOP automatically after office-hours is finalized | `my-harness-autopilot-slice` |
| User wants to update, upgrade, version-check, or refresh the installed `my-harness` plugin from GitHub | `my-harness-upgrade` |
| User wants to add another recurring harness helper | Create a new focused skill under this plugin, then update this routing table |

## Current Harness Loop

1. gstack `/office-hours`
2. gstack `/plan-design-review`
3. Pencil prototype
4. gstack `/plan-design-review` on prototype
5. gstack `/plan-eng-review`
6. Superpowers `writing-plans`
7. Superpowers `executing-plans` or `subagent-driven-development`
8. Superpowers `verification-before-completion`
9. gstack `/browse` verification, with `open-gstack-browser` when visible real-time browser control is needed and Playwright for scripted fallback/regression
10. gstack `/design-review`
11. gstack `/qa`
12. gstack `/review`
13. Git closeout
14. gstack `/ship`
15. gstack `/land-and-deploy`

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
