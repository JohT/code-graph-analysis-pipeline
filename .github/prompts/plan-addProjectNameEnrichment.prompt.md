# Plan: Add `projectName` Enrichment to Code Unit Nodes

## Problem Statement

**Massive duplication pattern:** 20+ Cypher queries across `anomaly-detection`, `archetypes`, and `node-embeddings` domains repeat 4–6 identical lines of `OPTIONAL MATCH` traversal logic to compute project/artifact names at query runtime:

```cypher
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName
    WITH *, coalesce(artifactName, projectName) AS projectName
```

**Consequence:** 
- Each downstream query pays traversal cost (extra I/O) every time it runs
- Code duplication makes maintenance fragile (logic spread across 20+ files)
- New queries must replicate boilerplate or lack project context

**Solution:** Persist `projectName` as a node property once during pipeline setup, eliminating runtime traversal from all downstream queries.

---

## Solution Overview

### Phase 1: Create 2 Enrichment Queries

Two new queries in `cypher/General_Enrichment/` will set the `projectName` property on code unit nodes exactly once, during `prepareAnalysis.sh`:

#### **1. `Set_projectName_for_Java_code_units.cypher`**

```cypher
// Set "projectName" property on Java Package and Type nodes contained in an Artifact. Requires "Add_file_name_and_extension.cypher".

MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
WHERE (codeUnit:Java:Package OR codeUnit:Java:Type)
  AND codeUnit.projectName IS NULL
 SET codeUnit.projectName = artifact.name
RETURN count(*) AS updatedCodeUnits
```

**Why this pattern:**
- `Java:Artifact` is the jQAssistant container for all Java code units (Package, Type, Method)
- `artifact.name` is already set and stable (Maven artifact/JAR identifier)
- Scope to Package + Type because they are projection targets; Method is nested under Type
- `IS NULL` guard makes this query idempotent (safe to re-run without side effects)

---

#### **2. `Set_projectName_for_Typescript_modules.cypher`**

```cypher
// Set "projectName" property on TypeScript Module nodes using the containing Project name. Requires "Add_name_to_property_on_projects.cypher".

MATCH (proj:TS:Project)-[:CONTAINS]->(module:TS:Module)
WHERE proj.name IS NOT NULL
  AND module.projectName IS NULL
 SET module.projectName = proj.name
RETURN count(*) AS updatedModules
```

**Why this pattern:**
- `TS:Project.name` is already enriched by `Add_name_to_property_on_projects.cypher` (accounts for nested config-dir layout)
- More accurate than parsing raw `projectRoot.absoluteFileName` at query time
- Scope to Module (leaf code units are projection targets; their parent Project name is the container context)
- `IS NULL` guard ensures idempotency

---

### Phase 2: Wire Into Pipeline

Edit `scripts/prepareAnalysis.sh` at **line ~70** (immediately after the line):
```bash
execute_cypher "${TYPESCRIPT_CYPHER_DIR}/Add_name_to_property_on_projects.cypher"
```

Add:
```bash
execute_cypher "${GENERAL_ENRICHMENT_CYPHER_DIR}/Set_projectName_for_Java_code_units.cypher"
execute_cypher "${GENERAL_ENRICHMENT_CYPHER_DIR}/Set_projectName_for_Typescript_modules.cypher"
```

**Rationale for placement:**
- After `Add_name_to_property_on_projects.cypher` ensures TS:Project names are set before enriching modules
- Before any domain-specific queries (anomaly-detection, archetypes, etc.) so they can rely on the property

---

### Phase 3: Simplify Downstream Queries (20+ files)

Replace the 2–3 `OPTIONAL MATCH` blocks with a single line reading the enriched property.

#### **Before (example from `AnomalyDetectionFeatures.cypher`):**
```cypher
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, ...) AS codeUnitName
        ,codeUnit.name AS shortCodeUnitName
        ,coalesce(artifactName, projectName, "") AS projectName
        ,...
```

#### **After:**
```cypher
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, ...) AS codeUnitName
        ,codeUnit.name AS shortCodeUnitName
        ,coalesce(codeUnit.projectName, "") AS projectName
        ,...
```

**Impact:** ~6 lines removed per file, 1 line replaces them.

---

## Files to Update

### Anomaly Detection (9 files)

Query files (5):
- `domains/anomaly-detection/features/AnomalyDetectionFeatures.cypher`
- `domains/anomaly-detection/summary/AnomalyDeepDiveTopAnomalies.cypher` ⚠️ **Note:** Has a 3rd fallback for `File:Directory` (SCIP nodes) — see Special Cases below
- `domains/anomaly-detection/queries/node-embeddings/Node_Embeddings_0a_Query_Calculated.cypher`
- `domains/anomaly-detection/queries/node-embeddings/Node_Embeddings_1d_Fast_Random_Projection_Tuneable_Stream.cypher`
- `domains/anomaly-detection/queries/node-embeddings/Node_Embeddings_2d_Hash_GNN_Tuneable_Stream.cypher`
- `domains/anomaly-detection/queries/node-embeddings/Node_Embeddings_3d_Node2Vec_Tuneable_Stream.cypher`

Label files (3):
- `domains/anomaly-detection/labels/AnomalyDetectionArchetypeOutlier.cypher`
- `domains/anomaly-detection/labels/AnomalyDetectionArchetypeBridge.cypher`
- `domains/anomaly-detection/labels/AnomalyDetectionTopAnomalies.cypher`

### Archetypes (11 files)

Query files (8):
- `domains/archetypes/queries/AnomalyDetectionFragileStructuralBridges.cypher`
- `domains/archetypes/queries/AnomalyDetectionOverReferencesUtilities.cypher`
- `domains/archetypes/queries/AnomalyDetectionPotentialImbalancedRoles.cypher`
- `domains/archetypes/queries/AnomalyDetectionSilentCoordinators.cypher`
- `domains/archetypes/queries/AnomalyDetectionPopularBottlenecks.cypher`
- `domains/archetypes/queries/AnomalyDetectionUnexpectedCentralNodes.cypher`
- `domains/archetypes/queries/AnomalyDetectionHiddenBridgeNodes.cypher`
- `domains/archetypes/queries/AnomalyDetectionDependencyHungryOrchestrators.cypher`

Label files (3):
- `domains/archetypes/labels/ArchetypeHub.cypher`
- `domains/archetypes/labels/ArchetypeAuthority.cypher`
- `domains/archetypes/labels/ArchetypeBottleneck.cypher`

⚠️ **Special case:** `domains/archetypes/queries/AnomalyDetectionPotentialOverEngineerOrIsolated.cypher` (not in Phase 3 list yet — needs verification)

### Node-Embeddings (8 files)

Stream files (4):
- `domains/node-embeddings/queries/node-embeddings/Node_Embeddings_1d_Fast_Random_Projection_Stream.cypher`
- `domains/node-embeddings/queries/node-embeddings/Node_Embeddings_2d_Hash_GNN_Stream.cypher`
- `domains/node-embeddings/queries/node-embeddings/Node_Embeddings_3d_Node2Vec_Stream.cypher`
- `domains/node-embeddings/queries/node-embeddings/Node_Embeddings_4d_GraphSAGE_Stream.cypher`

Tuneable-stream files (4):
- `domains/node-embeddings/queries/node-embeddings/Node_Embeddings_1d_Fast_Random_Projection_Tuneable_Stream.cypher`
- `domains/node-embeddings/queries/node-embeddings/Node_Embeddings_2d_Hash_GNN_Tuneable_Stream.cypher`
- `domains/node-embeddings/queries/node-embeddings/Node_Embeddings_3d_Node2Vec_Tuneable_Stream.cypher`
- `domains/node-embeddings/queries/node-embeddings/Node_Embeddings_4d_GraphSAGE_Tuneable_Stream.cypher`

---

## Special Cases & Decisions

### 1. `AnomalyDeepDiveTopAnomalies.cypher` — 3rd Fallback for SCIP Nodes

This file currently has a **third** `OPTIONAL MATCH` for `File:Directory`:
```cypher
OPTIONAL MATCH (codeDirectory:File:Directory)-[:CONTAINS]->(codeUnit)
    WITH *, split(replace(codeDirectory.fileName, './', ''), '/')[-2] AS directoryName
    WITH *, coalesce(artifactName, projectName, directoryName, "") AS projectName
```

**Options:**
- **Option A (Recommended):** Simplify to `coalesce(codeUnit.projectName, '')` — gracefully returns empty string for unmapped SCIP nodes; no third enrichment needed yet
- **Option B:** Add a third enrichment for SCIP nodes using directory-based fallback; revisit when SCIP integration requirements are clarified

**Recommendation:** Option A for now. SCIP node enrichment can be deferred to a future phase if business requirements demand it.

---

### 2. Notebook Embedded Queries

Two Jupyter notebooks contain embedded Cypher queries with the same pattern:
- [domains/anomaly-detection/explore/AnomalyDetectionExploration.ipynb](domains/anomaly-detection/explore/AnomalyDetectionExploration.ipynb)
- [domains/anomaly-detection/explore/AnomalyDetectionIsolationForestExploration.ipynb](domains/anomaly-detection/explore/AnomalyDetectionIsolationForestExploration.ipynb)

**Action:** Update notebook cells to use `coalesce(codeUnit.projectName, "")` instead of the duplicated traversal logic. Notebooks are exploratory/interactive, so updates are not blocking but good hygiene.

---

### 3. Existing Enrichment Precedents

- **`Set_artifactName_property_on_every_Package_node.cypher`:** Existing query (Java Package only, sets `artifactName` property). Our queries are complementary, use `projectName` property, and cover more node types (Package + Type, and all TS:Module).
- **`Set_localRootPath_for_modules.cypher`:** Sets `module.rootProjectName` via local-path parsing. Our `module.projectName` is independent and uses the enriched `proj.name` value. Both can coexist.

---

## Verification & Testing

### Unit Tests (Per-Query)

1. **Test `Set_projectName_for_Java_code_units.cypher`:**
   ```bash
   ./scripts/executeQuery.sh cypher/General_Enrichment/Set_projectName_for_Java_code_units.cypher
   # Expected: updatedCodeUnits > 0 (or 0 if no Java code in database)
   ```

2. **Test `Set_projectName_for_Typescript_modules.cypher`:**
   ```bash
   ./scripts/executeQuery.sh cypher/General_Enrichment/Set_projectName_for_Typescript_modules.cypher
   # Expected: updatedModules > 0 (or 0 if no TypeScript code in database)
   ```

### Integration Test

3. **Spot-check property coverage:**
   ```cypher
   MATCH (n) WHERE n.projectName IS NOT NULL 
   RETURN labels(n)[0..3] AS nodeLabels, count(*) AS count 
   ORDER BY count DESC
   # Expected: Java:Package, Java:Type, TS:Module with non-zero counts
   ```

4. **Run domain analysis:**
   ```bash
   analyze.sh --domain anomaly-detection --report Csv --keep-running
   analyze.sh --domain archetypes --report Csv --keep-running
   # Expected: CSV outputs have non-empty `projectName` column in result rows
   ```

5. **Idempotency check:** Run enrichment twice, verify same result count
   ```bash
   # Run Step 2 enrichments
   ./scripts/executeQuery.sh cypher/General_Enrichment/Set_projectName_for_Java_code_units.cypher
   # Record: X updated
   # Run again
   ./scripts/executeQuery.sh cypher/General_Enrichment/Set_projectName_for_Java_code_units.cypher
   # Expected: 0 updated (all nodes already have projectName set from first run)
   ```

---

## Implementation Checklist

- [ ] **Phase 1.1:** Create `cypher/General_Enrichment/Set_projectName_for_Java_code_units.cypher`
- [ ] **Phase 1.2:** Create `cypher/General_Enrichment/Set_projectName_for_Typescript_modules.cypher`
- [ ] **Phase 1 Verify:** Run both queries standalone; spot-check property coverage
- [ ] **Phase 2:** Edit `scripts/prepareAnalysis.sh` to call both enrichments after `Add_name_to_property_on_projects.cypher`
- [ ] **Phase 2 Verify:** Run `analyze.sh` for a test project; confirm no errors during enrichment phase
- [ ] **Phase 3.1–3.6:** Simplify anomaly-detection queries (6 files)
- [ ] **Phase 3.7–3.17:** Simplify archetypes queries (11 files)
- [ ] **Phase 3.18–3.25:** Simplify node-embeddings queries (8 files)
- [ ] **Phase 3 Verify:** Regression test — run `analyze.sh --domain anomaly-detection --report Csv` and compare CSV outputs to baseline (projectName column should match before/after)
- [ ] **Phase 4 (Optional):** Update notebook queries for consistency
- [ ] **Phase 5 (Optional):** Consider adding third enrichment for SCIP nodes if future requirements demand it

---

## Benefits

| Metric | Before | After |
|--------|--------|-------|
| **Code duplication** | 20+ query files repeat 4–6 lines each (~100+ duplicated lines total) | 2 centralized enrichment queries |
| **Query runtime** | Each query traverses Artifact/Project→codeUnit relationships at runtime | Single traversal during preparation; queries read cached property |
| **Maintainability** | Change to project name logic = update 20+ files | Change = update 2 enrichment files + update 1 return alias pattern |
| **New query onboarding** | Must replicate traversal boilerplate or miss context | Simply use `coalesce(codeUnit.projectName, '')` |
| **Pipeline performance** | No improvement (traversal cost is relatively small) | Modest improvement (O(1) property read vs O(N) traversal per query) |

---

## Design Principles Applied

- **DRY (Don't Repeat Yourself):** Eliminate duplicated logic across 20+ files
- **Single Responsibility:** Enrichment queries own the project-name resolution; business queries only read the result
- **Idempotency:** `IS NULL` guard allows safe re-runs without side effects
- **Separation of Concerns:** Preparation phase handles all enrichment; domain queries remain focused on their logic
- **Minimal Breaking Changes:** Downstream queries change only return clauses, not WHERE/MATCH logic

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Enrichment queries miss edge cases (e.g., SCIP nodes) | Some code units lack projectName; queries fall back to empty string | Phase 3 uses `coalesce()` fallback; test with real SCIP data before committing |
| Stale projectName if node structure changes mid-pipeline | Incorrect project association after re-analysis | Guard with `IS NULL` ensures fresh property on re-run; add validation query to prepareAnalysis if needed |
| Performance regression if enrichment queries are slow | Pipeline startup time increases | Test enrichment performance on large databases (>1M nodes); optimize if needed |
| Notebooks diverge from main queries | Maintenance burden; documentation inconsistency | Update notebooks as part of Phase 3 (or defer to Phase 4 if time-constrained) |

---

## Future Enhancements

1. **SCIP Node Enrichment:** Add `Set_projectName_for_SCIP_nodes.cypher` when SCIP integration requirements are clarified
2. **Other Labels:** Extend enrichment to `File:Directory`, `Method`, or domain-specific labels if needed
3. **Validation Query:** Add a data-quality check to `prepareAnalysis.sh` that verifies `projectName` coverage for expected node types
4. **Documentation:** Update [CYPHER.md](../../CYPHER.md) reference (auto-generated from file headers) to document new enrichments
