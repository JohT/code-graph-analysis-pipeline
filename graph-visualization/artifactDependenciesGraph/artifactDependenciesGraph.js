function draw() {
  const config = {
    containerId: "viz",
    neo4j: {
      serverUrl: "bolt://localhost:7687",
      serverUser: "neo4j",
      serverPassword: document.getElementById("neo4j-server-password").value || "neo4jinitial",
    },
    visConfig: {
      nodes: {
        shape: "hexagon",
        shadow: false,
        font: {
          strokeWidth: 40,
          strokeColor: "#F2F2FF",
        },
        size: 60,
      },
      edges: {
        arrows: {
          to: { enabled: true },
        },
        scaling: {
          max: 15,
        },
      },
      physics: {
        hierarchicalRepulsion: {
          nodeDistance: 300, // 100
          centralGravity: 0.5, // 0.2
          springLength: 180, // 200
          springConstant: 0.06, // 0.05
          damping: 0.09, // 0.09
          avoidOverlap: 0.1, // 0
        },
        solver: "hierarchicalRepulsion", // barnesHut
      },
      layout: {
        hierarchical: {
          enabled: true,
          sortMethod: "directed",
        },
      },
    },
    labels: {
      Artifact: {
        [NeoVis.NEOVIS_ADVANCED_CONFIG]: {
          function: {
            // Print all properties for the title (when nodes are clicked)
            title: NeoVis.objectToTitleHtml,
            // Use "fileName" as label. Remove leading slash, trailing ".jar" and version number.
            label: (node) =>
              node.properties.fileName
                .replace("/", "")
                .replace(".jar", "")
                .replace(/-[\d\\.]+/, ""),
          },
        },
      },
    },
    relationships: {
      DEPENDS_ON: {
        label: false,
        value: "weight",
      },
    },
    initialCypher: "MATCH (s:Artifact)-[r:DEPENDS_ON]->(d:Artifact) RETURN s,r,d",
  };

  const neoViz = new NeoVis.default(config);
  neoViz.render();  
}