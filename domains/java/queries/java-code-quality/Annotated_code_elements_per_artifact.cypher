// Annotated code elements per artifact and element type with some examples. Requires "Add_file_name and_extension.cypher".

MATCH (annotatedElement:Annotation|Parameter|Field|Method|Type&!ExternalType&!JavaType)-[:ANNOTATED_BY]->()-[]->(annotation:Type)
OPTIONAL MATCH (annotatedElementArtifact:Artifact)-[:CONTAINS]->(annotatedElement)
OPTIONAL MATCH (memberArtifact:Artifact)-[:CONTAINS]->(memberDeclaringType:Type)-[:DECLARES]->(annotatedElement:Member)
OPTIONAL MATCH (parameterArtifact:Artifact)-[:CONTAINS]->(parameterOwnerType:Type)-[:DECLARES]->(parameterOwnerMethod:Method)-[:HAS]->(annotatedElement:Parameter)
 WITH annotation
     ,annotatedElement
     ,coalesce(annotatedElement.fqn
              ,annotatedElement.fileName
              ,memberDeclaringType.fqn + '.' + annotatedElement.name
              ,parameterOwnerType.fqn + '.' + parameterOwnerMethod.name + '(' +  annotatedElement.index + ')'
              ,annotatedElement.name
              ) AS nameOfAnnotatedElement
     ,coalesce(parameterArtifact, memberArtifact, annotatedElementArtifact).name AS artifactName
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
  END                                      AS languageElement
 ,artifactName
 ,count(DISTINCT annotatedElement)         AS numberOfAnnotatedElements
 ,collect(DISTINCT nameOfAnnotatedElement) AS annotatedElements
RETURN artifactName
      ,annotationName
      ,languageElement
      ,numberOfAnnotatedElements
      ,annotatedElements[0..9] AS examples                  
ORDER BY artifactName ASCENDING, numberOfAnnotatedElements DESCENDING