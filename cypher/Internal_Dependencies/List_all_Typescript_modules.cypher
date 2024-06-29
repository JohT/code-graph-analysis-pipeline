// List all existing internal Typescript modules

MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement:TS)
 WITH internalModule.name                       AS moduleName
     ,internalModule.globalFqn                  AS moduleFullQualifiedName
     ,internalModule.incomingDependencies       AS incomingDependencies
     ,internalModule.outgoingDependencies       AS outgoingDependencies
     ,COUNT(DISTINCT internalElement.globalFqn) AS numberOfElements
RETURN moduleName, numberOfElements, incomingDependencies, outgoingDependencies, moduleFullQualifiedName