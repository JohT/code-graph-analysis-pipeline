// Link ExternalModule nodes to their corresponding NPM Dependency if available

 MATCH (external_module:TS:ExternalModule{isNodeModule:true})
  WITH count(external_module)   AS totalNumberOfExternalModules
      ,collect(external_module) AS external_modules
UNWIND external_modules         AS external_module 
 MATCH (external_module)<-[:USES]-(project:TS:Project)
 MATCH (project)-[:HAS_NPM_PACKAGE]->(npm_package:NPM:Package)-[npm_dependency_relation]->(npm_dependency:NPM:Dependency)
 WHERE external_module.globalFqn CONTAINS ('/node_modules/' + npm_dependency.name)
 CALL {  WITH npm_dependency, external_module
        MERGE (external_module)-[:PROVIDED_BY_NPM_DEPENDENCY]->(npm_dependency)
          SET external_module.npmPackage        = npm_dependency.name
             ,external_module.npmPackageVersion = npm_dependency.dependency
      } IN TRANSACTIONS
RETURN totalNumberOfExternalModules
      ,count(DISTINCT external_module.globalFqn) AS numberOfLinkedExternalModules
      ,count(DISTINCT project.name)              AS numberOfProjects
//Debugging
//RETURN totalNumberOfExternalModules, project.name, npm_dependency.name, external_module.globalFqn
//LIMIT 40