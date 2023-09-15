//Community Detection 6 Delete Existing Labels

  CALL db.labels() YIELD label
 WHERE label STARTS WITH "ArtifactLeiden"
  WITH collect(label) AS labels
 MATCH (artifact:Artifact)
  WITH collect(artifact) AS artifacts, labels
  CALL apoc.create.removeLabels(artifacts, labels) YIELD node
RETURN COUNT(node) AS nodesCount;