# Neo4j Management Domain

Owns the full lifecycle of the local Neo4j Graph Database: download, install, configure, start, and stop.

## When to use

**Normally you don't need this.** [`analyze.sh`](./../../scripts/analysis/analyze.sh) handles setup, start, and stop automatically. Environment variables are set by the profile (`--profile`) — no manual configuration needed.

Use this domain directly only for on-demand tasks outside a full analysis run:

- **Start / stop** Neo4j manually (e.g. after a reboot, or to free resources)
- **Reconfigure** without re-running the full analysis (e.g. increase memory)
- **Check** whether and where Neo4j is installed and running

> ⚠️ **Stop Neo4j before switching projects.** If Neo4j keeps running across projects, data from different projects can end up in the same database instance.

## Scripts

### Entry points

| Script | Purpose |
|--------|---------|
| [startNeo4j.sh](./startNeo4j.sh) | Start Neo4j and wait until it is queryable |
| [stopNeo4j.sh](./stopNeo4j.sh) | Stop Neo4j gracefully |
| [configureNeo4j.sh](./configureNeo4j.sh) | Apply a configuration template from `configuration/` |
| [useNeo4jHighMemoryProfile.sh](./useNeo4jHighMemoryProfile.sh) | Apply the high-memory configuration template |
| [detectNeo4j.sh](./detectNeo4j.sh) | Detect whether Neo4j is installed in the tools directory |
| [detectNeo4jWindows.sh](./detectNeo4jWindows.sh) | Windows-specific detection helper |
| [setupNeo4j.sh](./setupNeo4j.sh) | Install Neo4j with APOC and Graph Data Science — **called by `analyze.sh` automatically** |

### Internal helpers _(not for direct use)_

| Script | Purpose |
|--------|---------|
| [setupNeo4jInitialPassword.sh](./setupNeo4jInitialPassword.sh) | Set the initial Neo4j password (sourced by `setupNeo4j.sh`) |
| [waitForNeo4jHttpFunctions.sh](./waitForNeo4jHttpFunctions.sh) | HTTP polling functions (sourced by `startNeo4j.sh` / `stopNeo4j.sh`) |

### Tests

| Script | Purpose |
|--------|---------|
| [testConfigureNeo4j.sh](./testConfigureNeo4j.sh) | Integration tests for `configureNeo4j.sh` |

## Configuration templates

Stored under `configuration/`. Select a template via `NEO4J_CONFIG_TEMPLATE` (set automatically by the profile in normal runs).

| Template | Use case |
|----------|---------|
| [template-neo4j.conf](./configuration/template-neo4j.conf) | Default (Neo4j v5) |
| [template-neo4j-high-memory.conf](./configuration/template-neo4j-high-memory.conf) | Increased heap and page-cache for large graphs |
| [template-neo4j-low-memory.conf](./configuration/template-neo4j-low-memory.conf) | Reduced memory for constrained environments |
| [template-neo4j-v4.conf](./configuration/template-neo4j-v4.conf) | Default (Neo4j v4) |
| [template-neo4j-v4-low-memory.conf](./configuration/template-neo4j-v4-low-memory.conf) | Low-memory (Neo4j v4) |

## On-demand examples

Run from an analysis workspace (e.g. `temp/MyProject`) using the workspace forwarding scripts, or from the repo root using the full path.

```shell
export NEO4J_INITIAL_PASSWORD=my-secret

./startNeo4j.sh                    # start  (workspace shortcut)
./stopNeo4j.sh                     # stop   (always do this before switching projects)
./useNeo4jHighMemoryProfile.sh     # reconfigure with high-memory template

# From the repo root:
./domains/neo4j-management/startNeo4j.sh
./domains/neo4j-management/stopNeo4j.sh
```

## Environment variables

All variables are set automatically by `analyze.sh` via the selected profile in normal runs. See [`ENVIRONMENT_VARIABLES.md`](../../ENVIRONMENT_VARIABLES.md) for the full generated reference.

| Variable | Default | Description |
|----------|---------|-------------|
| `NEO4J_INITIAL_PASSWORD` | _(required)_ | Initial password for the local Neo4j instance |
| `NEO4J_VERSION` | _(set in profile)_ | Neo4j version to download/use |
| `NEO4J_EDITION` | `community` | `community` or `enterprise` |
| `NEO4J_HTTP_PORT` | `7474` | HTTP port |
| `NEO4J_BOLT_PORT` | `7687` | Bolt protocol port |
| `NEO4J_CONFIG_TEMPLATE` | `template-neo4j.conf` | Configuration template filename |
| `TOOLS_DIRECTORY` | `tools` | Directory where Neo4j is installed |
| `NEO4J_MANAGEMENT_DIR` | _(auto-resolved)_ | Absolute path to this domain directory |
| `SCRIPTS_DIR` | _(auto-resolved)_ | Absolute path to the shared `scripts/` directory |
