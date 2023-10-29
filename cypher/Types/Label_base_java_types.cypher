// Label primitive Java types and void

  MATCH (type:Type)
   WITH type
       ,type.fqn in ['byte', 'short', 'int', 'long', 'float', 'double', 'boolean', 'char'] AS isPrimitiveType
       ,type.fqn = 'void' AS isVoid
   WITH type
       ,isPrimitiveType
       ,isVoid
       ,CASE WHEN isPrimitiveType     THEN [1] ELSE [] END AS primitive
       ,CASE WHEN isVoid              THEN [1] ELSE [] END AS void
  WHERE isPrimitiveType OR isVoid
FOREACH (x in primitive         | SET type:PrimitiveType)
FOREACH (x in void              | SET type:Void)
 RETURN labels(type), count(type) as numberOfBaseTypes