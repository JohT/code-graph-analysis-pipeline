// Number of internal SCIP types per module grouped by language.

MATCH (m:SemanticCodeIndexModule)-[:CONTAINS]->(t:SemanticCodeIndexInternalType)
 WITH m.name                              AS moduleName
     ,m.fqn                               AS moduleFullPath
     ,t.language                          AS language
     ,count(DISTINCT t)                   AS numberOfTypes
RETURN moduleName
      ,moduleFullPath
      ,language
      ,numberOfTypes
 ORDER BY numberOfTypes DESC
