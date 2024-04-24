// External declarations split by their module and their contained symbols

MATCH (s:ExternalDeclaration)
 WITH *
      ,replace(split(s.globalFqn, '".')[0],'"', '') AS externalDeclarationModule
      ,split(s.globalFqn, '".')[1] AS externalDeclarationSymbol
RETURN externalDeclarationModule
      ,count(DISTINCT externalDeclarationSymbol) AS externalDeclarationSymbols
      ,collect(externalDeclarationSymbol)[0..4] AS someExternalDeclarationSymbols
      ,count(*) as numberOfExternalDeclarations
ORDER BY numberOfExternalDeclarations DESC, externalDeclarationModule ASC
LIMIT 50