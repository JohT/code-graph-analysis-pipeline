"""Unit tests for externalScipDependencyCharts.py.

Tests cover pure data transformation functions and chart generation logic.
No Neo4j or SCIP data required: Neo4j calls are mocked throughout.
"""

import os
import sys
from typing import Any
from unittest.mock import MagicMock, patch, mock_open

import pandas as pd
import pytest

# Ensure the domain directory is on the path so the module can be imported.
sys.path.insert(0, os.path.dirname(__file__))

import externalScipDependencyCharts as charts


# ── Data transformation tests ─────────────────────────────────────────────────


def test_group_small_values_into_others_groups_below_threshold() -> None:
    data = pd.DataFrame({
        "name": ["a", "b", "c", "d"],
        "value": [60, 25, 10, 5],
    })
    result = charts.group_small_values_into_others(data, "value", "name", threshold_percent=15.0)
    assert "others" in result.index
    assert "a" in result.index
    assert "b" in result.index
    assert "c" not in result.index
    assert "d" not in result.index


def test_group_small_values_into_others_single_large_entry_no_others() -> None:
    data = pd.DataFrame({
        "name": ["a"],
        "value": [100],
    })
    result = charts.group_small_values_into_others(data, "value", "name", threshold_percent=5.0)
    assert "others" not in result.index
    assert "a" in result.index


def test_group_small_values_into_others_sorted_descending() -> None:
    data = pd.DataFrame({
        "name": ["a", "b", "c"],
        "value": [10, 50, 40],
    })
    result = charts.group_small_values_into_others(data, "value", "name", threshold_percent=5.0)
    percent_column = "valuePercent"
    assert result[percent_column].iloc[0] >= result[percent_column].iloc[1]


def test_filter_entries_below_percentage_threshold_returns_only_small_entries() -> None:
    data = pd.DataFrame({
        "name": ["a", "b", "c"],
        "value": [70, 20, 10],
    })
    result = charts.filter_entries_below_percentage_threshold(data, "value", threshold_percent=25.0)
    percent_column = "valuePercent"
    assert all(result[percent_column] < 25.0)
    assert len(result) == 2  # b (20%) and c (10%)


def test_filter_entries_below_percentage_threshold_empty_when_all_large() -> None:
    data = pd.DataFrame({
        "name": ["a"],
        "value": [100],
    })
    result = charts.filter_entries_below_percentage_threshold(data, "value", threshold_percent=50.0)
    assert result.empty


def test_select_top_internal_artifacts_by_module_count_returns_top() -> None:
    data = pd.DataFrame({
        "internalArtifactName": ["a", "a", "b", "b", "b", "c"],
        "externalArtifactName": ["x", "y", "x", "y", "z", "x"],
        "numberOfModules": [3, 2, 5, 4, 1, 1],
    })
    result = charts.select_top_internal_artifacts_by_module_count(data, top_count=2)
    assert "b" in result
    assert "a" in result
    assert "c" not in result


def test_select_top_internal_artifacts_by_module_count_fewer_than_top() -> None:
    data = pd.DataFrame({
        "internalArtifactName": ["a", "b"],
        "externalArtifactName": ["x", "x"],
        "numberOfModules": [3, 1],
    })
    result = charts.select_top_internal_artifacts_by_module_count(data, top_count=10)
    assert len(result) == 2


def test_build_external_artifact_per_internal_artifact_pivot_shape() -> None:
    data = pd.DataFrame({
        "internalArtifactName": ["a", "a", "b"],
        "externalArtifactName": ["x", "y", "x"],
        "numberOfModules": [3, 2, 5],
    })
    pivot = charts.build_external_artifact_per_internal_artifact_pivot(data, top_artifacts=["a", "b"])
    assert "a" in pivot.columns
    assert "b" in pivot.columns
    assert "x" in pivot.index
    assert "y" in pivot.index


def test_build_external_artifact_per_internal_artifact_pivot_fill_zero() -> None:
    data = pd.DataFrame({
        "internalArtifactName": ["a", "b"],
        "externalArtifactName": ["x", "y"],
        "numberOfModules": [3, 2],
    })
    pivot = charts.build_external_artifact_per_internal_artifact_pivot(data, top_artifacts=["a", "b"])
    # Artifact "a" has no dependency on "y", should be 0
    assert pivot.loc["y", "a"] == 0


def test_build_external_artifact_per_internal_artifact_pivot_filters_to_top() -> None:
    data = pd.DataFrame({
        "internalArtifactName": ["a", "b", "c"],
        "externalArtifactName": ["x", "x", "x"],
        "numberOfModules": [3, 2, 1],
    })
    pivot = charts.build_external_artifact_per_internal_artifact_pivot(data, top_artifacts=["a", "b"])
    assert "c" not in pivot.columns


# ── Chart rendering tests (mocked matplotlib) ─────────────────────────────────


def test_save_pie_chart_skips_empty_data(capsys: Any) -> None:
    empty = pd.DataFrame({"value": [], "valuePercent": []})
    charts.save_pie_chart(empty, "Test Chart", "/tmp/test.svg")
    captured = capsys.readouterr()
    assert "skipping chart" in captured.out


def test_save_pie_chart_saves_file_when_data_present() -> None:
    data = pd.DataFrame(
        {"value": [60, 40], "valuePercent": [60.0, 40.0]},
        index=["a", "b"],
    )
    with patch("matplotlib.pyplot.savefig") as mock_save, \
         patch("matplotlib.pyplot.subplots", return_value=(MagicMock(), MagicMock())), \
         patch("matplotlib.pyplot.close"), \
         patch("matplotlib.pyplot.title"), \
         patch("pandas.DataFrame.plot"):
        charts.save_pie_chart(data, "Test", "/tmp/test.svg")
        mock_save.assert_called_once_with("/tmp/test.svg", bbox_inches="tight")


def test_save_stacked_bar_chart_skips_empty_data(capsys: Any) -> None:
    empty = pd.DataFrame()
    charts.save_stacked_bar_chart(empty, "Test", "x", "y", "/tmp/test.svg")
    captured = capsys.readouterr()
    assert "skipping chart" in captured.out


def test_save_stacked_bar_chart_saves_file_when_data_present() -> None:
    data = pd.DataFrame({"a": [1, 2]}, index=["x", "y"])
    with patch("matplotlib.pyplot.savefig") as mock_save, \
         patch("matplotlib.pyplot.subplots", return_value=(MagicMock(), MagicMock())), \
         patch("matplotlib.pyplot.close"), \
         patch("matplotlib.pyplot.tight_layout"), \
         patch("pandas.DataFrame.plot"):
        charts.save_stacked_bar_chart(data, "Test", "x", "y", "/tmp/test.svg")
        mock_save.assert_called_once_with("/tmp/test.svg", bbox_inches="tight")


def test_save_scatter_chart_skips_empty_data(capsys: Any) -> None:
    empty = pd.DataFrame()
    charts.save_scatter_chart(
        empty, "x_col", "y_col", "size_col", "color_col",
        "Test", "x", "y", "/tmp/test.svg", []
    )
    captured = capsys.readouterr()
    assert "skipping chart" in captured.out


def test_save_scatter_chart_saves_file_when_data_present() -> None:
    data = pd.DataFrame({
        "numberOfExternalArtifacts": [5, 10],
        "maxNumberOfModulesPercentage": [20.0, 50.0],
        "artifactModules": [100, 200],
        "stdNumberOfModulesPercentage": [5.0, 10.0],
        "internalArtifactName": ["a", "b"],
    })
    with patch("matplotlib.pyplot.savefig") as mock_save, \
         patch("matplotlib.pyplot.subplots", return_value=(MagicMock(), MagicMock())), \
         patch("matplotlib.pyplot.close"), \
         patch("matplotlib.pyplot.annotate"), \
         patch("pandas.DataFrame.plot"):
        charts.save_scatter_chart(
            data,
            "numberOfExternalArtifacts",
            "maxNumberOfModulesPercentage",
            "artifactModules",
            "stdNumberOfModulesPercentage",
            "Test",
            "x",
            "y",
            "/tmp/test.svg",
            [],
        )
        mock_save.assert_called_once_with("/tmp/test.svg", bbox_inches="tight")


# ── load_query_results test ────────────────────────────────────────────────────


def test_load_query_results_returns_data_frame() -> None:
    mock_driver = MagicMock()
    mock_driver.execute_query.return_value = (
        [MagicMock(values=lambda: ["artifactA", 3])],
        MagicMock(result_available_after=10),
        ["externalArtifactName", "numberOfModules"],
    )
    with patch("builtins.open", mock_open(read_data="MATCH (n) RETURN n")):
        result = charts.load_query_results("/fake/path.cypher", False, mock_driver)
    assert isinstance(result, pd.DataFrame)
    assert list(result.columns) == ["externalArtifactName", "numberOfModules"]
    assert len(result) == 1


# ── Integration test for generate_scip_charts (all external calls mocked) ──────


def test_generate_scip_charts_calls_all_queries() -> None:
    mock_driver = MagicMock()
    empty_df = pd.DataFrame()

    with patch.object(charts, "load_query_results", return_value=empty_df) as mock_load, \
         patch.object(charts, "save_pie_chart_pair") as mock_pie, \
         patch.object(charts, "save_stacked_bar_chart") as mock_bar, \
         patch.object(charts, "save_scatter_chart") as mock_scatter:
        charts.generate_scip_charts("/queries", "/reports", False, mock_driver)
        assert mock_load.call_count == 8
        mock_pie.assert_not_called()   # no data → charts skipped
        mock_bar.assert_not_called()
        mock_scatter.assert_not_called()
