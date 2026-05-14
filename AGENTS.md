# AI Agent Instructions

Automated pipeline for static code graph analysis.
Built on [jQAssistant](https://jqassistant.github.io/jqassistant/current) and [Neo4j](https://neo4j.com).
Java + experimental TypeScript.

**Keywords:** java, automation, neo4j, graph, static-code-analysis, code-analysis, cypher, git-history, graph-analysis, anomaly-detection, jqassistant, association-rule-mining, machine-learning-pipeline, code-dependency-analysis

## Project Structure

```
├── scripts/analysis/analyze.sh      # Main entry point for end-to-end analysis
├── domains/                         # Vertical-slice domains (self-contained analysis areas)
│   └── <domain-name>/               # One dir per domain — see domains/ for current list
├── cypher/                          # Core Cypher queries (enrichment, projections, types)
├── scripts/
│   ├── reports/compilations/        # One *Reports.sh per report type — source of truth
│   ├── reports/                     # Core report scripts
│   └── visualization/              # GraphViz visualization scripts
└── .github/
    ├── prompts/                     # Planning prompts for domain work
    └── skills/                      # Agent skills (caveman, neo4j-management)
```

Each domain: vertical slice with own entry points, queries, scripts, templates. See domain `README.md` (e.g. [domains/internal-dependencies/README.md](./domains/internal-dependencies/README.md)).

## Key Docs

| Document | Purpose |
|----------|---------|
| [README.md](./README.md) | Overview, features, prerequisites |
| [GETTING_STARTED.md](./GETTING_STARTED.md) | Quick-start |
| [COMMANDS.md](./COMMANDS.md) | All CLI commands, `analyze.sh` options |
| [INTEGRATION.md](./INTEGRATION.md) | CI/CD (GitHub Actions) |
| [SCRIPTS.md](./SCRIPTS.md) | Generated script reference |
| [CYPHER.md](./CYPHER.md) | Generated Cypher query reference |
| [ENVIRONMENT_VARIABLES.md](./ENVIRONMENT_VARIABLES.md) | All env vars with defaults |

## Running Pipeline

Main entry: `analyze.sh`. Run from analysis workspace directory. Repo scripts + domains discovered automatically:

```shell
# Full analysis
analyze.sh

# Scoped: single domain + report type. Add --keep-running to skip Neo4j stop/start on repeated runs.
analyze.sh --domain <domain-name> --report <report-type> --keep-running

# Skip specific domains during analysis
analyze.sh --exclude-domain "anomaly-detection,node-embeddings"
```

**Report types** — [scripts/reports/compilations/](./scripts/reports/compilations/): `All` (default), `Csv`, `Python`, `Markdown`, `Visualization`, `DatabaseCsvExport`.

**Domains** — [domains/](./domains/): `anomaly-detection`, `archetypes`, `external-dependencies`, `git-history`, `internal-dependencies`, `java`.

All options: [COMMANDS.md](./COMMANDS.md).

## Neo4j Management

Neo4j required. Use [.github/skills/neo4j-management/SKILL.md](./.github/skills/neo4j-management/SKILL.md) to detect, start, stop, configure.

## Domain Entry Points

Filename pattern in [scripts/reports/compilations/](./scripts/reports/compilations/):

| Pattern | Report type |
|---------|------------|
| `*Csv.sh` | CSV from Cypher queries |
| `*Python.sh` | Python SVG charts |
| `*Visualization.sh` | GraphViz visualizations |
| `*Markdown.sh` | Markdown summary |

---

## Coding Conventions

Instruction files auto-applied per file type:

| File type | Instruction file |
|-----------|-----------------|
| `*.sh` | [.github/instructions/shell-scripts.instructions.md](./.github/instructions/shell-scripts.instructions.md) |
| `*.py`, `*.ipynb` | [.github/instructions/python.instructions.md](./.github/instructions/python.instructions.md) |
| `*.cypher` | [.github/instructions/cypher-queries.instructions.md](./.github/instructions/cypher-queries.instructions.md) |
| `*.gv`, `*.dot` | [.github/instructions/graphviz.instructions.md](./.github/instructions/graphviz.instructions.md) |
| `pyproject.toml`, `conda-environment.yml` | [.github/instructions/python-dependencies.instructions.md](./.github/instructions/python-dependencies.instructions.md) |
| `CYPHER.md`, `SCRIPTS.md`, `ENVIRONMENT_VARIABLES.md` | [.github/instructions/generated-reference-docs.instructions.md](./.github/instructions/generated-reference-docs.instructions.md) |
| `.github/skills/`, `.github/instructions/`, `AGENTS.md` | [.github/instructions/agent-files.instructions.md](./.github/instructions/agent-files.instructions.md) |
| `.github/workflows/*.yml` | [.github/instructions/github-workflows.instructions.md](./.github/instructions/github-workflows.instructions.md) |
| `renovate.json` | [.github/instructions/renovate.instructions.md](./.github/instructions/renovate.instructions.md) |

---

## CI/CD Conventions

### Internal Workflows

`internal-*.yml` test pipeline itself — all domains run including `analyze.sh` defaults-skipped ones (`anomaly-detection`, `node-embeddings`, `graph-algorithms`). Purpose: smoke test end-to-end. Always set `run-all-domains: true`. Never restrict domains.

### Public Reusable Workflow

`public-analyze-code-graph.yml` external-facing. Used by other projects via `workflow_call`. Treat like public API:
- No breaking changes (no removal/rename of inputs or outputs)
- New params: `required: false` with safe defaults only
- Descriptions self-contained — external users have no repo context
- Prefer boolean params over raw string flags (avoids quoting fragility)

---

## Verification

Test single domain + report type (faster than full pipeline):

```shell
# Detect Neo4j workspace first (see neo4j-management skill above)
analyze.sh --domain git-history --report Csv --keep-running
analyze.sh --domain anomaly-detection --report Python --keep-running
```

- Shell: `shellcheck <script.sh>`
- Python: Pylance type checking
- Markdown links: `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json <file.md>`

---

## Design Principles

- **Vertical slicing** — domains self-contained: queries, scripts, charts, templates
- **No generic abstractions** — no "util", "helper", "common"; share only meaningful concepts
- **Progressive automation** — CSV (no Python) → Python (richer) → all reports
- **Graceful degradation** — domains handle missing data (e.g. no git history) with fallbacks
- **Cross-platform** — macOS, Linux, Windows (Git Bash/WSL)
- **Fail-fast** — clear errors on missing dependencies, misconfigurations, unsupported environments

## Before Proposing Changes

- Verify architecture, naming, scope assumptions
- Read domain READMEs + linked docs
- Check [COMMANDS.md](./COMMANDS.md) CLI options
- Check [ENVIRONMENT_VARIABLES.md](./ENVIRONMENT_VARIABLES.md) config
- Use plan prompts in [.github/prompts/](./.github/prompts/) for domain context