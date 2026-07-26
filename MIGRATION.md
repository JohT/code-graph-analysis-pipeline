# Migration Guide

This document describes breaking changes introduced in each major version and how to migrate your analysis workspace.

---

## Migrating to v5.0.0

v5 introduces several breaking changes, particularly around path-finding queries, report naming conventions, SCIP index support enhancements, and Python version requirements. The sections below describe each breaking change and the steps to migrate.

---

### 1. Path Finding query output column changes

**What changed (Commit [4cf08f8f9](https://github.com/JohT/code-graph-analysis-pipeline/commit/4cf08f8f9), [2a06f18a2](https://github.com/JohT/code-graph-analysis-pipeline/commit/2a06f18a2), [11b193dc4](https://github.com/JohT/code-graph-analysis-pipeline/commit/11b193dc4)):**

The Path Finding queries have been refactored to simplify the returned columns and add support for SCIP indices. The following changes affect CSV report output:

#### Path_Finding_5_All_pairs_shortest_path_examples.cypher

| Before | After |
|--------|-------|
| Columns: `distance`, `sourceContainerName`, `sourceProject`, `sourceScan`, `path` | Columns: `distance`, `sourceContainerName`, `source.projectName`, `path` |
| Queries optional project/scan nodes | Uses direct property access only |

#### Path_Finding_6_Longest_paths_examples.cypher

| Before | After |
|--------|-------|
| Columns: `distance`, `index`, `sourceContainerName`, `sourceProject`, `sourceScan`, `path` | Columns: `distance`, `index`, `sourceContainerName`, `source.projectName`, `path` |
| Queries optional project/scan nodes | Uses direct property access only |

Additionally, path finding algorithms now use **strongly connected components** to untangle cycles before computing longest paths, which may result in different path results for cyclic dependencies.

**Migration steps:**

1. **Update CSV consumers:** If you parse `Path_Finding_5_*.csv` or `Path_Finding_6_*.csv` reports:
   - Rename column references from `sourceProject` to `source.projectName`
   - Remove any references to the `sourceScan` column (no longer present)
   - Update any downstream dashboards or aggregations accordingly

2. **Update Cypher queries:** If you've extended or customized these path-finding queries:
   - Remove `OPTIONAL MATCH` clauses querying `(sourceProject:Artifact|Project)-[:CONTAINS]->(source)` and `(sourceScan:TS:Scan)-[:CONTAINS_PROJECT]->(sourceProject)`
   - Replace with direct property access: `coalesce(source.rootProjectName, source.projectName, source.name)`

3. **Validate path results:** Run path-finding reports and validate that longest paths are consistent with your expectations. The inclusion of strongly connected component detection may surface new or different cycles.

---

### 2. Node Embeddings FastRP report name correction

**What changed (Commit [5b25bcf01](https://github.com/JohT/code-graph-analysis-pipeline/commit/5b25bcf01)):**

The FastRP (Fast Random Projection) embedding report filename was corrected from a typo:

| Before | After |
|--------|-------|
| `<NodeLabel>_Embeddings_Label_Random_Projection.csv` | `<NodeLabel>_Embeddings_Fast_Random_Projection.csv` |

**Migration steps:**

1. **Update report consumers:** Update any scripts, dashboards, or CI jobs that read or archive embedding reports:
   - Search for references to `*_Label_Random_Projection.csv`
   - Replace with `*_Fast_Random_Projection.csv`

2. **Update archival/publishing:** If you publish embedding reports to external systems:
   - Update file paths and naming patterns accordingly

---

### 3. Git history: New CHANGED_TOGETHER_WITH relationships

**What changed (Commit [d451a21cf](https://github.com/JohT/code-graph-analysis-pipeline/commit/d451a21cf)):**

Git log import now creates `CHANGED_TOGETHER_WITH` relationships between file nodes that were modified in the same commit. This enables new analysis capabilities for co-change patterns.

**New Neo4j relationship:**

- `(file1:File)-[:CHANGED_TOGETHER_WITH]->(file2:File)` — created when both files are changed in the same commit

**Migration steps:**

1. **Update custom git history queries:** If you query git log data:
   - Consider leveraging the new `CHANGED_TOGETHER_WITH` relationship for co-change analysis
   - Existing queries are not affected and will continue to work

2. **New analysis opportunities:**
   - Identify files that frequently change together
   - Find co-change patterns that may indicate tight coupling
   - See [domains/git-history/README.md](./domains/git-history/README.md) for example usage

---

## Summary of v5.0.0 Breaking Changes

| Area | Breaking Change | Impact | Migration Effort |
|------|-----------------|--------|------------------|
| Path Finding Queries | Output columns changed | CSV column names differ | Medium |
| FastRP Embeddings | Filename corrected | Report filename changed | Low |
| Git History | New CHANGED_TOGETHER_WITH relationships | Enhanced data model | Low (backward compatible) |

For assistance, see [GETTING_STARTED.md](./GETTING_STARTED.md), [COMMANDS.md](./COMMANDS.md), or check the relevant domain READMEs.

---

## Migrating to v4.0.0

v4 is a major release that reorganizes the pipeline into vertical-slice domains and removes several legacy features. The sections below describe each breaking change and the steps to migrate.

---

### 1. Python package manager: `venv` replaced by `uv`

**What changed (PR [#584](https://github.com/JohT/code-graph-analysis-pipeline/pull/584)):**

| Before | After |
|--------|-------|
| `requirements.txt` | `pyproject.toml` + `uv.lock` |
| `scripts/activatePythonEnvironment.sh` | `scripts/activateUvEnvironment.sh` |
| `USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV=true` | `PYTHON_PACKAGE_MANAGER=uv` (default) |
| `PYTHON_ENVIRONMENT_FILE=<path>` | removed |

**Migration steps:**

1. **Default (uv):** Install `uv` if not already present: <https://docs.astral.sh/uv/getting-started/installation/>. Once installed, no further action is needed — `uv` is the new default.
2. **conda users:** Set `PYTHON_PACKAGE_MANAGER=conda` in your environment or pass it to `analyze.sh`.
3. **GitHub Actions:** Remove or replace `use-venv_virtual_python_environment: true` — `uv` is now the default, so you can simply omit the input, or set it explicitly:

   ```yaml
   python-package-manager: 'uv'
   ```

   Former conda users (previously relying on `use-venv_virtual_python_environment: false`) must now set:

   ```yaml
   python-package-manager: 'conda'
   ```

4. **Custom scripts** that source `scripts/activatePythonEnvironment.sh` must be updated to source `scripts/activateUvEnvironment.sh` instead.
5. Remove any reference to `USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV` and `PYTHON_ENVIRONMENT_FILE` from your environment configuration.

---

### 2. Jupyter pipeline removed

**What changed (PR [#577](https://github.com/JohT/code-graph-analysis-pipeline/pull/577)):**

- `--report Jupyter` is no longer a valid report type.
- `scripts/reports/compilations/JupyterReports.sh` is deleted.
- `scripts/executeJupyterNotebook.sh` and `scripts/executeJupyterNotebookReport.sh` are deleted.
- Environment variables `ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION` and `JUPYTER_NOTEBOOK_DIRECTORY` are removed.
- GitHub Actions public workflow input `jupyter-pdf` is removed.
- Chromium headless browser is no longer required.
- The 25 `explore/*.ipynb` notebooks remain available for **interactive local use only** and are not executed by the pipeline.

**Migration steps:**

1. Remove any invocation of `analyze.sh --report Jupyter` from your scripts or CI configuration.
2. Remove `ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION` and `JUPYTER_NOTEBOOK_DIRECTORY` from your environment.
3. Remove `jupyter-pdf` from your GitHub Actions workflow inputs.
4. Uninstall Chromium if it was only installed for PDF generation.

---

### 3. Output directory changes

Several report output directories have been renamed as part of the domain reorganization.

#### 3a. Internal dependencies (PR [#552](https://github.com/JohT/code-graph-analysis-pipeline/pull/552))

| Before | After |
|--------|-------|
| `reports/internal-dependencies-csv/` | `reports/internal-dependencies/<scope>/` |
| `reports/path-finding-csv/` | `reports/internal-dependencies/<scope>/` |
| `reports/topology-csv/` | `reports/internal-dependencies/<scope>/` |
| `reports/internal-dependencies-visualization/` | `reports/internal-dependencies/<scope>/Graph_Visualizations/` |
| `reports/path-finding-visualization/` | `reports/internal-dependencies/<scope>/Graph_Visualizations/` |

`<scope>` is one of: `Java_Artifact`, `Java_Package`, `Java_Type`, `Typescript_Module`, `NPM_NonDevPackage`, `NPM_DevPackage`.

#### 3b. Git history (PR [#559](https://github.com/JohT/code-graph-analysis-pipeline/pull/559))

| Before | After |
|--------|-------|
| `reports/git-history-csv/` | `reports/git-history/` |

#### 3c. Java (PR [#568](https://github.com/JohT/code-graph-analysis-pipeline/pull/568))

| Before | After |
|--------|-------|
| `reports/java-csv/` | `reports/java/` |
| `reports/artifact-dependencies-csv/` | `reports/java/` |

#### 3d. Cyclic dependencies (PR [#581](https://github.com/JohT/code-graph-analysis-pipeline/pull/581))

| Before | After |
|--------|-------|
| `reports/internal-dependencies/<scope>/Cyclic_Dependencies*.csv` | `reports/cyclic-dependencies/<scope>/` |

**Migration steps:**

1. Update any downstream consumers (CI jobs, dashboards, archival scripts) that reference the old output paths.
2. The old directories are no longer created. If you archive or publish reports, update the source paths accordingly.

---

### 4. Three compute-intensive domains deactivated by default

**What changed (PR [#586](https://github.com/JohT/code-graph-analysis-pipeline/pull/586)):**

To reduce baseline analysis time, three domains are now **skipped by default**:

- `anomaly-detection` (machine learning model training)
- `node-embeddings` (graph embedding generation)
- `graph-algorithms` (community detection, centrality algorithms)

When running `analyze.sh` without `--domain`, these domains are automatically excluded. The remaining seven analysis domains (overview, external-dependencies, internal-dependencies, cyclic-dependencies, java, git-history, archetypes) and the neo4j-management support domain run normally.

**Migration steps:**

1. **To include all domains:** Pass `--exclude-domain ""`:

   ```shell
   analyze.sh --exclude-domain ""
   ```

2. **To include only compute-intensive domains:** Use `--domain`:

   ```shell
   analyze.sh --domain anomaly-detection --keep-running
   analyze.sh --domain node-embeddings --keep-running
   analyze.sh --domain graph-algorithms --keep-running
   ```

3. **To customize exclusions:** List specific domains to skip:

   ```shell
   analyze.sh --exclude-domain "node-embeddings,graph-algorithms"
   ```

4. **In GitHub Actions:** The public workflow now accepts `run-all-domains: true` to include all domains by default:

   ```yaml
   run-all-domains: true
   ```

---

### 5. Cyclic dependencies split into its own domain

**What changed (PR [#581](https://github.com/JohT/code-graph-analysis-pipeline/pull/581)):**

- A new `domains/cyclic-dependencies/` domain now owns all cyclic dependency analysis.
- Cyclic dependency Cypher queries moved from `domains/internal-dependencies/queries/cyclic-dependencies/` to `domains/cyclic-dependencies/queries/`.
- The `internal-dependencies` report no longer includes a "Cyclic Dependencies" section.
- Output CSV files for cyclic dependency results are now written to `reports/cyclic-dependencies/<scope>/` instead of `reports/internal-dependencies/<scope>/`.

**Migration steps:**

1. Update any report consumers that read `Cyclic_Dependencies*.csv` files from `reports/internal-dependencies/` to read from `reports/cyclic-dependencies/` instead.
2. If you reference cyclic dependency queries by path, update the path from `domains/internal-dependencies/queries/cyclic-dependencies/` to `domains/cyclic-dependencies/queries/`.
3. No changes to `analyze.sh` invocations are required — both domains run by default.

---

### 6. Archetypes split out of `anomaly-detection`

**What changed (PR [#580](https://github.com/JohT/code-graph-analysis-pipeline/pull/580)):**

A new `domains/archetypes/` domain now owns Authority, Bottleneck, and Hub archetype detection. The `anomaly-detection` domain no longer assigns these labels or rank properties.

**Neo4j node property renames:**

| Before | After |
|--------|-------|
| `Mark4TopAnomalyAuthority` | `Mark4TopArchetypeAuthority` |
| `Mark4TopAnomalyBottleneck` | `Mark4TopArchetypeBottleneck` |
| `Mark4TopAnomalyHub` | `Mark4TopArchetypeHub` |
| `anomalyAuthorityRank` | `archetypeAuthorityRank` |
| `anomalyBottleneckRank` | `archetypeBottleneckRank` |
| `anomalyHubRank` | `archetypeHubRank` |

**Migration steps:**

1. If your Cypher queries or application code reference the old property names, rename them to the new names listed above.
2. If you persist Neo4j data across pipeline runs and have existing nodes with the old properties, run the following Cypher to migrate them:

   ```cypher
   MATCH (n)
   WHERE n.Mark4TopAnomalyAuthority IS NOT NULL
   SET n.Mark4TopArchetypeAuthority = n.Mark4TopAnomalyAuthority
   REMOVE n.Mark4TopAnomalyAuthority

   MATCH (n)
   WHERE n.Mark4TopAnomalyBottleneck IS NOT NULL
   SET n.Mark4TopArchetypeBottleneck = n.Mark4TopAnomalyBottleneck
   REMOVE n.Mark4TopAnomalyBottleneck

   MATCH (n)
   WHERE n.Mark4TopAnomalyHub IS NOT NULL
   SET n.Mark4TopArchetypeHub = n.Mark4TopAnomalyHub
   REMOVE n.Mark4TopAnomalyHub

   MATCH (n)
   WHERE n.anomalyAuthorityRank IS NOT NULL
   SET n.archetypeAuthorityRank = n.anomalyAuthorityRank
   REMOVE n.anomalyAuthorityRank

   MATCH (n)
   WHERE n.anomalyBottleneckRank IS NOT NULL
   SET n.archetypeBottleneckRank = n.anomalyBottleneckRank
   REMOVE n.anomalyBottleneckRank

   MATCH (n)
   WHERE n.anomalyHubRank IS NOT NULL
   SET n.archetypeHubRank = n.anomalyHubRank
   REMOVE n.anomalyHubRank
   ```

3. No changes to `analyze.sh` invocations are required — both domains run by default.

---

### 7. Neo4j configuration templates moved

**What changed (PR [#555](https://github.com/JohT/code-graph-analysis-pipeline/pull/555)):**

| Before | After |
|--------|-------|
| `scripts/configuration/template-neo4j.conf` | `domains/neo4j-management/configuration/template-neo4j.conf` |
| `scripts/configuration/template-neo4j-high-memory.conf` | `domains/neo4j-management/configuration/template-neo4j-high-memory.conf` |
| `scripts/configuration/template-neo4j-low-memory.conf` | `domains/neo4j-management/configuration/template-neo4j-low-memory.conf` |
| `scripts/configuration/template-neo4j-v4.conf` | `domains/neo4j-management/configuration/template-neo4j-v4.conf` |
| `scripts/configuration/template-neo4j-v4-low-memory.conf` | `domains/neo4j-management/configuration/template-neo4j-v4-low-memory.conf` |

`scripts/startNeo4j.sh` and `scripts/stopNeo4j.sh` are kept as **backward-compatible redirect stubs** — existing analysis workspaces that call these scripts do not need to be updated.

**Migration steps:**

1. If you reference the configuration template files directly (e.g. to copy or override them), update the paths from `scripts/configuration/` to `domains/neo4j-management/configuration/`.
2. No changes needed for `scripts/startNeo4j.sh` or `scripts/stopNeo4j.sh` callers.

---

### 8. Reference documentation moved to repo root

**What changed (PR [#555](https://github.com/JohT/code-graph-analysis-pipeline/pull/555)):**

| Before | After |
|--------|-------|
| `scripts/SCRIPTS.md` | `SCRIPTS.md` (repo root) |
| `scripts/ENVIRONMENT_VARIABLES.md` | `ENVIRONMENT_VARIABLES.md` (repo root) |
| `cypher/CYPHER.md` | `CYPHER.md` (repo root) |

**Migration steps:**

1. Update any bookmarks, links, or documentation that reference the old paths.

---

### 9. `importGit.sh` canonical location changed

**What changed (PR [#559](https://github.com/JohT/code-graph-analysis-pipeline/pull/559)):**

| Before | After |
|--------|-------|
| `scripts/importGit.sh` | `domains/git-history/import/importGit.sh` |

**Migration steps:**

1. Update any invocations of `scripts/importGit.sh` to use `domains/git-history/import/importGit.sh`.
2. Update links in documentation or CI scripts accordingly.
