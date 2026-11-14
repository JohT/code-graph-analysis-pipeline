// Import all cross-file internal symbols from 'scip_symbol_nodes.csv' and link each to its SemanticCodeIndexProject via BELONGS_TO.
// Sets :SCIP:SemanticCodeIndexInternalSymbol label on all rows.
// Requires "Create_SCIP_Cross_File_Internal_Symbol_Constraint.cypher" and "Import_SCIP_Project_Nodes.cypher".

LOAD CSV WITH HEADERS FROM 'file:///scip_symbol_nodes.csv' AS row
WITH row WHERE row.file <> ''
MERGE (node:SCIP:SemanticCodeIndexInternalSymbol {symbol: row.symbol})
SET node.fqn            = row.symbol,
    node.name           = row.display_name,
    node.scheme         = row.scheme,
    node.language       = row.language,
    node.kind           = toInteger(row.kind),
    node.symbolType     = row.symbol_type,
    node.typeName       = row.symbol_type,
    node.file           = row.file,
    node.packageId      = row.package_id,
    node.packageManager = row.package_manager,
    node.version        = row.version,
    node.module         = row.module,
    node.isAbstract     = (row.is_abstract = 'true'),
    node.isTest         = (row.is_test = 'true'),
    node.descriptor     = row.descriptor
WITH node, row.project_root AS projectRoot
MATCH (p:SCIP:SemanticCodeIndexProject {fqn: projectRoot})
MERGE (node)-[:BELONGS_TO]->(p)
RETURN count(*) AS writtenRelationships
