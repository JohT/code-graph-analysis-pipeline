// Query all types that use Java Reflection or "Class.forName"

   MATCH (dependentArtifact:Artifact)-[:CONTAINS]-(dependentType:Type)
    WITH replace(last(split(dependentArtifact.fileName, '/')), '.jar', '') AS dependentArtifactName
        ,dependentType
OPTIONAL MATCH (dependentType)-[:DEPENDS_ON]->(reflectionType:Type)
   WHERE reflectionType.fqn STARTS WITH 'java.lang.reflect.'
OPTIONAL MATCH (dependentType)-[:DECLARES]->(dependentMethod:Method)-[:INVOKES]->(classForName:Method)
   WHERE classForName.signature STARTS WITH 'java.lang.Class forName'
    WITH dependentArtifactName
        ,dependentType.fqn  AS reflectionCallerTypeName
        ,collect(DISTINCT coalesce(reflectionType.fqn, 'Class.' + classForName.name)) AS reflectionTypes
   WHERE size(reflectionTypes) > 0
  RETURN dependentArtifactName
        ,reflectionCallerTypeName
        ,reflectionTypes[0..19]  AS reflectionTypes