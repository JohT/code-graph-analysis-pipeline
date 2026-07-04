# Plan: Integrate `scip-index-import` into Pipeline

## TL;DR
Integrate `domains/scip-index-import` as an on-by-default pipeline step in `analyze.sh`, triggered conditionally when `indices/` contains `*.scip.json` files. Adapt the `create-type-graph-csv.sh` conversion script, extend three domains (archetypes, cyclic-deps, external-deps) with SCIP node support, add a React Router SCIP example, update GitHub Actions, and document everything in a new `SCIP.md`.

**Decisions captured:**
- Folder name: `indices` (not `indizes` — typo in original prompt)
- Multi-file: support from the start via awk-based CSV merge (deduplicate nodes, sum edge reference_count)
- Example: new standalone `scripts/examples/analyzeReactRouterScip.sh` with pre-generated SCIP JSON files
- Documentation: new `SCIP.md` file documenting user workflow for generating SCIP indices externally
- `scip` CLI: **NOT required in pipeline** — user provides pre-converted `.scip.json` files
- Correct SCIP node labels: `:SCIP:SemanticCodeIndexType:InternalType` / `:SCIP:SemanticCodeIndexType:ExternalType` (prompt had a typo: "SemanticIndexType")
- **Fail-Fast Principle**: validate inputs early, reject non-JSON files in `indices/`, fail immediately with clear errors

---

## Phase 1: CSV Conversion Scripts (new, in `domains/scip-index-import/`)

**Depends on nothing. Start here.**

1. **New `domains/scip-index-import/convertScipIndexToCsvForNeo4jImport.sh`**
   - Adapted from `/Users/johnny/Repositories/git/getting-started-with-scip/type-graph/create-type-graph-csv.sh`
   - Follow shell-scripts.instructions.md: `set -o errexit -o pipefail -o nounset`, `IFS=$'\n\t'`, usage(), braces+quotes
   - **Fail-fast validation (early in script):**
     - Check `jq` in PATH (fail immediately with install hint if missing)
     - Check `INDICES_DIRECTORY` exists (fail if not found)
     - Check for non-JSON files in `INDICES_DIRECTORY`: if any `.scip` binary or other files found, fail with clear message: "Only .scip.json files are supported. Found: [list]. Remove them or use a clean indices/ directory."
     - Check at least one `*.scip.json` file found (fail if none)
   - Inputs: `INDICES_DIRECTORY` (env, defaults to `./indices`), `IMPORT_DIRECTORY` (env, defaults to `./import`)
   - For each `*.scip.json` in `INDICES_DIRECTORY`: run jq logic → temp node/edge CSVs
   - Merge nodes: concatenate all per-file node CSVs, keep header once, dedup by `symbol` (sort -u)
   - Merge edges: awk group by `(source_symbol, target_symbol)`, sum `reference_count`
   - Write merged CSVs to `${IMPORT_DIRECTORY}/scip_type_nodes.csv` and `${IMPORT_DIRECTORY}/scip_type_edges.csv`

2. **Modified `domains/scip-index-import/importScipIndexData.sh`**
   - Add call to `convertScipIndexToCsvForNeo4jImport.sh` at the start (before Cypher phase 1)
   - Pass `INDICES_DIRECTORY` and `IMPORT_DIRECTORY`

3. **New `domains/scip-index-import/testConvertScipIndexToCsvForNeo4jImport.sh`**
   - Adapted from `/Users/johnny/Repositories/git/getting-started-with-scip/type-graph/create-type-graph-csv-test.sh`
   - Tests: prerequisite validation, non-JSON file rejection, node CSV columns, edge CSV columns, multi-file merge (dedup nodes, sum edges)
   - Prefix convention: test scripts named `test*.sh`

---

## Phase 2: Pipeline Integration

**Depends on Phase 1 (convertScipIndexToCsvForNeo4jImport.sh).**

### Fail-Fast Principle (Applied Throughout)

- **Early validation**: All scripts check prerequisites and inputs at the start, before any processing
- **Clear error messages**: Errors include: what failed, why it failed, what to do next
- **No silent failures**: If indices/ contains unexpected files, fail immediately, don't attempt conversion
- **Validate before commit**: Each domain extension validates SCIP node structure exists before running queries

4. **Modified `scripts/analysis/analyze.sh`**
   - Add `INDICES_DIRECTORY=${INDICES_DIRECTORY:-"indices"}` (next to ARTIFACTS_DIRECTORY/SOURCE_DIRECTORY)
   - Update `usage()` to mention `INDICES_DIRECTORY` and clarify it must contain `.scip.json` files
   - **Fail-fast check**: before checking for artifacts/source, validate `INDICES_DIRECTORY` if it exists:
     - If directory exists and contains any files, ensure they are all `.scip.json`
     - If non-JSON files found, fail with clear error message listing them
   - Update "nothing to analyze" check to also accept non-empty `indices/`:
     ```bash
     if [ ! -d "${ARTIFACTS_DIRECTORY}" ] && [ ! -d "${SOURCE_DIRECTORY}" ] && \
        [ -z "$(find "${INDICES_DIRECTORY:-indices}" -name '*.scip.json' -maxdepth 1 2>/dev/null | head -1)" ]; then
     ```
   - After `resetAndScanChanged.sh` block, before `prepareAnalysis.sh` block, add conditional SCIP import:
     ```bash
     # Import SCIP index data if indices/ is non-empty and domain is not excluded
     if [ -d "${INDICES_DIRECTORY}" ] && [ -n "$(find "${INDICES_DIRECTORY}" -name '*.scip.json' -maxdepth 1 2>/dev/null | head -1)" ]; then
       if [[ ",${ANALYSIS_DOMAINS_TO_SKIP}," != *",scip-index-import,"* ]]; then
         echo "${LOG_GROUP_START}Import SCIP Index Data"
         source "${DOMAINS_DIRECTORY}/scip-index-import/importScipIndexData.sh"
         echo "${LOG_GROUP_END}"
       else
         echo "analyze: Skipping scip-index-import (domain excluded via ANALYSIS_DOMAINS_TO_SKIP)."
       fi
     fi
     ```
   - Export `INDICES_DIRECTORY` so child scripts can inherit it
   - Update `--exclude-domain` usage example to mention `scip-index-import`

5. **Modified `init.sh`**
   - Add `INDICES_DIRECTORY=${INDICES_DIRECTORY:-"indices"}` (next to ARTIFACTS_DIRECTORY/SOURCE_DIRECTORY)
   - Add `mkdir -p "./${INDICES_DIRECTORY}"` after source dir creation
   - Update "Next steps" output to guide user to place `.scip.json` files in `indices/`:
     ```
     (3) (Optional) Place your SCIP index files (.scip.json) into this directory:
            $(pwd)/${INDICES_DIRECTORY}
         To learn how to generate SCIP index files, see SCIP.md
     ```

---

## Phase 3: Domain Extensions + Orphan Cleanup

**Depends on Phase 1 (SCIP data structures must be understood). Can run parallel with Phase 2.**

### 3a: Orphan cleanup — `domains/scip-index-import/`

6. The `queries/` root level contains DUPLICATE flat files (older versions of the structured `import/`, `enrichment/`, `structure/` subdirectories). Delete:
   - All `.cypher` files at `domains/scip-index-import/queries/*.cypher` (the flat duplicates; NOT the subdirectory files)
   - These are: `Cleanup_SCIP_Type_Nodes.cypher`, `Create_SCIP_Artifact_Nodes.cypher`, etc. at root `queries/` level

7. Move `domains/scip-index-import/queries/analysis/Cyclic_SCIP_Type_Dependencies.cypher`
   → `domains/cyclic-dependencies/queries/Cyclic_SCIP_Type_Dependencies.cypher`

8. Move `domains/scip-index-import/queries/analysis/External_SCIP_Type_Package_Usage_Overall.cypher`
   → `domains/external-dependencies/queries/External_SCIP_Type_Package_Usage_Overall.cypher`

9. Delete now-empty `domains/scip-index-import/queries/analysis/` directory

### 3b: archetypes domain

10. **New `domains/archetypes/features/ArchetypeFeature_Abstractness_Scip.cypher`**
    - Pattern: mirror `ArchetypeFeature_Abstractness_JavaType.cypher` (uses `javaCodeUnit:Interface`, `javaCodeUnit.abstract`)
    - For SCIP: use `typeName` property — `'Interface' → 1.0`, `'AbstractClass' → 0.7`, else `0.0`

11. **Modified `domains/archetypes/archetypesCsv.sh`**
    - In `archetype_features()`, add abstractness call for SCIP after the TypeScript one:
      ```bash
      execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                           "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_Scip.cypher" "${@}"
      ```
    - After the existing node-type archetype_features() calls, add an InternalType call:
      - projection_name=`scip-type-archetypes`
      - projection_node_label=`InternalType`
      - projection_weight_property=`referenceCount`
      - Output dir: `${REPORTS_DIRECTORY}/archetypes/Scip_Type/`

### 3c: cyclic-dependencies domain

12. **Modified `domains/cyclic-dependencies/cyclicDependenciesCsv.sh`**
    - Add `mkdir -p "${FULL_REPORT_DIRECTORY}/Scip_Module"`
    - Execute `Cyclic_SCIP_Type_Dependencies.cypher` (moved from scip-index-import analysis/) → CSV in `Scip_Module/`
    - Pattern: mirror existing TypeScript section

### 3d: external-dependencies domain

13. **Modified `domains/external-dependencies/externalDependenciesCsv.sh`**
    - Add `mkdir -p "${FULL_REPORT_DIRECTORY}/Scip"`
    - Execute `External_SCIP_Type_Package_Usage_Overall.cypher` → CSV in `Scip/`
    - Pattern: mirror existing TypeScript query execution section

---

## Phase 4: React Router SCIP Example

**Depends on Phase 1 (convertScipIndexToCsvForNeo4jImport.sh, validation logic).**

14. **New `scripts/examples/analyzeReactRouterScip.sh`**
    - Structure mirrors `analyzeReactRouter.sh`
    - Accepts version as first param (auto-detects latest if omitted via `detectLatestGitTag.sh`)
    - Calls `./init.sh "react-router-scip-${projectVersion}"`
    - Changes to workspace dir `temp/react-router-scip-${projectVersion}`
    - **Key difference from standard example**: Instead of downloading source and scanning with jQAssistant, it expects pre-generated SCIP JSON index files to be provided
    - **Two options for user**:
      - **Option A (Turnkey)**: The script downloads react-router source + generates SCIP index using helper functions (see SCIP.md for prerequisites)
      - **Option B (Index-only)**: User provides pre-generated `react-router-X.X.X.scip.json` in workspace, script skips generation
    - Script includes fail-fast checks: validate JSON files exist, validate they parse as valid JSON
    - Calls `analyze.sh "${@}"`
    - **Note**: This example may require external tools (Node.js, scip CLI, scip-typescript) if user chooses Option A. Document this clearly.

---

## Phase 5: GitHub Actions

**Depends on Phase 2 (indices/ dir). Parallel with Phases 3-4.**

15. **Modified `.github/workflows/public-analyze-code-graph.yml`**
    - New input (add near `sources-upload-name`):
      ```yaml
      indices-upload-name:
        description: 'Name of a previously uploaded artifact containing *.scip.json files to place in indices/ before analysis.'
        type: string
        required: false
        default: ''
      ```
    - New validation (fail-fast): if `indices-upload-name` is provided, validate the artifact name is not empty
    - New download step (after source/artifact steps):
      ```yaml
      - name: Download SCIP index files
        if: inputs.indices-upload-name != ''
        uses: actions/download-artifact@v4
        with:
          name: ${{ inputs.indices-upload-name }}
          path: temp/${{ inputs.analysis-name }}/indices
      ```
    - Validation step: after download, verify files end with `.scip.json` (fail if not)
    - Update the "at least one input required" validation to include `indices-upload-name`

16. **New `.github/workflows/internal-scip-index-code-example.yml`**
    - Pattern: `internal-typescript-upload-code-example.yml`
    - `paths-ignore`: same as typescript upload example
    - Job 1: `prepare-scip-index`
      - **Fail-fast**: Check Node.js and scip-typescript tool availability early
      - Checkout react-router (specific version, e.g. latest)
      - Set up pnpm and Node.js
      - `pnpm install --frozen-lockfile`
      - Install `@sourcegraph/scip-typescript` 
      - `./node_modules/.bin/scip-typescript index` → `index.scip`
      - **Validation**: Verify `index.scip` was created before proceeding
      - `scip print --json index.scip > index.scip.json` (or provide pre-generated JSON if scip CLI not available)
      - **Validation**: Verify output is valid JSON before uploading
      - Upload `index.scip.json` as artifact (retention 1 day)
    - Job 2: `analyze-code-graph`
      - Calls `public-analyze-code-graph.yml`
      - Inputs: `analysis-name`, `indices-upload-name` (from job 1 output), `sources-upload-name` (react-router source also uploaded, for validation purposes)
      - Uses `--profile Neo4j-latest-low-memory` or appropriate profile
      - Report: `Csv` only (fast smoke test)
      - No domain restriction — lets default exclusions apply (scip-index-import NOT excluded by default)

---

## Phase 6: Documentation

**Depends on all other phases being designed. Can write in parallel.**

17. **New `SCIP.md`**
    - What SCIP is + why it vastly expands language support (Go, Java, TypeScript, Rust, C++, Ruby, Python, C#)
    - **User workflow** (outside this pipeline):
      1. Install language-specific SCIP indexer (e.g., scip-typescript, scip-java)
      2. Generate SCIP binary index: `scip-typescript index` → `index.scip`
      3. Convert to JSON: `scip print --json index.scip > index.scip.json`
      4. Place `.scip.json` file(s) in `indices/` folder
      5. Run `analyze.sh` — pipeline automatically imports SCIP data
    - **Supported languages**: Go, Java, TypeScript, Rust, C++, Ruby, Python, C# (via SCIP indexers)
    - **TypeScript setup example**: `npm install @sourcegraph/scip-typescript`, run `scip-typescript index`, run `scip print --json`
    - **Install `scip` CLI**: link to https://github.com/sourcegraph/scip releases (required for JSON conversion)
    - **Other languages**: links to scip-java, scip-go, rust-analyzer, etc.
    - **Troubleshooting**: common errors (missing scip CLI, invalid JSON, file format), validation checks performed by pipeline
    - Reference `scripts/examples/analyzeReactRouterScip.sh` as optional end-to-end example

18. **Modified `README.md`**
    - Add to main feature list: "Multi-language analysis via SCIP (Go, Rust, C++, Ruby, Python, C# + more) — see [SCIP.md](SCIP.md)"
    - Add `indices/` to workspace directory description (alongside `artifacts/` and `source/`)
    - Link to SCIP.md for setup details

19. **Modified `ENVIRONMENT_VARIABLES.md`**
    - Add `INDICES_DIRECTORY` entry (default: `indices`, used by `analyze.sh` and `init.sh`)

20. **Modified `SCRIPTS.md`** (generated — update per instructions in generated-reference-docs.instructions.md)
    - Add new scripts: `convertScipIndexToCsvForNeo4jImport.sh`, `testConvertScipIndexToCsvForNeo4jImport.sh`, `analyzeReactRouterScip.sh`

21. **Modified `CYPHER.md`** (generated — update per instructions)
    - Add moved/new queries in cyclic-deps and external-deps
    - Remove orphaned scip-index-import analysis queries

22. **Modified `domains/scip-index-import/README.md`**
    - Explain user provides pre-converted JSON files
    - Describe `indices/` input folder
    - List required tools: `jq` (for CSV conversion), `scip` CLI (for user to generate JSON outside pipeline)

---

## Relevant Files

**New files:**
- `domains/scip-index-import/convertScipIndexToCsvForNeo4jImport.sh` — converts pre-generated `.scip.json` files to Neo4j import CSVs
- `domains/scip-index-import/testConvertScipIndexToCsvForNeo4jImport.sh`
- `domains/archetypes/features/ArchetypeFeature_Abstractness_Scip.cypher`
- `scripts/examples/analyzeReactRouterScip.sh` — example using pre-generated SCIP JSON
- `.github/workflows/internal-scip-index-code-example.yml` — CI smoke-test using pre-generated SCIP JSON
- `SCIP.md` — user guide for external SCIP index generation workflow

**Modified files:**
- `domains/scip-index-import/importScipIndexData.sh` — add call to convertScipIndexToCsvForNeo4jImport.sh
- `scripts/analysis/analyze.sh` — add indices/ support, fail-fast validation for non-JSON files
- `init.sh` — create indices/ directory, update guidance
- `domains/archetypes/archetypesCsv.sh` — add InternalType support
- `domains/cyclic-dependencies/cyclicDependenciesCsv.sh` — add SCIP module queries
- `domains/external-dependencies/externalDependenciesCsv.sh` — add SCIP external type queries
- `.github/workflows/public-analyze-code-graph.yml` — add indices-upload-name input, validation
- `README.md` — add to features, explain indices/ workflow, link to SCIP.md
- `ENVIRONMENT_VARIABLES.md` — add INDICES_DIRECTORY entry
- `SCRIPTS.md` — add convertScipIndexToCsvForNeo4jImport.sh, analyzeReactRouterScip.sh (generated docs)
- `CYPHER.md` — update with moved/new queries (generated docs)
- `domains/scip-index-import/README.md` — explain user provides pre-converted JSON files

**Moved files (source → dest):**
- `domains/scip-index-import/queries/analysis/Cyclic_SCIP_Type_Dependencies.cypher` → `domains/cyclic-dependencies/queries/`
- `domains/scip-index-import/queries/analysis/External_SCIP_Type_Package_Usage_Overall.cypher` → `domains/external-dependencies/queries/`

**Deleted files:**
- `domains/scip-index-import/queries/*.cypher` (root-level flat duplicates — 17 files)
- `domains/scip-index-import/queries/analysis/` directory (empty after moves)

**Reference sources (external, read-only):**
- `/Users/johnny/Repositories/git/getting-started-with-scip/type-graph/create-type-graph-csv.sh` — basis for convertScipIndexToCsvForNeo4jImport.sh
- `/Users/johnny/Repositories/git/getting-started-with-scip/type-graph/create-type-graph-csv-test.sh` — basis for testConvertScipIndexToCsvForNeo4jImport.sh
- `/Users/johnny/Repositories/git/getting-started-with-scip/` — referenced in SCIP.md for user guidance on generating indices externally

**Key patterns to reference:**
- `domains/graph-algorithms/` — how InternalType was added to projections (commit ec578293)
- `domains/archetypes/features/ArchetypeFeature_Abstractness_JavaType.cypher` — abstractness query pattern
- `domains/cyclic-dependencies/cyclicDependenciesCsv.sh` — TypeScript section as template for SCIP section
- `scripts/examples/analyzeReactRouter.sh` — template for new SCIP example script
- `.github/workflows/internal-typescript-upload-code-example.yml` — template for new internal workflow

---

## Verification

1. `shellcheck` on all new/modified `.sh` files
2. `analyze.sh --help` — verify INDICES_DIRECTORY in env vars section
3. `init.sh test-scip` — verify `indices/` directory created
4. `./domains/scip-index-import/testConvertScipIndexToCsvForNeo4jImport.sh` — all assertions pass
5. Place a `*.scip.json` in `indices/`, run `analyze.sh --keep-running` — verify SCIP import runs before reports
6. Run `analyze.sh --exclude-domain scip-index-import` with file in `indices/` — verify import is skipped
7. Run cyclic-deps domain: `analyze.sh --domain cyclic-dependencies --report Csv` — verify `Scip_Module/` CSV generated
8. Run external-deps domain: `analyze.sh --domain external-dependencies --report Csv` — verify `Scip/` CSV generated
9. Run `scripts/examples/analyzeReactRouterScip.sh` — end-to-end example works
10. `npx markdown-link-check SCIP.md README.md` — all links valid
11. GitHub Actions: new `internal-scip-index-code-example.yml` workflow passes

---

## Further Considerations

1. **SCIP-only runs (no artifacts/source)**: The updated "nothing to scan" check in `analyze.sh` handles this. `resetAndScanChanged.sh`/jQAssistant will scan empty dirs and produce an empty graph — only SCIP data will exist. This is intentional and supported (useful for analyzing pre-indexed code without source).

2. **Non-JSON file validation**: The pipeline must catch and reject `.scip` binary files (or any non-JSON) in `indices/` immediately, with a clear message telling the user to convert them or remove them. This fail-fast approach prevents confusing errors later in processing.

3. **`archetypesCsv.sh` InternalType call**: The `archetype_features()` function accepts `projection_node_label` and `projection_weight_property`. For `InternalType` with `referenceCount`, verify `createDirectedDependencyProjection` in `projectionFunctions.sh` handles it without special-casing. If not, add a new `createDirectedSCIPInternalTypeDependencyProjection()` function.

4. **GitHub Actions**: The CI workflow (`internal-scip-index-code-example.yml`) may need pre-generated SCIP JSON files committed to the repo (or uploaded as artifacts in job 1). Ensure the workflow doesn't require the `scip` CLI unless the user explicitly wants to generate indices (outside the pipeline).

5. **Instruction compliance**: Implementer must follow `.github/copilot-instructions.md` (shell-scripts.instructions.md rules: strict mode, IFS, usage(), braces+quotes, no eval, named functions, fail-fast checks first, clear error messages).
