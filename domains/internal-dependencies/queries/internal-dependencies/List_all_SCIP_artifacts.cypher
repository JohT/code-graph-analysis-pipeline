// List all existing SCIP Semantic Index artifacts with dependency counts and external flag.

MATCH (a:SemanticCodeIndexArtifact)
RETURN a.projectName        AS projectName
      ,a.name               AS artifactName
      ,a.version            AS version
      ,a.incomingDependencies AS incomingDependencies
      ,a.outgoingDependencies AS outgoingDependencies
      ,a.isExternal          AS isExternal
ORDER BY incomingDependencies DESC, outgoingDependencies DESC, artifactName
