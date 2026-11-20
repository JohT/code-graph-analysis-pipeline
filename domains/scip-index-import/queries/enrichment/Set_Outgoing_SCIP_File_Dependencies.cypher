// Set outgoing SCIP file dependencies aggregated from symbol-level DEPENDS_ON relationships. Requires "Create_SCIP_File_Nodes.cypher".
// outgoingDependencies = COUNT of symbol-level edges from symbols (types and functions) in this file.
// outgoingDependenciesWeight = SUM of referenceCount (magnitude of those edges).
// outgoingDependentModules = COUNT DISTINCT of modules that contain symbols depended on by this file's symbols.
// outgoingDependentArtifacts = COUNT DISTINCT of artifacts that contain symbols depended on by this file's symbols.

   MATCH (sourceFile:SCIP:File:SemanticCodeIndexInternalFile)
OPTIONAL MATCH (sourceFile)<-[:SOURCE_FILE]-(it:SCIP:SemanticCodeIndexInternalSymbol)-[symbolDependency:DEPENDS_ON]->(targetSymbol:SCIP:SemanticCodeIndexInternalSymbol)-[:SOURCE_FILE]->(targetFile:SCIP:File:SemanticCodeIndexInternalFile)
OPTIONAL MATCH (targetSymbol)<-[:CONTAINS]-(targetModule:SCIP:SemanticCodeIndexModule)<-[:CONTAINS]-(targetArtifact:SCIP:SemanticCodeIndexArtifact)
   WHERE sourceFile <> targetFile
    WITH sourceFile
        ,count(symbolDependency)              AS outgoingDependencies
        ,sum(symbolDependency.referenceCount) AS outgoingDependenciesWeight
        ,count(DISTINCT targetSymbol)         AS distinctTargetSymbols
        ,count(DISTINCT targetModule)         AS distinctTargetModules
        ,count(DISTINCT targetArtifact)       AS distinctTargetArtifacts
     SET sourceFile.outgoingDependencies        = outgoingDependencies
        ,sourceFile.outgoingDependenciesWeight  = outgoingDependenciesWeight
        ,sourceFile.outgoingDependentModules    = distinctTargetModules
        ,sourceFile.outgoingDependentArtifacts  = distinctTargetArtifacts
  RETURN sourceFile.relativePath AS file
        ,outgoingDependencies
        ,outgoingDependenciesWeight
        ,distinctTargetSymbols
        ,distinctTargetModules
        ,distinctTargetArtifacts
