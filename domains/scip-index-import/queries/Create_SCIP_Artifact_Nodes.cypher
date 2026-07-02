// Create SCIPArtifact nodes from unique module, version, and packageManager combinations on SCIPType nodes. Requires "Import_SCIP_Type_Internal_Nodes.cypher" and "Import_SCIP_Type_External_Nodes.cypher".

MATCH (t:SCIPType)
 WITH DISTINCT t.module         AS module
             ,t.version         AS version
             ,t.packageManager  AS packageManager
             ,t.packageId       AS packageId
MERGE (a:SCIP:SCIPArtifact {fqn: module + ' ' + version})
  SET a.name           = module
     ,a.version        = version
     ,a.packageManager = packageManager
     ,a.fileName       = packageId
RETURN count(*) AS writtenNodes
