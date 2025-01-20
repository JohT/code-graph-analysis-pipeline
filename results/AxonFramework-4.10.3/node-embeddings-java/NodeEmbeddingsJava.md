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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>[-0.21103507280349731, -0.18831247091293335, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>[-0.25916367769241333, -0.12870511412620544, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.2757379710674286, -0.25459837913513184, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.24588952958583832, -0.25064313411712646, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.2661723494529724, -0.25586026906967163, -0...</td>
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
       --> Time elapsed: 0.02 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.4888, 50 iterations in 0.0558 sec
    Iteration  100, KL divergence 1.2041, 50 iterations in 0.0159 sec
    Iteration  150, KL divergence 1.2041, 50 iterations in 0.0152 sec
    Iteration  200, KL divergence 1.2041, 50 iterations in 0.0153 sec
    Iteration  250, KL divergence 1.2041, 50 iterations in 0.0158 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2098, 50 iterations in 0.0528 sec
    Iteration  100, KL divergence 0.1821, 50 iterations in 0.0499 sec
    Iteration  150, KL divergence 0.1713, 50 iterations in 0.0469 sec
    Iteration  200, KL divergence 0.1708, 50 iterations in 0.0447 sec
    Iteration  250, KL divergence 0.1706, 50 iterations in 0.0438 sec
    Iteration  300, KL divergence 0.1706, 50 iterations in 0.0447 sec
    Iteration  350, KL divergence 0.1709, 50 iterations in 0.0443 sec
    Iteration  400, KL divergence 0.1708, 50 iterations in 0.0439 sec
    Iteration  450, KL divergence 0.1708, 50 iterations in 0.0441 sec
    Iteration  500, KL divergence 0.1711, 50 iterations in 0.0440 sec
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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>5.347819</td>
      <td>0.170724</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>6.166368</td>
      <td>0.880938</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>6.455507</td>
      <td>0.158294</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.528139</td>
      <td>-0.276205</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.594112</td>
      <td>-0.134591</td>
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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>[0.8660253882408142, -0.6495190411806107, 0.0,...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>[0.0, 0.0, -0.6495190411806107, 0.433012694120...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.8660253882408142, -1.5155444294214249, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-1.0825317353010178, -0.21650634706020355, -1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.4330126941204071, 0.0, -0.4330126941204071...</td>
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
    Iteration   50, KL divergence -0.5133, 50 iterations in 0.0611 sec
    Iteration  100, KL divergence 1.2258, 50 iterations in 0.0161 sec
    Iteration  150, KL divergence 1.2258, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.2258, 50 iterations in 0.0144 sec
    Iteration  250, KL divergence 1.2258, 50 iterations in 0.0143 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5757, 50 iterations in 0.0503 sec
    Iteration  100, KL divergence 0.5591, 50 iterations in 0.0493 sec
    Iteration  150, KL divergence 0.5564, 50 iterations in 0.0440 sec
    Iteration  200, KL divergence 0.5569, 50 iterations in 0.0436 sec
    Iteration  250, KL divergence 0.5569, 50 iterations in 0.0433 sec
    Iteration  300, KL divergence 0.5568, 50 iterations in 0.0568 sec
    Iteration  350, KL divergence 0.5568, 50 iterations in 0.0449 sec
    Iteration  400, KL divergence 0.5570, 50 iterations in 0.0442 sec
    Iteration  450, KL divergence 0.5570, 50 iterations in 0.0443 sec
    Iteration  500, KL divergence 0.5569, 50 iterations in 0.0449 sec
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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>-1.502146</td>
      <td>7.863140</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>-2.070825</td>
      <td>5.655420</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>-2.054574</td>
      <td>6.220653</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-1.069462</td>
      <td>6.762203</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-1.139120</td>
      <td>6.878317</td>
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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>[0.3877551257610321, 0.2531123161315918, 0.195...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>[0.10057783871889114, 0.24116496741771698, 0.2...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[0.44230160117149353, 0.15307272970676422, 0.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.29575273394584656, 0.1599380075931549, 0.17...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.2972909212112427, 0.22154121100902557, 0.27...</td>
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
    Iteration   50, KL divergence -0.9173, 50 iterations in 0.0632 sec
    Iteration  100, KL divergence -2.8831, 50 iterations in 0.0187 sec
    Iteration  150, KL divergence -2.8831, 50 iterations in 0.0168 sec
    Iteration  200, KL divergence 1.1643, 50 iterations in 0.0156 sec
    Iteration  250, KL divergence 1.1643, 50 iterations in 0.0146 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3321, 50 iterations in 0.0563 sec
    Iteration  100, KL divergence 0.3011, 50 iterations in 0.0466 sec
    Iteration  150, KL divergence 0.2981, 50 iterations in 0.0452 sec
    Iteration  200, KL divergence 0.2983, 50 iterations in 0.0438 sec
    Iteration  250, KL divergence 0.2984, 50 iterations in 0.0442 sec
    Iteration  300, KL divergence 0.2984, 50 iterations in 0.0442 sec
    Iteration  350, KL divergence 0.2984, 50 iterations in 0.0448 sec
    Iteration  400, KL divergence 0.2985, 50 iterations in 0.0444 sec
    Iteration  450, KL divergence 0.2983, 50 iterations in 0.0442 sec
    Iteration  500, KL divergence 0.2981, 50 iterations in 0.0443 sec
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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>-5.373613</td>
      <td>-0.905736</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>-5.188871</td>
      <td>-3.082673</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>-6.307832</td>
      <td>-0.954504</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-4.846581</td>
      <td>-0.150129</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-5.680134</td>
      <td>-1.257649</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

