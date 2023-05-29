//Community Detection for Types 6 Leiden Delete Labels

  CALL db.labels() YIELD label
 WHERE label STARTS WITH "LeidenType"
  WITH collect(label) AS labels
 MATCH (type:Type)
  WITH collect(type) AS types, labels
  CALL apoc.create.removeLabels(types, labels)
 YIELD node
RETURN node, labels(node) AS labels;