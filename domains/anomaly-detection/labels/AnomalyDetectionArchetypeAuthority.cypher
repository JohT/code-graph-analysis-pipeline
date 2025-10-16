// Anomaly Detection Labels: Label code units of archetype "Authority" by looking for the (at most) top 20 entries with a high PageRank >= 90% percentile and a high PageRank to ArticleRank difference >= 95% percentile. Requires features/*.cypher to be run first.
// Shows code that is referenced widely but not strongly contributing back (utility libraries, framework entry points)

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityPageRank    IS NOT NULL
     AND codeUnit.centralityArticleRank IS NOT NULL
    WITH collect(codeUnit)                                 AS codeUnits
        ,min(codeUnit.centralityPageRank)                  AS minPageRank
        ,max(codeUnit.centralityPageRank)                  AS maxPageRank
        ,min(codeUnit.centralityArticleRank)               AS minArticleRank
        ,max(codeUnit.centralityArticleRank)               AS maxArticleRank
        ,percentileDisc(codeUnit.centralityPageRank, 0.90) AS pageRankThreshold
        ,percentileDisc(codeUnit.centralityPageRankToArticleRankDifference, 0.90)  AS pageToArticleRankDifferenceThreshold
  UNWIND codeUnits AS codeUnit
    WITH *
   WHERE codeUnit.centralityPageRankToArticleRankDifference  >= pageToArticleRankDifferenceThreshold
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName
    WITH *, coalesce(artifactName, projectName)            AS projectName
   ORDER BY codeUnit.centralityPageRank DESC, codeUnit.centralityArticleRank ASC
   LIMIT 10
    WITH collect([codeUnit, projectName]) AS results
  UNWIND range(0, size(results) - 1)      AS codeUnitIndex
    WITH codeUnitIndex + 1                AS codeUnitIndex
        ,results[codeUnitIndex][0]        AS codeUnit
        ,results[codeUnitIndex][1]        AS projectName
     SET codeUnit:Mark4TopAnomalyAuthority
        ,codeUnit.anomalyAuthorityRank = codeUnitIndex
  RETURN DISTINCT 
         projectName
        ,codeUnit.name                                        AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.centralityPageRank                          AS pageRank
        ,codeUnit.centralityArticleRank                       AS articleRank
        ,codeUnit.centralityPageRankToArticleRankDifference   AS normalizedPageRankToArticleRankDifference
        ,codeUnit.anomalyAuthorityRank                        AS rank