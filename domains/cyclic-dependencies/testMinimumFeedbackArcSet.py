"""Unit tests for minimumFeedbackArcSet.py.

Tests cover all individual helper functions and the main entry point.
No external dependencies required beyond the standard library.
"""

import os
import sys

sys.path.insert(0, os.path.dirname(__file__))

import minimumFeedbackArcSet as mfas


# ── Acyclicity helper ─────────────────────────────────────────────────────────


def is_acyclic(nodes: list[str], edges: list[tuple[str, str]]) -> bool:
    """Return True if the directed graph defined by edges contains no cycle.

    Uses DFS-based cycle detection (white-grey-black colouring).
    """
    adjacency: dict[str, list[str]] = {n: [] for n in nodes}
    for source, target in edges:
        if source != target:
            adjacency[source].append(target)

    state: dict[str, str] = {}  # unvisited / visiting / visited

    def has_cycle_from(node: str) -> bool:
        state[node] = "visiting"
        for neighbor in adjacency[node]:
            if state.get(neighbor) == "visiting":
                return True
            if state.get(neighbor) != "visited" and has_cycle_from(neighbor):
                return True
        state[node] = "visited"
        return False

    return not any(has_cycle_from(node) for node in nodes if node not in state)


def edges_without_feedback_arcs(
    all_edges: list[tuple[str, str, int]],
    feedback_arcs: list[tuple[str, str, int]],
) -> list[tuple[str, str]]:
    """Return edge pairs remaining after removing feedback arcs."""
    feedback_arc_pairs = {(source, target) for source, target, _ in feedback_arcs}
    return [
        (source, target)
        for source, target, _ in all_edges
        if (source, target) not in feedback_arc_pairs
    ]


# ── _has_path ─────────────────────────────────────────────────────────────────


def test_has_path_given_direct_edge_returns_true() -> None:
    dag: dict[str, set[str]] = {"A": {"B"}, "B": set()}
    assert mfas._has_path(dag, start="A", end="B")


def test_has_path_given_no_path_returns_false() -> None:
    dag: dict[str, set[str]] = {"A": {"B"}, "C": set()}
    assert not mfas._has_path(dag, start="A", end="C")


def test_has_path_given_same_node_returns_true() -> None:
    dag: dict[str, set[str]] = {"A": set()}
    assert mfas._has_path(dag, start="A", end="A")


def test_has_path_given_transitive_path_returns_true() -> None:
    dag: dict[str, set[str]] = {"A": {"B"}, "B": {"C"}, "C": set()}
    assert mfas._has_path(dag, start="A", end="C")


# ── find_feedback_arc_set: simple cases ──────────────────────────────────────


def test_given_empty_edges_returns_empty() -> None:
    result = mfas.find_feedback_arc_set([])
    assert result == []


def test_given_linear_dag_returns_no_feedback_arcs() -> None:
    """Given A→B→C (no cycles), no edges need removal."""
    edges = [("A", "B", 1), ("B", "C", 1)]
    result = mfas.find_feedback_arc_set(edges)
    assert result == []


def test_given_self_loop_returns_it_in_result() -> None:
    """Self-loops are always in the feedback arc set."""
    edges = [("A", "A", 5), ("A", "B", 1), ("B", "C", 1)]
    result = mfas.find_feedback_arc_set(edges)
    self_loop_pairs = {(src, tgt) for src, tgt, _ in result}
    assert ("A", "A") in self_loop_pairs


def test_given_two_node_cycle_result_is_one_edge() -> None:
    """A↔B mutual dependency: exactly one edge must be removed."""
    edges = [("A", "B", 10), ("B", "A", 5)]
    result = mfas.find_feedback_arc_set(edges)
    assert len(result) == 1


def test_given_two_node_cycle_remaining_graph_is_acyclic() -> None:
    """After removing the feedback arc, A↔B becomes a DAG."""
    edges = [("A", "B", 10), ("B", "A", 5)]
    result = mfas.find_feedback_arc_set(edges)
    remaining = edges_without_feedback_arcs(edges, result)
    assert is_acyclic(["A", "B"], remaining)


def test_given_weighted_cycle_lighter_edge_preferred_for_removal() -> None:
    """In a 2-node cycle, the edge with lower weight should be in the feedback arc set."""
    edges = [("A", "B", 100), ("B", "A", 1)]
    result = mfas.find_feedback_arc_set(edges)
    result_pairs = {(src, tgt) for src, tgt, _ in result}
    # The heavy edge A→B should stay; the light edge B→A should be removed
    assert ("B", "A") in result_pairs
    assert ("A", "B") not in result_pairs


def test_given_three_node_cycle_result_is_acyclic() -> None:
    """A→B→C→A: removing one edge must yield a DAG."""
    edges = [("A", "B", 3), ("B", "C", 3), ("C", "A", 3)]
    result = mfas.find_feedback_arc_set(edges)
    assert len(result) >= 1
    remaining = edges_without_feedback_arcs(edges, result)
    assert is_acyclic(["A", "B", "C"], remaining)


def test_given_complex_graph_result_is_always_acyclic() -> None:
    """Complex graph with multiple overlapping cycles: result leaves an acyclic graph."""
    edges = [
        ("A", "B", 10),
        ("B", "C", 8),
        ("C", "A", 6),
        ("B", "D", 4),
        ("D", "A", 2),
        ("C", "D", 1),
    ]
    nodes = ["A", "B", "C", "D"]
    result = mfas.find_feedback_arc_set(edges)
    remaining = edges_without_feedback_arcs(edges, result)
    assert is_acyclic(nodes, remaining)


def test_given_multiple_self_loops_all_returned() -> None:
    """Multiple self-loops are all in the feedback arc set."""
    edges = [("A", "A", 1), ("B", "B", 2), ("A", "B", 5)]
    result = mfas.find_feedback_arc_set(edges)
    result_pairs = {(src, tgt) for src, tgt, _ in result}
    assert ("A", "A") in result_pairs
    assert ("B", "B") in result_pairs
