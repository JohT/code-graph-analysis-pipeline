// External SCIP artifact usage spread, excluding test modules.

MATCH (a:SemanticCodeIndexArtifact {isExternal: false})-[:CONTAINS]->(m:SemanticCodeIndexModule)-[:CONTAINS]->(i:SemanticCodeIndexInternalType)-[d:DEPENDS_ON]->(e:SemanticCodeIndexExternalType)
WHERE coalesce(m.isTest, false) = false
  WITH e.module              AS externalArtifactName
      ,a.name                AS internalArtifactName
      ,count(DISTINCT m)     AS numberOfModules
      ,count(DISTINCT i)     AS numberOfTypes
      ,sum(d.referenceCount) AS referenceCount
  WITH externalArtifactName
      ,count(DISTINCT internalArtifactName) AS numberOfInternalArtifacts
      ,sum(numberOfModules)                  AS sumNumberOfModules
      ,sum(numberOfTypes)                    AS sumNumberOfTypes
      ,sum(referenceCount)                   AS sumReferenceCount
RETURN externalArtifactName
      ,numberOfInternalArtifacts
      ,sumNumberOfModules
      ,sumNumberOfTypes
      ,sumReferenceCount
 ORDER BY numberOfInternalArtifacts DESC, sumNumberOfModules DESC
