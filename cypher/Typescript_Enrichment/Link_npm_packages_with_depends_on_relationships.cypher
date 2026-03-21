// Link npm packages with DEPENDS_ON relationships. Requires Link_npm_dependencies_to_npm_packages.
// This creates direct package-to-package dependencies by following the chain:
// (source:NPM:Package)-[dependency_relationship]->(NPM:Dependency)-[:IS_DESCRIBED_IN_NPM_PACKAGE]->(target:NPM:Package)

MATCH (source:NPM:Package)-[dependency_relationship]->(npm_dependency:NPM:Dependency)
MATCH (npm_dependency)-[:IS_DESCRIBED_IN_NPM_PACKAGE]->(target:NPM:Package)
WHERE  source     <> target
  AND  source.name IS NOT NULL
  AND  target.name IS NOT NULL
WITH source
      ,target 
      ,
      // Weight peer dependencies as 3, regular dependencies as 2, and dev dependencies as 1.
      // The highest weight is used when multiple dependency types exist for the same package pair.
      max(CASE 
        WHEN dependency_relationship:DECLARES_PEER_DEPENDENCY THEN 3
        WHEN dependency_relationship:DECLARES_DEPENDENCY      THEN 2
        WHEN dependency_relationship:DECLARES_DEV_DEPENDENCY  THEN 1
        ELSE 1
      END) AS weightByDependencyType
 CALL { WITH source, target, weightByDependencyType
       MERGE (source)-[dependsOnRelationship:DEPENDS_ON]->(target)
         SET dependsOnRelationship.weightByDependencyType = weightByDependencyType
      } IN TRANSACTIONS
RETURN count(*)                          AS numberOfWrittenRelationships
      ,count(DISTINCT source)            AS numberOfDistinctSourcePackages
      ,count(DISTINCT target)            AS numberOfDistinctTargetPackages
// Debugging
// RETURN source.name, target.name, weightByDependencyType
// LIMIT 10
