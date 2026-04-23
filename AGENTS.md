# AI Agent Instructions

Fully automated pipeline for static code graph analysis.
Built on [jQAssistant](https://jqassistant.github.io/jqassistant/current) and [Neo4j](https://neo4j.com).
Supports Java and experimental TypeScript analysis.

**Keywords:** java, automation, neo4j, graph, static-code-analysis, code-analysis, cypher, git-history, graph-analysis, anomaly-detection, jqassistant, association-rule-mining, machine-learning-pipeline, code-dependency-analysis

## Project Structure

```
├── scripts/analysis/analyze.sh      # Main entry point for end-to-end analysis
├── domains/                         # Vertical-slice domains (self-contained analysis areas)
│   └── <domain-name>/               # One dir per domain — see domains/ for current list
├── cypher/                          # Core Cypher queries (enrichment, projections, types)
├── jupyter/                         # Legacy Jupyter notebooks (migrating into domains)
├── scripts/
│   ├── reports/compilations/        # One *Reports.sh per report type — source of truth
│   ├── reports/                     # Core report scripts
│   └── visualization/              # GraphViz visualization scripts
└── .github/
    ├── prompts/                     # Planning prompts for domain work
    └── skills/                      # Agent skills (caveman, neo4j-management)
```

Each domain: vertical slice with own entry points, queries, scripts, report templates. See domain `README.md` (e.g. [domains/internal-dependencies/README.md](./domains/internal-dependencies/README.md)).

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

Main entry: `analyze.sh`. Run from analysis workspace directory:

```shell
# Full analysis
analyze.sh

# Scoped: single domain + report type. Add --keep-running to skip Neo4j stop/start on repeated runs.
analyze.sh --domain <domain-name> --report <report-type> --keep-running
```

**Report types** — one script per type in [scripts/reports/compilations/](./scripts/reports/compilations/): `All` (default), `Csv`, `Jupyter`, `Python`, `Markdown`, `Visualization`, `DatabaseCsvExport`.

**Domains** — one directory per domain in [domains/](./domains/): `anomaly-detection`, `external-dependencies`, `git-history`, `internal-dependencies`.

See [COMMANDS.md](./COMMANDS.md) for all options including `--profile`, `--explore`.

## Neo4j Management

Neo4j must run before queries or reports. Use [.github/skills/neo4j-management/SKILL.md](./.github/skills/neo4j-management/SKILL.md) to detect, start, stop, configure. Always detect running workspace first.

## Domain Entry Points

Domains discovered by filename pattern in [scripts/reports/compilations/](./scripts/reports/compilations/):

| Pattern | Report type |
|---------|------------|
| `*Csv.sh` | CSV from Cypher queries |
| `*Python.sh` | Python SVG charts |
| `*Visualization.sh` | GraphViz visualizations |
| `*Markdown.sh` | Markdown summary |

---

## Coding Conventions

Scoped instruction files — auto-applied by GitHub Copilot per file type:

| File type | Instruction file |
|-----------|-----------------|
| `*.sh` | [.github/instructions/shell-scripts.instructions.md](./.github/instructions/shell-scripts.instructions.md) |
| `*.py`, `*.ipynb` | [.github/instructions/python.instructions.md](./.github/instructions/python.instructions.md) |
| `*.cypher` | [.github/instructions/cypher-queries.instructions.md](./.github/instructions/cypher-queries.instructions.md) |
| `requirements.txt`, `conda-environment.yml` | [.github/instructions/python-dependencies.instructions.md](./.github/instructions/python-dependencies.instructions.md) |
| `CYPHER.md`, `SCRIPTS.md`, `ENVIRONMENT_VARIABLES.md` | [.github/instructions/generated-reference-docs.instructions.md](./.github/instructions/generated-reference-docs.instructions.md) |
| `.github/skills/`, `.github/instructions/`, `AGENTS.md` | [.github/instructions/agent-files.instructions.md](./.github/instructions/agent-files.instructions.md) |

---

## Verification

Scope verification to domain + report type — avoids full pipeline run:

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

- **Vertical slicing** — each domain self-contained: queries, scripts, charts, templates
- **No generic abstractions** — no "util", "helper", "common", "shared"; share only meaningful domain concepts
- **Progressive automation** — CSV needs no Python; Python/Jupyter add richer output; full pipeline does all
- **Graceful degradation** — domains handle missing data (e.g. no git history) with fallback reports or silent skip
- **Cross-platform** — macOS (zsh), Linux (bash), Windows (Git Bash/WSL)

## Ask Before Assuming

- Ask before making assumptions on architecture, naming, scope
- Read domain READMEs and linked docs before proposing changes
- Check [COMMANDS.md](./COMMANDS.md) for CLI options
- Check [ENVIRONMENT_VARIABLES.md](./ENVIRONMENT_VARIABLES.md) for configuration
- Use plan prompts in [.github/prompts/](./.github/prompts/) for domain creation context