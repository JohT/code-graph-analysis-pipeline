# Plan: Internal Dependencies Domain — Additional Reports

## Domain Fit Assessment

| Addition | Fits? | Rationale |
|---|---|---|
| DependenciesGraphExploration (Java/TS) | ✅ YES | Visualizes internal dependency hierarchy — core domain content |
| OOP Design Metrics | ✅ YES | Instability + Abstractness measure coupling quality — dependency design metrics defined in terms of dependency ratios |
| Visibility Metrics | ✅ YES | Public API surface encapsulation shapes how modules/packages can depend on each other |
| Wordcloud (code names) | ⚠️ BORDERLINE | General vocabulary analysis, not dependency data; no better domain exists currently |

---

## Extends: plan-internal_dependencies_domain.prompt.md

All steps below are ADDITIONS to that plan. Phase numbering continues from original.

---

## New Files (delta from original plan)

**New Python scripts** (in `domains/internal-dependencies/`):
- `objectOrientedDesignMetricsCharts.py` — scatter + bar charts for instability/abstractness/main sequence
- `visibilityMetricsCharts.py` — scatter subplots for visibility percentiles
- `wordcloudChart.py` — code unit names wordcloud as SVG

**New query directories**:
- `queries/ood-metrics/` — 29 files from `cypher/Metrics/`
- `queries/visibility/` — 4 files from `cypher/Visibility/`
- Add to `queries/exploration/` — `Words_for_universal_Wordcloud.cypher`

**New explore notebooks** (7 additional, copies of jupyter/):
- `explore/DependenciesGraphExplorationJava.ipynb`
- `explore/DependenciesGraphExplorationTypescript.ipynb`
- `explore/ObjectOrientedDesignMetricsJava.ipynb`
- `explore/ObjectOrientedDesignMetricsTypescript.ipynb`
- `explore/VisibilityMetricsJava.ipynb`
- `explore/VisibilityMetricsTypescript.ipynb`
- `explore/Wordcloud.ipynb`

**Updated files**:
- `internalDependenciesCsv.sh` — add OOD metrics + visibility metrics sections
- `internalDependenciesPython.sh` — call 3 new chart scripts
- `summary/report.template.md` — add OOD metrics, visibility, wordcloud sections
- `COPIED_FILES.md` — add all new original→copy mappings

---

## Steps

### Phase 1 Extension: Cypher Queries

**1.10** Copy 29 files from `cypher/Metrics/` into `queries/ood-metrics/`:
- Java (without subpackages): `Get_Incoming_Java_Package_Dependencies.cypher`, `Set_Incoming_Java_Package_Dependencies.cypher`, `Get_Outgoing_Java_Package_Dependencies.cypher`, `Set_Outgoing_Java_Package_Dependencies.cypher`, `Get_Instability_for_Java.cypher`, `Calculate_and_set_Instability_for_Java.cypher`, `Get_Abstractness_for_Java.cypher`, `Calculate_and_set_Abstractness_for_Java.cypher`, `Calculate_distance_between_abstractness_and_instability_for_Java.cypher`
- Java (including subpackages): same 9 files with `_Including_Subpackages` / `_including_subpackages` suffix variants
- TypeScript: `Get_Incoming_Typescript_Module_Dependencies.cypher`, `Set_Incoming_Typescript_Module_Dependencies.cypher`, `Get_Outgoing_Typescript_Module_Dependencies.cypher`, `Set_Outgoing_Typescript_Module_Dependencies.cypher`, `Get_Instability_for_Typescript.cypher`, `Calculate_and_set_Instability_for_Typescript.cypher`, `Get_Abstractness_for_Typescript.cypher`, `Calculate_and_set_Abstractness_for_Typescript.cypher`, `Calculate_distance_between_abstractness_and_instability_for_Typescript.cypher`
- Shared prerequisite: `Count_and_set_abstract_types.cypher` (required before abstractness calculation)

Exact file count: verify with `ls cypher/Metrics/ | wc -l` to ensure no files are missed; the CSV script uses a specific subset, notebooks use more — copy all needed by either.

**1.11** Copy all 4 files from `cypher/Visibility/` into `queries/visibility/`:
- `Global_relative_visibility_statistics_for_types.cypher`
- `Relative_visibility_public_types_to_all_types_per_package.cypher`
- `Global_relative_visibility_statistics_for_elements_for_Typescript.cypher`
- `Relative_visibility_exported_elements_to_all_elements_per_module_for_Typescript.cypher`

**1.12** Copy `cypher/Overview/Words_for_universal_Wordcloud.cypher` → `queries/exploration/` (explore notebook reference + wordcloud chart).

### Phase 2 Extension: CSV Entry Point

**2.x** Extend `internalDependenciesCsv.sh` — add after existing topological sort section:

**OOP Metrics block** (follow `scripts/reports/ObjectOrientedDesignMetricsCsv.sh` ordering):
- Java without subpackages (5 queries): incoming, outgoing, instability, abstractness, main-sequence distance → `Java_Package/`
- Java with subpackages (5 queries): same set with `_Including_Subpackages` suffix → `Java_Package/`
- TypeScript (5 queries): TypeScript equivalents → `Typescript_Module/`
- Note: `Count_and_set_abstract_types.cypher` must run before abstractness queries; check if `ObjectOrientedDesignMetricsCsv.sh` runs it explicitly and replicate that order.

**Visibility Metrics block** (follow `scripts/reports/VisibilityMetricsCsv.sh` ordering):
- Java: global visibility stats per artifact → `Java_Artifact/`, per-package visibility → `Java_Package/`
- TypeScript: global stats per project → `Typescript_Module/`, per-module visibility → `Typescript_Module/`

### Phase 3 Extension: Python Chart Scripts (*parallel with Phase 4 extension*)

**3.6** Create `objectOrientedDesignMetricsCharts.py`:
- `Parameters` class: `--report_directory`, `--queries_directory` (default: `queries/ood-metrics/`), `--verbose`
- Run `Count_and_set_abstract_types.cypher` first (prerequisite for abstractness)
- Run `Calculate_and_set_*` queries (idempotent write-back to graph), then read results
- Chart functions (all save SVG):
  - `plot_top_dependencies_bar(data, title, x_col, y_col, file_path)` — horizontal bar, top 30 packages by incoming/outgoing deps
  - `plot_main_sequence_scatter(data, title, file_path)` — scatter: X=abstractness, Y=instability; point size=type count; color=distance from main sequence (green=near, red=far); green dashed diagonal reference line
- Sections: Java packages (without subpackages), Java packages (including subpackages), TypeScript modules
- Output to: `Java_Package/` and `Typescript_Module/` subdirs within report directory
- Handle "no data" gracefully with warning + skip

**3.7** Create `visibilityMetricsCharts.py`:
- `Parameters` class: `--report_directory`, `--queries_directory` (default: `queries/visibility/`), `--verbose`
- Chart functions:
  - `plot_visibility_scatter(data, title, file_path, percentile_col, y_col)` — scatter: X=visibility percentile (25/50/75), Y=package/module count (log scale); custom Y ticks: 1, 2, 5, 10, 20, 50, 100, 200, 500, 1K, 2K, 5K, 10K
  - `plot_visibility_subplots(java_data, ts_data, report_dir)` — 3-subplot layout matching notebook style
- Output to: `Java_Package/` for Java, `Typescript_Module/` for TypeScript

**3.8** Create `wordcloudChart.py`:
- `Parameters` class: `--report_directory`, `--queries_directory` (default: `queries/exploration/`), `--verbose`
- Run `Words_for_universal_Wordcloud.cypher` to get word list
- Apply same stopwords list as Wordcloud.ipynb (builder, exception, abstract, helper, util, callback, factory, result, handler, test, impl, plugin, etc.)
- Generate wordcloud using `WordCloud.to_svg()` for pure-vector SVG output (800x800, max 600 words, viridis colormap)
- Output: `reports/internal-dependencies/CodeNamesWordcloud.svg`
- Handle "no data" (no nodes with names) with warning + skip

### Phase 4 Extension: Python Entry Point

**4.1 Update** `internalDependenciesPython.sh` — after existing `pathFindingCharts.py` call, add:
```
python objectOrientedDesignMetricsCharts.py --report_directory "${FULL_REPORT_DIRECTORY}" ${verboseMode}
python visibilityMetricsCharts.py --report_directory "${FULL_REPORT_DIRECTORY}" ${verboseMode}
python wordcloudChart.py --report_directory "${FULL_REPORT_DIRECTORY}" ${verboseMode}
```
Follow same pattern as existing call in `externalDependenciesPython.sh`.

### Phase 6 Extension: Markdown Summary

**6.1 Update** `summary/report.template.md` — add new sections after existing content:

**New Section: OOP Design Metrics**
- Introductory paragraph: Condense from notebook — *"Based on Robert C. Martin's stable dependencies principle. **Instability** = outgoing/(incoming+outgoing): 0 = fully stable (many dependents, hard to change), 1 = fully unstable (no dependents, easy to change). **Abstractness** = abstract types / total types: 0 = fully concrete, 1 = fully abstract. The **Main Sequence** diagonal (A + I = 1) defines the ideal balance. Distance from main sequence measures how far a package deviates from this ideal: near 0 = well-balanced, near 1 = problematic ('Zone of Pain' = concrete+stable; 'Zone of Uselessness' = abstract+unstable)."*
- Java packages (without subpackages): table links + scatter chart references with 1-3 sentence descriptions
- Java packages (including subpackages): same
- TypeScript modules: same
- Glossary additions: `Instability`, `Abstractness`, `Distance from Main Sequence`, `Zone of Pain`, `Zone of Uselessness`

**New Section: Visibility Metrics**
- Introductory paragraph: *"Measures the ratio of publicly visible types/elements to all types/elements per package or module. High visibility means most internals are exposed (low encapsulation). The percentile25/50/75 metrics per artifact show whether low-visibility packages are the norm or outliers within each artifact."*
- Java scatter subplot references with chart description
- TypeScript scatter subplot references
- Linked tables: top 40 packages/modules with lowest encapsulation

**New Section: Code Vocabulary (Wordcloud)**
- Introductory paragraph: *"Words derived from code element names across all artifacts/modules (types, methods, variables). Constructed by splitting camelCase/snake_case identifiers, filtering common stopwords (util, helper, factory, etc.), and weighting by frequency. Larger words appear more often in the codebase — revealing dominant concerns and naming patterns."*
- Wordcloud SVG reference (conditional include if file exists)

**6.2 Update** `summary/internalDependenciesSummary.sh` — add:
- Execute OOD metrics read queries → Markdown table includes (instability/abstractness/distance tables for Java + TypeScript)
- Execute visibility read queries → Markdown table includes (low-visibility packages/modules tables)
- Conditional SVG chart references (OOD scatter plots, visibility subplots, wordcloud)

### Phase 7 Extension: Exploration Notebooks (7 additional)

**7.5** Copy `jupyter/DependenciesGraphExplorationJava.ipynb` → `explore/DependenciesGraphExplorationJava.ipynb`
- Already has `ValidateAlwaysFalse` — no metadata change needed

**7.6** Copy `jupyter/DependenciesGraphExplorationTypescript.ipynb` → `explore/DependenciesGraphExplorationTypescript.ipynb`
- Already has `ValidateAlwaysFalse` — no metadata change needed

**7.7** Copy `jupyter/ObjectOrientedDesignMetricsJava.ipynb` → `explore/ObjectOrientedDesignMetricsJava.ipynb`
- Change `"code_graph_analysis_pipeline_data_validation"` from `"ValidateJavaPackageDependencies"` → `"ValidateAlwaysFalse"`

**7.8** Copy `jupyter/ObjectOrientedDesignMetricsTypescript.ipynb` → `explore/ObjectOrientedDesignMetricsTypescript.ipynb`
- Change `"ValidateTypescriptModuleDependencies"` → `"ValidateAlwaysFalse"`

**7.9** Copy `jupyter/VisibilityMetricsJava.ipynb` → `explore/VisibilityMetricsJava.ipynb`
- Change `"ValidateJavaTypes"` → `"ValidateAlwaysFalse"`

**7.10** Copy `jupyter/VisibilityMetricsTypescript.ipynb` → `explore/VisibilityMetricsTypescript.ipynb`
- Change `"ValidateTypescriptModuleDependencies"` → `"ValidateAlwaysFalse"`

**7.11** Copy `jupyter/Wordcloud.ipynb` → `explore/Wordcloud.ipynb`
- Change data validation to `"ValidateAlwaysFalse"`
- Note in COPIED_FILES.md: only "Wordcloud of names in code" section (`Words_for_universal_Wordcloud.cypher`) is replicated in `wordcloudChart.py`; the git authors wordcloud section is explore-only

---

## Relevant Files (delta)

**To create**:
- `domains/internal-dependencies/objectOrientedDesignMetricsCharts.py`
- `domains/internal-dependencies/visibilityMetricsCharts.py`
- `domains/internal-dependencies/wordcloudChart.py`

**To copy** (new Cypher, ~34 files):
- `cypher/Metrics/` → `queries/ood-metrics/` (29 files: 9 Java + 9 Java-subpackages + 9 TypeScript + `Count_and_set_abstract_types.cypher` + 1 TBD from `ObjectOrientedDesignMetricsCsv.sh` reference)
- `cypher/Visibility/` (all 4 files) → `queries/visibility/`
- `cypher/Overview/Words_for_universal_Wordcloud.cypher` → `queries/exploration/`

**To copy** (new notebooks, 7 files):
- `jupyter/DependenciesGraphExplorationJava.ipynb` → `explore/`
- `jupyter/DependenciesGraphExplorationTypescript.ipynb` → `explore/`
- `jupyter/ObjectOrientedDesignMetricsJava.ipynb` → `explore/`
- `jupyter/ObjectOrientedDesignMetricsTypescript.ipynb` → `explore/`
- `jupyter/VisibilityMetricsJava.ipynb` → `explore/`
- `jupyter/VisibilityMetricsTypescript.ipynb` → `explore/`
- `jupyter/Wordcloud.ipynb` → `explore/`

**To modify**:
- `domains/internal-dependencies/internalDependenciesCsv.sh` — add OOD metrics + visibility sections
- `domains/internal-dependencies/internalDependenciesPython.sh` — add 3 new chart script calls
- `domains/internal-dependencies/summary/report.template.md` — add 3 new sections
- `domains/internal-dependencies/summary/internalDependenciesSummary.sh` — add table/chart includes
- `domains/internal-dependencies/COPIED_FILES.md` — add new mappings

**Reference** (read-only, for Python chart implementation):
- `scripts/reports/ObjectOrientedDesignMetricsCsv.sh` — query ordering + output file names
- `scripts/reports/VisibilityMetricsCsv.sh` — query ordering + output file names
- `jupyter/ObjectOrientedDesignMetricsJava.ipynb` — scatter plot implementation details
- `jupyter/VisibilityMetricsJava.ipynb` — 3-subplot scatter implementation + Y-axis tick list
- `jupyter/Wordcloud.ipynb` — stopwords list + wordcloud parameters (800x800, max 600 words, viridis)
- `domains/external-dependencies/externalDependencyCharts.py` — Parameters class pattern

---

## Verification (delta)

1. **Cypher count**: `find domains/internal-dependencies/queries/ -name "*.cypher" | wc -l` = 43 (original) + ~34 (new) ≈ 77
2. **Python compile**: `python -m py_compile domains/internal-dependencies/objectOrientedDesignMetricsCharts.py visibilityMetricsCharts.py wordcloudChart.py`
3. **Shell lint**: `shellcheck` on updated `internalDependenciesCsv.sh` and `internalDependenciesPython.sh`
4. **Notebook metadata**: All 11 explore/ notebooks contain `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"`
5. **No external changes**: No modifications outside `domains/internal-dependencies/`

---

## Further Considerations

1. **Wordcloud domain fit**: Code vocabulary analysis is not directly a dependency metric. If an Overview domain is planned later, `wordcloudChart.py` and `explore/Wordcloud.ipynb` could move there. For now, including it is the pragmatic choice.
2. **Count_and_set_abstract_types prerequisite**: Verify whether `ObjectOrientedDesignMetricsCsv.sh` runs `Count_and_set_abstract_types.cypher` explicitly before abstractness queries — replicate that order in the domain CSV script. If it doesn't (i.e., it's expected to be a prior pipeline step), document it as a prerequisite in PREREQUISITES.md instead of running it inline.
3. **Wordcloud SVG method**: `WordCloud.to_svg()` produces pure-vector SVG. If the installed `wordcloud` library version doesn't support it, fall back to rendering to a matplotlib figure and saving as SVG (rasterized but valid).
