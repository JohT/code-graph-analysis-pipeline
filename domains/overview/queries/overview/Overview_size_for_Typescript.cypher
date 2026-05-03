// Overview size for Typescript

 MATCH (n)
  WITH COUNT(n) AS nodeCount
 MATCH ()-[]->()
  WITH nodeCount
      ,count(*) AS relationshipCount
 MATCH (a:TS&Project)
  WITH nodeCount
      ,relationshipCount
      ,count(DISTINCT a) AS projectCount
 MATCH (p:TS&Module)
  WITH nodeCount
      ,relationshipCount
      ,projectCount
      ,count(DISTINCT p.globalFqn) AS moduleCount
 MATCH (function:TS&Function)
  WITH nodeCount
      ,relationshipCount
      ,projectCount
      ,moduleCount
      ,count(DISTINCT function) AS functionCount 
 MATCH (object:TS&Object)
  WITH nodeCount
      ,relationshipCount
      ,projectCount
      ,moduleCount
      ,functionCount
      ,count(DISTINCT object) AS objectCount
 MATCH (typeAlias:TS&TypeAlias)
  WITH nodeCount
      ,relationshipCount
      ,projectCount
      ,moduleCount
      ,functionCount
      ,objectCount
      ,count(DISTINCT typeAlias) AS typeAliasCount
 MATCH (interface:TS&Interface)
  WITH nodeCount
      ,relationshipCount
      ,projectCount
      ,moduleCount
      ,functionCount
      ,objectCount
      ,typeAliasCount
      ,count(DISTINCT interface) AS interfaceCount
 MATCH (method:TS&Method)
  WITH nodeCount
      ,relationshipCount
      ,projectCount
      ,moduleCount
      ,functionCount
      ,objectCount
      ,typeAliasCount
      ,interfaceCount
      ,count(DISTINCT method) AS methodCount
 MATCH (class:TS&Class)
  WITH nodeCount
      ,relationshipCount
      ,projectCount
      ,moduleCount
      ,functionCount
      ,objectCount
      ,typeAliasCount
      ,interfaceCount
      ,methodCount
      ,count(DISTINCT class) AS classCount
RETURN nodeCount
      ,relationshipCount
      ,projectCount
      ,moduleCount
      ,functionCount
      ,objectCount
      ,typeAliasCount
      ,interfaceCount
      ,classCount
      ,methodCount