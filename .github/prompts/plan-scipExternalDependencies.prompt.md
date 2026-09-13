# Plan: SCIP External Dependencies Support

## Context

Extend `domains/external-dependencies` to support SCIP index-based nodes. SCIP has multi-language support; analysis must be language-agnostic. Group by `module` (external artifact name) only — no sub-artifact parsing.

## Decisions

- **Grouping unit**: `externalType.module` (the external artifact) — language-agnostic. No symbol string parsing.
- **Python script**: New `externalScipDependencyCharts.py` (not modifying existing)
- **Language breakdown**: All languages combined (SCIP types have `language` property but no separate sections)
- **Explore notebook**: One new `ExternalDependenciesScip.ipynb`
- **Out of scope**: Maven POM queries, package.json queries, ExternalAnnotation labeling, second-level package grouping
- **Prefer adding new files/parts over changing existing logic**

## SCIP Graph Model (for external dependency queries)

Internal types: `(i:SemanticCodeIndexInternalType)` — `file` is set (non-empty)  
External types: `(e:SemanticCodeIndexExternalType)` — `file = ''`  
Dependency edge: `(i)-[:DEPENDS_ON {referenceCount: N}]->(e)`  
Internal modules: `(m:SemanticCodeIndexModule)-[:CONTAINS]->(i)`  
Internal artifacts: `(a:SemanticCodeIndexArtifact {isExternal: false})-[:CONTAINS]->(m)`  
External artifacts: `(ea:SemanticCodeIndexArtifact {isExternal: true})`  

Key external type properties: `module` (artifact name), `version`, `packageManager`, `language`, `name`, `fqn`

## Phase 1: Cypher Queries (7 new files in `queries/`)

All files use `_for_Scip` suffix. All return columns described below.

### Q1: `External_artifact_usage_overall_for_Scip.cypher`
Group internal type → external type DEPENDS_ON edges by external `module`.  
Return: `externalArtifactName`, `numberOfInternalCallerModules`, `numberOfInternalCallerTypes`, `numberOfTypeCalls`, `totalReferenceCount`, `allInternalModules`, `allInternalTypes`, `tenExternalTypeNames[0..9]`  
ORDER BY numberOfInternalCallerModules DESC, externalArtifactName ASC

### Q2: `External_artifact_usage_spread_for_Scip.cypher`
For each external artifact: how many distinct internal artifacts use it.  
Return: `externalArtifactName`, `numberOfInternalArtifacts`, `sumNumberOfModules`, `sumNumberOfTypes`, `sumReferenceCount`  
ORDER BY numberOfInternalArtifacts DESC, sumNumberOfModules DESC

### Q3: `External_artifact_usage_per_internal_artifact_for_Scip.cypher`
Per internal artifact + external artifact: module and type counts. Used for stacked bar chart.  
Return: `internalArtifactName`, `externalArtifactName`, `numberOfModules`, `numberOfTypes`, `totalReferenceCount`  
ORDER BY internalArtifactName, numberOfModules DESC

### Q4: `External_artifact_usage_per_internal_artifact_sorted_top_for_Scip.cypher`
Internal artifacts ranked by external usage. Used for summary Markdown table.  
Return: `internalArtifactName`, `artifactModules`, `numberOfModulesUsingExternal`, `numberOfExternalArtifacts`, `modulesUsingExternalRate`  
ORDER BY modulesUsingExternalRate DESC, internalArtifactName ASC  
LIMIT 30

### Q5: `External_artifact_usage_per_internal_module_sorted_for_Scip.cypher`
Internal modules ranked by number of external artifacts used.  
Return: `internalModuleName`, `internalArtifactName`, `numberOfExternalArtifacts`, `numberOfExternalTypes`, `totalReferenceCount`  
ORDER BY numberOfExternalArtifacts DESC, internalModuleName ASC

### Q6: `External_artifact_usage_per_internal_module_aggregated_for_Scip.cypher`
Per internal artifact: aggregated stats on module external usage. Used for scatter chart.  
Return: `internalArtifactName`, `artifactModules`, `numberOfExternalArtifacts`, `maxNumberOfModulesPercentage`, `medNumberOfModulesPercentage`, `avgNumberOfModulesPercentage`, `stdNumberOfModulesPercentage`  
ORDER BY numberOfExternalArtifacts DESC

### Q7: `External_artifact_usage_per_type_for_Scip.cypher`
Per internal type: list external artifacts it depends on (detailed analysis).  
Return: `internalTypeFqn`, `internalModuleName`, `externalArtifactName`, `referenceCount`  
ORDER BY referenceCount DESC, internalTypeFqn ASC  
LIMIT 100

## Phase 2: Python Chart Script (new file)

**`domains/external-dependencies/externalScipDependencyCharts.py`**

- No `--language` argument (SCIP is inherently multi-language)
- Args: `--report_directory`, `--verbose` (queries_directory defaults to `./queries` relative to script)
- Chart name prefix: `Scip_`
- Reuse chart helper functions locally (not imported from existing script — separate file per instructions)
- Follow python conventions: `pathlib.Path`, type annotations, no abbreviations (`figure` not `fig`, `axis` not `ax`)

Charts generated (using same `save_pie_chart_pair`, `save_stacked_bar_chart`, `save_scatter_chart` implementations as in existing script):

| Chart file prefix | Source query | value_column | name_column |
|---|---|---|---|
| `Scip_Top_external_artifacts_by_types` | Q1 | `numberOfInternalCallerTypes` | `externalArtifactName` |
| `Scip_Top_external_artifacts_by_modules` | Q1 | `numberOfInternalCallerModules` | `externalArtifactName` |
| `Scip_Most_spread_artifacts_by_types` | Q2 | `sumNumberOfTypes` | `externalArtifactName` |
| `Scip_Most_spread_artifacts_by_modules` | Q2 | `sumNumberOfModules` | `externalArtifactName` |
| `Scip_External_artifact_usage_per_artifact_stacked` | Q3 | stacked bar by numberOfModules | per artifact column |
| `Scip_External_artifact_usage_max_internal_modules_percent` | Q6 | scatter: x=numberOfExternalArtifacts, y=maxNumberOfModulesPercentage, size=artifactModules, color=stdNumberOfModulesPercentage |

## Phase 3: Explore Notebook (new file)

**`domains/external-dependencies/explore/ExternalDependenciesScip.ipynb`**

- Front matter: language-agnostic, `code_graph_analysis_pipeline_data_validation: ValidateAlwaysFalse`
- Sections following structure of existing Java/TypeScript notebooks:
  1. Setup cell (imports, Neo4j connection, helper functions)
  2. SCIP External Artifact Usage Overall (Q1)
  3. SCIP External Artifact Usage Spread (Q2)
  4. SCIP External Artifact Usage per Internal Artifact (Q3)
  5. SCIP External Artifact Usage per Internal Module (Q5)

## Phase 4: Shell Script Extensions

### `externalDependenciesCsv.sh` — add SCIP section after existing TypeScript section

```bash
# -- SCIP External Artifact Reports ----------------------------------------
execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_artifact_usage_overall_for_Scip.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_artifact_usage_overall_for_Scip.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_artifact_usage_spread_for_Scip.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_artifact_usage_spread_for_Scip.csv"
# ... all 7 queries
```

### `externalDependenciesPython.sh` — add SCIP section after TypeScript section

```bash
# -- SCIP Charts -----------------------------------------------------------
time python "${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}/externalScipDependencyCharts.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}
```

No `--language` argument (SCIP charts are language-agnostic).

## Phase 5: Summary Extensions

### `summary/externalDependenciesSummary.sh` — add SCIP section

Add after TypeScript section:
- `execute_cypher` for Q1, Q2, Q4, Q5 with `--output-markdown-table`
- `include_svgs_matching` for all `Scip_*.svg` files → `ScipExternalDependencyCharts.md`

### `summary/report.template.md` — add section 5

```markdown
## 5. SCIP External Dependencies

### 5.1 Most Used External Artifacts

<!-- include:External_artifact_usage_overall_for_Scip.md|empty.md -->

### 5.2 Most Spread External Artifacts

<!-- include:External_artifact_usage_spread_for_Scip.md|empty.md -->

### 5.3 External Artifact Usage per Internal Artifact (Top)

<!-- include:External_artifact_usage_per_internal_artifact_sorted_top_for_Scip.md|empty.md -->

### 5.4 External Artifact Usage per Internal Module

<!-- include:External_artifact_usage_per_internal_module_sorted_for_Scip.md|empty.md -->

### 5.5 SCIP Charts

<!-- include:ScipExternalDependencyCharts.md|empty.md -->
```

Also update Glossary section with new SCIP terms.

## Phase 6: README Update

`domains/external-dependencies/README.md`:
- Add SCIP prerequisites section (SCIP indices must exist in graph)
- Add SCIP queries to Folder Structure list
- Add SCIP chart descriptions to SVG charts section
- Add SCIP section to Markdown summary description

## Phase 7: Testing

All tests are self-contained unit tests with no external dependencies (no Neo4j, no SCIP data required). This ensures tests can run in CI and the pipeline gracefully handles missing SCIP indices.

### A. Python Chart Script Unit Tests

**File**: `domains/external-dependencies/test_externalScipDependencyCharts.py`

Pytest-based unit tests for data transformation and chart generation logic. No Neo4j dependency.

**Test modules:**

1. **test_load_query_results()**
   - Mock CSV file loading
   - Verify DataFrame structure
   - Test empty CSV handling
   - Test missing columns error

2. **test_group_small_values_into_others()**
   - Test grouping by threshold percentage
   - Verify "others" group is created
   - Test 100% coverage edge case
   - Test single large entry (no others)

3. **test_derive_second_level_package_name()** (unused by SCIP, kept for reference)
   - Verify dot-splitting logic
   - Test edge cases (1 part, 2 parts, 3+ parts)

4. **test_filter_entries_below_percentage_threshold()**
   - Test filtering entries below percentage
   - Verify sum of filtered entries matches expected %
   - Test boundary conditions (exactly at threshold)

5. **test_select_top_artifacts_by_package_count()**
   - Test top 15 artifact selection
   - Verify DataFrame sorting
   - Test with fewer than 15 artifacts

6. **test_build_external_package_per_artifact_pivot()**
   - Test pivot table creation
   - Verify correct indexing (external package rows, artifact columns)
   - Test fill_value=0 behavior

7. **test_save_pie_chart()** (mock matplotlib)
   - Mock matplotlib and test SVG save
   - Verify file created with correct name
   - Test empty data handling (skip silently)

8. **test_save_stacked_bar_chart()** (mock matplotlib)
   - Mock stacked bar rendering
   - Verify correct transposition and stacking
   - Test legend placement

9. **test_save_scatter_chart()** (mock matplotlib)
   - Mock scatter plot rendering
   - Verify annotation points selected correctly
   - Test empty data handling

10. **test_connect_to_graph_database()** (mock neo4j)
    - Mock Neo4j driver
    - Test connection attempt
    - Test error handling on connection failure

11. **test_generate_scip_charts()** (integration)
    - Mock all external calls
    - Test query loading, data processing, chart generation flow
    - Verify all expected chart files would be created

**Run tests**: `pytest domains/external-dependencies/test_externalScipDependencyCharts.py -v`

**Coverage target**: 80%+ for all utility functions (grouping, filtering, formatting)

### B. Shell Script Static Analysis

### B. Test Files in Repository

Update `.gitignore` to exclude test artifacts:
- `domains/external-dependencies/.pytest_cache/`
- `domains/external-dependencies/__pycache__/`
- `domains/external-dependencies/*.svg` (generated by tests)

### C. Graceful Handling of Missing SCIP Data

The shell scripts must handle missing SCIP data gracefully. Only add code and complexity if really necessary. Empty queries resulting in empty reports are not an issue since they will be cleaned up automatically.

**In `externalDependenciesCsv.sh`:**
- Only if necessary
- Wrap SCIP section in conditional check for SCIP types in database
- If no SCIP types detected, skip SCIP queries silently
- Log message: "No SCIP data found; skipping SCIP external dependency queries"
- No error exit code

**In `externalDependenciesPython.sh`:**
- Only if necessary
- Check if any SCIP CSV files were generated
- If none found, skip Python chart generation
- Log message: "No SCIP CSV data found; skipping SCIP chart generation"
- No error exit code

**In `summary/externalDependenciesSummary.sh`:**
- Only if necessary
- Check if SCIP markdown files exist before including them
- If none found, skip section 5 from report template
- No error on missing SCIP data

This allows jQAssistant analysis (Java/TypeScript without SCIP) to proceed normally without errors.

## Files Summary

### New files (10)
- `domains/external-dependencies/queries/External_artifact_usage_overall_for_Scip.cypher`
- `domains/external-dependencies/queries/External_artifact_usage_spread_for_Scip.cypher`
- `domains/external-dependencies/queries/External_artifact_usage_per_internal_artifact_for_Scip.cypher`
- `domains/external-dependencies/queries/External_artifact_usage_per_internal_artifact_sorted_top_for_Scip.cypher`
- `domains/external-dependencies/queries/External_artifact_usage_per_internal_module_sorted_for_Scip.cypher`
- `domains/external-dependencies/queries/External_artifact_usage_per_internal_module_aggregated_for_Scip.cypher`
- `domains/external-dependencies/queries/External_artifact_usage_per_type_for_Scip.cypher`
- `domains/external-dependencies/externalScipDependencyCharts.py`
- `domains/external-dependencies/explore/ExternalDependenciesScip.ipynb`
- `domains/external-dependencies/test_externalScipDependencyCharts.py` *(Phase 7.A)*

### Modified files (5) — additions + graceful degradation
- `domains/external-dependencies/externalDependenciesCsv.sh` — add SCIP section with missing data check
- `domains/external-dependencies/externalDependenciesPython.sh` — add SCIP section with missing CSV check
- `domains/external-dependencies/summary/externalDependenciesSummary.sh` — add SCIP section with file existence check
- `domains/external-dependencies/summary/report.template.md` — add section 5
- `domains/external-dependencies/README.md` — add SCIP docs

## Verification

### Static Analysis & Linting (no external dependencies)

1. `shellcheck domains/external-dependencies/externalDependenciesCsv.sh`
2. `shellcheck domains/external-dependencies/externalDependenciesPython.sh`
3. Pylance on `externalScipDependencyCharts.py` (strict mode)
4. `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json domains/external-dependencies/README.md`

### Unit Tests (no external dependencies)

5. `pytest domains/external-dependencies/test_externalScipDependencyCharts.py -v --cov=domains/external-dependencies/externalScipDependencyCharts.py --cov-fail-under=80`

### Integration Tests (optional, requires Neo4j + SCIP data)

**Only run if SCIP data is available. These tests verify end-to-end functionality:**

6. `analyze.sh --domain external-dependencies --report Csv --keep-running` (verify SCIP CSV files generated)
7. `analyze.sh --domain external-dependencies --report Python --keep-running` (verify SCIP chart SVGs generated)
8. `analyze.sh --domain external-dependencies --report Markdown --keep-running` (verify section 5 in report)

**When SCIP data is not available:**
- Tests 1-5 will pass (static analysis and unit tests)
- Tests 6-8 will gracefully skip SCIP sections (no errors)
- jQAssistant analysis (Java/TypeScript) will complete successfully
