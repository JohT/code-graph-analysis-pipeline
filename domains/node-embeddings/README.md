# Node Embeddings Domain

This directory contains the implementation and resources for generating and visualising **node embeddings** from the code dependency graph within the Code Graph Analysis Pipeline. It follows the vertical-slice domain pattern: all Cypher queries, Python chart scripts, Jupyter notebooks, shell scripts, and report templates needed for this analysis live here.

This domain covers:

- **Node Embedding Generation**: Computes fixed-length vector representations of code units using three GDS algorithms — FastRP, HashGNN, Node2Vec. GraphSAGE queries are present in `queries/node-embeddings/` and may be wired in a future iteration.
- **UMAP Visualisation**: Reduces embedding vectors to 2D via UMAP and generates scatter plots coloured by Leiden community (when available) or PageRank (fallback).
- **Interactive Exploration**: Jupyter notebooks for exploring embeddings and tuning UMAP parameters interactively.

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [nodeEmbeddingsCsv.sh](./nodeEmbeddingsCsv.sh): Entry point for node-embedding CSV reports. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [nodeEmbeddingsPython.sh](./nodeEmbeddingsPython.sh): Entry point for Python-based UMAP chart generation. Discovered by `PythonReports.sh` (`*Python.sh` pattern).
- [nodeEmbeddingsMarkdown.sh](./nodeEmbeddingsMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).

## Folder Structure

```
domains/node-embeddings/
├── README.md                                     # This file
├── PREREQUISITES.md                              # Detailed prerequisite documentation
├── COPIED_FILES.md                               # Original → copy mapping for deprecation follow-up
├── nodeEmbeddingsCsv.sh                          # Entry point: CSV + embedding property generation
├── nodeEmbeddingsPython.sh                       # Entry point: UMAP scatter plot SVGs
├── nodeEmbeddingsMarkdown.sh                     # Entry point: Markdown summary
├── nodeEmbeddingsCharts.py                       # UMAP chart generator (reads from Neo4j)
├── explore/                                      # Jupyter notebooks for interactive exploration
│   ├── NodeEmbeddingsJavaExploration.ipynb
│   └── NodeEmbeddingsTypescriptExploration.ipynb
├── queries/
│   ├── node-embeddings/                          # 22 Cypher queries (copied from cypher/Node_Embeddings/)
│   └── statistics/                               # 2 summary Cypher queries for the Markdown report
└── summary/
    ├── nodeEmbeddingsSummary.sh                  # Markdown assembly logic
    ├── report.template.md                        # Main report template
    └── report_no_embedding_data.template.md      # Fallback when no data is present
```

## Prerequisites

See [PREREQUISITES.md](./PREREQUISITES.md) for full details. Key requirements:

- Neo4j running with the Graph Data Science (GDS) plugin installed
- `DEPENDS_ON` relationships with weight properties from [`cypher/Dependency_Enrichment/`](../../cypher/Dependency_Enrichment/)
- Dependencies Projection functions from [`cypher/Dependencies_Projection/`](../../cypher/Dependencies_Projection/) and [`scripts/projectionFunctions.sh`](../../scripts/projectionFunctions.sh)
- `NEO4J_INITIAL_PASSWORD` environment variable set (required by `nodeEmbeddingsCharts.py`)

## Execution Order

1. **`nodeEmbeddingsCsv.sh`** — runs GDS embedding algorithms, writes embedding properties to nodes and CSV files
2. **`nodeEmbeddingsPython.sh`** — reads embedding properties from Neo4j, generates UMAP scatter plot SVGs
3. **`nodeEmbeddingsMarkdown.sh`** — assembles the final Markdown report

## What This Domain Produces

All output goes into `reports/node-embeddings/`:

- `<NodeLabel>_Embeddings_Label_Random_Projection.csv` — FastRP embedding vectors
- `<NodeLabel>_Embeddings_HashGNN.csv` — HashGNN embedding vectors
- `<NodeLabel>_Embeddings_Node2Vec.csv` — Node2Vec embedding vectors
- `<NodeLabel>_Embeddings_<Algorithm>_UMAP2D_Scatter.svg` — 2D scatter plots
- `node_embeddings_report.md` — assembled Markdown summary report
