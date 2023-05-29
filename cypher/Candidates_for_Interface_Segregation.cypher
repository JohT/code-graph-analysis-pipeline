// Candidates for Interface Segregation 

MATCH (type:Type)-[:DECLARES]->(method:Method)-[:INVOKES]->(dependentMethod:Method)<-[:DECLARES]-(dependentType:Interface)
MATCH (dependentType)-[:DECLARES]->(declaredMethod:Method)
WHERE type.fqn <> dependentType
  AND dependentMethod.name IS NOT NULL
 WITH type
     ,dependentType
     ,collect(DISTINCT dependentMethod.name) AS calledMethodNames
     ,count(DISTINCT dependentMethod) AS calledMethods
     ,count(DISTINCT declaredMethod) AS declaredMethods
WHERE declaredMethods > calledMethods + 2
 WITH dependentType
     ,declaredMethods
     ,calledMethodNames
     ,calledMethods
     ,count(DISTINCT type) AS callerTypes
 RETURN dependentType.fqn AS dependentTypeFullQualifiedName, declaredMethods, calledMethodNames, calledMethods, callerTypes
 ORDER BY callerTypes DESC, declaredMethods DESC, dependentType.fqn