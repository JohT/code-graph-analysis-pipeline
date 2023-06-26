// Create a DEPENDS_ON relationship for every DEPENDS_ON_ARTIFACT

MATCH (a:Artifact)-[existing:DEPENDS_ON_ARTIFACT]->(b:Artifact)
MERGE (a)-[created:DEPENDS_ON]->(b)
 WITH count(existing) as numberOfExistingRelations
     ,count(created)  as numberOfCreatedRelations
RETURN numberOfExistingRelations, numberOfCreatedRelations