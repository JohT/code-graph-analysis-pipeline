// Example on how to set the parameters for similarity in this case for Packages and Node Similarity

:params {
    "dependencies_projection": "package-similarity",     
    "dependencies_projection_node": "Package",
    "dependencies_projection_weight_property": "weight25PercentInterfaces",
    "dependencies_projection_write_property": "similarityScore",
}