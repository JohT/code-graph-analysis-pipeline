 // Add "name", "extension" and "extensionExtended" properties to File nodes

 MATCH (file:File)
 WHERE file.fileName IS NOT NULL
   AND file.name IS NULL // Don't override an already existing "name" property
  WITH *
      ,file.fileName AS fileName
  WITH *
      ,last(split(fileName, '/')) AS fileNameWithoutPath
  WITH *
      ,coalesce(nullif(last(split(fileNameWithoutPath, '.')), fileNameWithoutPath), '') AS fileExtension
  WITH *
      //,rtrim(fileNameWithoutPath, '.' + fileExtension) AS fileNameWithoutPathAndExtensionOld //rtrim seems to have an issue
      ,substring(fileNameWithoutPath, 0, size(fileNameWithoutPath) - size(fileExtension) - 1) AS fileNameWithoutPathAndExtension
  WITH *
      ,CASE WHEN file:Directory OR file:ServiceLoader THEN fileNameWithoutPath ELSE fileNameWithoutPathAndExtension END AS name
      ,CASE WHEN file:Directory OR file:ServiceLoader THEN '' ELSE fileExtension  END AS fileExtension
   SET file.name              = name
      ,file.extension         = fileExtension
RETURN count(*) AS updatedArtifacts
// Debugging
//RETURN labels(file)[0..3]                    AS fileLabels
//      ,count(*)                              AS nodeCount
//      ,collect(DISTINCT fileName 
//              + ': name='        + name 
//              + ', withoutPath=' + fileNameWithoutPath 
//              + ', extension='   + fileExtension 
//              )[0..4] AS exampleFiles