
// Set "localProjectPath", "localProjectPath" and "localModulePath" on Typescript Module nodes

 MATCH (module:TS:Module)
  WITH *, ltrim(module.localFqn, '.')                              AS trimmedLocalFqn
  WITH *, split(module.globalFqn, trimmedLocalFqn)[0]              AS rootPath
  WITH *, reverse(split(reverse(rootPath), reverse('source/'))[0]) AS localProjectPath
  WITH *, split(localProjectPath, '/')[0]                          AS rootProjectName
   SET module.localProjectPath = localProjectPath
      ,module.rootProjectName  = rootProjectName
      ,module.localModulePath  = localProjectPath + trimmedLocalFqn
RETURN count(DISTINCT localProjectPath) AS identifiedLocalProjectPaths
// Debugging
//RETURN rootPath
//      ,localProjectPath
//      ,count(*)
//      ,collect(DISTINCT module.localFqn)[0..2] AS exampleModuleLocalFqn
//      ,collect(DISTINCT trimmedLocalFqn)[0..2] AS exampleTrimmedModuleLocalFqn