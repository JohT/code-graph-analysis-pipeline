// Label external types and annotations

 MATCH (externalType:Type)
 WHERE externalType.byteCodeVersion IS NULL // byte code not available -> external dependency
  WITH externalType
      ,(NOT externalType.fqn CONTAINS '.')                       AS isPrimitiveType
      ,(externalType.fqn STARTS WITH 'java.')                    AS isJavaType
      ,exists((externalType)-[:RESOLVES_TO]->(:Type))            AS isAlsoInternalType
      ,exists((externalType)<-[:OF_TYPE]-()<-[:ANNOTATED_BY]-()) AS isAnnotation
 WHERE isPrimitiveType    = false
   AND isJavaType         = false
   AND isAlsoInternalType = false
  WITH externalType
      ,CASE WHEN isAnnotation THEN [1] ELSE [] END AS annotated
FOREACH (x in annotated | SET externalType:ExternalAnnotation)
    SET externalType:ExternalType 
 RETURN labels(externalType), count(externalType) as numberOfExternalTypes