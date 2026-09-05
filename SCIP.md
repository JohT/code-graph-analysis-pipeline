# SCIP-Based Multi-Language Analysis

The pipeline supports multi-language static code analysis via [SCIP](https://github.com/sourcegraph/scip) (Semantic Code Intelligence Protocol). SCIP enables type graph analysis for languages beyond Java and TypeScript, including Go, Rust, C++, Ruby, Python, and C#.

## Supported Languages

| Language   | SCIP Indexer                                                                 |
|------------|------------------------------------------------------------------------------|
| Java       | [scip-java](https://github.com/sourcegraph/scip-java)                        |
| TypeScript | [@sourcegraph/scip-typescript](https://www.npmjs.com/package/@sourcegraph/scip-typescript) |
| Go         | [scip-go](https://github.com/sourcegraph/scip-go)                            |
| Rust       | [rust-analyzer](https://rust-analyzer.github.io/)                            |
| C++        | [scip-clang](https://github.com/sourcegraph/scip-clang)                      |
| Ruby       | [scip-ruby](https://github.com/sourcegraph/scip-ruby)                        |
| Python     | [scip-python](https://github.com/sourcegraph/scip-python)                    |
| C#         | [scip-dotnet](https://github.com/sourcegraph/scip-dotnet)                    |

## How It Works

1. You generate a SCIP index **outside the pipeline** (see workflow below).
2. You place the `.scip.json` file(s) in the `indices/` directory of your analysis workspace.
3. `analyze.sh` detects the files automatically and imports them into Neo4j before running reports.

The pipeline creates `:SCIP:SemanticCodeIndexInternalType` and `:SCIP:SemanticCodeIndexExternalType` nodes with `DEPENDS_ON` relationships, fully compatible with archetype, cyclic dependency, and external dependency analyses.

## User Workflow

### Prerequisites

- [scip CLI](https://github.com/scip-code/scip/releases). Required for JSON conversion (see install instructions below)
- Language-specific SCIP indexer (see table above)

### Step-by-Step

```shell
# 1. Install the scip CLI (used to convert binary SCIP to JSON)
#    Download from: https://github.com/scip-code/scip/releases
#    Or use the helper script from the domain (installs to analysis workspace by default):
domains/scip-index-import/installScipCli.sh

# 2. Install a language-specific SCIP indexer
#    TypeScript example:
npm install --save-dev @sourcegraph/scip-typescript

# 3. Generate the binary SCIP index (in your project directory)
./node_modules/.bin/scip-typescript index
#    → produces: index.scip

# 4. Convert the binary index to JSON
scip print --json index.scip > index.scip.json

# 5. Initialize your analysis workspace (if not already done)
./init.sh my-project

# 6. Place the JSON index in the indices/ directory
cp index.scip.json temp/my-project/indices/my-project.scip.json

# 7. Run the pipeline — SCIP import runs automatically
cd temp/my-project
./analyze.sh
```

### TypeScript Full Example

The repository ships with a ready-to-use example for analyzing react-router via SCIP:

```shell
# Requires: Node.js 18+, pnpm, curl, jq, NEO4J_INITIAL_PASSWORD
export NEO4J_INITIAL_PASSWORD=your-password
./scripts/examples/analyzeReactRouterScip.sh
```

This script downloads react-router, generates a SCIP index, converts it to JSON, and runs the full pipeline.

## Multiple Index Files

Place multiple `.scip.json` files in `indices/` to import several codebases at once:

```text
temp/my-project/indices/
  service-a.scip.json
  service-b.scip.json
  shared-lib.scip.json
```

The pipeline merges them automatically: node symbols are deduplicated; edge reference counts from the same symbol pair are summed.

## Environment Variables

| Variable           | Default    | Description                                           |
|--------------------|------------|-------------------------------------------------------|
| `INDICES_DIRECTORY`| `indices`  | Directory containing `*.scip.json` files for import   |

## Validation

The pipeline validates `indices/` on startup:

- **Non-JSON files** (e.g. binary `.scip` files) cause an immediate error with instructions.
- **No `*.scip.json` files + no `artifacts/` + no `source/`** → pipeline exits with "nothing to analyze".

If you pass a binary `.scip` file by mistake, convert it first:

```shell
scip print --json index.scip > index.scip.json
```

## Performance

For the **initial import** (empty database), the pipeline uses `neo4j-admin database import full` **before Neo4j starts** when all conditions are met (Neo4j v5+, `neo4j-admin` executable, indices changed). This writes the native store format directly. Measurably faster than LOAD CSV for large indices.

The pipeline automatically:

- Stops Neo4j if it's running (required for admin import)
- Performs a fast `neo4j-admin database import full` import
- Falls back gracefully to LOAD CSV if any issues occur
- Uses Cypher-based cleanup (not filesystem manipulation) for any data re-import

On repeat runs (unchanged index) or when the fast path fails, the regular LOAD CSV path runs as a fallback.

See [domains/scip-index-import/README.md](domains/scip-index-import/README.md#fast-import-via-neo4j-admin) for full details.

## Known Limitations

### SCIP-Java Only Captures Explicit Type References

**Limitation**: SCIP-Java (and other SCIP indexers) only captures **explicit type references** in source code. This means:

- ✅ **Captured**: Direct method calls, field access, type annotations, inheritance declarations

  ```java
  MyClass obj = new MyClass();           // ✅ captured
  obj.method();                          // ✅ captured
  List<String> list;                     // ✅ captured
  class Child extends Parent { }         // ✅ captured
  ```

- ❌ **Not captured**: Implicit or compiler-generated references
  - Inner class access to outer class members (implicit `this` binding)
  - Javadoc `@link` or `@see` tags (documentation references)
  - Reflection-based references
  - Metaprogramming constructs

### Inner Class Dependencies Are Incomplete

**Impact**: Non-static inner classes do not record dependencies on their enclosing class, even though they have implicit access to all private members at runtime.

**Example**:

```java
class Coordinator {
    private EventSource eventSource;
    private TokenStore tokenStore;
    
    // Inner class can access all Coordinator private members implicitly
    private class CoordinationTask implements Runnable {
        public void run() {
            eventSource.getEvents();      // Implicit access via compiler-generated Coordinator.this
            tokenStore.store(token);      // Not visible as explicit reference in SCIP
        }
    }
}
```

In the SCIP index:

- ✅ `Coordinator → CoordinationTask` edge exists (explicit instantiation)
- ❌ `CoordinationTask → Coordinator` edge **missing** (implicit dependency not recorded)

**Implications**:

- Dependency graphs are incomplete for nested class structures
- Cycle detection may miss cycles that involve inner classes
- Architecture analysis may undercount dependencies in codebases with heavy use of inner classes

**Workaround**: Consider refactoring inner classes to package-private or public top-level classes if dependency tracking is critical for your analysis.

### Anonymous Inner Class Names won't necessarily match between Java and SCIP

**Limitation**: Anonymous inner classes in Java are assigned names like `OuterClass$1`, `OuterClass$2`, etc. However, SCIP is imported as `OuterClass$anonymous0`, `OuterClass$anonymous1`, etc., with no guaranteed matching numbers.

**Impact**: Dependencies involving anonymous inner classes may appear missing in SCIP data when trying to match by name between Java and SCIP.

**Workaround**: There is no reliable workaround other than being aware of this limitation when analyzing dependencies involving anonymous inner classes.

### JavaDoc References

**Limitation**: References in Javadoc comments using `@link` or `@see` tags are not captured as dependencies in SCIP.

**Impact**: Dependencies that are only mentioned in documentation may appear missing in SCIP data.

**Workaround**: There is no direct workaround; consider adding explicit code references if tracking these dependencies is important.

## Troubleshooting

**`jq` not found**

```shell
convertScipIndexToCsvForNeo4jImport: Error: jq is required but not found in PATH.
Install jq: brew install jq (macOS) or apt-get install jq (Linux).
```

→ Install `jq`.

**Binary `.scip` file in `indices/`**

```shell
analyze: Error: INDICES_DIRECTORY 'indices' contains unsupported files (only *.scip.json allowed)
```

→ Convert with `scip print --json index.scip > index.scip.json` then remove the binary.

**`scip print` not found**

```shell
scip: command not found
```

→ Download the scip CLI binary from [github.com/scip-code/scip/releases](https://github.com/scip-code/scip/releases) or run `domains/scip-index-import/installScipCli.sh`.

## Skipping SCIP Import

Pass `--exclude-domain scip-index-import` to skip SCIP import even if `indices/` is non-empty:

```shell
analyze.sh --exclude-domain scip-index-import
```

## GitHub Actions Integration

Use the `indices-upload-name` input of `public-analyze-code-graph.yml` to pass a pre-generated SCIP JSON artifact:

```yaml
jobs:
  generate-scip-index:
    # ... generates index.scip.json and uploads it as 'my-scip-index'
  analyze:
    uses: JohT/code-graph-analysis-pipeline/.github/workflows/public-analyze-code-graph.yml@main
    with:
      analysis-name: my-project-1.0.0
      indices-upload-name: my-scip-index
```

See [`.github/workflows/internal-scip-index-code-example.yml`](.github/workflows/internal-scip-index-code-example.yml) for a full end-to-end CI example.
