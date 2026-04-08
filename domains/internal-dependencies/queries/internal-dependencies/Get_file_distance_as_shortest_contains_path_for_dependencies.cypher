// Get file distance distribution for dependencies (intuitively the fewest number of change directory commands needed)

  MATCH (source:File)-[dependency:DEPENDS_ON]->(target:File)
  WHERE dependency.fileDistanceAsFewestChangeDirectoryCommands IS NOT NULL
   WITH count(*)            AS totalNumberOfDependencies
       ,collect(dependency) AS dependencies
 UNWIND dependencies        AS dependency
   WITH *
       ,startNode(dependency)      AS source
       ,endNode(dependency)        AS target      
 RETURN dependency.fileDistanceAsFewestChangeDirectoryCommands              AS directoryDistance
       ,count(*)                                                            AS numberOfDependencies
       ,round(count(*) / (max(totalNumberOfDependencies) + 1E-38) * 100, 2) AS percentageOfDependencies
       ,count(DISTINCT source)                                              AS numberOfDependencyUsers
       ,count(DISTINCT target)                                              AS numberOfDependencyProviders
       ,collect(source.fileName + ' uses ' + target.fileName)[0..4]         AS examples
 ORDER BY directoryDistance