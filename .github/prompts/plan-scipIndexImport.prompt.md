# Plan: `scip-index-import` Domain

**TL;DR**: Create a standalone `domains/scip-index-import/` domain that (1) imports SCIP type-graph CSVs into Neo4j by splitting source files into single-statement `.cypher` files, (2) enriches the data for `projectionFunctions.sh` compatibility, and (3) creates SCIP-scoped structural nodes and SCIP-specific query variants for cyclic-deps and external-deps compatibility — without polluting shared labels.

**Decided**: domain name = `scip-index-import`, always cleanup before import, pass `referenceCount` as `$dependencies_projection_weight_property` parameter, assume CSVs pre-placed in Neo4j import dir, reuse `cypher/Dependency_Enrichment/` language-agnostic queries directly, keep all SCIP nodes under SCIP-specific labels only.

---

## Phase 1: Import Queries (split source files)

Files in `domains/scip-index-import/queries/`:

1. `Cleanup_SCIP_Type_Nodes.cypher`: copied from `getting-started-with-scip/type-graph/cleanup-code-unit-csv-from-neo4j.cypher`; single DETACH DELETE statement; strip semicolons per convention
2. `Create_SCIP_Type_Constraint.cypher`: Step 1 from `import-code-unit-csv-to-neo4j.cypher` (CREATE CONSTRAINT scip_type_symbol_unique)
3. `Import_SCIP_Type_Internal_Nodes.cypher`: Step 2 (LOAD CSV WHERE row.file <> '')
4. `Import_SCIP_Type_External_Nodes.cypher`: Step 3 (LOAD CSV WHERE row.file = '')
5. `Import_SCIP_Type_Edges.cypher`: Step 4 (LOAD CSV edges, MERGE DEPENDS_ON)

*Cypher convention: strip all semicolons; first line = description comment; one statement per file.*

## Phase 2: Projection-Compatibility Enrichment

6. `Set_Incoming_SCIP_Type_Dependencies.cypher`: MATCH `(target:SCIPType)` WHERE `incomingDependencies IS NULL`; OPTIONAL MATCH source nodes; SET `incomingDependencies`, `incomingDependenciesWeight`
7. `Set_Outgoing_SCIP_Type_Dependencies.cypher`: mirror of above for outgoing
8. `Set_SCIP_Type_Test_Marker_Integer.cypher`: `SET n.testMarkerInteger = CASE WHEN n.isTest THEN 1 ELSE 0 END` WHERE `n.testMarkerInteger IS NULL`; MATCH `(n:SCIPType)`

*Script reuses `cypher/Dependency_Enrichment/Set_Dependency_Degree.cypher` and `Set_Dependency_Degree_Rank.cypher` directly — no copies.*

## Phase 3: Structural Node Enrichment (SCIP-scoped)

Structural nodes carry only SCIP-specific labels to avoid collision with jQAssistant data. No `:Type`, `:Package`, `:Artifact`, or `:ExternalType` labels are added.

9. `Create_SCIP_Artifact_Nodes.cypher`: MERGE `:SCIP:SCIPArtifact` nodes from unique `(module, version, packageManager)` on SCIPType; `fqn = module + ' ' + version`, `name = module`, `fileName = packageId`
10. `Create_SCIP_Module_Nodes_For_Internal_Types.cypher`: MERGE `:SCIP:SCIPModule` nodes from unique directory portion of `file` on `:SCIPInternalType` nodes; `fqn` = raw directory path (language-agnostic: `left(file, size(file) - size(split(file, '/')[-1]) - 1)`); no language-specific stripping
11. `Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher`: MATCH SCIPModule by `fqn` equal to the derived directory of `file`, MATCH SCIPInternalType, MERGE `(module)-[:CONTAINS]->(type)`
12. `Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher`: MATCH SCIPArtifact by module+version, MATCH SCIPModule by module, MERGE `(artifact)-[:CONTAINS]->(module)`
13. `Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher`: External types have no package path; link SCIPArtifact directly to SCIPExternalType via CONTAINS

## Phase 4: SCIP-specific Domain Query Variants

Existing domain queries use `:Package`, `:Type`, `:Artifact`, `:ExternalType` — labels not present on SCIP nodes. SCIP variants are placed in `domains/scip-index-import/queries/` for now (domain not yet integrated).

14. `Cyclic_SCIP_Type_Dependencies.cypher`: adapted from `domains/cyclic-dependencies/queries/Cyclic_Dependencies.cypher`; replace `:Package` with `:SCIPModule`, `:Type` with `:SCIPType`, `:Artifact` with `:SCIPArtifact`; same logic and output columns
15. `External_SCIP_Type_Package_Usage_Overall.cypher`: adapted from `domains/external-dependencies/queries/External_package_usage_overall.cypher`; replace `:ExternalType` with `:SCIPExternalType`, `:Package` with `:SCIPModule`, `:Type` with `:SCIPType`; same logic and output columns

## Phase 5: Entry-point Shell Script

16. `domains/scip-index-import/importScipIndexData.sh`:
    - Header: shebang, blank line, description comment, `set -o errexit -o pipefail -o nounset`, `IFS=$'\n\t'`
    - Source `executeQueryFunctions.sh` (via SCRIPTS_DIR resolution pattern from `prepareAnalysis.sh`)
    - QUERIES_DIR defined relative to script location
    - DEPENDENCY_ENRICHMENT_CYPHER_DIR path to `cypher/Dependency_Enrichment/`
    - Runs in sequence: cleanup → constraint → import nodes (2 queries) → import edges → incoming → outgoing → test marker → Set_Dependency_Degree → Set_Dependency_Degree_Rank → artifact nodes → module nodes → contains links (3 queries)
    - Log each step with echo prefix `importScipIndexData:`

## Verification

1. `shellcheck domains/scip-index-import/importScipIndexData.sh`
2. Copy test CSVs from `temp/simple-project-for-scip-java-comparision/import/` to Neo4j import dir; run script
3. Verify nodes exist: `MATCH (n:SCIPType) RETURN count(n)`
4. Verify projection readiness: run `Dependencies_0_Verify_Projectable.cypher` with params `dependencies_projection_node=SCIPType`, `dependencies_projection_weight_property=referenceCount`
5. Verify cyclic-deps SCIP variant: `domains/scip-index-import/queries/Cyclic_SCIP_Type_Dependencies.cypher`
6. Verify external-deps SCIP variant: `domains/scip-index-import/queries/External_SCIP_Type_Package_Usage_Overall.cypher`

## Gap Analysis

✅ Enabled after this plan:
- `projectionFunctions.sh` with `SCIPType` node + `referenceCount` property (graph algorithms, anomaly detection, node embeddings)
- `Cyclic_SCIP_Type_Dependencies.cypher`: via SCIPModule/SCIPArtifact/CONTAINS + SCIPType
- `External_SCIP_Type_Package_Usage_Overall.cypher`: via SCIPExternalType + SCIPModule/SCIPType

❌ Still missing (not in this plan):
- Internal-deps queries use `:Java:Package`, `:Java:Type` - SCIP-specific variants not planned here
- TypeScript-specific internal-deps queries - different schema entirely
- git-history domain - explicitly out of scope
- Queries using `globalFqn` or `fqn` on types - SCIP types use `symbol`; `name` is the display name

## Further Considerations

1. **Weight property aliasing (optional future optimization)**: If a hardcoded `weight` property becomes necessary (e.g., for domain queries that don't parameterize the weight property), it can be added in Phase 1 during the LOAD CSV edges step (item 5) with a simple `SET r.weight = r.referenceCount` clause. Currently all projection usage is parameterized, so this is not needed.