// Calculate and set abstractness for SCIP artifacts and return a 0.1 ranged bin distribution. Requires "Link_SCIP_Artifact_CONTAINS_SCIP_InternalType.cypher".

MATCH (a:SemanticCodeIndexArtifact)
 WITH a
     ,count{(a)-[:CONTAINS]->(:SemanticCodeIndexInternalType)}                    AS numberTypes
     ,count{(a)-[:CONTAINS]->(:SemanticCodeIndexInternalType {isAbstract: true})} AS numberAbstractTypes
 WITH *
     ,toFloat(numberAbstractTypes) / (numberTypes + 1E-38) AS abstractness
  SET a.abstractness = abstractness
RETURN round(abstractness, 1)  AS abstractnessBin
      ,count(*)                AS artifactCount
      ,collect(a.name)[0..4]   AS examples
ORDER BY abstractnessBin ASC
