// Set name property on Typescript scan nodes

 MATCH (typescriptScan:TS:Scan)
  WITH  typescriptScan
       ,replace(reverse(split(reverse(typescriptScan.fileName), '/')[0]), '.json', '') AS scanName
   SET  typescriptScan.name = scanName
RETURN count(*) AS numberOfNamesScans