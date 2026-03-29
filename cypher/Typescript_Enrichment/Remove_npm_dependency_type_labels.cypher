// Remove NPM package type labels (idempotent).
   
 MATCH (packageNode:NPM:Package)
REMOVE packageNode:NpmDevPackage
REMOVE packageNode:NpmNonDevPackage
