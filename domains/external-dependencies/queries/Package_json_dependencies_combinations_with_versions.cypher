// List most used combination of 2 and 3 dependencies including version specifier

 MATCH (package:NPM:Package)-[:DECLARES_DEPENDENCY]->(dependency:NPM:Dependency)
 OPTIONAL MATCH (package)-[:CONTAINS]->(:Json:Object)-[:HAS_KEY]->(:Json:Key{name:'name'})-[:HAS_VALUE]->(packageName:Json:Scalar:Value)
  WITH package.fileName      AS packageFileName
      ,dependency.name       AS dependencyName
      ,dependency.dependency AS dependencyVersion
 ORDER BY packageFileName, dependencyName
  WITH packageFileName
      ,apoc.coll.combinations(collect(dependencyName + ' ' + dependencyVersion), 2, 3) AS dependencyCombinations
UNWIND dependencyCombinations   AS dependencyCombination
  WITH dependencyCombination
      ,count(*) as occurrences
      ,collect(packageFileName) AS packages
 WHERE occurrences > 1
RETURN dependencyCombination
      ,occurrences
      ,packages[0..9] AS firstTenPackages
ORDER BY occurrences DESC