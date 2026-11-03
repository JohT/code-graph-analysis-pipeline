// Extend module-level DEPENDS_ON relationships using function-level dependencies. Requires "Link_SCIP_Module_CONTAINS_SCIP_Function.cypher" and "Import_SCIP_Function_Edges.cypher".

 MATCH (sourceModule:SCIP&SemanticCodeIndexModule)-[:CONTAINS]->(sourceFunction:SemanticCodeIndexFunction)
 MATCH (sourceFunction)-[functionDependency:DEPENDS_ON]->(dependentSymbol:SemanticCodeIndexInternalType|SemanticCodeIndexExternalType|SemanticCodeIndexFunction)
 MATCH (dependentSymbol)<-[:CONTAINS]-(dependentModule:SCIP&SemanticCodeIndexModule)
WHERE sourceModule     <> dependentModule
  AND sourceModule.fqn <> dependentModule.fqn
  WITH sourceModule
      ,dependentModule
      ,SUM(functionDependency.referenceCount) AS moduleDependencyReferenceCount
  CALL { WITH sourceModule, dependentModule, moduleDependencyReferenceCount
        MERGE (sourceModule)-[dependency:DEPENDS_ON]->(dependentModule)
          SET dependency.referenceCount = coalesce(dependency.referenceCount, 0) + moduleDependencyReferenceCount
       } IN TRANSACTIONS OF 1000 ROWS
RETURN sourceModule.fqn, dependentModule.fqn, moduleDependencyReferenceCount
