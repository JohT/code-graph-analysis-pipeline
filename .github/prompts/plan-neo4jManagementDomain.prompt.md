# Plan: Introduce neo4j-management Domain

Create `domains/neo4j-management/` containing all scripts, configs, and tests for installing, configuring, starting, and stopping Neo4j. Move 15 files (10 shell scripts + 5 configuration templates) into the domain. Keep profiles in `scripts/profiles/` and jQAssistant YAML templates in `scripts/configuration/`. Update all references. Create a README with agent-friendly examples.

---

### Phase 1 — Create Domain Structure & Move Files

1. Create `domains/neo4j-management/` with a `configuration/` subdirectory
2. Move **10 shell scripts** from `scripts/` → `domains/neo4j-management/`:
   - [setupNeo4j.sh](domains/neo4j-management/setupNeo4j.sh), [setupNeo4jInitialPassword.sh](domains/neo4j-management/setupNeo4jInitialPassword.sh), [configureNeo4j.sh](domains/neo4j-management/configureNeo4j.sh) *(pre-move locations: `scripts/setupNeo4j.sh`, `scripts/setupNeo4jInitialPassword.sh`, `scripts/configureNeo4j.sh`)*
   - [startNeo4j.sh](domains/neo4j-management/startNeo4j.sh), [stopNeo4j.sh](domains/neo4j-management/stopNeo4j.sh) *(pre-move locations: `scripts/startNeo4j.sh`, `scripts/stopNeo4j.sh`)*
   - [detectNeo4j.sh](domains/neo4j-management/detectNeo4j.sh), [detectNeo4jWindows.sh](domains/neo4j-management/detectNeo4jWindows.sh) *(pre-move locations: `scripts/detectNeo4j.sh`, `scripts/detectNeo4jWindows.sh`)*
   - [waitForNeo4jHttpFunctions.sh](domains/neo4j-management/waitForNeo4jHttpFunctions.sh), [useNeo4jHighMemoryProfile.sh](domains/neo4j-management/useNeo4jHighMemoryProfile.sh) *(pre-move locations: `scripts/waitForNeo4jHttpFunctions.sh`, `scripts/useNeo4jHighMemoryProfile.sh`)*
   - [testConfigureNeo4j.sh](domains/neo4j-management/testConfigureNeo4j.sh) *(pre-move location: `scripts/testConfigureNeo4j.sh`)*
3a. Replace the pre-move scripts `scripts/startNeo4j.sh` and `scripts/stopNeo4j.sh` with **minimal redirect stubs** that forward to [domains/neo4j-management/startNeo4j.sh](domains/neo4j-management/startNeo4j.sh) and [domains/neo4j-management/stopNeo4j.sh](domains/neo4j-management/stopNeo4j.sh) for backward compatibility with existing projects that have forwarding scripts pointing to the old location. The stubs must not be referenced by any new code; they exist solely to avoid breaking old workspaces. Each stub contains only:
   ```bash
   #!/usr/bin/env bash
   # Deprecated: moved to domains/neo4j-management/. This stub exists for backward compatibility only.
   source "$(dirname -- "${BASH_SOURCE[0]}")/../domains/neo4j-management/$(basename -- "${BASH_SOURCE[0]}")" "${@}"
   ```
3. Move **5 neo4j.conf templates** from `scripts/configuration/` → `domains/neo4j-management/configuration/`:
   - `template-neo4j.conf`, `template-neo4j-high-memory.conf`, `template-neo4j-low-memory.conf`, `template-neo4j-v4.conf`, `template-neo4j-v4-low-memory.conf`

### Phase 2 — Update Internal References (within moved scripts)

4. Add `NEO4J_MANAGEMENT_DIR` resolution to each moved script (same pattern as `DOMAIN_SCRIPT_DIR` in other domains), keeping a `SCRIPTS_DIR` fallback for shared utilities like `download.sh` and `operatingSystemFunctions.sh`
5. Update `configureNeo4j.sh` — resolve config templates from `domains/neo4j-management/configuration/` instead of `scripts/configuration/`
6. Update `setupNeo4j.sh` — source `configureNeo4j.sh` and `setupNeo4jInitialPassword.sh` from co-located directory
7. Update the moved `startNeo4j.sh` and `stopNeo4j.sh` in the domain — source `waitForNeo4jHttpFunctions.sh` from the co-located directory
8. Update `useNeo4jHighMemoryProfile.sh` — source `configureNeo4j.sh` from co-located directory
9. Update `testConfigureNeo4j.sh` — source `configureNeo4j.sh` from co-located directory

### Phase 3 — Update External Callers

10. Update [scripts/analysis/analyze.sh](scripts/analysis/analyze.sh) — source `setupNeo4j.sh`, `startNeo4j.sh`, `stopNeo4j.sh` from `${DOMAINS_DIRECTORY}/neo4j-management/` (already resolves `DOMAINS_DIRECTORY`) *(critical path)*
11. Update [init.sh](init.sh) — change forwarding script paths for `startNeo4j.sh` and `stopNeo4j.sh` from `./../../scripts/` to `./../../domains/neo4j-management/`. The redirect stubs in `scripts/` ensure old workspaces (where `init.sh` was already run before this change) still work without any manual migration.
12. Check [scripts/resetAndScan.sh](scripts/resetAndScan.sh) — references `template-neo4j` for jQAssistant YAML path resolution; verify this is about jQAssistant templates (which stay) not neo4j.conf templates

### Phase 4 — Update Documentation

13. Update [COMMANDS.md](COMMANDS.md) — fix links to `setupNeo4j.sh`, `configureNeo4j.sh`, `stopNeo4j.sh`, `useNeo4jHighMemoryProfile.sh`, and configuration template references
14. Update [README.md](README.md) — fix `useNeo4jHighMemoryProfile.sh` usage examples (lines ~304–307)
15. Update [.github/prompts/plan-coding_agent_instructions.prompt.md](.github/prompts/plan-coding_agent_instructions.prompt.md) — fix `startNeo4j.sh` reference
16. Do not change [SCRIPTS.md](SCRIPTS.md) its will be regenerated via `generateScriptReference.sh`
17. Add [CHANGELOG.md](CHANGELOG.md) entry for the domain creation

### Phase 5 — Verify Renovate Patterns

18. Verify [renovate.json](renovate.json) — 5 regex managers use `^scripts/profiles/Neo4j-latest.*\\.sh$` and `^scripts/[^/]*\\.sh$`. Since profiles stay in `scripts/profiles/`, no changes needed unless moved scripts contain `NEO4J_VERSION:-` defaults (unlikely — those are in profiles). *Parallel with Phase 4.*

### Phase 6 — Create README.md

19. Create `domains/neo4j-management/README.md` with:
    - Purpose & scope (install, configure, start, stop Neo4j)
    - Prerequisites (Java, `jq`, `NEO4J_INITIAL_PASSWORD`)
    - Quick-start examples for setting up, starting, stopping Neo4j
    - Environment variables reference
    - Configuration templates explanation
    - Agent-friendly structured instructions for future AGENTS.md / skill usage

---

### Relevant Files

**Move (15 files):** 10 scripts from `scripts/` + 5 templates from `scripts/configuration/` (listed above)

**Create (1 file):** `domains/neo4j-management/README.md`

**Replace with redirect stubs (2 files):** `scripts/startNeo4j.sh`, `scripts/stopNeo4j.sh` — replaced in-place with minimal stubs that forward to the domain; not deleted

**Update (9–11 files):** [analyze.sh](scripts/analysis/analyze.sh), [init.sh](init.sh), [scripts/runTests.sh](scripts/runTests.sh), [COMMANDS.md](COMMANDS.md), [README.md](README.md), [CHANGELOG.md](CHANGELOG.md), [.github/prompts/plan-coding_agent_instructions.prompt.md](.github/prompts/plan-coding_agent_instructions.prompt.md), possibly [scripts/resetAndScan.sh](scripts/resetAndScan.sh) and [renovate.json](renovate.json)

**Stay in place:** All 11 profile scripts, 5 jQAssistant YAML templates, all query function scripts, `scripts/startNeo4j.sh` (as stub), `scripts/stopNeo4j.sh` (as stub)

---

### Verification

1. Update [scripts/runTests.sh](scripts/runTests.sh) — it currently discovers tests with `find "${SCRIPTS_DIR}" -type f -name 'test*.sh'`, searching only the `scripts/` directory. Extend it to also search `domains/` so that `testConfigureNeo4j.sh` in its new location is picked up automatically (and any future domain-level tests are discovered too).
2. Run `./scripts/runTests.sh` from the repository root — verify that `testConfigureNeo4j.sh` is discovered and executed from its new domain location, and that all other tests still pass.
3. Run `shellcheck` on all moved scripts
4. Grep for old paths (`scripts/setupNeo4j|scripts/configureNeo4j|scripts/detectNeo4j|scripts/waitForNeo4j|scripts/useNeo4jHighMemory|scripts/setupNeo4jInitialPassword|scripts/testConfigureNeo4j`) — no stale references should remain. `scripts/startNeo4j.sh` and `scripts/stopNeo4j.sh` are intentionally kept as redirect stubs, so references to them from *outside* this repository (e.g., old workspace forwarding scripts) are expected and acceptable.
5. Verify `init.sh` forwarding scripts point to new locations
6. Verify Renovate regex patterns still match profile files

---

### Decisions

- **Profiles stay in `scripts/profiles/`** — they also contain jQAssistant settings (separate concern)
- **jQAssistant YAML templates stay in `scripts/configuration/`** — not neo4j-specific
- **No COPIED_FILES.md** — files are moved, not copied (clean cut)
- **testConfigureNeo4j.sh moves** into the domain
- **init.sh paths updated directly** — forwarding scripts created by `init.sh` point to the domain going forward
- **`scripts/startNeo4j.sh` and `scripts/stopNeo4j.sh` replaced with redirect stubs** — they forward to the domain implementation; not referenced by any pipeline code after the change, but kept so old project workspaces (already initialised before this change) continue to work without migration
- **No domain entry-point scripts** (`*Csv.sh`, `*Python.sh`) — this domain is infrastructure, not report generation

---

### Pros and Cons: Moving Query Functions

The query execution infrastructure (`executeQueryFunctions.sh`, `executeQuery.sh`, `parseCsvFunctions.sh`, `projectionFunctions.sh`) was evaluated for inclusion:

**Pros of moving:**
- Cohesive grouping — all Neo4j interaction in one place
- Agent-friendly — a single domain to fully operate Neo4j
- Cleaner `scripts/` directory

**Cons of moving:**
- **30+ consumer files need path changes** — every report script, every domain script, `prepareAnalysis.sh`, `importGit.sh`
- **Cross-domain coupling** — other domains would now depend on neo4j-management, breaking vertical-slice independence where each domain only depends on `scripts/`
- **Mixing concerns** — management (lifecycle) and query execution (runtime API) are different layers
- **No benefit to consumers** — the functions are already a stable, well-abstracted API

**Recommendation:** Don't move query functions now. Keep neo4j-management focused on lifecycle management. Query functions could become a separate `neo4j-query-api` domain later if desired.
