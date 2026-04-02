# Internal Dependencies Domain — Prerequisites

The following are provided by the central pipeline and must run **before** this domain executes.
They are not copied into this domain; they are sourced or referenced from the central pipeline locations.

---

## 1. Neo4j Running with Scanned Artifacts

Neo4j must be running and all artifacts must have been scanned and loaded into the graph database
before any script in this domain is executed.

See the main [README.md](../../README.md) and [GETTING_STARTED.md](../../GETTING_STARTED.md) for setup instructions.

---

## 2. DEPENDS_ON Relationships between Types

The graph must contain `DEPENDS_ON` relationships between `Type`, `Package`, and `Artifact` nodes.
These are created by the jQAssistant scan step.

---

## 3. Type Labels

The following type classification labels must exist on the relevant nodes:

| Label | Purpose |
|-------|---------|
| `PrimitiveType` | Java primitives (int, boolean, …) |
| `Void` | Java void return type |
| `JavaType` | Resolved Java type (class, interface, enum) |
| `ResolvedDuplicateType` | Duplicate type resolved across artifacts |

**Cypher source:** [`cypher/Types/`](../../cypher/Types/)

---

## 4. Weight Properties on DEPENDS_ON Relationships

The following weight properties must exist on `DEPENDS_ON` relationships:

| Property | Description |
|----------|-------------|
| `weight` | Total count of dependencies |
| `weightInterfaces` | Dependency weight counting only interface types |
| `weight25PercentInterfaces` | Blended weight: 75% class + 25% interface weight |

**Cypher source:** [`cypher/DependsOn_Relationship_Weights/`](../../cypher/DependsOn_Relationship_Weights/)

---

## 5. Dependencies Projection

The Graph Data Science (GDS) library projection functions must be available.
Key functions used by path finding and topological sort:

- `createDirectedDependencyProjection` — creates a directed in-memory graph projection for a given node label and weight property
- `createDirectedJavaTypeDependencyProjection` — specialized projection for Java `Type` nodes
- `deleteDirectedDependencyProjection` — removes the projection after use

**Cypher source:** [`cypher/Dependencies_Projection/`](../../cypher/Dependencies_Projection/)

> **Note:** A follow-up task is planned to rethink the placement of core dependency Cypher files within the pipeline.

---

## 6. Projection Functions Shell Script

The shell functions wrapping the Dependencies Projection Cypher queries are provided by:

```
scripts/projectionFunctions.sh
```

This script is sourced directly from `../../scripts/projectionFunctions.sh` by the domain entry point scripts.

---

## 7. TypeScript Enrichment

For TypeScript analyses, the following enrichment must have been applied:

| Enrichment | Description |
|-----------|-------------|
| `namespace` property | Module namespace |
| `moduleName` property | Module name |
| `isNodeModule` property | Whether the module is a Node.js built-in |
| `isExternalImport` property | Whether the import is external |
| `IS_IMPLEMENTED_IN` relationships | Links TypeScript declarations to source modules |
| `DEPENDS_ON` between modules | Propagated from resolved imports |
| `PROVIDED_BY_NPM_DEPENDENCY` links | Links modules to npm package dependencies |
| `lowCouplingElement25PercentWeight` | Dependency weight for TypeScript modules |

**Cypher source:** [`cypher/Typescript_Enrichment/`](../../cypher/Typescript_Enrichment/)

---

## 8. General Enrichment

The following properties must exist on `File` nodes, required for file distance calculations:

| Property | Description |
|----------|-------------|
| `name` | Name of the file |
| `extension` | File extension |

**Cypher source:** [`cypher/General_Enrichment/`](../../cypher/General_Enrichment/)

---

## 9. Metrics (Indirect)

Dependency degree calculations (incoming/outgoing `DEPENDS_ON` counts) are used indirectly
by several internal dependency queries.

**Cypher source:** [`cypher/Metrics/`](../../cypher/Metrics/)
