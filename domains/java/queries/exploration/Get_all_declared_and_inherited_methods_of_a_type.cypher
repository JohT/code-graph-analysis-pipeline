// Get all declared and inherited methods of a type

 MATCH (type:Type)-[:DECLARES]->(method:Method)
 MATCH (type)-[:IMPLEMENTS*]->(superType:Type)-[:DECLARES]->(inheritedMethod:Method)
 WHERE type.name = 'TrackedEventMessage' 
   AND method.name          IS NOT NULL
   AND inheritedMethod.name IS NOT NULL
//RETURN type, method, superType, inheritedMethod
  WITH type
      ,COLLECT(DISTINCT method.name)          AS methodNames
      ,COLLECT(DISTINCT superType.name)       AS superTypes
      ,COLLECT(DISTINCT inheritedMethod.name) AS inheritedMethods
      ,COLLECT(DISTINCT split(method.signature, ' ')[1]) + COLLECT(DISTINCT split(inheritedMethod.signature, ' ')[1]) AS allMethodSignaturesWithoutReturnType
RETURN type.fqn, type.name, methodNames
      ,size(allMethodSignaturesWithoutReturnType) AS distinctDeclaredMethods, allMethodSignaturesWithoutReturnType
      ,inheritedMethods, superTypes