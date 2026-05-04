---
applyTo: "**/*.py,**/*.ipynb"
---
# Python Conventions

Applies to Jupyter notebooks, standalone `.py` scripts.

## Style

- Type annotations everywhere — parameters, return types, non-obvious variables
- Verify with Pylance (strict mode preferred)
- No abbreviations. Write out names. `figure` not `fig`. `axis` not `ax`. `i`, `j`, `k` for indices OK
- Prefer named functions over comments. Comments explain *why*, not *what*
- Split into meaningful functions. Ideally pure, easy to test
- Apply functional programming where it improves readability: map, filter, list comprehensions
- f-strings over `%` or `.format()` for string interpolation
- No `+` concatenation in loops — use `"".join()` or list accumulation
- `is`/`is not` for `None` comparisons, never `==`/`!=`
- Truthiness: `if seq:` not `if len(seq) > 0:`. `if x is not None:` not `if x != None:`
- Use `pathlib.Path` over `os.path` for file operations

## Type Annotations

- `X | None` over `Optional[X]`; `X | Y` over `Union[X, Y]` (PEP 604)
- Abstract container types in signatures: `Sequence` over `list`, `Mapping` over `dict`

## Imports

- Order: stdlib → third-party → local; one blank line between groups
- No wildcard imports (`from x import *`)
- One import statement per module line; multiple names from same module OK: `from x import A, B`

## Query Construction

- Cypher, SQL, all database queries: parameterized only. Never string concatenation
- Parameters prevent injection attacks, improve performance
- Bad: `query = f"MATCH (n) WHERE n.name = '{user_input}' ..."`
- Good: `query = "MATCH (n) WHERE n.name = $name ..."; params = {"name": user_input}`
- All query types: SQL, Cypher, GraphQL, REST API calls with user input

## Input Validation

- Validate inputs early. Fail fast on invalid data
- Check preconditions at start: type, ranges, non-null values
- Raise specific exceptions with clear messages on failure
- Prevents invalid state cascading deep into code
- Example: file paths exist, collections non-empty, numeric ranges valid before processing

## Error Handling

- No bare `except:`. Name specific exceptions only (`except ValueError:`)
- No mutable defaults: `def f(x: list = [])`. Use `None` + guard
- Use `with` for file/resource management. Never manual open/close
- Keep try/except short, focused. Wrap only code that raises specific exception being caught
- Never catch unrelated failures together. Separate concerns prevent masking bugs
- Example: file I/O + JSON parsing need separate try/except blocks. Each failure mode distinct

## Naming

- No generic names: no util, helper, common, shared
- Module-level constants: `UPPER_CASE_WITH_UNDERSCORES`
- DRY only for domain concepts
- No magic numbers. Extract named constants for literal comparisons

## Docstrings

- Public functions require docstring (triple double quotes)
- First line imperative, period: `"""Compute distances from center."""`
- Multi-line: blank line after summary, then `Args:`, `Returns:`, `Raises:` sections as needed
