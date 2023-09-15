// Get all Artifacts with a Community Detection Label

MATCH (artifact:Artifact) 
WHERE any(label IN labels(artifact) WHERE label CONTAINS 'Community')
RETURN DISTINCT artifact;