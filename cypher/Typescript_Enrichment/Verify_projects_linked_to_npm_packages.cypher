// Verify that all Typescript projects are linked to npm packages

 MATCH (project:TS:Project)
  WITH count(project)   AS totalProjectsCount
      ,collect(project) AS projects
UNWIND projects AS project
OPTIONAL MATCH (project)-[:HAS_NPM_PACKAGE]->(npm:NPM:Package)
  WITH totalProjectsCount
      ,count(npm)         AS npmLinkedProjectsCount
RETURN npmLinkedProjectsCount
      ,totalProjectsCount
      ,(totalProjectsCount - npmLinkedProjectsCount)               AS unresolvedProjectsCount
      ,(100.0 / totalProjectsCount * npmLinkedProjectsCount)       AS npmLinkedProjectsPercentage