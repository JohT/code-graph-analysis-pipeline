// Example on how to set the parameters for node embeddings in this case for Packages and Node2Vec

:params {
    "dependencies_projection": "package-embeddings-directed",     
    "dependencies_projection_node": "Package",
    "dependencies_projection_weight_property": "weight25PercentInterfaces",
    "dependencies_projection_write_property": "embeddingsNode2Vec",
    "dependencies_projection_embedding_dimension": "64"
}