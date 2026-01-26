// Reset all algorithm features related to anomaly detection for code units to force a recalculation

  MATCH (codeUnit)
  WHERE $projection_node_label IN labels(codeUnit)
 REMOVE codeUnit.communityLocalClusteringCoefficient
       ,codeUnit.centralityArticleRank
       ,codeUnit.centralityPageRank
       ,codeUnit.centralityBetweenness
       ,codeUnit.communityStronglyConnectedComponentId
       ,codeUnit.communityWeaklyConnectedComponentId