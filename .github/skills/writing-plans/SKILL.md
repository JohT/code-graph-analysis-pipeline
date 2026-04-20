---
name: writing-plans
description: Use when a spec or requirements exist for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write plans assuming engineer: zero codebase context, questionable taste. Document all: files per task, code, testing, docs, how to test. Bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume skilled dev, knows almost nothing about toolset/domain, poor test design.

**Announce at start:** "Using writing-plans skill."

**Context:** Run in dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences override.)

## Scope Check

Spec covers multiple independent subsystems? Should've been split during brainstorming. If not, suggest separate plans — one per subsystem. Each plan: working, testable software on its own.

## File Structure

Before tasks, map files to create/modify and responsibilities. Decomposition locks in here.

- Design units: clear boundaries, defined interfaces. One responsibility per file.
- Focused files = reliable edits. Prefer smaller, focused files.
- Files that change together: live together. Split by responsibility, not technical layer.
- Existing codebases: follow patterns. Large files — don't restructure unilaterally. File grown unwieldy → split in plan is reasonable.

Structure informs task decomposition. Each task: self-contained, independent.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step needs actual content. These are **plan failures** — never write:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat code — engineer may read tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Remember
- Exact file paths always
- Complete code in every step — if step changes code, show code
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits

## Self-Review

After writing plan, check against spec. Run yourself — not subagent.

**1. Spec coverage:** Skim each spec section. Point to implementing task? List gaps.

**2. Placeholder scan:** Search for red flags from "No Placeholders" section. Fix them.

**3. Type consistency:** Types, signatures, property names match across tasks? `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 = bug.

Issues found: fix inline. No re-review. Missing requirement: add task.

## Execution Handoff

After saving, offer choice:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - Dispatch fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in session using executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per task + two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Batch execution with checkpoints for review
