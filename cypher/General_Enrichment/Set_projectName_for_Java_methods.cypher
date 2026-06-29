// Set "projectName" property on Java Method nodes by inheriting it from their declaring Type. Requires "Set_projectName_for_Java_code_units.cypher".

MATCH (type:Java:Type)-[:DECLARES]->(method:Java:Method)
WHERE type.projectName IS NOT NULL
  AND method.projectName IS NULL // Don't override an already existing "projectName" property
  SET method.projectName = type.projectName
RETURN count(*) AS updatedMethods
