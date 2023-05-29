// Add weight25PercentInterfaces to Package DEPENDS_ON relationships

 MATCH (package:Package)-[r:DEPENDS_ON]->(dependent:Package)
  WITH package, r
      ,toInteger(r.weight - round(r.weightInterfaces * 0.75)) AS weight25PercentInterfaces
   SET r.weight25PercentInterfaces = weight25PercentInterfaces
RETURN package.fqn, weight25PercentInterfaces, r.weight, r.weightInterfaces
 ORDER BY weight25PercentInterfaces DESC