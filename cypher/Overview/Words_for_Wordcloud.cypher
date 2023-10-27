// Words for Wordcloud

MATCH (package:Package)
 WITH collect(package.name) AS packageNames
MATCH (type:Type&!PrimitiveType&!Void&!JavaType&!ResolvedDuplicateType&!ExternalType)
WHERE type.name <> 'package-info'       // not package-info files
 WITH packageNames, split(type.name, '$') AS splittedInnerClasses
UNWIND splittedInnerClasses AS splittedInnerClass
 WITH packageNames
     ,apoc.text.replace(splittedInnerClass, '(?<!^)([A-Z])', ' $1') AS splittedCamelCaseWord
 WITH packageNames
     ,split(apoc.text.replace(splittedCamelCaseWord, '[0-9]', ''), ' ') AS splittedCamelCaseWords
UNWIND splittedCamelCaseWords AS splittedCamelCaseWord     
 WITH packageNames, collect(splittedCamelCaseWord) AS typeNames
UNWIND packageNames + typeNames AS word
RETURN toLower(word) AS word