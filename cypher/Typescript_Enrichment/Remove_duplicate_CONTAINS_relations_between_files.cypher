// Remove duplicate CONTAINS relationships  with the same properties between files

 MATCH (directory:File)-[contains_relation:CONTAINS]-(file:File)
  WITH directory
      ,file
      ,keys(contains_relation)                  AS contains_relation_property_names
      ,collect(DISTINCT contains_relation)[1..] AS contains_relations
 WHERE size(contains_relations) > 0
UNWIND contains_relations AS contains_relation
DELETE contains_relation
RETURN count(*)
// For Debugging
// RETURN directory, file
// LIMIT 10