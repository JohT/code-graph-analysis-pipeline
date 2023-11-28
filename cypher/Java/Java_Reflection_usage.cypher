// Query Java Reflection usage combined with invokations of "Class.forName"

   MATCH (dependentArtifact:Artifact)-[:CONTAINS]-(dependentType:Type)
    WITH replace(last(split(dependentArtifact.fileName, '/')), '.jar', '') AS dependentArtifactName
        ,dependentType AS dependentType
OPTIONAL MATCH (dependentType)-[:DEPENDS_ON]->(reflectionType:Type)
   WHERE reflectionType.fqn STARTS WITH 'java.lang.reflect.'
OPTIONAL MATCH (dependentType)-[:DECLARES]->(dependentMethod:Method)-[:INVOKES]->(classForName:Method)
   WHERE classForName.signature STARTS WITH 'java.lang.Class forName'
    WITH dependentArtifactName
        ,collect(DISTINCT coalesce(reflectionType.fqn, 'Class.forName')) AS reflectionTypes
        ,collect(DISTINCT dependentType.fqn)  AS reflectionCaller
        ,count(DISTINCT dependentType.fqn)    AS numberOfReflectionCaller
RETURN dependentArtifactName
      ,numberOfReflectionCaller
      ,reflectionTypes[0..19]  AS someReflectionTypes
      ,reflectionCaller[0..19] AS someDependentTypes