# Graph Algorithms Domain — Copied Files

This document lists the original source locations of Cypher query files that were copied into this domain.
The originals **remain in place** and are not deleted. This list is maintained for traceability.

## Centrality Queries

Copied from [`cypher/Centrality/`](../../cypher/Centrality/) → [`queries/centrality/`](./queries/centrality/)

All 43 files in `cypher/Centrality/` were copied verbatim.

## Community Detection Queries

Copied from [`cypher/Community_Detection/`](../../cypher/Community_Detection/) → [`queries/community-detection/`](./queries/community-detection/)

All 64 files in `cypher/Community_Detection/` were copied verbatim.

## Similarity Queries

Copied from [`cypher/Similarity/`](../../cypher/Similarity/) → [`queries/similarity/`](./queries/similarity/)

All 10 files in `cypher/Similarity/` were copied verbatim.

## Not Copied

The following files are referenced from their central locations and are **not** copied into this domain:

- [`cypher/Dependencies_Projection/`](../../cypher/Dependencies_Projection/) — projection utilities used by all domains
- [`cypher/Node_Embeddings/`](../../cypher/Node_Embeddings/) — used only as HDBSCAN preprocessing input in `communityCsv.sh`
- [`scripts/projectionFunctions.sh`](../../scripts/projectionFunctions.sh) — shell projection helpers
- [`scripts/executeQueryFunctions.sh`](../../scripts/executeQueryFunctions.sh) — Cypher execution helpers
