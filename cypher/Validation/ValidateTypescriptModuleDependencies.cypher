// Check if there is at least one Typescript Module dependency.

 MATCH (source:TS:Module)-[dependency:DEPENDS_ON]->(target:TS:Module)
RETURN elementId(source) AS sourceElementId
 LIMIT 1