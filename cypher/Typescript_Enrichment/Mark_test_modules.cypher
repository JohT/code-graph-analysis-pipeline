// Add "Test" label for modules that contain tests and test-related implementations

MATCH (m:Module)
 WITH m
     ,(m.globalFqn contains '/__tests__/') OR        
      (m.globalFqn contains '/test/')      OR
      (m.globalFqn contains '/tests/')                  AS isInTestFolder
     ,(m.globalFqn contains '/__mocks__/') OR        
      (m.globalFqn contains '/mock/')      OR      
      (m.globalFqn contains '/mocks/')                  AS isInMockFolder
     ,(m.globalFqn ENDS WITH '.test.' + m.extension) OR
      (m.globalFqn ENDS WITH '/test.' + m.extension) OR
      (m.globalFqn ENDS WITH 'Test.'  + m.extension)    AS isTestExtension
     ,(m.globalFqn ENDS WITH '.spec.' + m.extension) OR
      (m.globalFqn ENDS WITH '/spec.' + m.extension) OR
      (m.globalFqn ENDS WITH 'Spec.'  + m.extension)    AS isSpecificationExtension
    //,(m.globalFqn contains 'test')                    AS isTestMentioned // for debugging
  WITH *
      ,(isTestExtension OR isSpecificationExtension) AS isTest
      ,isInMockFolder                                AS isMock
      ,(isInTestFolder AND NOT isInMockFolder AND NOT isTestExtension AND NOT isSpecificationExtension) AS isTestEnvironment
  WITH *
      ,CASE WHEN isTest            THEN [1] ELSE [] END AS nonEmptyIfTest
      ,CASE WHEN isMock            THEN [1] ELSE [] END AS nonEmptyIfMock
      ,CASE WHEN isTestEnvironment THEN [1] ELSE [] END AS nonEmptyIfTestEnvironment
// Set labels "Test", "Mock", "TestEnvironment" and combining all "TestRelated" 
// Additionally, set the property "testMarkerInteger" (default=0) to filter projections.
// Numeric properties are required by projections using Neo4j's graph data science library.
    SET m.testMarkerInteger = 0
FOREACH (x in nonEmptyIfTest            | SET m:TestRelated:Test,            m.testMarkerInteger = 1)
FOREACH (x in nonEmptyIfMock            | SET m:TestRelated:Mock,            m.testMarkerInteger = 2)
FOREACH (x in nonEmptyIfTestEnvironment | SET m:TestRelated:TestEnvironment, m.testMarkerInteger = 3)
RETURN isTest, isMock, isTestEnvironment
      ,isInTestFolder, isInMockFolder, isTestExtension, isSpecificationExtension
    //,isTestMentioned // for debugging
     ,count(DISTINCT m.globalFqn)          AS numberOfModules
     ,collect(DISTINCT m.globalFqn)[0..4]  AS examples 