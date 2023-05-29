//Calculate and set Abstractness including Counts 

   MATCH (package:Package)
OPTIONAL MATCH (package)-[:CONTAINS]->(type:Type) 
    WITH package
        ,COUNT(type) AS numberTypes
OPTIONAL MATCH (package)-[:CONTAINS]->(abstract:Class {abstract:true}) 
    WITH package
        ,numberTypes
        ,COUNT(abstract) AS numberAbstractClasses
OPTIONAL MATCH (package)-[:CONTAINS]->(enum:Enum)
    WITH package
        ,numberTypes
        ,numberAbstractClasses
        ,COUNT(enum) AS numberEnums
OPTIONAL MATCH (package)-[:CONTAINS]->(class:Class)
    WITH package
        ,numberTypes
        ,numberAbstractClasses
        ,numberEnums
        ,COUNT(class) - numberAbstractClasses + numberEnums AS numberNonAbstractTypes
OPTIONAL MATCH (package)-[:CONTAINS]->(annotation:Annotation) 
    WITH package
        ,numberTypes
        ,numberAbstractClasses
        ,numberEnums
        ,numberNonAbstractTypes
        ,COUNT(annotation) AS numberAnnotations
OPTIONAL MATCH (package)-[:CONTAINS]->(interface:Interface) 
    WITH package
        ,numberTypes
        ,numberAbstractClasses
        ,numberEnums
        ,numberNonAbstractTypes
        ,numberAnnotations
        ,COUNT(interface) AS numberInterfaces
        ,COUNT(interface) + numberAbstractClasses + numberAnnotations AS numberAbstractTypes
    WITH *
        ,toFloat(numberAbstractTypes) / (numberTypes + 1E-38)  AS abstractness
     SET package.abstractness = abstractness
    WITH *
   WHERE numberTypes > 0
  RETURN package.fqn  AS fullQualifiedPackageName
        ,package.name AS packageName
        ,abstractness
        ,numberAbstractTypes
        ,numberTypes
ORDER BY abstractness ASC, numberTypes DESC