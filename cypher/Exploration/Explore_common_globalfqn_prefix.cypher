// Get common global full qualified name prefix

MATCH (module:TS)
WHERE module.globalFqn STARTS WITH '/'
 WITH count(module.globalFqn) AS numberOfAllModules
     ,collect(module)         AS modules
UNWIND modules AS module
 WITH numberOfAllModules
     ,module.globalFqn        AS moduleFullQualifiedName
     ,split(module.globalFqn, '/') AS paths
UNWIND paths AS path
 WITH path, numberOfAllModules, count(*) AS numberOfModulesUsingThePath
WHERE numberOfAllModules = numberOfModulesUsingThePath
RETURN apoc.text.join(collect(path), '/') AS commonPath