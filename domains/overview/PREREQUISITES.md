# Overview Domain — Prerequisites

This domain requires the following to be in place before running. These are provided by the central pipeline and are **not** set up by this domain.

## Required: Neo4j Running with Scanned Code

Neo4j must be running with at least one code artifact (Java JAR/WAR or TypeScript project) scanned and imported into the graph database.

See [scripts/setupJQAssistant.sh](../../scripts/setupJQAssistant.sh) and [GETTING_STARTED.md](../../GETTING_STARTED.md) for setup instructions.

## Required: NEO4J_INITIAL_PASSWORD Environment Variable

The Python chart generator (`overviewCharts.py`) reads data directly from Neo4j via the Bolt protocol. The `NEO4J_INITIAL_PASSWORD` environment variable must be set so the driver can authenticate.

```shell
export NEO4J_INITIAL_PASSWORD=<your-neo4j-password>
```

## Required: jQAssistant Java Plugin (for Java-specific metrics)

The following properties on `Method` nodes are used for complexity and line-count distributions:

- `effectiveLineCount` — effective lines of code per method
- `cyclomaticComplexity` — cyclomatic complexity per method

These properties are set by the **jQAssistant Java Plugin** during the scan phase. They are not present for TypeScript-only projects; the affected queries will return empty results, which are silently skipped by the chart generator.

## Not Required: Dependency Enrichment or Projections

This domain does **not** depend on:

- `DEPENDS_ON` relationship weight properties from [`cypher/Dependency_Enrichment/`](../../cypher/Dependency_Enrichment/)
- Graph projection functions from [`scripts/projectionFunctions.sh`](../../scripts/projectionFunctions.sh)
- The Neo4j Graph Data Science (GDS) plugin

It queries raw node and relationship counts and structural metadata only.

## Optional: Prior Domains

The overview domain is fully self-contained and can be run independently. No other domain needs to run first.
