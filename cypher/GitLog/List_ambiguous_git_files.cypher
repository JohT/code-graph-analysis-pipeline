// List ambigiously resolved git files where a single git file is attached to more than one code file for troubleshooting/testing.

MATCH (file:File&!Git)<-[:RESOLVES_TO]-(git_file:File&Git)
OPTIONAL MATCH (artifact:Artifact:Archive)-[:CONTAINS]->(file)
 WITH file.fileName                                           AS fileName
     ,reverse(split(reverse(file.fileName),'.')[0])           AS fileExtension
     ,count(DISTINCT git_file.fileName)                       AS gitFilesCount
     ,collect(DISTINCT split(git_file.fileName,'/')[0])[0..6] AS gitFileFirstPathExamples
     ,collect(DISTINCT git_file.fileName)[0..6]               AS gitFileExamples
     ,collect(DISTINCT artifact.fileName)                     AS artifacts
WHERE gitFilesCount > 1
RETURN fileName
      ,fileExtension
      ,gitFilesCount
      ,count(*) AS numberOfCases
      ,artifacts
      ,gitFileFirstPathExamples
      ,gitFileExamples
ORDER BY gitFilesCount DESC, fileName ASC
LIMIT 50