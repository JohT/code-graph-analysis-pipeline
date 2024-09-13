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
      <td>[-0.2640637755393982, -0.16886964440345764, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[-0.2898571491241455, -0.12669463455677032, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[-0.29758816957473755, -0.21426807343959808, -...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.2730443775653839, -0.22372417151927948, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.2931281328201294, -0.21918103098869324, -0...</td>
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
    Iteration   50, KL divergence -0.2272, 50 iterations in 0.0561 sec
    Iteration  100, KL divergence 1.2147, 50 iterations in 0.0156 sec
    Iteration  150, KL divergence 1.2147, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2147, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2147, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2219, 50 iterations in 0.0508 sec
    Iteration  100, KL divergence 0.1859, 50 iterations in 0.0484 sec
    Iteration  150, KL divergence 0.1825, 50 iterations in 0.0422 sec
    Iteration  200, KL divergence 0.1825, 50 iterations in 0.0418 sec
    Iteration  250, KL divergence 0.1826, 50 iterations in 0.0414 sec
    Iteration  300, KL divergence 0.1828, 50 iterations in 0.0424 sec
    Iteration  350, KL divergence 0.1826, 50 iterations in 0.0425 sec
    Iteration  400, KL divergence 0.1827, 50 iterations in 0.0420 sec
    Iteration  450, KL divergence 0.1826, 50 iterations in 0.0416 sec
    Iteration  500, KL divergence 0.1826, 50 iterations in 0.0418 sec
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
      <td>-4.850489</td>
      <td>2.361595</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>-5.427195</td>
      <td>3.520321</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>-6.181206</td>
      <td>2.939386</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-6.449598</td>
      <td>2.366702</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-6.477769</td>
      <td>2.660849</td>
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
      <td>[0.6495190411806107, 0.6495190411806107, -0.86...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[-0.4330126941204071, 0.21650634706020355, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[-0.21650634706020355, -1.948557123541832, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.21650634706020355, -1.2990380823612213, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.8660253882408142, -1.7320507764816284, -0.4...</td>
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
    Iteration   50, KL divergence -1.1119, 50 iterations in 0.0625 sec
    Iteration  100, KL divergence 1.2279, 50 iterations in 0.0163 sec
    Iteration  150, KL divergence 1.2279, 50 iterations in 0.0144 sec
    Iteration  200, KL divergence 1.2279, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.2279, 50 iterations in 0.0141 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5271, 50 iterations in 0.0502 sec
    Iteration  100, KL divergence 0.5186, 50 iterations in 0.0476 sec
    Iteration  150, KL divergence 0.5126, 50 iterations in 0.0470 sec
    Iteration  200, KL divergence 0.5114, 50 iterations in 0.0468 sec
    Iteration  250, KL divergence 0.5095, 50 iterations in 0.0471 sec
    Iteration  300, KL divergence 0.5095, 50 iterations in 0.0464 sec
    Iteration  350, KL divergence 0.5091, 50 iterations in 0.0465 sec
    Iteration  400, KL divergence 0.5092, 50 iterations in 0.0461 sec
    Iteration  450, KL divergence 0.5092, 50 iterations in 0.0457 sec
    Iteration  500, KL divergence 0.5092, 50 iterations in 0.0456 sec
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
      <td>-6.107723</td>
      <td>1.936342</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>-7.103321</td>
      <td>1.446234</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>-5.598582</td>
      <td>-1.638787</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-6.402402</td>
      <td>-1.929829</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-6.307112</td>
      <td>-1.896512</td>
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
      <td>[0.4966241717338562, -0.261223703622818, -0.16...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[0.40502679347991943, -0.25921666622161865, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[0.6153467297554016, -0.22864128649234772, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.28505900502204895, -0.1802164912223816, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.581468939781189, -0.04361711069941521, -0.3...</td>
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
    Iteration   50, KL divergence -0.5192, 50 iterations in 0.0620 sec
    Iteration  100, KL divergence 1.1725, 50 iterations in 0.0167 sec
    Iteration  150, KL divergence 1.1725, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.1725, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.1725, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2952, 50 iterations in 0.0521 sec
    Iteration  100, KL divergence 0.2784, 50 iterations in 0.0496 sec
    Iteration  150, KL divergence 0.2761, 50 iterations in 0.0468 sec
    Iteration  200, KL divergence 0.2766, 50 iterations in 0.0468 sec
    Iteration  250, KL divergence 0.2762, 50 iterations in 0.0467 sec
    Iteration  300, KL divergence 0.2756, 50 iterations in 0.0470 sec
    Iteration  350, KL divergence 0.2765, 50 iterations in 0.0476 sec
    Iteration  400, KL divergence 0.2762, 50 iterations in 0.0478 sec
    Iteration  450, KL divergence 0.2760, 50 iterations in 0.0476 sec
    Iteration  500, KL divergence 0.2763, 50 iterations in 0.0473 sec
       --> Time elapsed: 0.48 seconds



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
      <td>4.837095</td>
      <td>2.382923</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>6.380756</td>
      <td>1.726764</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>5.633355</td>
      <td>2.674834</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>3.620514</td>
      <td>1.096988</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>6.105576</td>
      <td>2.524832</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

