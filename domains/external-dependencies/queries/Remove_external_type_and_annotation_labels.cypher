// Remove external type and annotation labels

  MATCH (externalType:Java:ExternalType)
 REMOVE externalType:ExternalType
 REMOVE externalType:ExternalAnnotation