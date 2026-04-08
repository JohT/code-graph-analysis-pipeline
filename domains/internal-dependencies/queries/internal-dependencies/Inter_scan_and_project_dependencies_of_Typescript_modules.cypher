// Inter scan/project higher-level module dependencies for manual exploration

MATCH (source_module:TS:Module)-[:DEPENDS_ON]->(target_module:TS:Module)
MATCH (source_project:TS:Project)-[:CONTAINS]->(source_module)
MATCH (target_project:TS:Project)-[:CONTAINS]->(target_module)
OPTIONAL MATCH (source_project)<-[:REFERENCED_PROJECTS*1..3]-(source_project_roots:TS:Project)
MATCH (source_scan:TS:Scan)-[:CONTAINS_PROJECT]->(source_project)
MATCH (target_scan:TS:Scan)-[:CONTAINS_PROJECT]->(target_project)
RETURN source_scan, target_scan
      ,collect(source_project)[0..2], collect(target_project)[0..2]
      ,collect(source_module)[0..9], collect(target_module)[0..9]
LIMIT 50