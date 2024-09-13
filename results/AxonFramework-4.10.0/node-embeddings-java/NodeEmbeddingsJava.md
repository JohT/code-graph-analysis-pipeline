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
      <td>[-0.3952479958534241, -0.020556509494781494, -...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[-0.23372207581996918, -0.06335897743701935, -...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[-0.3376738429069519, -0.07632027566432953, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.3203500509262085, -0.04939573258161545, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.3448586165904999, -0.052857473492622375, -...</td>
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
    Iteration   50, KL divergence -0.7553, 50 iterations in 0.0560 sec
    Iteration  100, KL divergence 1.2099, 50 iterations in 0.0159 sec
    Iteration  150, KL divergence 1.2099, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2099, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2099, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1816, 50 iterations in 0.0509 sec
    Iteration  100, KL divergence 0.1503, 50 iterations in 0.0481 sec
    Iteration  150, KL divergence 0.1467, 50 iterations in 0.0466 sec
    Iteration  200, KL divergence 0.1467, 50 iterations in 0.0464 sec
    Iteration  250, KL divergence 0.1465, 50 iterations in 0.0463 sec
    Iteration  300, KL divergence 0.1466, 50 iterations in 0.0471 sec
    Iteration  350, KL divergence 0.1465, 50 iterations in 0.0480 sec
    Iteration  400, KL divergence 0.1464, 50 iterations in 0.0541 sec
    Iteration  450, KL divergence 0.1465, 50 iterations in 0.0470 sec
    Iteration  500, KL divergence 0.1466, 50 iterations in 0.0472 sec
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
      <td>-7.498266</td>
      <td>-0.825151</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>-7.990853</td>
      <td>0.160846</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>-7.100111</td>
      <td>-0.758034</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-7.087340</td>
      <td>-1.342302</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-7.178458</td>
      <td>-1.342762</td>
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
      <td>[-0.6495190411806107, 0.4330126941204071, -0.4...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[0.21650634706020355, -1.948557123541832, -1.2...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[-0.4330126941204071, -0.8660253882408142, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-1.2990380823612213, -1.0825317353010178, -1....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-1.2990380823612213, -1.0825317353010178, -0....</td>
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
    Iteration   50, KL divergence -0.7224, 50 iterations in 0.0641 sec
    Iteration  100, KL divergence 1.2412, 50 iterations in 0.0167 sec
    Iteration  150, KL divergence 1.2412, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2412, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2412, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5902, 50 iterations in 0.0509 sec
    Iteration  100, KL divergence 0.5696, 50 iterations in 0.0491 sec
    Iteration  150, KL divergence 0.5648, 50 iterations in 0.0464 sec
    Iteration  200, KL divergence 0.5542, 50 iterations in 0.0461 sec
    Iteration  250, KL divergence 0.5531, 50 iterations in 0.0465 sec
    Iteration  300, KL divergence 0.5527, 50 iterations in 0.0465 sec
    Iteration  350, KL divergence 0.5530, 50 iterations in 0.0471 sec
    Iteration  400, KL divergence 0.5529, 50 iterations in 0.0466 sec
    Iteration  450, KL divergence 0.5530, 50 iterations in 0.0484 sec
    Iteration  500, KL divergence 0.5530, 50 iterations in 0.0532 sec
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
      <td>-3.165960</td>
      <td>-4.787592</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>0.230024</td>
      <td>3.473565</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>1.105287</td>
      <td>4.828188</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>1.770318</td>
      <td>4.897312</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>1.681065</td>
      <td>4.875660</td>
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
      <td>[0.5827924013137817, -0.12824608385562897, 0.3...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[0.6532383561134338, -0.2925974428653717, 0.33...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[0.619573175907135, -0.1587112993001938, 0.197...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.3756014108657837, -0.2326597422361374, 0.32...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.7593620419502258, -0.196803480386734, 0.254...</td>
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
    Iteration   50, KL divergence -0.8420, 50 iterations in 0.0635 sec
    Iteration  100, KL divergence -2.8804, 50 iterations in 0.0183 sec
    Iteration  150, KL divergence 1.1670, 50 iterations in 0.0159 sec
    Iteration  200, KL divergence 1.1670, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.1670, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3800, 50 iterations in 0.0551 sec
    Iteration  100, KL divergence 0.3536, 50 iterations in 0.0489 sec
    Iteration  150, KL divergence 0.3517, 50 iterations in 0.0461 sec
    Iteration  200, KL divergence 0.3516, 50 iterations in 0.0456 sec
    Iteration  250, KL divergence 0.3506, 50 iterations in 0.0455 sec
    Iteration  300, KL divergence 0.3507, 50 iterations in 0.0449 sec
    Iteration  350, KL divergence 0.3505, 50 iterations in 0.0461 sec
    Iteration  400, KL divergence 0.3507, 50 iterations in 0.0464 sec
    Iteration  450, KL divergence 0.3508, 50 iterations in 0.0460 sec
    Iteration  500, KL divergence 0.3511, 50 iterations in 0.0458 sec
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
      <td>0.600971</td>
      <td>5.744929</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>0.366777</td>
      <td>7.095651</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>1.320830</td>
      <td>6.811287</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>0.702418</td>
      <td>3.941507</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>1.048791</td>
      <td>6.882541</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

