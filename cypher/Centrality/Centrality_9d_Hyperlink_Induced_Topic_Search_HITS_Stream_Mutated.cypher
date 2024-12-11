// Centrality 9d Hyperlink-Induced Topic Search (HITS) Stream Mutated. Requires "Add_file_name and_extension.cypher", "Set_localRootPath_for_modules", "Set_declaring_type_on_method_nodes".

CALL gds.graph.nodeProperties.stream(
     $dependencies_projection + '-cleaned'
    ,[
         $dependencies_projection_write_property + 'Authority'  
        ,$dependencies_projection_write_property + 'Hub'
     ]
)
YIELD nodeId, propertyValue
 WITH gds.util.asNode(nodeId) AS codeUnit
     ,collect(propertyValue)  AS values
  WITH *, coalesce(codeUnit.declaringType + ': ', '')        +
          coalesce(codeUnit.rootProjectName + '/', '') +
          coalesce(codeUnit.signature,  codeUnit.name) AS codeUnitNameWithDetails
RETURN DISTINCT coalesce(codeUnit.fqn, codeUnitNameWithDetails, codeUnit.fileName, codeUnit.name) AS codeUnitName
     ,codeUnit.name                 AS shortCodeUnitName
     ,values[0]                     AS centralityHyperlinkInducedTopicSearchAuthority
     ,values[1]                     AS centralityHyperlinkInducedTopicSearchHub
     ,codeUnit.incomingDependencies AS incomingDependencies
     ,codeUnit.outgoingDependencies AS outgoingDependencies
ORDER BY centralityHyperlinkInducedTopicSearchAuthority DESCENDING, codeUnitName ASCENDING