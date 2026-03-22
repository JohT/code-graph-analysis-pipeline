// Enrich NPM:Package nodes with incoming and outgoing dependency counts
// Requires Link_npm_packages_with_depends_on_relationships.cypher

MATCH (package:NPM:Package)
WITH package,
     // Private packages often contain test and example code. They will be left out of the main dependency graph analysis.
     CASE WHEN package.private = true OR package.private = "true" THEN 1 ELSE 0 END AS testMarkerInteger,
     COUNT {(package)<-[:DEPENDS_ON]-(:NPM:Package)}  AS incomingDependencies,
     COUNT {(package)-[:DEPENDS_ON]->(:NPM:Package)}  AS outgoingDependencies
SET  package.incomingDependencies = incomingDependencies,
     package.outgoingDependencies = outgoingDependencies,
     package.testMarkerInteger    = testMarkerInteger
RETURN count(DISTINCT package)        AS numberOfPackagesEnriched
      ,sum(incomingDependencies)      AS totalIncomingDependencies
      ,sum(outgoingDependencies)      AS totalOutgoingDependencies
      ,avg(incomingDependencies)      AS averageIncomingDependencies
      ,avg(outgoingDependencies)      AS averageOutgoingDependencies
// Debugging
// RETURN package.name, package.incomingDependencies, package.outgoingDependencies
// LIMIT 20
