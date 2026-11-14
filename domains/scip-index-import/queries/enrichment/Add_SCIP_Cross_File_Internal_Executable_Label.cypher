// Add SemanticCodeIndexInternalExecutable label to cross-file internal symbols that represent executable code (functions, methods, constructors, getters, setters, abstract methods). This is a stable aggregated label combining executable symbolTypes. Intended for stability-critical queries. Requires "Add_SCIP_Cross_File_Symbol_Type_Label.cypher".

MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
WHERE n.symbolType IN ['Function', 'Method', 'AbstractMethod', 'Constructor', 'Getter', 'Setter']
  AND NOT n:SemanticCodeIndexInternalExecutable
SET n:SemanticCodeIndexInternalExecutable
RETURN count(*) AS labelledNodes