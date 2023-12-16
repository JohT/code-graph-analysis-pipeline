/**
 * Splits a large Graph into multiple smaller ones with query pagination to be able visualize them.
 * Uses {@link https://github.com/neo4j-contrib/neovis.js|neovis.js}
 * on top of {@link https://visjs.github.io/vis-network/docs/network/|vis-network.js}.
 *
 * @param {Object} parameters - The parameters for the paginated visualization using neovis.js on top of vis-network.js.
 * @param {string} parameters.containerElementId - The id of the main container element (typically a div) where all visualizations will be drawn into.
 * @param {Object} parameters.neoVizConfiguration - {@link https://neo4j-contrib.github.io/neovis.js/interfaces/NeovisConfig.html|NeovisConfig} object. The containerId will be overwritten so it can be left out or filled with an empty string.
 * @param {string} [parameters.maxVisualizations=100] - Maximal number of visualizations (pages)
 * @param {string} [parameters.recordsPerVisualization=160] - Maximal numbers of records per visualization (page/block size)
 * @param {string} [parameters.idPrefixOfIndexedVisualizationElement="vis"] - Element id prefix for every indexed visualization element. It is then followed by the index number.
 * @param {string} [parameters.classOfIndexedVisualizationElement="indexedVisualization"] - CSS class name for every indexed visualization element
 * @param {string} [parameters.classOfFinishedVisualization="visualization-finished"] - CSS class name for finished visualizations (might be successful or failed)
 * @param {string} [parameters.classOfFailedVisualization="visualization-failed"] - CSS class name for failed visualizations containing an error message
 */
function paginatedGraphVisualization({
  containerElementId,
  neoVizConfiguration,
  maxVisualizations = 100,
  recordsPerVisualization = 160,
  idPrefixOfIndexedVisualizationElement = "vis",
  classOfIndexedVisualizationElement = "indexedVisualization",
  classOfFinishedVisualization = "visualization-finished",
  classOfFailedVisualization = "visualization-failed",
}) {
  /**
   * Marks the given element as finished when the visualization is completed.
   * @param {Element} indexedVisualizationElement
   * @param {string} logDescription
   */
  function markVisualizationAsFinished(indexedVisualizationElement, logDescription) {
    indexedVisualizationElement.classList.add(classOfFinishedVisualization);
    const unfinishedVisualizations = document.querySelectorAll(`.${classOfIndexedVisualizationElement}:not(.${classOfFinishedVisualization})`);
    if (unfinishedVisualizations.length === 0) {
      console.debug(`${logDescription}: Last visualization finished on element ${JSON.stringify(indexedVisualizationElement)}.`);
      console.debug(`${logDescription}: Mark whole visualization as finished on parent element ${JSON.stringify( indexedVisualizationElement.parentElement)}`);
      indexedVisualizationElement.parentElement.classList.add(classOfFinishedVisualization);
    }
  }

  const containerElement = document.getElementById(containerElementId);

  for (let index = 0; index < maxVisualizations; index++) {
    const indexedVisualizationContainer = document.createElement("div");
    indexedVisualizationContainer.id = `${idPrefixOfIndexedVisualizationElement}-${index}`;
    indexedVisualizationContainer.classList.add(classOfIndexedVisualizationElement);
    containerElement.appendChild(indexedVisualizationContainer);

    const config = { ...neoVizConfiguration, containerId: indexedVisualizationContainer.id };
    const neoViz = new NeoVis.default(config);

    neoViz.registerOnEvent(NeoVis.NeoVisEvents.CompletionEvent, (event) => {
      if (event.recordCount == 0) {
        if (index=0) {
          log.error('No query results. Nothing to visualize. Check the query and if the nodes and properties have been written.')
        }
        indexedVisualizationContainer.remove(); // remove an empty canvas
        markVisualizationAsFinished(indexedVisualizationContainer, 'No query results (anymore)');
      } else {
        setTimeout(() => {
          neoViz.stabilize();
          markVisualizationAsFinished(indexedVisualizationContainer, 'Visualization stabilized');
        }, 5000);
      }
    });
    neoViz.registerOnEvent(NeoVis.NeoVisEvents.ErrorEvent, (event) => {
      indexedVisualizationContainer.classList.add(classOfFailedVisualization);
      indexedVisualizationContainer.textContent = event.error.message;
      console.error(`Visualization Error: ${JSON.stringify(event.error)}`)
      markVisualizationAsFinished(indexedVisualizationContainer, 'Error event');
    });
    const parameters = {
      blockSize: recordsPerVisualization,
      startIndex: index * recordsPerVisualization,
      endIndex: (index + 1) * recordsPerVisualization,
    };
    neoViz.render(undefined, parameters);
  }
}
