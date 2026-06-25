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

## Folder Structure

```text
domains/scip-index-import/
├── README.md                              # This file
├── importScipIndexData.sh                 # Entry point: orchestrates full import pipeline
└── queries/
    ├── import/                            # Phase 1: setup and import
    │   ├── Cleanup_SCIP_Type_Nodes.cypher
    │   ├── Create_SCIP_Type_Constraint.cypher
    │   ├── Import_SCIP_Type_Internal_Nodes.cypher
    │   ├── Import_SCIP_Type_External_Nodes.cypher
    │   └── Import_SCIP_Type_Edges.cypher
    ├── structure/                         # Phase 2: module/artifact nodes and dependencies
    │   ├── Create_SCIP_Module_Nodes_For_Internal_Types.cypher
    │   ├── Create_SCIP_Artifact_Nodes.cypher
    │   ├── Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher
    │   ├── Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher
    │   ├── Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher
    │   ├── Link_SCIP_Artifact_CONTAINS_SCIP_InternalType.cypher
    │   ├── Link_SCIP_Module_DEPENDS_ON_SCIP_Module.cypher
    │   └── Link_SCIP_Artifact_DEPENDS_ON_SCIP_Artifact.cypher
    ├── enrichment/                        # Phase 3: dependency counts and properties
    │   ├── Set_Incoming_SCIP_Type_Dependencies.cypher
    │   ├── Set_Outgoing_SCIP_Type_Dependencies.cypher
    │   ├── Set_SCIP_Type_Test_Marker_Integer.cypher
    │   ├── Set_SCIP_Type_Project_Name.cypher
    │   ├── Set_SCIP_Module_Is_Test_And_Marker_Integer.cypher
    │   ├── Set_Incoming_SCIP_Module_Dependencies.cypher
    │   ├── Set_Outgoing_SCIP_Module_Dependencies.cypher
    │   ├── Set_SCIP_Artifact_Is_Test_And_Marker_Integer.cypher
    │   ├── Set_SCIP_Artifact_Is_External.cypher
    │   ├── Set_Incoming_SCIP_Artifact_Dependencies.cypher
    │   └── Set_Outgoing_SCIP_Artifact_Dependencies.cypher
    └── analysis/                          # Investigation and analytics queries
        ├── Cyclic_SCIP_Type_Dependencies.cypher
        └── External_SCIP_Type_Package_Usage_Overall.cypher
```

## Prerequisites

Two CSV files must be present in the Neo4j import directory before running:

| File | Columns |
|------|---------|
| `scip_type_nodes.csv` | `symbol`, `display_name`, `file`, `scheme`, `type_name`, `package_id`, `package_manager`, `version`, `module`, `is_abstract` |
| `scip_type_edges.csv` | `source_symbol`, `target_symbol`, `reference_count` |

Internal types have a non-empty `file` column. External types have an empty `file` column.

## Import Phases

`importScipIndexData.sh` runs queries organized into four functional folders in `queries/`:

### 1. Import (`queries/import/`)

| Query | Purpose |
|-------|---------|
| [Cleanup_SCIP_Type_Nodes.cypher](./queries/import/Cleanup_SCIP_Type_Nodes.cypher) | Delete all existing SCIP nodes — clean slate before re-import |
| [Create_SCIP_Type_Constraint.cypher](./queries/import/Create_SCIP_Type_Constraint.cypher) | Create uniqueness constraint on `SemanticCodeIndexType.symbol` |
| [Import_SCIP_Type_Internal_Nodes.cypher](./queries/import/Import_SCIP_Type_Internal_Nodes.cypher) | Import internal types (own source files); sets `isTest` from file path patterns |
| [Import_SCIP_Type_External_Nodes.cypher](./queries/import/Import_SCIP_Type_External_Nodes.cypher) | Import external types (library dependencies) |
| [Import_SCIP_Type_Edges.cypher](./queries/import/Import_SCIP_Type_Edges.cypher) | Import `DEPENDS_ON` relationships between types |

### 2. Structure (`queries/structure/`)

Build module and artifact hierarchy, plus dependency relationships.

| Query | Purpose |
|-------|---------|
| [Create_SCIP_Module_Nodes_For_Internal_Types.cypher](./queries/structure/Create_SCIP_Module_Nodes_For_Internal_Types.cypher) | Create `SemanticCodeIndexModule` nodes — one per unique source directory |
| [Create_SCIP_Artifact_Nodes.cypher](./queries/structure/Create_SCIP_Artifact_Nodes.cypher) | Create `SemanticCodeIndexArtifact` nodes — one per unique module+version combination |
| [Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher](./queries/structure/Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher) | `SemanticCodeIndexModule -[:CONTAINS]-> InternalType` |
| [Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher](./queries/structure/Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher) | `SemanticCodeIndexArtifact -[:CONTAINS]-> SemanticCodeIndexModule` |
| [Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher](./queries/structure/Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher) | `SemanticCodeIndexArtifact -[:CONTAINS]-> ExternalType` |
| [Link_SCIP_Artifact_CONTAINS_SCIP_InternalType.cypher](./queries/structure/Link_SCIP_Artifact_CONTAINS_SCIP_InternalType.cypher) | `SemanticCodeIndexArtifact -[:CONTAINS]-> InternalType` — direct artifact-to-type link (optimization for projections) |
| [Link_SCIP_Module_DEPENDS_ON_SCIP_Module.cypher](./queries/structure/Link_SCIP_Module_DEPENDS_ON_SCIP_Module.cypher) | `SemanticCodeIndexModule -[:DEPENDS_ON]-> SemanticCodeIndexModule` — aggregated from type dependencies |
| [Link_SCIP_Artifact_DEPENDS_ON_SCIP_Artifact.cypher](./queries/structure/Link_SCIP_Artifact_DEPENDS_ON_SCIP_Artifact.cypher) | `SemanticCodeIndexArtifact -[:DEPENDS_ON]-> SemanticCodeIndexArtifact` — aggregated from module dependencies |

### 3. Enrichment (`queries/enrichment/`)

Set dependency counts and derived properties on nodes.

**Type Enrichment:**

| Query | Purpose |
|-------|---------|
| [Set_Incoming_SCIP_Type_Dependencies.cypher](./queries/enrichment/Set_Incoming_SCIP_Type_Dependencies.cypher) | Set `incomingDependencies` and `incomingDependenciesWeight` on each type |
| [Set_Outgoing_SCIP_Type_Dependencies.cypher](./queries/enrichment/Set_Outgoing_SCIP_Type_Dependencies.cypher) | Set `outgoingDependencies` and `outgoingDependenciesWeight` on each type |
| [Set_SCIP_Type_Test_Marker_Integer.cypher](./queries/enrichment/Set_SCIP_Type_Test_Marker_Integer.cypher) | Set `testMarkerInteger` (0/1) from `isTest` on all types |
| [Set_SCIP_Type_Project_Name.cypher](./queries/enrichment/Set_SCIP_Type_Project_Name.cypher) | Set `projectName` from `module` on all types |

**Module Enrichment:**

| Query | Purpose |
|-------|---------|
| [Set_SCIP_Module_Is_Test_And_Marker_Integer.cypher](./queries/enrichment/Set_SCIP_Module_Is_Test_And_Marker_Integer.cypher) | Set `isTest` and `testMarkerInteger` on modules — true if any contained type is a test |
| [Set_Incoming_SCIP_Module_Dependencies.cypher](./queries/enrichment/Set_Incoming_SCIP_Module_Dependencies.cypher) | Set `incomingDependencies` and `incomingDependenciesWeight` on modules |
| [Set_Outgoing_SCIP_Module_Dependencies.cypher](./queries/enrichment/Set_Outgoing_SCIP_Module_Dependencies.cypher) | Set `outgoingDependencies` and `outgoingDependenciesWeight` on modules |

**Artifact Enrichment:**

| Query | Purpose |
|-------|---------|
| [Set_SCIP_Artifact_Is_Test_And_Marker_Integer.cypher](./queries/enrichment/Set_SCIP_Artifact_Is_Test_And_Marker_Integer.cypher) | Set `isTest` and `testMarkerInteger` on artifacts — true if any contained internal type is a test |
| [Set_SCIP_Artifact_Is_External.cypher](./queries/enrichment/Set_SCIP_Artifact_Is_External.cypher) | Set `isExternal` on artifacts — true if contains only external types |
| [Set_Incoming_SCIP_Artifact_Dependencies.cypher](./queries/enrichment/Set_Incoming_SCIP_Artifact_Dependencies.cypher) | Set `incomingDependencies` and `incomingDependenciesWeight` on artifacts |
| [Set_Outgoing_SCIP_Artifact_Dependencies.cypher](./queries/enrichment/Set_Outgoing_SCIP_Artifact_Dependencies.cypher) | Set `outgoingDependencies` and `outgoingDependenciesWeight` on artifacts |

### 4. Analysis (`queries/analysis/`)

Investigation queries for SCIP data (used by other domains):

- [Cyclic_SCIP_Type_Dependencies.cypher](./queries/analysis/Cyclic_SCIP_Type_Dependencies.cypher) — Cyclic module dependencies
- [External_SCIP_Type_Package_Usage_Overall.cypher](./queries/analysis/External_SCIP_Type_Package_Usage_Overall.cypher) — External package usage patterns

### 5. Dependency Metrics

Shared queries from [`cypher/Dependency_Enrichment/`](../../cypher/Dependency_Enrichment/):

- `Set_Dependency_Degree.cypher` — combined in/out degree per node
- `Set_Dependency_Degree_Rank.cypher` — percentile rank of dependency degree

## Graph Model

### Nodes

| Label | Description |
|-------|-------------|
| `SCIP:SemanticCodeIndexType:InternalType` | Type from own source code; has `isTest`, `testMarkerInteger`, `file` |
| `SCIP:SemanticCodeIndexType:ExternalType` | Type from an external library; `isTest = false` |
| `SCIP:SemanticCodeIndexModule` | Source directory; has `isTest`, `testMarkerInteger` |
| `SCIP:SemanticCodeIndexArtifact` | Module + version package; groups types and modules |

### Relationships

| Relationship | From → To | Description |
|--------------|-----------|-------------|
| `DEPENDS_ON` | `SemanticCodeIndexType → SemanticCodeIndexType` | Type-level dependency with `referenceCount` |
| `CONTAINS` | `SemanticCodeIndexModule → InternalType` | Module contains its source types |
| `CONTAINS` | `SemanticCodeIndexArtifact → SemanticCodeIndexModule` | Artifact contains its modules |
| `CONTAINS` | `SemanticCodeIndexArtifact → ExternalType` | Artifact contains its external types |

### Key Properties

| Property | Nodes | Description |
|----------|-------|-------------|
| `isTest` | `InternalType`, `SemanticCodeIndexModule` | `true` if the node is part of test code |
| `testMarkerInteger` | `SemanticCodeIndexType`, `SemanticCodeIndexModule` | `1` if `isTest`, `0` otherwise — used for graph projections |
| `language` | `SemanticCodeIndexType` | Detected language (e.g. `Java`, `TypeScript`, `Go`) |
| `incomingDependencies` | `SCIPType` | Number of types that depend on this type |
| `outgoingDependencies` | `SCIPType` | Number of types this type depends on |

### Test Detection

`isTest` is set on `SCIPInternalType` nodes during import by matching file path patterns (`/test/`, `/tests/`, `/spec/`, `__tests__`, `_test.go`, `.test.`, `.spec.`, Windows equivalents).

`isTest` on `SCIPModule` nodes is derived from its contained types: a module is a test module if **any** of its `SCIPInternalType` nodes has `isTest = true`.
