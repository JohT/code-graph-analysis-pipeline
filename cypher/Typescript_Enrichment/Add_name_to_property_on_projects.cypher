// Set name property on Typescript project nodes

 MATCH (project:TS:Project)-[:HAS_ROOT]->(root:Directory)
OPTIONAL MATCH (project)-[:HAS_CONFIG]->(config:File)<-[:CONTAINS]-(config_dir:Directory)
  WITH *
      ,reverse(split(reverse(root.absoluteFileName), '/')[0])       AS projectNameFromRoot
      ,reverse(split(reverse(config_dir.absoluteFileName), '/')[0]) AS projectNameFromConfig
  WITH *
      ,projectNameFromRoot + '/' + 
       nullif(projectNameFromConfig, projectNameFromRoot) AS projectNameWithDifferentConfigIfPresent
  WITH *
      ,coalesce(projectNameWithDifferentConfigIfPresent, projectNameFromRoot) AS projectName
   SET project.name = projectName
RETURN count(*) AS numberOfNamesProjects
// For debugging
//RETURN projectNameFromRoot
//      ,projectNameFromConfig
//      ,projectNameWithDifferentConfig
//      ,projectName
//      ,project, root, config
//LIMIT 10