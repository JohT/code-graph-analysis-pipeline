// List anomalous files

MATCH (anomalyScoreStats:File&!Directory&!Archive)
WHERE anomalyScoreStats.anomalyScore < 0
ORDER BY anomalyScoreStats.anomalyScore ASCENDING
LIMIT 150 // n largest negative anomaly scores as threshold
 WITH collect(anomalyScoreStats.anomalyScore)[-1] AS anomalyScoreThreshold
MATCH (anomalyRankStats:File&!Directory&!Archive)
 WITH anomalyScoreThreshold
     ,max(anomalyRankStats.anomalyAuthorityRank)  AS maxAnomalyAuthorityRank
     ,max(anomalyRankStats.anomalyBottleneckRank) AS maxAnomalyBottleneckRank
     ,max(anomalyRankStats.anomalyBridgeRank)     AS maxAnomalyBridgeRank
     ,max(anomalyRankStats.anomalyHubRank)        AS maxAnomalyHubRank
     ,max(anomalyRankStats.anomalyOutlierRank)    AS maxAnomalyOutlierRank
MATCH (anomalous:File&!Directory&!Archive)
WHERE (anomalous.anomalyScore < anomalyScoreThreshold
   OR  anomalous.anomalyHubRank        IS NOT NULL
   OR  anomalous.anomalyAuthorityRank  IS NOT NULL
   OR  anomalous.anomalyBottleneckRank IS NOT NULL
   OR  anomalous.anomalyOutlierRank    IS NOT NULL
   OR  anomalous.anomalyBridgeRank     IS NOT NULL)
OPTIONAL MATCH (project:Artifact|Project)-[:CONTAINS]->(anomalous)
  WITH *
      ,coalesce(project.name + '/', '')                     AS projectName
      ,coalesce(anomalous.fileName, anomalous.relativePath) AS fileName
RETURN replace(projectName + fileName, '//', '/')   AS filePath
      ,CASE WHEN anomalous.anomalyScore < 0 THEN abs(anomalous.anomalyScore) ELSE 0 END AS absoluteAnomalyScore
      ,coalesce(toFloat(anomalous.anomalyAuthorityRank) / maxAnomalyAuthorityRank, 0)   AS normalizedAuthorityRank
      ,coalesce(toFloat(anomalous.anomalyBottleneckRank) / maxAnomalyBottleneckRank, 0) AS normalizedBottleneckRank
      ,coalesce(toFloat(anomalous.anomalyBridgeRank) / maxAnomalyBridgeRank, 0)         AS normalizedBridgeRank
      ,coalesce(toFloat(anomalous.anomalyHubRank / maxAnomalyHubRank), 0)               AS normalizedHubRank
      ,coalesce(toFloat(anomalous.anomalyOutlierRank) / maxAnomalyOutlierRank, 0)       AS normalizedOutlierRank
ORDER BY filePath ASCENDING
LIMIT 200