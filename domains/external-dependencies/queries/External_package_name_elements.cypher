// External package name elements

MATCH (externalType:ExternalType)
 WITH replace(externalType.fqn, '.' + externalType.name, '') AS packageName
 WITH size(split(packageName,'.'))                           AS packageNameElements
      ,count(DISTINCT packageName)                           AS packageCount
      ,collect(DISTINCT packageName)[0..19]                  AS somePackageNames
RETURN packageNameElements
      ,packageCount
      ,somePackageNames
ORDER BY packageNameElements