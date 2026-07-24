// Import SCIP project metadata nodes from 'scip_projects.csv'. Creates SemanticCodeIndexProject nodes representing the root of each SCIP index. Requires "Create_SCIP_Project_Constraint.cypher".

LOAD CSV WITH HEADERS FROM 'file:///scip_projects.csv' AS row
WITH row WHERE row.project_root <> ''
MERGE (node:SCIP:SemanticCodeIndexProject {fqn: row.project_root})
SET node.projectRoot     = row.project_root,
    node.toolName        = row.tool_name,
    node.toolVersion     = row.tool_version
RETURN count(node) AS writtenNodes
