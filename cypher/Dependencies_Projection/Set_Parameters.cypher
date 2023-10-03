// Example on how to set the parameters for the dependencies projection in this case for Packages and the useage with PageRank

:params {
    "dependencies_projection": "package-centrality",     
    "dependencies_projection_node": "Package",
    "dependencies_projection_weight_property": "weight25PercentInterfaces",
    "dependencies_projection_write_property": "centralityPageRank",
}