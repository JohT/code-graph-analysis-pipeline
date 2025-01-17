// Query deprecated type and member usage by non deprecated elements. Requires "Add_file_name and_extension.cypher".

         MATCH (annotated)-[:ANNOTATED_BY]->(:Annotation)-[:OF_TYPE]->(:Type{fqn:'java.lang.Deprecated'})
OPTIONAL MATCH (artifactReadsDeprecated:Artifact)-[:CONTAINS]->(typeReadsDeprecated:Type)-[:DECLARES]->(readsDeprecated:Method)-[:READS]->(annotated:Field)
OPTIONAL MATCH (artifactInvokesDeprecated:Artifact)-[:CONTAINS]->(typeInvokesDeprecated:Type)-[:DECLARES]->(invokesDeprecated:Method)-[:INVOKES]->(annotated:Method)
OPTIONAL MATCH (artifactInvokesParameterDeprecated:Artifact)-[:CONTAINS]->(typeInvokesParameterDeprecated:Type)-[:DECLARES]->(invokesParameterDeprecated:Method)-[:INVOKES]->(parameterAnnotatedMethod:Method)-[:HAS]->(annotated:Parameter)
OPTIONAL MATCH (artifactDependsOnDeprecated:Artifact)-[:CONTAINS]->(typeDependsOnDeprecated:Type)-[:DEPENDS_ON]->(annotated:Type)
    WITH coalesce(artifactReadsDeprecated, artifactInvokesDeprecated, artifactInvokesParameterDeprecated, artifactDependsOnDeprecated) AS artifact
        ,coalesce(typeReadsDeprecated, typeInvokesDeprecated, typeInvokesParameterDeprecated, typeDependsOnDeprecated) AS type
        ,coalesce(readsDeprecated, invokesDeprecated, invokesParameterDeprecated) AS method
        ,CASE WHEN 'Annotation'  IN labels(annotated) THEN 'Annotation'
              WHEN 'Parameter'   IN labels(annotated) THEN 'Parameter'
              WHEN 'Field'       IN labels(annotated) THEN 'Field'
              WHEN 'Constructor' IN labels(annotated) THEN 'Constructor'
              WHEN 'Method'      IN labels(annotated) THEN 'Method'
              WHEN 'Member'      IN labels(annotated) THEN 'Member'
              WHEN 'Class'       IN labels(annotated) THEN 'Class'
              WHEN 'Interface'   IN labels(annotated) THEN 'Interface'
              WHEN 'Enum'        IN labels(annotated) THEN 'Enum'
              WHEN 'Type'        IN labels(annotated) THEN 'Type'
              ELSE 'Unexpected'
        END  AS deprecatedElement        
        ,coalesce(typeReadsDeprecated.fqn + '.' + readsDeprecated.name
                 ,typeInvokesDeprecated.fqn + '.' + invokesDeprecated.name
                 ,typeInvokesParameterDeprecated.fqn + '.' + invokesParameterDeprecated.name
                 ,typeDependsOnDeprecated.fqn
              ) AS elementUsingDeprecatedElement
  WHERE artifact IS NOT NULL
    AND NOT (type)-[:ANNOTATED_BY]->(:Annotation)-[:OF_TYPE]->(:Type{fqn:'java.lang.Deprecated'})
    AND NOT (method)-[:ANNOTATED_BY]->(:Annotation)-[:OF_TYPE]->(:Type{fqn:'java.lang.Deprecated'})
RETURN artifact.name AS artifactName
      ,deprecatedElement
      ,count(DISTINCT elementUsingDeprecatedElement)            AS numberOfElementsUsingDeprecatedElements
      ,collect(DISTINCT elementUsingDeprecatedElement)[0..19]   AS someElementsUsingDeprecatedElements
ORDER BY artifactName ASCENDING