//Community Detection 6 Delete Existing Labels

  CALL db.labels() YIELD label
 WHERE label STARTS WITH "Leiden"
  WITH collect(label) AS labels
 MATCH (package:Package)
  WITH collect(package) AS packages, labels
  CALL apoc.create.removeLabels(packages, labels) YIELD node
RETURN COUNT(node) AS nodesCount;