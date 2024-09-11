// Jakarta Enterprise Edition JAX-RS REST Annotations. Requires "Add_file_name and_extension.cypher".
//
// --- Method Http Annotation ---
MATCH (method:Method)-[:ANNOTATED_BY]->(httpMethodLink:Annotation)-[:OF_TYPE]->(httpMethodAnnotation:Type)
WHERE ((httpMethodAnnotation.fqn STARTS WITH 'jakarta.ws.rs.'
   OR   httpMethodAnnotation.fqn STARTS WITH 'javax.ws.rs.')
  AND  httpMethodAnnotation.name IN ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD', 'OPTIONS'])
// --- Method Path Annotation ---
OPTIONAL MATCH (method)-[:ANNOTATED_BY]->(pathMethodLink:Annotation)-[:OF_TYPE]->(pathMethodAnnotation:Type)
WHERE pathMethodAnnotation.fqn in ['jakarta.ws.rs.Path', 'javax.ws.rs.Path']
OPTIONAL MATCH (pathMethodLink)-[:HAS]->(pathMethodValue:Value{name: 'value'})
// --- Method Parameter Annotation ---
OPTIONAL MATCH (method)-[:HAS]->(methodParam:Parameter)-[:ANNOTATED_BY]->(methodParamLink:Annotation)-[:OF_TYPE]->(methodParamAnnotation:Type)
WHERE ((methodParamAnnotation.fqn STARTS WITH 'jakarta.ws.rs.'
   OR   methodParamAnnotation.fqn STARTS WITH 'javax.ws.rs.')
  AND  methodParamAnnotation.name ENDS WITH 'Param'
  AND  methodParamAnnotation.name <> 'PathParam')
OPTIONAL MATCH (methodParamLink)-[:HAS]->(methodParamValue:Value{name: 'value'})
// --- Type Path Annotation ---
OPTIONAL MATCH (method)<-[:DECLARES]-(pathType:Type)
OPTIONAL MATCH (pathType)-[:ANNOTATED_BY]->(pathTypeLink:Annotation)-[:OF_TYPE]->(pathTypeAnnotation:Type)
WHERE pathTypeAnnotation.fqn in ['jakarta.ws.rs.Path', 'javax.ws.rs.Path']
OPTIONAL MATCH (pathTypeLink)-[:HAS]->(pathTypeValue:Value{name: 'value'})
// --- SubType Path Annotation ---
OPTIONAL MATCH (pathType:Type)<-[:EXTENDS*1..3]-(subPathType:Type)-[:ANNOTATED_BY]->(subPathTypeLink:Annotation)-[:OF_TYPE]->(subPathTypeAnnotation:Type)
WHERE subPathTypeAnnotation.fqn in ['jakarta.ws.rs.Path', 'javax.ws.rs.Path']
OPTIONAL MATCH (subPathTypeLink)-[:HAS]->(subPathTypeValue:Value{name: 'value'})
// --- Application Path Annotation ---
OPTIONAL MATCH (artifact:Artifact)-[:CONTAINS]->(pathType)
OPTIONAL MATCH (artifact)-[:CONTAINS]->(applicationPathType:Type)-[:ANNOTATED_BY]->(applicationPathLink:Annotation)-[:OF_TYPE]->(applicationPathAnnotation:Type)
WHERE applicationPathAnnotation.fqn in ['jakarta.ws.rs.ApplicationPath', 'javax.ws.rs.ApplicationPath']
OPTIONAL MATCH (applicationPathLink)-[:HAS]->(applicationPathValue:Value{name: 'value'})
// --- Return Results ---
RETURN replace(
         coalesce(applicationPathValue.value, '') + '/' +
         coalesce(subPathTypeValue.value, pathTypeValue.value, '') + '/' + 
         coalesce(pathMethodValue.value, '')
       , '//', '/')                                             AS path
      ,httpMethodAnnotation.name                                AS httpMethod
      ,artifact.name AS resourceArtifact
      ,coalesce(subPathType.fqn, pathType.fqn)                  AS resourceType
      ,method.name                                              AS resourceMethod
      ,collect(methodParamAnnotation.name + ': ' + 
        methodParamValue.value
      )                                                         AS methodParameters
ORDER BY path, httpMethod, resourceType, resourceMethod