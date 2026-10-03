// Overview size for SCIP. Counts total graph nodes, relationships, SCIP artifacts, modules, internal types, external types, and total reference count.

 MATCH (n)
  WITH COUNT(n) AS nodeCount
 MATCH ()-[]->()
  WITH nodeCount
      ,count(*) AS relationshipCount
 MATCH (a:SemanticCodeIndexArtifact)
  WITH nodeCount
      ,relationshipCount
      ,count(DISTINCT a) AS artifactCount
 MATCH (m:SemanticCodeIndexModule)
  WITH nodeCount
      ,relationshipCount
      ,artifactCount
      ,count(DISTINCT m) AS moduleCount
 MATCH (t:SemanticCodeIndexInternalType)
  WITH nodeCount
      ,relationshipCount
      ,artifactCount
      ,moduleCount
      ,count(DISTINCT t) AS internalTypeCount
 OPTIONAL MATCH (e:SemanticCodeIndexExternalType)
  WITH nodeCount
      ,relationshipCount
      ,artifactCount
      ,moduleCount
      ,internalTypeCount
      ,count(DISTINCT e) AS externalTypeCount
 OPTIONAL MATCH (i:SemanticCodeIndexInternalType)-[d:DEPENDS_ON]->()
  WITH nodeCount
      ,relationshipCount
      ,artifactCount
      ,moduleCount
      ,internalTypeCount
      ,externalTypeCount
      ,sum(d.referenceCount) AS totalReferenceCount
RETURN nodeCount
      ,relationshipCount
      ,artifactCount
      ,moduleCount
      ,internalTypeCount
      ,externalTypeCount
      ,totalReferenceCount
