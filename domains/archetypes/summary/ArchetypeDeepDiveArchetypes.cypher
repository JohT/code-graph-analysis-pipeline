// Archetypes DeepDive: Summarizes all labelled archetypes including examples. Requires all other labels/*.cypher queries to run first. Variables: projection_node_label

 MATCH (codeUnit)
 WHERE $projection_node_label IN labels(codeUnit)
UNWIND keys(codeUnit) AS codeUnitProperty
  WITH *
 WHERE codeUnitProperty STARTS WITH 'archetype'
   AND codeUnitProperty ENDS   WITH 'Rank'
  WITH *
      ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
      ,split(split(codeUnitProperty, 'archetype')[1], 'Rank')[0] AS archetype             
      ,codeUnit[codeUnitProperty]                                AS archetypeRank
  WITH *, collect(archetype)[0] AS archetype
 ORDER BY archetypeRank ASC, codeUnitName ASC, archetype ASC
  WITH archetype
      ,archetypeRank
      ,codeUnitName
RETURN archetype                               AS `Archetype`
      ,count(DISTINCT codeUnitName)            AS `Count`
      ,max(archetypeRank)                      AS `Max. Rank` 
      ,apoc.text.join(collect(DISTINCT codeUnitName)[0..3], ', ')    AS `Examples`
ORDER BY archetype, `Max. Rank` ASC
