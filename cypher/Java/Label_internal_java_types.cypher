// Label internal Java types (non java built-in types that have byte code version). Requires 'Label_external_types_and_annotations' (optionally).

 MATCH (javaType:Java:Type)
 WHERE javaType.byteCodeVersion IS NOT NULL // internal types have byte code version, external types don't
   AND NOT javaType:ExternalType
   AND NOT javaType:PrimitiveType
   AND NOT javaType:Void
   AND NOT javaType:JavaType
   AND NOT javaType:ResolvedDuplicateType
   AND NOT javaType.name = 'package-info'
  WITH javaType
   SET javaType:InternalJavaType
  WITH javaType
UNWIND labels(javaType) AS javaTypeLabel
  WITH javaType, javaTypeLabel
 WHERE NOT javaTypeLabel STARTS WITH 'Mark4'
   AND NOT javaTypeLabel IN ['Type', 'Java', 'File', 'ByteCode']
  WITH javaType, collect(javaTypeLabel) AS javaTypeLabels
RETURN javaTypeLabels, count(javaType) as numberOfInternalJavaTypes
ORDER BY numberOfInternalJavaTypes DESC