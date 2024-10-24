// Link npm dependencies to the npm package that describe them if it exists

MATCH (npm_dependency:NPM:Dependency)
MATCH (npm_package:NPM:Package)
WHERE  npm_package.name = npm_dependency.name
  AND  npm_package     <> npm_dependency
 CALL { WITH npm_package, npm_dependency
       MERGE (npm_dependency)-[:IS_DESCRIBED_IN_NPM_PACKAGE]->(npm_package)
      } IN TRANSACTIONS
RETURN count(*)                       AS numberOfWrittenRelationships
      ,count(DISTINCT npm_dependency) AS numberOfDistinctNpmDependencies
      ,count(DISTINCT npm_package)    AS numberOfDistinctNpmPackages
// Debugging
// RETURN npm_dependency, npm_package
// LIMIT 1