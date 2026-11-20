// Verify that every SemanticCodeIndexInternalSymbol has all required properties.
// Uses property coverage approach: only reports properties that should be present but aren't.
// Properties checked (kind is excluded as it can be intentionally null):
//   - name         : Display name (from display_name in CSV)
//   - fqn          : Fully qualified name (copied from symbol)
//   - file         : Source file path
//   - module       : Containing module
//   - symbolType   : Symbol type classification (Class, Function, etc.)
//   - descriptor   : SCIP descriptor (last component of symbol path)
//   - projectName  : Project name (set by enrichment)
//   - isTest       : Boolean test marker
//   - isAbstract   : Boolean abstract marker
//   - packageId    : Package identifier
//   - scheme       : SCIP scheme (e.g., scip-typescript)
//   - language     : Programming language
//
// Returns properties with < 100% coverage and example symbols missing them.

 MATCH (symbol:SCIP:SemanticCodeIndexInternalSymbol)
  WITH count(*)        AS overallSymbolCount
      ,collect(symbol) AS symbols
UNWIND symbols         AS symbol
UNWIND keys(symbol)    AS propertyName
  WITH propertyName
      ,toFloat(count(*)) / max(overallSymbolCount) * 100.0 AS coverage
      ,COLLECT(DISTINCT COALESCE(symbol.name, symbol.fqn, 'unknown'))[0..9] AS symbolExamples
 WHERE coverage < 100.0
   AND propertyName IN ['name', 'fqn', 'file', 'module', 'symbolType', 'descriptor', 'projectName', 'isTest', 'isAbstract', 'packageId', 'scheme', 'language']
RETURN propertyName, coverage, symbolExamples