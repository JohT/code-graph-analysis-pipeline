// Set "projectName" property on TypeScript Module nodes using the containing Project name. Requires "Add_name_to_property_on_projects.cypher".

MATCH (proj:TS:Project)-[:CONTAINS]->(module:TS:Module)
WHERE proj.name IS NOT NULL
  AND module.projectName IS NULL // Don't override an already existing "projectName" property
  SET module.projectName = proj.name
RETURN count(*) AS updatedModules
