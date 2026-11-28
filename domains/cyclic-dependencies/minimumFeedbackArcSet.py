#!/usr/bin/env python

# Minimum Feedback Arc Set algorithm for weighted directed graphs.
# Implements the Eades-Lin-Smyth (1993) greedy heuristic adapted with log-dampened
# weights and a re-insertion pass to rescue heavy arcs back into the resulting DAG.
#
# References:
#   Peter Eades, Xuemin Lin, W. F. Smyth (1993):
#   "A fast and effective heuristic for the feedback arc set problem",
#   Information Processing Letters, 47(6), 319-323.
#   https://doi.org/10.1016/0020-0190(93)90079-O
#
# All functions are pure (no I/O, no external state). Edge weights must be positive integers.

import heapq
import math
from collections import defaultdict
from typing import Mapping, Sequence

# (source_node_id, target_node_id, weight) where weight > 0
EdgeTriple = tuple[str, str, int]


def find_feedback_arc_set(edges: Sequence[EdgeTriple]) -> list[EdgeTriple]:
    """Return a minimal-weight feedback arc set for a weighted directed graph.

    Self-loops are always included. The main Eades algorithm operates on the
    remaining edges. Removing the returned arcs yields an acyclic graph.

    Args:
        edges: (source, target, weight) tuples with positive integer weights.

    Returns:
        (source, target, weight) triples — the feedback arcs to remove.
    """
    self_loops = [(source, target, weight) for source, target, weight in edges if source == target]
    clean_edges = [(source, target, weight) for source, target, weight in edges if source != target]

    if not clean_edges:
        return self_loops

    nodes, out_adj, in_adj, out_weights, in_weights = _build_dampened_graph(clean_edges)
    ordering = _compute_greedy_ordering(nodes, out_adj, in_adj, out_weights, in_weights)
    position = {node: index for index, node in enumerate(ordering)}
    dag_adj, candidates = _partition_edges(clean_edges, position)
    minimal_arcs = _minimize_feedback_arc_set(candidates, dag_adj)

    return self_loops + minimal_arcs


def _build_dampened_graph(
    edges: Sequence[EdgeTriple],
) -> tuple[
    set[str],
    defaultdict[str, dict[str, float]],
    defaultdict[str, dict[str, float]],
    defaultdict[str, float],
    defaultdict[str, float],
]:
    """Build a log-dampened adjacency structure to tame power-law hub skew.

    Uses log1p(weight) dampening so extreme-weight hub nodes do not dominate
    the greedy ordering step and distort the resulting arc set.

    Args:
        edges: Non-self-loop (source, target, weight) triples with positive weights.

    Returns:
        Five-tuple: (nodes, out_adj, in_adj, out_weights, in_weights).
        Adjacency maps: node → {neighbor: dampened_weight}.
        Weight maps: node → total dampened weight.
    """
    nodes: set[str] = set()
    out_adj: defaultdict[str, dict[str, float]] = defaultdict(dict)
    in_adj: defaultdict[str, dict[str, float]] = defaultdict(dict)
    out_weights: defaultdict[str, float] = defaultdict(float)
    in_weights: defaultdict[str, float] = defaultdict(float)

    for source, target, weight in edges:
        nodes.add(source)
        nodes.add(target)
        dampened = math.log1p(weight)
        out_adj[source][target] = dampened
        in_adj[target][source] = dampened
        out_weights[source] += dampened
        in_weights[target] += dampened

    return nodes, out_adj, in_adj, out_weights, in_weights


def _compute_greedy_ordering(
    nodes: set[str],
    out_adj: Mapping[str, Mapping[str, float]],
    in_adj: Mapping[str, Mapping[str, float]],
    out_weights: Mapping[str, float],
    in_weights: Mapping[str, float],
) -> list[str]:
    """Build a linear node ordering using the Eades greedy algorithm.

    Repeatedly:
    1. Peel source nodes (no incoming edges in remaining subgraph) → place left.
    2. Peel sink nodes (no outgoing edges in remaining subgraph) → place right.
    3. When neither exists: pick the node with maximum (out_weight − in_weight) → place left.
       Placing max-delta nodes left minimises backward edges in the final ordering.

    Uses a max-heap with lazy deletion for step 3. Operates on mutable internal
    copies of the graph structures to avoid mutating the caller's data.

    Args:
        nodes: All node identifiers in the graph.
        out_adj, in_adj: Adjacency dicts mapping node → {neighbor: dampened_weight}.
        out_weights, in_weights: Cumulative dampened weights per node.

    Returns:
        Linear ordering of all nodes. Backward edges in this ordering are arc candidates.
    """
    active: set[str] = set(nodes)

    # Mutable copies for the active subgraph (modified as nodes are removed)
    active_out: dict[str, dict[str, float]] = {n: dict(out_adj.get(n, {})) for n in nodes}
    active_in: dict[str, dict[str, float]] = {n: dict(in_adj.get(n, {})) for n in nodes}
    active_out_weight: dict[str, float] = {n: float(out_weights.get(n, 0.0)) for n in nodes}
    active_in_weight: dict[str, float] = {n: float(in_weights.get(n, 0.0)) for n in nodes}

    sources: set[str] = {n for n in active if not active_in[n]}
    sinks: set[str] = {n for n in active if not active_out[n] and n not in sources}

    # (-delta, node): min-heap used as max-heap by negating delta
    heap: list[tuple[float, str]] = []
    for node in active:
        if active_in[node] and active_out[node]:
            delta = active_out_weight[node] - active_in_weight[node]
            heapq.heappush(heap, (-delta, node))

    left_sequence: list[str] = []
    right_sequence: list[str] = []

    def remove_node(node: str, side: str) -> None:
        """Remove node from the active subgraph and update all neighbor weights."""
        active.discard(node)
        if side == "left":
            left_sequence.append(node)
        else:
            right_sequence.append(node)

        for target_node, dampened in list(active_out[node].items()):
            if target_node not in active:
                continue
            del active_in[target_node][node]
            active_in_weight[target_node] -= dampened
            if not active_in[target_node]:
                sinks.discard(target_node)
                sources.add(target_node)
            elif active_out[target_node]:
                new_delta = active_out_weight[target_node] - active_in_weight[target_node]
                heapq.heappush(heap, (-new_delta, target_node))

        for source_node, dampened in list(active_in[node].items()):
            if source_node not in active:
                continue
            del active_out[source_node][node]
            active_out_weight[source_node] -= dampened
            if not active_out[source_node]:
                if not active_in[source_node]:
                    sources.add(source_node)
                else:
                    sinks.add(source_node)
            elif active_in[source_node]:
                new_delta = active_out_weight[source_node] - active_in_weight[source_node]
                heapq.heappush(heap, (-new_delta, source_node))

        active_out[node].clear()
        active_in[node].clear()

    while active:
        while sinks:
            node = sinks.pop()
            if node in active:
                remove_node(node, "right")

        while sources:
            node = sources.pop()
            if node in active:
                remove_node(node, "left")

        if not active:
            break

        # No sources or sinks: greedily pick max-delta node from heap (lazy deletion of stale entries)
        placed = False
        while heap and not placed:
            neg_delta, node = heapq.heappop(heap)
            if node not in active or not active_in[node] or not active_out[node]:
                continue
            current_delta = active_out_weight[node] - active_in_weight[node]
            if abs(-neg_delta - current_delta) < 1e-12:
                remove_node(node, "left")
                placed = True

        if not placed and active:
            # Fallback: all heap entries were stale (can happen with floating-point precision);
            # pick any remaining active node with both edges, or any node
            fallback = next(
                (n for n in active if active_in[n] and active_out[n]),
                next(iter(active)),
            )
            remove_node(fallback, "left")

    return left_sequence + list(reversed(right_sequence))


def _partition_edges(
    edges: Sequence[EdgeTriple],
    position: Mapping[str, int],
) -> tuple[defaultdict[str, set[str]], list[EdgeTriple]]:
    """Partition edges into DAG (forward in ordering) and feedback arc candidates (backward).

    Forward: position[source] < position[target] → edge goes into the DAG.
    Backward: position[source] >= position[target] → edge is a feedback arc candidate.

    Args:
        edges: Non-self-loop edge triples.
        position: Maps each node to its index in the linear ordering.

    Returns:
        (dag_adj, candidates): adjacency set for forward edges; list of backward edge triples.
    """
    dag_adj: defaultdict[str, set[str]] = defaultdict(set)
    candidates: list[EdgeTriple] = []

    for source, target, weight in edges:
        if position[source] < position[target]:
            dag_adj[source].add(target)
        else:
            candidates.append((source, target, weight))

    return dag_adj, candidates


def _minimize_feedback_arc_set(
    candidates: list[EdgeTriple],
    dag_adj: defaultdict[str, set[str]],
) -> list[EdgeTriple]:
    """Re-insertion pass: rescue heavy backward arcs back into the DAG when safe.

    Processes candidates in descending raw weight order so the most important
    dependencies are rescued first. An arc (source → target) can be added back
    without introducing a cycle if and only if target cannot already reach source.

    Args:
        candidates: Backward edge triples from _partition_edges.
        dag_adj: Mutable DAG adjacency (modified in-place as arcs are rescued).

    Returns:
        Minimal feedback arc set: candidates that could not be rescued into the DAG.
    """
    sorted_candidates = sorted(candidates, key=lambda edge: edge[2], reverse=True)
    minimal_arcs: list[EdgeTriple] = []

    for source, target, weight in sorted_candidates:
        if _has_path(dag_adj, start=target, end=source):
            minimal_arcs.append((source, target, weight))
        else:
            dag_adj[source].add(target)

    return minimal_arcs


def _has_path(dag_adj: Mapping[str, set[str]], start: str, end: str) -> bool:
    """Return True if end is reachable from start via a depth-first search.

    Args:
        dag_adj: Adjacency mapping for the current DAG state.
        start: Starting node.
        end: Target node to find.

    Returns:
        True if end is reachable from start, False otherwise.
    """
    if start == end:
        return True
    visited: set[str] = {start}
    stack: list[str] = [start]
    while stack:
        current = stack.pop()
        for neighbor in dag_adj.get(current, set()):
            if neighbor == end:
                return True
            if neighbor not in visited:
                visited.add(neighbor)
                stack.append(neighbor)
    return False
