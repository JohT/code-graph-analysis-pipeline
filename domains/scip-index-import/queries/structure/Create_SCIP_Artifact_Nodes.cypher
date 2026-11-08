// Create SemanticCodeIndexArtifact nodes from unique module, version, and packageManager combinations on SemanticCodeIndexInternalType, SemanticCodeIndexExternalType, and SemanticCodeIndexFunction nodes. Requires "Import_SCIP_Type_Internal_Nodes.cypher", "Import_SCIP_Type_External_Nodes.cypher", and "Import_SCIP_Function_Nodes.cypher".

MATCH (t:SemanticCodeIndexInternalType|SemanticCodeIndexExternalType|SemanticCodeIndexFunction)
 WITH DISTINCT t.module         AS module
             ,t.version         AS version
             ,t.packageManager  AS packageManager
             ,t.packageId       AS packageId
  WITH module
     ,version
     ,packageManager
     ,packageId
     ,split(split(module, '/')[-1], '#')[0] AS shortName
MERGE (a:SCIP:SemanticCodeIndexArtifact {fqn: module + ' ' + version})
  SET a.name           = shortName
     ,a.fullName       = module
     ,a.version        = version
     ,a.packageManager = packageManager
     ,a.fileName       = packageId
RETURN count(*) AS writtenNodes
