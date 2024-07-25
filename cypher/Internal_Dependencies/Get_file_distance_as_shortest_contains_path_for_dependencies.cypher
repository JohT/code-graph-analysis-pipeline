// Get file distance distribution for dependencies (intuitively the fewest number of change directory commands needed)

  MATCH (source:File)-[dependency:DEPENDS_ON]->(target:File)
  WHERE dependency.fileDistanceAsFewestChangeDirectoryCommands IS NOT NULL
 RETURN dependency.fileDistanceAsFewestChangeDirectoryCommands
       ,count(*)               AS numberOfDependencies
       ,count(DISTINCT source) AS numberOfDependencyUsers
       ,count(DISTINCT target) AS numberOfDependencyProviders
       ,collect(source.fileName + ' uses ' + target.fileName)[0..4] AS examples
 ORDER BY dependency.fileDistanceAsFewestChangeDirectoryCommands