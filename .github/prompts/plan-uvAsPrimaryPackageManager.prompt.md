# Plan: uv as Primary Package Manager

uv becomes the primary (default) Python package manager using `pyproject.toml` + `uv.lock` as the canonical dependency source. Conda remains a supported optional path. venv is removed entirely. All wiring — scripts, workflows, Renovate, docs, and instruction files — is updated accordingly.

---

## Phase 1 — Canonical Dependency Source
1. **Create `pyproject.toml`**: `[project]` section with `requires-python = ">=3.12"`, `dependencies` pinned with `==` (exact versions from `requirements.txt`); `[tool.uv]` for uv settings
2. **Delete `requirements.txt`** — Renovate's `uv` manager takes over version tracking
3. **Fix drift in `conda-environment.yml`**: `pandas=2.2.3` → `2.3.3`; `neo4j==5.28.2` → `6.1.0` in its pip block
4. **Update header comment** in `conda-environment.yml`: "sync to `pyproject.toml`" (not requirements.txt)

**Verification**: `uv sync` completes cleanly; `uv lock --check` passes.

## Phase 2 — Activation Scripts *(parallel with Phase 3)*
5. **Create `scripts/activateUvEnvironment.sh`**: skips early if `PYTHON_PACKAGE_MANAGER != 'uv'`; hard-fails if `uv` not found (with install URL); runs `uv sync --frozen`; activates `.venv/bin/activate` (Unix) or `.venv/Scripts/activate` (Windows Git Bash) — cross-platform via `operatingSystemFunctions.sh`; shellcheck-clean, follows [shell-scripts.instructions.md](.github/instructions/shell-scripts.instructions.md)
6. **Delete `scripts/activatePythonEnvironment.sh`**
7. **Modify `scripts/activateCondaEnvironment.sh`**: replace `USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV == 'true'` skip-guard → `PYTHON_PACKAGE_MANAGER != 'conda'`; leave deprecated var in comment

## Phase 3 — Environment Variables *(parallel with Phase 2)*
8. **Add `PYTHON_PACKAGE_MANAGER`** env var (default: `uv`, valid: `uv` | `conda`) to both new activation scripts
9. **Deprecate `USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV`** — mark in all referencing scripts
10. **Remove `PYTHON_ENVIRONMENT_FILE`** — referenced only by the deleted `activatePythonEnvironment.sh`

## Phase 4 — Pipeline Script Wiring *(depends on 2 + 3)*
11. **Modify `scripts/reports/compilations/PythonReports.sh`**: replace `source activatePythonEnvironment.sh` → `source activateUvEnvironment.sh`; keep `activateCondaEnvironment.sh` call; update comment
12. **Modify `scripts/checkCompatibility.sh`**: replace `oneOf "conda" "venv"` → `oneOf "uv" "conda"`; replace `checkOptionalCommand "virtualenv"` → `checkOptionalCommand "uv"` (with astral.sh URL); remove `python`/`pip` as required commands (uv manages its own Python)

## Phase 5 — Workflows *(depends on 2 + 3 + 4)*
13. **Rename** `internal-check-python-venv-support.yml` → `internal-check-python-uv-support.yml`: install uv via `astral-sh/setup-uv`; `uv sync --frozen`; verify package imports; trigger paths: `pyproject.toml`, `uv.lock`, `scripts/activateUvEnvironment.sh`
14. **Create** `.github/workflows/internal-check-conda-support.yml`: setup-miniconda + `conda-environment.yml`; verify activation + imports; trigger paths: `conda-environment.yml`, `scripts/activateCondaEnvironment.sh`
15. **Modify `public-analyze-code-graph.yml`** (public API — no breaking changes):
    - Add `python-package-manager` input: `type: string`, `default: 'uv'`, `required: false`, self-contained description for external users
    - Update `use-venv_virtual_python_environment` description: "Deprecated. Use `python-package-manager` instead."
    - Add uv setup step (conditional `inputs.python-package-manager != 'conda'`) using `astral-sh/setup-uv`
    - Keep conda setup step (conditional `inputs.python-package-manager == 'conda'`)
    - Pass `PYTHON_PACKAGE_MANAGER: ${{ inputs.python-package-manager }}` to the analysis env
    - ⚠️ **Behavior change**: callers relying on conda being the effective default must now explicitly pass `python-package-manager: 'conda'`
16. **Modify `internal-java-code-analysis.yml`**: remove `!requirements.txt` override from `paths-ignore` (2 occurrences); no other changes — inherits uv default
17. **Modify `internal-typescript-code-analysis.yml`**: same `!requirements.txt` removal

## Phase 6 — Renovate *(parallel with Phase 5)*
18. **Modify `renovate.json`**: add `"uv"` to `matchManagers` in the "Only use stable versions" packageRule; remove `"pip_requirements"` from the same list; Renovate's `uv` manager auto-discovers `pyproject.toml` + `uv.lock`
    - 🔘 **Decision point**: enable the currently-disabled conda customManagers? (change `fileMatch` from `conda-environment-temporarily-disabled.yml` → `conda-environment.yml`)

## Phase 7 — Documentation *(depends on all above)*
19. **`README.md`**: update Python prerequisites (uv primary, conda optional)
20. **`COMMANDS.md`**: add uv setup commands; keep conda manual setup section
21. **`ENVIRONMENT_VARIABLES.md`**: add `PYTHON_PACKAGE_MANAGER`, deprecate `USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV`, remove `PYTHON_ENVIRONMENT_FILE`
22. **Regenerate `SCRIPTS.md`** (run generation script after all script changes)
23. **`AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`**: update instruction table row for `python-dependencies.instructions.md` (applyTo now covers `pyproject.toml`)

## Phase 8 — Instruction Files *(depends on all above)*
24. **Modify `.github/instructions/python-dependencies.instructions.md`**: update `applyTo` to `pyproject.toml,conda-environment.yml`; update sync rule (`pyproject.toml` is canonical); update verification to `uv sync --check` / `uv lock --check`

---

## Summary Table

| File | Change |
|------|--------|
| `pyproject.toml` | **NEW** — canonical dep source |
| `requirements.txt` | **DELETED** |
| `conda-environment.yml` | drift fix + header comment update |
| `scripts/activateUvEnvironment.sh` | **NEW** |
| `scripts/activatePythonEnvironment.sh` | **DELETED** |
| `scripts/activateCondaEnvironment.sh` | gate on `PYTHON_PACKAGE_MANAGER` |
| `scripts/reports/compilations/PythonReports.sh` | swap activation script |
| `scripts/checkCompatibility.sh` | uv/conda check, remove pip/python |
| `.github/workflows/internal-check-python-venv-support.yml` | **RENAMED** → uv-support.yml |
| `.github/workflows/internal-check-conda-support.yml` | **NEW** |
| `.github/workflows/public-analyze-code-graph.yml` | add `python-package-manager` param |
| `.github/workflows/internal-java-code-analysis.yml` | remove `!requirements.txt` exception |
| `.github/workflows/internal-typescript-code-analysis.yml` | remove `!requirements.txt` exception |
| `renovate.json` | add `uv` manager, remove `pip_requirements` |
| `ENVIRONMENT_VARIABLES.md` | new var, deprecated var, removed var |
| `SCRIPTS.md` | regenerated |
| `README.md`, `COMMANDS.md` | uv setup docs |
| `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md` | instruction table update |
| `.github/instructions/python-dependencies.instructions.md` | applyTo + sync rule + verification |

## Verification Checklist
1. `uv sync --frozen` completes cleanly from project root
2. `uv lock --check` — lockfile is consistent with `pyproject.toml`
3. `uv run python -c "import ipykernel, pandas, sklearn, umap, shap, neo4j, plotly, optuna"` — all imports succeed
4. `shellcheck scripts/activateUvEnvironment.sh scripts/activateCondaEnvironment.sh` — no warnings
5. `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json README.md COMMANDS.md ENVIRONMENT_VARIABLES.md` — no broken links
6. CI: `internal-check-python-uv-support.yml` passes
7. CI: `internal-check-conda-support.yml` passes
8. CI: `public-analyze-code-graph.yml` smoke-tested with default (uv) and with `python-package-manager: conda`

## Renovate Decision
- Should Renovate's conda customManagers be re-enabled now that `conda-environment.yml` is officially the conda canonical file? Currently disabled on purpose. Enabling makes Renovate auto-update conda packages but the custom matchers only cover conda packages (not the nested pip block). Answer: Yes, but it is fine when conda versions diverge from pyproject.toml since conda is now explicitly optional and secondary. Therefore, enable it and change it so that it only matches `conda-environment.yml` and only takes conda package updates into account (ignore pip block).

## Key Decisions Made
- **Canonical source**: `pyproject.toml` + `uv.lock`
- **`requirements.txt`**: deleted entirely; Renovate `uv` manager handles updates
- **`conda-environment.yml`**: kept; synced to `pyproject.toml` (not deleted)
- **Drift fix** (in this PR): `pandas=2.3.3`, `neo4j==6.1.0` (use requirements.txt versions as truth)
- **Script**: new `activateUvEnvironment.sh`; delete `activatePythonEnvironment.sh`
- **Env var**: new `PYTHON_PACKAGE_MANAGER` (default: `uv`); `USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV` deprecated
- **Public workflow**: add `python-package-manager` string param (default `'uv'`); keep old param deprecated-but-present
  - **Behavior change flag**: callers relying on old conda default (VENV=false) now get uv. Must set `python-package-manager: 'conda'` explicitly.
- **CI**: uv = primary (existing internal workflows), conda = new dedicated check workflow
- **Renovate**: enable `uv` manager; remove/disable `pip_requirements` since no more requirements.txt
- **Windows Git Bash / WSL**: supported in `activateUvEnvironment.sh`
- **Jupyter**: `ipykernel==7.2.0` already in both files — no changes needed
