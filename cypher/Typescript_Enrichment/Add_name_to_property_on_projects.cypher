// Set name property on Typescript project nodes

 MATCH (project:TS:Project)-[:HAS_ROOT]->(root:Directory)
  WITH  project
       ,reverse(split(reverse(root.absoluteFileName), '/')[0]) AS projectName
   SET  project.name = projectName
RETURN count(*) AS numberOfNamesProjects