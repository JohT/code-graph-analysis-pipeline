// Set "rootProjectName" and some local path properties for Typescript modules

 MATCH (module:TS:Module)
  WITH *, ltrim(module.localFqn, '.')                              AS trimmedLocalFqn
  WITH *, split(module.globalFqn, trimmedLocalFqn)[0]              AS rootPath
  WITH *, reverse(split(reverse(rootPath), reverse('source/'))[0]) AS localProjectPath
  WITH *, localProjectPath + trimmedLocalFqn                       AS localModulePath
  WITH *, split(localProjectPath, '/')[0]                          AS rootProjectName
  WITH *, split(split(trimmedLocalFqn, '/' + module.moduleName)[0], '/src')[0] AS trimmedLocalFqnWithoutModuleAndSourceFolder
  WITH *, localProjectPath + trimmedLocalFqnWithoutModuleAndSourceFolder       AS localModuleDir
   SET module.localProjectPath = localProjectPath
      ,module.localModulePath  = localModulePath
      ,module.localModuleDir   = localModuleDir
      ,module.rootProjectName  = rootProjectName
RETURN count(DISTINCT localProjectPath) AS identifiedLocalProjectPaths
// Debugging
// RETURN rootPath
//       ,localProjectPath
//       ,rootProjectName
//       ,count(*)
//       ,collect(DISTINCT localModulePath)[0..4] AS exampleLocalModulePath
//       ,collect(DISTINCT localModuleDir) [0..4] AS exampleLocalModuleDir
//       ,collect(DISTINCT module.localFqn)[0..4] AS exampleModuleLocalFqn
//       ,collect(DISTINCT trimmedLocalFqn)[0..4] AS exampleTrimmedModuleLocalFqn