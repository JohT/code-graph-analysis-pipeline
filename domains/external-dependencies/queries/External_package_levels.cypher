// External package levels

MATCH (externalType:ExternalType)
 WITH replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
 WITH  count(DISTINCT split(externalPackageName, '.')[0])    AS externalFirstLevelPackages
      ,count(DISTINCT split(externalPackageName, '.')[0..1]) AS externalSecondLevelPackages
      ,count(DISTINCT split(externalPackageName, '.')[0..2]) AS externalThirdLevelPackages
      ,count(DISTINCT split(externalPackageName, '.')[0..3]) AS externalForthLevelPackages
      ,count(DISTINCT split(externalPackageName, '.')[0..4]) AS externalFifthLevelPackages
      ,count(DISTINCT externalPackageName)                   AS allExternalPackages
RETURN externalFirstLevelPackages
      ,externalSecondLevelPackages
      ,externalThirdLevelPackages
      ,externalForthLevelPackages
      ,externalFifthLevelPackages
      ,allExternalPackages