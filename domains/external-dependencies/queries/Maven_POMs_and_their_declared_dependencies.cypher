// Maven POMs and their declared dependencies

 MATCH (pom:Pom)-[r1:DECLARES_DEPENDENCY]->(dependency:Dependency)-[r2:TO_ARTIFACT]->(dependentArtifact) 
RETURN pom.artifactId, pom.name, coalesce(dependency.scope, 'default') as scope, dependency.optional, dependentArtifact.group, dependentArtifact.name
 ORDER BY pom.artifactId