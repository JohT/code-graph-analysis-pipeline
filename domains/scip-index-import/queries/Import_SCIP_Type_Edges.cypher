// Import SCIP type dependency edges from 'scip_type_edges.csv'. Requires "Import_SCIP_Type_Internal_Nodes.cypher" and "Import_SCIP_Type_External_Nodes.cypher".

LOAD CSV WITH HEADERS FROM 'file:///scip_type_edges.csv' AS row
MATCH (source:SCIPType {symbol: row.source_symbol})
MATCH (target:SCIPType {symbol: row.target_symbol})
MERGE (source)-[relationship:DEPENDS_ON]->(target)
SET relationship.referenceCount = toInteger(row.reference_count)
