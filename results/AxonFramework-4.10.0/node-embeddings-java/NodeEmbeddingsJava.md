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
      <td>[-0.659714937210083, -0.06230711191892624, 0.1...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[-0.5672626495361328, -0.029676325619220734, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[-0.613905668258667, -0.08698559552431107, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.5517697334289551, -0.04978996887803078, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.5723351836204529, -0.04799080267548561, -0...</td>
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
    Iteration   50, KL divergence -0.2991, 50 iterations in 0.0531 sec
    Iteration  100, KL divergence 1.2189, 50 iterations in 0.0158 sec
    Iteration  150, KL divergence 1.2189, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.2189, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2189, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.11 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1754, 50 iterations in 0.0488 sec
    Iteration  100, KL divergence 0.1553, 50 iterations in 0.0478 sec
    Iteration  150, KL divergence 0.1491, 50 iterations in 0.0427 sec
    Iteration  200, KL divergence 0.1479, 50 iterations in 0.0437 sec
    Iteration  250, KL divergence 0.1426, 50 iterations in 0.0427 sec
    Iteration  300, KL divergence 0.1426, 50 iterations in 0.0432 sec
    Iteration  350, KL divergence 0.1424, 50 iterations in 0.0440 sec
    Iteration  400, KL divergence 0.1425, 50 iterations in 0.0427 sec
    Iteration  450, KL divergence 0.1425, 50 iterations in 0.0425 sec
    Iteration  500, KL divergence 0.1422, 50 iterations in 0.0425 sec
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
      <td>-6.161004</td>
      <td>3.332846</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>-6.737284</td>
      <td>3.252995</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>-6.880116</td>
      <td>4.164802</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-7.377144</td>
      <td>4.069150</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-7.245483</td>
      <td>4.155103</td>
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
      <td>[1.2990380823612213, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[-0.4330126941204071, -1.0825317353010178, 0.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[1.0825317353010178, -1.7320507764816284, 0.21...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.0, -1.948557123541832, 0.21650634706020355,...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.6495190411806107, -1.948557123541832, 0.649...</td>
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
    Iteration   50, KL divergence -0.3826, 50 iterations in 0.0664 sec
    Iteration  100, KL divergence 1.2098, 50 iterations in 0.0187 sec
    Iteration  150, KL divergence 1.2098, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.2098, 50 iterations in 0.0143 sec
    Iteration  250, KL divergence 1.2098, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6165, 50 iterations in 0.0512 sec
    Iteration  100, KL divergence 0.5973, 50 iterations in 0.0461 sec
    Iteration  150, KL divergence 0.5962, 50 iterations in 0.0459 sec
    Iteration  200, KL divergence 0.5877, 50 iterations in 0.0443 sec
    Iteration  250, KL divergence 0.5886, 50 iterations in 0.0446 sec
    Iteration  300, KL divergence 0.5881, 50 iterations in 0.0449 sec
    Iteration  350, KL divergence 0.5883, 50 iterations in 0.0464 sec
    Iteration  400, KL divergence 0.5884, 50 iterations in 0.0462 sec
    Iteration  450, KL divergence 0.5882, 50 iterations in 0.0531 sec
    Iteration  500, KL divergence 0.5879, 50 iterations in 0.0467 sec
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
      <td>-4.943739</td>
      <td>-0.355457</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>1.951592</td>
      <td>-5.992235</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>4.426947</td>
      <td>-6.677497</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>4.252548</td>
      <td>-6.998051</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>4.221056</td>
      <td>-6.914791</td>
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
      <td>[0.38334324955940247, -0.3386620283126831, 0.2...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[0.37575656175613403, -0.3501276969909668, 0.3...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[0.41463702917099, -0.13989077508449554, 0.317...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.2936837375164032, -0.30023062229156494, 0.1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.44257882237434387, -0.28305909037590027, 0....</td>
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
    Iteration   50, KL divergence -0.8633, 50 iterations in 0.0636 sec
    Iteration  100, KL divergence 1.1666, 50 iterations in 0.0169 sec
    Iteration  150, KL divergence 1.1666, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.1666, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.1666, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3093, 50 iterations in 0.0551 sec
    Iteration  100, KL divergence 0.2895, 50 iterations in 0.0521 sec
    Iteration  150, KL divergence 0.2763, 50 iterations in 0.0488 sec
    Iteration  200, KL divergence 0.2752, 50 iterations in 0.0480 sec
    Iteration  250, KL divergence 0.2753, 50 iterations in 0.0484 sec
    Iteration  300, KL divergence 0.2754, 50 iterations in 0.0483 sec
    Iteration  350, KL divergence 0.2754, 50 iterations in 0.0492 sec
    Iteration  400, KL divergence 0.2750, 50 iterations in 0.0492 sec
    Iteration  450, KL divergence 0.2753, 50 iterations in 0.0483 sec
    Iteration  500, KL divergence 0.2751, 50 iterations in 0.0486 sec
       --> Time elapsed: 0.50 seconds



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
      <td>5.628654</td>
      <td>0.308987</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>6.243697</td>
      <td>0.886388</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>6.375682</td>
      <td>0.317490</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>4.807944</td>
      <td>1.646146</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>6.158235</td>
      <td>1.290965</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

