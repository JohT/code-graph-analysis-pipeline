// Writes batch data back into the database for code units when working with a dependencies projection. Variables: dependencies_projection_rows, dependencies_projection_node

UNWIND $dependencies_projection_rows AS row
MATCH (codeUnit)
WHERE elementId(codeUnit) = row.nodeId
  AND $dependencies_projection_node IN labels(codeUnit) 
  SET codeUnit += row.properties