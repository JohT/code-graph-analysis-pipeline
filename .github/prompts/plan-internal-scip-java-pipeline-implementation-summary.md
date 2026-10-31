# Implementation Summary: Internal SCIP-Java Pipeline Smoke Test

## Phase 1 — Refactor: Move `installScipCli.sh`

| File | Change |
|------|--------|
| `domains/scip-index-import/installScipCli.sh` | **Deleted** |
| `domains/scip-index-import/examples/installScipCli.sh` | **Created** — identical content, SCRIPTS_DIR fixed to `../../..` (3 levels up) |
| `.github/workflows/internal-scip-index-code-example.yml` | Updated install path |
| `.github/workflows/internal-scip-jqassistant-typescript-code-example.yml` | Updated install path |
| `scripts/examples/analyzeReactRouterScip.sh` | Updated header comment + body install path |
| `scripts/examples/createScipIndexTypescript.sh` | Removed "Requires" comment; updated error message path |

## Phase 2 — Build: New files

| File | Purpose |
|------|---------|
| `installScipJava.sh` | Installs scip-java 0.12.3 via Coursier; idempotent; `--version`, `--bin-dir`, `--help` flags |
| `createScipIndexFunctionsForJava.sh` | Sourced library: `index_module` + `resolve_placeholders_in_json`; cross-platform `sed -i` |
| `createAxonFrameworkScipIndices.sh` | Indexes 5 AxonFramework modules; derives tool paths from own location |
| `testInstallScipJava.sh` | 7 unit tests (help, unknown arg, --bin-dir, idempotency); auto-discovered by `runTests.sh` |
| `internal-scip-java-code-example.yml` | CI workflow: Java 21, clone AxonFramework, install tools, index, upload, analyze |
| `SCIP.md` | Fixed 2 `installScipCli.sh` paths + added "Java Full Example (experimental)" section |
| `domains/scip-index-import/README.md` | Updated Entry Points + Installing CLI + new "Examples Directory" section + Folder Structure |
| `renovate.json` | Added `SCIP_JAVA_VERSION` custom manager tracking `scip-code/scip-java` github-releases |

## Verification results

- **shellcheck**: all 7 scripts pass ✓
- **testInstallScipJava.sh**: 7/7 tests pass (no network access needed) ✓
- **markdown-link-check SCIP.md**: pass ✓
- **markdown-link-check domains/scip-index-import/README.md**: pass ✓