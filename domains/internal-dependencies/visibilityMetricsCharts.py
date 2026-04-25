#!/usr/bin/env python

# Generates visibility metrics charts as SVG files from CSV data produced by internalDependenciesCsv.sh.
# Charts are saved to the report directory subdirectories and referenced by the Markdown summary report.
#
# Input Parameters:
#  --report_directory   path to the report directory (contains Java_Artifact/, Java_Package/, etc.)
#  --verbose            optional finer-grained logging
#
# Prerequisites:
#  - internalDependenciesCsv.sh must have run first to produce the required CSV files.

import os
import sys
import argparse

import pandas as pd

import matplotlib
matplotlib.use('Agg')  # Non-interactive backend — required for headless script execution
import matplotlib.pyplot as plot

SCRIPT_NAME = "visibilityMetricsCharts"

# Y-axis ticks for log-scale scatter charts (matching the notebook's custom tick list)
LOG_Y_TICKS = [1, 2, 5, 10, 20, 50, 100, 200, 500, 1_000, 2_000, 5_000, 10_000]

MAIN_COLOR_MAP = "nipy_spectral"


class Parameters:
    def __init__(
        self,
        report_directory: str,
        verbose: bool,
    ) -> None:
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
        """Prints versions of key dependencies for debugging."""
        print("---------------------------------------")
        print(f"Python version: {sys.version}")
        from pandas import __version__ as pandas_version
        print(f"pandas version: {pandas_version}")
        from matplotlib import __version__ as matplotlib_version
        print(f"matplotlib version: {matplotlib_version}")
        print("---------------------------------------")


def parse_parameters() -> Parameters:
    """Parses command-line arguments and returns a Parameters instance."""
    parser = argparse.ArgumentParser(
        description="Generates visibility metrics charts as SVG files from CSV data."
    )
    parser.add_argument(
        "--report_directory",
        type=str,
        default="",
        help="Path to the report directory containing abstraction-level subdirectories with CSV files",
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


def chart_file_path(name: str, level_directory: str, verbose: bool) -> str:
    """Returns the full SVG file path for a named chart within the level directory."""
    path = os.path.join(level_directory, name + ".svg")
    if verbose:
        print(f"{SCRIPT_NAME}: Saving {path}")
    return path


def load_csv(csv_path: str, verbose: bool) -> pd.DataFrame:
    """Loads a CSV file into a DataFrame; returns empty DataFrame if file is missing or empty."""
    if not os.path.isfile(csv_path):
        if verbose:
            print(f"{SCRIPT_NAME}: CSV not found, skipping: {csv_path}")
        return pd.DataFrame()
    data_frame = pd.read_csv(csv_path)
    if verbose:
        print(f"{SCRIPT_NAME}: Loaded {len(data_frame)} rows from {os.path.basename(csv_path)}")
    return data_frame


# ── Chart rendering functions ──────────────────────────────────────────────────


def plot_visibility_per_artifact_subplots(
    data_frame: pd.DataFrame,
    title_prefix: str,
    y_label: str,
    file_path: str,
) -> None:
    """
    Renders a 3-subplot scatter chart of relative visibility percentiles vs. unit count.

    Three subplots share the X-axis:
    - Top: 75th percentile of relative visibility vs. unit count (log scale)
    - Middle: 50th percentile (median) vs. unit count
    - Bottom: 25th percentile vs. unit count

    Skips silently when the input is empty or required columns are missing.
    """
    if data_frame.empty:
        print(f"{SCRIPT_NAME}: No data for '{title_prefix}', skipping chart.")
        return

    required_columns = {"percentile25", "percentile50", "percentile75", "all"}
    missing = required_columns - set(data_frame.columns)
    if missing:
        print(f"{SCRIPT_NAME}: Missing columns {missing} for '{title_prefix}', skipping chart.")
        return

    figure, axes = plot.subplots(nrows=3, ncols=1, sharex=True, figsize=(10, 12))

    for axis, percentile_col, subplot_title in [
        (axes[0], "percentile75", f"{title_prefix} (75th percentile)"),
        (axes[1], "percentile50", f"{title_prefix} (50th percentile / median)"),
        (axes[2], "percentile25", f"{title_prefix} (25th percentile)"),
    ]:
        data_frame.plot(
            ax=axis,
            kind="scatter",
            title=subplot_title,
            x=percentile_col,
            y="all",
            grid=True,
            logy=True,
            yticks=LOG_Y_TICKS,
            xlabel="relative visibility",
            ylabel=y_label,
            cmap=MAIN_COLOR_MAP,
        )
        axis.grid(color="grey", linestyle="-", linewidth=0.2)

    plot.tight_layout()
    plot.savefig(file_path, bbox_inches="tight")
    plot.close(figure)


def plot_visibility_per_unit_scatter(
    data_frame: pd.DataFrame,
    title: str,
    x_column: str,
    y_column: str,
    x_label: str,
    y_label: str,
    file_path: str,
) -> None:
    """
    Renders a scatter chart of relative visibility vs. element count with log Y-axis.

    Skips silently when the input is empty or required columns are missing.
    """
    if data_frame.empty:
        print(f"{SCRIPT_NAME}: No data for '{title}', skipping chart.")
        return

    required_columns = {x_column, y_column}
    missing = required_columns - set(data_frame.columns)
    if missing:
        print(f"{SCRIPT_NAME}: Missing columns {missing} for '{title}', skipping chart.")
        return

    figure, axis = plot.subplots(figsize=(10, 6))
    data_frame.plot(
        ax=axis,
        kind="scatter",
        title=title,
        x=x_column,
        y=y_column,
        grid=True,
        logy=True,
        yticks=LOG_Y_TICKS,
        xlabel=x_label,
        ylabel=y_label,
        cmap=MAIN_COLOR_MAP,
    )
    axis.grid(color="grey", linestyle="-", linewidth=0.2)

    plot.tight_layout()
    plot.savefig(file_path, bbox_inches="tight")
    plot.close(figure)


# ── Per-language chart generation ─────────────────────────────────────────────


def generate_java_visibility_charts(report_directory: str, verbose: bool) -> None:
    """Generates Java visibility metric charts from CSV files."""
    artifact_dir = os.path.join(report_directory, "Java_Artifact")
    package_dir = os.path.join(report_directory, "Java_Package")

    # Per-artifact subplots (percentile25/50/75 vs. number of packages)
    per_artifact_csv = os.path.join(artifact_dir, "RelativeVisibilityPerArtifact.csv")
    per_artifact_data = load_csv(per_artifact_csv, verbose)
    if not per_artifact_data.empty:
        plot_visibility_per_artifact_subplots(
            data_frame=per_artifact_data,
            title_prefix="Relative visibility in Java artifacts",
            y_label="number of types",
            file_path=chart_file_path("Java_Artifact_VisibilityPercentiles", artifact_dir, verbose),
        )

    # Per-artifact scatter (percentile50 / median visibility vs. number of types)
    if not per_artifact_data.empty:
        plot_visibility_per_unit_scatter(
            data_frame=per_artifact_data,
            title="Relative visibility of Java artifacts (median)",
            x_column="percentile50",
            y_column="all",
            x_label="relative visibility (median)",
            y_label="number of types",
            file_path=chart_file_path("Java_Artifact_RelativeVisibility", artifact_dir, verbose),
        )

    # Per-package scatter (relativeVisibility vs. allTypes)
    per_package_csv = os.path.join(package_dir, "RelativeVisibilityPerPackage.csv")
    per_package_data = load_csv(per_package_csv, verbose)
    if not per_package_data.empty:
        plot_visibility_per_unit_scatter(
            data_frame=per_package_data,
            title="Relative visibility of Java packages",
            x_column="relativeVisibility",
            y_column="allTypes",
            x_label="relative visibility",
            y_label="number of types",
            file_path=chart_file_path("Java_Package_RelativeVisibility", package_dir, verbose),
        )


def generate_typescript_visibility_charts(report_directory: str, verbose: bool) -> None:
    """Generates TypeScript visibility metric charts from CSV files."""
    module_dir = os.path.join(report_directory, "Typescript_Module")

    # Per-project subplots (percentile25/50/75 vs. number of modules)
    per_project_csv = os.path.join(module_dir, "RelativeVisibilityPerTypescriptProject.csv")
    per_project_data = load_csv(per_project_csv, verbose)
    if not per_project_data.empty:
        plot_visibility_per_artifact_subplots(
            data_frame=per_project_data,
            title_prefix="Relative visibility in TypeScript projects",
            y_label="number of elements",
            file_path=chart_file_path("Typescript_Module_VisibilityPercentiles", module_dir, verbose),
        )

    # Per-project scatter (percentile50 / median visibility vs. number of elements)
    if not per_project_data.empty:
        plot_visibility_per_unit_scatter(
            data_frame=per_project_data,
            title="Relative visibility of TypeScript projects (median)",
            x_column="percentile50",
            y_column="all",
            x_label="relative visibility (median)",
            y_label="number of elements",
            file_path=chart_file_path("Typescript_Project_RelativeVisibility", module_dir, verbose),
        )

    # Per-module scatter (relativeVisibility vs. element count)
    per_module_csv = os.path.join(module_dir, "RelativeVisibilityPerTypescriptModule.csv")
    per_module_data = load_csv(per_module_csv, verbose)
    if not per_module_data.empty:
        # Detect the element count column (first numeric column that isn't the visibility ratio)
        numeric_cols = per_module_data.select_dtypes(include="number").columns.tolist()
        y_column = "allElements" if "allElements" in numeric_cols else (numeric_cols[1] if len(numeric_cols) > 1 else numeric_cols[0] if numeric_cols else "")
        x_column = "relativeVisibility" if "relativeVisibility" in per_module_data.columns else (numeric_cols[0] if numeric_cols else "")
        if x_column and y_column:
            plot_visibility_per_unit_scatter(
                data_frame=per_module_data,
                title="Relative visibility of TypeScript modules",
                x_column=x_column,
                y_column=y_column,
                x_label="relative visibility",
                y_label="number of elements",
                file_path=chart_file_path("Typescript_Module_RelativeVisibility", module_dir, verbose),
            )


def main() -> None:
    """Generates all visibility metric charts for Java and TypeScript."""
    parameters = parse_parameters()

    if parameters.verbose:
        print(parameters)
        Parameters.log_dependency_versions()

    print(f"{SCRIPT_NAME}: Starting visibility metrics chart generation...")

    if not parameters.report_directory or not os.path.isdir(parameters.report_directory):
        print(f"{SCRIPT_NAME}: Report directory not found: {parameters.report_directory!r}", file=sys.stderr)
        sys.exit(1)

    generate_java_visibility_charts(parameters.report_directory, parameters.verbose)
    generate_typescript_visibility_charts(parameters.report_directory, parameters.verbose)

    print(f"{SCRIPT_NAME}: Successfully finished.")


if __name__ == "__main__":
    main()
