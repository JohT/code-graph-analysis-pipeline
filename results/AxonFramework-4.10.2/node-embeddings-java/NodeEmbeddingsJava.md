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
      <td>[-0.7522660493850708, -0.007106993347406387, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[-0.7839622497558594, -0.19446444511413574, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.6704540252685547, -0.19453763961791992, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.5693390369415283, -0.18449585139751434, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.5913885831832886, -0.18970248103141785, 0....</td>
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
    Iteration   50, KL divergence -0.1262, 50 iterations in 0.0550 sec
    Iteration  100, KL divergence 1.2097, 50 iterations in 0.0155 sec
    Iteration  150, KL divergence 1.2097, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2097, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2097, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.11 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1725, 50 iterations in 0.0502 sec
    Iteration  100, KL divergence 0.1497, 50 iterations in 0.0472 sec
    Iteration  150, KL divergence 0.1409, 50 iterations in 0.0439 sec
    Iteration  200, KL divergence 0.1387, 50 iterations in 0.0439 sec
    Iteration  250, KL divergence 0.1389, 50 iterations in 0.0435 sec
    Iteration  300, KL divergence 0.1390, 50 iterations in 0.0451 sec
    Iteration  350, KL divergence 0.1389, 50 iterations in 0.0454 sec
    Iteration  400, KL divergence 0.1387, 50 iterations in 0.0455 sec
    Iteration  450, KL divergence 0.1386, 50 iterations in 0.0439 sec
    Iteration  500, KL divergence 0.1386, 50 iterations in 0.0441 sec
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
      <td>-6.245686</td>
      <td>-4.094637</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>-7.352096</td>
      <td>-3.683646</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>-7.254509</td>
      <td>-4.512626</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-7.163456</td>
      <td>-4.919149</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-7.314295</td>
      <td>-4.851819</td>
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
      <td>[0.4330126941204071, -0.4330126941204071, -1.7...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[-0.21650634706020355, 0.0, -1.732050776481628...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[0.6495190411806107, -1.0825317353010178, -1.5...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.21650634706020355, -1.0825317353010178, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.21650634706020355, -1.0825317353010178, -0....</td>
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
    Iteration   50, KL divergence -0.6194, 50 iterations in 0.0714 sec
    Iteration  100, KL divergence 1.2191, 50 iterations in 0.0189 sec
    Iteration  150, KL divergence 1.2191, 50 iterations in 0.0144 sec
    Iteration  200, KL divergence 1.2191, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2191, 50 iterations in 0.0143 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6006, 50 iterations in 0.0516 sec
    Iteration  100, KL divergence 0.5868, 50 iterations in 0.0476 sec
    Iteration  150, KL divergence 0.5817, 50 iterations in 0.0465 sec
    Iteration  200, KL divergence 0.5811, 50 iterations in 0.0434 sec
    Iteration  250, KL divergence 0.5813, 50 iterations in 0.0436 sec
    Iteration  300, KL divergence 0.5814, 50 iterations in 0.0433 sec
    Iteration  350, KL divergence 0.5814, 50 iterations in 0.0441 sec
    Iteration  400, KL divergence 0.5814, 50 iterations in 0.0441 sec
    Iteration  450, KL divergence 0.5815, 50 iterations in 0.0439 sec
    Iteration  500, KL divergence 0.5813, 50 iterations in 0.0450 sec
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
      <td>-2.012555</td>
      <td>-3.735270</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>-3.196121</td>
      <td>6.377282</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>-3.420827</td>
      <td>4.102326</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-3.974240</td>
      <td>3.606471</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-4.215148</td>
      <td>3.722826</td>
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
      <td>[0.2858395278453827, -0.1534721404314041, 0.00...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[0.22047129273414612, -0.1565546691417694, 0.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[0.3185337781906128, -0.25032103061676025, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.17592698335647583, -0.1431637853384018, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.22548748552799225, -0.14598971605300903, -0...</td>
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
    Iteration   50, KL divergence -0.5251, 50 iterations in 0.0633 sec
    Iteration  100, KL divergence 1.1637, 50 iterations in 0.0163 sec
    Iteration  150, KL divergence 1.1637, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.1637, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.1637, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3108, 50 iterations in 0.0523 sec
    Iteration  100, KL divergence 0.2900, 50 iterations in 0.0466 sec
    Iteration  150, KL divergence 0.2828, 50 iterations in 0.0458 sec
    Iteration  200, KL divergence 0.2830, 50 iterations in 0.0457 sec
    Iteration  250, KL divergence 0.2833, 50 iterations in 0.0468 sec
    Iteration  300, KL divergence 0.2831, 50 iterations in 0.0476 sec
    Iteration  350, KL divergence 0.2830, 50 iterations in 0.0474 sec
    Iteration  400, KL divergence 0.2831, 50 iterations in 0.0463 sec
    Iteration  450, KL divergence 0.2832, 50 iterations in 0.0463 sec
    Iteration  500, KL divergence 0.2833, 50 iterations in 0.0462 sec
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
      <td>-2.031987</td>
      <td>5.724866</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>-1.350261</td>
      <td>7.047898</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>-1.148946</td>
      <td>5.983007</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-1.102265</td>
      <td>3.747216</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-0.870000</td>
      <td>5.410104</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

