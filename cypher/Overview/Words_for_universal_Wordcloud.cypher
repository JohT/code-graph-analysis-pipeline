// Words for universal Wordcloud

MATCH (named:!Key&!Primitive&!PrimitiveType&!Void&!JavaType&!ResolvedDuplicateType&!ExternalType&!Git)
WHERE named.name > ''
  AND named.name <> 'package-info'
  AND named.name <> '<init>'
  AND named.name <> '<clinit>'
 WITH apoc.text.replace(named.name, '(?<!^)([-_A-Z\W])', ' $1') AS words
 WITH apoc.text.replace(words, '[-_0-9\W]', ' ')                AS words
 WITH apoc.text.replace(words, '\s+', ' ')                      AS words
 WITH split(toLower(trim(words)), ' ')                          AS words
UNWIND words AS word
  WITH word  AS word
 WHERE size(word) > 1
RETURN word
//      ,count(*) as numberOfAppearances
//ORDER BY numberOfAppearances DESC, word