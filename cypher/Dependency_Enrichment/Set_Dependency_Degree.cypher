// Set "dependencyDegree" and "dependencyDegreeWeighted" on all nodes containing a property for incoming or outgoing dependencies. Requires all "Set_Incoming*.cypher" and "Set_Outgoing*.cypher".

   MATCH (dependency)
   WHERE (dependency.incomingDependencies IS NOT NULL OR dependency.outgoingDependencies IS NOT NULL)
    WITH dependency
        ,coalesce(dependency.incomingDependencies, 0)       AS inDegree
        ,coalesce(dependency.outgoingDependencies, 0)       AS outDegree
        ,coalesce(dependency.incomingDependenciesWeight, 0) AS inDegreeWeighted
        ,coalesce(dependency.outgoingDependenciesWeight, 0) AS outDegreeWeighted
     SET dependency.dependencyDegree         = inDegree         + outDegree
        ,dependency.dependencyDegreeWeighted = inDegreeWeighted + outDegreeWeighted
  RETURN count(*)                                 AS writtenNodes
        ,max(dependency.dependencyDegree)         AS maxDependencyDegree 
        ,max(dependency.dependencyDegreeWeighted) AS maxDependencyDegreeWeighted