// Label external types and external annotations. Requires 'Label_base_java_types', 'Label_buildin_java_types' and 'Label_resolved_duplicate_types' of 'Types' directory.

  MATCH (type:Type&!PrimitiveType&!Void&!JavaType&!ResolvedDuplicateType&!TS)
   WITH type
       ,type.byteCodeVersion IS NULL                      AS isExternalType
       ,exists((type)<-[:OF_TYPE]-()<-[:ANNOTATED_BY]-()) AS isAnnotation
   WITH type
       ,isExternalType
       ,CASE WHEN isAnnotation THEN [1] ELSE [] END AS annotation
  WHERE isExternalType
FOREACH (x in annotation | SET type:ExternalAnnotation)
    SET type:ExternalType 
 RETURN labels(type), count(type) as numberOfExternalTypes