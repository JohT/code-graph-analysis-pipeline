// List package.json dependencies by package

 MATCH (package:NPM:Package)-[:DECLARES_DEPENDENCY]->(dependency:NPM:Dependency)
 OPTIONAL MATCH (package)-[:CONTAINS]->(:Json:Object)-[:HAS_KEY]->(:Json:Key{name:'name'})-[:HAS_VALUE]->(packageName:Json:Scalar:Value)
RETURN replace(replace(package.fileName, '/npm-package-json/', ''), '/package.json', '')
                             AS packageDirectory
      ,packageName.value     AS packageName
      ,dependency.name       AS dependencyName
      ,dependency.dependency AS dependencyVersion
ORDER BY packageName, dependencyName