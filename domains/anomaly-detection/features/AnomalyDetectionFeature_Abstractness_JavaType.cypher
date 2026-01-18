// Calculate and set abstractness for Java Types and returns the distribution.

MATCH (javaCodeUnit:Java:Type)
 WITH javaCodeUnit
     ,javaCodeUnit:Annotation                        AS isAnnotation
     ,javaCodeUnit:Interface                         AS isInterface
     ,(javaCodeUnit:Class AND javaCodeUnit.abstract) AS isAbstractClass
 WITH *
     ,CASE WHEN isAnnotation OR isInterface THEN 1.0
           WHEN isAbstractClass             THEN 0.7
           ELSE 0.0
      END AS abstractness
  SET javaCodeUnit.abstractness = abstractness
RETURN abstractness
      ,count(*) AS typeCount
      ,collect(javaCodeUnit.name)[0..4] AS examples
ORDER BY abstractness ASC