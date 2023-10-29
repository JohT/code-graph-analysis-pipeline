// Create filtered Type node projection without zero-degree nodes, external types, java types or duplicates. Variables: dependencies_projection. Requires 'Label_base_java_types', 'Label_buildin_java_types' and 'Label_resolved_duplicate_types' of 'Types' directory.

  MATCH (internalType:Type&!PrimitiveType&!Void&!JavaType&!ResolvedDuplicateType&!ExternalType)
 OPTIONAL MATCH (internalType)-[typeDependency:DEPENDS_ON]->(dependentType:Type&!PrimitiveType&!Void&!JavaType&!ResolvedDuplicateType&!ExternalType)
  WITH internalType
      ,typeDependency
      ,dependentType
      ,exists((internalType)<-[:DEPENDS_ON]-(:Type))   AS hasIncomingDependenciesInternal
 WHERE (hasIncomingDependenciesInternal OR dependentType IS NOT NULL)
  WITH gds.graph.project($dependencies_projection + '-cleaned', internalType, dependentType, {
         sourceNodeProperties: internalType {.incomingDependencies, .outgoingDependencies}
        ,targetNodeProperties: dependentType {.incomingDependencies, .outgoingDependencies}
        ,relationshipProperties: typeDependency {.weight}
        ,relationshipType: 'DEPENDS_ON'
      }
      ) AS projection
RETURN projection.graphName         AS graphName
      ,projection.nodeCount         AS nodeCount
      ,projection.relationshipCount AS relationshipCount
      ,projection.projectMillis     AS projectMillis