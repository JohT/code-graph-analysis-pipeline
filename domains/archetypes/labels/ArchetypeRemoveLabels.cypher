// Archetypes Labels: Reset/Remove all archetype marker labels and their rank properties. Intended to be used before setting them for a clean state.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
  REMOVE codeUnit:Mark4TopArchetypeAuthority
  REMOVE codeUnit:Mark4TopArchetypeBottleneck
  REMOVE codeUnit:Mark4TopArchetypeHub
    WITH codeUnit
   WHERE codeUnit.archetypeAuthorityRank  IS NOT NULL
      OR codeUnit.archetypeBottleneckRank IS NOT NULL
      OR codeUnit.archetypeHubRank        IS NOT NULL
  REMOVE codeUnit.archetypeAuthorityRank
  REMOVE codeUnit.archetypeBottleneckRank
  REMOVE codeUnit.archetypeHubRank
