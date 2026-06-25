// Link SemanticCodeIndexArtifact nodes to other artifacts they depend on via DEPENDS_ON (for internal types only). Mirrors module-level aggregation at artifact level. Requires "Create_SCIP_Artifact_Nodes.cypher", "Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher", and "Link_SCIP_Module_DEPENDS_ON_SCIP_Module.cypher".

MATCH (sourceArtifact:SCIP:SemanticCodeIndexArtifact)-[:CONTAINS]->(sourceModule:SCIP:SemanticCodeIndexModule)
MATCH (sourceModule)-[moduleDependency:DEPENDS_ON]->(dependentModule:SCIP:SemanticCodeIndexModule)
MATCH (dependentModule)<-[:CONTAINS]-(dependentArtifact:SCIP:SemanticCodeIndexArtifact)
WHERE sourceArtifact <> dependentArtifact
  AND sourceArtifact.fqn <> dependentArtifact.fqn
  WITH sourceArtifact
      ,dependentArtifact
      ,SUM(moduleDependency.referenceCount) AS artifactDependencyReferenceCount
      ,SUM(moduleDependency.abstractReferenceCount) AS artifactDependencyAbstractReferenceCount
  CALL { WITH sourceArtifact, dependentArtifact
             ,artifactDependencyReferenceCount, artifactDependencyAbstractReferenceCount
        MERGE (sourceArtifact)-[dependency:DEPENDS_ON]->(dependentArtifact)
          SET dependency.referenceCount         = artifactDependencyReferenceCount
             ,dependency.abstractReferenceCount = artifactDependencyAbstractReferenceCount
       } IN TRANSACTIONS OF 1000 ROWS
RETURN count(*) AS writtenRelationships
