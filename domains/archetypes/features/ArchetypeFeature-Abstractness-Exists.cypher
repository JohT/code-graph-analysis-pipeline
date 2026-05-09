// Return the first node with the property "abstractness" if it exists

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
     AND codeUnit.abstractness         IS NOT NULL
  RETURN codeUnit.name                       AS shortCodeUnitName
        ,elementId(codeUnit)                 AS nodeElementId
        ,codeUnit.abstractness               AS abstractness
   LIMIT 1