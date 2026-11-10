// Import SCIP variable dependency edges from 'scip_variable_edges.csv'. Requires "Import_SCIP_Variable_Nodes.cypher", "Import_SCIP_Function_Nodes.cypher", "Import_SCIP_Type_Internal_Nodes.cypher", and "Import_SCIP_Type_External_Nodes.cypher".

LOAD CSV WITH HEADERS FROM 'file:///scip_variable_edges.csv' AS row
MATCH (source:SemanticCodeIndexVariable {symbol: row.source_symbol})
MATCH (target:SemanticCodeIndexVariable|SemanticCodeIndexFunction|SemanticCodeIndexInternalType|SemanticCodeIndexExternalType {symbol: row.target_symbol})
MERGE (source)-[relationship:DEPENDS_ON]->(target)
SET relationship.referenceCount = toInteger(row.reference_count),
    relationship.via            = row.edge_type
RETURN count(*) AS writtenRelationships
