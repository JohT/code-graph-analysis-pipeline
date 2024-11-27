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
      <td>[-0.1515263170003891, 0.09383302927017212, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[-0.1975688487291336, -0.06982621550559998, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.2067357897758484, -0.013037709519267082, -...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.16775843501091003, 0.010361047461628914, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.1916571855545044, 0.007435358129441738, -0...</td>
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
       --> Time elapsed: 0.04 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.3355, 50 iterations in 0.0544 sec
    Iteration  100, KL divergence 1.2245, 50 iterations in 0.0158 sec
    Iteration  150, KL divergence 1.2245, 50 iterations in 0.0150 sec
    Iteration  200, KL divergence 1.2245, 50 iterations in 0.0186 sec
    Iteration  250, KL divergence 1.2245, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2219, 50 iterations in 0.0626 sec
    Iteration  100, KL divergence 0.1860, 50 iterations in 0.0433 sec
    Iteration  150, KL divergence 0.1776, 50 iterations in 0.0424 sec
    Iteration  200, KL divergence 0.1699, 50 iterations in 0.0438 sec
    Iteration  250, KL divergence 0.1680, 50 iterations in 0.0423 sec
    Iteration  300, KL divergence 0.1680, 50 iterations in 0.0427 sec
    Iteration  350, KL divergence 0.1680, 50 iterations in 0.0424 sec
    Iteration  400, KL divergence 0.1679, 50 iterations in 0.0419 sec
    Iteration  450, KL divergence 0.1680, 50 iterations in 0.0421 sec
    Iteration  500, KL divergence 0.1679, 50 iterations in 0.0423 sec
       --> Time elapsed: 0.45 seconds



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
      <td>5.496510</td>
      <td>-2.113257</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>6.222397</td>
      <td>-2.977620</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>6.612850</td>
      <td>-2.229837</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.561429</td>
      <td>-1.610921</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.697638</td>
      <td>-1.841272</td>
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
      <td>[-0.4330126941204071, -2.1650634706020355, -2....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[-0.8660253882408142, -2.814582511782646, -1.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.21650634706020355, -0.8660253882408142, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.6495190411806107, -0.8660253882408142, -1.7...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.8660253882408142, -0.6495190411806107, -0.8...</td>
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
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.2297, 50 iterations in 0.0691 sec
    Iteration  100, KL divergence 1.2336, 50 iterations in 0.0175 sec
    Iteration  150, KL divergence 1.2336, 50 iterations in 0.0143 sec
    Iteration  200, KL divergence 1.2336, 50 iterations in 0.0143 sec
    Iteration  250, KL divergence 1.2336, 50 iterations in 0.0143 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6779, 50 iterations in 0.0492 sec
    Iteration  100, KL divergence 0.6693, 50 iterations in 0.0476 sec
    Iteration  150, KL divergence 0.6672, 50 iterations in 0.0471 sec
    Iteration  200, KL divergence 0.6669, 50 iterations in 0.0467 sec
    Iteration  250, KL divergence 0.6661, 50 iterations in 0.0469 sec
    Iteration  300, KL divergence 0.6659, 50 iterations in 0.0460 sec
    Iteration  350, KL divergence 0.6656, 50 iterations in 0.0467 sec
    Iteration  400, KL divergence 0.6659, 50 iterations in 0.0467 sec
    Iteration  450, KL divergence 0.6656, 50 iterations in 0.0454 sec
    Iteration  500, KL divergence 0.6659, 50 iterations in 0.0450 sec
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
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>-1.823784</td>
      <td>2.331896</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>-6.551724</td>
      <td>-2.568553</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>0.144647</td>
      <td>2.383843</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-0.123298</td>
      <td>2.753965</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-0.049481</td>
      <td>2.724965</td>
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
      <td>[0.2990874648094177, 0.1134275570511818, 0.121...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[0.3334411382675171, 0.10434269905090332, 0.15...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[0.43718284368515015, 0.17197193205356598, 0.2...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.26001450419425964, 0.04405286908149719, 0.1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.2902913987636566, 0.11603305488824844, 0.10...</td>
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
    Iteration   50, KL divergence -0.8600, 50 iterations in 0.0650 sec
    Iteration  100, KL divergence 1.1612, 50 iterations in 0.0168 sec
    Iteration  150, KL divergence 1.1612, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.1612, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.1612, 50 iterations in 0.0149 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3651, 50 iterations in 0.0509 sec
    Iteration  100, KL divergence 0.3429, 50 iterations in 0.0484 sec
    Iteration  150, KL divergence 0.3304, 50 iterations in 0.0465 sec
    Iteration  200, KL divergence 0.3274, 50 iterations in 0.0458 sec
    Iteration  250, KL divergence 0.3269, 50 iterations in 0.0453 sec
    Iteration  300, KL divergence 0.3268, 50 iterations in 0.0461 sec
    Iteration  350, KL divergence 0.3262, 50 iterations in 0.0473 sec
    Iteration  400, KL divergence 0.3249, 50 iterations in 0.0465 sec
    Iteration  450, KL divergence 0.3031, 50 iterations in 0.0463 sec
    Iteration  500, KL divergence 0.3022, 50 iterations in 0.0454 sec
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
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>-0.979244</td>
      <td>5.714429</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>-1.740895</td>
      <td>5.814929</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>-0.954625</td>
      <td>6.195144</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-0.729474</td>
      <td>3.695377</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-1.926603</td>
      <td>5.403902</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

