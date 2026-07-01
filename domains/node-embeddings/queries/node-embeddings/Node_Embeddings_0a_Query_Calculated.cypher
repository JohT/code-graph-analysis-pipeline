// Query already calculated and written node embeddings on nodes with label in parameter $dependencies_projection_node including a communityId and centrality. Variables: dependencies_projection_node, dependencies_projection_write_property. Requires "Add_file_name_and_extension.cypher".

 MATCH (codeUnit)
 WHERE $dependencies_projection_node IN LABELS(codeUnit)
   AND codeUnit[$dependencies_projection_write_property] IS NOT NULL
   // AND codeUnit.notExistingToForceRecalculation IS NOT NULL // uncomment this line to force recalculation
 RETURN DISTINCT 
        coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
       ,codeUnit.name                AS shortCodeUnitName
       ,coalesce(codeUnit.projectName, '')                                                               AS projectName
       ,coalesce(codeUnit.communityLeidenId, 0)           AS communityId
       ,coalesce(codeUnit.centralityPageRank, 0.01)       AS centrality
       ,codeUnit[$dependencies_projection_write_property] AS embedding
  ORDER BY communityId