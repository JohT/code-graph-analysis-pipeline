// Similarity 2b Check Projection Node

MATCH (p:Package)
RETURN p.name AS name
      ,p.incomingDependencies
      ,gds.util.nodeProperty(
          'package-similarity', id(p), 'incomingDependencies'
       ) AS projectedIncomingDependencies
      ,p.outgoingDependencies
      ,gds.util.nodeProperty(
          'package-similarity', id(p), 'outgoingDependencies'
       ) AS projectedOutgoingDependencies
ORDER BY name