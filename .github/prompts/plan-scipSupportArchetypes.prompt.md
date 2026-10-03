# Plan: SCIP Support for Archetypes Domain

## Decisions
- Abstractness: `Interface`/`TypeAlias` → 1.0, `AbstractClass` → 0.7, rest → 0.0; computed for all three levels
- SCIP Artifact scope: include external artifacts (interesting signal for 3rd-party lib role classification)

## TL;DR
Extend the archetypes domain to classify SCIP-based nodes at three levels: `SemanticCodeIndexInternalType`, `SemanticCodeIndexModule`, `SemanticCodeIndexArtifact`. All existing parameterized Cypher query files work as-is. The work is: 3 new abstractness feature queries + additive invocation blocks in 3 shell scripts.

---

## Phase 1 — New feature query files (parallel; independent)

### 1a. `domains/archetypes/features/ArchetypeFeature_Abstractness_ScipInternalType.cypher`
- Match `SemanticCodeIndexInternalType` nodes
- Map `typeName`: `Interface`/`TypeAlias` → 1.0, `AbstractClass` → 0.7, else → 0.0
- SET `n.abstractness` and return bin distribution (same return shape as Java Type query)
- Reference: `ArchetypeFeature_Abstractness_JavaType.cypher` for return style

### 1b. `domains/archetypes/features/ArchetypeFeature_Abstractness_ScipModule.cypher`
- Match `SemanticCodeIndexModule`-[:CONTAINS]->`SemanticCodeIndexInternalType`
- Aggregate: count types, count abstract classes, count interfaces/aliases, weighted sum / total
- Formula mirrors `ArchetypeFeature_Abstractness_Java.cypher` Package aggregation
- SET `m.abstractness` on module nodes; return bin distribution

### 1c. `domains/archetypes/features/ArchetypeFeature_Abstractness_ScipArtifact.cypher`
- Match `SemanticCodeIndexArtifact`-[:CONTAINS]->`SemanticCodeIndexInternalType` (direct link, not via module)
  - Reason: `Link_SCIP_Artifact_CONTAINS_SCIP_InternalType` exists as an optimization link
  - External artifacts have no internal types → get no abstractness; this is acceptable
- Same aggregation formula as ScipModule; SET `a.abstractness`; return bin distribution

---

## Phase 2 — Extend `archetypesCsv.sh` (depends on Phase 1)

File: `domains/archetypes/archetypesCsv.sh`

### 2a. Add 3 SCIP calls inside `archetype_features()` function
After the existing TypeScript abstractness call, add:
```bash
execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                     "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_ScipInternalType.cypher" "${@}"
execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                     "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_ScipModule.cypher" "${@}"
execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                     "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_ScipArtifact.cypher" "${@}"
```
Skip-if-exists semantics: The Exists query checks `$projection_node_label IN labels(codeUnit)`. For each projection level, only the matching write query matters. Others run idempotently or get skipped.

### 2b. Add 3 SCIP invocation blocks after the Typescript block
```
# -- SCIP InternalType Archetypes
if createUndirectedDependencyProjection ... SemanticCodeIndexInternalType ... referenceCount ... SCIP; then
    createDirectedDependencyProjection  ... SemanticCodeIndexInternalType-directed ... referenceCount ... SCIP
    archetypes_csv_reports              ... SemanticCodeIndexInternalType ... referenceCount ... SCIP
fi

# -- SCIP Module Archetypes
if createUndirectedDependencyProjection ... SemanticCodeIndexModule ... referenceCount ... SCIP; then
    createDirectedDependencyProjection  ... SemanticCodeIndexModule-directed ... referenceCount ... SCIP
    archetypes_csv_reports              ... SemanticCodeIndexModule ... referenceCount ... SCIP
fi

# -- SCIP Artifact Archetypes
if createUndirectedDependencyProjection ... SemanticCodeIndexArtifact ... referenceCount ... SCIP; then
    createDirectedDependencyProjection  ... SemanticCodeIndexArtifact-directed ... referenceCount ... SCIP
    archetypes_csv_reports              ... SemanticCodeIndexArtifact ... referenceCount ... SCIP
fi
```
Projection names: `scip-type-archetypes`, `scip-module-archetypes`, `scip-artifact-archetypes`

---

## Phase 3 — Extend `archetypesGraphs.sh` (depends on Phase 2 - SCIP data needed)

File: `domains/archetypes/graphs/archetypesGraphs.sh`

Add 3 blocks after the Typescript block (same pattern as existing Java/TS blocks):
```
archetypes_graph_visualization "${QUERY_NODE}=SemanticCodeIndexInternalType" "${QUERY_LANGUAGE}=SCIP" "${QUERY_WEIGHT}=referenceCount"
archetypes_graph_visualization "${QUERY_NODE}=SemanticCodeIndexModule"        "${QUERY_LANGUAGE}=SCIP" "${QUERY_WEIGHT}=referenceCount"
archetypes_graph_visualization "${QUERY_NODE}=SemanticCodeIndexArtifact"      "${QUERY_LANGUAGE}=SCIP" "${QUERY_WEIGHT}=referenceCount"
```

---

## Phase 4 — Extend `archetypesSummary.sh` (parallel with Phase 3)

File: `domains/archetypes/summary/archetypesSummary.sh`

Add 3 report blocks after the Typescript block:
```
archetypes_report "${ALGORITHM_NODE}=SemanticCodeIndexInternalType" "${ALGORITHM_LANGUAGE}=SCIP"
archetypes_report "${ALGORITHM_NODE}=SemanticCodeIndexModule"        "${ALGORITHM_LANGUAGE}=SCIP"
archetypes_report "${ALGORITHM_NODE}=SemanticCodeIndexArtifact"      "${ALGORITHM_LANGUAGE}=SCIP"
```

---

## Phase 5 — Update README (parallel; independent)

File: `domains/archetypes/README.md`
- Add SCIP abstraction levels table (InternalType, Module, Artifact)
- Document weight property (`referenceCount` vs Java's `weight`)
- Note external artifact inclusion in Artifact-level analysis
- Note that report directories use `SCIP_SemanticCodeIndex*` naming

---

## Files NOT needing changes

All existing Cypher queries are parameterized via `$projection_node_label`:
- `labels/*.cypher` — use `labels(codeUnit)` check; SCIP nodes have `fqn` for display
- `labels/ArchetypeRemoveLabels.cypher` — REMOVE is no-op if label absent
- `queries/AnomalyDetection*.cypher` — parameterized; work with any node label
- `graphs/TopAuthority.cypher`, `TopBottleneck.cypher`, `TopHub.cypher` — SCIP nodes have `name`, `fqn`
- `graphs/TopCentral.template.gv` — unchanged
- `summary/ArchetypeDeepDiveArchetypes.cypher` — parameterized
- `summary/ArchetypesInTotal.cypher` — counts all nodes with dependency data
- `summary/ArchetypesPerAbstractionLayer.cypher` — SCIP nodes appear as `SCIP,SemanticCodeIndex*`; no filter change needed
- All `features/` GDS algorithm queries — fully parameterized; work with any label

---

## Key Design Notes

**`referenceCount` as weight**: Only edge property available on SCIP DEPENDS_ON edges. Java uses `weight` (inflated by interface reference count). SCIP archetype classification uses relative percentile rankings so absolute value difference is acceptable.

**Module `projectName` missing**: SCIP modules have no `projectName` property. The archetype label queries use `coalesce(codeUnit.projectName, '')` → returns empty string. Module `fqn` (full directory path) is returned as `codeUnitName`, providing sufficient identification.

**Report directory naming**: `${language}_${nodeLabel}` → `SCIP_SemanticCodeIndexInternalType`, `SCIP_SemanticCodeIndexModule`, `SCIP_SemanticCodeIndexArtifact`. Verbose but unambiguous.

**Abstractness skip-if-exists correctness**: Each projection's `archetype_features()` call runs 6 abstractness call pairs (3 existing + 3 SCIP). For each projection level, only the matching SCIP write query successfully sets abstractness for that level's nodes. Other SCIP writes either run idempotently (for other label types) or get skipped (after the matching level's Exists returns true).

**External artifacts**: `SemanticCodeIndexArtifact` includes external (third-party) artifacts. The projection subgraph filter only excludes test nodes and zero-degree nodes — external artifacts with `incomingDependencies > 0` appear in the analysis. External artifacts show as Authority archetypes when widely depended upon.

---

## Verification

1. `shellcheck domains/archetypes/archetypesCsv.sh domains/archetypes/graphs/archetypesGraphs.sh domains/archetypes/summary/archetypesSummary.sh`
2. Run `analyze.sh --domain archetypes --report Csv --keep-running` in a workspace with SCIP indices
3. Verify report dirs exist and contain CSV files: `reports/archetypes/SCIP_SemanticCodeIndexInternalType/`, `SCIP_SemanticCodeIndexModule/`, `SCIP_SemanticCodeIndexArtifact/`
4. `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json domains/archetypes/README.md`
