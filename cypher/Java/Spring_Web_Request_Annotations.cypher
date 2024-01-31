// Spring Web Request Annotations
//
// --- Method HTTP Annotation ---
MATCH (method:Method)-[:ANNOTATED_BY]->(httpMethodLink:Annotation)-[:OF_TYPE]->(httpMethodAnnotation:Type)
WHERE httpMethodAnnotation.fqn STARTS WITH 'org.springframework.web.bind.annotation.'
  AND httpMethodAnnotation.name IN ['RequestMapping', 'GetMapping', 'PostMapping', 'PutMapping', 'DeleteMapping', 'PatchMapping']
// --- Method HTTP Annotation Path Value ---
OPTIONAL MATCH (httpMethodLink)-[:HAS]->(httpPathAnnotationProperty:Value)-[:CONTAINS]->(httpPathAnnotationValue:Value)
WHERE httpPathAnnotationProperty.name IN ['value', 'path']
// --- Method HTTP Annotation Path Value ---
OPTIONAL MATCH (httpMethodLink)-[:HAS]->(httpMethodAnnotationProperty:Value)-[:CONTAINS]->(httpMethodAnnotationValue:Value)
WHERE httpMethodAnnotationProperty.name = 'method'
// --- Method HTTP Annotation Other Values ---
OPTIONAL MATCH (httpMethodLink)-[:HAS]->(httpAnnotationAdditionalProperty:Value)-[:CONTAINS]->(httpAnnotationAdditionalValue:Value)
WHERE NOT httpAnnotationAdditionalProperty.name IN ['value', 'path', 'method']
// --- Method Parameter Annotation ---
OPTIONAL MATCH (method)-[:HAS]->(methodParam:Parameter)-[:ANNOTATED_BY]->(methodParamLink:Annotation)-[:OF_TYPE]->(methodParamAnnotation:Type)
WHERE methodParamAnnotation.fqn STARTS WITH 'org.springframework.web.bind.annotation.'
OPTIONAL MATCH (methodParamLink)-[:HAS]->(methodParamAnnotationValue:Value)
// --- Type Path Annotation ---
OPTIONAL MATCH (method)<-[:DECLARES]-(resourceType:Type)
OPTIONAL MATCH (resourceType)-[:ANNOTATED_BY]->(pathTypeLink:Annotation)-[:OF_TYPE]->(pathTypeAnnotation:Type)
WHERE pathTypeAnnotation.fqn = 'org.springframework.web.bind.annotation.RequestMapping'
OPTIONAL MATCH (pathTypeLink)-[:HAS]->(pathTypeAnnotationProperty:Value)-[:CONTAINS]->(pathTypeAnnotationValue:Value)
WHERE pathTypeAnnotationProperty.name IN ['value', 'path']
// --- SubType Path Annotation ---
OPTIONAL MATCH (resourceType:Type)<-[:EXTENDS*1..5]-(subResourceType:Type)-[:ANNOTATED_BY]->(subResourceTypeLink:Annotation)-[:OF_TYPE]->(subResourceTypeAnnotation:Type)
WHERE subResourceTypeAnnotation.fqn = 'org.springframework.web.bind.annotation.RequestMapping'
OPTIONAL MATCH (subResourceTypeLink)-[:HAS]->(subResourceTypeAnnotationProperty:Value)-[:CONTAINS]->(subResourceTypeAnnotationValue:Value)
WHERE subResourceTypeAnnotationProperty.name IN ['value', 'path']
// --- Artifact ---
OPTIONAL MATCH (artifact:Artifact)-[:CONTAINS]->(resourceType)
// --- Return Results ---
RETURN replace(
         coalesce(subResourceTypeAnnotationValue.value, pathTypeAnnotationValue.value, '') + 
         '/' +                                              
         coalesce(httpPathAnnotationValue.value, '')                                                
        , '//', '/')                                                AS path
      ,coalesce(
        httpMethodAnnotationValue.value, 
        toUpper(
          replace(replace(httpMethodAnnotation.name, 'Mapping', ''), 'Request', 'All')
          )
       )                                                            AS httpMethod
      ,replace(last(split(artifact.fileName, '/')), '.jar', '')     AS resourceArtifact
      ,coalesce(subResourceType.fqn, resourceType.fqn)              AS resourceType
      ,method.name                                                  AS resourceMethod
      ,collect(
        httpAnnotationAdditionalProperty.name + ': ' + 
        httpAnnotationAdditionalValue.value
      )                                                             AS additionalHttpProperties
      ,collect(methodParamAnnotation.name + 
        replace('.' + methodParamAnnotationValue.name, '.value', '') + 
        ': ' + 
        methodParamAnnotationValue.value)                           AS methodParameters
ORDER BY path, httpMethod, resourceType, resourceType