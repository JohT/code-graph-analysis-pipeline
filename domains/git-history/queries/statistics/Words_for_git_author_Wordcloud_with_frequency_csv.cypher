// Wordcloud of git authors and their commit count. Uses the CSV-imported git log schema (Git:Log:Author, Git:Log:Commit).

MATCH (author:Git:Log:Author)-[:AUTHORED]->(commit:Git:Log:Commit)
WHERE NOT author.name CONTAINS '[bot]'
  AND size(author.name) > 1
RETURN author.name AS word, count(commit) AS frequency
