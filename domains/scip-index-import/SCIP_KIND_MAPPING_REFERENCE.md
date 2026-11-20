# SCIP Kind Mapping Reference

This document clarifies Neo4j label semantics and stability expectations for SCIP-imported symbols.

## Label Categories

### 1. Volatile Labels (Symbol-Type Derived)

These labels are **automatically derived** from the `symbolType` property via dynamic label enrichment. They are prefixed with an underscore (`_`) to signal volatility and instability.

**Cross-file mode**: Each node receives a label named `_SemanticCodeIndex<SymbolType>` (e.g., `_SemanticCodeIndexFunction`, `_SemanticCodeIndexField`)
**Kind-level mode**: Hardcoded labels without underscore (e.g., `SemanticCodeIndexFunction`) are applied at import time

**Stability**: ⚠️ **VOLATILE** — Do not use in stability-critical queries.

**Use cases**:
- Ad-hoc exploration and filtering
- Node coloring and visualization
- Dynamic aggregation and grouping by symbolType

**Why volatile**:
- SCIP kind mappings may evolve across language versions
- Symbol type extraction logic may be refined
- Adding a new symbol type requires no code change (automatic label via dynamic labeling)
- These labels are ephemeral metadata, not business entities
- The underscore prefix (`_`) explicitly marks them as unstable

**Note**: The underscore prefix is only used in cross-file mode (current feature branch). Kind-level mode (existing, already released) uses labels without underscore for backward compatibility. Both modes converge on stable aggregated labels for queries.

### 2. Stable Aggregated Labels

These labels are **explicitly defined** and group multiple symbol types under a single, stable business concept. They are added via dedicated enrichment queries and are safe for stability-critical queries.

**Stability**: ✅ **STABLE** — Safe for reporting and long-term queries.

#### `SemanticCodeIndexInternalExecutable`
- **Members**: Function, Method, Constructor, AbstractMethod, Getter, Setter
- **Semantics**: Runtime executable code (methods, functions, constructors, accessors)
- **Added by** (cross-file): `Add_SCIP_Cross_File_Internal_Executable_Label.cypher`
- **Added by** (kind-level): `Add_SCIP_Kind_Level_Internal_Executable_Label.cypher`
- **Stability**: ✅ **STABLE** — Safe for all queries regardless of import mode
- **Note**: Excludes compile-time constructs like Macro

#### `SemanticCodeIndexInternalType`
- **Members**: Class, Interface, AbstractClass, Record, Struct, Enum, File, AnonymousClass
- **Semantics**: Type definitions
- **Added by**: `Add_SCIP_Cross_File_Internal_Type_Label.cypher`
- **Stability**: ✅ **STABLE** (preserved from earlier enrichment)

#### `SemanticCodeIndexExternalType`
- **Members**: External type definitions from imported packages
- **Semantics**: Types outside the analyzed codebase
- **Added by**: `Add_SCIP_Cross_File_External_Type_Label.cypher`
- **Stability**: ✅ **STABLE** (preserved from earlier enrichment)

### 3. Core Structural Labels

These labels identify the primary entity type and are never removed. They are inherited from import and form the basis of the data model.

- `:SCIP` — All SCIP-imported nodes
- `:SemanticCodeIndexInternalSymbol` — All internal cross-file symbols
- `:SemanticCodeIndexExternalSymbol` — All external symbols
- `:SemanticCodeIndexProject`, `:SemanticCodeIndexArtifact`, `:SemanticCodeIndexModule` — Structural containers

**Stability**: ✅ **STABLE** — Never change.

## SCIP Kind to symbolType Mapping

The `code_unit_type_all()` function in `convertScipIndexToCsvForNeo4jCrossFileImport.sh` maps SCIP Kind numbers to human-readable `symbolType` values. These values are stored as properties and used by enrichment queries to assign Neo4j labels.

### Mapping Table

**Column Note**: "Volatile Label" shows cross-file labels with underscore prefix (e.g., `_SemanticCodeIndexFunction`). Kind-level imports use the same names without underscore for backward compatibility.

| Kind | Name | symbolType | Volatile Label (Cross-File) | Stable Label | Notes |
|------|------|-----------|-------|---|---|
| 7 | Class | Class | `_SemanticCodeIndexClass` | `SemanticCodeIndexInternalType` | Abstract variant mapped to AbstractClass |
| 8 | Constant | Variable | `_SemanticCodeIndexVariable` | — | Module-level constant |
| 9 | Constructor | Constructor | `_SemanticCodeIndexConstructor` | `SemanticCodeIndexInternalExecutable` | |
| 11 | Enum | Enum | `_SemanticCodeIndexEnum` | `SemanticCodeIndexInternalType` | |
| 12 | EnumMember | EnumMember | `_SemanticCodeIndexEnumMember` | — | Member of enum |
| 17 | Function | Function | `_SemanticCodeIndexFunction` | `SemanticCodeIndexInternalExecutable` | Top-level function |
| 18 | Getter | Getter | `_SemanticCodeIndexGetter` | `SemanticCodeIndexInternalExecutable` | Property getter accessor |
| 21 | Interface | Interface | `_SemanticCodeIndexInterface` | `SemanticCodeIndexInternalType` | |
| 25 | Macro | Macro | `_SemanticCodeIndexMacro` | — | Compile-time code generation |
| 26 | Method | Method | `_SemanticCodeIndexMethod` | `SemanticCodeIndexInternalExecutable` | |
| 35 | Package | Package | `_SemanticCodeIndexPackage` | — | No stable mapping |
| 41 | Property | Property | `_SemanticCodeIndexProperty` | — | Object property (TypeScript/JavaScript) |
| 49 | Struct | Struct | `_SemanticCodeIndexStruct` | `SemanticCodeIndexInternalType` | |
| 54 | TypeAlias | TypeAlias | `_SemanticCodeIndexTypeAlias` | — | Type alias definition |
| 55 | TypeAlias (Rust) | TypeAlias | `_SemanticCodeIndexTypeAlias` | — | Rust-specific type alias |
| 61 | Variable | Field/TypeAlias | `_SemanticCodeIndexField` or `_SemanticCodeIndexTypeAlias` | — | Language-specific interpretation |
| 66 | AbstractMethod | AbstractMethod | `_SemanticCodeIndexAbstractMethod` | `SemanticCodeIndexInternalExecutable` | Abstract method/interface method |
| 67 | MethodSpecification | AbstractMethod | `_SemanticCodeIndexAbstractMethod` | `SemanticCodeIndexInternalExecutable` | Abstract method specification |
| 79 | StaticField | Field | `_SemanticCodeIndexField` | — | Class field/static member |
| 80 | StaticMethod | Method | `_SemanticCodeIndexMethod` | `SemanticCodeIndexInternalExecutable` | Static method |

## Special Cases

### Kind 61 (Variable - TypeScript/Python)
Kind 61 requires special handling as it can represent either:
- **Field**: When the descriptor matches the pattern `#name.` (e.g., `#field.`)
- **TypeAlias/TypeParameter**: For all other cases

The detection is performed by `is_base_field_descriptor(sym)` which checks if the descriptor ends with `#name.`

### Kind 7 (Class) with Abstract Detection
Classes with `abstract` in their signature text are mapped to `AbstractClass` instead of `Class`.

## Migrating Queries to Use Stable Labels

If you have existing queries that filter by volatile symbol-type labels, migrate them to use stable aggregated labels for long-term maintainability.

### Before (Volatile – Cross-File Mode)
```cypher
MATCH (f:_SemanticCodeIndexFunction)
RETURN count(f) AS functionCount
```

### Before (Volatile – Kind-Level Mode)
```cypher
MATCH (f:SemanticCodeIndexFunction)
RETURN count(f) AS functionCount
```

### After (Stable – Both Modes)
```cypher
MATCH (e:SemanticCodeIndexInternalExecutable)
RETURN count(e) AS executableCount
```

**Benefit**: The same stable query works regardless of import mode (cross-file or kind-level).

Or if you need to distinguish Function from Method:
```cypher
MATCH (s:SemanticCodeIndexInternalSymbol)
WHERE s.symbolType IN ['Function', 'Method']
RETURN count(s) AS callableCount
```

## Using Volatile Labels Safely (Cross-File Mode Only)

Volatile labels (prefixed with `_`) are safe for temporary purposes and development when using cross-file SCIP import:

```cypher
-- Ad-hoc: Debug by symbol type (cross-file mode)
MATCH (n:_SemanticCodeIndexField)
RETURN n.name, n.file

-- Ad-hoc: Visualize nodes colored by symbol type (cross-file mode)
MATCH (n:_SemanticCodeIndexVariable)
RETURN n LIMIT 100
```

**For stable queries that work across both import modes, use aggregated labels:**

```cypher
-- Cross-file mode
MATCH (n:_SemanticCodeIndexFunction)
RETURN count(n)

-- Kind-level mode
MATCH (n:SemanticCodeIndexFunction)
RETURN count(n)

-- Both modes (RECOMMENDED for reporting queries)
MATCH (n:SemanticCodeIndexInternalExecutable)
RETURN count(n)
```

## Import Mode Differences

### Cross-File Mode (Current Feature Branch)

**Volatile Labels**: Dynamic symbol-type labels prefixed with underscore (e.g., `_SemanticCodeIndexFunction`)
- Signal volatility and non-stability
- For ad-hoc queries, visualization, and temporary exploration only
- Generated by: `Add_SCIP_Cross_File_Symbol_Type_Label.cypher`

**Stable Aggregated Label**: `SemanticCodeIndexInternalExecutable`
- Members: Function, Method, AbstractMethod, Constructor, Getter, Setter
- Generated by: `Add_SCIP_Cross_File_Internal_Executable_Label.cypher`

### Kind-Level Mode (Existing, Already Released)

**Volatile Labels**: Hardcoded labels without underscore (e.g., `SemanticCodeIndexFunction`)
- No underscore prefix (applied at import time, not generated)
- Used by existing analyses and scripts
- Cannot be changed due to backward compatibility

**Stable Aggregated Label**: `SemanticCodeIndexInternalExecutable`
- Members: Function (mapped to executable by enrichment query)
- Generated by: `Add_SCIP_Kind_Level_Internal_Executable_Label.cypher`

### Design Rationale

Both import modes use **different conventions for volatile labels** but **converge on the same stable labels** for reporting:

```
┌─────────────────────────────────┬─────────────────────────────────┐
│      Cross-File Mode            │      Kind-Level Mode            │
├─────────────────────────────────┼─────────────────────────────────┤
│ Volatile: _SemanticCodeIndex... │ Volatile: SemanticCodeIndex...  │
│ Stable: SemanticCodeIndex...    │ Stable: SemanticCodeIndex...    │
└─────────────────────────────────┴─────────────────────────────────┘
           ↓                                    ↓
┌─────────────────────────────────────────────────────────────────────┐
│    All Reporting Queries Use: SemanticCodeIndexInternalExecutable   │
│    (Single stable API works for both import modes)                  │
└─────────────────────────────────────────────────────────────────────┘
```

**Benefit**: Underscore prefix signals volatility in new code (cross-file), while existing code (kind-level) is unaffected. All reporting queries are decoupled from the underlying import mode.

## Adding New Kinds

To add support for a new SCIP Kind:

1. **Update the mapping function** in `convertScipIndexToCsvForNeo4jCrossFileImport.sh`:
   - Add a new `elif kind == <number> then "<symbolType>"` clause to `code_unit_type_all()`

2. **The volatile label will be created automatically** via `Add_SCIP_Cross_File_Symbol_Type_Label.cypher` — no query file needed.

3. **If this symbol type should be in a stable aggregated label** (e.g., part of "InternalExecutable"), create or update the corresponding stable label enrichment query:
   - File: `domains/scip-index-import/queries/enrichment/Add_SCIP_Cross_File_Internal_<Name>_Label.cypher`
   - Add the new symbolType to the WHERE clause

4. **Reference Documentation**:
   - SCIP Kind enum: https://scip-code.org/docs.html#symbol
   - Update this document with the new mapping

## External Symbols

External symbols (defined outside the analyzed codebase) use a subset of kinds and are handled by:
- `Add_SCIP_Cross_File_External_Type_Label.cypher`
- Maps to `:SemanticCodeIndexExternalType` stable label
- Filters for: Class, Interface, AbstractClass, Record, Struct, Enum, TypeAlias, Unknown

## Resources

- **SCIP Documentation**: https://scip-code.org/docs.html#symbol
- **Conversion Script**: `convertScipIndexToCsvForNeo4jCrossFileImport.sh`
- **Dynamic Label Enrichment**: `Add_SCIP_Cross_File_Symbol_Type_Label.cypher`
- **Stable Label Enrichment**: `Add_SCIP_Cross_File_Internal_*.cypher` files
