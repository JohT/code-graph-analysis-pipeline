// Will never return any results so that the validation will always fail. This is helpful for Jupyter Notebooks that should not be executed automatically.

MATCH (nothing) RETURN nothing LIMIT 0