# Plan: Split cyclic-dependencies domain from `internal-dependencies`

Create a new self-contained `domains/cyclic-dependencies/` domain by extracting all cyclic dependency analysis from `domains/internal-dependencies/`. The new domain gets: 7 Cypher queries (moved), `Csv` + `Markdown` entry point scripts, a dedicated `summary/` with Markdown report, and a README. All cyclic content is then fully removed from `internal-dependencies`.

**Decisions:**
- Fully remove from internal-dependencies (Option A)
- Own report directory `reports/cyclic-dependencies/…` (Option A)
- No Python charts for now
- No explore notebooks for now

---

## Phase 1: Create new `cyclic-dependencies` domain

### Step 1 — Move queries
Move all 7 `.cypher` files from `domains/internal-dependencies/queries/cyclic-dependencies/` → `domains/cyclic-dependencies/queries/` (flat; drop the extra subdirectory level since the new domain IS cyclic-dependencies).

Files to move:
- `Cyclic_Dependencies.cypher`
- `Cyclic_Dependencies_Breakdown.cypher`
- `Cyclic_Dependencies_Breakdown_Backward_Only.cypher`
- `Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher`
- `Cyclic_Dependencies_Breakdown_for_Typescript.cypher`
- `Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher`
- `Cyclic_Dependencies_for_Typescript.cypher`

### Step 2 — Create `cyclicDependenciesCsv.sh`
New file: `domains/cyclic-dependencies/cyclicDependenciesCsv.sh`
- Pattern: modelled on `internalDependenciesCsv.sh` header block (SCRIPT_DIR self-detection, SCRIPTS_DIR, strict mode)
- `REPORT_NAME="cyclic-dependencies"`
- `CYCLIC_DEPS_CYPHER_DIR="${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/queries"` (flat)
- Creates dirs: `Java_Package/`, `Java_Artifact/`, `Typescript_Module/` under report dir
- Executes the 7 cyclic queries (extracted from `internalDependenciesCsv.sh` lines ~65-105)
- Sources: `executeQueryFunctions.sh` only (no projection functions needed)
- Variable name prefix: `CYCLIC_DEPENDENCIES_SCRIPT_DIR`

### Step 3 — Create `cyclicDependenciesMarkdown.sh`
New file: `domains/cyclic-dependencies/cyclicDependenciesMarkdown.sh`
- Identical structure to `domains/archetypes/archetypesMarkdown.sh`
- Delegates to `summary/cyclicDependenciesSummary.sh`
- Variable name prefix: `CYCLIC_DEPENDENCIES_SCRIPT_DIR`

### Step 4 — Create `summary/cyclicDependenciesSummary.sh`
New file: `domains/cyclic-dependencies/summary/cyclicDependenciesSummary.sh`
- Pattern: modelled on `internalDependenciesSummary.sh`
- `REPORT_NAME="cyclic-dependencies"`; output: `cyclic_dependencies_report.md`
- `CYCLIC_DEPS_QUERY_CYPHER_DIR` points to `../queries` (flat)
- Implements: `cyclic_dependencies_front_matter()`, `assemble_cyclic_dependencies_report()`
- The assemble function runs 7 `execute_limited_table` calls (extracted from `internalDependenciesSummary.sh` lines ~135-165):
  - Java: Cyclic_Dependencies, Breakdown, Backward_Only, between_Artifacts
  - TypeScript: Cyclic_Dependencies_for_Typescript, Breakdown_for_Typescript, Backward_Only_for_Typescript
- Copies fallback templates (`report_no_cycles_data.template.md`, `report_no_typescript_data.template.md`) to include dir
- Creates `empty.md` fallback
- Uses same `embedMarkdownIncludes.sh` pipeline as other summary scripts
- Reuses helper functions: `limit_markdown_table`, `execute_limited_table` (copy from internal-dependencies summary)

### Step 5 — Create `summary/report.template.md`
New file: `domains/cyclic-dependencies/summary/report.template.md`
- Standalone Cyclic Dependencies Report
- Front matter include
- Executive Overview (explain cycle groups, forwardToBackwardBalance metric)
- Table of Contents with 2 top-level sections
- Section 1: Java Cyclic Dependencies
  - 1.1 Java Package Cyclic Dependencies (Overview) — `<!-- include:Cyclic_Dependencies.md|report_no_cycles_data.template.md -->`
  - 1.2 Java Package Cyclic Dependencies (Breakdown) — `<!-- include:Cyclic_Dependencies_Breakdown.md|report_no_cycles_data.template.md -->`
  - 1.3 Java Package Cyclic Dependencies (Backward Only) — `<!-- include:Cyclic_Dependencies_Breakdown_Backward_Only.md|report_no_cycles_data.template.md -->`
  - 1.4 Java Artifact Cyclic Dependencies — `<!-- include:Cyclic_Dependencies_between_Artifacts.md|report_no_cycles_data.template.md -->`
- Section 2: TypeScript Cyclic Dependencies
  - 2.1 Overview — `<!-- include:Cyclic_Dependencies_for_Typescript.md|report_no_typescript_data.template.md -->`
  - 2.2 Breakdown — `<!-- include:Cyclic_Dependencies_Breakdown_for_Typescript.md|report_no_typescript_data.template.md -->`
  - 2.3 Backward Only — `<!-- include:Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.md|report_no_typescript_data.template.md -->`
- Section 3: Glossary (forwardToBackwardBalance, cycle group, backward/forward dependency)

Note: Reuse the prose from the existing Section 2 of `internal-dependencies/summary/report.template.md` — the explanations are already well-written.

### Step 6 — Create fallback templates in `summary/`
- `domains/cyclic-dependencies/summary/report_no_cycles_data.template.md` — same content as in `internal-dependencies/summary/report_no_cycles_data.template.md`:
  `✅ _No cyclic dependencies detected — the dependency graph is acyclic for this abstraction level._`
- `domains/cyclic-dependencies/summary/report_no_typescript_data.template.md` — same content as in `internal-dependencies/summary/report_no_typescript_data.template.md`:
  `⚠️ _No data available — TypeScript not detected in this codebase._`

### Step 7 — Create `README.md`
New file: `domains/cyclic-dependencies/README.md`
- Domain purpose: focused cyclic dependency analysis independent from the broader internal-dependencies domain
- Entry points table (Csv, Markdown)
- Folder structure (queries/, summary/)
- Output files: `cyclic_dependencies_report.md`, CSV files per abstraction level
- Prerequisite note: requires `prepareAnalysis.sh` and running Neo4j

---

## Phase 2: Remove cyclic content from `internal-dependencies`

### Step 8 — Modify `internalDependenciesCsv.sh`
Remove from `domains/internal-dependencies/internalDependenciesCsv.sh`:
- `CYCLIC_DEPS_CYPHER_DIR` variable declaration (line ~32)
- The 7 cyclic `execute_cypher` blocks for Java (lines ~68-80)
- The 3 cyclic `execute_cypher` blocks for TypeScript (lines ~95-105)
- Update script description comment (remove cyclic from list)

### Step 9 — Modify `internalDependenciesSummary.sh`
Remove from `domains/internal-dependencies/summary/internalDependenciesSummary.sh`:
- `CYCLIC_DEPS_QUERY_CYPHER_DIR` variable declaration (line ~32)
- The 7 `execute_limited_table` calls for cyclic deps (lines ~135-165)
- The `cp -f ... report_no_cycles_data.template.md` copy command (line ~455)

### Step 10 — Modify `summary/report.template.md`
In `domains/internal-dependencies/summary/report.template.md`:
- Remove all of Section 2 (Cyclic Dependencies) — ~60 lines covering 2.1–2.7
- Remove TOC entry for Section 2
- Renumber remaining sections: 3→2, 4→3, 5→4, 6→5, 7→6, 8→7, 9→8, 10→9, 11→10
- Update anchor links in TOC to match new section numbers
- Update Executive Overview: remove cyclic mention, or add cross-reference note: "Cyclic dependency analysis is now in the `cyclic-dependencies` domain"

### Step 11 — Delete stale files
- Delete `domains/internal-dependencies/summary/report_no_cycles_data.template.md` (moved)
- Delete `domains/internal-dependencies/queries/cyclic-dependencies/` directory (all 7 files + dir)

### Step 12 — Update `internal-dependencies` README
In `domains/internal-dependencies/README.md`:
- Remove cyclic dependencies from list of analysis areas
- Add cross-reference to the new `cyclic-dependencies` domain

---

## Verification

1. `shellcheck domains/cyclic-dependencies/cyclicDependenciesCsv.sh`
2. `shellcheck domains/cyclic-dependencies/cyclicDependenciesMarkdown.sh`
3. `shellcheck domains/cyclic-dependencies/summary/cyclicDependenciesSummary.sh`
4. `analyze.sh --domain cyclic-dependencies --report Csv --keep-running`
5. `analyze.sh --domain cyclic-dependencies --report Markdown --keep-running`
6. Verify `reports/cyclic-dependencies/` directory created with CSV files
7. Verify `reports/cyclic-dependencies/cyclic_dependencies_report.md` generated
8. Verify `internal-dependencies` report no longer contains Section 2 (cyclic)
9. `npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json domains/cyclic-dependencies/README.md`
