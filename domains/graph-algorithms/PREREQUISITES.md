# Graph Algorithms Domain — Prerequisites

This domain requires the following to be in place before running. These are provided by the central pipeline and are **not** set up by this domain.

## Required: Neo4j with GDS Plugin

Neo4j must be running with the **Graph Data Science (GDS) plugin** installed. The GDS plugin provides all centrality, community detection, and similarity algorithms used by this domain.

See [scripts/setupJQAssistant.sh](../../scripts/setupJQAssistant.sh) and [GETTING_STARTED.md](../../GETTING_STARTED.md) for setup instructions.

## Required: Scanned Code Artifacts

At least one code artifact (Java JAR/WAR or TypeScript project) must be scanned and imported into the graph database before running this domain.

The `DEPENDS_ON` relationships between `Type`, `Package`, `Artifact`, and `Module` nodes must exist and have weight properties set.

## Required: Dependency Enrichment (Weight Properties)

The following weight properties must be set on `DEPENDS_ON` relationships before running projections:

- `weight` — basic dependency weight
- `weightInterfaces` — weight adjusted for interface usage
- `weight25PercentInterfaces` — weight with 25% interface contribution

These are set by the Cypher queries in [`cypher/Dependency_Enrichment/`](../../cypher/Dependency_Enrichment/).

## Required: Dependencies Projection Utilities

The graph projection functions used by this domain are sourced from:

- [`scripts/projectionFunctions.sh`](../../scripts/projectionFunctions.sh) — provides `createUndirectedDependencyProjection`, `createDirectedDependencyProjection`, `createUndirectedJavaTypeDependencyProjection`, `createDirectedJavaTypeDependencyProjection`
- [`cypher/Dependencies_Projection/`](../../cypher/Dependencies_Projection/) — Cypher files for projection creation, mutation, write-back, and clean-up

These are **not** copied into this domain — they are referenced from the central `cypher/` and `scripts/` directories.


## Optional: Type Labels

For Java Type projections (`createUndirectedJavaTypeDependencyProjection`), type classification labels (`PrimitiveType`, `Void`, `JavaType`, `ResolvedDuplicateType`) should be set by [`cypher/Types/`](../../cypher/Types/).
