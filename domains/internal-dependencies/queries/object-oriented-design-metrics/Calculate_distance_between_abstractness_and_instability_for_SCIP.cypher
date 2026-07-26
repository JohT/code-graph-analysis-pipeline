// Calculate distance between abstractness and instability for SCIP Semantic Index modules.
// Requires "Calculate_and_set_Abstractness_for_SCIP.cypher" and "Calculate_and_set_Instability_for_SCIP.cypher".

MATCH (m:SemanticCodeIndexModule)
WHERE m.abstractness IS NOT NULL
  AND m.instability  IS NOT NULL
RETURN m.projectName                                    AS artifactName
      ,m.fqn                                           AS fullQualifiedName
      ,m.name                                          AS name
      ,abs(m.abstractness + m.instability - 1)         AS distance
      ,m.abstractness                                  AS abstractness
      ,m.instability                                   AS instability
      ,m.numberOfTypes                                 AS elementsCount
ORDER BY distance DESC, elementsCount DESC
