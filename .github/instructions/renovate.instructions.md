---
applyTo: "renovate.json"
---
# Renovate Config Conventions

## Valid JSON

File must be valid JSON. No trailing commas. Validate with:

```shell
npx --yes --package renovate -- renovate-config-validator
```

## $schema

Top-level field must have schema reference:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json"
}
```

## customManagers

Each entry requires:

- `"customType": "regex"` — mandatory for regex managers
- `"description"` — short human-readable string. State what updated, where.

Example:

```json
{
  "description": "Update NEO4J_VERSION constant in shell scripts",
  "customType": "regex",
  "fileMatch": ["^scripts/[^/]*\\.sh$"],
  "matchStrings": ["NEO4J_VERSION:-\\\"?(?<currentValue>.*?)\\\""]
}
```

## packageRules

Each entry requires:

- `"description"` — short string. Clarify rule purpose.

Example:

```json
{
  "description": "Keep Python ML libraries in sync",
  "matchDatasources": ["pypi"],
  "matchPackageNames": ["scikit-**", "umap-learn"],
  "groupName": "python-machine-learning-libs"
}
```

## Escaping

Use `\\` in `matchStrings` + `fileMatch`. Single `\` → invalid JSON.

- `.` → `\\.`
- `"` → `\\\"`
