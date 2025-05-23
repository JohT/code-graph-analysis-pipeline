// Candidates for Interface Segregation

MATCH (type:Type)-[:DECLARES]->(method:Method)-[:INVOKES]->(dependentMethod:Method)
MATCH (dependentMethod)<-[:DECLARES]-(dependentType:Type)
MATCH (dependentType)-[:IMPLEMENTS*1..9]->(superType:Type)-[:DECLARES]->(inheritedMethod:Method)
WHERE type.fqn <> dependentType.fqn
  AND dependentMethod.name IS NOT NULL
  AND inheritedMethod.name IS NOT NULL
  AND dependentMethod.name <> '<init>' // ignore constructors
  AND inheritedMethod.name <> '<init>' // ignore constructors
 WITH type.fqn                               AS fullTypeName
     ,dependentType.fqn                      AS fullDependentTypeName
     ,collect(DISTINCT dependentMethod.name) AS calledMethodNames
     ,count(DISTINCT dependentMethod)        AS calledMethods
     // Count the different signatures without the return type
     // of all declared methods including the inherited ones
     ,count(DISTINCT split(method.signature, ' ')[1]) + count(DISTINCT split(inheritedMethod.signature, ' ')[1]) AS declaredMethods
// Filter out types that declare only a few more methods than those that are actually used.
// A good interface segregation candidate declares a lot of methods where only a few of them are used widely.
WHERE declaredMethods > calledMethods + 2
 WITH fullDependentTypeName
     ,declaredMethods
     ,calledMethodNames
     ,calledMethods
     ,count(DISTINCT fullTypeName) AS callerTypes
 RETURN fullDependentTypeName, declaredMethods, calledMethodNames, calledMethods, callerTypes
 ORDER BY callerTypes DESC, declaredMethods DESC, fullDependentTypeName