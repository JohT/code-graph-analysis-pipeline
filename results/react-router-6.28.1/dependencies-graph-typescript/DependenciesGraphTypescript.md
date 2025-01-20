## Artifact Dependencies

This report includes graph visualization(s) using JavaScript and might not be exportable to some document formats.

### References

- [neovis.js (GitHub)](https://github.com/neo4j-contrib/neovis.js)
- [vis-network (GitHub)](https://github.com/visjs/vis-network)
- [vis network documentation](https://visjs.github.io/vis-network/docs/network)
- [Neo4j Graph Algorithms Jupyter Notebooks (GitHub)](https://github.com/neo4j-graph-analytics/graph-algorithms-notebooks)
- [Neo4j Graph Data Science Topological Sort](https://neo4j.com/docs/graph-data-science/current/algorithms/alpha/topological-sort)


## Dependencies Hierarchy

The following hierarchical graphs shows dependencies with the most used and shared elements at the bottom and the ones that use the most dependencies on top. The visualization is limited to the first 20 nodes and their direct dependency ordered descending by their layer ("maxDistanceFromSource"). 

For the whole list of topologically sorted elements including the hierarchical layer see the detailed report `TopologicalSorted....csv`. It is for example helpful to find out in which order Artifacts need to be build/assembled in case of breaking changes.

### Hierarchical Typescript Module Dependencies

The following Graph shows up to 20 Typescript Module dependencies in hierarchical form sorted by their topology.



<!DOCTYPE html>
<html>
<head>
  <title>Jupyter Notebook embedded neovis.js visualization</title>
  <style type="text/css">
.graph-visualization {
    width: 660px;
    height: 660px;
    border: 1px solid lightgray;
}
div.vis-tooltip {
  font-size: 6px;
}
</style>
</head>
<body>
  <div id="graph-visualization-typescript-modules" class="graph-visualization"></div>
  <script type="text/javascript" defer>
    configuration={"containerId": "graph-visualization-typescript-modules", "visConfig": {"nodes": {"shape": "hexagon", "shadow": false, "font": {"strokeWidth": 4, "strokeColor": "#F2F2FF", "size": 12}, "size": 22, "borderWidth": 2, "widthConstraint": {"maximum": 60}}, "edges": {"arrows": {"to": {"enabled": true, "scaleFactor": 0.3}}, "scaling": {"max": 6}}, "physics": {"hierarchicalRepulsion": {"nodeDistance": 200, "centralGravity": 0.2, "springLength": 100, "springConstant": 0.02, "damping": 0.09, "avoidOverlap": 0.9}, "solver": "hierarchicalRepulsion"}, "layout": {"hierarchical": {"enabled": true, "sortMethod": "directed"}}}, "neo4j": {"serverUrl": "bolt://localhost:7687", "serverUser": "neo4j", "serverPassword": ">$Uch(g<G70A"}, "initialCypher": "\n        MATCH (module:TS:Module)-[dependency:DEPENDS_ON]->(dependent:TS:Module)\n        WHERE  module.maxDistanceFromSource IS NOT NULL\n        AND  dependent.maxDistanceFromSource > module.maxDistanceFromSource\n        RETURN module, dependency, dependent\n        ORDER BY module.maxDistanceFromSource DESC\n                ,module.maxDistanceFromSource ASC\n                ,module.topologicalSortIndex  ASC\n                ,dependent.topologicalSortIndex ASC\n        LIMIT 20        \n    ", "defaultLabelConfig": {"label": "name"}, "labels": {"File": {"label": "name"}}, "relationships": {"DEPENDS_ON": {"value": "cardinality", "label": false}}}; 
function draw(NeoVis) {
  configuration.labels[NeoVis.NEOVIS_DEFAULT_CONFIG] = {
    [NeoVis.NEOVIS_ADVANCED_CONFIG]: {
      function: {
        title: NeoVis.objectToTitleHtml // Show all node properties in the tooltip
      }
    }
  }
  configuration.relationships[NeoVis.NEOVIS_DEFAULT_CONFIG] = {
    [NeoVis.NEOVIS_ADVANCED_CONFIG]: {
      function: {
        title: NeoVis.objectToTitleHtml // Show all relationship properties in the tooltip
      }
    }
  }
  console.debug(configuration)
  const neoViz = new NeoVis.default(configuration);
  neoViz.render();
}

// Use JavaScript library neovis.js to render the graph into the HTML above
requirejs(['https://unpkg.com/neovis.js@2.1.0'], function(NeoVis){ 
  draw(NeoVis);
}, function (err) {
    throw new Error("Failed to load NeoVis:" + err);
});

  </script>
</body>
</html>


