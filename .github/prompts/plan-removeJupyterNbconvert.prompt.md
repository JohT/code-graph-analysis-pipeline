# Plan: Remove Jupyter Notebook Rendering/Converting Pipeline

Remove all automated Jupyter notebook execution, rendering (nbconvert), and PDF generation from the pipeline. The `jupyter/` folder is empty of notebooks; all reports are now plain Python scripts in `domains/`. The 25 `explore/*.ipynb` notebooks remain as static interactive files only — not part of the automated pipeline. Span subagents where appropriate.

**Decisions confirmed:**
- Remove both `jupyter` and `nbconvert` packages from environments
- Delete `jupyter/` folder entirely
- Delete `JupyterReports.sh`, `executeJupyterNotebook.sh`, `executeJupyterNotebookReport.sh`
- Remove `JUPYTER_NOTEBOOK_DIRECTORY` from `activateCondaEnvironment.sh`; derive `CONDA_ENVIRONMENT_FILE` from `${SCRIPTS_DIR}/../conda-environment.yml` directly
- Clean up `NBCONVERT`/`NBCONVERT_PATH` detection in `GitHistoryGeneralExploration.ipynb` only
- Operational doc cleanup only (keep CHANGELOG history)
- Keep `**/*.ipynb` in `python.instructions.md` applyTo
- Remove "Notebook to Script Conversion" section from `python.instructions.md`
- Remove `*.nbconvert*` from `.gitignore`; keep `.ipynb_checkpoints`
- SCRIPTS.md, ENVIRONMENT_VARIABLES.md, CYPHER.md auto-regenerate from source

---

## Phase 1: Delete deprecated files (no dependencies, can all run in parallel)

1. Delete `scripts/reports/compilations/JupyterReports.sh`
2. Delete `scripts/executeJupyterNotebook.sh`
3. Delete `scripts/executeJupyterNotebookReport.sh`
4. Delete `jupyter/` directory (contains only `jupyter/.env`)
5. Delete entire `cypher/Validation/` directory — only used for Jupyter notebook data availability validation; no other queries depend on it

## Phase 2: Update pipeline shell scripts (parallel)

6. `scripts/reports/compilations/AllReports.sh` — remove `source JupyterReports.sh` line and its preceding Jupyter comment (lines 22 and 27)
7. `scripts/analysis/analyze.sh` — remove `Jupyter` from `--report` usage string (line 53); update line 14 note comment to remove `"Jupyter"` example
8. `scripts/activateCondaEnvironment.sh` — remove `JUPYTER_NOTEBOOK_DIRECTORY` variable and its `echo`; change `CONDA_ENVIRONMENT_FILE` default to `${SCRIPTS_DIR}/../conda-environment.yml` inline (no longer via jupyter dir); update script header comment to say "Python scripts" not "Jupyter Notebooks and Python scripts"
9. `scripts/activatePythonEnvironment.sh` — update header comment: remove "Jupyter Notebooks" reference; update ROOT_DIRECTORY comment which says "Repository directory containing the Jupyter Notebooks"

## Phase 3: Python dependencies (parallel)

10. `requirements.txt` — remove `jupyter==1.1.1` and `nbconvert[webpdf]==7.17.0`
11. `conda-environment.yml` — remove `jupyter=1.1.1`, `nbconvert=7.16.6`, `nbconvert-webpdf=7.16.6`

## Phase 4: GitHub Actions workflows (parallel)

12. `.github/workflows/public-analyze-code-graph.yml` — remove `jupyter-pdf` input block (~lines 102–107); remove `ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION` env var line (~line 275); update stale comment "Setup Python could be skipped if jupyter notebook..." (~line 160); update stale comment "Shell type can be skipped if jupyter notebook..." (~line 271)
13. `.github/workflows/internal-java-code-analysis.yml` — remove `jupyter-pdf: "false"` (~line 120)
14. `.github/workflows/internal-typescript-code-analysis.yml` — remove `jupyter-pdf: "false"` (~line 68)
15. `.github/workflows/internal-typescript-upload-code-example.yml` — remove `jupyter-pdf: "false"` (~line 123)

## Phase 5: Notebook cleanup

16. `domains/git-history/explore/GitHistoryGeneralExploration.ipynb` — remove the `NBCONVERT`/`NBCONVERT_PATH` env var detection code block (cells ~52–63)
17. All `domains/*/explore/*.ipynb` notebooks — remove the `"code_graph_analysis_pipeline_data_validation"` metadata property from cell outputs or notebook metadata (used to reference `cypher/Validation/` queries; no longer applicable)

## Phase 6: Manually maintained documentation (parallel)

18. `COMMANDS.md` — remove: `Jupyter` from report-type ToC (~line 47), `--report Jupyter` example (~line 76), "Jupyter Notebook Reports" section (~lines 113–134, ~lines 400–499), nbconvert-related links; remove "Data Availability Validation" section; update report types list
19. `README.md` — remove Jupyter feature lines (~lines 45, 47, 105–113, 156–160, 187–189); remove Chromium auto-download note (~line 113); remove 3 outdated Q&A entries ("How can i add a Jupyter Notebook report", "How can i enable PDF generation", "Why are some Jupyter Notebook reports skipped"); add new Q&A entry: "What changed in version 4 regarding report generation?" explaining PDF removal, Markdown focus, and that explore notebooks remain for interactive use
20. `GETTING_STARTED.md` — remove Chromium prerequisite notes (~lines 85, 88, 91)
21. `AGENTS.md` — remove `Jupyter` from report types table (line 52)
22. `CLAUDE.md` — same (line 52)
23. `.github/copilot-instructions.md` — same (line 52)
24. `.github/prompts/plan-addDomainOption.prompt.md` — remove step 8 "Modify JupyterReports.sh" and its rationale; remove JupyterReports from relevant files list

## Phase 7: Instruction files

25. `.github/instructions/python.instructions.md` — remove "Notebook to Script Conversion" section (last section, ~3 bullet points)
26. `.github/instructions/python-dependencies.instructions.md` — replace `nbconvert` split packages example with `plotly[kaleido]` / `python-kaleido` example (line 13)

## Phase 8: Miscellaneous

27. `.gitignore` — remove `*.nbconvert*` entry (~line 94)

---

**Relevant files**
- `scripts/reports/compilations/JupyterReports.sh` — DELETE
- `scripts/executeJupyterNotebook.sh` — DELETE
- `scripts/executeJupyterNotebookReport.sh` — DELETE
- `jupyter/` — DELETE entire directory
- `cypher/Validation/` — DELETE entire directory
- `scripts/reports/compilations/AllReports.sh` — remove JupyterReports.sh source line
- `scripts/analysis/analyze.sh` — remove Jupyter from usage and comments
- `scripts/activateCondaEnvironment.sh` — remove JUPYTER_NOTEBOOK_DIRECTORY, update CONDA_ENVIRONMENT_FILE path
- `scripts/activatePythonEnvironment.sh` — update header comment only
- `requirements.txt` — remove jupyter + nbconvert packages
- `conda-environment.yml` — remove jupyter + nbconvert packages
- `.github/workflows/public-analyze-code-graph.yml` — remove jupyter-pdf input + env var + stale comments
- `.github/workflows/internal-java-code-analysis.yml` — remove jupyter-pdf: "false"
- `.github/workflows/internal-typescript-code-analysis.yml` — remove jupyter-pdf: "false"
- `.github/workflows/internal-typescript-upload-code-example.yml` — remove jupyter-pdf: "false"
- `domains/git-history/explore/GitHistoryGeneralExploration.ipynb` — remove NBCONVERT detection code
- All `domains/*/explore/*.ipynb` notebooks — remove `code_graph_analysis_pipeline_data_validation` metadata
- `COMMANDS.md` — remove all Jupyter/nbconvert sections, including Data Availability Validation
- `README.md` — remove Jupyter/Chromium sections
- `GETTING_STARTED.md` — remove Chromium prerequisite
- `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md` — remove Jupyter from report types
- `.github/prompts/plan-addDomainOption.prompt.md` — remove JupyterReports.sh step
- `.github/instructions/python.instructions.md` — remove Notebook to Script Conversion section
- `.github/instructions/python-dependencies.instructions.md` — update nbconvert example
- `.gitignore` — remove *.nbconvert*

**Auto-generated docs (do NOT edit directly):**
- `SCRIPTS.md` — regenerates from `.sh` first-line comments after Phase 2
- `ENVIRONMENT_VARIABLES.md` — regenerates from inline `.sh` comments after Phase 2
- `CYPHER.md` — regenerates from `.cypher` first-line comments (all Validation queries removed in Phase 1)

---

**Verification**
1. `shellcheck scripts/activateCondaEnvironment.sh scripts/reports/compilations/AllReports.sh scripts/analysis/analyze.sh` — no errors
2. Confirm `conda-environment.yml` and `requirements.txt` still have matching packages (python-dependencies.instructions.md sync rule)
3. `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json COMMANDS.md README.md GETTING_STARTED.md AGENTS.md` — no broken links
4. Grep for `nbconvert|JupyterReports|executeJupyterNotebook|ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION|JUPYTER_NOTEBOOK_DIRECTORY` across non-CHANGELOG `.sh`, `.yml`, `.md` files — no remaining operational references
5. Confirm `analyze.sh` usage string no longer lists `Jupyter` as a report type option

**Scope boundaries**
- CHANGELOG.md: keep all historical Jupyter entries untouched
- `explore/*.ipynb` notebooks: no changes except GitHistoryGeneralExploration.ipynb NBCONVERT cleanup; `code_graph_analysis_pipeline_data_validation` metadata removed
- `.ipynb_checkpoints` gitignore entry: stays
- Other `cypher/Validation/` files: untouched (they serve real validation for domain scripts)

---

## Breaking Changes & Migration Guide

### What's Changing in Version 4

**Removed:**
- Jupyter notebook PDF generation (`ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION` environment variable no longer supported)
- `--report Jupyter` option in `analyze.sh` (use `--report Markdown` or `--report All` instead)
- Python packages: `jupyter`, `nbconvert`, `nbconvert-webpdf`
- System dependency: Chromium headless browser (no longer auto-downloaded)
- Cypher query directory: `cypher/Validation/` (used only for Jupyter notebook validation)
- GitHub Actions inputs: `jupyter-pdf` parameter in public-analyze-code-graph.yml

**Why:**
- Reduced pipeline complexity and dependency footprint
- Eliminated CVE surface from older, less-maintained dependencies
- Faster report generation (no need for browser rendering)
- Better version control integration (Markdown reports in Git)
- All important reports already available in Markdown format

### Migration Guide

**For users of `ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION`:**
- This environment variable is no longer recognized or used
- Replace PDF report workflows with Markdown equivalents
- All analysis data previously in PDF is now in Markdown (`.md`) files in `reports/*/` directories
- Markdown files integrate better with CI/CD pipelines and version control

**For users of `--report Jupyter`:**
```shell
# Old (no longer works):
./scripts/analysis/analyze.sh --report Jupyter

# New alternatives:
./scripts/analysis/analyze.sh --report Markdown  # Markdown reports
./scripts/analysis/analyze.sh --report All       # All reports including Markdown
```

**For users running GitHub Actions with jupyter-pdf input:**
```yaml
# Old (v3.x):
- uses: JohT/code-graph-analysis-pipeline/.github/workflows/public-analyze-code-graph.yml@main
  with:
    jupyter-pdf: "true"

# New (v4.x):
- uses: JohT/code-graph-analysis-pipeline/.github/workflows/public-analyze-code-graph.yml@main
  # Remove jupyter-pdf input — not supported anymore
```

**For interactive exploration of Jupyter notebooks:**
- The 25 `explore/*.ipynb` notebooks in `domains/*/explore/` remain available
- They are **no longer executed automatically** by the pipeline
- To use them interactively:
  ```shell
  # Start Jupyter server
  jupyter lab
  # Navigate to domains/*/explore/ and open notebooks manually
  ```
- These notebooks now have `.env` file support only; the pipeline no longer manages their execution

**For custom Jupyter notebooks with data validation:**
- Custom metadata `"code_graph_analysis_pipeline_data_validation"` in notebooks is no longer used
- If you have notebooks that relied on this, the validation logic must be moved to your notebook setup

**What to expect in reports directory:**
- Markdown (`.md`) reports instead of PDF
- CSV exports (`.csv`) for data analysis
- SVG visualizations (`.svg`) for graphs and charts
- Python-generated charts as static images embedded in Markdown

### No Breaking Changes For:
- CSV reports (`--report Csv`)
- Python reports (`--report Python`)
- Visualization reports (`--report Visualization`)
- Markdown reports (`--report Markdown`)
- All Cypher queries (except validation queries)
- Neo4j setup and database operations
- Git history analysis
- Anomaly detection
- All domain-specific analyses

### Verification Checklist for Migration

- [ ] Update CI/CD pipelines: remove `jupyter-pdf` environment variable or workflow input
- [ ] Update local scripts: remove `ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION` export statements
- [ ] Update report consumers: adjust to read Markdown instead of PDF
- [ ] Uninstall Jupyter/nbconvert locally (if custom environment): `pip uninstall jupyter nbconvert` or `conda remove jupyter nbconvert`
- [ ] Verify Markdown reports render correctly in your documentation system
- [ ] For interactive exploration: install Jupyter separately if needed: `pip install jupyter` or `conda install jupyter`
