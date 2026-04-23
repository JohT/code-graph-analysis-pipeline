#!/usr/bin/env python

# Generates a code vocabulary word cloud as SVG from Neo4j graph data.
# Queries all code element names, splits them into words, and renders a word cloud.
# The chart is saved to the main report directory and referenced by the Markdown summary report.
#
# Input Parameters:
#  --report_directory   path to the main report directory (reports/internal-dependencies/)
#  --queries_directory  path to the directory containing the wordcloud .cypher file
#                       (default: queries/exploration/ next to this script)
#  --verbose            optional finer-grained logging
#
# Prerequisites:
#  - Neo4j must be running with scanned artifacts loaded.
#  - NEO4J_INITIAL_PASSWORD environment variable must be set.

import os
import sys
import argparse
from typing import LiteralString, cast

import pandas as pd

import matplotlib
matplotlib.use('Agg')  # Non-interactive backend — required for headless script execution
import matplotlib.pyplot as plot

from neo4j import GraphDatabase, Driver
from wordcloud import WordCloud, STOPWORDS

SCRIPT_NAME = "wordcloudChart"

WORDCLOUD_QUERY_FILE = "Words_for_universal_Wordcloud.cypher"
OUTPUT_FILE_NAME = "CodeNamesWordcloud.svg"

WORDCLOUD_WIDTH = 800
WORDCLOUD_HEIGHT = 800
WORDCLOUD_MAX_WORDS = 600
WORDCLOUD_COLORMAP = "viridis"

# Stop words: default set plus domain-specific noise from the original Wordcloud.ipynb notebook
CUSTOM_STOP_WORDS = STOPWORDS.union([
    "builder", "exception", "abstract", "helper", "util", "callback", "factory", "result",
    "handler", "type", "module", "name", "parameter", "lambda", "access", "create", "message",
    "ts", "js", "tsx", "jsx", "css", "htm", "html", "props", "use", "id", "ref", "hook", "event",
    "span", "data", "context", "form", "get", "set", "object", "null", "new", "plugin", "package",
    "types", "dom", "static", "view", "link", "build", "element", "impl", "function", "test",
    "dev", "event", "mock", "error", "input", "sdk", "api", "item", "end", "value", "param", "start",
])


class Parameters:
    def __init__(
        self,
        report_directory: str,
        queries_directory: str,
        verbose: bool,
    ) -> None:
        self.report_directory = report_directory
        self.queries_directory = queries_directory
        self.verbose = verbose

    def __repr__(self) -> str:
        return (
            f"Parameters("
            f"report_directory={self.report_directory!r}, "
            f"queries_directory={self.queries_directory!r}, "
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
        from neo4j import __version__ as neo4j_version
        print(f"neo4j version: {neo4j_version}")
        from wordcloud import __version__ as wordcloud_version
        print(f"wordcloud version: {wordcloud_version}")
        print("---------------------------------------")


def parse_parameters() -> Parameters:
    """Parses command-line arguments and returns a Parameters instance."""
    script_directory = os.path.dirname(os.path.abspath(__file__))
    default_queries_directory = os.path.join(script_directory, "queries", "exploration")

    parser = argparse.ArgumentParser(
        description="Generates a code vocabulary word cloud as SVG from Neo4j graph data."
    )
    parser.add_argument(
        "--report_directory",
        type=str,
        default="",
        help="Path to the main report directory where the SVG file will be written",
    )
    parser.add_argument(
        "--queries_directory",
        type=str,
        default=default_queries_directory,
        help="Path to the directory containing the wordcloud Cypher query file",
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
        queries_directory=args.queries_directory,
        verbose=args.verbose,
    )


def connect_to_graph_database() -> Driver:
    """Connects to the local Neo4j instance using the NEO4J_INITIAL_PASSWORD environment variable."""
    password = os.environ.get("NEO4J_INITIAL_PASSWORD")
    if not password:
        print(
            f"{SCRIPT_NAME}: Environment variable NEO4J_INITIAL_PASSWORD must be set and non-empty "
            "before connecting to Neo4j.",
            file=sys.stderr,
        )
        sys.exit(1)

    graph_driver = GraphDatabase.driver(
        uri="bolt://localhost:7687",
        auth=("neo4j", password),
    )
    graph_driver.verify_connectivity()
    print(f"{SCRIPT_NAME}: Successfully connected to Neo4j")
    return graph_driver


def load_query_results(cypher_file_path: str, verbose: bool, driver: Driver) -> pd.DataFrame:
    """Reads a .cypher file and executes it against the graph database, returning a DataFrame."""
    with open(cypher_file_path, "r", encoding="utf-8") as cypher_file:
        query = cypher_file.read()
    if verbose:
        print(f"{SCRIPT_NAME}: Querying {os.path.basename(cypher_file_path)}")
    records, summary, keys = driver.execute_query(cast(LiteralString, query))
    if verbose:
        print(f"{SCRIPT_NAME}: Got {len(records)} rows after {summary.result_available_after} ms")
    return pd.DataFrame([record.values() for record in records], columns=keys)


def save_wordcloud_svg(
    words_data: pd.DataFrame,
    report_directory: str,
    verbose: bool,
) -> None:
    """
    Generates and saves the code names word cloud as an SVG file.

    Joins the word column into a single text, applies custom stop words, and
    renders an 800x800 word cloud using the viridis colormap.
    Tries WordCloud.to_svg() for a pure-vector SVG; falls back to matplotlib
    savefig for older wordcloud library versions that lack to_svg().
    Skips silently when there are no words.
    """
    if words_data.empty:
        print(f"{SCRIPT_NAME}: No word data returned, skipping word cloud.")
        return

    word_column = words_data.columns[0]
    words = words_data[word_column].dropna().astype(str).tolist()
    number_of_words = len(words)
    print(f"{SCRIPT_NAME}: There are {number_of_words} words in the dataset.")

    if number_of_words <= 0:
        print(f"{SCRIPT_NAME}: No words to render, skipping word cloud.")
        return

    text = " ".join(words)

    wordcloud = WordCloud(
        width=WORDCLOUD_WIDTH,
        height=WORDCLOUD_HEIGHT,
        max_words=WORDCLOUD_MAX_WORDS,
        stopwords=CUSTOM_STOP_WORDS,
        collocations=False,
        background_color="white",
        colormap=WORDCLOUD_COLORMAP,
    ).generate(text)

    output_path = os.path.join(report_directory, OUTPUT_FILE_NAME)
    if verbose:
        print(f"{SCRIPT_NAME}: Saving {output_path}")

    # Prefer pure-vector SVG export (available since wordcloud >= 1.9.3)
    if hasattr(wordcloud, "to_svg"):
        svg_content = wordcloud.to_svg()
        with open(output_path, "w", encoding="utf-8") as svg_file:
            svg_file.write(svg_content)
    else:
        # Fallback: render to matplotlib figure and save as SVG (rasterized but valid)
        figure, axis = plot.subplots(figsize=(WORDCLOUD_WIDTH / 100, WORDCLOUD_HEIGHT / 100))
        axis.imshow(wordcloud, interpolation="bilinear")
        axis.axis("off")
        axis.set_title("Wordcloud of names in code")
        plot.tight_layout(pad=0)
        plot.savefig(output_path, format="svg", bbox_inches="tight")
        plot.close(figure)

    print(f"{SCRIPT_NAME}: Saved word cloud to {output_path}")


def main() -> None:
    """Generates the code vocabulary word cloud from Neo4j graph data."""
    parameters = parse_parameters()

    if parameters.verbose:
        print(parameters)
        Parameters.log_dependency_versions()

    print(f"{SCRIPT_NAME}: Starting code vocabulary word cloud generation...")

    if not parameters.report_directory or not os.path.isdir(parameters.report_directory):
        print(f"{SCRIPT_NAME}: Report directory not found: {parameters.report_directory!r}", file=sys.stderr)
        sys.exit(1)

    cypher_file_path = os.path.join(parameters.queries_directory, WORDCLOUD_QUERY_FILE)
    if not os.path.isfile(cypher_file_path):
        print(f"{SCRIPT_NAME}: Cypher query file not found: {cypher_file_path}", file=sys.stderr)
        sys.exit(1)

    driver = connect_to_graph_database()
    with driver:
        words_data = load_query_results(cypher_file_path, parameters.verbose, driver)

    save_wordcloud_svg(words_data, parameters.report_directory, parameters.verbose)

    print(f"{SCRIPT_NAME}: Successfully finished.")


if __name__ == "__main__":
    main()
