# Plan: Introduce `graph-algorithms` and `node-embeddings` Domains

## TL;DR

Create two new vertical-slice domains using `domains/java/` as the reference pattern and `plan-git-history-domain.prompt.md` as the planning template. Copy (no move/delete) all Cypher queries, scripts, and notebooks into each domain. `graph-algorithms` covers centrality, community detection, and similarity (3 separate `*Csv.sh` entry points + Markdown summary). `node-embeddings` covers FastRP/HashGNN/Node2Vec/GraphSAGE embeddings (CSV + Python UMAP charts + Markdown summary + explore notebooks). Both domains stay self-contained except for central GDS projection utilities documented as prerequisites.

---

## Decisions

- **Domain names**: `graph-algorithms` + `node-embeddings` (kept as proposed)
- **Summary algorithms**: PageRank · ArticleRank · Betweenness | Leiden · SCC · WCC · LCC | Jaccard — all others → CSV reference only
- **`cypher/Dependencies_Projection/`**: Keep central; documented as prerequisite in each domain. Used by 4+ domains; not duplicated.
- **Report subdirectories**: Keep existing `centrality-csv/`, `community-csv/`, `similarity-csv/` — no consolidation
- **Python charts for graph-algorithms**: Deferred — CSV + Markdown only this iteration. No `graphAlgorithmsCharts.py`.
- **GraphSAGE**: Include all 22 `Node_Embeddings/` queries (2 GraphSAGE files noted as unsupported in current pipeline scripts — copy with documentation note)
- **No explore notebooks for graph-algorithms**: No dedicated graph algorithm notebooks exist in `jupyter/`
- **Similarity algorithm**: Expected to be Jaccard (via `gds.nodeSimilarity`) — verify against `cypher/Similarity/Set_Parameters.cypher` during implementation

---

## Source Files to Copy

### graph-algorithms

| Source | Destination |
|--------|-------------|
| `scripts/reports/CentralityCsv.sh` | `domains/graph-algorithms/centralityCsv.sh` |
| `scripts/reports/CommunityCsv.sh` | `domains/graph-algorithms/communityCsv.sh` |
| `scripts/reports/SimilarityCsv.sh` | `domains/graph-algorithms/similarityCsv.sh` |
| `cypher/Centrality/` (43 files) | `domains/graph-algorithms/queries/centrality/` |
| `cypher/Community_Detection/` (64 files) | `domains/graph-algorithms/queries/community-detection/` |
| `cypher/Similarity/` (10 files) | `domains/graph-algorithms/queries/similarity/` |

### node-embeddings

| Source | Destination |
|--------|-------------|
| `scripts/reports/NodeEmbeddingsCsv.sh` | `domains/node-embeddings/nodeEmbeddingsCsv.sh` |
| `cypher/Node_Embeddings/` (22 files) | `domains/node-embeddings/queries/node-embeddings/` |
| `jupyter/NodeEmbeddingsJava.ipynb` | `domains/node-embeddings/explore/NodeEmbeddingsJavaExploration.ipynb` |
| `jupyter/NodeEmbeddingsTypescript.ipynb` | `domains/node-embeddings/explore/NodeEmbeddingsTypescriptExploration.ipynb` |

---

## Domain Directory Structures

### `domains/graph-algorithms/`

```
domains/graph-algorithms/
├── README.md
├── PREREQUISITES.md
├── COPIED_FILES.md
├── centralityCsv.sh                    # Entry: centrality CSV (*Csv.sh)
├── communityCsv.sh                     # Entry: community detection CSV (*Csv.sh)
├── similarityCsv.sh                    # Entry: similarity CSV (*Csv.sh)
├── graphAlgorithmsMarkdown.sh          # Entry: Markdown summary (*Markdown.sh)
├── queries/
│   ├── centrality/                     # 43 files from cypher/Centrality/
│   ├── community-detection/            # 64 files from cypher/Community_Detection/
│   ├── similarity/                     # 10 files from cypher/Similarity/
│   └── statistics/                     # NEW: 8 summary queries reading written properties
└── summary/
    ├── graphAlgorithmsSummary.sh
    ├── report.template.md
    └── report_no_graph_data.template.md
```

### `domains/node-embeddings/`

```
domains/node-embeddings/
├── README.md
├── PREREQUISITES.md
├── COPIED_FILES.md
├── nodeEmbeddingsCsv.sh                # Entry: CSV reports (*Csv.sh)
├── nodeEmbeddingsPython.sh             # Entry: Python SVG charts (*Python.sh)
├── nodeEmbeddingsMarkdown.sh           # Entry: Markdown summary (*Markdown.sh)
├── nodeEmbeddingsCharts.py             # UMAP 2D scatter plots → SVG
├── explore/
│   ├── NodeEmbeddingsJavaExploration.ipynb
│   └── NodeEmbeddingsTypescriptExploration.ipynb
├── queries/
│   ├── node-embeddings/                # 22 files from cypher/Node_Embeddings/
│   └── statistics/                     # NEW: 2 queries reading embedding properties for summary
└── summary/
    ├── nodeEmbeddingsSummary.sh
    ├── report.template.md
    └── report_no_embedding_data.template.md
```

---

## Key Path Adaptation for Scripts

Scripts originally at `scripts/reports/` reference `$CYPHER_DIR/Centrality` etc. When copied to domain directories, internal Cypher paths must change. Pattern (from `domains/java/javaCsv.sh`):

```bash
SCRIPT_DIR=$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )
SCRIPTS_DIR=${SCRIPTS_DIR:-"${SCRIPT_DIR}/../../scripts"}
CYPHER_DIR=${CYPHER_DIR:-"${SCRIPT_DIR}/../../cypher"}     # still needed for Dependencies_Projection
DOMAIN_QUERIES_DIR="${SCRIPT_DIR}/queries"
```

In each function: replace `local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"` → `"${DOMAIN_QUERIES_DIR}/centrality"`. `CYPHER_DIR/Dependencies_Projection` stays **unchanged** (remains central).

Same pattern applies to `nodeEmbeddingsCsv.sh` in the node-embeddings domain.

---

## Statistics Queries (NEW Cypher files)

### graph-algorithms: `queries/statistics/`

These new `.cypher` files read already-written node properties to produce small tables for the markdown report:

1. `Top_nodes_by_PageRank.cypher` — reads `centralityPageRank` property, parameterized by node label, top 20
2. `Top_nodes_by_ArticleRank.cypher` — reads `centralityArticleRank`
3. `Top_nodes_by_Betweenness.cypher` — reads `centralityBetweenness`
4. `Leiden_community_overview.cypher` — reads `communityLeidenId`, groups + counts, shows top communities
5. `SCC_overview.cypher` — reads `communityStronglyConnectedComponentId`, groups + counts
6. `WCC_overview.cypher` — reads `communityWeaklyConnectedComponentId`, groups + counts
7. `LCC_nodes_by_coefficient.cypher` — reads `communityLocalClusteringCoefficient`, top 20 by value
8. `Jaccard_similarity_top_pairs.cypher` — reads `SIMILAR` relationships, top 20 by similarity score

Property names sourced from `CentralityCsv.sh` and `CommunityCsv.sh` write property assignments. Verify exact property names during implementation.

### node-embeddings: `queries/statistics/`

1. `Embedding_properties_overview.cypher` — lists which embedding properties exist and on how many nodes per label
2. `Node_embeddings_with_community_and_centrality.cypher` — for nodes with embeddings + Leiden + PageRank (feeds UMAP chart)

---

## Prerequisites

### graph-algorithms `PREREQUISITES.md`

- Neo4j running with scanned/analyzed artifacts
- **Dependency enrichment** complete: `cypher/Dependency_Enrichment/` must have set `weight`, `weight25PercentInterfaces`, `incomingDependencies`, `outgoingDependencies`, `lowCouplingElement25PercentWeight`, `weightByDependencyType` on nodes/relationships
- **Central projection utilities** available: `cypher/Dependencies_Projection/` (26 GDS queries)
- `scripts/projectionFunctions.sh` (creates/deletes GDS in-memory graphs)
- `scripts/executeQueryFunctions.sh`
- `scripts/cleanupAfterReportGeneration.sh`
- Neo4j **Graph Data Science (GDS)** plugin installed

### node-embeddings `PREREQUISITES.md`

- All graph-algorithms prerequisites PLUS:
- `centralityPageRank` property on code nodes (from graph-algorithms centrality CSV run) — for UMAP visualization coloring; graceful if absent (uniform black dots)
- `communityLeidenId` property on code nodes (from graph-algorithms community CSV run) — for UMAP visualization coloring; graceful if absent
- Python environment: `neo4j`, `pandas`, `numpy`, `umap-learn`, `matplotlib`, `scikit-learn` (verify in `requirements.txt` / `conda-environment.yml`)

---

## Instructions to Follow

All new and adapted files must follow the scoped instruction files before finalizing:

| File type | Instruction file |
|-----------|-----------------|
| `*.sh` | [`.github/instructions/shell-scripts.instructions.md`](./.github/instructions/shell-scripts.instructions.md) |
| `*.py`, `*.ipynb` | [`.github/instructions/python.instructions.md`](./.github/instructions/python.instructions.md) |
| `*.cypher` | [`.github/instructions/cypher-queries.instructions.md`](./.github/instructions/cypher-queries.instructions.md) |

Key requirements:
- Shell: `#!/usr/bin/env bash`, `set -euo pipefail`, `IFS=$'\n\t'`, `local` vars, `"${var}"` quoting, `usage()` function, no `eval`
- Python: type annotations, `pathlib.Path`, named constants, f-strings, `"""docstrings"""`
- Cypher: first-line description comment, one statement per file, uppercase keywords (copied files inherit original format; only modify if adapting is necessary)
- **No new abbreviations**: do not introduce abbreviations not already present in the source files. Write out variable names, function names, and identifiers in full. Symbols (`i`, `j`, `k` for indices) are the only accepted shorthand.

---

## Steps

### Phase 1: Scaffolding — parallel for both domains

- [ ] 1.1 Create directory structure for `domains/graph-algorithms/`: `queries/{centrality,community-detection,similarity,statistics}/`, `summary/`
- [ ] 1.2 Create `domains/graph-algorithms/COPIED_FILES.md` — table mapping every source file to destination path for deprecation tracking
- [ ] 1.3 Create `domains/node-embeddings/` directory structure: `queries/{node-embeddings,statistics}/`, `summary/`, `explore/`
- [ ] 1.4 Create `domains/node-embeddings/COPIED_FILES.md`

### Phase 2: Copy Cypher Queries — parallel for both domains

- [ ] 2.1 Copy all 43 files from `cypher/Centrality/` → `domains/graph-algorithms/queries/centrality/` (no modification)
- [ ] 2.2 Copy all 64 files from `cypher/Community_Detection/` → `domains/graph-algorithms/queries/community-detection/` (no modification)
- [ ] 2.3 Copy all 10 files from `cypher/Similarity/` → `domains/graph-algorithms/queries/similarity/` (no modification). **Verify** `Set_Parameters.cypher` uses Jaccard as the similarity metric; update plan if not.
- [ ] 2.4 Copy all 22 files from `cypher/Node_Embeddings/` → `domains/node-embeddings/queries/node-embeddings/` (no modification). Note in `COPIED_FILES.md` that GraphSAGE Train/Stream files are present but not yet wired into the entry point script.
- [ ] 2.5 **Scan for unreferenced Cypher queries**: check `cypher/Centrality/`, `cypher/Community_Detection/`, `cypher/Similarity/`, and `cypher/Node_Embeddings/` for any files not referenced by the source report scripts (`CentralityCsv.sh`, `CommunityCsv.sh`, `SimilarityCsv.sh`, `NodeEmbeddingsCsv.sh`). If unreferenced queries clearly belong to the domain (same algorithm family, same node properties), copy them into the domain's query subdirectory and note them in `COPIED_FILES.md`. **Ask before copying if the fit is unclear.**

### Phase 3: Create Statistics Queries (NEW Cypher files)

- [ ] 3.1 Create 8 statistics queries in `domains/graph-algorithms/queries/statistics/` (listed above). Follow cypher-queries instructions: first-line description comment, uppercase keywords, parameterized with `$nodeLabel` where applicable. Cross-check property names against `CentralityCsv.sh` / `CommunityCsv.sh` write property assignments before writing.
- [ ] 3.2 Create 2 statistics queries in `domains/node-embeddings/queries/statistics/` (listed above).
- [ ] 3.3 Run verification: `./scripts/executeQuery.sh <query>` against live Neo4j for each new query. Empty result ≠ broken — data may be absent.

### Phase 4: Copy and Adapt Entry Point Scripts — parallel for both domains

- [ ] 4.1 Copy `scripts/reports/CentralityCsv.sh` → `domains/graph-algorithms/centralityCsv.sh`. Adapt:
  - Add `SCRIPT_DIR` resolution (pattern from `domains/java/javaCsv.sh`)
  - Update `SCRIPTS_DIR` to `"${SCRIPT_DIR}/../../scripts"`
  - Update `CYPHER_DIR` to `"${SCRIPT_DIR}/../../cypher"` (still needed for Dependencies_Projection)
  - Add `DOMAIN_QUERIES_DIR="${SCRIPT_DIR}/queries"`
  - In each function: replace `local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"` → `"${DOMAIN_QUERIES_DIR}/centrality"`
  - Keep `local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"` unchanged
  - Apply shell-scripts instructions: `set -euo pipefail`, `IFS=$'\n\t'`, `usage()` function, description header comment
- [ ] 4.2 Copy `scripts/reports/CommunityCsv.sh` → `domains/graph-algorithms/communityCsv.sh`. Same adaptations, changing `Community_Detection` dir reference.
- [ ] 4.3 Copy `scripts/reports/SimilarityCsv.sh` → `domains/graph-algorithms/similarityCsv.sh`. Same adaptations.
- [ ] 4.4 Copy `scripts/reports/NodeEmbeddingsCsv.sh` → `domains/node-embeddings/nodeEmbeddingsCsv.sh`. Same adaptation pattern; replace `Node_Embeddings` dir reference.
- [ ] 4.5 Run `shellcheck` on all 4 adapted scripts: `shellcheck domains/graph-algorithms/centralityCsv.sh domains/graph-algorithms/communityCsv.sh domains/graph-algorithms/similarityCsv.sh domains/node-embeddings/nodeEmbeddingsCsv.sh`

### Phase 5: Markdown Entry Points

- [ ] 5.1 Create `domains/graph-algorithms/graphAlgorithmsMarkdown.sh` — thin script delegating to `summary/graphAlgorithmsSummary.sh`. Pattern: `domains/java/javaMarkdown.sh`
- [ ] 5.2 Create `domains/node-embeddings/nodeEmbeddingsMarkdown.sh` — same pattern
- [ ] 5.3 Run `shellcheck` on both new scripts

### Phase 6: Python Script and Entry Point (node-embeddings only)

- [ ] 6.1 Create `domains/node-embeddings/nodeEmbeddingsCharts.py` from notebooks. Requirements:
  - `Parameters` class for CLI args (pattern: `domains/java/javaCharts.py`)
  - Neo4j connection via `NEO4J_INITIAL_PASSWORD` env var (as in source notebooks — security: no hardcoded credentials)
  - `load_embeddings(node_label: str, embedding_property: str) -> pd.DataFrame`
  - `apply_umap(embeddings: pd.DataFrame) -> pd.DataFrame` — returns 2D coordinates
  - `generate_embedding_scatter(node_label: str, algorithm_name: str) -> None` — saves `{Label}_Embeddings_{Algorithm}_2D.svg`
  - Graceful degradation: if `centralityPageRank` or `communityLeidenId` absent, skip coloring/sizing (uniform display)
  - Exit 0 if no report directory or no data
  - Apply python.instructions.md: type annotations, `pathlib.Path`, named constants, `"""docstrings"""`
- [ ] 6.2 Run `python -m py_compile domains/node-embeddings/nodeEmbeddingsCharts.py`
- [ ] 6.3 Open `nodeEmbeddingsCharts.py` in VS Code; verify zero Pylance errors in Problems panel
- [ ] 6.4 Create `domains/node-embeddings/nodeEmbeddingsPython.sh` — activates Python env, runs `nodeEmbeddingsCharts.py`. Pattern: `domains/java/javaPython.sh`
- [ ] 6.5 Run `shellcheck domains/node-embeddings/nodeEmbeddingsPython.sh`

### Phase 7: Explore Notebooks (node-embeddings only)

- [ ] 7.1 Copy `jupyter/NodeEmbeddingsJava.ipynb` → `domains/node-embeddings/explore/NodeEmbeddingsJavaExploration.ipynb`:
  - In top-level `"metadata"` JSON: add `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"`
  - Update title markdown cell to include "Exploration" (see `domains/anomaly-detection/explore/AnomalyDetectionExploration.ipynb` title style)
  - Retain all original code; adapt any hardcoded paths if present
- [ ] 7.2 Copy `jupyter/NodeEmbeddingsTypescript.ipynb` → `domains/node-embeddings/explore/NodeEmbeddingsTypescriptExploration.ipynb` — same modifications
- [ ] 7.3 Verify: inspect both notebooks' `"metadata"` sections — confirm `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"` is present at top-level (not cell-level)

### Phase 8: Summary Templates and Assembly Scripts

- [ ] 8.1 Create `domains/graph-algorithms/summary/report.template.md`:
  - Selected algorithms: dedicated section per algorithm with description (≤3 sentences, AI-context-friendly) + `{{include}}` for top-10 table
  - Excluded algorithms: single "Further Results" section with bulleted CSV file path references
  - Fallback section if no graph data
- [ ] 8.2 Create `domains/graph-algorithms/summary/report_no_graph_data.template.md` — brief fallback report
- [ ] 8.3 Create `domains/graph-algorithms/summary/graphAlgorithmsSummary.sh`:
  - For each selected algorithm: run corresponding statistics query → generate limited Markdown include file (top 10 rows)
  - Graceful: skip section if property not present (algorithm may not have run)
  - Assemble final report via `embedMarkdownIncludes.sh`
  - Pattern: `domains/java/summary/javaSummary.sh`
- [ ] 8.4 Run `shellcheck domains/graph-algorithms/summary/graphAlgorithmsSummary.sh`
- [ ] 8.5 Create `domains/node-embeddings/summary/report.template.md`:
  - SVG embeds per projection/algorithm (FastRP, HashGNN, Node2Vec)
  - Quality metrics table (silhouette score, Davies-Bouldin) if available
  - Links to explore notebooks for deeper investigation
  - CSV file references for complete data
- [ ] 8.6 Create `domains/node-embeddings/summary/report_no_embedding_data.template.md`
- [ ] 8.7 Create `domains/node-embeddings/summary/nodeEmbeddingsSummary.sh`
- [ ] 8.8 Run `shellcheck domains/node-embeddings/summary/nodeEmbeddingsSummary.sh`

### Phase 9: Documentation

- [ ] 9.1 Create `domains/graph-algorithms/README.md`:
  - Domain overview, entry point table, folder structure, output description
- [ ] 9.2 Create `domains/graph-algorithms/PREREQUISITES.md`:
  - Neo4j GDS plugin required
  - `cypher/Dependency_Enrichment/` must have set: `weight`, `weight25PercentInterfaces`, `incomingDependencies`, `outgoingDependencies`, `lowCouplingElement25PercentWeight`, `weightByDependencyType`
  - Central: `cypher/Dependencies_Projection/` (26 queries) + `scripts/projectionFunctions.sh`
  - Central: `scripts/executeQueryFunctions.sh`, `scripts/cleanupAfterReportGeneration.sh`
  - Run-order note: `graphAlgorithmsMarkdown.sh` summary only works correctly after `centralityCsv.sh` and `communityCsv.sh` have run at least once
- [ ] 9.3 Create `domains/node-embeddings/README.md`
- [ ] 9.4 Create `domains/node-embeddings/PREREQUISITES.md`:
  - All graph-algorithms prerequisites PLUS
  - `centralityPageRank` and `communityLeidenId` node properties (from graph-algorithms domain) — needed for UMAP visualization; graceful if absent
  - Python env packages: `neo4j`, `pandas`, `numpy`, `umap-learn`, `matplotlib`, `scikit-learn`
  - Note: `nodeEmbeddingsCharts.py` reads directly from Neo4j (not from CSVs) — Neo4j must be running during Python report generation

### Phase 10: Verification

- [ ] 10.1 `shellcheck domains/graph-algorithms/*.sh domains/graph-algorithms/summary/*.sh domains/node-embeddings/*.sh domains/node-embeddings/summary/*.sh`
- [ ] 10.2 `python -m py_compile domains/node-embeddings/nodeEmbeddingsCharts.py`
- [ ] 10.3 Pylance: open `nodeEmbeddingsCharts.py` in VS Code — zero errors in Problems panel
- [ ] 10.4 Inspect `domains/graph-algorithms/queries/similarity/Set_Parameters.cypher` — confirm similarity metric is Jaccard; update summary template label if different
- [ ] 10.5 Cross-verify written property names in adapted scripts match property names in statistics queries
- [ ] 10.6 `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json domains/graph-algorithms/README.md domains/node-embeddings/README.md`
- [ ] 10.7 Confirm `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"` in both explore notebooks' top-level metadata
- [ ] 10.8 `analyze.sh --domain graph-algorithms --report Csv --keep-running`
- [ ] 10.9 `analyze.sh --domain graph-algorithms --report Markdown --keep-running`
- [ ] 10.10 `analyze.sh --domain node-embeddings --report Csv --keep-running`
- [ ] 10.11 `analyze.sh --domain node-embeddings --report Python --keep-running`
- [ ] 10.12 `analyze.sh --domain node-embeddings --report Markdown --keep-running`

---

## Relevant Reference Files

| File | Purpose |
|------|---------|
| `scripts/reports/CentralityCsv.sh` | Source script for centrality domain entry point |
| `scripts/reports/CommunityCsv.sh` | Source script for community domain entry point |
| `scripts/reports/SimilarityCsv.sh` | Source script for similarity domain entry point |
| `scripts/reports/NodeEmbeddingsCsv.sh` | Source script for node-embeddings domain entry point |
| `jupyter/NodeEmbeddingsJava.ipynb` | Source for Python chart extraction |
| `jupyter/NodeEmbeddingsTypescript.ipynb` | Source for Python chart extraction |
| `domains/java/javaCsv.sh` | `SCRIPT_DIR` resolution + entry point pattern |
| `domains/java/javaCharts.py` | `Parameters`, `load_csv()`, `save_figure()`, `main()` pattern |
| `domains/java/javaPython.sh` | Python entry point pattern |
| `domains/java/summary/javaSummary.sh` | Summary assembly pattern |
| `domains/java/summary/report.template.md` | Template structure with `{{include}}` directives |
| `domains/anomaly-detection/explore/AnomalyDetectionExploration.ipynb` | Explore notebook metadata format reference |
| `.github/instructions/shell-scripts.instructions.md` | Must be applied to all new `.sh` |
| `.github/instructions/python.instructions.md` | Must be applied to `.py` and adapted `.ipynb` |
| `.github/instructions/cypher-queries.instructions.md` | Must be applied to all new `.cypher` files |

---

## Further Considerations

1. **Similarity metric verification** (Step 2.3): if `Set_Parameters.cypher` uses COSINE or OVERLAP instead of Jaccard, the summary template label and the plan statistics query name must change accordingly.
2. **Statistics queries require written properties**: `graphAlgorithmsSummary.sh` only works correctly after `centralityCsv.sh` and `communityCsv.sh` have run at least once. Document this explicitly in `PREREQUISITES.md`.
3. **`nodeEmbeddingsCharts.py` reads from Neo4j directly** (not from CSVs): unlike `javaCharts.py` which reads CSV files, this script requires a live Neo4j connection. Document clearly; fail gracefully with a helpful error message if Neo4j is unreachable.
4. **Unreferenced Cypher queries**: some queries in `cypher/Centrality/`, `cypher/Community_Detection/`, `cypher/Similarity/`, and `cypher/Node_Embeddings/` may not be referenced by any existing report script (e.g. alternative stream variants, write alternatives, or helper queries). If they clearly belong to a domain, copy them alongside the others and list them in `COPIED_FILES.md`. Ask before copying if the domain fit is unclear.
5. **No new abbreviations**: all new identifiers (variable names, function names, file names, parameter names) must be written out in full. Do not introduce abbreviations not already present in the source files being copied or adapted. Accepted shorthand: `i`, `j`, `k` as loop indices only.
