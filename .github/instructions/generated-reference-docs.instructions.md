---
applyTo: "CYPHER.md,SCRIPTS.md,ENVIRONMENT_VARIABLES.md"
---
# Generated Reference Files

[CYPHER.md](../../CYPHER.md), [SCRIPTS.md](../../SCRIPTS.md), [ENVIRONMENT_VARIABLES.md](../../ENVIRONMENT_VARIABLES.md) — **auto-generated**. Do not edit directly. Changes get overwritten.

## Do Not Run Generators Manually

Generators run automatically — output **auto-committed**. Running locally causes **git merge conflicts** in pipeline. Only run if user explicitly insists.

## Influence Indirectly

| File | Edit instead |
|------|--------------|
| `CYPHER.md` | First line `// Description.` of each `.cypher` file |
| `SCRIPTS.md` | First line `# Description.` of each `.sh` file |
| `ENVIRONMENT_VARIABLES.md` | Inline `# comment` after env var declaration in `.sh` files |

Moved/renamed files: auto-detected, reflected on next pipeline run.

## Generators

See [scripts/documentation/](../../scripts/documentation/):

- `generateCypherReference.sh` → `CYPHER.md`
- `generateScriptReference.sh` → `SCRIPTS.md`
- `generateEnvironmentVariableReference.sh` + `appendEnvironmentVariables.sh` → `ENVIRONMENT_VARIABLES.md`
