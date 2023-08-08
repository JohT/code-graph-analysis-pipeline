function hierarchicalHexagons() {
  return {
    nodes: {
      shape: "hexagon",
      shadow: false,
      font: {
        strokeWidth: 4,
        strokeColor: "#F2F2FF",
        size: 11,
      },
      size: 22,
      widthConstraint: {
        maximum: 60,
      },
    },
    edges: {
      arrows: {
        to: {
          enabled: true,
          scaleFactor: 0.5,
        },
      },
      scaling: {
        max: 8,
      },
    },
    physics: {
      hierarchicalRepulsion: {
        nodeDistance: 200, // 100
        centralGravity: 0.5, // 0.2
        springLength: 200, // 200
        springConstant: 0.06, // 0.05
        damping: 0.09, // 0.09
        avoidOverlap: 1, // 0
      },
      solver: "hierarchicalRepulsion", // barnesHut
    },
    layout: {
      hierarchical: {
        enabled: true,
        sortMethod: "directed",
      },
    },
  };
}
