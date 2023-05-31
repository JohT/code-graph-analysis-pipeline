// Candidates for Interface Segregation 

MATCH (type:Type)-[:DECLARES]->(method:Method)-[:INVOKES]->(dependentMethod:Method)
MATCH (dependentType:Type)-[:DECLARES]->(dependentMethod)
MATCH (dependentType)-[:DECLARES]->(declaredMethod:Method)
MATCH (dependentType)-[:IMPLEMENTS*1..10]->(superType:Type)-[:DECLARES]->(inheritedMethod:Method)
WHERE type.fqn <> dependentType
  AND dependentMethod.name IS NOT NULL
  AND inheritedMethod.name IS NOT NULL
  AND dependentMethod.name <> '<init>' // ignore constructors
 WITH type
     ,dependentType
     ,collect(DISTINCT dependentMethod.name) AS calledMethodNames
     ,count(DISTINCT dependentMethod) AS calledMethods
     ,count(DISTINCT declaredMethod.signature) + count(DISTINCT inheritedMethod.signature) AS declaredMethods
WHERE declaredMethods > calledMethods + 2
 WITH dependentType
     ,declaredMethods
     ,calledMethodNames
     ,calledMethods
     ,count(DISTINCT type) AS callerTypes
 RETURN dependentType.fqn AS dependentTypeFullQualifiedName, declaredMethods, calledMethodNames, calledMethods, callerTypes
 ORDER BY callerTypes DESC, declaredMethods DESC, dependentType.fqn