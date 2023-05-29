// Add weight10PercentInterfaces to Package DEPENDS_ON relationships

 MATCH (package:Package)-[r:DEPENDS_ON]->(dependent:Package)
  WITH package, r
      ,toInteger(r.weight - round(r.weightInterfaces * 0.90)) AS weight10PercentInterfaces
   SET r.weight10PercentInterfaces = weight10PercentInterfaces
RETURN package.fqn, weight10PercentInterfaces, r.weight, r.weightInterfaces
 ORDER BY weight10PercentInterfaces DESC