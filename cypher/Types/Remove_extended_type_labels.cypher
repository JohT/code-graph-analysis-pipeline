// Remove external type and annotation labels

  MATCH (extendedLabeledType:JavaType|PrimitiveType|Void|ResolvedDuplicateType)
 REMOVE extendedLabeledType:JavaType:PrimitiveType:Void:ResolvedDuplicateType