// List package.json dependencies by the number they are used by all packages

 MATCH (package:NPM:Package)-[:DECLARES_DEPENDENCY]->(dependency:NPM:Dependency)
 OPTIONAL MATCH (package)-[:CONTAINS]->(:Json:Object)-[:HAS_KEY]->(:Json:Key{name:'name'})-[:HAS_VALUE]->(packageName:Json:Scalar:Value)
  WITH replace(replace(package.fileName, '/npm-package-json/', ''), '/package.json', '')
                             AS packageDirectory
      ,packageName.value     AS packageName
      ,dependency.name       AS dependencyName
      ,dependency.dependency AS dependencyVersion
RETURN dependencyName
      ,count(*)                          AS usingPackageCount
      ,count(DISTINCT dependencyVersion) AS dependencyVersionCount
      ,collect(packageName)[0..9]        AS packageNameExamples
      ,collect(dependencyVersion)[0..4]  AS dependencyVersionExamples
      ,collect(packageDirectory)[0..4]   AS packageDirectory
ORDER BY usingPackageCount DESC