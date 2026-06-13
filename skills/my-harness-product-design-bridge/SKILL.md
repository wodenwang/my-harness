---
name: my-harness-product-design-bridge
description: Use when a frontend or UI slice can optionally use the Product Design plugin for visual targets, prototype generation, URL/image-to-code work, or design-qa evidence inside the my-harness SOP
---

# My Harness Product Design Bridge

## Purpose

Coordinate the optional Product Design plugin inside the existing `my-harness` frontend flow without replacing the 15-step SOP.

Product Design is an accelerator, not a dependency. If the host Codex environment does not have the Product Design plugin or focused skills available, fall back to the original `my-harness` flow: `plan-design-review`, Pencil prototype, prototype review, `plan-eng-review`, Superpowers planning/execution, browser verification, design review, QA, review, ship, and land/deploy.

## When To Use

Use this bridge when:

- a frontend, UI, screen, flow, redesign, prototype, or visual implementation slice has no approved visual target yet
- the user provides a URL, screenshot, Figma frame, mockup, image, ImageGen result, or existing code surface and wants a clickable prototype or frontend implementation
- Product Design can help create or compare a visual target before implementation
- `design-qa.md` could provide useful visual-fidelity evidence before `gstack /design-review`

Do not use this bridge for backend-only work, deployment work, release work, or broad product discovery that still belongs in step 1.

## Dependency Rule

Product Design is optional.

- Do not require installation.
- Do not block the SOP because Product Design is missing.
- Do not ask the user to install Product Design just to continue `my-harness`.
- If Product Design is unavailable, say so briefly and continue with the original Pencil-centered flow.
- If Product Design is available but a required source cannot be opened or captured, stop only the Product Design branch and fall back to the normal harness gate unless the missing source is also required by the project.

## Placement In The SOP

The canonical 15 steps remain unchanged.

### Design Stage Enhancement

Between step 2 and step 3, Product Design may be used as an optional visual-target branch:

1. If there is no visual target, use Product Design `get-context`.
2. After the brief is confirmed, use Product Design `ideate`.
3. Generate exactly three visual options unless the user explicitly requested another count.
4. Stop and wait for the user to choose one.
5. Treat the selected option as the frontend visual target.
6. Save or reference the selected image and notes under `design/`.
7. Continue to step 3: Pencil remains the formal design-governance artifact.

Pencil remains the official project design source. Product Design outputs can seed Pencil, but they do not replace `.pen`, exported screenshots, or `DESIGN.md` unless the project explicitly records a different design governance rule.

### Implementation Stage Enhancement

During step 7, Product Design `image-to-code` or `url-to-code` may help implement the first frontend vertical slice only when all are true:

- step 6 has produced `IMPLEMENTATION_PLAN.md`
- the plan names the frontend slice, files, tests, and done criteria
- there is a selected visual target or source URL
- the implementation stays within the first vertical slice

Product Design implementation does not replace Superpowers execution discipline. It is one implementation method inside step 7.

### Visual QA Enhancement

Before or during step 10, Product Design `design-qa` may provide visual-fidelity evidence when both artifacts exist:

- source visual target: selected image, screenshot, Figma frame, mockup, or URL capture
- rendered implementation: local URL, deployed URL, app screen, or screenshot

`design-qa.md` can support step 10, but it does not replace:

- step 8 `verification-before-completion`
- step 9 browser verification
- step 10 `gstack /design-review`
- step 11 `gstack /qa`
- step 12 `gstack /review`
- step 14 `/ship`
- step 15 `/land-and-deploy`

## Routing

| Situation | Product Design route | Harness fallback |
|---|---|---|
| No visual target for a UI slice | `get-context` -> `ideate` -> user selects one option | Step 3 Pencil prototype from `plan-design-review` output |
| User provides screenshot, mockup, Figma frame, ImageGen result, or image | `get-context` -> `image-to-code` | Step 3 Pencil prototype, then normal step 7 implementation |
| User provides a URL to recreate or extend | `get-context` -> `url-to-code` | Capture reference manually, create Pencil prototype, then normal step 7 implementation |
| Existing app needs redesign exploration | `get-context` -> inspect existing surface -> `ideate` -> user selects one option | Step 2/3/4 normal design review and Pencil iteration |
| Implemented UI has a source visual and rendered screenshot | `design-qa` before `gstack /design-review` | Step 9 browser evidence plus step 10 `gstack /design-review` |
| Product Design is unavailable | Do not route | Continue original `my-harness` flow |

## Required Evidence

When using Product Design, record enough evidence in `design/` or the project notes for the next harness step to understand the source of truth:

- confirmed design brief
- selected visual option or source URL/screenshot
- where the image, screenshot, prototype, or `design-qa.md` is stored
- whether the selected Product Design output has been incorporated into Pencil
- any fallback reason if Product Design was skipped or unavailable

## Conservative Write Rules

- Do not modify production code before step 6 exists.
- Do not use `image-to-code` or `url-to-code` to bypass `IMPLEMENTATION_PLAN.md`.
- Do not replace an existing approved Pencil prototype with a Product Design output unless the user explicitly approves the replacement.
- Do not make Product Design a required dependency in README, AGENTS, or generated project governance.
- Do not mark a frontend slice complete from `design-qa.md` alone.

## Completion Check

This bridge is complete when it has done one of these:

- selected and recorded the Product Design route and next harness step
- created or selected a visual target and recorded where it lives
- produced `design-qa.md` as supporting evidence before step 10
- explicitly fallen back to the original Pencil-centered flow because Product Design is unavailable or unsuitable

## Common Mistakes

- Treating a Product Design brief as a visual target. A brief alone is not enough; use `ideate` and wait for user selection.
- Starting `image-to-code` before `IMPLEMENTATION_PLAN.md` exists.
- Treating Product Design as a replacement for Pencil, `gstack /design-review`, QA, or code review.
- Requiring users to install Product Design before `my-harness` can continue.
- Leaving Product Design outputs outside `design/` with no durable reference.
