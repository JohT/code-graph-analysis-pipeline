# Render Graph Visualizations

This [node.js](https://nodejs.org/de) project provides the script [renderVisualizations.js](./renderVisualizations.js) to render all graph visualizations as image files.  

## Prerequisites

- Run `npm ci` in this directory to download all necessary dependencies.

## How it works

[renderVisualizations.js](./renderVisualizations.js) uses these three steps:

- Opens every HTML file in this directory and its subdirectories with [Puppeteer](https://pptr.dev) in a headless browser
- Takes screenshots of all contained [HTML5 Canvas elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/canvas?retiredLocale=de)
- Creates a directory with the name of the HTML converted to snake case in the current directory
- Saves all screenshots as [PNG](https://en.wikipedia.org/wiki/PNG) files into that newly created directory

## How to run it in the CLI

Under the assumption that your current working directory is `temp/projectname/reports/graph-visualizations` in the root directory of this repository, then the command would look like this:

```shell
node ./../../../../graph-visualization/renderVisualizations
```

## How to open it in the browser

- Open one of the HTML files in the Browser using `file://` prefix followed by the full path or using a Live Server.
- Enter the password for the local Neo4j database `neo4j` that you have chosen as initial password.
- Wait until the orange frames turn green and use drag'n'drop or scrolling to see the part of the Graph you're interested in.
- Currently, the frames are intentionally very large to get a practicable resolution for saving the images. This might get refined in future.

## Scripts

- [renderVisualizations.js](./renderVisualizations.js) is the main Node.js script that renders the Graph Visualizations using a Command Line Interface (CLI)
- [vis-configuration-presets.js](./vis-configuration-presets.js) contains functions that return predefined visualization configurations. Currently (May 2024), there is only one configuration for visualizing hierarchical, topology sorted Graphs.
- [visualization-pagination.js](./visualization-pagination.js) provides pagination for visualizing large Graphs by splitting them up into smaller Subgraphs all in separate images.