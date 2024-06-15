// List external Java types used

MATCH (external:Java:ExternalType) 
RETURN labels(external), count(DISTINCT external.fqn) as numberOfExternalTypes