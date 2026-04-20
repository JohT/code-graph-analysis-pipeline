---
name: neo4j-management
description: "Manage a local Neo4j database for code graph analysis. Use when: starting Neo4j, stopping Neo4j, detecting if Neo4j is running, checking Neo4j status, answering 'Is Neo4j running?', 'Is Neo4j currently running?', 'where is Neo4j running?', increasing Neo4j memory, switching analysis workspace, troubleshooting Neo4j, setting up Neo4j."
argument-hint: "is neo4j running | detect | start [workspace] | stop | memory | setup"
---

# Neo4j Management

Manage local Neo4j graph database lifecycle: detect, start, stop, reconfigure memory.

**Quick reference:**

| Action | Script | Typical trigger |
|--------|--------|-----------------|
| Detect | `detectNeo4j.sh` / `detectNeo4jWindows.sh` | First step always |
| Start  | `startNeo4j.sh` | Neo4j not running |
| Stop   | `stopNeo4j.sh` | Free resources, switch workspace |
| Memory | `useNeo4jHighMemoryProfile.sh` | Out-of-memory or slow queries |
| Setup  | Use `analyze.sh` (see [GETTING_STARTED](./../../../GETTING_STARTED.md)) | New installation |

## When to Use

- User asks to start, stop, or check Neo4j
- User wants to switch analysis workspace
- User has memory issues (heap, page cache)
- User asks to set up or install Neo4j

## Domain Scripts

Scripts live in `domains/neo4j-management/`. **Detection scripts** (`detectNeo4j.sh`, `detectNeo4jWindows.sh`) inspect process table — run from **any directory** including repo root. **Start/stop/configure scripts** must run from **analysis workspace directory** (e.g. `temp/my-project`).

| Script | Purpose |
|--------|---------|
| `detectNeo4j.sh` | Detect if Neo4j is running (Linux/macOS) |
| `detectNeo4jWindows.sh` | Detect if Neo4j is running (WSL/Git Bash on Windows) |
| `startNeo4j.sh` | Start Neo4j and wait until queryable |
| `stopNeo4j.sh` | Stop Neo4j gracefully |
| `useNeo4jHighMemoryProfile.sh` | Reconfigure with high-memory template |
| `configureNeo4j.sh` | Apply a configuration template |

### Internal scripts — do NOT use directly

- `setupNeo4jInitialPassword.sh`
- `waitForNeo4jHttpFunctions.sh`
- `testConfigureNeo4j.sh`

## Procedure

### Step 1 — Detect if Neo4j Is Running

Always run detect script first. Don't read processes, ports, or other signals manually before script runs.

On **Windows** (WSL/Git Bash):

```shell
./domains/neo4j-management/detectNeo4jWindows.sh
```

On **Linux or macOS**, run:

```shell
./domains/neo4j-management/detectNeo4j.sh
```

No output: run second time before concluding. Two empty runs = `Neo4j not running`.

Output is one of:

- `Neo4j not running`
- `Neo4j running in <path> (workspace: <name>)` — workspace identified
- `Neo4j running in <path>` — path found, workspace not derived
- `Neo4j running in (path undetermined)` — running, path unreadable

#### Workspace identified `(workspace: <name>)`

Workspace = path **before** `/tools` segment. Example: `/Users/me/repo/temp/my-project/tools/neo4j-community-2026.01.4` → workspace `/Users/me/repo/temp/my-project`. Inform user, `cd` into it.

#### Path found but no workspace in parentheses

Neo4j running outside standard `temp/<workspace>/tools/...` layout.
Ask user for workspace dir. If known, `cd` into it.
If unknown — see [Troubleshooting guide](./references/troubleshooting.md).

#### Path undetermined

Ask user to run:

```shell
ps -eo pid,command | grep -i neo4j | grep -v grep
```

Path identified → follow "Path found" branch or [Troubleshooting guide](./references/troubleshooting.md).

### Step 2 — Decide Based on User Intent and Neo4j State

#### Neo4j is NOT running + user wants to start it

1. Ask user for workspace (e.g. `temp/my-project`) if unknown.
2. `cd` into workspace.
3. Prompt user for Neo4j password:
   > "What is your `NEO4J_INITIAL_PASSWORD`? (You can skip this if you prefer to set it yourself in the terminal — just type `skip` or press Enter.)"

   - Password provided:
     ```shell
     export NEO4J_INITIAL_PASSWORD=<provided-password>
     ```
   - Skipped: remind user to run export before starting.
4. Start Neo4j:
   ```shell
   ./startNeo4j.sh
   ```

#### Neo4j IS running + user wants to start a DIFFERENT workspace

**Warning:** Running two analysis workspaces against the same Neo4j instance corrupts data by mixing results from different projects. Stop current workspace first.

```shell
cd <current-workspace>
./stopNeo4j.sh
```

Continue only after user confirms stopped.

#### Neo4j IS running + user wants to stop it

`cd` into workspace, then:

```shell
./stopNeo4j.sh
```

#### User reports memory issues

Neo4j must be **stopped** first.

```shell
cd <workspace>
./stopNeo4j.sh
./useNeo4jHighMemoryProfile.sh
./startNeo4j.sh
```

### Step 3 — Setup / Installation Requests

> **Always recommend `analyze.sh` first.** Handles download, install, config, start, stop via profiles. Point user to [GETTING_STARTED guide](./../../../GETTING_STARTED.md).

Only assist with manual `setupNeo4j.sh` if user has concrete reason `analyze.sh` won't work (custom version, enterprise, non-standard layout).

## Environment Variables

All are set automatically by `analyze.sh` in normal runs. For manual operation:

| Variable | Default | Required |
|----------|---------|----------|
| `NEO4J_INITIAL_PASSWORD` | — | **Yes** |
| `NEO4J_VERSION` | `2026.01.4` | No |
| `NEO4J_EDITION` | `community` | No |
| `NEO4J_HTTP_PORT` | `7474` | No |
| `TOOLS_DIRECTORY` | `tools` | No |

## Important Warnings

- **Stop Neo4j before switching projects.** Data from different projects will mix in the same database instance otherwise.
- **`NEO4J_INITIAL_PASSWORD` must be set** before starting or setting up Neo4j.
- Scripts expect to be run from the analysis workspace directory (where the `tools/` folder lives).
- **Docker is not supported.** Detection and management scripts rely on native process inspection (`ps`) and do not detect or manage Neo4j running inside a Docker container.
