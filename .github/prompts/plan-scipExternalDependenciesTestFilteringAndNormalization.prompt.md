# Plan: SCIP External Dependencies — Test Filtering + Artifact Normalization

## TL;DR

Two independent changes to the external-dependencies domain for SCIP reports:

1. **"Excluding tests" variants**: Add `_excluding_tests` Cypher+CSV+chart+Markdown variants of `overall` and `spread` SCIP queries. Filter using `WHERE coalesce(m.isTest, false) = false` on `SemanticCodeIndexModule` nodes. Both old and new reports run.

2. **Normalized artifact names (Option C)**: Add `_normalized` variants of `overall` and `spread` queries that group by `replace(e.packageId, '/', '.')` instead of `e.module`. No enrichment step needed — `packageId` is already stored on every `SemanticCodeIndexExternalType` node. Optionally set `groupId = replace(fileName, '/', '.')` on `SemanticCodeIndexArtifact` nodes for artifact-level queries.

**Decisions:**
- Only `overall` and `spread` queries get variants (most impacted; both appear in Markdown summary)
- No combined `_normalized_excluding_tests` variant (out of scope; can be added later)
- No enrichment step needed for Phase 2 — `e.packageId` is already on every `SemanticCodeIndexExternalType` node, set during import
- `SemanticCodeIndexArtifact.fileName` already holds `packageId` (misleadingly named but data is there)
- Normalization strategy: `replace(e.packageId, '/', '.')` — language-agnostic, no hardcoding, derived from SCIP data
- **Honest limitation**: scip-java truncates Maven groupIds (e.g., `io.projectreactor:reactor-core` → `reactor/core`, not `io/projectreactor`), so `org.apache` still groups all Apache types together — same coarseness, just better named than `apache` alone

---

## Phase 1: Excluding-Tests Variants

### Step 1. New Cypher files (×2)
`domains/external-dependencies/queries/External_artifact_usage_overall_excluding_tests_for_Scip.cypher`
- Copy of `External_artifact_usage_overall_for_Scip.cypher`
- Add `WHERE coalesce(m.isTest, false) = false` after the MATCH clause

`domains/external-dependencies/queries/External_artifact_usage_spread_excluding_tests_for_Scip.cypher`
- Copy of `External_artifact_usage_spread_for_Scip.cypher`
- Add `WHERE coalesce(m.isTest, false) = false` after the MATCH clause

### Step 2. `externalDependenciesCsv.sh`
Add 2 new `execute_cypher` calls in the SCIP section (after the existing spread call):
```
execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_artifact_usage_overall_excluding_tests_for_Scip.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_artifact_usage_overall_excluding_tests_for_Scip.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_artifact_usage_spread_excluding_tests_for_Scip.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_artifact_usage_spread_excluding_tests_for_Scip.csv"
```

### Step 3. `externalScipDependencyCharts.py`
Add chart generation for both new queries (pie chart pairs, same pattern as existing `overall` and `spread` charts). New SVG names: `Scip_Top_external_artifacts_excl_tests_by_types_above_threshold.svg` etc.

### Step 4. `externalDependenciesSummary.sh`
- Add 2 new `execute_cypher ... --output-markdown-table` calls → `_excluding_tests.md` includes
- Add new SVG include globs for the new chart names

### Step 5. `report.template.md`
Add new subsections in Section 5 (SCIP) for the excluding-tests views (5.1.1 and 5.2.1 or as 5.6/5.7):
```
<!-- include:External_artifact_usage_overall_excluding_tests_for_Scip.md|empty.md -->
<!-- include:External_artifact_usage_spread_excluding_tests_for_Scip.md|empty.md -->
```

---

## Phase 2: Normalized Artifact Name Variants

### Background: what's already in the data

Every `SemanticCodeIndexExternalType` node already has `e.packageId` set during import — it's the slash-separated groupId path from the SCIP symbol (e.g., `reactor/core`, `org/slf4j`, `com/fasterxml`). The `module` field is derived from it by stripping the first path segment.

`SemanticCodeIndexArtifact` already stores `packageId` too — under the misleadingly named property `a.fileName` (`a.name = module`, `a.fileName = packageId`).

So `replace(e.packageId, '/', '.')` gives unambiguous names — no enrichment needed:

| module (current) | packageId → dot form (proposed) | Comment |
|---|---|---|
| `core` | `reactor.core` | no longer ambiguous |
| `test` | `reactor.test` | no longer ambiguous |
| `util` | `reactor.util` | no longer ambiguous |
| `fasterxml` | `com.fasterxml` | Jackson 2.x (com.fasterxml.jackson.*) |
| `jackson` | `tools.jackson` | Jackson 3.x (tools.jackson.*) — separate, correct |
| `persistence` | `jakarta.persistence` | no longer ambiguous |
| `validation` | `jakarta.validation` | no longer ambiguous |
| `springframework` | `org.springframework` | clearer |
| `jdk` | `jdk` | no slash, unchanged |

**Honest limitation**: scip-java doesn't emit the full Maven groupId. It uses a truncated form (e.g., `io.projectreactor:reactor-core` → `reactor/core`, not `io/projectreactor`). So `org.apache` still groups all Apache types together — same inherent coarseness, just better named than `apache` alone.

### Step 6. ~~New enrichment Cypher file~~ — not needed
No `Set_normalized_module_for_Scip_external_types.cypher` required. `e.packageId` is already there.

Optional (for artifact-level queries): small enrichment query on artifact nodes:
`Set_group_id_for_Scip_artifacts.cypher` — idempotent `SET a.groupId = replace(a.fileName, '/', '.')` on `SemanticCodeIndexArtifact` nodes. Lets artifact-level queries use `a.groupId` cleanly instead of inline `replace(a.fileName, '/', '.')`.

### Step 7. New normalized query files (×2)
`External_artifact_usage_overall_normalized_for_Scip.cypher`
- Copy of `overall` with `e.module` replaced by `replace(e.packageId, '/', '.')` as `externalArtifactName`

`External_artifact_usage_spread_normalized_for_Scip.cypher`
- Copy of `spread` with `e.module` replaced by `replace(e.packageId, '/', '.')` as `externalArtifactName`

### Step 8. `externalDependenciesCsv.sh`
- Add 2 new CSV exports for `_normalized` queries (no enrichment call needed)

### Step 9. `externalScipDependencyCharts.py`
Add chart generation for both normalized queries (pie chart pairs).

### Step 10. `externalDependenciesSummary.sh` + `report.template.md`
Add Markdown include sections and template directives for normalized views.

---

## Relevant Files

| File | Change |
|------|--------|
| `domains/external-dependencies/queries/` | 4 new `.cypher` files (no enrichment file for types; optional 1 for artifacts) |
| `domains/external-dependencies/externalDependenciesCsv.sh` | +4 new CSV exports (no enrichment call needed) |
| `domains/external-dependencies/externalScipDependencyCharts.py` | +4 new chart generation calls |
| `domains/external-dependencies/summary/externalDependenciesSummary.sh` | +4 Markdown table sections + SVG globs |
| `domains/external-dependencies/summary/report.template.md` | +4 `include` directives in SCIP section |

---

## Verification

1. Run `analyze.sh --domain external-dependencies --report Csv --keep-running`
   - Check `reports/external-dependencies/External_artifact_usage_overall_excluding_tests_for_Scip.csv` exists
   - Check junit/mockito/assertj absent from `_excluding_tests` CSV
   - Check `External_artifact_usage_overall_normalized_for_Scip.csv` shows `reactor.core` (not ambiguous `core`) and `com.fasterxml` / `tools.jackson` (separate — correct, different Jackson versions)

2. Run `analyze.sh --domain external-dependencies --report Python --keep-running`
   - Check new `Scip_*excl_tests*` SVGs appear in reports

3. Run `analyze.sh --domain external-dependencies --report Markdown --keep-running`
   - Check `external_dependencies_report.md` includes the new sections

4. Verify report still gracefully handles absence of SCIP data (empty files cleaned up)

5. `shellcheck` on modified `.sh` files

---

## Scope Boundaries

- **In**: `overall` + `spread` for both changes
- **Out**: `per_internal_module_sorted`, `per_internal_artifact_sorted_top`, combined `_normalized_excluding_tests` variant — can be added later
- **Out**: Changes to `scip-index-import` — no enrichment needed for Phase 2 type-level queries; optional artifact-level enrichment stays in external-dependencies domain
- **Out**: Full Maven groupId precision — scip-java truncates groupIds; pipeline cannot fix what the SCIP tool doesn't emit
