// Add dynamically derived labels based on symbolType property to cross-file internal symbols (e.g., _SemanticCodeIndexFunction, _SemanticCodeIndexField). 
// Labels are volatile and intended for ad-hoc queries, node coloring, and dynamic aggregation only—not for stability-critical queries.
// The underscore prefix (_) indicates volatility and that the label may not be stable across SCIP versions or symbol type refinements.
// For stable queries, use aggregated labels like SemanticCodeIndexInternalExecutable instead.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType IS NOT NULL
WITH n, '_SemanticCodeIndex' + n.symbolType AS symbolTypeLabel
CALL apoc.create.addLabels(n, [symbolTypeLabel])
YIELD node
RETURN count(node) AS labelledNodes
