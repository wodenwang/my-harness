# Frontend Fidelity First Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Encode the frontend-first mock implementation and Product Design high-fidelity gate into my-harness without changing the canonical 15-step ledger.

**Architecture:** Keep the 15 canonical steps as the source of truth, and add an optional but default UI-project execution pattern inside Step 6-11: Frontend Fidelity Loop (6A-11A) followed by Backend Integration Loop (6B-11B). Update router docs, next-action prompts, design-governance skill, Admin Console template, and the old-project merge addendum so executors get the rule at every relevant entry point.

**Tech Stack:** Markdown skills/docs, Python design initializer script, shell verification via `./scripts/verify.sh`, `git diff --check`, and temporary project regression checks.

---

### Task 1: Update Core Harness SOP

**Files:**
- Modify: `AGENTS.md`
- Modify: `skills/my-harness/SKILL.md`
- Modify: `README.md`

- [ ] **Step 1: Add Frontend Fidelity First to canonical SOP**

Update the canonical loop text so UI/frontend/dashboard/app work states:

```markdown
前端高保真优先规则：对 CRM、Portal、Admin Console、dashboard、App 等 UI 密集项目，Step 6-11 默认拆成两轮执行证据，但不新增 canonical step 编号。第一轮是 Step 6A-11A Frontend Fidelity Loop：基于 Step 3 approved visual target 写前端计划、用 mock 打通界面和交互、提前跑 browser screenshots、通过 Product Design 高保真门禁和 mock QA。第二轮是 Step 6B-11B Backend Integration Loop：后端/API/真实数据接入后重新跑 integration verification、browser verification、视觉回归和功能 QA，防止真实数据破坏布局和交互。Step 12-15 不变。
```

- [ ] **Step 2: Strengthen Step 3 wording**

In `AGENTS.md`, `skills/my-harness/SKILL.md`, and `README.md`, replace loose `visual target` wording with `approved visual target`. Include these required evidence terms:

```text
approved / selected / system-recommended accepted
implementation spec extraction
target mockup
shadcn component/block mapping
Tailwind token / CSS variable mapping
```

- [ ] **Step 3: Update README phase description**

In `README.md`, add a short section after the phase table describing Frontend Fidelity First and make clear that Step 6A-11A / 6B-11B are sub-loops inside existing steps, not new canonical rows.

- [ ] **Step 4: Check core SOP terms**

Run:

```bash
rg -n "Frontend Fidelity|6A|10A|approved visual target|implementation spec extraction" AGENTS.md skills/my-harness/SKILL.md README.md
```

Expected: matches in all three files.

### Task 2: Update Next-Action Classification and Prompts

**Files:**
- Modify: `skills/my-harness-next-action/SKILL.md`

- [ ] **Step 1: Add classification rule**

Add a new section after `Product Design Frontend Rule`:

```markdown
### Frontend Fidelity First Rule

For UI-heavy projects such as CRM, Portal, Admin Console, dashboards, or apps, Step 6-11 should normally run as two evidence loops without renumbering the canonical SOP.

- Step 6A frontend writing plan must reference the Step 3 approved visual target and extract implementation spec.
- Step 7A frontend mock implementation prioritizes fidelity first, then code cleanup, and must finish on shadcn/ui or the selected project component system.
- Step 9A browser verification must run before Step 10A because Product Design QA needs screenshots as evidence.
- Step 10A is a hard Product Design fidelity gate with target mockup, screenshots, differences, fixes, before/after evidence, and accepted deviations.
- Step 6B-11B integrate backend and real data, then rerun browser verification, visual regression, and functional QA.
```

- [ ] **Step 2: Update canonical sequence rows**

Expand rows 3, 6, 7, 8, 9, 10, and 11 so the completion evidence names the A/B loop requirements for UI projects.

- [ ] **Step 3: Update prompt templates**

In the Step 3 prompt, require `approved visual target` and implementation spec extraction.

In the Step 6 prompt, require the executor to choose between:

```text
UI-heavy project: write Step 6A frontend fidelity plan first, then after 10A/11A write Step 6B backend integration plan.
Non-UI or simple backend work: write a normal Step 6 plan.
```

In the Step 7 prompt, require `image-to-code` / `url-to-code` scaffold adaptation, mock coverage, and final shadcn/ui compliance for Admin Console.

In the Step 9 prompt, require Step 9A screenshots before Step 10A.

In the Step 10 prompt, require differences, fixes, before/after, target mockup, and accepted deviations.

- [ ] **Step 4: Check next-action terms**

Run:

```bash
rg -n "Frontend Fidelity First Rule|Step 6A|Step 7A|Step 9A|Step 10A|Step 6B|before/after" skills/my-harness-next-action/SKILL.md
```

Expected: each term appears.

### Task 3: Update Writing-Design Governance and Old-Project Addendum

**Files:**
- Modify: `skills/my-harness-writing-design/SKILL.md`
- Modify: `skills/my-harness-writing-design/templates/DESIGN.shadcn-admin-console.md`
- Modify: `skills/my-harness-writing-design/scripts/harness_write_design.py`

- [ ] **Step 1: Update writing-design skill**

Add explicit requirements:

```markdown
- Existing `DESIGN.md` refreshes must include the latest Frontend Fidelity First governance section.
- Admin Console design input must define how Step 3 produces an approved visual target, not just options.
- Design input must include implementation spec extraction fields: layout, component inventory, states, responsive behavior, token mapping, shadcn mapping, screenshots, and accepted deviations.
```

- [ ] **Step 2: Update Admin Console template**

Add a section named `前端高保真先行门禁` to the template. It must require:

```markdown
- Step 3 approved visual target path/reference
- Step 6A frontend fidelity plan extracts implementation spec
- Step 7A mock implementation uses Product Design scaffold only as a starting point
- Step 9A screenshots before Step 10A
- Step 10A target/screenshot/diff/fix/before-after/accepted-deviation record
- Step 6B-11B backend integration visual regression
```

- [ ] **Step 3: Update Python addendum**

In `latest_design_governance_section()`, add a `### 前端高保真先行门禁` subsection with the same requirements. Keep the marker behavior unchanged so existing `DESIGN.md` files are updated idempotently.

- [ ] **Step 4: Check design governance terms**

Run:

```bash
rg -n "前端高保真先行门禁|approved visual target|Step 6A|Step 10A|before/after" skills/my-harness-writing-design
```

Expected: matches in the skill, template, and script.

### Task 4: Update Maintenance and History

**Files:**
- Modify: `CHANGELOG.md`
- Modify: `docs/maintenance.md`
- Modify: `docs/project-history.md`

- [ ] **Step 1: Add changelog entry**

Under `Unreleased`, add a bullet that says my-harness now supports Frontend Fidelity First for UI-heavy projects, with Step 6A-11A and Step 6B-11B as evidence sub-loops.

- [ ] **Step 2: Add maintenance notes**

Document that future SOP changes must preserve the 15-step canonical ledger while allowing A/B evidence under Step 6-11 for UI-heavy projects.

- [ ] **Step 3: Add project history note**

Record the decision date and rationale: user selected frontend-first + mock + Product Design high-fidelity gate, borrowing gstack's approved target, screenshot evidence, and before/after fix loop.

- [ ] **Step 4: Check release notes**

Run:

```bash
rg -n "Frontend Fidelity|前端高保真|6A|10A|before/after" CHANGELOG.md docs/maintenance.md docs/project-history.md
```

Expected: matches in all three files.

### Task 5: Verification and Regression

**Files:**
- Test only: no source edits unless verification fails.

- [ ] **Step 1: Run repository verification**

Run:

```bash
./scripts/verify.sh
```

Expected output includes:

```text
manifest ok
skills ok
verify ok
```

- [ ] **Step 2: Run whitespace check**

Run:

```bash
git diff --check
```

Expected: no output and exit code 0.

- [ ] **Step 3: Run old-project design merge regression**

Create a temporary project with an existing custom `DESIGN.md`, run:

```bash
python3 skills/my-harness-writing-design/scripts/harness_write_design.py --project-root "$tmpdir" --scenario admin-console --project-name LegacyCRM --force
python3 skills/my-harness-writing-design/scripts/harness_write_design.py --project-root "$tmpdir" --scenario admin-console --project-name LegacyCRM --force
```

Check:

```bash
rg -n "Custom Brand|MY_HARNESS_DESIGN_GOVERNANCE|前端高保真先行门禁|Step 6A|Step 10A" "$tmpdir/DESIGN.md"
python3 - "$tmpdir" <<'PY'
from pathlib import Path
import sys
root = Path(sys.argv[1])
design = (root / "DESIGN.md").read_text()
agents = (root / "AGENTS.md").read_text()
print("design_marker_count=", design.count("MY_HARNESS_DESIGN_GOVERNANCE_START"))
print("agents_marker_count=", agents.count("MY_HARNESS_AGENTS_DESIGN_START"))
assert "Custom Brand" in design
assert "前端高保真先行门禁" in design
assert design.count("MY_HARNESS_DESIGN_GOVERNANCE_START") == 1
assert agents.count("MY_HARNESS_AGENTS_DESIGN_START") == 1
PY
```

Expected: custom content preserved, new section appears, both marker counts equal 1.

- [ ] **Step 4: Check pycache**

Run:

```bash
find . \( -name '__pycache__' -o -name '*.pyc' \) -print
```

Expected: no output.
