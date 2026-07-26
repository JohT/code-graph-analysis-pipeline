//Path Finding 1 Create Projection
CALL gds.graph.project(
    $dependencies_projection,
    $dependencies_projection_node,
    'DEPENDS_ON'
)