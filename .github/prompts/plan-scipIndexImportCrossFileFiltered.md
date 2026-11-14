# Plan: SCIP Cross-File Filtering Import

**TL;DR**: New extraction script `convertScipIndexToCsvForNeo4jCrossFileImport.sh` replaces kind-level filtering with occurrence-based cross-file filtering. All cross-file internal symbols import as `:SemanticCodeIndexInternalSymbol`; all external symbols as `:SemanticCodeIndexExternalSymbol`. Kind-specific labels added in enrichment. Admin format via thin awk wrapper. Controlled by `SCIP_IMPORT_MODE=kind-level` (default) or `cross-file`. Lives in existing `domains/scip-index-import/`.

---

## Decisions Locked

- **Script location**: `domains/scip-index-import/` — no new domain directory
- **Feature flag**: `SCIP_IMPORT_MODE=kind-level` (default, existing behavior) | `cross-file` (new)
- **Internal nodes**: `SemanticCodeIndexInternalSymbol` for all cross-file internal symbols at import time (same label as the existing union label — now primary instead of enrichment-added)
- **External nodes**: `SemanticCodeIndexExternalSymbol` as the primary label at import; `SemanticCodeIndexExternalType` + kind-specific external labels added in enrichment
- **Kind-specific labels**: Added in separate enrichment Cypher queries per kind — no APOC
- **Admin format**: Thin wrapper `convertScipIndexToCsvForNeo4jAdminCrossFileImport.sh` transforms headers and adds `:LABEL` column via awk — no logic duplication
- **Unified CSVs**: New scripts produce `scip_symbol_nodes.csv`, `scip_symbol_edges.csv`, `scip_external_symbol_nodes.csv`, `scip_projects.csv` — no kind-split files
- **Existing scripts untouched**: Kind-level scripts remain unchanged; `SCIP_IMPORT_MODE=kind-level` runs them exactly as before
- **Breaking change scope**: `SemanticCodeIndexExternalType` no longer applied at import in cross-file mode — added in enrichment. Document under MIGRATION.md v6.

---

## Challenges to Reference Documents

The reference docs (`ARCHITECTURAL_DECISIONS.md`, `IMPLEMENTATION_PLAN_PHASE3.md` in `temp/`) were written without code access. Several premises are wrong:

1. **"Variables/fields must be added to kind-level scripts first (Phase 1 & 2)"** — Already done. `convertScipIndexToCsvForNeo4jImport.sh` already extracts variables (kind 8) and fields (kind 61/79). The gap is the admin import script missing these, but that is a separate pre-existing issue, not a prerequisite.

2. **"Build in a separate `domains/scip-index-import-next/` directory"** — Rejected. Code duplication, maintenance burden. New scripts inside the existing domain with a feature flag achieve the same isolation without forking the domain.

3. **"Use APOC for dynamic label assignment in Cypher"** — Rejected. APOC is optional and introduces a hard dependency. Use separate enrichment queries per kind.

4. **"Coverage drops to 45-50% without variables/fields"** — Specific to React Router TypeScript. Java projects have different characteristics (class-bound code is effectively always cross-file). Do not treat these numbers as universal.

5. **"Use SCIP_IMPORT_MODE=current|next"** — Rejected by user. Use `kind-level` and `cross-file`.

6. **"Generate backwards-compatible legacy CSVs from the new script"** — Unnecessary complexity. Old script stays unchanged. Feature flag controls which runs. No need for dual output from the new script.

---

## Why Cross-File Is Better Than Kind-Level

| Concern | Kind-level filtering | Cross-file filtering |
|---------|---------------------|---------------------|
| Filter logic | Hardcoded kind numbers | Occurrence-based |
| Local symbols | Included for kinds 17/21 (noise) | Excluded (not cross-file) |
| New SCIP kinds | Require manual code change | Automatically included |
| Language-specific | Different rules per language | Uniform algorithm |
| Precision | ~18% of symbols, 70-80% dependency coverage | Only symbols that cross file boundaries |

---

## New Files

```
domains/scip-index-import/
├─ convertScipIndexToCsvForNeo4jCrossFileImport.sh      # New extraction script
├─ convertScipIndexToCsvForNeo4jAdminCrossFileImport.sh # Admin format wrapper (awk)
├─ testConvertScipIndexToCsvForNeo4jCrossFileImport.sh  # Unit tests
└─ queries/
   ├─ import/
   │  ├─ Create_SCIP_Cross_File_Internal_Symbol_Constraint.cypher
   │  ├─ Create_SCIP_Cross_File_External_Symbol_Constraint.cypher
   │  ├─ Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher
   │  ├─ Import_SCIP_Cross_File_External_Symbol_Nodes.cypher
   │  └─ Import_SCIP_Cross_File_Symbol_Edges.cypher
   └─ enrichment/
      ├─ Add_SCIP_Cross_File_Function_Label.cypher
      ├─ Add_SCIP_Cross_File_Internal_Type_Label.cypher
      ├─ Add_SCIP_Cross_File_Variable_Label.cypher
      ├─ Add_SCIP_Cross_File_Field_Label.cypher
      └─ Add_SCIP_Cross_File_External_Type_Label.cypher
```

## Modified Files

- `domains/scip-index-import/importScipIndexData.sh` — branch on `SCIP_IMPORT_MODE`
- `domains/scip-index-import/importScipIndexDataWithAdminImport.sh` — branch on `SCIP_IMPORT_MODE`
- `MIGRATION.md` — v6 section: `SemanticCodeIndexExternalType` now added in enrichment in cross-file mode
- `domains/scip-index-import/README.md` — new entry points
- `SCIP.md` — cross-file mode explanation

---

## Cross-File Algorithm

### Pass 1 — Symbol information index (extended from existing)

Add `symbol_to_reference_files` to the existing index object: a map from each non-local symbol to the unique set of files that contain a reference occurrence (`symbol_roles % 2 == 0`) for that symbol.

```jq
symbol_to_reference_files: (
    [.documents[] |
     .relative_path as $file |
     .occurrences[] |
     select((.symbol_roles // 0) % 2 == 0) |
     select(.symbol | startswith("local ") | not) |
     select((.symbol | split(" ") | length) >= 5) |
     {key: .symbol, value: $file}
    ] |
    group_by(.key) |
    map({key: .[0].key, value: ([.[].value] | unique)}) |
    from_entries
)
```

### Pass 2 — Internal cross-file symbol nodes

A symbol is an internal cross-file symbol if:
- It has a definition occurrence in this document (`symbol_to_file[$symbol] == $file`) AND is referenced from at least one file different from `$file`, OR
- It appears only in the `symbols` section (no definition occurrence in `symbol_to_file` — indicates a cross-module type declared in another module's index).

The `__file__` fallback node is retained unchanged for documents with no cross-file symbols but with internal references.

Pre-computed in jq (not deferred to Cypher enrichment):
- `language` — via `scheme_to_language` (already in admin script, now also in cross-file script)
- `is_test` — via `is_test` path heuristic (same as admin script)
- `kind` — raw SCIP kind integer
- `symbol_type` — human-readable: Function, Method, Class, Interface, AbstractClass, Record, Enum, Struct, Variable, Field, TypeAlias, Package, File, Unknown

### Pass 3 — External symbol nodes

External symbols are non-local symbols whose `package_id` is not in `internal_package_ids`, referenced from any document in the index. Same logic as existing external type extraction, but not restricted to kind 21.

### Pass 4 — Symbol edges

For each document, attribute reference occurrences to their containing cross-file symbol using the same scope/line-window logic as the existing kind-level scripts. Edge types carry over as-is (`calls_function`, `uses_type`, `initializes_with_function`, `uses_field`, etc.) plus a catch-all `references` for unclassifiable references.

Edges between two symbols in the same file (same `symbol_to_file` entry) are suppressed unless one of them is cross-file — consistent with existing behavior.

### Edge cases

- **Symbols with no occurrences anywhere** (symbols-section-only entries in multi-module projects): classified as internal cross-file symbols using the same `directory_to_package_tokens` fallback as the existing scripts.
- **Local symbols** (`startswith("local ")`): always excluded.
- **Short symbols** (fewer than 5 space-separated tokens): always excluded (same guard as existing scripts).
- **Self-edges**: suppressed (same as existing scripts).

---

## CSV Formats

### `scip_symbol_nodes.csv` (internal cross-file symbols)

```
symbol,display_name,scheme,language,kind,symbol_type,file,package_id,package_manager,version,module,is_abstract,is_test,project_root,descriptor
```

Same column names as `scip_type_nodes.csv` / `scip_function_nodes.csv` where overlapping; adds `language`, `kind`, `symbol_type` pre-computed in jq.

### `scip_external_symbol_nodes.csv` (external symbols)

```
symbol,display_name,scheme,language,kind,symbol_type,package_id,package_manager,version,descriptor
```

### `scip_symbol_edges.csv` (all symbol dependency edges)

```
from,to,edge_type,reference_count
```

Same column names as existing edge CSVs.

### `scip_projects.csv` — format unchanged, same as existing.

---

## Admin Format Wrapper

`convertScipIndexToCsvForNeo4jAdminCrossFileImport.sh`:

1. Calls `convertScipIndexToCsvForNeo4jCrossFileImport.sh` to produce canonical CSVs.
2. Transforms column headers using awk:
   - Node: `symbol` → `symbol:ID(ScipNode)`, `is_abstract` → `is_abstract:boolean`, `is_test` → `is_test:boolean`; appends `:LABEL` column computed from `symbol_type` value.
   - Edge: `from` → `:START_ID(ScipNode)`, `to` → `:END_ID(ScipNode)`, `edge_type` → `:TYPE`, `reference_count` → `reference_count:int`.
3. Writes admin CSVs: `scip_symbol_nodes_admin.csv`, `scip_symbol_edges_admin.csv`, `scip_external_symbol_nodes_admin.csv`.

The `:LABEL` mapping (awk `switch` or `if` on `symbol_type` column value):

| `symbol_type` | `:LABEL` value |
|---|---|
| Function / Method | `SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexFunction` |
| Class / Interface / AbstractClass / Record / Struct / Enum | `SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexInternalType` |
| TypeAlias | `SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexTypeAlias` |
| Variable | `SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexVariable` |
| Field | `SCIP;SemanticCodeIndexInternalSymbol;SemanticCodeIndexField` |
| File / Unknown / (anything else) | `SCIP;SemanticCodeIndexInternalSymbol` |

External node `:LABEL` follows the same pattern under `SemanticCodeIndexExternalSymbol`.

---

## Cypher Import Queries (cross-file mode)

### `Create_SCIP_Cross_File_Internal_Symbol_Constraint.cypher`

Unique constraint on `SemanticCodeIndexInternalSymbol(symbol)` — equivalent to existing `Create_SCIP_Internal_Type_Constraint.cypher` but on the new label.

### `Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher`

```cypher
// Import all cross-file internal symbols from scip_symbol_nodes.csv.
// Sets :SCIP:SemanticCodeIndexInternalSymbol label on all rows.
// Requires Create_SCIP_Cross_File_Internal_Symbol_Constraint.cypher.

LOAD CSV WITH HEADERS FROM 'file:///scip_symbol_nodes.csv' AS row
WITH row WHERE row.file <> ''
MERGE (n:SCIP:SemanticCodeIndexInternalSymbol {symbol: row.symbol})
SET n.fqn = row.symbol,
    n.display_name = row.display_name,
    n.name = row.display_name,
    n.language = row.language,
    n.scheme = row.scheme,
    n.kind = toInteger(row.kind),
    n.symbolType = row.symbol_type,
    n.typeName = row.symbol_type,
    n.file = row.file,
    n.packageId = row.package_id,
    n.packageManager = row.package_manager,
    n.version = row.version,
    n.module = row.module,
    n.isAbstract = (row.is_abstract = 'true'),
    n.isTest = (row.is_test = 'true'),
    n.projectRoot = row.project_root,
    n.descriptor = row.descriptor
```

### `Import_SCIP_Cross_File_External_Symbol_Nodes.cypher`

Same pattern, `MERGE (n:SCIP:SemanticCodeIndexExternalSymbol {symbol: row.symbol})`. Sets same properties; `file` is empty for external symbols.

### `Import_SCIP_Cross_File_Symbol_Edges.cypher`

```cypher
// Import all cross-file symbol dependency edges from scip_symbol_edges.csv.
// Requires Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher,
//          Import_SCIP_Cross_File_External_Symbol_Nodes.cypher.

LOAD CSV WITH HEADERS FROM 'file:///scip_symbol_edges.csv' AS row
WITH row WHERE row.from <> '' AND row.to <> ''
MATCH (source:SCIP {symbol: row.from})
MATCH (target:SCIP {symbol: row.to})
MERGE (source)-[r:DEPENDS_ON]->(target)
SET r.referenceCount = toInteger(row.reference_count),
    r.edgeType = row.edge_type
```

### Kind-label enrichment queries

One query per kind label — no APOC, no dynamic dispatch. Example for functions:

```cypher
// Add SemanticCodeIndexFunction label to cross-file symbols of function kinds.
// Requires Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher.

MATCH (n:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType IN ['Function', 'Method']
  AND NOT n:SemanticCodeIndexFunction
SET n:SemanticCodeIndexFunction
```

Similar queries for `SemanticCodeIndexInternalType` (Class/Interface/AbstractClass/Record/Struct/Enum), `SemanticCodeIndexVariable`, `SemanticCodeIndexField`, `SemanticCodeIndexTypeAlias`.

For external type label:

```cypher
// Add SemanticCodeIndexExternalType label to external symbols of type kinds.
// Requires Import_SCIP_Cross_File_External_Symbol_Nodes.cypher.

MATCH (n:SemanticCodeIndexExternalSymbol)
WHERE n.symbolType IN ['Class', 'Interface', 'AbstractClass', 'Record', 'Struct', 'Enum', 'TypeAlias', 'Unknown']
  AND NOT n:SemanticCodeIndexExternalType
SET n:SemanticCodeIndexExternalType
```

---

## Integration: `importScipIndexData.sh` Changes

Add `SCIP_IMPORT_MODE="${SCIP_IMPORT_MODE:-kind-level}"` near the top (after existing env vars).

Replace the single conversion call and kind-level constraint + import queries with a branch:

```bash
if [ "${SCIP_IMPORT_MODE}" = "cross-file" ]; then
    echo "importScipIndexData: ... Converting SCIP index files to CSV (cross-file mode)..."
    ( INDICES_DIRECTORY="${INDICES_DIRECTORY}" IMPORT_DIRECTORY="${IMPORT_DIRECTORY}" \
      bash "${SCIP_INDEX_IMPORT_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jCrossFileImport.sh" )
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Cross_File_Internal_Symbol_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Cross_File_External_Symbol_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Project_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Project_Nodes.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Cross_File_External_Symbol_Nodes.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Cross_File_Symbol_Edges.cypher"
    # Kind-specific labels must be added before shadow-type handling
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Function_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Internal_Type_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Variable_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Field_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_External_Type_Label.cypher"
else
    # ... existing kind-level import block (unchanged) ...
fi
```

The shadow-type redirect/delete queries and all subsequent enrichment (`Set_Incoming/Outgoing_...`, `Set_SCIP_Symbol_Project_Name`, etc.) run after the branch and are shared by both modes. This works because both modes produce `SemanticCodeIndexInternalSymbol`, `SemanticCodeIndexExternalType` (added in enrichment for cross-file mode), and `SemanticCodeIndexModule` / `SemanticCodeIndexArtifact` (created from these labels).

**Admin path (`SCIP_ADMIN_IMPORT_DONE=true`)**: The constraint-only fast path also needs a branch to create the cross-file constraints instead of kind-level ones when `SCIP_IMPORT_MODE=cross-file`. Followed by the same kind-label enrichment queries.

## Integration: `importScipIndexDataWithAdminImport.sh` Changes

Branch on `SCIP_IMPORT_MODE` to call the admin wrapper:

```bash
if [ "${SCIP_IMPORT_MODE:-kind-level}" = "cross-file" ]; then
    bash "${SCIP_ADMIN_IMPORT_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jAdminCrossFileImport.sh"
else
    bash "${SCIP_ADMIN_IMPORT_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jAdminImport.sh"
fi
```

The neo4j-admin import command and all guard logic stay unchanged — only the CSV filenames differ.

---

## Schema Compatibility

Queries using `:SemanticCodeIndexInternalSymbol` work in both modes (kind-level adds the label in enrichment; cross-file adds it at import).

Queries using `:SemanticCodeIndexExternalType` work in both modes when run after the full enrichment pipeline (enrichment adds the label in cross-file mode).

Queries using `:SemanticCodeIndexInternalType` or `:SemanticCodeIndexFunction` etc. work in both modes after enrichment.

The only behavioral difference: cross-file mode produces more `SemanticCodeIndexInternalSymbol` nodes (fields, variables, cross-file methods that were missing from kind-level) and more edges. No node or edge is removed.

---

## Testing Strategy

### New test script: `testConvertScipIndexToCsvForNeo4jCrossFileImport.sh`

Follow `testConvertScipIndexToCsvForNeo4jAdminImport.sh` structure (assertion helpers, `PASS_COUNT`/`FAIL_COUNT`).

Test groups:

1. **Prerequisites**: jq missing → exit 1; no INDICES_DIRECTORY → exit 1; no `.scip.json` files → exit 1; non-`.scip.json` file present → exit 1.

2. **Column presence** (using real test data):
   - `scip_symbol_nodes.csv` has all expected headers including `language`, `kind`, `symbol_type`
   - `scip_symbol_edges.csv` has `from`, `to`, `edge_type`, `reference_count`
   - `scip_external_symbol_nodes.csv` has expected headers
   - `scip_projects.csv` exists

3. **Cross-file filtering correctness**:
   - Local symbols (`startswith("local ")`) are absent from all CSVs
   - A known local function (defined and called only within one file) is absent from `scip_symbol_nodes.csv`
   - A known cross-file function (called from another file) is present in `scip_symbol_nodes.csv`

4. **Symbol type correctness**:
   - A known type (kind 7/21) has `symbol_type` in `['Class','Interface','AbstractClass',...]`
   - A known function (kind 17) has `symbol_type = Function`

5. **Multi-file merge** (two input files):
   - Duplicate internal symbols are deduplicated
   - Duplicate edges have their `reference_count` summed

6. **Admin wrapper output**:
   - `scip_symbol_nodes_admin.csv` first column header = `symbol:ID(ScipNode)`
   - `is_abstract:boolean` and `is_test:boolean` present
   - `:LABEL` column present with `;`-separated values
   - `scip_symbol_edges_admin.csv` has `:START_ID(ScipNode)`, `:END_ID(ScipNode)`, `:TYPE`

Test data: synthetic minimal SCIP JSON (same inline-heredoc style as existing tests) covering both a TypeScript-like and Java-like symbol structure. Integration-level assertions use `temp/react-router-scip-latest/` and `temp/AxonFramework-5.1.1-multi-scip/` data for non-empty output checks.

---

## Documentation Updates

### `ENVIRONMENT_VARIABLES.md`

Add entry:
```
SCIP_IMPORT_MODE=kind-level
```
Description: Controls SCIP index extraction strategy. `kind-level` (default) filters by SCIP symbol kind numbers. `cross-file` filters by occurrence-based cross-file reference detection, capturing all symbol kinds that cross file boundaries.

### `SCIP.md`

Add a section explaining the two import modes, when to use `cross-file`, and what the coverage difference means.

### `domains/scip-index-import/README.md`

Add rows for the new scripts to the Entry Points table.

### `MIGRATION.md` — v6 addition

Add a new subsection under the existing v6 section:

**What changed**: In `cross-file` mode (`SCIP_IMPORT_MODE=cross-file`), external nodes are imported with label `SemanticCodeIndexExternalSymbol` instead of `SemanticCodeIndexExternalType`. The `SemanticCodeIndexExternalType` label is added during enrichment for external symbols of type kinds.

**Migration steps**:
1. If `SCIP_IMPORT_MODE` is not set or is `kind-level`, no action required.
2. If using `SCIP_IMPORT_MODE=cross-file`, custom queries that filter by `:SemanticCodeIndexExternalType` continue to work if they run after the full enrichment pipeline.
3. If running custom queries directly after import (before enrichment), replace `:SemanticCodeIndexExternalType` with `:SemanticCodeIndexExternalSymbol`.

---

## Verification Steps

```shell
# Shell script linting
shellcheck domains/scip-index-import/convertScipIndexToCsvForNeo4jCrossFileImport.sh
shellcheck domains/scip-index-import/convertScipIndexToCsvForNeo4jAdminCrossFileImport.sh
shellcheck domains/scip-index-import/testConvertScipIndexToCsvForNeo4jCrossFileImport.sh

# Unit tests
bash domains/scip-index-import/testConvertScipIndexToCsvForNeo4jCrossFileImport.sh

# Full pipeline smoke test with TypeScript data
# (From temp/react-router-scip-latest/ analysis workspace)
SCIP_IMPORT_MODE=cross-file analyze.sh --report Csv --keep-running --explore

# Full pipeline smoke test with Java data
# (From temp/AxonFramework-5.1.1-multi-scip/ analysis workspace)
SCIP_IMPORT_MODE=cross-file analyze.sh --report Csv --keep-running --explore

# Verify default kind-level mode is unaffected
analyze.sh --report Csv --keep-running --explore
```

Compare node counts between modes:

```cypher
MATCH (n:SemanticCodeIndexInternalSymbol) RETURN labels(n) AS labels, count(n) AS count ORDER BY count DESC
```

Expected: cross-file mode shows more nodes (fields, variables, cross-file-only methods) but not dramatically more (private/local symbols are excluded).

---

## Implementation Summary

Implemented `SCIP_IMPORT_MODE=cross-file` as described in the plan. No breaking changes to existing behavior.

### New files

**Extraction script** - `convertScipIndexToCsvForNeo4jCrossFileImport.sh`: occurrence-based cross-file filtering. Builds `symbol_has_cross_file_reference` boolean map in Pass 1 (two-step jq binding within one call), then extracts all symbols that cross file boundaries across all SCIP kinds. Produces `scip_symbol_nodes.csv`, `scip_external_symbol_nodes.csv`, `scip_symbol_edges.csv`, `scip_projects.csv`.

**Admin wrapper** - `convertScipIndexToCsvForNeo4jAdminCrossFileImport.sh`: calls the extraction script, then transforms CSVs to admin format via awk. Also produces `scip_projects_admin.csv` and `scip_symbol_project_links_admin.csv` (for `BELONGS_TO` relationships).

**Tests** - `testConvertScipIndexToCsvForNeo4jCrossFileImport.sh`: 59 tests covering prerequisites, columns, cross-file filtering, symbol type correctness, multi-file merge, and admin wrapper output.

**10 Cypher queries**: 2 constraints, 3 import queries, 5 kind-label enrichment queries in `queries/import/` and `queries/enrichment/`.

### Modified files

- `importScipIndexData.sh`: branches on `SCIP_IMPORT_MODE`. Kind-label enrichment runs at the end of the cross-file branch so shadow-type queries find `SemanticCodeIndexInternalType` and `SemanticCodeIndexExternalType` labels before they run.
- `importScipIndexDataWithAdminImport.sh`: branches CSV conversion and neo4j-admin command on `SCIP_IMPORT_MODE`, using the cross-file admin CSV filenames when in cross-file mode.
- `ENVIRONMENT_VARIABLES.md`, `SCIP.md`, `domains/scip-index-import/README.md`, `MIGRATION.md`.

### Key design notes

- **Performance**: `symbol_has_cross_file_reference` is a boolean map (not an array of files per symbol), computed in a single jq call using the bind-variable pattern. The admin wrapper is a thin awk transformation - no second jq pass.
- **`__file__` nodes**: only emitted when a document references cross-file or external symbols. Self-only references are excluded, so pure single-file definitions produce no spurious fallback nodes.
- **Schema compatibility**: both modes produce `DEPENDS_ON` relationships with `edgeType` as a property. All downstream queries using `:SemanticCodeIndexInternalSymbol`, `:SemanticCodeIndexInternalType`, or `:DEPENDS_ON` work after enrichment completes.
- **Deprecation path**: kind-level code is entirely isolated in the `else` branch. The cross-file branch stands independently. Dropping kind-level later means removing the `else` branch and the `convertScipIndexToCsvForNeo4jImport.sh`/`convertScipIndexToCsvForNeo4jAdminImport.sh` calls.