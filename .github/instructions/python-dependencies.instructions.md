---
applyTo: "requirements.txt,conda-environment.yml"
---
# Python Dependency Conventions

Applies to [requirements.txt](../../requirements.txt), [conda-environment.yml](../../conda-environment.yml).

## Sync Rule

Both files must stay **in sync**: same packages, same pinned versions. Package in one must be in other.

Exceptions (document inline with comment if they differ):
- `conda-environment.yml` may split packages (e.g. `nbconvert` + `nbconvert-webpdf` vs. `nbconvert[webpdf]` in pip)
- `conda-environment.yml` may use `pip:` block for packages not on conda-forge

## Versioning

- Pin all versions — no ranges, no `>=`, no unpinned entries
- `requirements.txt`: `==` (e.g. `pandas==2.2.3`)
- `conda-environment.yml`: `=` (e.g. `pandas=2.2.3`)

## Adding or Updating

- **Ask user before introducing new dependencies**
- Update both files when changing version

## Verification

**`requirements.txt`** — venv dry-run from [.github/workflows/internal-check-python-venv-support.yml](../../.github/workflows/internal-check-python-venv-support.yml):

```shell
python -m venv .venv
source ./scripts/activatePythonEnvironment.sh
.venv/bin/pip install --dry-run --quiet --requirement requirements.txt
! .venv/bin/pip install --dry-run --requirement requirements.txt 2>/dev/null | grep -q "Would install"
```

**`conda-environment.yml`** — via [scripts/activateCondaEnvironment.sh](../../scripts/activateCondaEnvironment.sh):

```shell
source ./scripts/activateCondaEnvironment.sh
```

Fallback (conda directly):

```shell
conda env update --file conda-environment.yml --prune
conda activate codegraph
```
