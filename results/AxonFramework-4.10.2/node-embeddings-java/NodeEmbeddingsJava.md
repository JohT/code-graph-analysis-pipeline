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
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>[-0.2721554934978485, 0.2686484456062317, -0.3...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[-0.3697691857814789, 0.20472835004329681, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.275747686624527, 0.11001288890838623, -0.3...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.24983331561088562, 0.09112916141748428, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.2681088447570801, 0.08383456617593765, -0....</td>
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
    Iteration   50, KL divergence -0.4705, 50 iterations in 0.0568 sec
    Iteration  100, KL divergence 1.1919, 50 iterations in 0.0161 sec
    Iteration  150, KL divergence 1.1919, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.1919, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.1919, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1621, 50 iterations in 0.0526 sec
    Iteration  100, KL divergence 0.1437, 50 iterations in 0.0485 sec
    Iteration  150, KL divergence 0.1319, 50 iterations in 0.0443 sec
    Iteration  200, KL divergence 0.1311, 50 iterations in 0.0446 sec
    Iteration  250, KL divergence 0.1310, 50 iterations in 0.0443 sec
    Iteration  300, KL divergence 0.1307, 50 iterations in 0.0443 sec
    Iteration  350, KL divergence 0.1306, 50 iterations in 0.0445 sec
    Iteration  400, KL divergence 0.1306, 50 iterations in 0.0441 sec
    Iteration  450, KL divergence 0.1307, 50 iterations in 0.0439 sec
    Iteration  500, KL divergence 0.1309, 50 iterations in 0.0441 sec
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
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>6.158570</td>
      <td>-2.317878</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>7.039315</td>
      <td>-2.836472</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>6.849794</td>
      <td>-1.872265</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.708947</td>
      <td>-1.437656</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.798207</td>
      <td>-1.576380</td>
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
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>[-0.8660253882408142, -2.381569817662239, -0.4...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[-2.1650634706020355, -1.0825317353010178, -1....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[0.4330126941204071, -0.8660253882408142, -0.6...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.4330126941204071, -0.8660253882408142, -0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.0, -1.5155444294214249, -0.4330126941204071...</td>
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
    Iteration   50, KL divergence -0.6393, 50 iterations in 0.0641 sec
    Iteration  100, KL divergence -2.8375, 50 iterations in 0.0184 sec
    Iteration  150, KL divergence -2.8375, 50 iterations in 0.0167 sec
    Iteration  200, KL divergence -2.8375, 50 iterations in 0.0164 sec
    Iteration  250, KL divergence 1.2099, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5723, 50 iterations in 0.0548 sec
    Iteration  100, KL divergence 0.5394, 50 iterations in 0.0489 sec
    Iteration  150, KL divergence 0.5391, 50 iterations in 0.0476 sec
    Iteration  200, KL divergence 0.5395, 50 iterations in 0.0468 sec
    Iteration  250, KL divergence 0.5400, 50 iterations in 0.0465 sec
    Iteration  300, KL divergence 0.5391, 50 iterations in 0.0466 sec
    Iteration  350, KL divergence 0.5394, 50 iterations in 0.0486 sec
    Iteration  400, KL divergence 0.5396, 50 iterations in 0.0480 sec
    Iteration  450, KL divergence 0.5394, 50 iterations in 0.0474 sec
    Iteration  500, KL divergence 0.5393, 50 iterations in 0.0476 sec
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
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>1.211948</td>
      <td>-5.601424</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>3.690473</td>
      <td>-4.289478</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>8.097313</td>
      <td>-2.481964</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>8.076020</td>
      <td>-1.853041</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>8.116441</td>
      <td>-1.692510</td>
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
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>[0.018138015642762184, -0.10909265279769897, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[-0.18306507170200348, -0.26565366983413696, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.1524665653705597, -0.11665873974561691, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.2538345158100128, -0.1217074766755104, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.16402973234653473, -0.1561640053987503, 0....</td>
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
    Iteration   50, KL divergence -0.8054, 50 iterations in 0.0647 sec
    Iteration  100, KL divergence 1.1565, 50 iterations in 0.0165 sec
    Iteration  150, KL divergence 1.1565, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.1565, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.1565, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3646, 50 iterations in 0.0535 sec
    Iteration  100, KL divergence 0.3458, 50 iterations in 0.0509 sec
    Iteration  150, KL divergence 0.3242, 50 iterations in 0.0480 sec
    Iteration  200, KL divergence 0.3225, 50 iterations in 0.0465 sec
    Iteration  250, KL divergence 0.3226, 50 iterations in 0.0480 sec
    Iteration  300, KL divergence 0.3229, 50 iterations in 0.0474 sec
    Iteration  350, KL divergence 0.3229, 50 iterations in 0.0478 sec
    Iteration  400, KL divergence 0.3233, 50 iterations in 0.0460 sec
    Iteration  450, KL divergence 0.3232, 50 iterations in 0.0453 sec
    Iteration  500, KL divergence 0.3233, 50 iterations in 0.0455 sec
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
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>1.905515</td>
      <td>-4.779197</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>3.409189</td>
      <td>-5.072080</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>2.787079</td>
      <td>-5.364796</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>0.663020</td>
      <td>-1.456821</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>2.901685</td>
      <td>-5.060346</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

