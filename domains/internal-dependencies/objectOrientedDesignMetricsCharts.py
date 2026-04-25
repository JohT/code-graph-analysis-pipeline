#!/usr/bin/env python

# Generates Object Oriented Design metrics charts as SVG files from CSV data produced by internalDependenciesCsv.sh.
# Charts are saved to the report directory subdirectories and referenced by the Markdown summary report.
#
# Input Parameters:
#  --report_directory   path to the report directory (contains Java_Package/, Typescript_Module/, etc.)
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
from matplotlib.colors import LinearSegmentedColormap

SCRIPT_NAME = "objectOrientedDesignMetricsCharts"

# Colormap for main sequence scatter: green (near main sequence) → red (far away)
MAIN_SEQUENCE_COLORMAP = LinearSegmentedColormap.from_list(
    "main_sequence", ["green", "gold", "orangered", "red"], N=256
)

# Abstraction levels: (subdirectory, description, main_sequence_csv_name, incoming_csv_name, outgoing_csv_name)
ABSTRACTION_LEVELS = [
    (
        "Java_Package",
        "Java Packages (without sub-packages)",
        "MainSequenceAbstractnessInstabilityDistanceJava.csv",
        "IncomingPackageDependenciesJava.csv",
        "OutgoingPackageDependenciesJava.csv",
    ),
    (
        "Java_Package",
        "Java Packages (including sub-packages)",
        "MainSequenceAbstractnessInstabilityDistanceIncludingSubpackagesJava.csv",
        "IncomingPackageDependenciesIncludingSubpackagesJava.csv",
        "OutgoingPackageDependenciesIncludingSubpackagesJava.csv",
    ),
    (
        "Typescript_Module",
        "TypeScript Modules",
        "MainSequenceAbstractnessInstabilityDistanceTypescript.csv",
        "IncomingPackageDependenciesTypescript.csv",
        "OutgoingPackageDependenciesTypescript.csv",
    ),
]

# Chart SVG file name prefixes per abstraction level description
CHART_PREFIX = {
    "Java Packages (without sub-packages)": "Java_Package_MainSequence",
    "Java Packages (including sub-packages)": "Java_Package_IncludingSubpackages_MainSequence",
    "TypeScript Modules": "Typescript_Module_MainSequence",
}

INCOMING_CHART_PREFIX = {
    "Java Packages (without sub-packages)": "Java_Package_IncomingDependencies_Bar",
    "Java Packages (including sub-packages)": "Java_Package_IncludingSubpackages_IncomingDependencies_Bar",
    "TypeScript Modules": "Typescript_Module_IncomingDependencies_Bar",
}

OUTGOING_CHART_PREFIX = {
    "Java Packages (without sub-packages)": "Java_Package_OutgoingDependencies_Bar",
    "Java Packages (including sub-packages)": "Java_Package_IncludingSubpackages_OutgoingDependencies_Bar",
    "TypeScript Modules": "Typescript_Module_OutgoingDependencies_Bar",
}

TOP_DEPENDENCIES_COUNT = 30


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
        description="Generates Object Oriented Design metrics charts as SVG files from CSV data."
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


# ── Annotation helpers ────────────────────────────────────────────────────────


def _index_of_sorted(data_frame: pd.DataFrame, highest: list[str] | None = None) -> pd.Index:
    """Returns the index of the first row after sorting by abstractness, instability, elementsCount, and name.

    Args:
        data_frame: DataFrame containing at least abstractness, instability, elementsCount columns.
        highest: Column names to sort descending; all others sort ascending.

    Returns:
        pandas Index of the selected row.
    """
    if highest is None:
        highest = []
    by = ["abstractness", "instability", "elementsCount"]
    ascending = [
        "abstractness" not in highest,
        "instability" not in highest,
        False,
    ]
    if "artifactName" in data_frame.columns:
        by.append("artifactName")
        ascending.append(True)
    return data_frame.sort_values(by=by, ascending=ascending).head(1).index


def _index_of_highest_property(data_frame: pd.DataFrame, highest: str) -> pd.Index:
    """Returns the index of the row with the highest value in the given column.

    Args:
        data_frame: Source DataFrame.
        highest: Column name to sort descending.

    Returns:
        pandas Index of the selected row.
    """
    by = [highest, "artifactName"] if "artifactName" in data_frame.columns else [highest]
    ascending = [False, True] if "artifactName" in data_frame.columns else [False]
    return data_frame.sort_values(by=by, ascending=ascending).head(1).index


def _annotate_axis_point(axis: "plot.Axes", data_frame: pd.DataFrame, index: pd.Index, verbose: bool = False) -> None:  # type: ignore[name-defined]
    """Annotates a single scatter point on the axis, using artifact and package/module name as label.

    Skips silently when the index is empty or required columns are absent.

    Args:
        axis: Matplotlib axes to annotate.
        data_frame: Source DataFrame; must contain abstractness and instability columns.
        index: Row index of the point to annotate.
        verbose: When True, logs any exception instead of silently discarding it.
    """
    if index.empty:
        return
    try:
        x_position = data_frame.loc[index, "abstractness"].item()
        y_position = data_frame.loc[index, "instability"].item()
        artifact_name = data_frame.loc[index, "artifactName"].item() if "artifactName" in data_frame.columns else ""
        name = data_frame.loc[index, "name"].item() if "name" in data_frame.columns else ""
        label = "\n".join(part for part in [artifact_name, name] if part)
        if not label:
            return
        label_box = dict(boxstyle="round4,pad=0.5", fc="w", alpha=0.8)
        axis.annotate(
            label,
            xy=(x_position, y_position),
            xycoords="data",
            xytext=(20, 0),
            textcoords="offset points",
            size=6,
            bbox=label_box,
            arrowprops=dict(arrowstyle="-|>", mutation_scale=10, color="black"),
        )
    except (KeyError, ValueError, TypeError) as error:
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping annotation for index {list(index)}: {error}")


# ── Chart rendering functions ──────────────────────────────────────────────────


def plot_main_sequence_scatter(
    data_frame: pd.DataFrame,
    title: str,
    file_path: str,
    verbose: bool = False,
) -> None:
    """
    Renders the Main Sequence scatter chart.

    X-axis = Abstractness (0 = fully concrete, 1 = fully abstract).
    Y-axis = Instability (0 = fully stable, 1 = fully unstable).
    Point size = number of contained types (elementsCount).
    Point color = distance from main sequence (green = near, red = far).
    Green dashed diagonal = the ideal Main Sequence line (A + I = 1).
    Skips silently when the input is empty.
    """
    if data_frame.empty:
        print(f"{SCRIPT_NAME}: No data for '{title}', skipping chart.")
        return

    required_columns = {"abstractness", "instability", "elementsCount", "distance"}
    missing = required_columns - set(data_frame.columns)
    if missing:
        print(f"{SCRIPT_NAME}: Missing columns {missing} in data for '{title}', skipping chart.")
        return

    marker_scales = data_frame["elementsCount"].clip(lower=2, upper=300) * 0.7

    figure, axis = plot.subplots(figsize=(10, 8))
    scatter = axis.scatter(
        data_frame["abstractness"],
        data_frame["instability"],
        s=marker_scales,
        c=data_frame["distance"],
        cmap=MAIN_SEQUENCE_COLORMAP,
        alpha=0.5,
    )

    # Green dashed Main Sequence reference line: A + I = 1
    axis.plot([0, 1], [1, 0], color="lightgreen", linestyle="dashed", label="Main Sequence")

    # Annotate key data points — mirrors the original ObjectOrientedDesignMetricsJava.ipynb
    _annotate_axis_point(axis, data_frame, _index_of_highest_property(data_frame, "elementsCount"), verbose)
    _annotate_axis_point(axis, data_frame, _index_of_sorted(data_frame, highest=["abstractness", "instability"]), verbose)
    _annotate_axis_point(axis, data_frame, _index_of_sorted(data_frame, highest=["instability"]), verbose)
    _annotate_axis_point(axis, data_frame, _index_of_sorted(data_frame, highest=[]), verbose)
    _annotate_axis_point(axis, data_frame, _index_of_sorted(data_frame, highest=["abstractness"]), verbose)
    near_main_sequence = data_frame.query("abstractness <= 0.4 & instability <= 0.4")
    if not near_main_sequence.empty:
        _annotate_axis_point(axis, data_frame, _index_of_sorted(near_main_sequence, highest=["abstractness", "instability"]), verbose)

    figure.colorbar(scatter, ax=axis, label="Distance from Main Sequence")
    axis.set_title(title)
    axis.set_xlabel("Abstractness")
    axis.set_ylabel("Instability")
    axis.set_xlim(-0.05, 1.05)
    axis.set_ylim(-0.05, 1.05)
    axis.legend(loc="upper right")

    plot.tight_layout()
    plot.savefig(file_path, bbox_inches="tight")
    plot.close(figure)


def plot_top_dependencies_bar(
    data_frame: pd.DataFrame,
    title: str,
    file_path: str,
    count_column: str,
) -> None:
    """
    Renders a horizontal bar chart of the top packages/modules by dependency count.

    Skips silently when the input is empty or the count column is missing.
    """
    if data_frame.empty:
        print(f"{SCRIPT_NAME}: No data for '{title}', skipping chart.")
        return

    if count_column not in data_frame.columns:
        if len(data_frame.columns) > 0:
            # Fall back to the last numeric column if available
            numeric_cols = data_frame.select_dtypes(include="number").columns.tolist()
            if not numeric_cols:
                print(f"{SCRIPT_NAME}: No numeric column found for '{title}', skipping chart.")
                return
            count_column = numeric_cols[-1]
        else:
            print(f"{SCRIPT_NAME}: Empty DataFrame for '{title}', skipping chart.")
            return

    # Use the first non-numeric column as label, fallback to index
    label_cols = data_frame.select_dtypes(exclude="number").columns.tolist()
    label_column = label_cols[0] if label_cols else None

    top = data_frame.nlargest(TOP_DEPENDENCIES_COUNT, count_column)

    figure, axis = plot.subplots(figsize=(10, max(6, len(top) * 0.3)))
    labels = top[label_column].astype(str) if label_column else top.index.astype(str)
    axis.barh(labels, top[count_column])
    axis.invert_yaxis()
    axis.set_title(title)
    axis.set_xlabel(count_column)
    axis.set_ylabel("Package / Module")

    plot.tight_layout()
    plot.savefig(file_path, bbox_inches="tight")
    plot.close(figure)


# ── Per-level chart generation ──────────────────────────────────────────────────


def generate_main_sequence_charts(
    level_directory: str,
    description: str,
    main_sequence_csv: str,
    verbose: bool,
) -> None:
    """Generates the main sequence scatter chart for one abstraction level."""
    data_frame = load_csv(main_sequence_csv, verbose)
    if data_frame.empty:
        return

    chart_prefix = CHART_PREFIX.get(description, description.replace(" ", "_"))
    plot_main_sequence_scatter(
        data_frame=data_frame,
        title=f'Abstractness vs. Instability ("Main Sequence")\n{description}',
        file_path=chart_file_path(chart_prefix, level_directory, verbose),
        verbose=verbose,
    )


def generate_incoming_dependencies_chart(
    level_directory: str,
    description: str,
    incoming_csv: str,
    verbose: bool,
) -> None:
    """Generates the top incoming dependencies bar chart for one abstraction level."""
    data_frame = load_csv(incoming_csv, verbose)
    if data_frame.empty:
        return

    # Detect the incoming dependency count column (first numeric column)
    numeric_cols = data_frame.select_dtypes(include="number").columns.tolist()
    count_column = numeric_cols[0] if numeric_cols else ""

    chart_prefix = INCOMING_CHART_PREFIX.get(description, f"{description.replace(' ', '_')}_Incoming")
    plot_top_dependencies_bar(
        data_frame=data_frame,
        title=f"Top {TOP_DEPENDENCIES_COUNT} by Incoming Dependencies\n{description}",
        file_path=chart_file_path(chart_prefix, level_directory, verbose),
        count_column=count_column,
    )


def generate_outgoing_dependencies_chart(
    level_directory: str,
    description: str,
    outgoing_csv: str,
    verbose: bool,
) -> None:
    """Generates the top outgoing dependencies bar chart for one abstraction level."""
    data_frame = load_csv(outgoing_csv, verbose)
    if data_frame.empty:
        return

    numeric_cols = data_frame.select_dtypes(include="number").columns.tolist()
    count_column = numeric_cols[0] if numeric_cols else ""

    chart_prefix = OUTGOING_CHART_PREFIX.get(description, f"{description.replace(' ', '_')}_Outgoing")
    plot_top_dependencies_bar(
        data_frame=data_frame,
        title=f"Top {TOP_DEPENDENCIES_COUNT} by Outgoing Dependencies\n{description}",
        file_path=chart_file_path(chart_prefix, level_directory, verbose),
        count_column=count_column,
    )


def generate_charts_for_level(
    report_directory: str,
    subdirectory: str,
    description: str,
    main_sequence_csv_name: str,
    incoming_csv_name: str,
    outgoing_csv_name: str,
    verbose: bool,
) -> None:
    """Generates all Object Oriented Design metric charts for a single abstraction level."""
    level_directory = os.path.join(report_directory, subdirectory)
    if not os.path.isdir(level_directory):
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping '{description}' — directory not found: {level_directory}")
        return

    main_sequence_csv = os.path.join(level_directory, main_sequence_csv_name)
    incoming_csv = os.path.join(level_directory, incoming_csv_name)
    outgoing_csv = os.path.join(level_directory, outgoing_csv_name)

    generate_main_sequence_charts(level_directory, description, main_sequence_csv, verbose)
    generate_incoming_dependencies_chart(level_directory, description, incoming_csv, verbose)
    generate_outgoing_dependencies_chart(level_directory, description, outgoing_csv, verbose)


def main() -> None:
    """Generates all Object Oriented Design metrics charts for all abstraction levels."""
    parameters = parse_parameters()

    if parameters.verbose:
        print(parameters)
        Parameters.log_dependency_versions()

    print(f"{SCRIPT_NAME}: Starting Object Oriented Design metrics chart generation...")

    for subdirectory, description, main_sequence_csv_name, incoming_csv_name, outgoing_csv_name in ABSTRACTION_LEVELS:
        print(f"{SCRIPT_NAME}: Processing {description}...")
        generate_charts_for_level(
            report_directory=parameters.report_directory,
            subdirectory=subdirectory,
            description=description,
            main_sequence_csv_name=main_sequence_csv_name,
            incoming_csv_name=incoming_csv_name,
            outgoing_csv_name=outgoing_csv_name,
            verbose=parameters.verbose,
        )

    print(f"{SCRIPT_NAME}: Successfully finished.")


if __name__ == "__main__":
    main()
