// Link Typescript projects to npm packages

MATCH (npmPackage:NPM:Package)
 WITH  npmPackage
// Remove the first ("/npm-package-json/")" and the last part ("/package.json")
// of the file name to get the actual relative path to the directory 
// that contains the package.json file
      ,replace(
            replace(npmPackage.fileName, '/' + split(npmPackage.fileName, '/')[1], '')
          , '/package.json'
          , ''
          ) AS relativeNpmPackageDirectory
 MATCH (project:TS:Project)-[:HAS_ROOT]->(projectRoot:Directory)
 WHERE projectRoot.absoluteFileName ENDS WITH relativeNpmPackageDirectory
  WITH npmPackage
      ,relativeNpmPackageDirectory
      ,collect(DISTINCT project) AS projects
      ,collect(DISTINCT projectRoot) AS projectRoots
// Assure that the found connection is unique and not ambiguous 
 WHERE size(projects)     = 1
   AND size(projectRoots) = 1
 UNWIND projects AS project
// Create a HAS_NPM_PACKAGE relationship between the Typescript project and the npm package
 MERGE (project)-[:HAS_NPM_PACKAGE]->(npmPackage)
// Set the "relativeFileDirectory" on the npm package to the relative directory 
// that contains the package.json file 
   SET npmPackage.relativeFileDirectory = relativeNpmPackageDirectory
 RETURN count(*) AS numberOfCreatedNpmPackageRelationships
// Detailed results for debugging
//RETURN npmPackage.fileName              AS npmPackageFileName
//      ,projectRoots[0].absoluteFileName AS projectRootDirectory
//      ,relativeNpmPackageDirectory