# Plan: Add `--domain` option to analyze.sh

Add an optional `--domain <name>` CLI option to `analyze.sh` that selects a single domain (subdirectory of `domains/`) for vertical-slice analysis. When set, only that domain's report scripts run; core reports from `scripts/reports/` and other domains are skipped. Composes naturally with `--report` (horizontal slice). When omitted, behavior is unchanged.

---

**Steps**

### Phase 1: `analyze.sh` CLI parsing and validation

1. **Add `--domain` to argument parsing** in [analyze.sh](scripts/analysis/analyze.sh) — add default `analysisDomain=""`, add `--domain)` case in the `while` loop, update `usage()`
2. **Validate the domain name** — POSIX `case` glob pattern `*[!A-Za-z0-9-]*` to reject invalid characters (only if non-empty), resolve `DOMAINS_DIR="${SCRIPTS_DIR}/../domains"`, check `domains/<name>/` subdirectory exists with clear error message, then set `ANALYSIS_DOMAIN` (plain variable, no `export`)
3. **Log the domain** in the "Start Analysis" group alongside `analysisReportCompilation`, `settingsProfile`, `exploreMode`

### Phase 2: Report compilation scripts — respect `ANALYSIS_DOMAIN` (*all steps parallel*)

4. **Modify [CsvReports.sh](scripts/reports/compilations/CsvReports.sh)** — when `ANALYSIS_DOMAIN` is set, replace `for directory in "${REPORTS_SCRIPT_DIR}" "${DOMAINS_DIRECTORY}"` with just `"${DOMAINS_DIRECTORY}/${ANALYSIS_DOMAIN}"`
5. **Modify [PythonReports.sh](scripts/reports/compilations/PythonReports.sh)** — same pattern (Python env activation still runs)
6. **Modify [VisualizationReports.sh](scripts/reports/compilations/VisualizationReports.sh)** — same pattern
7. **Modify [MarkdownReports.sh](scripts/reports/compilations/MarkdownReports.sh)** — same pattern
8. **No changes to `AllReports.sh`** (chains the above scripts, filtering cascades) or **`DatabaseCsvExportReports.sh`** (special case, invoked explicitly only)

### Phase 3: GitHub Actions workflow (*depends on Phase 1*)

10. **Add `domain` input** to [public-analyze-code-graph.yml](.github/workflows/public-analyze-code-graph.yml) — optional string, default `''`. In the "Analyze" step, prepend `--domain <value>` to `analysis-arguments` when non-empty

### Phase 4: Documentation (*depends on Phase 1*)

11. **Update [analyze.sh](scripts/analysis/analyze.sh) header comments** — add `# Note:` block for `--domain` matching existing style
12. **Update [COMMANDS.md](COMMANDS.md)** — add `--domain` under "Command Line Options" and document the `ANALYSIS_DOMAIN` environment variable alongside other overrideable variables
13. **Update [GETTING_STARTED.md](GETTING_STARTED.md)** — add example: `./../../scripts/analysis/analyze.sh --domain anomaly-detection`

### Phase 5: Test scripts (*depends on Phases 1–2*)

14. **Create [testAnalyzeDomainOption.sh](scripts/testAnalyzeDomainOption.sh)** — follow existing conventions (`testCloneGitRepository.sh` pattern: `tearDown`, `successful`, `fail`, `info` helpers; temp directory with fake `domains/` structure; auto-discovered by `runTests.sh` via `find … -name 'test*.sh'`). Test cases:
    - Reject `--domain` with invalid characters (e.g. `../../etc`) → fails at regex
    - Reject `--domain` with nonexistent domain name → fails with error listing available domains
    - Accept `--domain` with valid name matching a temp subdirectory → passes validation (script then fails at "no artifacts" check, which confirms domain validation succeeded)
    - No `--domain` given → passes validation unchanged (same late failure)

---

**Relevant files**
- `scripts/analysis/analyze.sh` — add `--domain` parsing, validation (match pattern of `settingsProfile`), set `ANALYSIS_DOMAIN` (no `export`)
- `scripts/reports/compilations/CsvReports.sh` — conditionally filter `for directory in ...` loop
- `scripts/reports/compilations/PythonReports.sh` — same conditional filtering
- `scripts/reports/compilations/VisualizationReports.sh` — same conditional filtering
- `scripts/reports/compilations/MarkdownReports.sh` — same conditional filtering
- `.github/workflows/public-analyze-code-graph.yml` — add `domain` input, pass through
- `COMMANDS.md` — document `--domain` option and `ANALYSIS_DOMAIN` environment variable
- `GETTING_STARTED.md` — add usage examples
- `scripts/testAnalyzeDomainOption.sh` — new test script for `--domain` validation (auto-discovered by `runTests.sh`)

**Verification**
1. Run `analyze.sh --domain nonexistent` → clear error listing available domains
2. Run `--domain anomaly-detection --report Csv` → only `anomalyDetectionCsv.sh` runs (no core CSV, no `externalDependenciesCsv.sh`)
3. Run `--domain anomaly-detection` (default `--report All`) → only anomaly-detection scripts for Csv/Python/Visualization/Markdown run
4. Run without `--domain` → all reports + all domains execute unchanged (backward compat)
5. Run `--domain "../../etc"` → regex rejects it
6. Run example script with `--domain anomaly-detection` → argument passes through via `"${@}"`

**Decisions**
- `--domain` and `--report` compose: report selects type (horizontal), domain selects scope (vertical)
- When `--domain` is set, core reports from `scripts/reports/` are **skipped** — only the domain's scripts run
- Only a single domain selectable (not comma-separated)
- Propagated via `ANALYSIS_DOMAIN` shell variable (no `export`) from `analyze.sh` to compilation scripts — an env var (not script arguments) because compilation scripts are `source`d (not subprocesses), positional params would conflict in nested sourcing, and it follows the established convention (`DOMAINS_DIRECTORY`, `REPORTS_SCRIPT_DIR`, etc.)
- **Not exported** — `export` would leak the variable into all child processes (Python, Java/jQAssistant, Neo4j, npm/node) where it could collide with unrelated programs outside this project's control. Since all compilation scripts are `source`d (same shell), `export` is unnecessary
- **POSIX-compliant where practical** — prefer `case` glob patterns over `[[ =~ ]]` for validation (e.g. `case "${var}" in *[!A-Za-z0-9-]*) …`), `[ ]` over `[[ ]]` for simple tests, standard parameter expansion, and portable constructs. No new external dependencies. Must run on macOS, Linux, and Windows (Git Bash, WSL). Exception: `${BASH_SOURCE[0]}` (already used throughout the codebase). Follow existing script conventions over strict POSIX when they conflict
- **Readability over brevity** — no abbreviations in variable names, function names, or messages, even if names feel long (e.g. selectedAnalysisDomain over domain, analysisDomainsDirectory over domainsDir). Follow the existing codebase style (analysisReportCompilation, settingsProfile, REPORT_COMPILATIONS_SCRIPT_DIR, etc.)
