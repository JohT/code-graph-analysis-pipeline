//Community Detection 6 Louvain Delete Existing Labels

  CALL db.labels() YIELD label
 WHERE label STARTS WITH "Louvain"
  WITH collect(label) AS labels
 MATCH (package:Package)
  WITH collect(package) AS packages, labels
  CALL apoc.create.removeLabels(packages, labels) YIELD node
RETURN COUNT(node) AS nodesCount;