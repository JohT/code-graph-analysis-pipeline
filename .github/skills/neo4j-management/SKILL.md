---
name: neo4j-management
description: "Manage a local Neo4j database for code graph analysis. Use when: starting Neo4j, stopping Neo4j, detecting if Neo4j is running, checking Neo4j status, answering 'Is Neo4j running?', 'Is Neo4j currently running?', 'where is Neo4j running?', increasing Neo4j memory, switching analysis workspace, troubleshooting Neo4j, setting up Neo4j."
argument-hint: "is neo4j running | detect | start [workspace] | stop | memory | setup"
---

# Neo4j Management

Manage the local Neo4j graph database lifecycle: detect, start, stop, reconfigure memory.

**Quick reference:**

| Action | Script | Typical trigger |
|--------|--------|-----------------|
| Detect | `detectNeo4j.sh` / `detectNeo4jWindows.sh` | First step always |
| Start  | `startNeo4j.sh` | Neo4j not running |
| Stop   | `stopNeo4j.sh` | Free resources, switch workspace |
| Memory | `useNeo4jHighMemoryProfile.sh` | Out-of-memory or slow queries |
| Setup  | Use `analyze.sh` (see [GETTING_STARTED](../../GETTING_STARTED.md)) | New installation |

## When to Use

- User asks to start, stop, or check on Neo4j
- User wants to switch to a different analysis workspace
- User runs into memory issues (heap, page cache) and wants to increase Neo4j memory
- User asks to set up or install Neo4j

## Domain Scripts

The scripts live in `domains/neo4j-management/`. **Detection scripts** (`detectNeo4j.sh`, `detectNeo4jWindows.sh`) inspect the process table and can be run from **any directory**, including the repository root. **Start/stop/configure scripts** must be run from the **analysis workspace directory** (e.g. `temp/my-project`).

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

Always run the detect script first — do **not** attempt to read processes, ports, or any other signals manually before the script has been executed.

Determine the operating system. On **Windows** (WSL / Git Bash), run:

```shell
./domains/neo4j-management/detectNeo4jWindows.sh
```

On **Linux or macOS**, run:

```shell
./domains/neo4j-management/detectNeo4j.sh
```

If the script produces no output at all, run it a **second time** before drawing any conclusions. Only if the second run also returns nothing, treat it as equivalent to `Neo4j not running`.

The output is one of:

- `Neo4j not running`
- `Neo4j running in <path> (workspace: <name>)` — workspace successfully identified
- `Neo4j running in <path>` — path found but workspace could not be derived
- `Neo4j running in (path undetermined)` — Neo4j is running but the path could not be read

#### Workspace identified `(workspace: <name>)`

The analysis workspace directory is the path **before** the `/tools` segment. For example, if the path is `/Users/me/repo/temp/my-project/tools/neo4j-community-2026.01.4`, the workspace is `/Users/me/repo/temp/my-project`. Inform the user and `cd` into that directory.

#### Path found but no workspace in parentheses

Neo4j is running outside the standard `temp/<workspace>/tools/...` layout.
Ask the user if they know the workspace directory. If yes, `cd` into it and continue.
If no — see [Troubleshooting guide](./references/troubleshooting.md) for manual stop and kill commands.

#### Path undetermined

Neo4j is running but the path cannot be read. Ask the user to run:

```shell
ps -eo pid,command | grep -i neo4j | grep -v grep
```

Once the path is identified, follow the "Path found" branch above or the [Troubleshooting guide](./references/troubleshooting.md).

### Step 2 — Decide Based on User Intent and Neo4j State

#### Neo4j is NOT running + user wants to start it

1. Ask the user which analysis workspace to use (e.g. `temp/my-project`) if not already known.
2. `cd` into the analysis workspace directory.
3. Prompt the user for the Neo4j password:
   > "What is your `NEO4J_INITIAL_PASSWORD`? (You can skip this if you prefer to set it yourself in the terminal — just type `skip` or press Enter.)"

   - If the user provides a password, generate the export command:
     ```shell
     export NEO4J_INITIAL_PASSWORD=<provided-password>
     ```
   - If the user skips, remind them to run the export themselves before starting:
     > "Please run `export NEO4J_INITIAL_PASSWORD=<your-password>` in your terminal before starting Neo4j."
4. Start Neo4j:
   ```shell
   ./startNeo4j.sh
   ```

#### Neo4j IS running + user wants to start a DIFFERENT workspace

**Strongly warn the user**: running two analysis workspaces against the same Neo4j instance corrupts data by mixing results from different projects.

Recommend stopping the current analysis first:

```shell
cd <current-workspace>
./stopNeo4j.sh
```

Only proceed with starting the new workspace after the user confirms they have stopped the old one.

#### Neo4j IS running + user wants to stop it

`cd` into the workspace where Neo4j is running, then:

```shell
./stopNeo4j.sh
```

#### User reports memory issues

Apply the high-memory configuration template. Neo4j must be **stopped** first.

```shell
cd <workspace>
./stopNeo4j.sh
./useNeo4jHighMemoryProfile.sh
./startNeo4j.sh
```

### Step 3 — Setup / Installation Requests

> **Always recommend using `analyze.sh` first.** It handles download, installation, configuration, start, and stop automatically via profiles. Point the user to the [GETTING_STARTED guide](../../GETTING_STARTED.md).

Only assist with a manual `setupNeo4j.sh` invocation if the user can explain a concrete reason why the automated `analyze.sh` workflow does not fit their needs (e.g. custom Neo4j version, enterprise edition, non-standard directory layout).

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
