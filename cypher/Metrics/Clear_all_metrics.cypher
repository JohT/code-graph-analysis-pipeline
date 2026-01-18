// Clear all object oriented design metrics

MATCH (package:Java:Package)
REMOVE package.incomingDependencies      
      ,package.incomingDependenciesWeight
      ,package.incomingDependentTypes    
      ,package.incomingDependentInterfaces
      ,package.incomingDependentPackages 
      ,package.incomingDependentArtifacts
      ,package.outgoingDependencies       
      ,package.outgoingDependenciesWeight 
      ,package.outgoingDependentTypes     
      ,package.outgoingDependentInterfaces
      ,package.outgoingDependentPackages  
      ,package.outgoingDependentArtifacts 
      ,package.incomingDependenciesIncludingSubpackages      
      ,package.incomingDependenciesWeightIncludingSubpackages
      ,package.incomingDependentTypesIncludingSubpackages    
      ,package.incomingDependentInterfacesIncludingSubpackages
      ,package.incomingDependentPackagesIncludingSubpackages 
      ,package.incomingDependentArtifactsIncludingSubpackages
      ,package.outgoingDependenciesIncludingSubpackages       
      ,package.outgoingDependenciesWeightIncludingSubpackages 
      ,package.outgoingDependentTypesIncludingSubpackages     
      ,package.outgoingDependentInterfacesIncludingSubpackages
      ,package.outgoingDependentPackagesIncludingSubpackages  
      ,package.outgoingDependentArtifactsIncludingSubpackages 
      ,package.abstractness
      ,package.numberOfTypes
      ,package.numberOfAbstractTypes
      ,package.numberOfAbstractClasses
      ,package.abstractnessIncludingSubpackages
      ,package.numberOfAbstractTypesIncludingSubpackages
      ,package.numberOfTypesIncludingSubpackages
      ,package.instability
      ,package.instabilityTypes
      ,package.instabilityInterfaces
      ,package.instabilityPackages
      ,package.instabilityArtifacts
      ,package.instabilityIncludingSubpackages
      ,package.instabilityTypesIncludingSubpackages
      ,package.instabilityInterfacesIncludingSubpackages
      ,package.instabilityPackagesIncludingSubpackages
      ,package.instabilityArtifactsIncludingSubpackages
RETURN count(package) as numberOfPackagesWithClearedMetricProperties