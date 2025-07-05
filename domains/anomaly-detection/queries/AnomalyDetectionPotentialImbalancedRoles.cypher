// Anomaly Detection Query: Find potential imbalanced roles in the codebase by listing the top 40 most significant Page Rank to Article Rank differences.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityPageRank    IS NOT NULL
     AND codeUnit.centralityArticleRank IS NOT NULL
    WITH collect(codeUnit) AS codeUnits
        ,avg  (codeUnit.centralityPageRank - codeUnit.centralityArticleRank) AS pageToArticleRankDifferenceMean
        ,stDev(codeUnit.centralityPageRank - codeUnit.centralityArticleRank) AS pageToArticleRankDifferenceStandardDeviation
   WHERE pageToArticleRankDifferenceStandardDeviation <> 0
  UNWIND codeUnits AS codeUnit
    WITH *, codeUnit.centralityPageRank - codeUnit.centralityArticleRank     AS pageToArticleRankDifference
    WITH *, (pageToArticleRankDifference - pageToArticleRankDifferenceMean) / 
             pageToArticleRankDifferenceStandardDeviation                    AS pageToArticleRankDifferenceZScore
// Only include code units with a PageRank vs ArticleRank difference more than 2 (z-score) standard deviations from the mean
WHERE abs(pageToArticleRankDifferenceZScore) > 2.0
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName
  RETURN DISTINCT 
         coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.name                       AS shortCodeUnitName
        ,coalesce(artifactName, projectName) AS projectName
        ,sign(pageToArticleRankDifference)   AS pageToArticleRankSign
        ,pageToArticleRankDifferenceZScore
        ,pageToArticleRankDifference
        ,codeUnit.centralityPageRank         AS pageRank
        ,codeUnit.centralityArticleRank      AS articleRank
        //For Debugging
        //,pageToArticleRankDifferenceMean
        //,pageToArticleRankDifferenceStandardDeviation
  ORDER BY abs(pageToArticleRankDifferenceZScore) DESC
  LIMIT 40