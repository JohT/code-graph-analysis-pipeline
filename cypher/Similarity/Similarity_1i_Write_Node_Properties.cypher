// Write similar node names and their score per node

 MATCH (source)-[similar:SIMILAR]->(target)
 WHERE $dependencies_projection_node IN labels(source)
   AND $dependencies_projection_node IN labels(target)
  WITH source
      ,coalesce(source.fqn, source.fileName, source.name) AS sourceName
      ,similar.score                                      AS similarityScore
      ,coalesce(target.fqn, target.fileName, target.name) AS targetName
 ORDER BY sourceName ASCENDING, similarityScore DESCENDING
  WITH source
      ,sourceName
      ,collect(DISTINCT targetName)      AS similarNames
      ,collect(DISTINCT similarityScore) AS similarityScores
   SET source.similarNames     = similarNames
      ,source.similarityScores = similarityScores
//RETURN sourceName, similarNames, similarityScores
//ORDER BY sourceName ASCENDING
 RETURN count(source) AS writtenNodes
