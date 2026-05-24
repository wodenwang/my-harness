# Project History

This document captures the useful decisions from the initial one-conversation build of `my-harness`.

## Origin

The plugin started as a way to answer one recurring question during project delivery:

> I am pushing a project forward, but I do not know where I am in the harness. What should I do next?

The first implementation packaged that answer into `my-harness-next-action`, then grew into a plugin so future harness helpers could live under one namespace.

## Core Decisions

- The plugin is called `my-harness`.
- Skill names use `my-harness-*`.
- The router skill is `my-harness`.
- The next-action skill is `my-harness-next-action`.
- The design-governance skill is `my-harness-writing-design`.
- The bounded closed-loop execution skill is `my-harness-autopilot-slice`.

## Canonical Flow

| Step | Harness action |
|---:|---|
| 1 | gstack `/office-hours` |
| 2 | gstack `/plan-design-review` |
| 3 | Pencil prototype |
| 4 | gstack `/plan-design-review` on prototype |
| 5 | gstack `/plan-eng-review` |
| 6 | Superpowers `writing-plans` |
| 7 | Superpowers `executing-plans` or `subagent-driven-development` |
| 8 | Superpowers `verification-before-completion` |
| 9 | gstack `/browse`, optional `open-gstack-browser`, Playwright fallback |
| 10 | gstack `/design-review` |
| 11 | gstack `/qa` |
| 12 | gstack `/review` |
| 13 | Git closeout |
| 14 | gstack `/ship` |
| 15 | gstack `/land-and-deploy` |

## Important Behavior Contracts

- `my-harness-next-action` must inspect artifacts before recommending step 1.
- If the SOP is already closed, it must say `当前 SOP 已闭环。` and provide the full status table instead of starting a new office-hours loop.
- The next-action table must include all 15 steps and use the agreed emoji status markers.
- Recommended prompts must be standalone fenced `text` blocks.
- `my-harness-writing-design` creates design-governance scaffolding and may call Pencil/Ant Design tools when available.
- `my-harness-autopilot-slice` is only for small, bounded work after office-hours is finalized.
- Autopilot loops `design-review`, `qa`, and `review` until clear, accepted, blocked, or 10 iterations.
- Autopilot must summarize every key step and loop metric whether it completes or hands off.
