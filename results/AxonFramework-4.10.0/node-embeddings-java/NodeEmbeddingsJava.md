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
      <td>[-0.46639496088027954, -0.08739567548036575, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[-0.5170594453811646, 0.0016787555068731308, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[-0.38894668221473694, -0.16302970051765442, 0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.3032928705215454, -0.18642829358577728, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[-0.3294175863265991, -0.18728020787239075, 0....</td>
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
    Iteration   50, KL divergence -0.4735, 50 iterations in 0.0554 sec
    Iteration  100, KL divergence 1.2186, 50 iterations in 0.0159 sec
    Iteration  150, KL divergence 1.2186, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.2186, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2186, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2464, 50 iterations in 0.0496 sec
    Iteration  100, KL divergence 0.2197, 50 iterations in 0.0483 sec
    Iteration  150, KL divergence 0.1931, 50 iterations in 0.0448 sec
    Iteration  200, KL divergence 0.1904, 50 iterations in 0.0453 sec
    Iteration  250, KL divergence 0.1904, 50 iterations in 0.0454 sec
    Iteration  300, KL divergence 0.1895, 50 iterations in 0.0472 sec
    Iteration  350, KL divergence 0.1893, 50 iterations in 0.0543 sec
    Iteration  400, KL divergence 0.1894, 50 iterations in 0.0466 sec
    Iteration  450, KL divergence 0.1889, 50 iterations in 0.0459 sec
    Iteration  500, KL divergence 0.1894, 50 iterations in 0.0455 sec
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
      <td>-1.841751</td>
      <td>-4.491582</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>-2.955510</td>
      <td>-4.658383</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>-2.081329</td>
      <td>-5.648263</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-1.636292</td>
      <td>-5.954824</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-1.734571</td>
      <td>-5.900079</td>
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
      <td>[0.6495190411806107, 1.0825317353010178, -1.29...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[0.4330126941204071, -0.8660253882408142, -1.7...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[1.7320507764816284, -0.4330126941204071, -1.7...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.8660253882408142, -0.4330126941204071, -0.4...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[1.0825317353010178, -0.4330126941204071, -0.2...</td>
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
    Iteration   50, KL divergence -0.7832, 50 iterations in 0.0680 sec
    Iteration  100, KL divergence 1.2195, 50 iterations in 0.0175 sec
    Iteration  150, KL divergence 1.2195, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2195, 50 iterations in 0.0144 sec
    Iteration  250, KL divergence 1.2195, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6493, 50 iterations in 0.0513 sec
    Iteration  100, KL divergence 0.6324, 50 iterations in 0.0489 sec
    Iteration  150, KL divergence 0.6315, 50 iterations in 0.0477 sec
    Iteration  200, KL divergence 0.6304, 50 iterations in 0.0474 sec
    Iteration  250, KL divergence 0.6303, 50 iterations in 0.0468 sec
    Iteration  300, KL divergence 0.6309, 50 iterations in 0.0470 sec
    Iteration  350, KL divergence 0.6309, 50 iterations in 0.0481 sec
    Iteration  400, KL divergence 0.6310, 50 iterations in 0.0483 sec
    Iteration  450, KL divergence 0.6302, 50 iterations in 0.0480 sec
    Iteration  500, KL divergence 0.6300, 50 iterations in 0.0480 sec
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
      <td>-6.170457</td>
      <td>0.576076</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>-0.158201</td>
      <td>-0.941531</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>-0.685900</td>
      <td>-7.984552</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-0.321556</td>
      <td>-7.001405</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>-0.309110</td>
      <td>-6.982683</td>
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
      <td>[0.0784028023481369, 0.18616634607315063, 0.43...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>[0.24456802010536194, -0.007436351850628853, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>[0.006480646785348654, 0.08215318620204926, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.024745481088757515, 0.1282261610031128, 0.4...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>[0.23122557997703552, 0.12876950204372406, 0.4...</td>
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
    Iteration   50, KL divergence -0.8667, 50 iterations in 0.0646 sec
    Iteration  100, KL divergence 1.1702, 50 iterations in 0.0168 sec
    Iteration  150, KL divergence 1.1702, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.1702, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.1702, 50 iterations in 0.0146 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3051, 50 iterations in 0.0521 sec
    Iteration  100, KL divergence 0.2841, 50 iterations in 0.0492 sec
    Iteration  150, KL divergence 0.2788, 50 iterations in 0.0483 sec
    Iteration  200, KL divergence 0.2789, 50 iterations in 0.0475 sec
    Iteration  250, KL divergence 0.2790, 50 iterations in 0.0471 sec
    Iteration  300, KL divergence 0.2796, 50 iterations in 0.0474 sec
    Iteration  350, KL divergence 0.2796, 50 iterations in 0.0488 sec
    Iteration  400, KL divergence 0.2798, 50 iterations in 0.0479 sec
    Iteration  450, KL divergence 0.2794, 50 iterations in 0.0476 sec
    Iteration  500, KL divergence 0.2797, 50 iterations in 0.0528 sec
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
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.088294</td>
      <td>4.112405</td>
      <td>4.905449</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.023309</td>
      <td>4.305611</td>
      <td>5.839366</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.014288</td>
      <td>3.558993</td>
      <td>5.232541</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>2.598696</td>
      <td>4.453827</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.0</td>
      <td>0</td>
      <td>0.012212</td>
      <td>2.825176</td>
      <td>5.868382</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

