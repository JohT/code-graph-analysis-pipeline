// List all existing internal Typescript modules. Requires "Set_localRootPath_for_modules.cypher", "Set_number_of...commits.cypher".

MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement:TS)
 WITH internalModule.name                            AS moduleName
     ,internalModule.rootProjectName                 AS rootProjectName
     ,internalModule.localModuleDir                  AS localModuleDir
     ,internalModule.incomingDependencies            AS incomingDependencies
     ,internalModule.outgoingDependencies            AS outgoingDependencies
     ,coalesce(internalModule.numberOfGitCommits, 0) AS numberOfGitCommits
     ,COUNT(DISTINCT internalElement.globalFqn)      AS numberOfElements
RETURN rootProjectName, moduleName, numberOfElements, numberOfGitCommits, incomingDependencies, outgoingDependencies