// [DEPRECATED] This query mixed relationship creation with property updates inefficiently.
// Use instead: 
//   1. Link_SCIP_Module_DEPENDS_ON_SCIP_Module.cypher - creates relationships
//   2. Set_Incoming_SCIP_Module_Dependencies.cypher - sets incoming counts
//   3. Set_Outgoing_SCIP_Module_Dependencies.cypher - sets outgoing counts
// Also added for artifacts:
//   1. Link_SCIP_Artifact_DEPENDS_ON_SCIP_Artifact.cypher - creates artifact relationships
//   2. Set_Incoming_SCIP_Artifact_Dependencies.cypher - sets incoming counts
//   3. Set_Outgoing_SCIP_Artifact_Dependencies.cypher - sets outgoing counts
// For complete enrichment context see: importScipIndexData.sh
//
// Original query (kept for reference):
//
// Link SemanticCodeIndexModules nodes to the containSemanticCodeIndexModules modules they depend via DEPENDS_ON. Requires "Create_SCIP_Module_Nodes_For_Internal_Types.cypher", "Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher" and "Import_SCIP_Type_Internal_Nodes.cypher".