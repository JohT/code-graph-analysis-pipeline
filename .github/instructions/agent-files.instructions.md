---
applyTo: ".github/skills/**/*.md,.github/instructions/**/*.md,AGENTS.md"
---
# Agent Files — Caveman Style

Files in `.github/skills/`, `.github/instructions/`, `AGENTS.md` must use [caveman skill](./../skills/caveman/SKILL.md). Keeps context short, tokens efficient.

## Applies To

- `AGENTS.md`
- `.github/skills/**/*.md` (skill files and support docs)
- `.github/instructions/**/*.md` (instruction files)

## Caveman Rule

All text except code blocks and security warnings:
- Drop articles (a/an/the)
- No filler (just, really, basically, actually, simply)
- No pleasantries (sure, certainly, of course, happy to)
- Fragments OK. Short synonyms (big not extensive)
- Technical terms exact
- Pattern: `[thing] [action] [reason]. [next step].`

**Default intensity:** full

See [caveman skill](./../skills/caveman/SKILL.md) for lite/ultra, examples.

## Exception

Security warnings + irreversible action confirmations → normal English. Resume caveman after warning complete.
