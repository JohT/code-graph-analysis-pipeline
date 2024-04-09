// Explore Typescript Projects

MATCH (project:TS:Project)-[:HAS_ROOT]->(dir:Directory)-[:CONTAINS]->(module:Module)
OPTIONAL MATCH (project)<-[:REFERENCED_PROJECTS*]-(top:TS:Project)
RETURN project, dir, module, top