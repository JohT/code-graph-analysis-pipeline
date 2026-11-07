// Import SCIP function dependency edges from 'scip_function_edges.csv'. Requires "Import_SCIP_Function_Nodes.cypher", "Import_SCIP_Type_Internal_Nodes.cypher", and "Import_SCIP_Type_External_Nodes.cypher".

LOAD CSV WITH HEADERS FROM 'file:///scip_function_edges.csv' AS row
MATCH (source:SemanticCodeIndexFunction {symbol: row.source_symbol})
MATCH (target:SemanticCodeIndexFunction|SemanticCodeIndexInternalType|SemanticCodeIndexExternalType {symbol: row.target_symbol})
MERGE (source)-[relationship:DEPENDS_ON]->(target)
SET relationship.referenceCount = toInteger(row.reference_count),
    relationship.via            = row.edge_type
RETURN count(*) AS writtenRelationships
