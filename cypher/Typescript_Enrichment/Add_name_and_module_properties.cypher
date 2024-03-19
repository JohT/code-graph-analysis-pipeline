// Add "name" and "module" properties to Typescript nodes that have a globalFqn property

 MATCH (ts:TS)
 WHERE ts.globalFqn IS NOT NULL
  WITH ts
      ,replace(split(ts.globalFqn, '".')[0],'"', '') AS moduleName
      ,replace(split(ts.globalFqn, '/index')[0],'"', '') AS moduleNameWithoutIndex
      ,split(ts.globalFqn, '".')[1]                  AS symbolName
  WITH *
      ,reverse(split(reverse(moduleNameWithoutIndex), '/')[0]) AS indexedName
    SET ts.module = moduleName
       ,ts.name   = coalesce(symbolName, indexedName)
RETURN count(*) AS updatedModules