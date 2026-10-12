// Wordcloud of git authors and their aggregated commit count. Uses the aggregated git log schema (Git:Log:Author, Git:Log:ChangeSpan).

MATCH (author:Git:Log:Author)-[:AUTHORED]->(:Git:Log:ChangeSpan)-[rel:CONTAINS_CHANGED]->(:Git:Log:File)
WHERE NOT author.name CONTAINS '[bot]'
  AND size(author.name) > 1
 WITH author.name AS word, sum(rel.commits) AS frequency
RETURN word, frequency
 ORDER BY frequency DESCENDING