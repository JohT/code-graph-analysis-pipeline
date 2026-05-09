// Return the first node with a clusteringCoefficient if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.communityLocalClusteringCoefficient         IS NOT NULL
  RETURN codeUnit.name                                        AS shortCodeUnitName
        ,elementId(codeUnit)                                  AS nodeElementId
        ,codeUnit.communityLocalClusteringCoefficient         AS clusteringCoefficient
   LIMIT 1