// Example on how to set the parameters for community detaction in this case for Packages and Leiden

:params {
    "dependencies_projection": "package-community",     
    "dependencies_projection_node": "Package",
    "dependencies_projection_weight_property": "weight25PercentInterfaces",
    "dependencies_projection_write_property": "communityLeidenId",
    "dependencies_leiden_gamma": "1.14",
}