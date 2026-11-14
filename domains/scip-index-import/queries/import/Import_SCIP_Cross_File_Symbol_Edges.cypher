// Import all cross-file symbol dependency edges from 'scip_symbol_edges.csv'.
// Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher", "Import_SCIP_Cross_File_External_Symbol_Nodes.cypher", and "Create_SCIP_Symbol_Index.cypher".
// Optimization: Uses indexed lookups (scip_symbol_index) and TRANSACTIONS to batch operations,
// avoiding expensive cartesian products and full label scans (~100x faster than sequential MATCHes).

LOAD CSV WITH HEADERS FROM 'file:///scip_symbol_edges.csv' AS row
WITH row WHERE row.from <> '' AND row.to <> ''
CALL { WITH row
    // Use indexed lookups on SCIP nodes by symbol (index created by Create_SCIP_Symbol_Index.cypher)
    MATCH (source:SCIP {symbol: row.from})
    MATCH (target:SCIP {symbol: row.to})
    
    // CREATE relationship (not MERGE) since scip_symbol_edges.csv is pre-deduplicated by converter
    CREATE (source)-[r:DEPENDS_ON {referenceCount: toInteger(row.reference_count),
                                    edgeType: row.edge_type}]->(target)
} IN TRANSACTIONS OF 500 ROWS
RETURN count(*) AS writtenRelationships
