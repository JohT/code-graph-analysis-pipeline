// Explore non null node property counts for the selected node label. Variables: projection_node_label

  MATCH (selectedNode)
  WHERE $projection_node_label IN labels(selectedNode)
   WITH *, keys(selectedNode) AS nodeProperties
 UNWIND nodeProperties    AS nodeProperty
   WITH *
 ORDER BY nodeProperty
  WHERE selectedNode[nodeProperty] IS NOT NULL
   WITH  nodeProperty, count(*) AS nonNullCount
// RETURN nodeProperty, nonNullCount 
// ORDER BY nodeProperty, nonNullCount
 RETURN nonNullCount
       ,count(DISTINCT nodeProperty) AS propertyCount
       ,collect(nodeProperty)        AS properties
ORDER BY nonNullCount DESC