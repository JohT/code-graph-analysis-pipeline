# Node Embeddings

This notebook demonstrates different methods for node embeddings and how to further reduce their dimensionality to be able to visualize them in a 2D plot. 

Node embeddings are essentially an array of floating point numbers (length = embedding dimension) that can be used as "features" in machine learning. These numbers approximate the relationship and similarity information of each node and can also be seen as a way to encode the topology of the graph.

## Considerations

Due to dimensionality reduction some information gets lost, especially when visualizing node embeddings in two dimensions. Nevertheless, it helps to get an intuition on what node embeddings are and how much of the similarity and neighborhood information is retained. The latter can be observed by how well nodes of the same color and therefore same community are placed together and how much bigger nodes with a high centrality score influence them. 

If the visualization doesn't show a somehow clear separation between the communities (colors) here are some ideas for tuning: 
- Clean the data, e.g. filter out very few nodes with extremely high degree that aren't actually that important
- Try directed vs. undirected projections
- Tune the embedding algorithm, e.g. use a higher dimensionality
- Tune t-SNE that is used to reduce the node embeddings dimension to two dimensions for visualization. 

It could also be the case that the node embeddings are good enough and well suited the way they are despite their visualization for the down stream task like node classification or link prediction. In that case it makes sense to see how the whole pipeline performs before tuning the node embeddings in detail. 

## Note about data dependencies

PageRank centrality and Leiden community are also fetched from the Graph and need to be calculated first.
This makes it easier to see if the embeddings approximate the structural information of the graph in the plot.
If these properties are missing you will only see black dots all of the same size.

<br>  

### References
- [jqassistant](https://jqassistant.org)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)
- [Tutorial: Applied Graph Embeddings](https://neo4j.com/developer/graph-data-science/applied-graph-embeddings)
- [Visualizing the embeddings in 2D](https://github.com/openai/openai-cookbook/blob/main/examples/Visualizing_embeddings_in_2D.ipynb)
- [scikit-learn TSNE](https://scikit-learn.org/stable/modules/generated/sklearn.manifold.TSNE.html#sklearn.manifold.TSNE)
- [AttributeError: 'list' object has no attribute 'shape'](https://bobbyhadz.com/blog/python-attributeerror-list-object-has-no-attribute-shape)
- [Fast Random Projection (neo4j)](https://neo4j.com/docs/graph-data-science/current/machine-learning/node-embeddings/fastrp)
- [HashGNN (neo4j)](https://neo4j.com/docs/graph-data-science/2.6/machine-learning/node-embeddings/hashgnn)
- [node2vec (neo4j)](https://neo4j.com/docs/graph-data-science/current/machine-learning/node-embeddings/node2vec) computes a vector representation of a node based on second order random walks in the graph. 
- [Complete guide to understanding Node2Vec algorithm](https://towardsdatascience.com/complete-guide-to-understanding-node2vec-algorithm-4e9a35e5d147)

    The openTSNE version is: 1.0.1
    The pandas version is: 1.5.1


### Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

The following function takes the original node embeddings with a higher dimensionality, e.g. 64 floating point numbers, and reduces them into a two dimensional array for visualization. 

> It converts similarities between data points to joint probabilities and tries to minimize the Kullback-Leibler divergence between the joint probabilities of the low-dimensional embedding and the high-dimensional data.

(see https://opentsne.readthedocs.io)





## 1. Java Packages

### 1.1 Generate Node Embeddings using Fast Random Projection (Fast RP) for Java Packages

[Fast Random Projection](https://neo4j.com/docs/graph-data-science/current/machine-learning/node-embeddings/fastrp) is used to reduce the dimensionality of the node feature space while preserving most of the distance information. Nodes with similar neighborhood result in node embedding with similar vectors.

**👉Hint:** To skip existing node embeddings and always calculate them based on the parameters below edit `Node_Embeddings_0a_Query_Calculated` so that it won't return any results.

    The results have been provided by the query filename: ../cypher/Node_Embeddings/Node_Embeddings_0a_Query_Calculated.cypher



<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>codeUnitName</th>
      <th>shortCodeUnitName</th>
      <th>projectName</th>
      <th>communityId</th>
      <th>centrality</th>
      <th>embedding</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.axonserver.connector</td>
      <td>connector</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.088294</td>
      <td>[-0.3583401143550873, -0.13783293962478638, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[-0.36523836851119995, -0.08999821543693542, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[-0.3143582046031952, -0.22040359675884247, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.239431232213974, -0.24296730756759644, 0.0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.26371264457702637, -0.2441297024488449, 0....</td>
    </tr>
  </tbody>
</table>
</div>


### 1.2 Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

This step takes the original node embeddings with a higher dimensionality, e.g. 64 floating point numbers, and reduces them into a two dimensional array for visualization. For more details look up the function declaration for "prepare_node_embeddings_for_2d_visualization".

    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 90 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.03 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence 0.0690, 50 iterations in 0.0538 sec
    Iteration  100, KL divergence 1.2219, 50 iterations in 0.0157 sec
    Iteration  150, KL divergence 1.2219, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2219, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2219, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.11 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1603, 50 iterations in 0.0517 sec
    Iteration  100, KL divergence 0.1483, 50 iterations in 0.0474 sec
    Iteration  150, KL divergence 0.1432, 50 iterations in 0.0434 sec
    Iteration  200, KL divergence 0.1436, 50 iterations in 0.0426 sec
    Iteration  250, KL divergence 0.1430, 50 iterations in 0.0424 sec
    Iteration  300, KL divergence 0.1430, 50 iterations in 0.0440 sec
    Iteration  350, KL divergence 0.1430, 50 iterations in 0.0586 sec
    Iteration  400, KL divergence 0.1430, 50 iterations in 0.0439 sec
    Iteration  450, KL divergence 0.1430, 50 iterations in 0.0434 sec
    Iteration  500, KL divergence 0.1430, 50 iterations in 0.0440 sec
       --> Time elapsed: 0.46 seconds



    (114, 2)



<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>codeUnit</th>
      <th>artifact</th>
      <th>communityId</th>
      <th>centrality</th>
      <th>x</th>
      <th>y</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.088294</td>
      <td>-2.919493</td>
      <td>-5.742914</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>-2.707476</td>
      <td>-6.936086</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>-3.583507</td>
      <td>-6.589572</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-4.063253</td>
      <td>-6.262720</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-3.968307</td>
      <td>-6.386096</td>
    </tr>
  </tbody>
</table>
</div>


### 1.3 Visualization of the node embeddings reduced to two dimensions


    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_21_0.png)
    


### 1.4 Node Embeddings for Java Packages using HashGNN

[HashGNN](https://neo4j.com/docs/graph-data-science/2.6/machine-learning/node-embeddings/hashgnn) resembles Graph Neural Networks (GNN) but does not include a model or require training. It combines ideas of GNNs and fast randomized algorithms. For more details see [HashGNN](https://neo4j.com/docs/graph-data-science/2.6/machine-learning/node-embeddings/hashgnn). Here, the latter 3 steps are combined into one for HashGNN.

    The results have been provided by the query filename: ../cypher/Node_Embeddings/Node_Embeddings_0a_Query_Calculated.cypher



<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>codeUnitName</th>
      <th>shortCodeUnitName</th>
      <th>projectName</th>
      <th>communityId</th>
      <th>centrality</th>
      <th>embedding</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.axonserver.connector</td>
      <td>connector</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.088294</td>
      <td>[-0.8660253882408142, -0.6495190411806107, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[-0.8660253882408142, -0.6495190411806107, 0.6...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[0.6495190411806107, -1.7320507764816284, 0.0,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.0, -1.5155444294214249, 0.21650634706020355...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.4330126941204071, -1.2990380823612213, 0.64...</td>
    </tr>
  </tbody>
</table>
</div>


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 90 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.01 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.01 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.7303, 50 iterations in 0.1143 sec
    Iteration  100, KL divergence 1.2366, 50 iterations in 0.0170 sec
    Iteration  150, KL divergence 1.2366, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.2366, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2366, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.18 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5487, 50 iterations in 0.0363 sec
    Iteration  100, KL divergence 0.5247, 50 iterations in 0.0465 sec
    Iteration  150, KL divergence 0.5193, 50 iterations in 0.0446 sec
    Iteration  200, KL divergence 0.5192, 50 iterations in 0.0440 sec
    Iteration  250, KL divergence 0.5191, 50 iterations in 0.0457 sec
    Iteration  300, KL divergence 0.5186, 50 iterations in 0.0451 sec
    Iteration  350, KL divergence 0.5189, 50 iterations in 0.0435 sec
    Iteration  400, KL divergence 0.5185, 50 iterations in 0.0426 sec
    Iteration  450, KL divergence 0.5187, 50 iterations in 0.0433 sec
    Iteration  500, KL divergence 0.5188, 50 iterations in 0.0441 sec
       --> Time elapsed: 0.44 seconds



    (114, 2)



<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>codeUnit</th>
      <th>artifact</th>
      <th>communityId</th>
      <th>centrality</th>
      <th>x</th>
      <th>y</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.088294</td>
      <td>-1.682604</td>
      <td>7.312775</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>3.653703</td>
      <td>0.168899</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>-7.424113</td>
      <td>3.420733</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-7.954680</td>
      <td>3.393950</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-7.992449</td>
      <td>3.332105</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_23_5.png)
    


### 2.5 Node Embeddings for Java Packages using node2vec

    The results have been provided by the query filename: ../cypher/Node_Embeddings/Node_Embeddings_0a_Query_Calculated.cypher



<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>codeUnitName</th>
      <th>shortCodeUnitName</th>
      <th>projectName</th>
      <th>communityId</th>
      <th>centrality</th>
      <th>embedding</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.axonserver.connector</td>
      <td>connector</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.088294</td>
      <td>[0.0933302640914917, -0.027183130383491516, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[0.16304683685302734, -0.07005564123392105, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[0.07147037982940674, 0.01540499646216631, 0.2...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.01782887801527977, -0.05544126406311989, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.23066195845603943, 0.1123834028840065, 0.33...</td>
    </tr>
  </tbody>
</table>
</div>


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 90 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.00 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -1.0541, 50 iterations in 0.0657 sec
    Iteration  100, KL divergence 1.1712, 50 iterations in 0.0170 sec
    Iteration  150, KL divergence 1.1712, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.1712, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.1712, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3361, 50 iterations in 0.0523 sec
    Iteration  100, KL divergence 0.3056, 50 iterations in 0.0484 sec
    Iteration  150, KL divergence 0.2950, 50 iterations in 0.0465 sec
    Iteration  200, KL divergence 0.2942, 50 iterations in 0.0453 sec
    Iteration  250, KL divergence 0.2940, 50 iterations in 0.0453 sec
    Iteration  300, KL divergence 0.2938, 50 iterations in 0.0450 sec
    Iteration  350, KL divergence 0.2942, 50 iterations in 0.0457 sec
    Iteration  400, KL divergence 0.2943, 50 iterations in 0.0457 sec
    Iteration  450, KL divergence 0.2944, 50 iterations in 0.0458 sec
    Iteration  500, KL divergence 0.2945, 50 iterations in 0.0462 sec
       --> Time elapsed: 0.47 seconds



    (114, 2)



<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>codeUnit</th>
      <th>artifact</th>
      <th>communityId</th>
      <th>centrality</th>
      <th>x</th>
      <th>y</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.088294</td>
      <td>-5.953138</td>
      <td>1.481131</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>-5.785200</td>
      <td>2.369407</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>-6.562187</td>
      <td>1.413467</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-3.873249</td>
      <td>1.316199</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-6.415822</td>
      <td>2.189210</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

