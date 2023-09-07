// Effective lines of method code per package

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
 MATCH (type)-[:DECLARES]->(method:Method)
 WHERE method.effectiveLineCount > 0
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,package.fqn                                              AS fullPackageName
      ,package.name                                             AS packageName
      ,sum(method.effectiveLineCount)                           AS sumEffectiveLinesOfMethodCode
      ,sum(method.cyclomaticComplexity)                         AS sumCyclomaticComplexity
      ,COUNT(DISTINCT method) AS numberOfMethods
      ,reduce( // Get the max effectiveLineCount of all methods in the package with the name and type of the method
        loc = {max:-1}, // initial object with max lines of code = -1
        m IN collect({method:method, type:type}) | // collect all methods and their types as objects
          CASE WHEN (m.method.effectiveLineCount > loc.max) // when there is a method with a higher line count...
            THEN {max: m.method.effectiveLineCount, method: m.method, type: m.type} // then update the object
            ELSE loc // otherwise keep the object as it was
          END
        ) AS methodWithMaxLinesOfCode
      ,reduce( // Get the max cyclomaticComplexity of all methods in the package with the name and type of the method
        cmplx = {max:-1}, // initial object with max cyclomatic complexity = -1
        m IN collect({method:method, type:type}) | // collect all methods and their types as objects
          CASE WHEN (m.method.cyclomaticComplexity > cmplx.max) 
            THEN {max: m.method.cyclomaticComplexity, method: m.method, type: m.type} // then update the object
            ELSE cmplx // otherwise keep the object as it was
          END 
        ) AS methodWithMaxCyclomaticComplexity
RETURN artifactName, fullPackageName
      ,sumEffectiveLinesOfMethodCode                 AS linesInPackage
      ,sumCyclomaticComplexity                       AS complexityInPackage
      ,numberOfMethods                               AS methodCount
      ,methodWithMaxLinesOfCode.max                  AS maxLinesMethod
      ,methodWithMaxLinesOfCode.type.name            AS maxLinesMethodType
      ,methodWithMaxLinesOfCode.method.name          AS maxLinesMethodName
      ,methodWithMaxCyclomaticComplexity.max         AS maxComplexity
      ,methodWithMaxCyclomaticComplexity.type.name   AS maxComplexityType
      ,methodWithMaxCyclomaticComplexity.method.name AS maxComplexityMethod
      ,packageName 
ORDER BY linesInPackage DESC, artifactName ASC, fullPackageName