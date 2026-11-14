// Import all cross-file symbol dependency edges from 'scip_symbol_edges.csv'.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher" and "Import_SCIP_Cross_File_External_Symbol_Nodes.cypher".

LOAD CSV WITH HEADERS FROM 'file:///scip_symbol_edges.csv' AS row
WITH row WHERE row.from <> '' AND row.to <> ''
MATCH (source:SCIP {symbol: row.from})
MATCH (target:SCIP {symbol: row.to})
MERGE (source)-[r:DEPENDS_ON]->(target)
  ON CREATE SET r.referenceCount = toInteger(row.reference_count),
               r.edgeType       = row.edge_type
  ON MATCH  SET r.referenceCount = r.referenceCount + toInteger(row.reference_count)
RETURN count(*) AS writtenRelationships
