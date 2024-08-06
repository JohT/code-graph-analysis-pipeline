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
      <td>org.axonframework.config</td>
      <td>config</td>
      <td>axon-configuration-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.062857</td>
      <td>[-0.27048173546791077, 0.15818534791469574, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>[-0.43146565556526184, 0.09490527212619781, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>[-0.3541834056377411, 0.27760809659957886, 0.0...</td>
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
       --> Time elapsed: 0.07 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.01 seconds
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -1.1245, 50 iterations in 0.0809 sec
    Iteration  100, KL divergence 1.0131, 50 iterations in 0.0259 sec
    Iteration  150, KL divergence 1.0131, 50 iterations in 0.0203 sec
    Iteration  200, KL divergence 1.0131, 50 iterations in 0.0239 sec
    Iteration  250, KL divergence 1.0131, 50 iterations in 0.0129 sec
       --> Time elapsed: 0.16 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1379, 50 iterations in 0.0392 sec
    Iteration  100, KL divergence 0.0975, 50 iterations in 0.0349 sec
    Iteration  150, KL divergence 0.0950, 50 iterations in 0.0353 sec
    Iteration  200, KL divergence 0.0894, 50 iterations in 0.0359 sec
    Iteration  250, KL divergence 0.0828, 50 iterations in 0.0348 sec
    Iteration  300, KL divergence 0.0832, 50 iterations in 0.0332 sec
    Iteration  350, KL divergence 0.0834, 50 iterations in 0.0326 sec
    Iteration  400, KL divergence 0.0834, 50 iterations in 0.0331 sec
    Iteration  450, KL divergence 0.0833, 50 iterations in 0.0328 sec
    Iteration  500, KL divergence 0.0831, 50 iterations in 0.0329 sec
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
      <td>org.axonframework.config</td>
      <td>axon-configuration-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-2.678622</td>
      <td>2.909998</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>-2.678621</td>
      <td>2.909998</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.062857</td>
      <td>5.519380</td>
      <td>0.591608</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>5.939886</td>
      <td>0.918748</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>5.222270</td>
      <td>-0.013345</td>
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
      <td>org.axonframework.config</td>
      <td>config</td>
      <td>axon-configuration-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.21650634706020355, 0.0, 0.0, 0.0, 0.0, 0.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>[-0.21650634706020355, -0.4330126941204071, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.062857</td>
      <td>[0.21650634706020355, -1.0825317353010178, -1....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>[-0.21650634706020355, -0.8660253882408142, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>[0.21650634706020355, -1.2990380823612213, -1....</td>
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
    Iteration   50, KL divergence -0.0976, 50 iterations in 0.0410 sec
    Iteration  100, KL divergence 1.0677, 50 iterations in 0.0130 sec
    Iteration  150, KL divergence 1.0677, 50 iterations in 0.0123 sec
    Iteration  200, KL divergence 1.0677, 50 iterations in 0.0123 sec
    Iteration  250, KL divergence 1.0677, 50 iterations in 0.0123 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.3058, 50 iterations in 0.0385 sec
    Iteration  100, KL divergence 0.2582, 50 iterations in 0.0506 sec
    Iteration  150, KL divergence 0.2530, 50 iterations in 0.0370 sec
    Iteration  200, KL divergence 0.2520, 50 iterations in 0.0372 sec
    Iteration  250, KL divergence 0.2511, 50 iterations in 0.0371 sec
    Iteration  300, KL divergence 0.2507, 50 iterations in 0.0362 sec
    Iteration  350, KL divergence 0.2497, 50 iterations in 0.0360 sec
    Iteration  400, KL divergence 0.2617, 50 iterations in 0.0365 sec
    Iteration  450, KL divergence 0.2612, 50 iterations in 0.0363 sec
    Iteration  500, KL divergence 0.2609, 50 iterations in 0.0437 sec
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
      <td>org.axonframework.config</td>
      <td>axon-configuration-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>3.544540</td>
      <td>1.793782</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>3.698756</td>
      <td>2.295813</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.062857</td>
      <td>-2.445662</td>
      <td>-4.036299</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>0.023891</td>
      <td>-4.804463</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>-0.458580</td>
      <td>-4.720376</td>
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
      <td>org.axonframework.config</td>
      <td>config</td>
      <td>axon-configuration-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.007990382611751556, -0.0016786546912044287,...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>[-0.013598830439150333, -0.004732140339910984,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.062857</td>
      <td>[0.5742443203926086, -0.2344251424074173, 0.29...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>[0.42670682072639465, -0.14512908458709717, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>[0.5693482756614685, -0.06831850111484528, 0.4...</td>
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
    Iteration   50, KL divergence -1.0545, 50 iterations in 0.0314 sec
    Iteration  100, KL divergence 0.9941, 50 iterations in 0.0131 sec
    Iteration  150, KL divergence 0.9941, 50 iterations in 0.0124 sec
    Iteration  200, KL divergence 0.9941, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 0.9941, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1612, 50 iterations in 0.0384 sec
    Iteration  100, KL divergence 0.1196, 50 iterations in 0.0504 sec
    Iteration  150, KL divergence 0.1091, 50 iterations in 0.0376 sec
    Iteration  200, KL divergence 0.1090, 50 iterations in 0.0339 sec
    Iteration  250, KL divergence 0.1087, 50 iterations in 0.0330 sec
    Iteration  300, KL divergence 0.1087, 50 iterations in 0.0329 sec
    Iteration  350, KL divergence 0.1086, 50 iterations in 0.0328 sec
    Iteration  400, KL divergence 0.1088, 50 iterations in 0.0329 sec
    Iteration  450, KL divergence 0.1086, 50 iterations in 0.0328 sec
    Iteration  500, KL divergence 0.1085, 50 iterations in 0.0334 sec
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
      <td>org.axonframework.config</td>
      <td>axon-configuration-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>2.581564</td>
      <td>-1.631700</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>2.581648</td>
      <td>-1.631576</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.062857</td>
      <td>-0.383026</td>
      <td>-4.389395</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>-0.458215</td>
      <td>-5.214401</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>0.500277</td>
      <td>-4.391312</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

