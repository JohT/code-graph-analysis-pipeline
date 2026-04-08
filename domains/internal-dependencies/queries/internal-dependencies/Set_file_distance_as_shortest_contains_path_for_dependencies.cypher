// Set file distance for dependencies as the shortest path of CONTAINS relationships (intuitively the fewest number of change directory commands needed)

   MATCH (source:File)-[dependency:DEPENDS_ON]->(target:File)
   MATCH changeDirectoryPath = shortestPath((source)-[:CONTAINS*1..15]-(target))
   WHERE ALL ( file IN nodes(changeDirectoryPath) WHERE "File" IN labels(file) )
OPTIONAL MATCH (source)<-[:CONTAINS]-(commonDirectory:Directory)-[:CONTAINS]->(target)
    WITH *, CASE commonDirectory
              WHEN IS NOT NULL THEN 0
              ELSE length(changeDirectoryPath)
            END AS fileDistanceAsFewestChangeDirectoryCommands
    SET dependency.fileDistanceAsFewestChangeDirectoryCommands
                  =fileDistanceAsFewestChangeDirectoryCommands
 RETURN fileDistanceAsFewestChangeDirectoryCommands
       ,count(*)               AS numberOfDependencies
       ,count(DISTINCT source) AS numberOfDependencyUsers
       ,count(DISTINCT target) AS numberOfDependencyProviders
       ,collect(source.fileName + ' uses ' + target.fileName)[0..4] AS examples
 ORDER BY fileDistanceAsFewestChangeDirectoryCommands