// Link matching external to internal Typescript declarations with an IS_IMPLEMENTED_IN relationship

 MATCH (externalModule:TS&ExternalModule)-[:EXPORTS]->(externalDeclaration:TS&ExternalDeclaration)
 MATCH (externalModule)-[:IS_IMPLEMENTED_IN]->(internalModule:TS&Module)
 MATCH (externalModule)-[:EXPORTS]->(internalDeclaration:TS&!ExternalDeclaration)
 WHERE externalDeclaration.name = internalDeclaration.name
  WITH externalDeclaration, internalDeclaration
  CALL { WITH externalDeclaration, internalDeclaration
        MERGE (externalDeclaration)-[:IS_IMPLEMENTED_IN]->(internalDeclaration)
       } IN TRANSACTIONS
RETURN count(  DISTINCT externalDeclaration.globalFqn + ' -> ' + internalDeclaration.globalFqn)       AS linkedDeclarationCount
      ,collect(DISTINCT externalDeclaration.globalFqn + ' -> ' + internalDeclaration.globalFqn)[0..4] AS linkedDeclarationExamples
//Debugging
//RETURN split(internalDeclaration.globalFqn, '/')[-6..] AS shortInternalDeclaration
//      ,split(externalDeclaration.globalFqn, '/')[-6..] AS shortExternalDeclaration
//      ,count(*)
//ORDER BY shortInternalDeclaration
//LIMIT 30