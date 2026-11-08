# SCIP Index Import Domain

Converts SCIP JSON index files to Neo4j import CSVs, imports them into Neo4j, and enriches the graph for analysis.
[SCIP](https://github.com/sourcegraph/scip) (Semantic Code Intelligence Protocol) provides a language-agnostic code dependency graph of types and module-level functions.

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
| [examples/installScipCli.sh](./examples/installScipCli.sh) | Downloads and installs the scip CLI binary (optional if scip is already globally available) |
| [importScipIndexData.sh](./importScipIndexData.sh) | Full import and enrichment pipeline (sourced by `analyze.sh`) |
| [convertScipIndexToCsvForNeo4jImport.sh](./convertScipIndexToCsvForNeo4jImport.sh) | Converts `*.scip.json` files to type CSVs (`scip_type_nodes.csv`, `scip_type_edges.csv`) and function CSVs (`scip_function_nodes.csv`, `scip_function_edges.csv`) |

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

The `scip` CLI is required to convert binary `.scip` files to JSON format. Use the `installScipCli.sh` script in `examples/`:

```shell
# From analysis workspace (temp/<project-name>/):
./../../domains/scip-index-import/examples/installScipCli.sh

# Or from repository root:
domains/scip-index-import/examples/installScipCli.sh --bin-dir /path/to/bin
```

**Features:**
- Detects and installs for your platform (macOS, Linux, Windows via Git Bash/WSL)
- Checks if `scip` is already available globally before downloading
- Installs to analysis workspace `./tools/scip-cli/` by default
- Supports version pinning: `SCIP_VERSION=0.8.0 installScipCli.sh`

## Examples Directory

The `examples/` subdirectory contains helper scripts for generating SCIP indices outside the pipeline — for use in CI or locally before running `analyze.sh`.

| Script | Purpose |
|--------|---------|
| [examples/installScipCli.sh](./examples/installScipCli.sh) | Downloads and installs the scip CLI binary |
| [examples/installScipJava.sh](./examples/installScipJava.sh) | Installs scip-java 0.12.3 via Coursier (requires Java 11+, curl) |
| [examples/createScipIndexFunctionsForJava.sh](./examples/createScipIndexFunctionsForJava.sh) | Sourced library: `index_module` and `resolve_placeholders_in_json` functions for Maven multi-module projects (use module directory names, e.g., "common", not artifact IDs like "axon-common") |
| [examples/createAxonFrameworkScipIndices.sh](./examples/createAxonFrameworkScipIndices.sh) | Creates per-module SCIP indices for AxonFramework (5 modules) |
| [examples/testInstallScipJava.sh](./examples/testInstallScipJava.sh) | Unit tests for `installScipJava.sh` |

**scip-java version note:** `installScipJava.sh` pins to 0.12.3 (`com.sourcegraph:scip-java_2.13`).
The Coursier bootstrap requires `--main com.sourcegraph.scip_java.ScipJava` to create an executable wrapper (package name differs in newer versions).
Version 0.13.x uses a different artifact (`org.scip-code:scip-java`) with a different package name (`org.scip_code.scip_java`) and introduced a Coursier bash wrapper bug on Linux — do not upgrade `SCIP_JAVA_VERSION` without verifying compatibility.

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

## Annotation-Only Files (e.g. `package-info.java`)

Some source files contain no type definitions but reference types via annotations or imports: Java's `package-info.java` is the most common example. These files have no internal symbols in the SCIP occurrence list (no `symbol_roles: 1` entries).

When such a file contains type references (either external or internal):

1. **With external type references**: Creates a `__file__ <path>` node using package metadata from a sibling file in the same directory (if one exists), and generates `DEPENDS_ON` edges to the referenced external types.

2. **With internal type references**: Creates a `__file__ <path>` node using package metadata extracted from the referenced internal type itself, and generates `DEPENDS_ON` edges to those internal types.

3. **Isolated (no sibling metadata)**: If the file is the only file in its directory and has only external type references, no node or edges are created (no metadata source available).

The pipeline always uses the most specific metadata source available:
- **First priority**: Definition symbols within the file (role=1)
- **Second priority**: Internal type references within the file (role=0 with internal package IDs)
- **Third priority**: Sibling files in the same directory (for external type references)

| Field | Value |
|-------|-------|
| `typeName` | `File` |
| `symbol` / `id` | `__file__ <relative_path>` |
| `packageId` | Extracted from definition symbols, internal references, or sibling files |
| `isAbstract` | `false` |

This behavior applies to any file without internal type definitions, not only `package-info.java`.

## Cross-Module `is_implementation` Relationships (Multi-Module SCIP)

When multiple per-module SCIP indices are processed (one per Maven module), a class in module B may implement an interface from module A. In per-module SCIP, the implementing class carries an `is_implementation` relationship pointing to the interface with the resolved module version (e.g., `5.1.1`), while the interface's definition in its home module uses a placeholder (e.g., `${revision}`).

The pipeline handles this in two steps:

1. **Relationship target nodes**: For each `is_implementation` target that is not defined in the current SCIP file (cross-module), the pipeline creates an external type node. This covers JDK super-types (e.g., `java/io/Serializable#`), external library interfaces, and project types from other modules that are inherited but never explicitly referenced as occurrences.

2. **Relationship edges**: `DEPENDS_ON` edges are created for all `is_implementation` relationships, including cross-module targets. The edge references the external node created in step 1.

This ensures that inheritance and interface-implementation edges are captured in the graph even when the SCIP indices span multiple modules with differing version strings.

### Shadow External Type Nodes

As a side effect, cross-module references (from both occurrences and `is_implementation` relationships) create **shadow ExternalType nodes** alongside the InternalType nodes from the defining module. For example, `DescribableComponent` appears both as:
- `maven/org.axonframework/axon-common ${revision} org/.../DescribableComponent#` — InternalType (from common module)
- `maven/org.axonframework/axon-common 5.1.1 org/.../DescribableComponent#` — ExternalType shadow (from consuming module)

Edges from consuming modules point to the ExternalType shadow, which excludes them from queries that filter on `SemanticCodeIndexInternalType` for both source and target.

To resolve this, run the two enrichment queries in order after import:
1. `Redirect_SCIP_Shadow_Type_Edges_To_Internal.cypher` — redirects edges from shadow to InternalType
2. `Delete_SCIP_Shadow_External_Types.cypher` — removes the now-orphaned shadow nodes

These queries match ExternalType and InternalType nodes by their **type descriptor** (the fully-qualified path, e.g., `org/axonframework/common/infra/DescribableComponent#`), which is unique within a project.

## Git Integration

SCIP File nodes created during import are automatically linked to Git history when both SCIP indices and git logs are present in the same analysis.

### How It Works

1. **SCIP File Node Creation**: `Create_SCIP_File_Nodes.cypher` extracts unique file paths from type nodes and creates `:SCIP:File` nodes (one per unique source file path across all internal types)
2. **Source File Linking**: `Link_SCIP_Type_SOURCE_FILE_SCIP_File.cypher` creates `SOURCE_FILE` edges from types to their source files
3. **Git Resolution**: `Add_RESOLVES_TO_relationships_to_git_files_for_SCIP.cypher` (executed by git-history domain) matches SCIP file paths to Git file nodes via `RESOLVES_TO` edges

### Data Model

```
Git:Repository
  -[:HAS_FILE]-> Git:File (from git log)
                  -[:RESOLVES_TO]-> SCIP:File
                                    <-[:SOURCE_FILE]- SemanticCodeIndexInternalType
```

### Use Cases

- **Enrichment**: Link SCIP type dependencies to git commit history
- **Change Analysis**: Track which source files changed together (git) and their type dependencies (SCIP)
- **Blame & Impact**: Combine git author/commit metadata with SCIP dependency graphs
- **Verification**: Validate that git repo files match SCIP-analyzed source structure

### Language Independence

The SCIP file integration is **language-agnostic** — same query handles all SCIP-supported languages (Java, TypeScript, Go, Rust, C++, Python, Ruby, C#). No per-language variants needed; matching is based on relative file paths only.

## Import Phases

`importScipIndexData.sh` runs in four phases via `queries/`:

**1. Import** — Cleans existing SCIP nodes, creates uniqueness constraints, then imports type nodes, external type nodes, function nodes, and their `DEPENDS_ON` edges from CSV.

**2. Structure** — Creates `SCIP:File`, `SemanticCodeIndexModule`, and `SemanticCodeIndexArtifact` nodes; builds `CONTAINS` hierarchies and `DEPENDS_ON` links at module and artifact level. Module dependencies aggregate from both type-level and function-level edges.

**3. Enrichment** — Sets dependency count properties, test markers, project names, and the `:SemanticCodeIndexInternalSymbol` unified label on all internal types and functions.

**4. Dependency Metrics** (shared `cypher/Dependency_Enrichment/`) — Sets dependency degree and percentile rank.

## Graph Model

### Nodes

| Label | Description |
|-------|-------------|
| `SCIP:SemanticCodeIndexInternalType` | Type from own source code; has `isTest`, `file`, `descriptor` |
| `SCIP:SemanticCodeIndexFunction` | Module-level function from own source code; has `isTest`, `file`, `descriptor` |
| `SemanticCodeIndexInternalSymbol` | Unified label on `SemanticCodeIndexInternalType` and `SemanticCodeIndexFunction` — use for queries spanning both |
| `SCIP:SemanticCodeIndexExternalType` | Type from an external library; `isTest = false` |
| `SCIP:SemanticCodeIndexModule` | Source directory; has `isTest`, `testMarkerInteger` |
| `SCIP:SemanticCodeIndexArtifact` | Module + version package; groups types and modules |

### Relationships

| Relationship | From → To | Description |
|--------------|-----------|-------------|
| `DEPENDS_ON` | `SemanticCodeIndexInternalType|SemanticCodeIndexExternalType → SemanticCodeIndexInternalType|SemanticCodeIndexExternalType` | Type-level dependency; `referenceCount` |
| `DEPENDS_ON` | `SemanticCodeIndexFunction → SemanticCodeIndexInternalSymbol|SemanticCodeIndexExternalType` | Function-level dependency; `referenceCount`, `via` (`uses_type`, `calls_function`, `calls_method`) |
| `CONTAINS` | `SemanticCodeIndexModule → SemanticCodeIndexInternalSymbol` | Module contains its source types and functions |
| `CONTAINS` | `SemanticCodeIndexArtifact → SemanticCodeIndexModule` | Artifact contains its modules |
| `CONTAINS` | `SemanticCodeIndexArtifact → SemanticCodeIndexExternalType` | Artifact contains its external types |

### Key Properties

| Property | Nodes | Description |
|----------|-------|-------------|
| `isTest` | `SemanticCodeIndexInternalType`, `SemanticCodeIndexFunction`, `SemanticCodeIndexModule` | `true` if the node is part of test code |
| `testMarkerInteger` | `SemanticCodeIndexInternalType`, `SemanticCodeIndexFunction`, `SemanticCodeIndexExternalType`, `SemanticCodeIndexModule` | `1` if `isTest`, `0` otherwise — used for graph projections |
| `language` | `SemanticCodeIndexInternalType`, `SemanticCodeIndexFunction`, `SemanticCodeIndexExternalType` | Detected language (e.g. `Java`, `TypeScript`, `Go`) |
| `descriptor` | `SemanticCodeIndexInternalType`, `SemanticCodeIndexFunction`, `SemanticCodeIndexExternalType` | Pre-computed SCIP descriptor — last space-separated token of `symbol` (e.g. `com/example/Foo#`, `lib/nav.ts/getRoute().`). Empty for `File` and `AnonymousClass` nodes. Enables indexed lookup. |
| `incomingDependencies` | `SCIPType` | Number of types that depend on this type |
| `outgoingDependencies` | `SCIPType` | Number of types this type depends on |
| `incomingDependencies` | `SCIPModule` | **COUNT** of symbol-level DEPENDS_ON edges into symbols (types and functions) in this module |
| `incomingDependenciesWeight` | `SCIPModule` | **SUM** of `referenceCount` from those edges (edge magnitude) |
| `outgoingDependencies` | `SCIPModule` | **COUNT** of symbol-level DEPENDS_ON edges from symbols (types and functions) in this module |
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
