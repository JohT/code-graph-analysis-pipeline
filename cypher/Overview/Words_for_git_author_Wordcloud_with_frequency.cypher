// Wordcloud of git authors and their commit count

 MATCH (author:Git:Author)-[:COMMITTED]-(commit:Git:Commit)
 WHERE NOT author.name CONTAINS '[bot]'
   AND size(author.name) > 1
RETURN author.name AS word, count(commit) AS frequency