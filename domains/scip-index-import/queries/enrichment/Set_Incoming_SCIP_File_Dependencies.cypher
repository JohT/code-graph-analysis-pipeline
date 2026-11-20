// Set incoming SCIP file dependencies aggregated from symbol-level DEPENDS_ON relationships. Requires "Create_SCIP_File_Nodes.cypher".
// incomingDependencies = COUNT of symbol-level edges into symbols (types and functions) in this file.
// incomingDependenciesWeight = SUM of referenceCount (magnitude of those edges).
// incomingDependentModules = COUNT DISTINCT of modules that have symbols depending on this file's symbols.
// incomingDependentArtifacts = COUNT DISTINCT of artifacts that contain symbols depending on this file's symbols.

   MATCH (sourceFile:SCIP:File:SemanticCodeIndexInternalFile)
OPTIONAL MATCH (sourceFile)<-[:SOURCE_FILE]-(it:SCIP:SemanticCodeIndexInternalSymbol)<-[symbolDependency:DEPENDS_ON]-(targetSymbol:SCIP:SemanticCodeIndexInternalSymbol)<-[:SOURCE_FILE]-(targetFile:SCIP:File:SemanticCodeIndexInternalFile)
OPTIONAL MATCH (targetSymbol)<-[:CONTAINS]-(targetModule:SCIP:SemanticCodeIndexModule)<-[:CONTAINS]-(targetArtifact:SCIP:SemanticCodeIndexArtifact)
   WHERE sourceFile <> targetFile
    WITH sourceFile, count(DISTINCT symbolDependency)     AS incomingDependencies
        ,sum(symbolDependency.referenceCount) AS incomingDependenciesWeight
        ,count(DISTINCT targetSymbol)         AS distinctTargetSymbols
        ,count(DISTINCT targetModule)         AS distinctTargetModules
        ,count(DISTINCT targetArtifact)       AS distinctTargetArtifacts
     SET sourceFile.incomingDependencies        = incomingDependencies
        ,sourceFile.incomingDependenciesWeight  = incomingDependenciesWeight
        ,sourceFile.incomingDependentModules    = distinctTargetModules
        ,sourceFile.incomingDependentArtifacts  = distinctTargetArtifacts
  RETURN sourceFile.relativePath AS file
        ,incomingDependencies
        ,incomingDependenciesWeight
        ,distinctTargetSymbols
        ,distinctTargetModules
        ,distinctTargetArtifacts