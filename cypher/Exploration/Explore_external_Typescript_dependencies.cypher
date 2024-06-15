// Explore Typescript nodes with globalFqn property by their label, count and if they came from the node_modules folder

MATCH (typescript:TS)
WHERE typescript.globalFqn IS NOT NULL
RETURN labels(file)[0..4] AS nodeType
      ,(typescript.globalFqn contains '/node_modules/') AS isNodeModule
      ,count(*) AS numberOfNodes
      ,collect(DISTINCT typescript.globalFqn)[0..9]     AS examples
ORDER BY nodeType ASC, numberOfNodes DESC