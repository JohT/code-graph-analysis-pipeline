// Number of internal SCIP types per module grouped by language.

MATCH (m:SemanticCodeIndexModule)-[:CONTAINS]->(t:SemanticCodeIndexInternalType)
 WITH m.name                              AS moduleName
     ,t.language                          AS language
     ,count(DISTINCT t)                   AS numberOfTypes
RETURN moduleName
      ,language
      ,numberOfTypes
 ORDER BY numberOfTypes DESC
