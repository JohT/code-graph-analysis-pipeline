// Label resolved duplicate types.

  MATCH (type:Type)
   WITH type, exists((type)-[:RESOLVES_TO]->(:Type)) AS isResolvedDuplicate
  WHERE isResolvedDuplicate
    SET type:ResolvedDuplicateType
 RETURN labels(type), count(type) as numberOfResolvedDuplicateTypes