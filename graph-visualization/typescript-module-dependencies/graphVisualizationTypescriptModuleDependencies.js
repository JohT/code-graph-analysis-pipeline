function getNeo4jCredentials() {
  return {
    serverUrl: "bolt://localhost:7687",
    serverUser: "neo4j",
    serverPassword: document.getElementById("neo4j-server-password").value,
  };
}

function getConfiguration(credentials, visConfiguration, containerId = "visualizations") {
  return {
    containerId: containerId,
    neo4j: credentials,
    visConfig: visConfiguration,
    // Note: "defaultLabelConfig" is used instead of named label configs: { NameOfTheLabel: {...}, ...}
    //       The reason for that is that neovis.js takes the first label that is returned by Neo4j.
    //       If there are multiple Labels this is not stable to use.
    //       Since we only expect one type of labels here (homogenous graph) we can simply use the default label config.
    //       Reference: https://github.com/neo4j-contrib/neovis.js/blob/cef0aa16d647ffe0fd9ca457bcffa6e0cb7c55c8/src/neovis.ts#L524
    defaultLabelConfig: {
        [NeoVis.NEOVIS_ADVANCED_CONFIG]: {
          function: {
            // Print all properties for the title (when nodes are clicked)
            title: NeoVis.objectToTitleHtml,
            // Use "name" as label. Remove file extension. Add dependency level (maxDistanceFromSource) in parentheses.
            label: (node) => {
              return node.properties.name.replace(/\.\w+$/gm, "") + "(" + node.properties.maxDistanceFromSource + ")";
            },
          },
        },
    },
    relationships: {
      DEPENDS_ON: {
        label: false,
        value: "cardinality",
        [NeoVis.NEOVIS_ADVANCED_CONFIG]: {
          function: {
            title: NeoVis.objectToTitleHtml
          },
        }
      },
    },
    initialCypher:
      "MATCH (module:TS:Module)-[dependency:DEPENDS_ON*0..1]->(dependent:TS:Module) WHERE module.topologicalSortIndex >= 0 AND dependent.topologicalSortIndex >= 0 AND module <> dependent RETURN module,dependency,dependent ORDER BY dependent.topologicalSortIndex, module.topologicalSortIndex SKIP toInteger($startIndex) LIMIT toInteger($blockSize)",
  };
}

function draw() {
  const config = getConfiguration(getNeo4jCredentials(), hierarchicalHexagons());
  paginatedGraphVisualization({ containerElementId: "visualizations", neoVizConfiguration: config });
}
