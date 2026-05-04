## Plan: --exclude-domain and --help for analyze.sh

TL;DR: Add `--exclude-domain` (comma-separated list, with smart defaults) and `--help` to `analyze.sh`. Domain exclusion flows via new env var `ANALYSIS_DOMAINS_TO_SKIP` into 4 compilation scripts. `--domain` and `--exclude-domain` interact per the chosen rules.

---

### Phase 1: analyze.sh

1. Expand `usage()` — accept exit-code arg (`exit "${1:-1}"`); add all flags with descriptions, env vars (`ANALYSIS_DOMAINS_TO_SKIP` + existing), copy-pastable examples

2. Add `--help` parsing — `case --help)`: call `usage 0`; before `*)` catch-all

3. Add tracking variables — `excludeDomainsExplicitlySet=false` and `selectedExcludedDomains=""` alongside existing defaults block

4. Add `--exclude-domain` parsing — reuse `is_missing_value_parameter`; set `excludeDomainsExplicitlySet=true` and `selectedExcludedDomains="${2}"` (empty allowed)

5. Resolve effective exclude list (after arg loop) — priority:
   1. `excludeDomainsExplicitlySet=true` → use `selectedExcludedDomains` as-is (even `""`)
   2. `--domain` was set → `""` (no default skipping)
   3. Otherwise → `"anomaly-detection,node-embeddings,graph-algorithms"`

   Set result into `resolvedExcludedDomains`.

6. Validate format — split by comma; each segment must match `^[A-Za-z0-9-]+$`; exit 1 on invalid

7. Warn on unknown excluded domains (explicit `--exclude-domain` only) — after `DOMAINS_DIRECTORY` is resolved; warn if `${DOMAINS_DIRECTORY}/${domain}` not a directory; don't exit

8. Detect `--domain` + `--exclude-domain` conflict — if `ANALYSIS_DOMAIN` is in `ANALYSIS_DOMAINS_TO_SKIP`, print warning that exclude wins

9. Export `ANALYSIS_DOMAINS_TO_SKIP` — set and log alongside existing log block

---

### Phase 2: Compilation Scripts (parallel changes)

Targets:
- `scripts/reports/compilations/CsvReports.sh`
- `scripts/reports/compilations/PythonReports.sh`
- `scripts/reports/compilations/MarkdownReports.sh`
- `scripts/reports/compilations/VisualizationReports.sh`

10. Log `ANALYSIS_DOMAINS_TO_SKIP` in the init block alongside `ANALYSIS_DOMAIN`

11. Extend single-domain branch — before setting `analysisReportScriptDirectories`, check if `ANALYSIS_DOMAIN` is in `ANALYSIS_DOMAINS_TO_SKIP` using `[[ ",${ANALYSIS_DOMAINS_TO_SKIP}," == *",${ANALYSIS_DOMAIN},"* ]]`; if excluded → set array empty, log skip message

12. Filter find output in all-domains loop — inside existing `while read -r report_script_file` loop, before `source`: if `ANALYSIS_DOMAINS_TO_SKIP` is non-empty, split by comma and check `report_script_file` path for `/${excluded_domain}/`; if matched → log skip + `continue`

---

### Phase 3: Testing (Unit tests — no analysis run)

13. Create `scripts/testAnalyzeCliOptions.sh` — a unit test script that:
   - Tests argument parsing and validation only (does NOT start analysis, Neo4j, or other heavy components).
   - Verifies `--help` prints usage and exits 0.
   - Exercises green paths: no flags, `--exclude-domain` with valid value, `--exclude-domain ""`, and `--domain` alone.
   - Exercises red paths: invalid characters in values, missing option values, unknown/ non-existent domain, malformed comma lists (spaces, trailing commas).
   - Validates exit codes and expected output substrings (warnings/messages) without invoking downstream analysis steps.
   - Follows the pattern and style used by `scripts/testDetectChangedFiles.sh` (colored output, pass/fail counts, cleanup).
   - File should be executable and idempotent: `scripts/testAnalyzeCliOptions.sh`.

14. Test-run instructions (manual step):
   - Make test executable: `chmod +x scripts/testAnalyzeCliOptions.sh`
   - Run: `bash scripts/testAnalyzeCliOptions.sh`
   - The test must not start Neo4j or run the analysis; it should only validate CLI parsing and early validation logic.

15. Acceptance criteria:
   - The test script covers all failing variants (red path) and at least one green path.
   - The test does not perform any analysis, network, or filesystem changes beyond temporary files created by the test itself.
   - The test script exits 0 when all checks pass, non-zero otherwise.

---

### Verification

1. `shellcheck` on all 5 modified scripts
2. `analyze.sh --help` → usage printed, exits 0
3. `analyze.sh --exclude-domain ""` → `ANALYSIS_DOMAINS_TO_SKIP=` (empty)
4. `analyze.sh` (no flags) → `ANALYSIS_DOMAINS_TO_SKIP=anomaly-detection,node-embeddings,graph-algorithms`
5. `analyze.sh --domain anomaly-detection` → `ANALYSIS_DOMAINS_TO_SKIP=` (empty default)
6. `analyze.sh --domain anomaly-detection --exclude-domain anomaly-detection` → warning; nothing runs for that domain
7. `analyze.sh --exclude-domain "anomaly-detection,nonexistent"` → warning for `nonexistent`
8. `analyze.sh --exclude-domain "invalid domain!"` → exits 1 (invalid characters)
9. `bash scripts/testAnalyzeCliOptions.sh` → all tests pass, exits 0
