// Anomaly Detection Labels: Label code units of archetype "Hub" by looking for the (at most) top 20 entries with the highest degree >= 90% percentile and a local clustering coefficient <= 10% percentile. Requires features/*.cypher to be run first.
// Shows code with many connections that are not well integrated into a cluster.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.communityLocalClusteringCoefficient IS NOT NULL
     AND codeUnit.incomingDependencies                IS NOT NULL
     AND codeUnit.outgoingDependencies                IS NOT NULL
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies   AS degree
    WITH collect(codeUnit)                                                  AS codeUnits
        ,percentileDisc(degree, 0.90)                                       AS degreeThreshold
        ,percentileDisc(codeUnit.communityLocalClusteringCoefficient, 0.10) AS localClusteringCoefficientThreshold
  UNWIND codeUnits AS codeUnit
    WITH *, codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
   WHERE degree                                       >= degreeThreshold
     AND codeUnit.communityLocalClusteringCoefficient <= localClusteringCoefficientThreshold
OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
    WITH *, artifact.name AS artifactName
OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
    WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName
    WITH *, coalesce(artifactName, projectName)            AS projectName
   ORDER BY codeUnit.communityLocalClusteringCoefficient ASC, degree DESC
   LIMIT 10
    WITH collect([codeUnit, projectName]) AS results
  UNWIND range(0, size(results) - 1) AS codeUnitIndex
    WITH codeUnitIndex + 1           AS codeUnitIndex
        ,results[codeUnitIndex][0]   AS codeUnit
        ,results[codeUnitIndex][1]   AS projectName
    WITH *
        ,codeUnit.incomingDependencies + codeUnit.outgoingDependencies AS degree
     SET codeUnit:Mark4TopAnomalyHub
        ,codeUnit.anomalyHubRank = codeUnitIndex
  RETURN DISTINCT 
         projectName
        ,codeUnit.name                                AS shortCodeUnitName
        ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
        ,codeUnit.communityLocalClusteringCoefficient AS localClusteringCoefficient
        ,degree
        ,codeUnit.incomingDependencies                AS incomingDependencies
        ,codeUnit.outgoingDependencies                AS outgoingDependencies
        ,codeUnit.anomalyHubRank                      AS rank