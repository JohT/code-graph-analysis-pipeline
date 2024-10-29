// Adds a relation "RESOLVES_TO" from an external module to a module if their global fully qualified names match.
// Depends on "Add_module_properties.cypher" to be run first
// Inspired by https://github.com/jQAssistant/jqassistant/blob/4cd7face5d6d2953449d8e6ff5b484f00ffbdc2f/plugin/java/src/main/resources/META-INF/jqassistant-rules/java-classpath.xml#L5
// Related to https://github.com/jqassistant-plugin/jqassistant-typescript-plugin/issues/35

MATCH (module:TS:Module)<-[:CONTAINS]-(package:TS:Project)
WHERE module.globalFqn IS NOT NULL
  AND EXISTS { (module)-[:EXPORTS]->(:TS) } // only when module exports something
MATCH (externalModule:TS:ExternalModule)
WHERE externalModule.globalFqn IS NOT NULL
  AND externalModule     <> module
  AND externalModule.name = module.name // Base requirement: Same module name
  AND EXISTS { (externalModule)-[:EXPORTS]->(:TS:ExternalDeclaration)<-[]-(used:TS) } // only when external declarations are used
 WITH *, size(externalModule.extensionExtended) AS externalExtensionSize
 WITH *, CASE externalModule.extensionExtended
            WHEN ENDS WITH '.js'  THEN left(externalModule.extensionExtended, externalExtensionSize - 3) + module.extension
            WHEN ENDS WITH 'd.ts' THEN left(externalModule.extensionExtended, externalExtensionSize - 4) + module.extension
            ELSE externalModule.extensionExtended
          END AS normalizedExternalExtension
 WITH *
     // Find internal and external modules with identical "globalFqn"
     ,(module.globalFqn = externalModule.globalFqn) AS equalGlobalFqn
     // Find internal and external modules with identical "module"
     ,(module.module    = externalModule.module)    AS equalModule
     // Find matching internal and external modules within the same package and namespace
     ,(    externalModule.namespace   <> ''
       AND externalModule.namespace    = module.namespace
       AND externalModule.packageName  = package.name     
       AND normalizedExternalExtension = module.extensionExtended
      ) AS equalNameAndNamespace
     // Find matching internal and external module without a namespace with matching local module path
     ,(    module.namespace            = ''
       AND externalModule.namespace    = ''
       AND normalizedExternalExtension = module.extensionExtended
       AND externalModule.globalFqn ENDS WITH
           replace(module.localModulePath, '/' + module.moduleName, '/' + externalModule.moduleName)
      ) AS equalNameWithoutNamespace     
     // Find matching module name, npm package name and npm package namespace
     ,(    externalModule.namespace    = module.namespace
       AND externalModule.packageName  = module.packageName
       AND externalModule.packageName  > ''
       AND normalizedExternalExtension = module.extensionExtended
      ) AS equalNameAndNpmPackage
WHERE equalGlobalFqn
   OR equalModule
   OR equalNameAndNamespace
   OR equalNameWithoutNamespace
   OR equalNameAndNpmPackage
 CALL {  WITH module, externalModule
        MERGE (externalModule)-[:RESOLVES_TO]->(module)
      } IN TRANSACTIONS
RETURN CASE WHEN equalGlobalFqn            THEN 'equalGlobalFqn'
            WHEN equalModule               THEN 'equalModule'
            WHEN equalNameWithoutNamespace THEN 'equalNameWithoutNamespace'
            WHEN equalNameAndNamespace     THEN 'equalNameAndNamespace'
            WHEN equalNameAndNpmPackage    THEN 'equalNameAndNpmPackage'
        END AS equality
       ,count(*) AS resolvedModules
       ,collect(externalModule.globalFqn + ' -> ' + module.globalFqn)[0..4] AS examples
// Debugging
// RETURN module.globalFqn  ,externalModule.globalFqn
//       ,module.name       ,externalModule.name
//       ,module.moduleName ,externalModule.moduleName
//       ,module.namespace  ,externalModule.namespace
//       ,module.extensionExtended, externalModule.extensionExtended
//       ,module.localModulePath
//       ,split(module.module, '/')[-2] AS moduleDirectory