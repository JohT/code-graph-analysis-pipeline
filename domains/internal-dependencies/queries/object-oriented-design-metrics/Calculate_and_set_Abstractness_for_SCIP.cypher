// Calculate and set Abstractness for SCIP Semantic Index modules. Requires "Count_and_set_abstract_types_for_SCIP.cypher".

MATCH (m:SemanticCodeIndexModule)
WHERE m.numberOfTypes IS NOT NULL
 WITH m
     ,toFloat(m.numberOfAbstractTypes) / (m.numberOfTypes + 1E-38) AS abstractness
  SET m.abstractness = abstractness
RETURN m.projectName        AS projectName
      ,m.fqn                AS fullQualifiedModuleName
      ,m.name               AS moduleName
      ,abstractness
      ,m.numberOfAbstractTypes AS numberOfAbstractTypes
      ,m.numberOfTypes         AS numberOfTypes
ORDER BY abstractness ASC, numberOfTypes DESC
