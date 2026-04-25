# Java Domain — Prerequisites

The following are provided by the central pipeline and must run **before** this domain executes.
They are not copied into this domain; they are sourced or referenced from the central pipeline locations.

---

## 1. Neo4j Running with Scanned Java Artifacts

Neo4j must be running and all Java artifacts must have been scanned and loaded into the graph database
before any script in this domain is executed.

See the main [README.md](../../README.md) and [GETTING_STARTED.md](../../GETTING_STARTED.md) for setup instructions.

---

## 2. General Enrichment

The `name` and `extension` properties on `File` nodes must be set by the general enrichment queries before this domain's queries run.

**Cypher source:** [`cypher/General_Enrichment/`](../../cypher/General_Enrichment/)

In particular, `Add_file_name_and_extension.cypher` must have run to ensure `name` and `extension` properties are present on `File` nodes.

---

## 3. Own Enrichment (Runs Automatically)

The following enrichment queries are executed automatically by `artifactDependenciesCsv.sh` before generating CSV output. They do not need to be run separately.

| Query | Purpose |
|-------|---------|
| `queries/enrichment/Set_number_of_Java_packages_and_types_on_artifacts.cypher` | Sets `numberOfPackages` and `numberOfTypes` count properties on each Java artifact |
| `queries/enrichment/Set_maven_artifact_version.cypher` | Sets a parsed Maven version string on each Java artifact where possible |


---

## 4. Graceful Degradation

The analyzed codebase may contain no Java artifacts at all. The domain handles this gracefully:

- `javaCsv.sh` and `artifactDependenciesCsv.sh` produce no output when all queries return empty results. `cleanupAfterReportGeneration.sh` removes empty CSV files. No report directory is created.
- `javaCharts.py` skips chart generation if the report directory does not exist or required CSV files are absent. Exits with code 0.
- `javaMarkdown.sh` uses the `<!-- include:...|report_no_java_data.template.md -->` fallback in the report template to render a "no data available" notice when a section's include file is empty.

---

## 5. Central Pipeline Scripts (sourced, not copied)

| Script | Purpose |
|--------|---------|
| `scripts/executeQueryFunctions.sh` | Provides `execute_cypher()` function used to run Cypher queries |
| `scripts/cleanupAfterReportGeneration.sh` | Removes empty CSV files and report directories after generation |
| `scripts/markdown/embedMarkdownIncludes.sh` | Assembles the final Markdown report by resolving `<!-- include:... -->` directives |
