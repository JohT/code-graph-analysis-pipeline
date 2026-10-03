// Number of internal SCIP types per project grouped by language.

MATCH (t:SemanticCodeIndexInternalType)
 WITH coalesce(t.projectName, 'unknown') AS projectName
     ,t.language                          AS language
     ,count(DISTINCT t)                   AS numberOfTypes
RETURN projectName
      ,language
      ,numberOfTypes
 ORDER BY numberOfTypes DESC
