---
applyTo: "**/*.sh"
---
# Shell Script Conventions

Target: **bash**. Must work on macOS, Linux, Windows (WSL/Git Bash).

## Header

- **First line: description comment** — used by [SCRIPTS.md](../../SCRIPTS.md). Format: `# Description sentence. Requires "other_script.sh".`
- Include required env vars, required tools, usage examples in description or `usage()` function
- Blank line after initial comment before code starts

## Shebang and Strict Mode

- First executable line: `#!/usr/bin/env bash`
- Enable strict mode immediately after: `set -euo pipefail`
- Set safe word-splitting: `IFS=$'\n\t'`
- `pipefail` propagates pipe failures — `set -e` bypassed in subshells and command groups; document where this applies

## Style

- POSIX-compliant as reasonable
- Always `"${variable}"` — curly braces + double quotes on every expansion
- Use `$(...)` for command substitution — not backticks
- No abbreviations. Write out variable and function names. `i`, `j`, `k` for indices OK
- Prefer named functions over code block comments. Comments explain *why*, not *what*
- Split into meaningful functions — ideally pure, easy to reason about
- Apply basic functional programming where it improves readability (piping, composition)

## Naming

- No generic names — no "util", "helper", "common", "shared"
- DRY only for domain-related concerns. Don't extract one-off operations

## Variables and Scope

- `local` for function-scoped variables
- `readonly` for constants
- `${VAR:-default}` for defaults
- `[[ ]]` over `[ ]`
- Quote all paths: `"${directory}/${filename}"`

## Argument Parsing

- Provide `usage()` — list parameters, flags, env vars, copy-pastable examples with expected output
- Support at minimum `--help` (print `usage()`, exit 0)
- Support `--dry-run` for destructive or irreversible operations

## Dependency Checks

- Check required tools early: `command -v <tool> || { echo "Install <tool>: <url>"; exit 1; }`

## Portability

- Prefer POSIX idioms; guard GNU vs BSD differences explicitly
- `sed -i` requires empty suffix on macOS: `sed -i ''` vs Linux `sed -i`
- `date -d` GNU only — use `date -v` on macOS or detect OS and branch

## Error Handling and Exit Codes

- Trap `ERR`/`EXIT` for cleanup and meaningful error messages
- Return meaningful non-zero exit codes — document semantics in `usage()`

## Security

- No `eval` — use arrays, named variables, or functions
- Sanitize external inputs before use in commands or filenames
- Never log or write secrets to temp files
- Use `mktemp` for temp files; restrict permissions with `chmod 600` or `umask 077`
- Clean up temp files in `trap ... EXIT`

## Linting, Formatting, and CI

- Verify all scripts with `shellcheck`; run in CI
- Format with `shfmt`; run in CI
- Document `shellcheck` exceptions inline with justification: `# shellcheck disable=SC2xxx — reason`
- Test scripts: name with prefix `test` (e.g. `testMyFeature.sh`) — `runTests.sh` auto-discovers in `scripts/` and `domains/` dirs
