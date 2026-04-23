---
applyTo: "**/*.cypher"
---
# Cypher Query Conventions

## Style

- **First line: description comment** — format: `// Description sentence. Requires "Other_Query.cypher".`
  Used in generated [CYPHER.md](../../CYPHER.md) reference
- Blank line between comment and statement
- One statement per file — no combining without explicit approval
- Standard Cypher where possible. Use APOC sparingly — confirm with user first
- Parameterize with `$parameterName`
- Keywords uppercase: `MATCH`, `WHERE`, `RETURN`, `WITH`, `SET`, `ORDER BY`, `LIMIT`, etc.
- Literals lowercase: `null`, `true`, `false`
- Each clause own line — no inline chaining
- `ORDER BY` and `LIMIT` on own lines
- Single quotes for strings: `'value'` not `"value"`
- No semicolons at end

## Naming

- Files: `Snake_Case_Description.cypher`
- Node labels: `PascalCase`
- Relationship types: `UPPER_SNAKE_CASE`
- Properties: `camelCase`
- No backtick-quoted identifiers — use clean label/property names

## Spacing

- One space between label predicate and property predicate: `(n:Label {prop: 1})`
- Space after each comma: `a, b, c` not `a,b,c`
- Wrapping space around operators: `a <> b`, `p = (s)-->(e)`
- No padding space inside function calls: `count(n)` not `count( n )`

## Patterns

- Anonymous nodes/rels when variable unused: `[:LIKES]` not `[r:LIKES]`

## Verification

Before finalizing, verify against live Neo4j. Catches syntax errors, warnings.
Requires Neo4j running — use [neo4j-management skill](./../skills/neo4j-management/SKILL.md) first.

```shell
# From repo root — NEO4J_INITIAL_PASSWORD must be exported
./scripts/executeQuery.sh <path/to/query.cypher>
```

- Empty result ≠ broken query — data may be absent
- `executeQueryFunctions.sh` for script composition only — not for ad-hoc verification
