// Set name property on Typescript scan nodes

 MATCH (typescriptScan:TS:Scan)
  WITH  typescriptScan
       ,reverse(split(reverse(split(typescriptScan.fileName, '/.reports/')[0]), '/')[0]) AS scanName
   SET  typescriptScan.name = scanName
RETURN count(*) AS numberOfNamesScans
// Debugging
//RETURN scanName, scanNameOld, typescriptScan.fileName