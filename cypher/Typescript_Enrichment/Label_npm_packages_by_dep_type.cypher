// Label NPM packages as NpmDevPackage or NpmNonDevPackage based on incoming DEPENDS_ON. Requires Link_npm_packages_with_depends_on_relationships.cypher
// For each package node, calculate the maximum `weightByDependencyType` across incoming
// `DEPENDS_ON` relationships. If the max is 1 -> label `NpmDevPackage`; if > 1 -> label
// `NpmNonDevPackage`. If the property is missing or < 1 then no label is added.
// weightByDependencyType= 1 is a dev dependency, 2 is a regular dependency, and 3 is a peer dependency.

MATCH (packageNode:NPM:Package)
OPTIONAL MATCH (packageNode)<-[dependsOnRel:DEPENDS_ON]-()
WITH packageNode, max(dependsOnRel.weightByDependencyType) AS maxWeight

CALL {
  WITH packageNode, maxWeight
  FOREACH (_ IN CASE WHEN maxWeight = 1 THEN [1] ELSE [] END |
    SET packageNode:NpmDevPackage
  )
  
  FOREACH (_ IN CASE WHEN maxWeight > 1 THEN [1] ELSE [] END |
    SET packageNode:NpmNonDevPackage
  )
} IN TRANSACTIONS OF 1000 ROWS

RETURN count(packageNode) AS evaluatedPackages,
       sum(CASE WHEN maxWeight = 1 THEN 1 ELSE 0 END) AS numberOfNpmDevPackages,
       sum(CASE WHEN maxWeight > 1 THEN 1 ELSE 0 END) AS numberOfNpmNonDevPackages,
       sum(CASE WHEN maxWeight IS NULL THEN 1 ELSE 0 END) AS numberOfPackagesWithMissingWeight,
       sum(CASE WHEN maxWeight < 1 AND maxWeight IS NOT NULL THEN 1 ELSE 0 END) AS numberOfPackagesWithWeightBelowOne