// Check if the projection exists. Variables: dependencies_projection

RETURN CASE WHEN gds.graph.exists($dependencies_projection + '-cleaned') THEN 1 
            ELSE 0 END AS projectionCount