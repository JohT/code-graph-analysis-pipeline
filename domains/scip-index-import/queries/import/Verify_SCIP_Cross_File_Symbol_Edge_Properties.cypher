// Verify that every DEPENDS_ON edge between SCIP symbols has the required properties
// that are created by the import queries (Import_SCIP_Cross_File_Symbol_Edges.cypher):
//   - referenceCount: Number of references (from CSV reference_count column)
//   - edgeType: Edge type classification (from CSV edge_type column)
//
// Returns: status, total_edges, edges_with_referenceCount, referenceCount_coverage_percent, 
//          edges_with_edgeType, edgeType_coverage_percent

MATCH (source:SCIP:SemanticCodeIndexInternalSymbol)-[edge:DEPENDS_ON]->(target:SCIP)
WITH COALESCE(count(edge), 0) AS total_edges
    ,COALESCE(count(CASE WHEN edge.referenceCount IS NOT NULL THEN 1 END), 0) AS edges_with_ref_count
    ,COALESCE(count(CASE WHEN edge.edgeType IS NOT NULL THEN 1 END), 0) AS edges_with_edge_type
RETURN
    CASE WHEN total_edges = 0 THEN 'No DEPENDS_ON edges found'
         WHEN edges_with_ref_count < total_edges THEN 'ERROR: referenceCount missing on some edges'
         WHEN edges_with_edge_type < total_edges THEN 'ERROR: edgeType missing on some edges'
         ELSE 'OK'
    END AS status
    ,total_edges
    ,edges_with_ref_count
    ,ROUND(toFloat(edges_with_ref_count) / CASE WHEN total_edges > 0 THEN total_edges ELSE 1 END * 100.0, 2) AS referenceCount_coverage_percent
    ,edges_with_edge_type
    ,ROUND(toFloat(edges_with_edge_type) / CASE WHEN total_edges > 0 THEN total_edges ELSE 1 END * 100.0, 2) AS edgeType_coverage_percent

