// Words for Wordcloud

MATCH (package:Package)
 WITH collect(package.name) AS packageNames
MATCH (type:Java:Type:InternalJavaType)
WHERE type.name <> 'package-info'       // not package-info files
 WITH packageNames, split(type.name, '$') AS splitInnerClasses
UNWIND splitInnerClasses AS splitInnerClass
 WITH packageNames
     ,apoc.text.replace(splitInnerClass, '(?<!^)([A-Z])', ' $1') AS splitCamelCaseWord
 WITH packageNames
     ,split(apoc.text.replace(splitCamelCaseWord, '[0-9]', ''), ' ') AS splitCamelCaseWords
UNWIND splitCamelCaseWords AS splitCamelCaseWord     
 WITH packageNames, collect(splitCamelCaseWord) AS typeNames
UNWIND packageNames + typeNames AS word
RETURN toLower(word) AS word