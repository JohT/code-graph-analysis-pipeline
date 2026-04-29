# Node Embeddings Domain — Copied Files

This document lists the original source locations of Cypher query files that were copied into this domain.
The originals **remain in place** and are not deleted. This list is maintained for traceability.

## Node Embeddings Queries

Copied from [`cypher/Node_Embeddings/`](../../cypher/Node_Embeddings/) → [`queries/node-embeddings/`](./queries/node-embeddings/)

All 22 files in `cypher/Node_Embeddings/` were copied verbatim. This includes FastRP, HashGNN, Node2Vec, and GraphSAGE queries.

Note: GraphSAGE queries are present in `queries/node-embeddings/` but are **not** wired into `nodeEmbeddingsCsv.sh`. See [PREREQUISITES.md](./PREREQUISITES.md) for details.

## Not Copied

The following files are referenced from their central locations and are **not** copied into this domain:

- [`cypher/Dependencies_Projection/`](../../cypher/Dependencies_Projection/) — projection utilities used by all domains
- [`scripts/projectionFunctions.sh`](../../scripts/projectionFunctions.sh) — shell projection helpers
- [`scripts/executeQueryFunctions.sh`](../../scripts/executeQueryFunctions.sh) — Cypher execution helpers
