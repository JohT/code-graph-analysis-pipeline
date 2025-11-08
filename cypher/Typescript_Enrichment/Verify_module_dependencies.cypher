// Verify that there are either no Typescript modules at all or that there is at least one module dependency.

MATCH (source:TS:Module)
OPTIONAL MATCH (source)-[moduleDependency:DEPENDS_ON2]->(:TS:Module)
 WITH count(DISTINCT source)  AS moduleCount
     ,count(moduleDependency) AS moduleDependencyCount
 WITH *, ((moduleCount = 0) OR (moduleDependencyCount > 0)) AS valid
RETURN moduleCount            AS typescriptModuleCount
      ,moduleDependencyCount  AS typescriptModuleDependencyCount
      ,toInteger(valid)       AS typescriptModuleDependenciesValid