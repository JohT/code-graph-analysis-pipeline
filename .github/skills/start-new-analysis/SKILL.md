---
name: start-new-analysis
description: Use when user wants to start a new code analysis, analyze Java or TypeScript project, set up a new analysis workspace, or run code-graph-analysis-pipeline for the first time on a project.
---

# Start New Analysis

Sets up, runs new analysis end-to-end.

**Prereq:** Run all commands from repo root (`code-graph-analysis-pipeline/`). Requires `NEO4J_INITIAL_PASSWORD` set.

---

## Step 1 — Choose Path

Ask: "Analyze pre-built example or custom project?"

| Option | Project |
|--------|---------|
| AxonFramework | Java event-sourcing library |
| ReactRouter | TypeScript UI routing library |
| Custom | Any Java or TypeScript project |

If **AxonFramework** or **ReactRouter**: skip Steps 4–6, go straight to Step 2 → 3 → [Example Script](#example-scripts).
If **Custom**: follow all steps.

---

## Step 2 — Neo4j Password

Ask: "Local run on own machine? If yes, I can set `NEO4J_INITIAL_PASSWORD` — provide password. Otherwise, run `export NEO4J_INITIAL_PASSWORD=<password>` in terminal and confirm when done."

If user provides password:
```shell
export NEO4J_INITIAL_PASSWORD=<provided-password>
```

> **Security warning:** Only accept the password directly in agent context when the user explicitly confirms this is a local run on their own machine. Never log, echo, or display the password value after setting it.

---

## Step 3 — Neo4j State

Run from repo root:
```shell
./domains/neo4j-management/detectNeo4j.sh
```

| Result | Action |
|--------|--------|
| `Neo4j not running` | proceed |
| `Neo4j running in <path>` | **warn**: data from different projects will mix. Ask user to stop it: `cd <workspace> && ./stopNeo4j.sh`. Only continue after confirmed stopped. |

---

## Step 3b — Check Compatibility + Advise Report Type

Run from repo root:
```shell
./scripts/checkCompatibility.sh
```

Read output and advise report type:

| Output | Recommended flag |
|--------|-----------------|
| ❌ on required deps (java, git, curl, jq…) | Fix missing deps first — analysis will fail |
| ✅ required, but ❌/⚠️ on Python env (conda/venv) or python/pip | `--report Csv` |
| ✅ required + ✅ Python env + ✅ python/pip | `--report Python` (no PDF) or full (no flag) |
| ✅ all including jupyter | `--report Jupyter` (adds PDF, needs Chromium) |
| ✅ npx/npm or dot | add `--report Visualization` or run full |

Tell user recommended `--report` flag, reason. Confirm before proceeding.

---

## Example Scripts

**AxonFramework** — ask for optional version (omit = latest):
```shell
./scripts/examples/analyzeAxonFramework.sh [<version>] --report <flag>
```
Example: `./scripts/examples/analyzeAxonFramework.sh 5.0.3 --report Csv`

**ReactRouter** — ask for optional version (omit = latest):
```shell
./scripts/examples/analyzeReactRouter.sh [<version>] --report <flag>
```
Example: `./scripts/examples/analyzeReactRouter.sh 7.5.0 --report Csv`

Both scripts: auto-detect latest if omitted, call `init.sh`, download artifacts, run `analyze.sh`. No further steps — skip to [Step 7](#step-7--start-analysis).

---

## Step 4 — Initialize (Custom Only)

From **repo root**:
```shell
./init.sh <name>
cd temp/<name>
```

Creates `artifacts/`, `source/`, forwarding scripts (`analyze.sh`, `startNeo4j.sh`, `stopNeo4j.sh`) in workspace.
Fails if `NEO4J_INITIAL_PASSWORD` not set.

---

## Step 5 — Add Code to Analyze (Custom Only)

Ask: "Project Java, TypeScript, or both?"

### Java

Ask: "Copy manually, symlink, or download from Maven Central?"

Option A — Copy/move manually:
```shell
cp /path/to/*.jar temp/<name>/artifacts/
```

Option B — Symlink:
```shell
ln -s /absolute/path/to/file.jar temp/<name>/artifacts/
```

Option C — Download from Maven Central (from `temp/<name>`):
```shell
./../../scripts/downloadMavenArtifact.sh -g <groupId> -a <artifactId> -v <version> [-t jar]
```
Example: `-g org.axonframework -a axon-messaging -v 4.10.0`

### TypeScript

Option A — Download via helper (clone + dep install, from `temp/<name>`):
```shell
./../../scripts/downloader/downloadTypescriptProject.sh \
  --url <git-clone-url> \
  --version <version> \
  [--tag <git-tag>] \
  [--packageManager npm|pnpm|yarn]
```

Option B — Clone manually into `source/` (from `temp/<name>`):
```shell
git clone <repo-url> ./source/<project-name>
# shallow clone (no git history):
git clone --depth 1 <repo-url> ./source/<project-name>
# symlink:
ln -s /absolute/path/to/project ./source/<project-name>
```

Install JS/TS deps:
```shell
cd source/<project-name> && npm install   # or: pnpm install / yarn install
cd ../..
```

---

## Step 6 — Git History (Custom Only, Optional)

Ask: "Include git history analysis (change frequency, author stats)?"

If yes: git repo must be in `source/`. If not already cloned (from `temp/<name>`):
```shell
# Full history:
git clone <repo-url> ./source/<project-name>
# Bare clone (Java only, no source needed):
git clone --bare <repo-url> ./source/<project-name>.git
```

Default import mode: `plugin` (jQAssistant handles automatically — recommended).
Override with env var if needed:

| `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` | Effect |
|--------------------------------------------|--------|
| `plugin` | default, recommended |
| `none` | skip git import |
| `aggregated` | monthly summary, smaller dataset |
| `full` | all commits |

```shell
export IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=none   # example: disable
```

---

## Step 7 — Start Analysis

Use recommended `--report` from Step 3b. Run from `temp/<name>`:
```shell
./analyze.sh --report Csv
```

| Flag | Requires | Use when |
|------|----------|----------|
| `--report Csv` | nothing extra | data only, fastest |
| `--report Python` | Python + Conda/venv | charts, no PDF |
| `--report Jupyter` | + Chromium | charts + PDF |
| `--report Visualization` | GraphViz or npx | graph images |
| `--explore` | nothing | manual Neo4j exploration only |

After analysis: `http://localhost:7474/browser` — user: `neo4j`, password from Step 2.

**Optional flags:**
- `--keep-running` — Neo4j stays up after analysis (useful for rerunning reports)
- `--domain <name>` — single domain only (e.g. `anomaly-detection`, `git-history`)
