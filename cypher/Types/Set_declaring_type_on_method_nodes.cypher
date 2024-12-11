// Set property "declaringType" on Method nodes.

 MATCH (javaType:Type)-[:DECLARES]->(javaMethod:Method)
   SET javaMethod.declaringType = javaType.fqn
RETURN count(DISTINCT javaMethod) AS numberOfMethods
      ,count(DISTINCT javaType)   AS numberOfTypes