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
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence 0.2132, 50 iterations in 0.0336 sec
    Iteration  100, KL divergence 1.0082, 50 iterations in 0.0129 sec
    Iteration  150, KL divergence 1.0082, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 1.0082, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0082, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1264, 50 iterations in 0.0378 sec
    Iteration  100, KL divergence 0.0864, 50 iterations in 0.0519 sec
    Iteration  150, KL divergence 0.0815, 50 iterations in 0.0370 sec
    Iteration  200, KL divergence 0.0819, 50 iterations in 0.0354 sec
    Iteration  250, KL divergence 0.0793, 50 iterations in 0.0350 sec
    Iteration  300, KL divergence 0.0795, 50 iterations in 0.0350 sec
    Iteration  350, KL divergence 0.0792, 50 iterations in 0.0352 sec
    Iteration  400, KL divergence 0.0819, 50 iterations in 0.0360 sec
    Iteration  450, KL divergence 0.0817, 50 iterations in 0.0357 sec
    Iteration  500, KL divergence 0.0815, 50 iterations in 0.0350 sec
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
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>3.481504</td>
      <td>-4.767530</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>3.543989</td>
      <td>-4.608189</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>3.565082</td>
      <td>-4.623843</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>3.791463</td>
      <td>-4.755737</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>3.822810</td>
      <td>-4.574775</td>
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
      <td>[0.21650634706020355, -1.5155444294214249, 0.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.0, -1.2990380823612213, -0.2165063470602035...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[0.21650634706020355, -1.5155444294214249, 0.0...</td>
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
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
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
    Iteration   50, KL divergence -0.7534, 50 iterations in 0.0377 sec
    Iteration  100, KL divergence 1.0733, 50 iterations in 0.0133 sec
    Iteration  150, KL divergence 1.0733, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 1.0733, 50 iterations in 0.0127 sec
    Iteration  250, KL divergence 1.0733, 50 iterations in 0.0130 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.2854, 50 iterations in 0.0398 sec
    Iteration  100, KL divergence 0.2575, 50 iterations in 0.0497 sec
    Iteration  150, KL divergence 0.2448, 50 iterations in 0.0371 sec
    Iteration  200, KL divergence 0.2448, 50 iterations in 0.0376 sec
    Iteration  250, KL divergence 0.2448, 50 iterations in 0.0378 sec
    Iteration  300, KL divergence 0.2449, 50 iterations in 0.0376 sec
    Iteration  350, KL divergence 0.2473, 50 iterations in 0.0369 sec
    Iteration  400, KL divergence 0.2474, 50 iterations in 0.0368 sec
    Iteration  450, KL divergence 0.2452, 50 iterations in 0.0377 sec
    Iteration  500, KL divergence 0.2485, 50 iterations in 0.0364 sec
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
      <td>-4.486129</td>
      <td>3.430408</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-4.385007</td>
      <td>3.400771</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>-4.495854</td>
      <td>3.450914</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-4.714739</td>
      <td>3.520470</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>-4.718060</td>
      <td>3.525906</td>
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
      <td>[1.5573259592056274, 0.8355397582054138, 0.326...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[1.4015076160430908, 0.7109981775283813, 0.207...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[1.4874755144119263, 0.7386007308959961, 0.312...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[1.4104052782058716, 0.6944995522499084, 0.318...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[1.4434181451797485, 0.7167187929153442, 0.233...</td>
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
    Iteration   50, KL divergence 0.2169, 50 iterations in 0.0309 sec
    Iteration  100, KL divergence 0.9883, 50 iterations in 0.0130 sec
    Iteration  150, KL divergence 0.9883, 50 iterations in 0.0126 sec
    Iteration  200, KL divergence 0.9883, 50 iterations in 0.0127 sec
    Iteration  250, KL divergence 0.9883, 50 iterations in 0.0128 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1704, 50 iterations in 0.0378 sec
    Iteration  100, KL divergence 0.1167, 50 iterations in 0.0534 sec
    Iteration  150, KL divergence 0.1139, 50 iterations in 0.0374 sec
    Iteration  200, KL divergence 0.1120, 50 iterations in 0.0346 sec
    Iteration  250, KL divergence 0.1105, 50 iterations in 0.0344 sec
    Iteration  300, KL divergence 0.1099, 50 iterations in 0.0335 sec
    Iteration  350, KL divergence 0.1104, 50 iterations in 0.0340 sec
    Iteration  400, KL divergence 0.1102, 50 iterations in 0.0343 sec
    Iteration  450, KL divergence 0.1110, 50 iterations in 0.0343 sec
    Iteration  500, KL divergence 0.1105, 50 iterations in 0.0346 sec
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
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>-5.887724</td>
      <td>-5.152814</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-6.159307</td>
      <td>-5.257149</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>-5.963929</td>
      <td>-5.148438</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-6.214207</td>
      <td>-5.079357</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>-5.903118</td>
      <td>-4.865750</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

