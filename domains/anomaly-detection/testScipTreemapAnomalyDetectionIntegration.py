"""Integration tests for scipTreemapAnomalyDetection.

These tests verify chart generation and other integration concerns that require external
dependencies like plotly. They are separated from unit tests to keep the main test suite
lightweight for CI pipelines.

Automatically excluded from standard test runs (./scripts/runPythonTests.sh).

To run manually: pytest domains/anomaly-detection/testScipTreemapAnomalyDetectionIntegration.py
Requires: plotly, scikit-learn, optuna

TODO: Build a formal integration test pipeline that can be triggered on-demand for
      comprehensive testing with all optional dependencies (plotly, ML libraries, etc.)
      while keeping CI lean and fast.
"""

import os
import sys
from unittest.mock import MagicMock, patch

import pandas as pd
import pytest

sys.path.insert(0, os.path.dirname(__file__))

# Mock neo4j module (not needed for tests; all Neo4j calls are mocked)
if 'neo4j' not in sys.modules:
    sys.modules['neo4j'] = MagicMock()

import scipTreemapAnomalyDetection as charts


# ── Chart generation tests ────────────────────────────────────────────────────


def _build_minimal_treemap_data() -> pd.DataFrame:
    """Build the minimal DataFrame shape expected by generate_treemap_visualizations."""
    data = pd.DataFrame({
        'filePath': ['com/example/Foo.java', 'com/example/Bar.java'],
        'absoluteAnomalyScore': [0.5, 0.3],
        'normalizedBridgeRank': [0.8, 0.0],
        'normalizedOutlierRank': [0.0, 0.6],
    })
    return charts.prepare_data_for_treemap(data)


def test_generate_treemap_visualizations_calls_write_image_four_times() -> None:
    data = _build_minimal_treemap_data()
    parameters = charts.Parameters(
        input_parameters={"projection_language": "SCIP"},
        report_directory="/tmp/test_report",
    )

    with patch('plotly.graph_objects.Figure.write_image') as mock_write_image:
        charts.generate_treemap_visualizations(data, parameters)

    assert mock_write_image.call_count == 4


def test_generate_treemap_visualizations_uses_prefix_in_file_names() -> None:
    data = _build_minimal_treemap_data()
    parameters = charts.Parameters(
        input_parameters={"projection_language": "SCIP"},
        report_directory="/tmp/test_report",
    )

    file_paths: list[str] = []

    def capture_write_image(**kwargs: object) -> None:
        file_paths.append(str(kwargs.get("file", "")))

    with patch('plotly.graph_objects.Figure.write_image', side_effect=capture_write_image):
        charts.generate_treemap_visualizations(data, parameters)

    assert all("SCIP" in path for path in file_paths)
    assert any("Treemap1" in path for path in file_paths)
    assert any("Treemap2" in path for path in file_paths)
    assert any("Treemap3" in path for path in file_paths)
    assert any("Treemap4" in path for path in file_paths)


def test_generate_treemap_visualizations_skips_archetype_treemaps_with_empty_archetype_data() -> None:
    """Treemap3 (Bridge) and Treemap4 (Outlier) are skipped when their respective rank data is empty."""
    data = _build_minimal_treemap_data()
    # Clear archetype ranks so individual archetype treemaps have no data rows
    data['normalizedBridgeRank'] = 0.0
    data['normalizedOutlierRank'] = 0.0

    parameters = charts.Parameters(
        input_parameters={"projection_language": "SCIP"},
        report_directory="/tmp/test_report",
    )

    write_image_calls: list[str] = []

    def capture_write_image(**kwargs: object) -> None:
        write_image_calls.append(str(kwargs.get("file", "")))

    with patch('plotly.graph_objects.Figure.write_image', side_effect=capture_write_image):
        charts.generate_treemap_visualizations(data, parameters)

    # When archetype rank data is empty, only Treemap1 (score) and Treemap2 (overview) are written
    treemap1_files = [path for path in write_image_calls if "Treemap1" in path]
    treemap2_files = [path for path in write_image_calls if "Treemap2" in path]
    treemap3_files = [path for path in write_image_calls if "Treemap3" in path]
    treemap4_files = [path for path in write_image_calls if "Treemap4" in path]

    assert len(treemap1_files) == 1, f"Expected 1 Treemap1 file, got {len(treemap1_files)}"
    assert len(treemap2_files) == 1, f"Expected 1 Treemap2 file, got {len(treemap2_files)}"
    assert len(treemap3_files) == 0, f"Expected 0 Treemap3 files (should be skipped), got {len(treemap3_files)}: {treemap3_files}"
    assert len(treemap4_files) == 0, f"Expected 0 Treemap4 files (should be skipped), got {len(treemap4_files)}: {treemap4_files}"
