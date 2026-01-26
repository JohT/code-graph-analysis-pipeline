// Create nodes for strongly connected components and connect them to their members. Requires "AnomalyDetectionFeature-StronglyConnectedComponents-CreateNode".

   MATCH (sourceCodeUnit)-[codeUnitDependency:DEPENDS_ON]->(targetCodeUnit)
   WHERE $projection_node_label IN labels(sourceCodeUnit)
     AND $projection_node_label IN labels(targetCodeUnit)
   MATCH (sourceCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(sourceComponent:StronglyConnectedComponent)
   MATCH (targetCodeUnit)-[:IN_STRONGLY_CONNECTED_COMPONENT]->(targetComponent:StronglyConnectedComponent)
   WHERE sourceComponent <> targetComponent
    WITH sourceComponent
        ,targetComponent
        ,count(*)                                             AS weightCount
        ,sum(codeUnitDependency.weight)                       AS weight
        ,CASE $projection_weight_property 
              WHEN '' THEN sum(codeUnitDependency.weight)
              ELSE         sum(codeUnitDependency[$projection_weight_property]) 
         END AS weightSelected
// For debugging purposes
  // RETURN sourceComponent.name + '-' + sourceComponent.id AS sourceComponentNameId
  //       ,targetComponent.name + '-' + targetComponent.id AS targetComponentNameId
  //       ,weightCount
  //       ,weight
  //       ,weightSelected
  //       ,count(*) AS occurs
  // LIMIT 50
  // ORDER BY occurs DESC, sourceComponentNameId, targetComponentNameId
   MERGE (sourceComponent)-[componentDependency:DEPENDS_ON]->(targetComponent)
    SET componentDependency.weightCount                  = weightCount
       ,componentDependency.weight                       = weight
       ,componentDependency[$projection_weight_property] = weightSelected