// Overview size

 MATCH (n)
  WITH COUNT(n) AS nodeCount
 MATCH ()-[]->()
  WITH nodeCount
      ,count(*) AS relationshipCount
 MATCH (a:Artifact:Archive)
  WITH nodeCount
      ,relationshipCount
      ,count(DISTINCT a.fileName) AS artifactCount
 MATCH (p:Package)
  WITH nodeCount
      ,relationshipCount
      ,artifactCount
      ,count(DISTINCT p.fqn) AS packageCount
 MATCH (t:Type)
  WITH nodeCount
      ,relationshipCount
      ,artifactCount
      ,packageCount
      ,count(DISTINCT t.fqn) AS typeCount
 MATCH (m:Method)
  WITH nodeCount
      ,relationshipCount
      ,artifactCount
      ,packageCount
      ,typeCount
      ,count(DISTINCT m.signature) AS methodCount
 MATCH (member:Member)
  WITH nodeCount
      ,relationshipCount
      ,artifactCount
      ,packageCount
      ,typeCount
      ,methodCount
      ,count(DISTINCT member.signature) AS memberCount
RETURN nodeCount
      ,relationshipCount
      ,artifactCount
      ,packageCount
      ,typeCount
      ,methodCount
      ,memberCount