# Render Graph Visualizations

This [node.js](https://nodejs.org/de) project provides the script [renderVisualizations.js](./renderVisualizations.js) to save all graph visualizations as image files.  
[renderVisualizations.js](./renderVisualizations.js) uses these three steps:

- opens every HTML file with [Puppeteer](https://pptr.dev) in a headless browser
- takes screenshots of all contained [HTML5 Canvas elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/canvas?retiredLocale=de)
- saves them as [PNG](https://en.wikipedia.org/wiki/PNG) files in the current directory

## Example

If the current working directory is e.g. `temp/projectname/reports/graph-visualizations` within this repository,
then the command would look like this:

```shell
node ./../../../../graph-visualization/renderVisualizations
```
