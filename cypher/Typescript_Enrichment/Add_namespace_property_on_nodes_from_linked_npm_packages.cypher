// Add namespace property to Typescript nodes if a npm a package is linked. Requires Link_projects_to_npm_packages.

MATCH (element:TS)<-[:CONTAINS]-(project:TS:Project)-[:HAS_NPM_PACKAGE]->(package:NPM:Package)
WHERE  element.globalFqn IS NOT NULL
 WITH *
     ,coalesce(nullif(split(package.name, '/')[0], package.name), '') AS npmPackageNamespace
     ,coalesce(split(package.name, '/')[1], package.name)             AS packageName 
  SET  element.namespace   = coalesce(nullif(element.namespace,   ''),  npmPackageNamespace)
  SET  element.packageName = coalesce(nullif(element.packageName, ''),  packageName)
RETURN labels(element)[0..4] AS nodeLabels, count(*) AS numberOfWrittenNamespaceProperties
// Debugging
//RETURN element.globalFqn, element.moduleName, element.namespace
//      ,package.name, package.fileName
//      ,npmPackageNamespace
//      ,packageName
//LIMIT 10