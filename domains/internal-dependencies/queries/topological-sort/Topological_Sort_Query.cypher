// Topological Sort to query the properties topologicalSortIndex (e.g. build order) and maxDistanceFromSource (build level) for each code unit node in topologicalSortIndex order. Requires "Add_file_name and_extension.cypher".
// Needs graph-data-science plugin version >= 2.5.0

MATCH (codeUnit)
 WHERE codeUnit.maxDistanceFromSource IS NOT NULL
   AND codeUnit.topologicalSortIndex  IS NOT NULL
   AND $dependencies_projection_node  IN LABELS(codeUnit) 
  WITH collect(codeUnit)                   AS codeUnits
      ,max(codeUnit.maxDistanceFromSource) AS overallMaxDistanceFromSource
UNWIND codeUnits AS codeUnit
RETURN coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.name)                          AS codeUnitName
      ,codeUnit.name                                                                     AS shortName
      ,codeUnit.topologicalSortIndex                                                     AS topologicalSortIndex
      ,codeUnit.maxDistanceFromSource                                                    AS maxDistanceFromSource
      ,overallMaxDistanceFromSource
      ,codeUnit.incomingDependencies                                                     AS incomingDependencies
      ,codeUnit.outgoingDependencies                                                     AS outgoingDependencies
ORDER BY codeUnit.topologicalSortIndex