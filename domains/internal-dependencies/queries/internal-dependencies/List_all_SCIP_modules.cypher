// List all existing internal SCIP Semantic Index modules with dependency counts and test flag.

MATCH (m:SemanticCodeIndexModule)
OPTIONAL MATCH (m)-[:CONTAINS]->(t:SemanticCodeIndexInternalType)
 WITH m
     ,count(DISTINCT t.fqn) AS numberOfTypes
RETURN m.projectName        AS projectName
      ,m.fqn                AS moduleFqn
      ,m.name               AS moduleName
      ,numberOfTypes
      ,m.incomingDependencies AS incomingDependencies
      ,m.outgoingDependencies AS outgoingDependencies
      ,m.isTest               AS isTest
ORDER BY incomingDependencies DESC, outgoingDependencies DESC, moduleName
