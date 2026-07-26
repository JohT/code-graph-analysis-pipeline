// Import internal SCIP type nodes from 'scip_type_nodes.csv' and link each to its SemanticCodeIndexProject via BELONGS_TO. Requires "Create_SCIP_Internal_Type_Constraint.cypher" and "Import_SCIP_Project_Nodes.cypher".

LOAD CSV WITH HEADERS FROM 'file:///scip_type_nodes.csv' AS row
WITH row WHERE row.file <> ''
MERGE (node:SCIP:SemanticCodeIndexInternalType {symbol: row.symbol})
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
    node.file           = row.file,
    node.packageId      = row.package_id,
    node.packageManager = row.package_manager,
    node.version        = row.version,
    node.module         = row.module,
    node.isAbstract     = (row.is_abstract = 'true'),
    node.isTest         = (
                            row.file CONTAINS '/test/'    OR
                            row.file CONTAINS '/tests/'   OR
                            row.file CONTAINS '/spec/'    OR
                            row.file CONTAINS '__tests__' OR
                            row.file ENDS WITH '_test.go' OR
                            row.file CONTAINS '.test.'    OR
                            row.file CONTAINS '.spec.'    OR
                            row.file CONTAINS '\\test\\'  OR
                            row.file CONTAINS '\\tests\\' OR
                            row.file CONTAINS '\\spec\\'
                          )
WITH node, row.project_root AS projectRoot
MATCH (p:SCIP:SemanticCodeIndexProject {fqn: projectRoot})
MERGE (node)-[:BELONGS_TO]->(p)
RETURN count(*) AS writtenRelationships
