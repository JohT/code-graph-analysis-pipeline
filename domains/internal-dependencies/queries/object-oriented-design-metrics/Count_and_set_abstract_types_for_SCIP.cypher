// Count and set abstract type counts for SCIP Semantic Index modules. Requires "Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher".

MATCH (m:SemanticCodeIndexModule)
 WITH m
     ,count{(m)-[:CONTAINS]->(:SemanticCodeIndexInternalType)}                  AS numberOfTypes
     ,count{(m)-[:CONTAINS]->(:SemanticCodeIndexInternalType {isAbstract: true})} AS numberOfAbstractTypes
  SET m.numberOfTypes         = numberOfTypes
     ,m.numberOfAbstractTypes = numberOfAbstractTypes
RETURN m.fqn                AS moduleFqn
      ,m.name               AS moduleName
      ,numberOfTypes
      ,numberOfAbstractTypes
ORDER BY numberOfAbstractTypes DESC, numberOfTypes DESC
