---
applyTo: ".github/workflows/*.yml"
---
# GitHub Workflow Conventions

## Internal Workflows (`internal-*.yml`)

Internal workflows test pipeline itself. All domains run — including those `analyze.sh` skips by default (`anomaly-detection`, `node-embeddings`, `graph-algorithms`). These are smoke tests: verify domains work end-to-end without breaking.

- Always set `run-all-domains: true` when calling `public-analyze-code-graph.yml`
- Never restrict domains in internal workflows
- Breaking internal workflow = broken smoke coverage → catch before merge

## Public Reusable Workflow (`public-analyze-code-graph.yml`)

External-facing. Used by other projects via `workflow_call`. Treat like a public API.

### Breaking Changes — Never

- Never remove or rename existing input parameters
- Never change default behavior without explicit opt-in parameter
- Never change output names
- Add new parameters as `required: false` with safe defaults only

### Descriptions

External users have no repo context. Descriptions must be self-contained:
- State what parameter does, accepted values, constraints
- State default and its effect
- Name example values matching `domains/` subdirectory names
- No internal repo references (no "smoke test", no "internal pipeline")

### Parameters

- `run-all-domains: true` → runs all domains, overrides smart defaults
- `exclude-domain: 'a,b'` → skip named domains, overrides smart defaults
- `run-all-domains` takes priority over `exclude-domain` when both set
- Default (neither set): `analyze.sh` smart defaults apply — `anomaly-detection`, `node-embeddings`, `graph-algorithms` skipped
- Prefer boolean parameters over raw string flags — avoids quoting fragility in `analysis-arguments`
