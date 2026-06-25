# SCIP Index Import Domain

Imports SCIP type-graph data from CSV into Neo4j and enriches it for analysis.
[SCIP](https://github.com/sourcegraph/scip) (Sourcegraph Code Intelligence Protocol) provides a language-agnostic type dependency graph.

Supported languages: Go, Java, TypeScript, Rust, C++, Ruby, Python, C#.

## When to use

Run this domain after generating `scip_type_nodes.csv` and `scip_type_edges.csv` and placing them in the Neo4j import directory.

## Entry Point

| Script | Purpose |
|--------|---------|
| [importScipIndexData.sh](./importScipIndexData.sh) | Full import and enrichment pipeline — run this directly |

## Prerequisites

Two CSV files must be present in the Neo4j import directory before running:

| File | Columns |
|------|---------|
| `scip_type_nodes.csv` | `symbol`, `display_name`, `file`, `scheme`, `type_name`, `package_id`, `package_manager`, `version`, `module`, `is_abstract` |
| `scip_type_edges.csv` | `source_symbol`, `target_symbol`, `reference_count` |

Internal types have a non-empty `file` column. External types have an empty `file` column.

## Import Phases

`importScipIndexData.sh` runs the following queries in order:

### 1. Setup

| Query | Purpose |
|-------|---------|
| [Cleanup_SCIP_Type_Nodes.cypher](./queries/Cleanup_SCIP_Type_Nodes.cypher) | Delete all existing SCIP nodes — clean slate before re-import |
| [Create_SCIP_Type_Constraint.cypher](./queries/Create_SCIP_Type_Constraint.cypher) | Create uniqueness constraint on `SCIPType.symbol` |

### 2. Import

| Query | Purpose |
|-------|---------|
| [Import_SCIP_Type_Internal_Nodes.cypher](./queries/Import_SCIP_Type_Internal_Nodes.cypher) | Import internal types (own source files); sets `isTest` from file path patterns |
| [Import_SCIP_Type_External_Nodes.cypher](./queries/Import_SCIP_Type_External_Nodes.cypher) | Import external types (library dependencies) |
| [Import_SCIP_Type_Edges.cypher](./queries/Import_SCIP_Type_Edges.cypher) | Import `DEPENDS_ON` relationships between types |

### 3. Type Enrichment

| Query | Purpose |
|-------|---------|
| [Set_Incoming_SCIP_Type_Dependencies.cypher](./queries/Set_Incoming_SCIP_Type_Dependencies.cypher) | Set `incomingDependencies` count on each type |
| [Set_Outgoing_SCIP_Type_Dependencies.cypher](./queries/Set_Outgoing_SCIP_Type_Dependencies.cypher) | Set `outgoingDependencies` count on each type |
| [Set_SCIP_Type_Test_Marker_Integer.cypher](./queries/Set_SCIP_Type_Test_Marker_Integer.cypher) | Set `testMarkerInteger` (0/1) from `isTest` on all types |

### 4. Structural Nodes and Links

| Query | Purpose |
|-------|---------|
| [Create_SCIP_Module_Nodes_For_Internal_Types.cypher](./queries/Create_SCIP_Module_Nodes_For_Internal_Types.cypher) | Create `SCIPModule` nodes — one per unique source directory |
| [Create_SCIP_Artifact_Nodes.cypher](./queries/Create_SCIP_Artifact_Nodes.cypher) | Create `SCIPArtifact` nodes — one per unique module+version combination |
| [Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher](./queries/Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher) | `SCIPModule -[:CONTAINS]-> SCIPInternalType` |
| [Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher](./queries/Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher) | `SCIPArtifact -[:CONTAINS]-> SCIPModule` |
| [Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher](./queries/Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher) | `SCIPArtifact -[:CONTAINS]-> SCIPExternalType` |
| [Set_SCIP_Module_Is_Test_And_Marker_Integer.cypher](./queries/Set_SCIP_Module_Is_Test_And_Marker_Integer.cypher) | Set `isTest` and `testMarkerInteger` on modules — true if any contained type is a test |

### 5. Dependency Metrics

Shared queries from [`cypher/Dependency_Enrichment/`](../../cypher/Dependency_Enrichment/):

- `Set_Dependency_Degree.cypher` — combined in/out degree per node
- `Set_Dependency_Degree_Rank.cypher` — percentile rank of dependency degree

## Graph Model

### Nodes

| Label | Description |
|-------|-------------|
| `SCIP:SCIPType:SCIPInternalType` | Type from own source code; has `isTest`, `testMarkerInteger`, `file` |
| `SCIP:SCIPType:SCIPExternalType` | Type from an external library; `isTest = false` |
| `SCIP:SCIPModule` | Source directory; has `isTest`, `testMarkerInteger` |
| `SCIP:SCIPArtifact` | Module + version package; groups types and modules |

### Relationships

| Relationship | From → To | Description |
|--------------|-----------|-------------|
| `DEPENDS_ON` | `SCIPType → SCIPType` | Type-level dependency with `referenceCount` |
| `CONTAINS` | `SCIPModule → SCIPInternalType` | Module contains its source types |
| `CONTAINS` | `SCIPArtifact → SCIPModule` | Artifact contains its modules |
| `CONTAINS` | `SCIPArtifact → SCIPExternalType` | Artifact contains its external types |

### Key Properties

| Property | Nodes | Description |
|----------|-------|-------------|
| `isTest` | `SCIPInternalType`, `SCIPModule` | `true` if the node is part of test code |
| `testMarkerInteger` | `SCIPType`, `SCIPModule` | `1` if `isTest`, `0` otherwise — used for graph projections |
| `language` | `SCIPType` | Detected language (e.g. `Java`, `TypeScript`, `Go`) |
| `incomingDependencies` | `SCIPType` | Number of types that depend on this type |
| `outgoingDependencies` | `SCIPType` | Number of types this type depends on |

### Test Detection

`isTest` is set on `SCIPInternalType` nodes during import by matching file path patterns (`/test/`, `/tests/`, `/spec/`, `__tests__`, `_test.go`, `.test.`, `.spec.`, Windows equivalents).

`isTest` on `SCIPModule` nodes is derived from its contained types: a module is a test module if **any** of its `SCIPInternalType` nodes has `isTest = true`.
