// Import external SCIP type nodes from 'scip_type_nodes.csv'. Requires "Create_SCIP_Type_Constraint.cypher".

LOAD CSV WITH HEADERS FROM 'file:///scip_type_nodes.csv' AS row
WITH row WHERE row.file = ''
MERGE (node:SCIP:SCIPType:SCIPExternalType {symbol: row.symbol})
SET node.fqn            = row.symbol,
    node.name           = row.display_name,
    node.scheme         = row.scheme,
    node.language       = CASE row.scheme
                            WHEN 'scip-go'         THEN 'Go'
                            WHEN 'semanticdb'      THEN 'Java'
                            WHEN 'scip-typescript' THEN 'TypeScript'
                            WHEN 'rust-analyzer'   THEN 'Rust'
                            WHEN 'cxx'             THEN 'C++'
                            WHEN 'scip-ruby'       THEN 'Ruby'
                            WHEN 'scip-python'     THEN 'Python'
                            WHEN 'scip-dotnet'     THEN 'C#'
                            ELSE toUpper(left(replace(row.scheme, 'scip-', ''), 1)) + substring(replace(row.scheme, 'scip-', ''), 1)
                          END,
    node.typeName       = row.type_name,
    node.file           = '',
    node.packageId      = row.package_id,
    node.packageManager = row.package_manager,
    node.version        = row.version,
    node.module         = row.module,
    node.isAbstract     = (row.is_abstract = 'true'),
    node.isTest         = false
