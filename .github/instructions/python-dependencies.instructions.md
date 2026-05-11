---
applyTo: "pyproject.toml,conda-environment.yml"
---
# Python Dependency Conventions

[pyproject.toml](../../pyproject.toml), [conda-environment.yml](../../conda-environment.yml).

## Sync Rule

`pyproject.toml` canonical source. `conda-environment.yml` stays synced: same packages, same pinned versions.

Exceptions (inline comment if differ):
- `conda-environment.yml` splits packages (e.g. `plotly[kaleido]` in pyproject.toml vs. `plotly` + `python-kaleido` in conda)
- `conda-environment.yml` uses `pip:` block for packages not on conda-forge

## Versioning

- Pin all versions — no ranges, no `>=`, no unpinned entries
- `pyproject.toml`: `==` (e.g. `"pandas==2.3.3"`)
- `conda-environment.yml`: `=` (e.g. `pandas=2.3.3`)

## Updating

- **Ask user before adding dependencies**
- Update both files when changing version

## Verification

**`pyproject.toml`** — uv sync from [.github/workflows/internal-check-python-uv-support.yml](../../.github/workflows/internal-check-python-uv-support.yml):

```shell
uv sync --frozen
uv lock --check
uv run python -c "import ipykernel, pandas, sklearn, umap, shap, neo4j, plotly, optuna"
```

**`conda-environment.yml`** — via [scripts/activateCondaEnvironment.sh](../../scripts/activateCondaEnvironment.sh):

```shell
PYTHON_PACKAGE_MANAGER=conda source ./scripts/activateCondaEnvironment.sh
```

Fallback (conda directly):

```shell
conda env update --file conda-environment.yml --prune
conda activate codegraph
```
