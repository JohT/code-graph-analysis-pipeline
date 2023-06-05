// Effective lines of method code per type

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
 MATCH (type)-[:DECLARES]->(method:Method)
 WHERE method.effectiveLineCount > 0
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,package.fqn                                              AS packageName
      ,type.name                                                AS typeName
      ,sum(method.effectiveLineCount)                           AS sumEffectiveLinesOfMethodCode
      ,reduce(loc = {max:-1}, m IN collect(method) | 
       CASE WHEN (m.effectiveLineCount > loc.max) THEN {max: m.effectiveLineCount, method: m} ELSE loc END) 
         AS methodWithMaxLoc
      ,reduce(cmplx = {max:-1}, m IN collect(method) | 
       CASE WHEN (m.cyclomaticComplexity > cmplx.max) THEN {max: m.cyclomaticComplexity, method: m} ELSE cmplx END) 
         AS methodWithMaxCyclomaticComplexity
RETURN artifactName, packageName, typeName
      ,sumEffectiveLinesOfMethodCode
      ,methodWithMaxLoc.max                          AS maxEffectiveLinesOfMethodCode
      ,methodWithMaxLoc.method.name                  AS methodWithMaxEffectiveLinesOfMethodCode
      ,methodWithMaxCyclomaticComplexity.max         AS maxCyclomaticComplexity
      ,methodWithMaxCyclomaticComplexity.method.name AS methodWithMaxCyclomaticComplexity
ORDER BY sumEffectiveLinesOfMethodCode DESC