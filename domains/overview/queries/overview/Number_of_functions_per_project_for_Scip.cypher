// Number of internal SCIP functions per project grouped by language.

MATCH (f:SemanticCodeIndexFunction)
 WITH coalesce(f.projectName, 'unknown') AS projectName
     ,f.language                          AS language
     ,count(DISTINCT f)                   AS numberOfFunctions
RETURN projectName
      ,language
      ,numberOfFunctions
 ORDER BY numberOfFunctions DESC
