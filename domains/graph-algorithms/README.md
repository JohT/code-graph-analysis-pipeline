# Graph Algorithms Domain

This directory contains the implementation and resources for analysing **code graphs using graph algorithms** within the Code Graph Analysis Pipeline. It follows the vertical-slice domain pattern: all Cypher queries, shell scripts, and report templates needed for this analysis live here.

This domain covers three related analysis areas:

- **Centrality**: Which nodes (packages, types, artifacts, TypeScript modules, SCIP types) are most influential in the dependency graph — PageRank, ArticleRank, Betweenness, Harmonic, Closeness, HITS, Bridges, CELF.
- **Community Detection**: How code units cluster into communities — Louvain, Leiden, Strongly Connected Components, Weakly Connected Components, Label Propagation, K-Core, Approximate Maximum k-cut, HDBSCAN, Local Clustering Coefficient.
- **Similarity**: Which code units share the most common dependencies — Jaccard Node Similarity.

The goal is to run the majority of graph algorithms provided by the Neo4j Graph Data Science (GDS) library and compare their results to get a basis for exploration and experimentation.

**These algorithms are not included:**

- **Path-Finding algorithms:** see [internal-dependencies](./../internal-dependencies/)
- **Node Embedding algorithms:** see [node-embeddings](./../node-embeddings/)

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [centralityCsv.sh](./centralityCsv.sh): Entry point for centrality CSV reports. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [communityCsv.sh](./communityCsv.sh): Entry point for community detection CSV reports. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [similarityCsv.sh](./similarityCsv.sh): Entry point for similarity CSV reports. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [graphAlgorithmsMarkdown.sh](./graphAlgorithmsMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).

## Folder Structure

```
domains/graph-algorithms/
├── README.md                              # This file
├── PREREQUISITES.md                       # Detailed prerequisite documentation
├── COPIED_FILES.md                        # Original → copy mapping for deprecation follow-up
├── centralityCsv.sh                       # Entry point: centrality CSV reports
├── communityCsv.sh                        # Entry point: community detection CSV reports
├── similarityCsv.sh                       # Entry point: similarity CSV reports
├── graphAlgorithmsMarkdown.sh             # Entry point: Markdown summary
├── queries/
│   ├── centrality/                        # 43 Cypher queries (copied from cypher/Centrality/)
│   ├── community-detection/               # 64 Cypher queries (copied from cypher/Community_Detection/)
│   ├── similarity/                        # 10 Cypher queries (copied from cypher/Similarity/)
│   └── statistics/                        # 8 summary Cypher queries for the Markdown report
└── summary/
    ├── graphAlgorithmsSummary.sh          # Markdown assembly logic
    ├── report.template.md                 # Main report template
    └── report_no_graph_data.template.md   # Fallback when no data is present
```

## Prerequisites

See [PREREQUISITES.md](./PREREQUISITES.md) for full details. Key requirements:

- Neo4j running with the Graph Data Science (GDS) plugin installed
- `DEPENDS_ON` relationships with weight properties from [`cypher/Dependency_Enrichment/`](../../cypher/Dependency_Enrichment/)
- Dependencies Projection functions from [`cypher/Dependencies_Projection/`](../../cypher/Dependencies_Projection/) and [`scripts/projectionFunctions.sh`](../../scripts/projectionFunctions.sh)

## Execution Order

1. **`centralityCsv.sh`** — runs centrality algorithms, writes node properties and CSV files
2. **`communityCsv.sh`** — runs community detection algorithms, writes node properties and CSV files
3. **`similarityCsv.sh`** — runs similarity algorithm, writes `SIMILAR` relationships and CSV files
4. **`graphAlgorithmsMarkdown.sh`** — assembles the final Markdown report from statistics queries

## What This Domain Produces

All output goes into `reports/graph-algorithms/`:

- `reports/graph-algorithms/<NodeType>/centrality/` — centrality scores per node type and algorithm (e.g., Java_Package, Java_Type, Typescript_Module, SCIP_Type)
- `reports/graph-algorithms/<NodeType>/communities/` — community assignments per node type and algorithm
- `reports/graph-algorithms/<NodeType>/similarity/` — top similar node pairs per node type
- `reports/graph-algorithms/` — assembled Markdown report (`graph_algorithms_report.md`)
