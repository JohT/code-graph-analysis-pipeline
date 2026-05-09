// Create DEPENDS_ON relationships between StronglyConnectedComponent nodes. Requires "ArchetypeFeature-StronglyConnectedComponents-CreateNode.cypher".

   MATCH (sourceCodeUnit)-[codeUnitDependency:DEPENDS_ON]->(targetCodeUnit)
   WHERE $projection_node_label IN labels(sourceCodeUnit)
     AND $projection_node_label IN labels(targetCodeUnit)
   MATCH (sourceCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(sourceComponent:StronglyConnectedComponent)
   MATCH (targetCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(targetComponent:StronglyConnectedComponent)
   WHERE sourceComponent <> targetComponent
    WITH sourceComponent
        ,targetComponent
        ,codeUnitDependency.weight AS weight
        ,CASE WHEN $projection_weight_property = 'weight'                  THEN 0
              WHEN $projection_weight_property IN keys(codeUnitDependency) THEN codeUnitDependency[$projection_weight_property]
              ELSE 0
         END AS weightSelected
    WITH sourceComponent
        ,targetComponent
        ,count(*)            AS weightCount
        ,sum(weight)         AS weight
        ,sum(weightSelected) AS weightSelected
// For debugging purposes
  // RETURN sourceComponent.name + '-' + sourceComponent.id AS sourceComponentNameId
  //       ,targetComponent.name + '-' + targetComponent.id AS targetComponentNameId
  //       ,weightCount
  //       ,weight
  //       ,weightSelected
  //       ,count(*) AS occurs
  // ORDER BY occurs DESC, sourceComponentNameId, targetComponentNameId
  // LIMIT 50
   MERGE (sourceComponent)-[componentDependency:DEPENDS_ON]->(targetComponent)
     SET componentDependency.weightCount                  = weightCount
        ,componentDependency.weight                       = weight
FOREACH (_ IN [sign(weightSelected)] |
    SET componentDependency[$projection_weight_property] = weightSelected)