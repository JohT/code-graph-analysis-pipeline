# Strongly and Weakly Connected Components

Centralized Cypher queries for computing strongly connected components (SCC) and weakly connected components (WCC) in dependency graphs.

## What are Connected Components?

**Strongly Connected Components (SCC)** identify groups of code units (packages, modules, classes) that form circular dependency cycles. All units in an SCC can reach all other units by following directed dependency edges. Finding SCCs reveals tightly coupled subsystems and architectural problem areas that may require refactoring.

**Weakly Connected Components (WCC)** are broader groupings where nodes are connected if you ignore edge direction. While SCCs identify specific cyclic structures, WCCs show connected island regions within a dependency graph, useful for understanding overall graph connectivity and isolation patterns.

## Why They Matter

- **Cyclic Dependencies**: SCCs pinpoint problematic cycles (architecture anti-patterns)
- **Modularity**: WCCs help assess independence between subsystems
- **Refactoring Guidance**: Visualizing SCCs/WCCs suggests where to break coupling
- **Quality Metrics**: Component count and size indicate architectural health
- **Graph Structure Guarantees**: Creating all components (including single-member) ensures the component graph itself is cycle-free, enabling reliable downstream algorithms like topological sort

## Projection Requirements

Queries expect the dependencies projection to be created with a specific naming convention:
- **Directed SCC analysis** requires a projection named `{dependencies_projection}-cleaned`
- This projection is created by the standard `createDirectedDependencyProjection()` shell function
- The `-cleaned` suffix must be preserved; altering projection naming will break SCC analysis

## Query Files

| File | Purpose |
| ---- | ------- |
| `StronglyConnectedComponent_Write.cypher` | Compute SCC and write `communityStronglyConnectedComponentId` property to nodes |
| `StronglyConnectedComponent_Exists.cypher` | Check if SCC has already been computed |
| `StronglyConnectedComponent_CreateNode.cypher` | Create SCC community node representing the cycle |
| `StronglyConnectedComponent_CreateDependency.cypher` | Link SCC communities based on inter-community dependencies |
| `WeaklyConnectedComponent_Write.cypher` | Compute WCC and write `communityWeaklyConnectedComponentId` property |
| `WeaklyConnectedComponent_Exists.cypher` | Check if WCC has already been computed |

## Usage

Queries expect these parameters:

- `$dependencies_projection` — Name of the in-memory GDS graph projection (e.g., `"java-package-cycles"`)
- `$dependencies_projection_node` — Node label to analyze (e.g., `"Package"`, `"Module"`)
- `$dependencies_projection_weight_property` — Optional weight property for ranking edges (default: unweighted)

Example invocation from shell:

```bash
execute_cypher "cypher/Connected_Components/StronglyConnectedComponent_Write.cypher" \
  "dependencies_projection=java-package-cycles" \
  "dependencies_projection_node=Package" \
  "dependencies_projection_weight_property=weight25PercentInterfaces"
```

## Integration

These queries are used by multiple analysis domains:

- `domains/cyclic-dependencies/` — Identifies and reports cyclic dependency patterns
- `domains/anomaly-detection/` — Detects anomalies based on component structure
- `domains/archetypes/` — Classifies code patterns using component membership
- `domains/internal-dependencies/` — Analyzes architectural structure
