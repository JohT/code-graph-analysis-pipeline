// Get SCIP Semantic Index modules with the lowest Abstractness first (if already set).

MATCH (m:SemanticCodeIndexModule)
WHERE m.abstractness IS NOT NULL
RETURN m.projectName          AS projectName
      ,m.fqn                  AS fullQualifiedModuleName
      ,m.name                 AS moduleName
      ,m.abstractness         AS abstractness
      ,m.numberOfAbstractTypes AS numberOfAbstractTypes
      ,m.numberOfTypes         AS numberOfTypes
ORDER BY abstractness ASC, numberOfTypes DESC
