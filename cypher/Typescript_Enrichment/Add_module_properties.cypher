// Add extended properties to Typescript nodes with a globalFqn like "namespace", "module", "name" and "extension" as well as markers like "isNodeModule", "isUnresolvedImport" and "isExternalImport"
 MATCH (ts:TS)
 WHERE ts.globalFqn IS NOT NULL
OPTIONAL MATCH (class:TS:Class)-[:DECLARES]->(ts)
  WITH ts
      ,replace(split(ts.globalFqn, '".')[0],'"', '')                                        AS modulePathName
      ,reverse(split(reverse(replace(split(ts.globalFqn, '".')[0],'"', '')), '/')[0])       AS moduleName
      ,replace(split(split(ts.globalFqn, '/index')[0], '.default')[0],'"', '')              AS modulePathNameWithoutIndexAndDefault
      ,nullif(split(ts.globalFqn, '".')[1], 'default')                                      AS symbolName
      ,split(nullif(reverse(split(reverse(ts.globalFqn), '@')[0]), ts.globalFqn), '/')[0]   AS namespaceName
      ,(ts.globalFqn contains '/node_modules/')                                             AS isNodeModule
      ,((NOT ts.globalFqn STARTS WITH '/') AND size(split(ts.globalFqn, '/')) < 3)          AS isUnresolvedImport
      ,reverse(split(reverse(class.globalFqn), '.')[0])                                     AS optionalClassName
  WITH *
      ,split(reverse(split(reverse(modulePathNameWithoutIndexAndDefault), '/')[0]), '.')[0] AS indexAndExtensionOmittedName
      ,replace(moduleName, nullif(split(moduleName, '.')[0], moduleName) + '.', '')         AS moduleNameExtensionExtended
      ,nullif(reverse(split(reverse(moduleName), '.')[0]), moduleName)                      AS moduleNameExtension
      ,coalesce('@' + nullif(namespaceName, ''), '')                                        AS namespaceNameWithAtPrefixed
      ,replace(symbolName, coalesce(optionalClassName + '.', ''), '')                       AS symbolNameWithoutClassName
    SET ts.namespace          = namespaceNameWithAtPrefixed
       ,ts.module             = modulePathName
       ,ts.moduleName         = moduleName
       ,ts.name               = coalesce(symbolNameWithoutClassName, indexAndExtensionOmittedName)
       ,ts.extensionExtended  = moduleNameExtensionExtended
       ,ts.extension          = moduleNameExtension
       ,ts.isNodeModule       = isNodeModule
       ,ts.isUnresolvedImport = isUnresolvedImport
       ,ts.isExternalImport   = isNodeModule OR isUnresolvedImport
RETURN count(*) AS updatedModules