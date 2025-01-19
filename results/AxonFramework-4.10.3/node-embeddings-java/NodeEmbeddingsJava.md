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
      <td>[-0.6159756183624268, -0.26816046237945557, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>[-0.719285249710083, -0.2623174488544464, 0.06...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.5816870927810669, -0.2726455330848694, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.5031238794326782, -0.27548152208328247, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.5326924324035645, -0.2748021185398102, -0....</td>
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
    Iteration   50, KL divergence -0.2790, 50 iterations in 0.0559 sec
    Iteration  100, KL divergence 1.2005, 50 iterations in 0.0156 sec
    Iteration  150, KL divergence 1.2005, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.2005, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2005, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2235, 50 iterations in 0.0479 sec
    Iteration  100, KL divergence 0.2051, 50 iterations in 0.0454 sec
    Iteration  150, KL divergence 0.2019, 50 iterations in 0.0430 sec
    Iteration  200, KL divergence 0.2009, 50 iterations in 0.0427 sec
    Iteration  250, KL divergence 0.1995, 50 iterations in 0.0412 sec
    Iteration  300, KL divergence 0.1994, 50 iterations in 0.0426 sec
    Iteration  350, KL divergence 0.1953, 50 iterations in 0.0444 sec
    Iteration  400, KL divergence 0.1945, 50 iterations in 0.0445 sec
    Iteration  450, KL divergence 0.1949, 50 iterations in 0.0437 sec
    Iteration  500, KL divergence 0.1948, 50 iterations in 0.0433 sec
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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>5.989622</td>
      <td>0.892725</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>6.904597</td>
      <td>1.739950</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>7.194857</td>
      <td>0.753268</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>7.348311</td>
      <td>0.240877</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>7.369737</td>
      <td>0.348176</td>
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
      <td>[-0.21650634706020355, -0.8660253882408142, -1...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>[-0.21650634706020355, -1.2990380823612213, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.8660253882408142, -0.4330126941204071, -1....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.21650634706020355, -1.2990380823612213, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.21650634706020355, -1.2990380823612213, -0...</td>
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
    Iteration   50, KL divergence -0.6660, 50 iterations in 0.0654 sec
    Iteration  100, KL divergence 1.2401, 50 iterations in 0.0174 sec
    Iteration  150, KL divergence 1.2401, 50 iterations in 0.0143 sec
    Iteration  200, KL divergence 1.2401, 50 iterations in 0.0143 sec
    Iteration  250, KL divergence 1.2401, 50 iterations in 0.0143 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5706, 50 iterations in 0.0517 sec
    Iteration  100, KL divergence 0.5524, 50 iterations in 0.0482 sec
    Iteration  150, KL divergence 0.5513, 50 iterations in 0.0452 sec
    Iteration  200, KL divergence 0.5516, 50 iterations in 0.0429 sec
    Iteration  250, KL divergence 0.5517, 50 iterations in 0.0440 sec
    Iteration  300, KL divergence 0.5516, 50 iterations in 0.0451 sec
    Iteration  350, KL divergence 0.5516, 50 iterations in 0.0460 sec
    Iteration  400, KL divergence 0.5517, 50 iterations in 0.0584 sec
    Iteration  450, KL divergence 0.5518, 50 iterations in 0.0597 sec
    Iteration  500, KL divergence 0.5518, 50 iterations in 0.0457 sec
       --> Time elapsed: 0.49 seconds



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
      <td>-6.100023</td>
      <td>4.797353</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>-0.170662</td>
      <td>-3.317157</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>4.473195</td>
      <td>-5.765590</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>4.063878</td>
      <td>-6.005084</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>4.035718</td>
      <td>-5.982101</td>
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
      <td>[0.17033880949020386, 0.01935906708240509, 0.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>[0.30458804965019226, -0.18102781474590302, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[0.308476060628891, -0.24300681054592133, -0.0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.09075246006250381, -0.15760785341262817, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.21079717576503754, -0.279901385307312, 0.08...</td>
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
    Iteration   50, KL divergence -1.2839, 50 iterations in 0.0621 sec
    Iteration  100, KL divergence 1.1567, 50 iterations in 0.0165 sec
    Iteration  150, KL divergence 1.1567, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.1567, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.1567, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3417, 50 iterations in 0.0531 sec
    Iteration  100, KL divergence 0.3192, 50 iterations in 0.0463 sec
    Iteration  150, KL divergence 0.3151, 50 iterations in 0.0461 sec
    Iteration  200, KL divergence 0.3155, 50 iterations in 0.0454 sec
    Iteration  250, KL divergence 0.3095, 50 iterations in 0.0442 sec
    Iteration  300, KL divergence 0.3091, 50 iterations in 0.0458 sec
    Iteration  350, KL divergence 0.3094, 50 iterations in 0.0474 sec
    Iteration  400, KL divergence 0.3094, 50 iterations in 0.0453 sec
    Iteration  450, KL divergence 0.3095, 50 iterations in 0.0445 sec
    Iteration  500, KL divergence 0.3092, 50 iterations in 0.0443 sec
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
      <td>-6.732566</td>
      <td>2.073451</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>-7.061215</td>
      <td>0.450158</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>-6.702384</td>
      <td>1.384077</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-0.704640</td>
      <td>0.544546</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-6.191942</td>
      <td>0.730120</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

