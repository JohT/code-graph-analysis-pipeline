---
applyTo: "**/README.md,COMMANDS.md,CHANGELOG.md,INTEGRATION.md,MIGRATION.md,SCIP.md,**/PREREQUISITES.md"
---
# Documentation Conventions

Applies to README.md (any folder), COMMANDS.md, CHANGELOG.md,
INTEGRATION.md, MIGRATION.md, SCIP.md, PREREQUISITES.md (any folder).

## Language & Tone

- **No abbreviations** except universally known ones: AI, CI/CD,
  SQL, JSON, CSV, REST, API. Write first occurrence with full name:
  "Java Virtual Machine (JVM)"
- **Brief and concise** without sacrificing clarity. Short sentences,
  active voice, enumerated lists, keywords
- **Include "why"** when introducing concepts, commands, or design
  decisions. Readers understand faster with context
- **No em dashes**. Use periods or hyphens instead. "Configure memory
  settings. Required for large repositories" not with em dash
- **Use examples** for instructions and non-obvious features. Show
  output, command flags, expected behavior
- **Use US spelling** like "analyze" instead of "analyse".

## Structure

- **Clear headings** that describe content, not generic titles.
  "Installation Requirements" not "Setup"
- **Short paragraphs** (2-4 sentences). Break prose with bullet lists
  when explaining multiple related items
- **One idea per list item**. Avoid explanatory prose in bullets
- **Code blocks** with language tags: ` ```bash `, ` ```json `,
  ` ```cypher `
- **Links inline** when referenced document is essential. Use markdown
  format: `[display text](relative/path.md)`

## Specificity

- **Name concepts precisely**. "Git repository" not "repo". "Command
  line" not "CLI" (except in headings). "Neo4j server" not "server"
- **Version numbers and defaults explicitly**. "Python 3.10+" not
  "Python 3+". "Default: 4GB" not "Configurable memory"
- **Exact file paths** when referring to configuration or domains. Use
  backticks: `scripts/analysis/analyze.sh`, `domains/anomaly-detection/`
- **Avoid pronouns** in procedural docs. "Run the command" not "You can
  run". Clearer for translation and scanning

## Quality Checks

Run markdownlint before committing:

```bash
npx --yes markdownlint-cli2 \
  README.md COMMANDS.md
```

Checks syntax, link validity, heading consistency, spacing. Fix
warnings. Errors block merge.