// Import all cross-file external symbols from 'scip_external_symbol_nodes.csv'.
// Sets :SCIP:SemanticCodeIndexExternalSymbol label on all rows.
// Requires "Create_SCIP_Cross_File_External_Symbol_Constraint.cypher".

LOAD CSV WITH HEADERS FROM 'file:///scip_external_symbol_nodes.csv' AS row
MERGE (node:SCIP:SemanticCodeIndexExternalSymbol {symbol: row.symbol})
SET node.fqn            = row.symbol,
    node.name           = row.name,
    node.scheme         = row.scheme,
    node.language       = row.language,
    node.kind           = toInteger(row.kind),
    node.symbolType     = row.symbolType,
    node.typeName       = row.symbolType,
    node.packageId      = row.packageId,
    node.packageManager = row.packageManager,
    node.version        = row.version,
    node.module         = row.module,
    node.descriptor     = row.descriptor
RETURN count(*) AS writtenNodes
