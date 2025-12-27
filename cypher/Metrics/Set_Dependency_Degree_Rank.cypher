// Set "dependencyDegreeRank" on all nodes containing a "dependencyDegree" property. Requires "Set_Degree.cypher".

   MATCH (dependency)
   WHERE dependency.dependencyDegree IS NOT NULL
    WITH dependency.dependencyDegree AS degree, collect(dependency) AS group
   ORDER BY degree DESC
    WITH collect({degree: degree, nodes: group}) AS groups
  UNWIND range(0, size(groups) - 1) AS rowIndex
    WITH rowIndex
        ,groups[rowIndex] AS group 
  UNWIND group.nodes AS dependency
     SET dependency.dependencyDegreeRank = rowIndex + 1
  RETURN count(*)                             AS writtenNodes
        ,max(dependency.dependencyDegreeRank) AS maxDependencyDegreeRank