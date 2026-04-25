// Query Java Reflection usage combined with invocations of "Class.forName". Requires "Add_file_name and_extension.cypher".

   MATCH (dependentArtifact:Artifact)-[:CONTAINS]-(dependentType:Type)
    WITH dependentArtifact.name AS dependentArtifactName
        ,dependentType
OPTIONAL MATCH (dependentType)-[:DEPENDS_ON]->(reflectionType:Type)
   WHERE reflectionType.fqn STARTS WITH 'java.lang.reflect.'
OPTIONAL MATCH (dependentType)-[:DECLARES]->(dependentMethod:Method)-[:INVOKES]->(classForName:Method)
   WHERE classForName.signature STARTS WITH 'java.lang.Class forName'
    WITH dependentArtifactName
        ,collect(DISTINCT coalesce(reflectionType.fqn, 'Class.' + classForName.name)) AS reflectionTypes
        ,collect(DISTINCT dependentType.fqn)  AS reflectionCaller
        ,count(DISTINCT dependentType.fqn)    AS numberOfReflectionCaller
RETURN dependentArtifactName
      ,numberOfReflectionCaller
      ,reflectionCaller[0..19] AS someReflectionCaller
      ,reflectionTypes[0..19]  AS someReflectionTypes
