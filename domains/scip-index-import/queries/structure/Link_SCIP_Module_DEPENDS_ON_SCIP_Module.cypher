// Link SemanticCodeIndexModules nodes to the containSemanticCodeIndexModules modules they depend via DEPENDS_ON. Requires "Create_SCIP_Module_Nodes_For_Internal_Types.cypher", "Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher" and "Import_SCIP_Type_Internal_Nodes.cypher".

 MATCH (sourceModule:SCIP:SemanticCodeIndexModule)-[:CONTAINS]->(sourceType:SCIP:SemanticCodeIndexType)
 MATCH (sourceType)-[typeDependency:DEPENDS_ON]->(dependentType:SCIP:SemanticCodeIndexType)
 MATCH (dependentType)<-[:CONTAINS]-(dependentModule:SCIP:SemanticCodeIndexModule)
WHERE sourceModule     <> dependentModule
  AND sourceModule.fqn <> dependentModule.fqn
  WITH sourceModule
      ,dependentModule
      ,SUM(typeDependency.referenceCount) AS moduleDependencyReferenceCount
      ,REDUCE(interfaces=0, depType IN COLLECT(DISTINCT dependentType) | 
         CASE WHEN depType.isAbstract THEN interfaces + 1 ELSE interfaces END ) AS moduleDependencyAbstractReferenceCount
  CALL { WITH sourceModule, dependentModule
             ,moduleDependencyReferenceCount, moduleDependencyAbstractReferenceCount
        MERGE (sourceModule)-[dependency:DEPENDS_ON]->(dependentModule)
          SET dependency.referenceCount         = moduleDependencyReferenceCount
             ,dependency.abstractReferenceCount = moduleDependencyAbstractReferenceCount
       } IN TRANSACTIONS OF 1000 ROWS
RETURN sourceModule.fqn, dependentModule.fqn, moduleDependencyReferenceCount, moduleDependencyAbstractReferenceCount