# Node Embeddings Domain — Prerequisites

This domain requires the following to be in place before running. These are provided by the central pipeline and are **not** set up by this domain.

## Required: Neo4j with GDS Plugin

Neo4j must be running with the **Graph Data Science (GDS) plugin** installed. The GDS plugin provides the FastRP, HashGNN, and Node2Vec embedding algorithms used by this domain.

See [scripts/setupJQAssistant.sh](../../scripts/setupJQAssistant.sh) and [GETTING_STARTED.md](../../GETTING_STARTED.md) for setup instructions.

## Required: NEO4J_INITIAL_PASSWORD Environment Variable

The Python chart generator (`nodeEmbeddingsCharts.py`) reads embedding vectors directly from Neo4j via the Bolt protocol. The `NEO4J_INITIAL_PASSWORD` environment variable must be set so the driver can authenticate.

```shell
export NEO4J_INITIAL_PASSWORD=<your-neo4j-password>
```

## Required: Scanned Code Artifacts

At least one code artifact (Java JAR/WAR or TypeScript project) must be scanned and imported into the graph database before running this domain.

## Required: Dependency Enrichment (Weight Properties)

The following weight properties must be set on `DEPENDS_ON` relationships before running projections:

- `weight` — basic dependency weight
- `weight25PercentInterfaces` — weight with 25% interface contribution
- `lowCouplingElement25PercentWeight` — TypeScript module weight

These are set by the Cypher queries in [`cypher/Dependency_Enrichment/`](../../cypher/Dependency_Enrichment/).

## Required: Dependencies Projection Utilities

The graph projection functions used by this domain are sourced from:

- [`scripts/projectionFunctions.sh`](../../scripts/projectionFunctions.sh) — provides `createUndirectedDependencyProjection`, `createUndirectedJavaTypeDependencyProjection`
- [`cypher/Dependencies_Projection/`](../../cypher/Dependencies_Projection/) — Cypher files for projection creation, mutation, write-back, and clean-up

These are **not** copied into this domain — they are referenced from the central `cypher/` and `scripts/` directories.

## Optional: Centrality and Community Properties

The UMAP scatter plots (`nodeEmbeddingsCharts.py`) colour and size points by `communityLeidenId` and `centralityPageRank` node properties when they are present. If these properties are absent (i.e. the `graph-algorithms` domain has not been run first), the chart falls back to uniform colour and size.

For the richest visualisation, run the `graph-algorithms` domain before `nodeEmbeddingsPython.sh`:

1. Run `centralityCsv.sh` (writes `centralityPageRank`)
2. Run `communityCsv.sh` (writes `communityLeidenId`)
3. Run `nodeEmbeddingsCsv.sh` (writes embedding properties)
4. Run `nodeEmbeddingsPython.sh` (generates charts coloured by community)

## Note: GraphSAGE

GraphSAGE query files are present in [`queries/node-embeddings/`](./queries/node-embeddings/) but are **not** wired into `nodeEmbeddingsCsv.sh`. GraphSAGE requires supervised training data (node labels) which is not available in the generic pipeline. The files are retained for future use.
