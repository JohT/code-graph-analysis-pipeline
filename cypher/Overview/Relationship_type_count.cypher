// Relationship count for each type separate. Sums up to the total number of relationships (100%).

 MATCH ()-[allRelationships]-()
  WITH COUNT(DISTINCT allRelationships) AS totalRelationshipCount
 MATCH ()-[relationshipsAndTheirTypes]-()
  WITH totalRelationshipCount
      ,type(relationshipsAndTheirTypes)                AS relationshipType
      ,count(DISTINCT relationshipsAndTheirTypes)      AS nodesWithThatRelationshipType
      ,toFloat(
          count(DISTINCT relationshipsAndTheirTypes)) 
        / totalRelationshipCount * 100.0               AS nodesWithThatRelationshipTypePercent
RETURN relationshipType
      ,nodesWithThatRelationshipType
      ,nodesWithThatRelationshipTypePercent
ORDER BY nodesWithThatRelationshipType DESC, relationshipType ASC