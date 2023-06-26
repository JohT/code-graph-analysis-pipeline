// Create a DEPENDS_ON relationship for every DEPENDS_ON_PACKAGE

MATCH (a:Package)-[existing:DEPENDS_ON_PACKAGE]->(b:Package)
MERGE (a)-[created:DEPENDS_ON]->(b)
 WITH count(existing) as numberOfExistingRelations
     ,count(created)  as numberOfCreatedRelations
RETURN numberOfExistingRelations, numberOfCreatedRelations