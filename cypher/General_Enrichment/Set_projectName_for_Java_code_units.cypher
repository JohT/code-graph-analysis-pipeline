// Set "projectName" property on Java Package and Type nodes contained in an Artifact.

MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
WHERE (codeUnit:Java:Package OR codeUnit:Java:Type)
  AND artifact.name IS NOT NULL
  AND codeUnit.projectName IS NULL // Don't override an already existing "projectName" property
  SET codeUnit.projectName = artifact.name
RETURN count(*) AS updatedCodeUnits
