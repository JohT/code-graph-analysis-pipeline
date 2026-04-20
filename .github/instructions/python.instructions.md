---
applyTo: "**/*.py,**/*.ipynb"
---
# Python Conventions

Applies to Jupyter notebooks, standalone `.py` scripts.

## Style

- Type annotations everywhere — parameters, return types, non-obvious variables
- Verify with Pylance (strict mode preferred)
- No abbreviations. Write out names. `figure` not `fig`. `axis` not `ax`. `i`, `j`, `k` for indices OK
- Prefer named functions over code block comments. Comments explain *why*, not *what*
- Split into meaningful functions — ideally pure, easy to test
- Apply basic functional programming where it improves readability: map, filter, list comprehensions
- f-strings preferred over `%` or `.format()` for string interpolation
- No `+` concatenation in loops — use `"".join()` or list accumulation
- `is`/`is not` for `None` comparisons, never `==`/`!=`
- Truthiness: `if seq:` not `if len(seq) > 0:`; `if x is not None:` not `if x != None:`
- Use `pathlib.Path` over `os.path` for file operations

## Type Annotations

- `X | None` over `Optional[X]`; `X | Y` over `Union[X, Y]` (PEP 604)
- Abstract container types in signatures: `Sequence` over `list`, `Mapping` over `dict`

## Imports

- Order: stdlib → third-party → local; one blank line between groups
- No wildcard imports (`from x import *`)
- One import statement per module line; multiple names from same module OK: `from x import A, B`

## Error Handling

- No bare `except:` — always name specific exceptions (`except ValueError:`)
- No mutable default arguments: `def f(x: list = [])` — use `None` + guard
- Use `with` for all file/resource management; never manual open/close

## Naming

- No generic names — no "util", "helper", "common", "shared"
- Module-level constants: `UPPER_CASE_WITH_UNDERSCORES`
- DRY only for domain-related concerns
- No magic numbers — extract named constants for literal comparisons

## Docstrings

- Public functions require `"""..."""` docstring (triple double quotes)
- First line imperative mood, ends with period: `"""Compute distances from center."""`
- Multi-line: blank line after summary, then `Args:`, `Returns:`, `Raises:` sections as needed

## Notebook to Script Conversion

- Extract charts and tables into standalone `.py` script with `main()` entry point
- Original notebook → `explore/` with metadata `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"` and "Exploration" added to title
- Charts → SVG, tables → CSV, descriptions → Markdown summary report
