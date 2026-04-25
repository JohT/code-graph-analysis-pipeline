#!/usr/bin/env python

# Generates Java analysis charts as SVG files from CSV data produced by javaCsv.sh and artifactDependenciesCsv.sh.
# Charts are saved to the report directory and referenced by the Markdown summary report.
#
# Charts produced:
#   Artifact dependencies (incoming): 1 horizontal bar chart
#   Artifact dependencies (outgoing): 1 horizontal bar chart
#   Artifact dependencies (most used): 1 horizontal bar chart
#   Artifact dependency spread (per dependency): 1 horizontal bar chart
#   Artifact dependency spread (per dependent): 1 horizontal bar chart
#   Method metrics (line count distribution): 1 histogram
#   Method metrics (top types by LOC): 1 horizontal bar chart
#   Method metrics (top packages by LOC): 1 horizontal bar chart
#   Java code quality (annotation distribution): 1 horizontal bar chart
#   Java code quality (annotated elements per artifact): 1 horizontal bar chart
#   Java code quality (deprecated element usage by type): 1 horizontal bar chart
#   Web framework annotations (Spring): 1 horizontal bar chart
#   Web framework annotations (Jakarta EE REST): 1 horizontal bar chart
#
# Input Parameters:
#  --report_directory   path to the report directory (contains CSV files from javaCsv.sh and artifactDependenciesCsv.sh)
#  --verbose            optional finer-grained logging
#
# Prerequisites:
#  - javaCsv.sh and artifactDependenciesCsv.sh must have run first to produce the required CSV files.
#  - If the report directory does not exist or CSVs are absent, exits with 0 without generating anything.

import os
import sys
import argparse

import pandas as pd
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend — required for headless script execution
import matplotlib.pyplot as plot

SCRIPT_NAME = "javaCharts"

FIGURE_WIDTH = 14
FIGURE_HEIGHT = 8

TOP_RESULTS_LIMIT = 20
TOP_ANNOTATION_LIMIT = 15

HORIZONTAL_BAR_COLOR = "steelblue"


# ── Parameters ────────────────────────────────────────────────────────────────

class Parameters:
    """Holds parsed command-line parameters for chart generation."""

    def __init__(self, report_directory: str, verbose: bool) -> None:
        self.report_directory = report_directory
        self.verbose = verbose

    def __repr__(self) -> str:
        return (
            f"Parameters("
            f"report_directory={self.report_directory!r}, "
            f"verbose={self.verbose})"
        )

    @staticmethod
    def log_dependency_versions() -> None:
        """Print versions of key dependencies for diagnostics."""
        print("---------------------------------------")
        print(f"Python version: {sys.version}")
        from pandas import __version__ as pandas_version
        print(f"pandas version: {pandas_version}")
        from matplotlib import __version__ as matplotlib_version
        print(f"matplotlib version: {matplotlib_version}")
        print("---------------------------------------")


def parse_parameters() -> Parameters:
    """Parse command-line arguments and return a Parameters instance."""
    parser = argparse.ArgumentParser(
        description="Generates Java analysis charts as SVG files from CSV data."
    )
    parser.add_argument(
        "--report_directory",
        type=str,
        default="",
        help="Path to the report directory containing CSV files from javaCsv.sh and artifactDependenciesCsv.sh",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        default=False,
        help="Enable verbose mode for detailed logging",
    )
    args = parser.parse_args()
    return Parameters(
        report_directory=args.report_directory,
        verbose=args.verbose,
    )


# ── CSV loading helpers ───────────────────────────────────────────────────────

def load_csv(report_directory: str, filename: str, verbose: bool) -> pd.DataFrame:
    """Load a CSV file from the report directory. Returns empty DataFrame if file is missing."""
    path = os.path.join(report_directory, filename)
    if not os.path.isfile(path):
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping — CSV not found: {path}")
        return pd.DataFrame()
    data_frame = pd.read_csv(path)
    if verbose:
        print(f"{SCRIPT_NAME}: Loaded {len(data_frame)} rows from {path}")
    return data_frame


def save_figure(figure: plot.Figure, report_directory: str, chart_name: str, verbose: bool) -> None:
    """Save a matplotlib figure as an SVG file to the report directory."""
    output_path = os.path.join(report_directory, f"{chart_name}.svg")
    figure.savefig(output_path, format="svg", bbox_inches="tight")
    plot.close(figure)
    if verbose:
        print(f"{SCRIPT_NAME}: Saved chart to {output_path}")


def extract_simple_name(fully_qualified_name: str) -> str:
    """Extract the simple (last segment) name from a fully qualified name."""
    return fully_qualified_name.split(".")[-1] if "." in fully_qualified_name else fully_qualified_name


def extract_artifact_name(file_name: str) -> str:
    """Extract a short display name from an artifact file path."""
    base = os.path.basename(file_name)
    # Remove .jar or .war suffix for display
    for suffix in (".jar", ".war", ".ear", ".zip"):
        if base.endswith(suffix):
            return base[: -len(suffix)]
    return base


# ── Artifact dependency charts ────────────────────────────────────────────────

def generate_incoming_dependencies_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of the top artifacts by incoming dependency count."""
    data_frame = load_csv(report_directory, "IncomingDependencies.csv", verbose)
    if data_frame.empty:
        return

    data_frame = data_frame.nlargest(TOP_RESULTS_LIMIT, "incomingDependencies")
    data_frame = data_frame.sort_values("incomingDependencies", ascending=True)
    data_frame["ArtifactName"] = data_frame["a.fileName"].apply(extract_artifact_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(data_frame["ArtifactName"], data_frame["incomingDependencies"], color=HORIZONTAL_BAR_COLOR)
    axis.set_xlabel("Incoming Dependencies")
    axis.set_title(f"Top {TOP_RESULTS_LIMIT} Artifacts by Incoming Dependency Count")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "ArtifactDependencies_IncomingTop20_Bar", verbose)


def generate_outgoing_dependencies_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of the top artifacts by outgoing dependency count."""
    data_frame = load_csv(report_directory, "OutgoingDependencies.csv", verbose)
    if data_frame.empty:
        return

    data_frame = data_frame.nlargest(TOP_RESULTS_LIMIT, "outgoingDependencies")
    data_frame = data_frame.sort_values("outgoingDependencies", ascending=True)
    data_frame["ArtifactName"] = data_frame["a.fileName"].apply(extract_artifact_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(data_frame["ArtifactName"], data_frame["outgoingDependencies"], color=HORIZONTAL_BAR_COLOR)
    axis.set_xlabel("Outgoing Dependencies")
    axis.set_title(f"Top {TOP_RESULTS_LIMIT} Artifacts by Outgoing Dependency Count")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "ArtifactDependencies_OutgoingTop20_Bar", verbose)


def generate_most_used_dependencies_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of the most used internal dependencies by how many artifacts depend on them."""
    data_frame = load_csv(report_directory, "MostUsedDependenciesAcrossArtifacts.csv", verbose)
    if data_frame.empty:
        return

    data_frame = data_frame.nlargest(TOP_RESULTS_LIMIT, "usedByPackages")
    data_frame = data_frame.sort_values("usedByPackages", ascending=True)
    data_frame["DependencyName"] = data_frame["dependency"].apply(extract_artifact_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(data_frame["DependencyName"], data_frame["usedByPackages"], color=HORIZONTAL_BAR_COLOR)
    axis.set_xlabel("Used By (Package Count)")
    axis.set_title(f"Top {TOP_RESULTS_LIMIT} Most Used Internal Dependencies")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "ArtifactDependencies_MostUsedTop20_Bar", verbose)


def generate_spread_per_dependency_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart showing dependency usage spread (top artifacts depended upon most widely)."""
    data_frame = load_csv(report_directory, "InternalArtifactUsageSpreadPerDependency.csv", verbose)
    if data_frame.empty:
        return

    data_frame = data_frame.nlargest(TOP_RESULTS_LIMIT, "usedInArtifacts")
    data_frame = data_frame.sort_values("usedInArtifacts", ascending=True)
    data_frame["DependencyName"] = data_frame["dependencyArtifactName"].apply(extract_artifact_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(data_frame["DependencyName"], data_frame["usedInArtifacts"], color=HORIZONTAL_BAR_COLOR)
    axis.set_xlabel("Spread (Dependent Artifact Count)")
    axis.set_title(f"Top {TOP_RESULTS_LIMIT} Internal Dependencies by Usage Spread")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "ArtifactDependencies_SpreadPerDependency_Bar", verbose)


def generate_spread_per_dependent_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart showing dependent usage spread (top artifacts with most diverse dependencies)."""
    data_frame = load_csv(report_directory, "InternalArtifactUsageSpreadPerDependent.csv", verbose)
    if data_frame.empty:
        return

    data_frame = data_frame.nlargest(TOP_RESULTS_LIMIT, "artifactDependencies")
    data_frame = data_frame.sort_values("artifactDependencies", ascending=True)
    data_frame["ArtifactName"] = data_frame["artifactName"].apply(extract_artifact_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(data_frame["ArtifactName"], data_frame["artifactDependencies"], color=HORIZONTAL_BAR_COLOR)
    axis.set_xlabel("Spread (Dependency Count)")
    axis.set_title(f"Top {TOP_RESULTS_LIMIT} Internal Artifacts by Dependent Spread")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "ArtifactDependencies_SpreadPerDependent_Bar", verbose)


# ── Method metrics charts ─────────────────────────────────────────────────────

def generate_method_line_count_distribution_chart(report_directory: str, verbose: bool) -> None:
    """Generate a histogram showing the distribution of effective method line counts."""
    data_frame = load_csv(report_directory, "EffectiveMethodLineCountDistribution.csv", verbose)
    if data_frame.empty:
        return

    # Aggregate across all artifacts: sum method counts per line count
    distribution = data_frame.groupby("effectiveLineCount")["methods"].sum().reset_index()
    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.bar(
        distribution["effectiveLineCount"],
        distribution["methods"],
        width=1.0,
        color=HORIZONTAL_BAR_COLOR,
        edgecolor="white",
        linewidth=0.3,
    )
    axis.set_xlabel("Effective Line Count")
    axis.set_ylabel("Number of Methods")
    axis.set_title("Effective Method Line Count Distribution")

    save_figure(figure, report_directory, "MethodMetrics_LineCountDistribution_Histogram", verbose)


def generate_top_types_by_loc_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of the top types by total effective lines of method code."""
    data_frame = load_csv(report_directory, "EffectiveLinesOfMethodCodePerType.csv", verbose)
    if data_frame.empty:
        return

    data_frame = data_frame.nlargest(TOP_RESULTS_LIMIT, "sumEffectiveLinesOfMethodCode")
    data_frame = data_frame.sort_values("sumEffectiveLinesOfMethodCode", ascending=True)
    data_frame["TypeName"] = data_frame["typeName"].apply(extract_simple_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(data_frame["TypeName"], data_frame["sumEffectiveLinesOfMethodCode"], color=HORIZONTAL_BAR_COLOR)
    axis.set_xlabel("Total Effective Lines of Method Code")
    axis.set_title(f"Top {TOP_RESULTS_LIMIT} Types by Effective Lines of Method Code")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "MethodMetrics_TopTypesLOC_Bar", verbose)


def generate_top_packages_by_loc_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of the top packages by total effective lines of method code."""
    data_frame = load_csv(report_directory, "EffectiveLinesOfMethodCodePerPackage.csv", verbose)
    if data_frame.empty:
        return

    data_frame = data_frame.nlargest(TOP_RESULTS_LIMIT, "linesInPackage")
    data_frame = data_frame.sort_values("linesInPackage", ascending=True)
    data_frame["PackageName"] = data_frame["packageName"].apply(extract_simple_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(data_frame["PackageName"], data_frame["linesInPackage"], color=HORIZONTAL_BAR_COLOR)
    axis.set_xlabel("Total Effective Lines of Method Code")
    axis.set_title(f"Top {TOP_RESULTS_LIMIT} Packages by Effective Lines of Method Code")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "MethodMetrics_TopPackagesLOC_Bar", verbose)


# ── Java code quality charts ──────────────────────────────────────────────────

def generate_annotation_type_distribution_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of the most frequently used annotations."""
    data_frame = load_csv(report_directory, "AnnotatedCodeElements.csv", verbose)
    if data_frame.empty:
        return

    annotation_counts = (
        data_frame.groupby("annotationName")["numberOfAnnotatedElements"]
        .sum()
        .reset_index()
        .nlargest(TOP_ANNOTATION_LIMIT, "numberOfAnnotatedElements")
        .sort_values("numberOfAnnotatedElements", ascending=True)
    )
    annotation_counts["AnnotationName"] = annotation_counts["annotationName"].apply(extract_simple_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(annotation_counts["AnnotationName"], annotation_counts["numberOfAnnotatedElements"], color=HORIZONTAL_BAR_COLOR)
    axis.set_xlabel("Number of Annotated Elements")
    axis.set_title(f"Top {TOP_ANNOTATION_LIMIT} Annotations by Usage Count")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "JavaCodeQuality_AnnotationTypeDistribution_Bar", verbose)


def generate_annotated_elements_per_artifact_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of the top artifacts by annotated element count."""
    data_frame = load_csv(report_directory, "AnnotatedCodeElementsPerArtifact.csv", verbose)
    if data_frame.empty:
        return

    artifact_counts = (
        data_frame.groupby("artifactName")["numberOfAnnotatedElements"]
        .sum()
        .reset_index(name="annotatedElementCount")
        .nlargest(TOP_RESULTS_LIMIT, "annotatedElementCount")
        .sort_values("annotatedElementCount", ascending=True)
    )
    artifact_counts["ArtifactName"] = artifact_counts["artifactName"].apply(extract_artifact_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(artifact_counts["ArtifactName"], artifact_counts["annotatedElementCount"], color=HORIZONTAL_BAR_COLOR)
    axis.set_xlabel("Annotated Element Count")
    axis.set_title(f"Top {TOP_RESULTS_LIMIT} Artifacts by Annotated Element Count")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "JavaCodeQuality_AnnotatedElementsPerArtifact_Bar", verbose)


def generate_deprecated_element_usage_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of deprecated element usage by deprecated element count."""
    data_frame = load_csv(report_directory, "DeprecatedElementUsage.csv", verbose)
    if data_frame.empty:
        return

    deprecated_counts = (
        data_frame.groupby("deprecatedElement")["numberOfElementsUsingDeprecatedElements"]
        .sum()
        .reset_index()
        .nlargest(TOP_RESULTS_LIMIT, "numberOfElementsUsingDeprecatedElements")
        .sort_values("numberOfElementsUsingDeprecatedElements", ascending=True)
    )
    deprecated_counts["ElementName"] = deprecated_counts["deprecatedElement"].apply(extract_simple_name)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))
    axis.barh(deprecated_counts["ElementName"], deprecated_counts["numberOfElementsUsingDeprecatedElements"], color="coral")
    axis.set_xlabel("Number of Usages")
    axis.set_title(f"Top {TOP_RESULTS_LIMIT} Most Used Deprecated Elements")
    axis.tick_params(axis="y", labelsize=8)

    save_figure(figure, report_directory, "JavaCodeQuality_DeprecatedElementUsageTop20_Bar", verbose)


# ── Web framework annotation charts ──────────────────────────────────────────

def generate_spring_endpoints_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of Spring Web endpoints by HTTP mapping annotation type."""
    data_frame = load_csv(report_directory, "SpringWebRequestAnnotations.csv", verbose)
    if data_frame.empty:
        return

    annotation_counts = (
        data_frame["httpMethod"]
        .apply(extract_simple_name)
        .value_counts()
        .reset_index()
    )
    annotation_counts.columns = ["httpMethod", "count"]
    annotation_counts = annotation_counts.sort_values("count", ascending=True)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, max(4, len(annotation_counts) * 0.5 + 2)))
    axis.barh(annotation_counts["httpMethod"], annotation_counts["count"], color="seagreen")
    axis.set_xlabel("Number of Endpoints")
    axis.set_title("Spring Web Endpoints by HTTP Mapping Annotation")

    save_figure(figure, report_directory, "WebFrameworks_SpringEndpointsByAnnotation_Bar", verbose)


def generate_jakarta_ee_endpoints_chart(report_directory: str, verbose: bool) -> None:
    """Generate a horizontal bar chart of Jakarta EE REST endpoints by HTTP method annotation type."""
    data_frame = load_csv(report_directory, "JakartaEE_REST_Annotations.csv", verbose)
    if data_frame.empty:
        return

    annotation_counts = (
        data_frame["httpMethod"]
        .apply(extract_simple_name)
        .value_counts()
        .reset_index()
    )
    annotation_counts.columns = ["httpMethod", "count"]
    annotation_counts = annotation_counts.sort_values("count", ascending=True)

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, max(4, len(annotation_counts) * 0.5 + 2)))
    axis.barh(annotation_counts["httpMethod"], annotation_counts["count"], color="darkorange")
    axis.set_xlabel("Number of Endpoints")
    axis.set_title("Jakarta EE REST Endpoints by HTTP Method Annotation")

    save_figure(figure, report_directory, "WebFrameworks_JakartaEEEndpointsByAnnotation_Bar", verbose)


# ── Main ──────────────────────────────────────────────────────────────────────

def generate_all_charts(report_directory: str, verbose: bool) -> None:
    """Generate all Java analysis charts and save them as SVG files to the report directory."""
    generate_incoming_dependencies_chart(report_directory, verbose)
    generate_outgoing_dependencies_chart(report_directory, verbose)
    generate_most_used_dependencies_chart(report_directory, verbose)
    generate_spread_per_dependency_chart(report_directory, verbose)
    generate_spread_per_dependent_chart(report_directory, verbose)
    generate_method_line_count_distribution_chart(report_directory, verbose)
    generate_top_types_by_loc_chart(report_directory, verbose)
    generate_top_packages_by_loc_chart(report_directory, verbose)
    generate_annotation_type_distribution_chart(report_directory, verbose)
    generate_annotated_elements_per_artifact_chart(report_directory, verbose)
    generate_deprecated_element_usage_chart(report_directory, verbose)
    generate_spring_endpoints_chart(report_directory, verbose)
    generate_jakarta_ee_endpoints_chart(report_directory, verbose)


def main() -> None:
    """Entry point: parse parameters and generate all Java analysis charts."""
    parameters = parse_parameters()

    if parameters.verbose:
        Parameters.log_dependency_versions()
        print(f"{SCRIPT_NAME}: Parameters: {parameters}")

    if not parameters.report_directory:
        print(f"{SCRIPT_NAME}: No report directory specified. Exiting.")
        sys.exit(0)

    if not os.path.isdir(parameters.report_directory):
        print(f"{SCRIPT_NAME}: Report directory not found: {parameters.report_directory!r} — no Java data. Skipping chart generation.")
        sys.exit(0)

    print(f"{SCRIPT_NAME}: Generating Java analysis charts from {parameters.report_directory!r}")
    generate_all_charts(parameters.report_directory, parameters.verbose)
    print(f"{SCRIPT_NAME}: Successfully finished.")


if __name__ == "__main__":
    main()
