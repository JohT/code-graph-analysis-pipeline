# Plan: Internal SCIP-Java Pipeline Smoke Test

## Problem

Add an internal CI workflow that smoke-tests and showcases a **pure SCIP-based analysis of a Java project
(AxonFramework) without jQAssistant** — mirroring what
`.github/workflows/internal-scip-jqassistant-typescript-code-example.yml` does for TypeScript.

## Key Decisions (confirmed with user)

| Topic | Decision |
|---|---|
| `installScipCli.sh` location | Move to `examples/` and update all references |
| scip-java version | 0.12.3 (proven safe; 0.13.2 bash bug likely affects Linux too) |
| init.sh in workflow | Skip — just `mkdir`, consistent with TypeScript reference |
| scip-java install target | `./tools/scip-java/` (consistent with SCIP CLI in `./tools/scip-cli/`) |
| Cross-platform `sed -i` | OS detection: `sed -i ''` on macOS, `sed -i` on Linux |
| Tool path defaults | Env vars with workspace defaults; caller passes absolute paths |
| Upload scope | Only `.scip.json` files (what the pipeline needs) |
| Workflow filename | `internal-scip-java-code-example.yml` |
| Analysis name | `AxonFramework-scip-5.1.1` |
| Renovate tracking | Add `SCIP_JAVA_VERSION` custom manager |
| `SCRIPTS.md` | Skip — auto-regenerated after merge |
| Changelog | No entry |
| AxonFramework modules | 5: common, conversion, modelling, eventsourcing, messaging |

## Approach

Work in two phases:

1. **Refactor** — move `installScipCli.sh` to `examples/`, fix its SCRIPTS_DIR path, update all
   existing references.
2. **Build** — create the 4 new Java scripts, the workflow, doc updates, and renovate rule.

---

## Files to Create

### `domains/scip-index-import/examples/` (new directory)

**`installScipCli.sh`** — *moved from parent*, SCRIPTS_DIR path corrected (3 levels up instead of 2).

**`installScipJava.sh`** — New. Installs scip-java **0.12.3** to `./tools/scip-java/scip-java`.
- Uses Coursier bootstrap with artifact `com.sourcegraph:scip-java_2.13:0.12.3`
  (different from 0.13.x which uses `org.scip-code:scip-java` — **do not upgrade without
  verifying the Coursier bash wrapper bug is fixed**).
- Requires Java (11+) and curl. Downloads coursier to a temp file, cleans up on exit.
- Idempotent: skips if binary already exists.
- Flags: `--version X.Y.Z`, `--bin-dir <path>`, `--help`.
- Follows bash strict-mode + all shell-scripts conventions.
- `SCIP_JAVA_VERSION=${SCIP_JAVA_VERSION:-"0.12.3"}` — tracked by new Renovate rule.

**`create-scip-index-functions-java.sh`** — Adapted from
`AxonFramework/tools/create-scip-indices-functions.sh`.
- Sourced library (not executed directly).
- `PROJECT_ROOT` — set by caller to the source project root; **no default** (avoid wrong directory).
- `SCIP_JAVA` default: `./tools/scip-java/scip-java` (overridden with absolute path by caller).
- `SCIP` default: `./tools/scip-cli/scip` (overridden with absolute path by caller).
- `OUTPUT_DIR` default: `${PROJECT_ROOT}/target/scip-indices-per-module`.
- `resolve_placeholders_in_json`: cross-platform `sed -i` via OS detection.
- Uses `mvnw` if present in `PROJECT_ROOT`, else `mvn`.

**`createAxonFrameworkScipIndices.sh`** — Adapted from
`AxonFramework/tools/create-scip-indices-per-module-github-actions.sh`.
- Requires `PROJECT_ROOT` env var (AxonFramework source root).
- Computes `PIPELINE_ROOT` from own location (`3 levels up from examples/`) and derives
  absolute paths for `SCIP_JAVA` and `SCIP` before sourcing the functions script.
- Indexes 5 modules with GitHub Actions grouping: `common`, `conversion`, `modelling`,
  `eventsourcing`, `messaging`.
- Each module: `index_module` → `resolve_placeholders_in_json "revision"`.

**`testInstallScipJava.sh`** — Unit tests for `installScipJava.sh`:
- `--help` exits 0 and prints usage.
- Unknown argument exits non-zero with a message.
- `--bin-dir` argument is respected (binary written to given path).
- Idempotency: when a binary already exists, install is skipped (no network call).
- No network access needed — fake binary for the idempotency test.
- Named `test*.sh` so `runTests.sh` auto-discovers it.

### `.github/workflows/internal-scip-java-code-example.yml`

```
name: SCIP Index Java Code Example - Smoke Test (experimental)

jobs:
  prepare-scip-index:
    runs-on: ubuntu-latest
    outputs:
      analysis-name, indices-upload-name, source-repository-branch

    env:
      PROJECT_NAME: AxonFramework
      AXON_FRAMEWORK_VERSION: 5.1.1   # tracked by renovate (existing rule)
      SCIP_VERSION: 0.10.0             # tracked by renovate
      SCIP_JAVA_VERSION: 0.12.3        # tracked by new renovate rule

    steps:
      1. Setup Java 21 (temurin) + Maven cache
      2. Checkout this repository
      3. Set 'analysis-name' output: AxonFramework-scip-5.1.1
      4. Set SOURCE_PATH env var
      5. mkdir -p ./temp
      6. Cache temp/downloads
      7. Clone AxonFramework (--branch axon-5.1.1 --single-branch)
      8. Install SCIP CLI  →  ./domains/scip-index-import/examples/installScipCli.sh
      9. Install scip-java →  ./domains/scip-index-import/examples/installScipJava.sh
      10. Create SCIP indices (export PROJECT_ROOT; run createAxonFrameworkScipIndices.sh)
      11. Generate ARTIFACT_UPLOAD_ID
      12. Set 'indices-upload-name' output
      13. Upload *.scip.json files from target/scip-indices-per-module/

  analyze-code-graph:
    needs: prepare-scip-index
    uses: ./.github/workflows/public-analyze-code-graph.yml
    with:
      analysis-name: ...
      indices-upload-name: ...
      source-repository: https://github.com/AxonFramework/AxonFramework.git
      source-repository-branch: axon-5.1.1
      run-all-domains: true
      analysis-arguments: "--skip-jqassistant --report All"
```

All actions use pinned commit SHAs (look up at implementation time).

---

## Files to Modify

| File | Change |
|---|---|
| `domains/scip-index-import/installScipCli.sh` | **Delete** (moved to `examples/`) |
| `.github/workflows/internal-scip-index-code-example.yml` | Update `installScipCli.sh` path |
| `.github/workflows/internal-scip-jqassistant-typescript-code-example.yml` | Update path |
| `scripts/examples/analyzeReactRouterScip.sh` | Update path (line ~106 + header comment) |
| `scripts/examples/createScipIndexTypescript.sh` | Update path in usage/error messages |
| `SCIP.md` | Fix `installScipCli.sh` path + add "Java SCIP (experimental)" section |
| `domains/scip-index-import/README.md` | Document new `examples/` directory + its scripts |
| `renovate.json` | Add `SCIP_JAVA_VERSION` custom manager |

---

## Renovate Rule (to add)

```json
{
  "description": "Update SCIP_JAVA_VERSION constant in scip-java install script",
  "customType": "regex",
  "fileMatch": ["^domains/scip-index-import/examples/[^/]*\\.sh$"],
  "matchStrings": ["SCIP_JAVA_VERSION=\\$\\{SCIP_JAVA_VERSION:-\\\"?(?<currentValue>.*?)\\\"?\\}"],
  "depNameTemplate": "scip-code/scip-java",
  "datasourceTemplate": "github-releases",
  "extractVersionTemplate": "^v?(?<version>.*)$"
}
```

Comment in `installScipJava.sh`: "Upgrade requires verifying Coursier bash wrapper compatibility
(see `domains/scip-index-import/examples/` README)."

---

## Verification

1. `shellcheck` — all new and modified `.sh` files
2. `scripts/runTests.sh` — auto-discovers and runs `testInstallScipJava.sh`
3. `npx --yes markdown-link-check --quiet --progress --config=markdown-link-check-config.json SCIP.md`
4. `npx --yes markdown-link-check --quiet --progress --config=markdown-link-check-config.json domains/scip-index-import/README.md`

---

## Constraints / Notes

- `install-scip-java-0.12.3.sh` in AxonFramework uses `#!/bin/sh` POSIX style; our version will be `#!/usr/bin/env bash` per project conventions.
- `sed -i ""` in the AxonFramework functions script is macOS-only — replaced with OS detection.
- The AxonFramework pom.xml uses `${revision}` as a Maven placeholder; `resolve_placeholders_in_json "revision"` handles this.
- `createScipIndexFunctionsForJava.sh` is a sourced library, not executable. No shebang, no `set -e` at the top (caller owns that). Actually — bash conventions say every `.sh` file gets a shebang. Since it's sourced-only, we'll use `#!/usr/bin/env bash` but add a comment that it must be sourced, not executed.
- `SCIP_VERSION` and `AXON_FRAMEWORK_VERSION` in the workflow: both already tracked by existing renovate custom managers. No changes needed there.
- No entry in SCRIPTS.md — that file is auto-regenerated post-merge.
