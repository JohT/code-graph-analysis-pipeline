// Export the whole database as CSV
CALL apoc.export.csv.all("codegraph.csv", {})