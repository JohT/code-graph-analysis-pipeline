// Get all Packages with a Community Detection Label
MATCH (package:Package) 
WHERE any(label IN labels(package) WHERE label CONTAINS 'Community')
RETURN DISTINCT package;