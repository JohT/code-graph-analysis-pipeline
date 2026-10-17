"""Unit tests for scipTreemapAnomalyDetection.py.

Tests cover pure data transformation functions and chart generation logic.
No Neo4j connection required: Neo4j calls are mocked throughout.
"""

import os
import sys
from unittest.mock import MagicMock

import pandas as pd

sys.path.insert(0, os.path.dirname(__file__))

# Mock neo4j module (not needed for tests; all Neo4j calls are mocked)
if 'neo4j' not in sys.modules:
    sys.modules['neo4j'] = MagicMock()

import scipTreemapAnomalyDetection as charts


# ── Data transformation tests ─────────────────────────────────────────────────


def test_remove_last_path_file_extension_empty_list() -> None:
    assert charts.remove_last_path_file_extension([]) == ['']


def test_remove_last_path_file_extension_single_element() -> None:
    assert charts.remove_last_path_file_extension(['Foo.java']) == ['Foo']


def test_remove_last_path_file_extension_multi_element() -> None:
    result = charts.remove_last_path_file_extension(['com', 'example', 'Foo.java'])
    assert result == ['com', 'example', 'Foo']


def test_join_path_elements_builds_cumulative_paths() -> None:
    result = charts.join_path_elements(['com', 'example', 'Foo.java'])
    assert result == ['com', 'com/example', 'com/example/Foo']


def test_join_path_elements_single_file() -> None:
    result = charts.join_path_elements(['Main.java'])
    assert result == ['Main']


def test_add_element_path_column_adds_exploded_paths() -> None:
    data = pd.DataFrame({'filePath': ['com/example/Foo.java']})
    result = charts.add_element_path_column(data, 'filePath')
    assert 'elementPath' in result.columns
    paths = result['elementPath'].tolist()
    assert 'com' in paths
    assert 'com/example' in paths
    assert 'com/example/Foo' in paths


def test_add_element_path_column_skips_if_already_exists() -> None:
    data = pd.DataFrame({'filePath': ['a/b.java'], 'elementPath': ['existing']})
    result = charts.add_element_path_column(data, 'filePath')
    assert result['elementPath'].tolist() == ['existing']


def test_add_element_name_column_extracts_last_segment() -> None:
    data = pd.DataFrame({'elementPath': ['com/example/Foo', 'com/example']})
    result = charts.add_element_name_column(data)
    assert result['elementName'].tolist() == ['Foo', 'example']


def test_add_element_name_column_skips_if_already_exists() -> None:
    data = pd.DataFrame({'elementPath': ['com/Foo'], 'elementName': ['existing']})
    result = charts.add_element_name_column(data)
    assert result['elementName'].tolist() == ['existing']


def test_add_parent_directory_column_extracts_parent() -> None:
    data = pd.DataFrame({'elementPath': ['com/example/Foo', 'com/example', 'com']})
    result = charts.add_parent_directory_column(data)
    assert result['directoryParentPath'].iloc[0] == 'com/example'
    assert result['directoryParentPath'].iloc[1] == 'com'
    assert result['directoryParentPath'].iloc[2] == ''


def test_add_parent_directory_column_skips_if_already_exists() -> None:
    data = pd.DataFrame({'elementPath': ['com/Foo'], 'directoryParentPath': ['existing']})
    result = charts.add_parent_directory_column(data)
    assert result['directoryParentPath'].tolist() == ['existing']


def test_prepare_data_for_treemap_produces_expected_columns() -> None:
    data = pd.DataFrame({
        'filePath': ['com/example/Foo.java', 'com/example/Bar.java'],
        'absoluteAnomalyScore': [0.5, 0.3],
        'normalizedBridgeRank': [0.8, 0.0],
        'normalizedOutlierRank': [0.0, 0.6],
    })
    result = charts.prepare_data_for_treemap(data)
    assert 'elementPath' in result.columns
    assert 'directoryParentPath' in result.columns
    assert 'elementName' in result.columns
    assert 'fileCount' in result.columns
    assert 'absoluteAnomalyScore' in result.columns
    assert 'normalizedBridgeRank' in result.columns
    assert 'normalizedOutlierRank' in result.columns
