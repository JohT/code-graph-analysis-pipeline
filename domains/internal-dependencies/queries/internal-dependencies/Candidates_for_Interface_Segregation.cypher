// Candidates for Interface Segregation
// Lists Java interfaces that declare many methods but where callers only use a small subset.
// These are candidates to be split into a smaller, more focused interface (ISP).
// Column descriptions:
//  - fullQualifiedTypeName:      FQN of the interface that may be too broad
//  - declaredMethodCount:        total public methods (declared + inherited from super-interfaces)
//  - distinctCalledMethodCount:  how many distinct methods callers actually invoke
//  - usageRatio:                 distinctCalledMethodCount / declaredMethodCount (lower = stronger candidate)
//  - callerCount:                number of distinct caller types using only that subset
//  - exampleCalledMethods:       the actual method names callers are using

MATCH (type:Type)-[:DECLARES]->(method:Method)-[:INVOKES]->(dependentMethod:Method)
MATCH (dependentMethod)<-[:DECLARES]-(dependentType:Type&Interface)
MATCH (dependentType)-[:IMPLEMENTS*1..9]->(superType:Type)-[:DECLARES]->(inheritedMethod:Method)
WHERE type.fqn <> dependentType.fqn
  AND dependentMethod.name IS NOT NULL
  AND inheritedMethod.name IS NOT NULL
  AND dependentMethod.name <> '<init>' // ignore constructors
  AND inheritedMethod.name <> '<init>' // ignore constructors
 WITH type.fqn                               AS fullTypeName
     ,dependentType.fqn                      AS fullQualifiedTypeName
     ,collect(DISTINCT dependentMethod.name) AS exampleCalledMethods
     ,count(DISTINCT dependentMethod)        AS distinctCalledMethodCount
     // Count the different signatures without the return type
     // of all declared methods including the inherited ones
     ,count(DISTINCT split(method.signature, ' ')[1]) + count(DISTINCT split(inheritedMethod.signature, ' ')[1]) AS declaredMethodCount
// Filter out types that declare only a few more methods than those that are actually used.
// A good interface segregation candidate declares a lot of methods where only a few of them are used widely.
WHERE declaredMethodCount > distinctCalledMethodCount + 2
 WITH fullQualifiedTypeName
     ,declaredMethodCount
     ,exampleCalledMethods
     ,distinctCalledMethodCount
     ,count(DISTINCT fullTypeName) AS callerCount
 RETURN fullQualifiedTypeName
       ,declaredMethodCount
       ,distinctCalledMethodCount
       ,round(toFloat(distinctCalledMethodCount) / declaredMethodCount * 100) / 100 AS usageRatio
       ,callerCount
       ,exampleCalledMethods
 ORDER BY callerCount DESC, declaredMethodCount DESC, fullQualifiedTypeName