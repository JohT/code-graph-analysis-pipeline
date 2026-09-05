# SCIP Index Import Domain

Converts SCIP JSON index files to Neo4j import CSVs, imports them into Neo4j, and enriches the graph for analysis.
[SCIP](https://github.com/sourcegraph/scip) (Semantic Code Intelligence Protocol) provides a language-agnostic type dependency graph.

Supported languages: Go, Java, TypeScript, Rust, C++, Ruby, Python, C#.

Anonymous inner classes are detected automatically when the SCIP indexer sets `enclosing_symbol` and `relationships[].is_implementation` on local symbols. See [Anonymous Inner Class Support](#anonymous-inner-class-support) below.

See [SCIP.md](../../SCIP.md) for how to generate `.scip.json` files outside the pipeline.

## How It Works

1. You place `.scip.json` files in the `indices/` directory of your analysis workspace.
2. `analyze.sh` calls `importScipIndexData.sh` automatically when it detects `*.scip.json` files.
3. `importScipIndexData.sh` first runs `convertScipIndexToCsvForNeo4jImport.sh` to convert the JSON to Neo4j import CSVs.
4. The Cypher queries then import and enrich the graph.

## When to use

This domain is triggered **automatically** by `analyze.sh` when `indices/*.scip.json` files exist.
To run it manually: place `.scip.json` files in `indices/` and execute `importScipIndexData.sh`.

## Entry Points

| Script | Purpose |
|--------|---------|
| [installScipCli.sh](./installScipCli.sh) | Downloads and installs the scip CLI binary (optional if scip is already globally available) |
| [importScipIndexData.sh](./importScipIndexData.sh) | Full import and enrichment pipeline (sourced by `analyze.sh`) |
| [convertScipIndexToCsvForNeo4jImport.sh](./convertScipIndexToCsvForNeo4jImport.sh) | Converts `*.scip.json` files to `scip_type_nodes.csv` and `scip_type_edges.csv` |

## Input

Place `.scip.json` files generated outside this pipeline into the `indices/` directory:

```
temp/my-project/indices/
  my-project.scip.json        ← output of: scip print --json index.scip
```

**Only `.scip.json` (JSON format) files are supported.** Binary `.scip` files must be converted first:
```shell
scip print --json index.scip > my-project.scip.json
```

Required tools for conversion (outside pipeline): `jq` (included in `convertScipIndexToCsvForNeo4jImport.sh`), `scip` CLI.

### Installing the scip CLI

The `scip` CLI is required to convert binary `.scip` files to JSON format. Use the `installScipCli.sh` script:

```shell
# From analysis workspace (temp/<project-name>/):
./../../domains/scip-index-import/installScipCli.sh

# Or from repository root:
domains/scip-index-import/installScipCli.sh --bin-dir /path/to/bin
```

**Features:**
- Detects and installs for your platform (macOS, Linux, Windows via Git Bash/WSL)
- Checks if `scip` is already available globally before downloading
- Installs to analysis workspace `./tools/scip-cli/` by default
- Supports version pinning: `SCIP_VERSION=0.8.0 installScipCli.sh`

## Environment Variables

| Variable           | Default    | Description |
|--------------------|------------|-------------|
| `INDICES_DIRECTORY`| `./indices` | Directory containing `*.scip.json` files |
| `IMPORT_DIRECTORY` | `./import`  | Neo4j import directory for generated CSVs |

## Fast Import via `neo4j-admin`

For the **initial import** (empty database), `analyze.sh` attempts a fast path using `neo4j-admin database import full` **before Neo4j starts**. This bypasses the transaction log and writes the native store format directly — significantly faster than LOAD CSV for large indices.

### Conditions

The fast path activates when all conditions are met:

| Condition | Details |
|-----------|---------|
| SCIP indices changed | Hash check (same as regular change detection) — skips if unchanged |
| Neo4j v5 or higher | `neo4j-admin database import full` not available on v4 |
| `neo4j-admin` executable | Found at `${NEO4J_INSTALLATION_DIRECTORY}/bin/neo4j-admin` |

If any condition fails, the fast path is skipped silently and the regular LOAD CSV path runs unchanged.

**Note:** Neo4j is automatically stopped before the admin import attempt (if running), then restarted by the standard pipeline flow.

### What Happens

1. **Pre-start** (`importScipIndexDataWithAdminImport.sh`, sourced before `startNeo4j.sh`):
   - Stops Neo4j if it's running (required for admin import)
   - Converts `*.scip.json` to admin import CSVs via `convertScipIndexToCsvForNeo4jAdminImport.sh`
   - `language` and `isTest` are computed in jq (not via Cypher after import)
   - Attempts `neo4j-admin database import full`
   - **If successful:** Exports `SCIP_ADMIN_IMPORT_DONE=true`
   - **If fails:** Returns silently (LOAD CSV will run as fallback)

2. **Standard flow** (always runs):
   - `startNeo4j.sh` starts Neo4j (or does nothing if already running)
   - `importScipIndexData.sh` runs:
     - If `SCIP_ADMIN_IMPORT_DONE=true`: Skips CSV conversion and LOAD CSV, runs only constraints and enrichment
     - If not set (fallback): Converts CSVs, cleans existing data via Cypher, imports via LOAD CSV, runs enrichment

### Fallback Behavior

When admin import cannot proceed (any guard fails) or fails to complete:

| Scenario | Behavior |
|----------|----------|
| Indices unchanged | Admin import skipped; LOAD CSV skipped; enrichment skipped |
| Neo4j v4 | Admin import skipped; LOAD CSV runs normally |
| `neo4j-admin` missing | Admin import skipped; LOAD CSV runs normally |
| CSV conversion fails | Admin import skipped; LOAD CSV runs normally |
| `neo4j-admin` command fails | Admin import skipped; LOAD CSV runs normally (cleans via Cypher) |
| Database already has data | Admin import fails; LOAD CSV runs (cleans existing data via Cypher before re-importing) |

**Important:** Neo4j is always started after the pre-start phase, so LOAD CSV has access to the HTTP API regardless of success/failure.

### `SCIP_ADMIN_IMPORT_DONE`

Environment variable exported by `importScipIndexDataWithAdminImport.sh` on success. Read by `importScipIndexData.sh` to skip LOAD CSV. Always `unset` at the end of `importScipIndexData.sh` regardless of which path ran.

## Change Detection and Optimization

`importScipIndexData.sh` includes **change detection** to skip re-import and enrichment when indices have not changed. This saves significant time on repeated `analyze.sh` runs, especially for large indices.

### How It Works

- On first run or when `indices/` contains changes, the script converts and imports all SCIP data.
- After successful import, a hash file (`./scipIndexChangeDetection.sha`) is written to track the indices state.
- On subsequent runs, if the hash matches, the entire import and enrichment process is **skipped** (fast path).
- If indices change, the hash is recalculated and the import runs again (slow path).

### Graph Reset

When `scripts/resetAndScan.sh` is executed (graph reset via `analyze.sh`), the change detection hash file is automatically deleted. This forces SCIP indices to be re-imported on the next run, keeping the SCIP graph in sync with the reset database.

**Typical workflow:**
```shell
# First run: full analysis including SCIP import
analyze.sh

# Subsequent runs: faster (skip unchanged indices)
analyze.sh

# Graph reset and full re-import:
analyze.sh  # Updates artifacts/ → triggers resetAndScan → deletes hash → re-imports SCIP
```

### Hash File Location

- **Path:** `indices/scipIndexChangeDetection.sha` (in the analysis workspace's indices directory)
- **Purpose:** Tracks SHA hash of all files in `indices/` directory
- **Behavior:** Auto-deleted on graph reset; regenerated after successful import

## Anonymous Inner Class Support

SCIP represents anonymous inner classes as `local` method symbols within their enclosing method, not as top-level type symbols. This pipeline detects and imports them as first-class nodes when the SCIP indexer provides sufficient metadata.

### Requirements

The SCIP indexer must populate two fields on each local symbol that is a method of an anonymous class:

- `enclosing_symbol` — qualified symbol of the enclosing method (e.g. `semanticdb maven ... Manager#execute().`)
- `relationships[].is_implementation: true` — symbol of the interface method being overridden (e.g. `... Callback#run().`)

Java indexers that use `semanticdb` typically provide both fields. Support for other languages depends on the indexer.

### What Gets Imported

One anonymous class node is created per unique `enclosing_symbol` within a document. If a method contains more than one anonymous class, they share a single node (known limitation — SCIP does not distinguish multiple anonymous classes within the same method).

| Field | Value |
|-------|-------|
| `typeName` | `AnonymousClass` |
| `:LABEL` (admin import) | `SCIP;SemanticCodeIndexInternalType;SemanticCodeIndexAnonymousType` |
| `isAbstract` | `false` |
| `isTest` | Derived from file path (same as other internal types) |
| Node ID format | `<pkg_id> <version> <EnclosingClass>#<method>()$anonymous<N>#` |

Example node ID: `maven/com.example/app 1.0 com/example/Manager#execute()$anonymous3#`

### Edges

Each anonymous class node gets:
- A `DEPENDS_ON` edge to every type it implements (derived from `relationships[].is_implementation`)
- A `BELONGS_TO` edge to the project node (admin import only)

## Folder Structure
├── README.md                              # This file
├── importScipIndexData.sh                 # Entry point: orchestrates CSV conversion + import
├── importScipIndexDataWithAdminImport.sh  # Pre-start fast import via neo4j-admin (sourced by analyze.sh)
├── convertScipIndexToCsvForNeo4jImport.sh # Converts *.scip.json → scip_type_nodes.csv + scip_type_edges.csv (LOAD CSV)
├── convertScipIndexToCsvForNeo4jAdminImport.sh # Converts *.scip.json → admin import CSV format
├── testConvertScipIndexToCsvForNeo4jImport.sh # Tests for convertScipIndexToCsvForNeo4jImport.sh
├── testConvertScipIndexToCsvForNeo4jAdminImport.sh # Tests for convertScipIndexToCsvForNeo4jAdminImport.sh
└── queries/
    ├── import/                            # Phase 1: setup and import
    │   ├── Cleanup_All_SCIP_Nodes.cypher
    │   ├── Create_SCIP_Internal_Type_Constraint.cypher
    │   ├── Create_SCIP_External_Type_Constraint.cypher
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

## Import Phases

`importScipIndexData.sh` runs queries organized into four functional folders in `queries/`:

### 1. Import (`queries/import/`)

| Query | Purpose |
|-------|---------|
| [Cleanup_All_SCIP_Nodes.cypher](./queries/import/Cleanup_All_SCIP_Nodes.cypher) | Delete all existing SCIP-labeled nodes (types, modules, artifacts, projects) — ensures clean slate before re-import |
| [Create_SCIP_Internal_Type_Constraint.cypher](./queries/import/Create_SCIP_Internal_Type_Constraint.cypher) | Create uniqueness constraint on `SemanticCodeIndexInternalType.symbol` |
| [Create_SCIP_External_Type_Constraint.cypher](./queries/import/Create_SCIP_External_Type_Constraint.cypher) | Create uniqueness constraint on `SemanticCodeIndexExternalType.symbol` |
| [Import_SCIP_Type_Internal_Nodes.cypher](./queries/import/Import_SCIP_Type_Internal_Nodes.cypher) | Import internal types (own source files); sets `isTest` from file path patterns |
| [Import_SCIP_Type_External_Nodes.cypher](./queries/import/Import_SCIP_Type_External_Nodes.cypher) | Import external types (library dependencies) |
| [Import_SCIP_Type_Edges.cypher](./queries/import/Import_SCIP_Type_Edges.cypher) | Import `DEPENDS_ON` relationships between types |

### 2. Structure (`queries/structure/`)

Build module and artifact hierarchy, plus dependency relationships.

| Query | Purpose |
|-------|---------|
| [Create_SCIP_Module_Nodes_For_Internal_Types.cypher](./queries/structure/Create_SCIP_Module_Nodes_For_Internal_Types.cypher) | Create `SemanticCodeIndexModule` nodes — one per unique source directory |
| [Create_SCIP_Artifact_Nodes.cypher](./queries/structure/Create_SCIP_Artifact_Nodes.cypher) | Create `SemanticCodeIndexArtifact` nodes — one per unique module+version combination |
| [Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher](./queries/structure/Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher) | `SemanticCodeIndexModule -[:CONTAINS]-> SemanticCodeIndexInternalType` |
| [Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher](./queries/structure/Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher) | `SemanticCodeIndexArtifact -[:CONTAINS]-> SemanticCodeIndexModule` |
| [Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher](./queries/structure/Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher) | `SemanticCodeIndexArtifact -[:CONTAINS]-> SemanticCodeIndexExternalType` |
| [Link_SCIP_Artifact_CONTAINS_SCIP_InternalType.cypher](./queries/structure/Link_SCIP_Artifact_CONTAINS_SCIP_InternalType.cypher) | `SemanticCodeIndexArtifact -[:CONTAINS]-> SemanticCodeIndexInternalType` — direct artifact-to-type link (optimization for projections) |
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
| [Set_Incoming_SCIP_Module_Dependencies.cypher](./queries/enrichment/Set_Incoming_SCIP_Module_Dependencies.cypher) | Set `incomingDependencies` (COUNT), `incomingDependenciesWeight` (SUM), `incomingDependentModules`, and `incomingDependentArtifacts` on modules (includes all sources: test and non-test) |
| [Set_Outgoing_SCIP_Module_Dependencies.cypher](./queries/enrichment/Set_Outgoing_SCIP_Module_Dependencies.cypher) | Set `outgoingDependencies` (COUNT), `outgoingDependenciesWeight` (SUM), `outgoingDependentModules`, and `outgoingDependentArtifacts` on modules (includes all targets: test and non-test) |

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
| `SCIP:SemanticCodeIndexInternalType` | Type from own source code; has `isTest`, `testMarkerInteger`, `file` |
| `SCIP:SemanticCodeIndexExternalType` | Type from an external library; `isTest = false` |
| `SCIP:SemanticCodeIndexModule` | Source directory; has `isTest`, `testMarkerInteger` |
| `SCIP:SemanticCodeIndexArtifact` | Module + version package; groups types and modules |

### Relationships

| Relationship | From → To | Description |
|--------------|-----------|-------------|
| `DEPENDS_ON` | `SemanticCodeIndexInternalType|SemanticCodeIndexExternalType → SemanticCodeIndexInternalType|SemanticCodeIndexExternalType` | Type-level dependency with `referenceCount` |
| `CONTAINS` | `SemanticCodeIndexModule → SemanticCodeIndexInternalType` | Module contains its source types |
| `CONTAINS` | `SemanticCodeIndexArtifact → SemanticCodeIndexModule` | Artifact contains its modules |
| `CONTAINS` | `SemanticCodeIndexArtifact → SemanticCodeIndexExternalType` | Artifact contains its external types |

### Key Properties

| Property | Nodes | Description |
|----------|-------|-------------|
| `isTest` | `SemanticCodeIndexInternalType`, `SemanticCodeIndexModule` | `true` if the node is part of test code |
| `testMarkerInteger` | `SemanticCodeIndexInternalType`, `SemanticCodeIndexExternalType`, `SemanticCodeIndexModule` | `1` if `isTest`, `0` otherwise — used for graph projections |
| `language` | `SemanticCodeIndexInternalType`, `SemanticCodeIndexExternalType` | Detected language (e.g. `Java`, `TypeScript`, `Go`) |
| `incomingDependencies` | `SCIPType` | Number of types that depend on this type |
| `outgoingDependencies` | `SCIPType` | Number of types this type depends on |
| `incomingDependencies` | `SCIPModule` | **COUNT** of type-level DEPENDS_ON edges into types in this module (aggregated from type level) |
| `incomingDependenciesWeight` | `SCIPModule` | **SUM** of `referenceCount` from those edges (edge magnitude) |
| `outgoingDependencies` | `SCIPModule` | **COUNT** of type-level DEPENDS_ON edges from types in this module |
| `outgoingDependenciesWeight` | `SCIPModule` | **SUM** of `referenceCount` from those edges |

### Module Dependency Semantics

**Important Note:** SCIP module dependency metrics use a **different edge model** than Java Packages:

- **SCIP:** One edge per unique type pair (no edge multiplicity) — each distinct (source type → target type) pair creates exactly one DEPENDS_ON edge
- **Java:** Can have multiple DEPENDS_ON edges between the same type pair (richer detail but more edges)

This structural difference means SCIP typically reports ~42–60% fewer edges than equivalent Java Package nodes, even when analyzing the same code.

**Example:** AxonFramework `messaging/core` module:
- **SCIP:** 4,908 type-level edges (unique type pairs)
- **Java Package:** 11,673 type-level edges (including multiple edges per pair)
- **Gap:** ~59% difference due to edge model, not missing data

Both representations are valid; they just capture dependencies at different granularities.

### Test Detection

`isTest` is set on `SCIPInternalType` nodes during import by matching file path patterns (`/test/`, `/tests/`, `/spec/`, `__tests__`, `_test.go`, `.test.`, `.spec.`, Windows equivalents).

`isTest` on `SCIPModule` nodes is derived from its contained types: a module is a test module if **any** of its `SCIPInternalType` nodes has `isTest = true`.
