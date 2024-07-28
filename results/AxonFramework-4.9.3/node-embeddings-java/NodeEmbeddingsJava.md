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
      <td>org.axonframework.test</td>
      <td>test</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>[-0.22466301918029785, 0.25969457626342773, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.26439180970191956, 0.21783214807510376, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[-0.21339406073093414, 0.24127791821956635, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.21123544871807098, 0.22235634922981262, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[-0.140242338180542, 0.19431671500205994, 0.28...</td>
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
       --> Time elapsed: 0.01 seconds
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -1.0478, 50 iterations in 0.0734 sec
    Iteration  100, KL divergence 1.0007, 50 iterations in 0.0378 sec
    Iteration  150, KL divergence 1.0007, 50 iterations in 0.0247 sec
    Iteration  200, KL divergence 1.0007, 50 iterations in 0.0136 sec
    Iteration  250, KL divergence 1.0007, 50 iterations in 0.0132 sec
       --> Time elapsed: 0.16 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1661, 50 iterations in 0.0322 sec
    Iteration  100, KL divergence 0.1075, 50 iterations in 0.0342 sec
    Iteration  150, KL divergence 0.0707, 50 iterations in 0.0348 sec
    Iteration  200, KL divergence 0.0709, 50 iterations in 0.0338 sec
    Iteration  250, KL divergence 0.0707, 50 iterations in 0.0340 sec
    Iteration  300, KL divergence 0.0710, 50 iterations in 0.0348 sec
    Iteration  350, KL divergence 0.0597, 50 iterations in 0.0344 sec
    Iteration  400, KL divergence 0.0613, 50 iterations in 0.0333 sec
    Iteration  450, KL divergence 0.0610, 50 iterations in 0.0328 sec
    Iteration  500, KL divergence 0.0606, 50 iterations in 0.0330 sec
       --> Time elapsed: 0.34 seconds



    (93, 2)



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
      <td>org.axonframework.test</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>5.544343</td>
      <td>-0.109414</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>5.477674</td>
      <td>-0.008287</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>5.495470</td>
      <td>-0.027921</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>5.496336</td>
      <td>-0.032063</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>5.426240</td>
      <td>0.075533</td>
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
      <td>org.axonframework.test</td>
      <td>test</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.0,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[0.21650634706020355, -1.5155444294214249, 0.0...</td>
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
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence 0.8469, 50 iterations in 0.0449 sec
    Iteration  100, KL divergence 0.8999, 50 iterations in 0.0424 sec
    Iteration  150, KL divergence 0.8669, 50 iterations in 0.0423 sec
    Iteration  200, KL divergence 0.8980, 50 iterations in 0.0532 sec
    Iteration  250, KL divergence 0.8852, 50 iterations in 0.0301 sec
       --> Time elapsed: 0.21 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.2259, 50 iterations in 0.0367 sec
    Iteration  100, KL divergence 0.2191, 50 iterations in 0.0368 sec
    Iteration  150, KL divergence 0.2170, 50 iterations in 0.0369 sec
    Iteration  200, KL divergence 0.2188, 50 iterations in 0.0364 sec
    Iteration  250, KL divergence 0.2184, 50 iterations in 0.0357 sec
    Iteration  300, KL divergence 0.2182, 50 iterations in 0.0364 sec
    Iteration  350, KL divergence 0.2117, 50 iterations in 0.0369 sec
    Iteration  400, KL divergence 0.2185, 50 iterations in 0.0351 sec
    Iteration  450, KL divergence 0.2096, 50 iterations in 0.0343 sec
    Iteration  500, KL divergence 0.1968, 50 iterations in 0.0355 sec
       --> Time elapsed: 0.36 seconds



    (93, 2)



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
      <td>org.axonframework.test</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>5.741102</td>
      <td>-0.299330</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>5.840776</td>
      <td>-0.325893</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>5.741342</td>
      <td>-0.308301</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>5.749229</td>
      <td>-0.334412</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>5.759889</td>
      <td>-0.124051</td>
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
      <td>org.axonframework.test</td>
      <td>test</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>[1.6938457489013672, 0.0011474936036393046, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[1.6114681959152222, -0.014881737530231476, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[1.6476922035217285, -0.04262004420161247, 0.3...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[1.3345069885253906, -0.007069097366183996, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[1.5777901411056519, 0.02468828856945038, 0.33...</td>
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
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -0.5632, 50 iterations in 0.0309 sec
    Iteration  100, KL divergence 0.9742, 50 iterations in 0.0132 sec
    Iteration  150, KL divergence 0.9742, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 0.9742, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 0.9742, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1639, 50 iterations in 0.0397 sec
    Iteration  100, KL divergence 0.1366, 50 iterations in 0.0525 sec
    Iteration  150, KL divergence 0.1313, 50 iterations in 0.0380 sec
    Iteration  200, KL divergence 0.1310, 50 iterations in 0.0356 sec
    Iteration  250, KL divergence 0.1313, 50 iterations in 0.0355 sec
    Iteration  300, KL divergence 0.1306, 50 iterations in 0.0357 sec
    Iteration  350, KL divergence 0.1307, 50 iterations in 0.0364 sec
    Iteration  400, KL divergence 0.1307, 50 iterations in 0.0368 sec
    Iteration  450, KL divergence 0.1309, 50 iterations in 0.0450 sec
    Iteration  500, KL divergence 0.1307, 50 iterations in 0.0363 sec
       --> Time elapsed: 0.39 seconds



    (93, 2)



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
      <td>org.axonframework.test</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>-7.614900</td>
      <td>-0.210921</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-7.604026</td>
      <td>-0.468501</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>-7.684710</td>
      <td>-0.355672</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-7.647562</td>
      <td>-0.494682</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>-7.459236</td>
      <td>-0.284937</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

