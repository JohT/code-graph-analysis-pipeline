// Add "namespace", "module" and "name" properties to Typescript nodes that have a globalFqn property

 MATCH (ts:TS)
 WHERE ts.globalFqn IS NOT NULL
  WITH ts
      ,replace(split(ts.globalFqn, '".')[0],'"', '')                                      AS moduleName
      ,replace(split(ts.globalFqn, '/index')[0],'"', '')                                  AS moduleNameWithoutIndex
      ,split(ts.globalFqn, '".')[1]                                                       AS symbolName
      ,split(nullif(reverse(split(reverse(ts.globalFqn), '@')[0]), ts.globalFqn), '/')[0] AS namespaceName
      ,(ts.globalFqn contains '/node_modules/')                                           AS isNodeModule
      ,((NOT ts.globalFqn STARTS WITH '/') AND size(split(ts.globalFqn, '/')) < 3)        AS isUnresolvedImport
  WITH *
      ,reverse(split(reverse(moduleNameWithoutIndex), '/')[0]) AS indexedName
      ,coalesce('@' + nullif(namespaceName, ''), '')           AS namespaceNameWithAtPrefixed
    SET ts.namespace          = namespaceNameWithAtPrefixed
       ,ts.module             = moduleName
       ,ts.name               = coalesce(symbolName, indexedName)
       ,ts.isNodeModule       = isNodeModule
       ,ts.isUnresolvedImport = isUnresolvedImport
       ,ts.isExternalImport   = isNodeModule OR isUnresolvedImport
RETURN count(*) AS updatedModules