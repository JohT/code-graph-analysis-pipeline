// Label connected internal Java types (non java built-in types that have byte code version and are somehow connected). Requires 'Label_internal_java_types.cypher'.

  MATCH (javaType:Java:InternalJavaType)
 OPTIONAL MATCH (javaType)-[typeDependency:DEPENDS_ON]->(dependentType:Java:InternalJavaType)
  WITH javaType
      ,typeDependency
      ,dependentType
      ,exists((javaType)<-[:DEPENDS_ON]-(:Type))   AS hasIncomingDependenciesInternal
 WHERE (hasIncomingDependenciesInternal OR dependentType IS NOT NULL)
   SET javaType:ConnectedInternalJavaType
  WITH javaType, count(*) AS numberOfDependentTypes
UNWIND labels(javaType) AS javaTypeLabel
  WITH javaType, javaTypeLabel
 WHERE NOT javaTypeLabel STARTS WITH 'Mark4'
   AND NOT javaTypeLabel IN ['Type', 'Java', 'File', 'ByteCode']
  WITH javaType, collect(javaTypeLabel) AS javaTypeLabels
RETURN javaTypeLabels, count(javaType) as numberOfInternalJavaTypes
ORDER BY numberOfInternalJavaTypes DESC