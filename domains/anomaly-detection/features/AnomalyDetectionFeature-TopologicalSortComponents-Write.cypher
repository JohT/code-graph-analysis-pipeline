// Topological Sort to write the property "topologicalSortMaxDistanceFromSource" (e.g. build order) for strongly connected components into the graph. Requires "AnomalyDetectionFeature-TopologicalSortComponents-Projection".
// Needs graph-data-science plugin version >= 2.5.0

CALL gds.dag.topologicalSort.stream(
 $projection_name + '-components', {
    computeMaxDistanceFromSource: true
}) YIELD nodeId, maxDistanceFromSource
   WITH nodeId
       ,gds.util.asNode(nodeId)           AS component
       ,toInteger(maxDistanceFromSource)  AS maxDistanceFromSource
    SET component.topologicalSortMaxDistanceFromSource = maxDistanceFromSource
   WITH maxDistanceFromSource, count(*) AS occurrences
 RETURN maxDistanceFromSource, occurrences
 ORDER BY maxDistanceFromSource