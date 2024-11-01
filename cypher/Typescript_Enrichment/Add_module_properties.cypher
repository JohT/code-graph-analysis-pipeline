// Add extended properties to Typescript nodes with a globalFqn like "namespace", "module", "name" and "extension" as well as markers like "isNodeModule", "isUnresolvedImport" and "isExternalImport"
 MATCH (ts:TS)
 WHERE ts.globalFqn IS NOT NULL
OPTIONAL MATCH (class:TS:Class)-[:DECLARES]->(ts)
  WITH *
      //In case of a path like ".../moduleName/src/index.ts", the module name is extracted into sourceIndexModuleName.
      ,reverse(split(reverse(nullif(split(ts.globalFqn, '/src/index.')[0], ts.globalFqn)), '/')[0]) AS sourceIndexModuleName
  WITH *
      //In case of a path like ".../moduleName/dist/types/index.d.ts", the module name is extracted into distTypesIndexModuleName.
      ,reverse(split(reverse(nullif(split(ts.globalFqn, '/dist/types/index.')[0], ts.globalFqn)), '/')[0]) AS distTypesIndexModuleName
  WITH *
      //In case of a path like ".../moduleName/types/index.d.ts", the module name is extracted into typesIndexModuleName.
      ,reverse(split(reverse(nullif(split(ts.globalFqn, '/types/index.')[0], ts.globalFqn)), '/')[0]) AS typesIndexModuleName
  WITH *
      //In case of a path like ".../moduleName/dist/types/src/index.d.ts", the module name is extracted into distTypesSourceIndexModuleName.
      ,reverse(split(reverse(nullif(split(ts.globalFqn, '/dist/types/src/index.')[0], ts.globalFqn)), '/')[0]) AS distTypesSourceIndexModuleName
  WITH *
      //Combine the cases above into "normalizedModuleName"
      ,coalesce(distTypesIndexModuleName, typesIndexModuleName, distTypesSourceIndexModuleName, sourceIndexModuleName) AS normalizedModuleName
  WITH *
      ,replace(split(ts.globalFqn, '".')[0],'"', '')                                        AS modulePathName
      ,reverse(split(reverse(replace(split(ts.globalFqn, '".')[0],'"', '')), '/')[0])       AS moduleName
      ,replace(split(split(ts.globalFqn, '/index')[0], '.default')[0],'"', '')              AS modulePathNameWithoutIndexAndDefault
      ,nullif(split(ts.globalFqn, '".')[1], 'default')                                      AS symbolName
      ,split(split(reverse(split(reverse(ts.globalFqn), reverse('/node_modules/'))[0]),'@')[1], '/')[0] AS namespaceName
      ,(ts.globalFqn contains '/node_modules/')                                             AS isNodeModule
      ,((NOT ts.globalFqn STARTS WITH '/') AND size(split(ts.globalFqn, '/')) < 3)          AS isUnresolvedImport
      ,reverse(split(reverse(class.globalFqn), '.')[0])                                     AS optionalClassName
  WITH *
      ,split(reverse(split(reverse(modulePathNameWithoutIndexAndDefault), '/')[0]), '.')[0] AS indexAndExtensionOmittedName
      ,replace(moduleName, nullif(split(moduleName, '.')[0], moduleName) + '.', '')         AS moduleNameExtensionExtended
      ,nullif(reverse(split(reverse(moduleName), '.')[0]), moduleName)                      AS moduleNameExtension
      ,coalesce('@' + nullif(namespaceName, ''), '')                                        AS namespaceNameWithAtPrefixed
      ,replace(symbolName, coalesce(optionalClassName + '.', ''), '')                       AS symbolNameWithoutClassName
      ,coalesce(split(split(ts.globalFqn, nullif(namespaceName, '') + '/')[1], '/')[0], '') AS packageName
    SET ts.namespace          = coalesce(nullif(namespaceNameWithAtPrefixed, ''), ts.namespace, '')
       ,ts.module             = modulePathNameWithoutIndexAndDefault
       ,ts.moduleName         = moduleName
       ,ts.name               = coalesce(symbolNameWithoutClassName, normalizedModuleName, indexAndExtensionOmittedName)
       ,ts.extensionExtended  = moduleNameExtensionExtended
       ,ts.extension          = moduleNameExtension
       ,ts.isNodeModule       = isNodeModule
       ,ts.isUnresolvedImport = isUnresolvedImport
       ,ts.isExternalImport   = isNodeModule OR isUnresolvedImport
       ,ts.packageName        = packageName
RETURN count(*) AS updatedModules
// For debugging
// RETURN  ts.globalFqn
//        ,namespaceNameWithAtPrefixed         AS namespace
//        ,modulePathName                      AS module            
//        ,moduleName                          AS moduleName        
//        ,coalesce(symbolNameWithoutClassName, normalizedModuleName, indexAndExtensionOmittedName) AS name              
//        ,moduleNameExtensionExtended         AS extensionExtended 
//        ,moduleNameExtension                 AS extension         
//        ,modulePathNameWithoutIndexAndDefault 
//        ,symbolName 
//        ,optionalClassName 
//        ,normalizedModuleName 
//        ,symbolNameWithoutClassName 
//        ,isNodeModule                       AS isNodeModule      
//        ,isUnresolvedImport                 AS isUnresolvedImport
//        ,isNodeModule OR isUnresolvedImport AS isExternalImport  
// LIMIT 50