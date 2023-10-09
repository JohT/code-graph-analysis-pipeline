// Centrality 9d Hyperlink-Induced Topic Search (HITS) Stream Mutated

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
RETURN DISTINCT coalesce(codeUnit.fqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
     ,coalesce(codeUnit.name, replace(last(split(codeUnit.fileName, '/')), '.jar', ''))      AS shortCodeUnitName
     ,values[0] AS centralityHyperlinkInducedTopicSearchAuthority
     ,values[1] AS centralityHyperlinkInducedTopicSearchHub
     ,codeUnit.incomingDependencies AS incomingDependencies
     ,codeUnit.outgoingDependencies AS outgoingDependencies
ORDER BY centralityHyperlinkInducedTopicSearchAuthority DESCENDING, codeUnitName ASCENDING