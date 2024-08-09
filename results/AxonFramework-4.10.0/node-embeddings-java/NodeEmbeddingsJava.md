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
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.081762</td>
      <td>[-0.23907749354839325, 0.25115057826042175, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.25671643018722534, 0.22634342312812805, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[-0.23002834618091583, 0.2406129688024521, 0.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.2189161479473114, 0.23353014886379242, 0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[-0.15309275686740875, 0.18397949635982513, 0....</td>
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
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence 0.4284, 50 iterations in 0.0366 sec
    Iteration  100, KL divergence 1.0097, 50 iterations in 0.0131 sec
    Iteration  150, KL divergence 1.0097, 50 iterations in 0.0122 sec
    Iteration  200, KL divergence 1.0097, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0097, 50 iterations in 0.0123 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1259, 50 iterations in 0.0391 sec
    Iteration  100, KL divergence 0.0946, 50 iterations in 0.0503 sec
    Iteration  150, KL divergence 0.0892, 50 iterations in 0.0370 sec
    Iteration  200, KL divergence 0.0889, 50 iterations in 0.0345 sec
    Iteration  250, KL divergence 0.0888, 50 iterations in 0.0339 sec
    Iteration  300, KL divergence 0.0773, 50 iterations in 0.0407 sec
    Iteration  350, KL divergence 0.0801, 50 iterations in 0.0341 sec
    Iteration  400, KL divergence 0.0797, 50 iterations in 0.0333 sec
    Iteration  450, KL divergence 0.0971, 50 iterations in 0.0322 sec
    Iteration  500, KL divergence 0.0815, 50 iterations in 0.0330 sec
       --> Time elapsed: 0.37 seconds



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
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.081762</td>
      <td>4.971318</td>
      <td>2.972117</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>4.917484</td>
      <td>2.897590</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>4.931409</td>
      <td>2.955182</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>4.938745</td>
      <td>2.942061</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>4.809856</td>
      <td>2.983166</td>
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
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.081762</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.21650634706020355, -1.5155444294214249, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.0,...</td>
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
    Iteration   50, KL divergence -0.5435, 50 iterations in 0.0402 sec
    Iteration  100, KL divergence 1.0704, 50 iterations in 0.0142 sec
    Iteration  150, KL divergence 1.0704, 50 iterations in 0.0123 sec
    Iteration  200, KL divergence 1.0704, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0704, 50 iterations in 0.0123 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.2573, 50 iterations in 0.0394 sec
    Iteration  100, KL divergence 0.2430, 50 iterations in 0.0515 sec
    Iteration  150, KL divergence 0.2311, 50 iterations in 0.0376 sec
    Iteration  200, KL divergence 0.2306, 50 iterations in 0.0362 sec
    Iteration  250, KL divergence 0.2336, 50 iterations in 0.0367 sec
    Iteration  300, KL divergence 0.2337, 50 iterations in 0.0367 sec
    Iteration  350, KL divergence 0.2368, 50 iterations in 0.0356 sec
    Iteration  400, KL divergence 0.2361, 50 iterations in 0.0356 sec
    Iteration  450, KL divergence 0.2361, 50 iterations in 0.0360 sec
    Iteration  500, KL divergence 0.2363, 50 iterations in 0.0356 sec
       --> Time elapsed: 0.38 seconds



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
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.081762</td>
      <td>4.676159</td>
      <td>-0.986991</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>5.173707</td>
      <td>-0.529099</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>4.844628</td>
      <td>-0.650783</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>4.617870</td>
      <td>-0.868503</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>5.031192</td>
      <td>-1.015338</td>
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
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.081762</td>
      <td>[-0.13272975385189056, -0.06747594475746155, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.12539257109165192, -0.19138063490390778, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[-0.07346031814813614, -0.08692897856235504, 0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.062499117106199265, -0.12165752053260803, ...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[-0.1588459610939026, -0.13457316160202026, 0....</td>
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
    Iteration   50, KL divergence -0.7787, 50 iterations in 0.0306 sec
    Iteration  100, KL divergence 0.9820, 50 iterations in 0.0134 sec
    Iteration  150, KL divergence 0.9820, 50 iterations in 0.0124 sec
    Iteration  200, KL divergence 0.9820, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 0.9820, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1432, 50 iterations in 0.0401 sec
    Iteration  100, KL divergence 0.1135, 50 iterations in 0.0497 sec
    Iteration  150, KL divergence 0.1066, 50 iterations in 0.0399 sec
    Iteration  200, KL divergence 0.1065, 50 iterations in 0.0348 sec
    Iteration  250, KL divergence 0.1062, 50 iterations in 0.0354 sec
    Iteration  300, KL divergence 0.1059, 50 iterations in 0.0355 sec
    Iteration  350, KL divergence 0.1056, 50 iterations in 0.0354 sec
    Iteration  400, KL divergence 0.1048, 50 iterations in 0.0355 sec
    Iteration  450, KL divergence 0.1053, 50 iterations in 0.0367 sec
    Iteration  500, KL divergence 0.1052, 50 iterations in 0.0357 sec
       --> Time elapsed: 0.38 seconds



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
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.081762</td>
      <td>-3.926047</td>
      <td>-5.139189</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-3.697922</td>
      <td>-4.924778</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>-3.726962</td>
      <td>-5.051698</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-4.120181</td>
      <td>-5.009314</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>-3.897639</td>
      <td>-4.746656</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

