// Remove external type and annotation labels

  MATCH (externalType:ExternalType)
 REMOVE externalType:ExternalType:ExternalAnnotation