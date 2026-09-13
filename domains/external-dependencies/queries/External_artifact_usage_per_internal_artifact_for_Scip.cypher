// External SCIP artifact usage per internal artifact

MATCH (a:SemanticCodeIndexArtifact {isExternal: false})-[:CONTAINS]->(m:SemanticCodeIndexModule)-[:CONTAINS]->(i:SemanticCodeIndexInternalType)-[d:DEPENDS_ON]->(e:SemanticCodeIndexExternalType)
RETURN a.name                AS internalArtifactName
      ,e.module              AS externalArtifactName
      ,count(DISTINCT m)     AS numberOfModules
      ,count(DISTINCT i)     AS numberOfTypes
      ,sum(d.referenceCount) AS totalReferenceCount
 ORDER BY internalArtifactName, numberOfModules DESC
