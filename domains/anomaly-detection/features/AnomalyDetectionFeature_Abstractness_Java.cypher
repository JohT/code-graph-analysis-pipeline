// Calculate and set abstractness for Java Code Packages or Artifacts and return a 0.1 ranged bin distribution.

MATCH (javaCodeUnit:Java&(Package|Artifact))
 WITH javaCodeUnit
     ,COUNT{ (javaCodeUnit)-[:CONTAINS]->(:Type) }                 AS numberTypes
     ,COUNT{ (javaCodeUnit)-[:CONTAINS]->(:Class{abstract:true}) } AS numberAbstractClasses
     ,COUNT{ (javaCodeUnit)-[:CONTAINS]->(:Annotation) }           AS numberAnnotations
     ,COUNT{ (javaCodeUnit)-[:CONTAINS]->(:Interface) }            AS numberInterfaces
 WITH *
     ,numberInterfaces + numberAnnotations + (numberAbstractClasses * 0.7) AS weightedAbstractTypes
 WITH *
     ,toFloat(weightedAbstractTypes) / (numberTypes + 1E-38) AS abstractness
  SET javaCodeUnit.abstractness      = abstractness
RETURN round(abstractness, 1)           AS abstractnessBin
      ,count(*)                         AS packageCount
      ,collect(javaCodeUnit.name)[0..4] AS examples
ORDER BY abstractnessBin ASC