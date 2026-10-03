// Archetypes Labels: Label code units of archetype "Authority" by looking for the (at most) top 10 entries with a high PageRank and a (high) positive PageRank to ArticleRank difference. Requires features/*.cypher to be run first.
// Shows code that is referenced widely but not strongly contributing back - utility libraries, framework entry points.
// Method: Tukey Fence (Inter Quartile Range (IQR)-based) for pageRank; >= 0 for PageRank to ArticleRank difference (sorted by the highest values first).

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.centralityPageRank                        IS NOT NULL
     AND codeUnit.centralityArticleRank                     IS NOT NULL
     AND codeUnit.centralityPageRankToArticleRankDifference IS NOT NULL
  // Get the quartiles for the PageRank values
    WITH collect(codeUnit)                                                         AS codeUnits
        ,percentileCont(codeUnit.centralityPageRank, 0.25)                         AS pageRankQuartile1
        ,percentileCont(codeUnit.centralityPageRank, 0.75)                         AS pageRankQuartile3
  // Get the upper percentile threshold for the PageRank to ArticleRank difference based on only the positive values
  UNWIND codeUnits AS codeUnit
    WITH *
   WHERE codeUnit.centralityPageRankToArticleRankDifference >= 0
   WITH collect(codeUnit)                                                          AS codeUnits
       ,pageRankQuartile1
       ,pageRankQuartile3
       ,percentileDisc(codeUnit.centralityPageRankToArticleRankDifference, 0.90)   AS pageToArticleRankDifferenceThreshold
  // Calculate the Inter Quartile Range (IQR) and the Tukey Fence for the PageRank values
    WITH *
        ,(pageRankQuartile3 - pageRankQuartile1)                                   AS pageRankIQR
    WITH * 
        ,(pageRankQuartile3 + (0.7 * pageRankIQR))                                 AS pageRankFence
  // Unwind the code units to calculate the Tukey Fence strength for each individual code unit
  UNWIND codeUnits AS codeUnit
    WITH *
        ,CASE WHEN pageRankIQR > 0
              THEN (codeUnit.centralityPageRank - pageRankQuartile3) / pageRankIQR
              ELSE 0 END AS pageRankTukeyFenceStrengthIQRs
        ,(codeUnit.centralityPageRankToArticleRankDifference >= pageToArticleRankDifferenceThreshold) AS strongPageToArticleRankDifference
   WHERE codeUnit.centralityPageRank   >= pageRankFence
    WITH *
        ,CASE WHEN pageRankTukeyFenceStrengthIQRs >= 1.5 AND strongPageToArticleRankDifference
               THEN 30
               WHEN pageRankTukeyFenceStrengthIQRs >= 0.9
               THEN 20
               ELSE 10
          END AS outlierClassInteger
    WITH *
        ,CASE WHEN outlierClassInteger >= 30
              THEN 'Strong authority (pageRank >= 1.5 IQRs + strong difference)'
              WHEN outlierClassInteger >= 20
              THEN 'Moderate authority (pageRank >= 0.9 IQRs)'
              ELSE 'Light authority'
          END AS authorityClassification
    WITH *, coalesce(codeUnit.projectName, '') AS projectName
   ORDER BY outlierClassInteger DESC, codeUnit.centralityPageRank DESC, codeUnit.centralityArticleRank ASC
   LIMIT 10
  // Collect the top code units into a list for final processing
    WITH collect([codeUnit, projectName, outlierClassInteger, authorityClassification, pageRankTukeyFenceStrengthIQRs, strongPageToArticleRankDifference, pageToArticleRankDifferenceThreshold]) AS results
  UNWIND range(0, size(results) - 1) AS codeUnitIndex
    WITH codeUnitIndex + 1           AS codeUnitIndex
        ,results[codeUnitIndex][0]   AS codeUnit
        ,results[codeUnitIndex][1]   AS projectName
        ,results[codeUnitIndex][2]   AS outlierClassInteger
        ,results[codeUnitIndex][3]   AS authorityClassification
        ,results[codeUnitIndex][4]   AS pageRankTukeyFenceStrengthIQRs
        ,results[codeUnitIndex][5]   AS strongPageToArticleRankDifference
        ,results[codeUnitIndex][6]   AS pageToArticleRankDifferenceThreshold
     SET codeUnit:Mark4TopArchetypeAuthority
        ,codeUnit.archetypeAuthorityRank = codeUnitIndex
  RETURN projectName
        ,codeUnit.name                                                AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,authorityClassification
        ,codeUnit.centralityPageRank                                  AS pageRank
        ,codeUnit.centralityArticleRank                               AS articleRank
        ,codeUnit.centralityPageRankToArticleRankDifference           AS normalizedPageRankToArticleRankDifference
        ,pageRankTukeyFenceStrengthIQRs                               AS pageRankTukeyFenceStrengthIQRs
        ,codeUnit.archetypeAuthorityRank                              AS rank
        // Debug columns
        //,strongPageToArticleRankDifference                            AS strongPageToArticleRankDifferenceDebug
        //,pageToArticleRankDifferenceThreshold                         AS pageToArticleRankDifferenceThresholdDebug
  ORDER BY codeUnitIndex