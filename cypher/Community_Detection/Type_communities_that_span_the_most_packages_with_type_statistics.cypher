// Communities that span the most packages with type statistics

 MATCH (a:Artifact)-[:CONTAINS]->(p:Package)-[:CONTAINS]->(t:Type)
  WITH replace(last(split(a.fileName, '/')), '.jar', '') AS artifactName
      ,t.communityLeidenId                               AS communityId
      ,p.fqn                                             AS packageName
      ,collect(DISTINCT p.fqn)                           AS packageNames
      ,count(DISTINCT p.fqn)                             AS packageCount
      ,collect(DISTINCT t.fqn)                           AS typeNames
      ,count(DISTINCT t.fqn)                             AS typeCount
ORDER BY typeCount ASCENDING
 WHERE communityId IS NOT NULL
  WITH artifactName
      ,communityId
      ,collect(DISTINCT packageName) AS packageNames
      ,count(DISTINCT packageName)   AS packageCount
      // The object structure of "packageCommunityTypes" only works in the browser.
      // It is only meant to be a helper to see how the communities and their packages are distributed in detail.
      //,collect(DISTINCT {package: packageName, numberOfTypes:typeCount}) AS packageCommunityTypes
      ,sum(typeCount)                AS sumTypeCount
      ,min(typeCount)                AS minTypeCount
      ,max(typeCount)                AS maxTypeCount
      ,avg(typeCount)                AS avgTypeCount
      ,stDev(typeCount)              AS stdTypeCount
      ,percentileDisc(typeCount, 0.5) AS per5TypeCount
RETURN artifactName
      ,communityId
      ,packageCount
      ,sumTypeCount
      ,minTypeCount
      ,maxTypeCount
      ,avgTypeCount
      ,stdTypeCount
      ,per5TypeCount
      //,packageCommunityTypes
      ,packageNames
ORDER BY packageCount DESCENDING
        ,sumTypeCount DESCENDING
        ,communityId  ASCENDING