function getNeo4jCredentials() {
  return {
    serverUrl: "bolt://localhost:7687",
    serverUser: "neo4j",
    serverPassword: document.getElementById("neo4j-server-password").value,
  };
}

function getConfiguration(containerId = "viz", credentials, visConfiguration) {
  return {
    containerId: containerId,
    neo4j: credentials,
    visConfig: visConfiguration,
    labels: {
      Artifact: {
        [NeoVis.NEOVIS_ADVANCED_CONFIG]: {
          function: {
            // Print all properties for the title (when nodes are clicked)
            title: NeoVis.objectToTitleHtml,
            // Use "fileName" as label. Remove leading slash, trailing ".jar", version number and a trailing word like "Final".
            label: (node) =>
              node.properties.fileName
                .replace("/", "")
                .replace(".jar", "")
                .replace(/[\d\.\-\_v]+\w+$/gm, "") +
              "(" +
              node.properties.maxDistanceFromSource +
              ")",
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
    initialCypher:
      "MATCH (a1:Artifact)-[r1:DEPENDS_ON*0..1]->(a2:Artifact) WHERE a1.topologicalSortIndex >= 0 AND a2.topologicalSortIndex >= 0 AND a1 <> a2 RETURN a1,r1,a2 ORDER BY a2.topologicalSortIndex, a1.topologicalSortIndex SKIP toInteger($startIndex) LIMIT toInteger($blockSize)",
  };
}

function draw() {
  const config = getConfiguration("viz", getNeo4jCredentials(), hierarchicalHexagons());
  paginatedGraphVisualization({containerElementId: "visualizations", neoVizConfiguration: config});
}