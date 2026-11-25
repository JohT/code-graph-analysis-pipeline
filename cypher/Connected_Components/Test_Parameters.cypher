// Example parameters for testing StronglyConnectedComponent and WeaklyConnectedComponent queries.
// Copy these parameter values to Neo4j browser or use them in your test scripts.

// Example 1: For Java Package analysis
:params {
    dependencies_projection: "package-analysis",     
    dependencies_projection_node: "Package",
    dependencies_projection_weight_property: "weight",
    dependencies_projection_language: "Java"
}

// Example 2: For Java Type analysis
:params {
    dependencies_projection: "type-analysis",     
    dependencies_projection_node: "Type",
    dependencies_projection_weight_property: "weight",
    dependencies_projection_language: "Java"
}

// Example 3: For SCIP (Multi-language) Module analysis
:params {
    dependencies_projection: "scip-module-cycles",     
    dependencies_projection_node: "SemanticCodeIndexModule",
    dependencies_projection_weight_property: "weight",
    dependencies_projection_language: "SCIP_Semantic_Index"
}
