// Number of internal SCIP functions per module grouped by language.

MATCH (m:SemanticCodeIndexModule)-[:CONTAINS]->(f:SemanticCodeIndexFunction)
 WITH m.name                              AS moduleName
     ,m.fqn                               AS moduleFullPath
     ,f.language                          AS language
     ,count(DISTINCT f)                   AS numberOfFunctions
RETURN moduleName
      ,moduleFullPath
      ,language
      ,numberOfFunctions
 ORDER BY numberOfFunctions DESC
