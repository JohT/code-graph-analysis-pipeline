// Annotated language elements by number of annotations

MATCH (annotatedElement:Annotation|Parameter|Field|Method|Type&!ExternalType&!JavaType)-[:ANNOTATED_BY]->()-[]->(annotation:Type)
OPTIONAL MATCH (parameterOwner:Method)-[:HAS]->(annotatedElement:Parameter)
 WITH annotation
     ,annotatedElement
     ,parameterOwner.signature AS parameterOwnerMethodSignature
     ,coalesce(annotatedElement.fqn, annotatedElement.fileName, annotatedElement.signature, annotatedElement.name) AS nameOfAnnotatedElement
 WITH annotation.fqn  AS annotationName
  ,CASE WHEN 'Annotation'  IN labels(annotatedElement) THEN 'Annotation'
        WHEN 'Parameter'   IN labels(annotatedElement) THEN 'Parameter'
        WHEN 'Field'       IN labels(annotatedElement) THEN 'Field'
        WHEN 'Constructor' IN labels(annotatedElement) THEN 'Constructor'
        WHEN 'Method'      IN labels(annotatedElement) THEN 'Method'
        WHEN 'Member'      IN labels(annotatedElement) THEN 'Member'
        WHEN 'Class'       IN labels(annotatedElement) THEN 'Class'
        WHEN 'Interface'   IN labels(annotatedElement) THEN 'Interface'
        WHEN 'Enum'        IN labels(annotatedElement) THEN 'Enum'
        WHEN 'Type'        IN labels(annotatedElement) THEN 'Type'
        ELSE 'Unexpected'
  END                                             AS languageElement
 ,count(DISTINCT annotatedElement)                AS numberOfAnnotatedElements
 ,collect(DISTINCT nameOfAnnotatedElement)        AS annotatedElements
 ,collect(DISTINCT parameterOwnerMethodSignature) AS methodSignatures
RETURN annotationName
      ,languageElement
      ,numberOfAnnotatedElements
      ,CASE languageElement 
          WHEN 'Parameter' THEN methodSignatures[0..9]
          ELSE                  annotatedElements[0..9]
       END AS examples                  
ORDER BY numberOfAnnotatedElements DESCENDING