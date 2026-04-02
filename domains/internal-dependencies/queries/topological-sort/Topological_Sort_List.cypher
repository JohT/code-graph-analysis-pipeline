// Topological Sort to list the properties topologicalSortIndex (e.g. build order) and maxDistanceFromSource (build level) for each code unit node.
// Needs graph-data-science plugin version >= 2.5.0

CALL gds.dag.topologicalSort.stream(
 $dependencies_projection + '-cleaned', {
    computeMaxDistanceFromSource: true
}) YIELD nodeId, maxDistanceFromSource
   WITH nodeId
       ,gds.util.asNode(nodeId)          AS codeUnit
       ,toInteger(maxDistanceFromSource) AS maxDistanceFromSource
    SET codeUnit.maxDistanceFromSource = maxDistanceFromSource
   WITH collect(nodeId)                  AS sortedNodeIds
       ,collect({codeUnit: codeUnit, maxDistanceFromSource: maxDistanceFromSource}) AS topologicalSortedCodeUnits
       ,max(maxDistanceFromSource)       AS overallMaxDistance
FOREACH (i IN range(0, SIZE(sortedNodeIds)-1) | 
    SET gds.util.asNode(sortedNodeIds[i]).topologicalSortIndex = i)
   WITH topologicalSortedCodeUnits
       ,overallMaxDistance
 UNWIND topologicalSortedCodeUnits       AS sorted
 RETURN coalesce(sorted.codeUnit.fqn, sorted.codeUnit.fileName, sorted.codeUnit.name) AS codeUnitName
       ,sorted.codeUnit.maxDistanceFromSource                                         AS maxDistanceFromSource
       ,overallMaxDistance                                                            AS overallNumberOfBuildLevels