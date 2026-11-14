# SCIP Kind Mapping Reference

This document provides a reference for the SCIP symbol Kind enum and its mapping to Neo4j labels and symbolType values used in the cross-file import process.

## SCIP Kind to symbolType Mapping

The `code_unit_type_all()` function in `convertScipIndexToCsvForNeo4jCrossFileImport.sh` maps SCIP Kind numbers to human-readable `symbolType` values. These values are then used by label enrichment Cypher queries to assign Neo4j labels.

### Mapping Table

| Kind | Name | symbolType | Neo4j Label | Query File |
|------|------|-----------|-------------|-----------|
| 7 | Class | Class/AbstractClass | `:SemanticCodeIndexInternalType` | Add_SCIP_Cross_File_Internal_Type_Label.cypher |
| 8 | Constant | Variable | `:SemanticCodeIndexVariable` | Add_SCIP_Cross_File_Variable_Label.cypher |
| 9 | Constructor | Constructor | `:SemanticCodeIndexConstructor` | Add_SCIP_Cross_File_Constructor_Label.cypher |
| 11 | Enum | Enum | `:SemanticCodeIndexInternalType` | Add_SCIP_Cross_File_Internal_Type_Label.cypher |
| 12 | EnumMember | EnumMember | `:SemanticCodeIndexEnumMember` | Add_SCIP_Cross_File_EnumMember_Label.cypher |
| 17 | Function | Function | `:SemanticCodeIndexFunction` | Add_SCIP_Cross_File_Function_Label.cypher |
| 18 | Getter | Getter | `:SemanticCodeIndexGetter` | Add_SCIP_Cross_File_Getter_Label.cypher |
| 21 | Interface | Interface | `:SemanticCodeIndexInternalType` | Add_SCIP_Cross_File_Internal_Type_Label.cypher |
| 26 | Method | Method | `:SemanticCodeIndexFunction` | Add_SCIP_Cross_File_Function_Label.cypher |
| 35 | Package | Package | (no label) | - |
| 41 | Property | Property | `:SemanticCodeIndexProperty` | Add_SCIP_Cross_File_Property_Label.cypher |
| 49 | Struct | Struct | `:SemanticCodeIndexInternalType` | Add_SCIP_Cross_File_Internal_Type_Label.cypher |
| 54 | TypeAlias | TypeAlias | `:SemanticCodeIndexTypeAlias` | Add_SCIP_Cross_File_TypeAlias_Label.cypher |
| 55 | TypeAlias | TypeAlias | `:SemanticCodeIndexTypeAlias` | Add_SCIP_Cross_File_TypeAlias_Label.cypher |
| 61 | Variable | Field/TypeAlias | `:SemanticCodeIndexField` or `:SemanticCodeIndexTypeAlias` | Add_SCIP_Cross_File_Field_Label.cypher |
| 66 | AbstractMethod | Method | `:SemanticCodeIndexFunction` | Add_SCIP_Cross_File_Function_Label.cypher |
| 67 | MethodSpecification | Method | `:SemanticCodeIndexFunction` | Add_SCIP_Cross_File_Function_Label.cypher |
| 79 | StaticField | Field | `:SemanticCodeIndexField` | Add_SCIP_Cross_File_Field_Label.cypher |
| 80 | StaticMethod | Method | `:SemanticCodeIndexFunction` | Add_SCIP_Cross_File_Function_Label.cypher |

## Special Cases

### Kind 61 (Variable - TypeScript/Python)
Kind 61 requires special handling as it can represent either:
- **Field**: When the descriptor matches the pattern `#name.` (e.g., `#field.`)
- **TypeAlias/TypeParameter**: For all other cases

The detection is performed by `is_base_field_descriptor(sym)` which checks if the descriptor ends with `#name.`

### Kind 7 (Class) with Abstract Detection
Classes with `abstract` in their signature text are mapped to `AbstractClass` instead of `Class`.

## Adding New Kinds

To add support for a new SCIP Kind:

1. **Update the mapping function** in `convertScipIndexToCsvForNeo4jCrossFileImport.sh`:
   - Add a new `elif kind == <number> then "<symbolType>"` clause to `code_unit_type_all()`

2. **Create a label query** in `domains/scip-index-import/queries/enrichment/`:
   - File: `Add_SCIP_Cross_File_<Name>_Label.cypher`
   - Pattern: Match nodes with the symbolType and add the corresponding label
   - Example:
     ```cypher
     // Add SemanticCodeIndexXyz label to cross-file internal symbols of xyz kind.
     // Requires "Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher".
     
     MATCH (n:SCIP:SemanticCodeIndexInternalSymbol)
     WHERE n.symbolType = 'Xyz'
       AND NOT n:SemanticCodeIndexXyz
     SET n:SemanticCodeIndexXyz
     RETURN count(*) AS labelledNodes
     ```

3. **Reference Documentation**:
   - SCIP Kind enum: https://scip-code.org/docs.html#symbol
   - Update this document with the new mapping

## External Symbols

External symbols (defined outside the analyzed codebase) use a subset of kinds and are handled by:
- `Add_SCIP_Cross_File_External_Type_Label.cypher`
- Maps to `:SemanticCodeIndexExternalType` label
- Filters for: Class, Interface, AbstractClass, Record, Struct, Enum, TypeAlias, Unknown

## Resources

- **SCIP Documentation**: https://scip-code.org/docs.html#symbol
- **Conversion Script**: `convertScipIndexToCsvForNeo4jCrossFileImport.sh`
- **Label Queries**: `domains/scip-index-import/queries/enrichment/Add_SCIP_Cross_File_*_Label.cypher`
