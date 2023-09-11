//5 Experimental Depth First Search Artifacts Index
//depthFirstSearchLevel is not correct

// Depth First Search starting from a node with no incoming dependencies
MATCH (source:Artifact{fileName:'/axon-configuration-4.8.0.jar'})
 CALL gds.dfs.stream('artifact-dependencies-directed-without-empty', {
  sourceNode: source
})
 YIELD nodeIds
// Generate an index to iterate through the searched nodes
UNWIND range(0, size(nodeIds)-1) AS nodeIndex
  WITH nodeIndex
      ,nodeIds
      ,gds.util.asNodes(nodeIds) AS searchedNodes
  WITH nodeIndex
      ,nodeIds
      ,searchedNodes
      ,searchedNodes[nodeIndex] AS indexedNode
      // Get the previous node to be able to detect where depth first search went back
      ,CASE WHEN nodeIndex > 0
            THEN searchedNodes[nodeIndex - 1]
            ELSE NULL
       END AS previousNode
// Get the parent node of the indexed one
 OPTIONAL MATCH (indexedNode)<-[:DEPENDS_ON]-(parent:Artifact)
  WITH nodeIndex
      ,nodeIds
      ,searchedNodes
      ,indexedNode
      ,previousNode
      ,COLLECT(parent.fileName)                                                           AS parentFilenames
      ,(previousNode IN COLLECT(parent))                                                  AS previousIsParent 
      ,COLLECT(apoc.coll.indexOf(searchedNodes[0..nodeIndex], parent))                    AS previousParentIndizes
      ,apoc.coll.max(COLLECT(apoc.coll.indexOf(searchedNodes[0..nodeIndex], parent))) + 1 AS topologyLevel
   // Set the property 'depthFirstSearchIndex' to the index
   // TODO Set 'depthFirstSearchLevel' relative to the level of the parent, not its dfs index
   SET indexedNode.depthFirstSearchIndex = nodeIndex
      ,indexedNode.depthFirstSearchLevel = topologyLevel
RETURN indexedNode.fileName
      ,nodeIndex
      ,previousNode.fileName
      ,previousIsParent
      ,previousParentIndizes
      ,topologyLevel
      ,parentFilenames
//FOREACH (i IN RANGE(0, SIZE(nodeIds)-1) | SET gds.util.asNode(nodeIds[i]).depthFirstSearchIndex = i)