# Plan: Update SCIP Cross-File Import to Complete Mode

**Objective:** Convert `convertScipIndexToCsvForNeo4jCrossFileImport.sh` from "cross-file" filtering (export-focused) to "complete" mode (includes unexported functions with outbound cross-file calls).

**Key Insight:** The current cross-file import misses 1,722 edges and 391 cyclic dependencies. Complete mode recovers ~95% of these by including functions that don't export but DO call other modules.

**Status:** Planning  
**Date:** 2026-11-15

---

## Problem Statement

**Current State:**
- SCIP cross-file mode includes only functions that are referenced from other files
- This excludes internal functions that call external functions (not exported)
- Result: 1,722 missing cross-file edges, 391 broken cycles

**Target State:**
- Include ALL symbols that participate in cross-file communication:
  - Symbols referenced from other files (current behavior) ✓
  - Symbols that make cross-file calls (new behavior) ✓
- Symbols only with same-file dependencies remain excluded
- Graph size increase: ~3-8% more symbols (manageable)

---

## Scope

**In Scope:**
- Update core conversion script logic
- Extend and adapt existing tests
- Update domain README documentation
- Create new verification analysis document
- Follow all instruction files (shell-scripts, cypher-queries)

**Out of Scope:**
- No new environment variables (use existing SCIP_IMPORT_MODE logic internally)
- No separate script file (modify existing script directly)
- No breaking changes to interface
- Verification directory (temporary, not committed)

---

## Implementation Plan

### Phase 1: Analysis & Planning (This Session)
- [x] Read critical findings summary
- [x] Understand current implementation
- [x] Review instruction files
- [x] Ask clarifying questions
- [ ] Finalize detailed plan

### Phase 2: Core Implementation
**File: `convertScipIndexToCsvForNeo4jCrossFileImport.sh`**

1. **Update description header**
   - Clarify that script uses "complete" mode (includes unexported outbound)
   - Document what's included vs excluded

2. **Add new jq function**
   - Detect if a symbol makes cross-file calls (outbound references)
   - Similar to existing `symbol_has_cross_file_reference` but inverted logic

3. **Update Pass 1 (symbol analysis)**
   - Current: Include symbol if it's referenced from another file
   - New: Include symbol if referenced OR if it makes cross-file calls

4. **Verify Pass 2-4 logic**
   - Ensure all downstream passes handle new symbols correctly
   - No changes expected (uses same symbol categories)

5. **Performance validation**
   - Ensure no significant slowdown
   - Graph size should increase minimally (~3-8%)

### Phase 3: Testing
**File: `testConvertScipIndexToCsvForNeo4jCrossFileImport.sh`**

1. **Extend existing tests**
   - Add test cases for unexported outbound symbols
   - Verify edge recovery (recovered edges should be ~1,700+)
   - Verify cycle recovery (should approach 391 cycles)

2. **Adapt existing tests if needed**
   - Update assertions that assume current symbol count
   - Example: if test expects 1,312 symbols, update to expect ~1,600-2,100

3. **Add comparison test**
   - Verify complete mode produces more edges than current cross-file
   - Verify complete mode produces fewer edges than kind-level (or equal)

### Phase 4: Documentation
**Files to update:**

1. **`domains/scip-index-import/README.md`**
   - Explain complete mode: what's included, why, use cases
   - Add comparison table vs kind-level and current cross-file
   - Document when to use complete mode

2. **New: `domains/scip-index-import/verification/COMPLETE_MODE_ANALYSIS.md`**
   - Document the analysis that led to complete mode
   - Show edge/cycle recovery metrics
   - Link to CRITICAL_FINDINGS_SUMMARY
   - Include test results from verification runs

3. **Script header comments**
   - Update description in convertScipIndexToCsvForNeo4jCrossFileImport.sh
   - Update description in convertScipIndexToCsvForNeo4jAdminCrossFileImport.sh (admin variant)

### Phase 5: Verification (Temporary)
**Not committed, but proves correctness**

1. **Create: `domains/scip-index-import/verification/verifyCompleteMode.sh`**
   - Convert a test SCIP index with complete mode
   - Compare against kind-level import
   - Report: edge count, cycle count, symbol count
   - Verify edges are recovered, not lost

2. **Update: `domains/scip-index-import/verification/.gitignore`**
   - Temporarily add CSV outputs and temp files
   - Will be reverted before commit

3. **Expected Results**
   - Complete mode symbols: 1,600-2,100 (vs 1,312 current)
   - Complete mode edges: closer to kind-level (recovery of ~1,700)
   - Cycles detected: approach 391 (vs 11 current)

---

## Success Criteria

### Code Quality
- [ ] All shell scripts pass `shellcheck` (no errors, justified exceptions)
- [ ] All comments follow conventions (explain why, not what)
- [ ] No abbreviations in variable/function names
- [ ] Readable, performant code (performance is key per requirements)

### Testing
- [ ] All existing tests pass with new symbol counts
- [ ] New tests verify unexported outbound symbol inclusion
- [ ] Comparison test verifies edge recovery vs current mode

### Documentation
- [ ] Script header clearly describes complete mode
- [ ] README explains use cases and tradeoffs
- [ ] Analysis document available in verification folder

### Verification
- [ ] Test run shows edge recovery
- [ ] Test run shows cycle detection improvement
- [ ] Results documented in COMPLETE_MODE_ANALYSIS.md

---

## Implementation Order (Todos)

1. **analyze-complete-mode-implementation** - Understand exact jq logic needed
2. **implement-outbound-detection-function** - Add jq function for outbound calls
3. **update-pass1-symbol-filter** - Change inclusion logic
4. **verify-no-downstream-changes** - Check passes 2-4 don't need updates
5. **extend-test-cases** - Add new test assertions
6. **adapt-existing-assertions** - Update symbol/edge count expectations
7. **add-comparison-test** - Verify edge recovery
8. **update-script-header** - Documentation in comments
9. **update-domain-readme** - Comprehensive documentation
10. **create-verification-analysis** - COMPLETE_MODE_ANALYSIS.md
11. **run-verification-tests** - Prove correctness with real data
12. **final-validation** - All checks pass, ready for commit

---

## Key Decisions

| Decision | Rationale |
|----------|-----------|
| Keep same script | Simpler interface, less duplication, "complete" is the right default |
| Add to existing tests | Cohesive test suite, easier maintenance |
| Include outbound functions | Critical for cyclic dependency detection, essential for dependency analysis |
| No new env vars | Leverage existing SCIP_IMPORT_MODE logic, simpler configuration |
| Include analysis doc | Documents why this change was made, useful for future maintainers |

---

## Risks & Mitigation

| Risk | Mitigation |
|------|-----------|
| Performance regression | Monitor jq performance, compare before/after timings |
| Test suite complexity | Start with essential tests, add edge cases incrementally |
| Documentation outdated | Create analysis doc now, update during implementation |
| Graph size explosion | Cap at 10% increase, abort if exceeded (should be 3-8%) |

---

## Dependencies

- jq (already required)
- Bash (existing)
- No new external tools needed
- Verification depends on test SCIP index availability

---

## Files to Create/Modify

### Create
- [ ] `/Users/johnny/.copilot/session-state/.../plan.md` (this file)
- [ ] `domains/scip-index-import/verification/COMPLETE_MODE_ANALYSIS.md`
- [ ] `domains/scip-index-import/verification/verifyCompleteMode.sh` (temporary)
- [ ] Possibly: Updated `.gitignore` entries in verification/

### Modify
- [ ] `convertScipIndexToCsvForNeo4jCrossFileImport.sh` (core logic + header)
- [ ] `convertScipIndexToCsvForNeo4jAdminCrossFileImport.sh` (header + pass-through logic)
- [ ] `testConvertScipIndexToCsvForNeo4jCrossFileImport.sh` (tests)
- [ ] `domains/scip-index-import/README.md` (documentation)

---

## Next Steps

1. Review and approve this plan
2. Begin Phase 2: Core Implementation
3. Iterate with focused tests
4. Verify with real SCIP data
5. Create pull request with full documentation

---

## Implementation Summary

**Challenged the plan — key corrections:**

1. **Plan said Pass 2-4 need no changes** — Wrong. Both Pass 2 (node extraction) and Pass 4 (edge extraction) needed updates to use the new condition.

2. **Plan said "complete mode" / 3-8% more symbols** — The mode stays `cross-file`. Actual new symbol count on react-router: +258 symbols (+17%), not 3-8%.

3. **Plan said 1,722 missing edges to recover** — The 198 `__file__` missing edges are NOT actually missing. They exist in the cross-file import as finer-grained edges (to `Type#property.` instead of normalized `Type#`). Only 1,524 edges have genuinely missing source nodes, and those are addressed by the fix.

4. **Recovery rate: 393 / 1,524 source symbols recovered** — The remaining ~1,131 are cases where the cross-file reference appears on the same line as an adjacent variable declaration, so the line-window attribution assigns it to that variable, not the expected function. This is **consistent** with how Pass 4 generates edges — adding those symbols as nodes would produce orphaned nodes with no edges from them.

**What was implemented:**

| File | Change |
|------|--------|
| `convertScipIndexToCsvForNeo4jCrossFileImport.sh` | Updated description; added `symbol_makes_cross_file_call` field to Pass 1; updated Pass 2 node filter + `__file__` def count; updated Pass 4 `$cross_file_defs` filter |
| `testConvertScipIndexToCsvForNeo4jCrossFileImport.sh` | Added `create_outbound_caller_scip_json` fixture + Test group 7 (6 new assertions; all pass) |
| `README.md` | Updated cross-file mode description to describe inbound + outbound filtering |

**Tests: 65 passed, 0 failed** (59 existing + 6 new).