---
applyTo: "**/*.gv,**/*.dot"
---
# GraphViz DOT Conventions

## File Format

- `.gv` extension (not `.dot`) — cleaner, no shell conflicts
- First line: `digraph <PascalCaseName> {` for directed graphs
- `rankdir=LR` — left-to-right flow (default: pipeline/process diagrams)
- `compound=true` for inter-cluster edges (with `lhead`/`ltail`)

## Style

- `fontname="Arial"` on graph, nodes, edges. Consistent rendering across platforms.
- Color hex uppercase: `#E3F2FD` not `#e3f2fd`
- `node [...]` block before first subgraph. Sets defaults.
- `edge [...]` block before first subgraph. Sets defaults.

## Clusters

- `subgraph cluster_<name> {` groups logic.
- Set `style="rounded,filled"` + `fillcolor` + `color` (border) + `penwidth=2` on clusters.
- Cluster label + font at top of subgraph block.
- `fontsize=12` cluster labels, `fontsize=11` node labels.

## Nodes

- `shape=ellipse` scripts/executables; `shape=box` data/resources/steps.
- Required dependencies: solid fill + strong color + white `fontcolor`.
- Optional dependencies: lighter fill + `style="filled,dashed"` + dark `fontcolor`.

## Edges

- Required flow: solid edge (default).
- Optional/conditional flow: `style=dashed`.
- Short `label=` describes flow (e.g., `"check"`, `"if needed"`, `"creates workspace"`).
- `constraint=false` edges don't influence rank/layout. Cross-cluster flow to shared outputs.

## Layout Hints

- `{ rank=same; nodeA; nodeB; }` aligns clusters on same row.
- Place rank hints at top—before subgraph blocks.

## Validation

Render to SVG to validate. Try `dot` CLI first; fall back to WASM wrapper:

```shell
# CLI (if dot installed)
dot -Tsvg <file>.gv -o <file>.svg

# Via project render script
source ./scripts/visualization/renderGraphVizSVG.sh <file>.gv
```

`scripts/analysis/` diagrams: use combined render script:

```shell
./scripts/analysis/renderDocumentationGraphs.sh
```

Syntax errors → empty/broken SVG. Check SVG contains expected node labels.
