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
- Enable strict mode immediately after: `set -o errexit -o pipefail -o nounset`
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

## Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Ask before improving adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Ask before removing pre-existing dead code

The test: Every changed line should trace directly to the user's request.

## Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.