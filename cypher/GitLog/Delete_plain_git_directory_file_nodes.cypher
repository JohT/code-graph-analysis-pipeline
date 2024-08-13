// Delete plain file nodes in "/.git" directory

MATCH (git_metadata_file:File)<-[:CONTAINS*]-(git_directory:Directory)
WHERE git_directory.fileName ENDS WITH '/.git'
 WITH git_directory.fileName AS gitDirectory
     ,count(DISTINCT git_metadata_file.fileName)          AS numberOfFiles
     ,collect(DISTINCT git_metadata_file.fileName)[0..4]  AS fileExamples
     ,collect(DISTINCT git_metadata_file)                 AS git_metadata_files
UNWIND git_metadata_files AS git_metadata_file
  CALL { WITH git_metadata_file
         DETACH DELETE git_metadata_file
       } IN TRANSACTIONS OF 1000 ROWS
RETURN DISTINCT gitDirectory, numberOfFiles, fileExamples
ORDER BY numberOfFiles DESC