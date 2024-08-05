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
      <td>[-0.08744904398918152, -0.17212477326393127, 0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>[-0.2598460614681244, -0.35355132818222046, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>[-0.19942130148410797, 0.000577540835365653, 0...</td>
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
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -1.9113, 50 iterations in 0.0372 sec
    Iteration  100, KL divergence 1.0161, 50 iterations in 0.0130 sec
    Iteration  150, KL divergence 1.0161, 50 iterations in 0.0141 sec
    Iteration  200, KL divergence 1.0161, 50 iterations in 0.0129 sec
    Iteration  250, KL divergence 1.0161, 50 iterations in 0.0125 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1250, 50 iterations in 0.0394 sec
    Iteration  100, KL divergence 0.0845, 50 iterations in 0.0490 sec
    Iteration  150, KL divergence 0.0805, 50 iterations in 0.0327 sec
    Iteration  200, KL divergence 0.0781, 50 iterations in 0.0331 sec
    Iteration  250, KL divergence 0.0780, 50 iterations in 0.0342 sec
    Iteration  300, KL divergence 0.0759, 50 iterations in 0.0330 sec
    Iteration  350, KL divergence 0.0751, 50 iterations in 0.0338 sec
    Iteration  400, KL divergence 0.0751, 50 iterations in 0.0323 sec
    Iteration  450, KL divergence 0.0753, 50 iterations in 0.0326 sec
    Iteration  500, KL divergence 0.0752, 50 iterations in 0.0318 sec
       --> Time elapsed: 0.35 seconds



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
      <td>2.401973</td>
      <td>-4.330330</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>2.401973</td>
      <td>-4.330330</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.062857</td>
      <td>0.193647</td>
      <td>5.624925</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>0.528206</td>
      <td>6.143056</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>0.598804</td>
      <td>5.203233</td>
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
      <td>[0.4330126941204071, -0.6495190411806107, -0.4...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>[0.4330126941204071, -1.7320507764816284, -0.6...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>[0.4330126941204071, -1.2990380823612213, -0.4...</td>
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
       --> Time elapsed: 0.01 seconds
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -0.5819, 50 iterations in 0.0757 sec
    Iteration  100, KL divergence 1.0627, 50 iterations in 0.0136 sec
    Iteration  150, KL divergence 1.0627, 50 iterations in 0.0133 sec
    Iteration  200, KL divergence 1.0627, 50 iterations in 0.0128 sec
    Iteration  250, KL divergence 1.0627, 50 iterations in 0.0127 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.2284, 50 iterations in 0.0403 sec
    Iteration  100, KL divergence 0.2087, 50 iterations in 0.0382 sec
    Iteration  150, KL divergence 0.2038, 50 iterations in 0.0347 sec
    Iteration  200, KL divergence 0.2035, 50 iterations in 0.0349 sec
    Iteration  250, KL divergence 0.2031, 50 iterations in 0.0354 sec
    Iteration  300, KL divergence 0.1969, 50 iterations in 0.0362 sec
    Iteration  350, KL divergence 0.2033, 50 iterations in 0.0359 sec
    Iteration  400, KL divergence 0.1947, 50 iterations in 0.0379 sec
    Iteration  450, KL divergence 0.1919, 50 iterations in 0.0370 sec
    Iteration  500, KL divergence 0.2030, 50 iterations in 0.0341 sec
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
      <td>-4.632584</td>
      <td>-1.757228</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>-4.988815</td>
      <td>-1.753539</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.062857</td>
      <td>2.531765</td>
      <td>5.172966</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>3.374667</td>
      <td>5.622766</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>3.330311</td>
      <td>4.840159</td>
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
      <td>[0.7724152207374573, 0.7057918906211853, -0.18...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>[0.8772542476654053, 0.6351722478866577, -0.43...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>[0.43655192852020264, 0.6812768578529358, 0.09...</td>
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
    Iteration   50, KL divergence -1.1349, 50 iterations in 0.0307 sec
    Iteration  100, KL divergence 1.0008, 50 iterations in 0.0131 sec
    Iteration  150, KL divergence 1.0008, 50 iterations in 0.0124 sec
    Iteration  200, KL divergence 1.0008, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0008, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1515, 50 iterations in 0.0374 sec
    Iteration  100, KL divergence 0.1304, 50 iterations in 0.0486 sec
    Iteration  150, KL divergence 0.1273, 50 iterations in 0.0380 sec
    Iteration  200, KL divergence 0.1275, 50 iterations in 0.0331 sec
    Iteration  250, KL divergence 0.1276, 50 iterations in 0.0325 sec
    Iteration  300, KL divergence 0.1279, 50 iterations in 0.0323 sec
    Iteration  350, KL divergence 0.1274, 50 iterations in 0.0328 sec
    Iteration  400, KL divergence 0.1269, 50 iterations in 0.0330 sec
    Iteration  450, KL divergence 0.1274, 50 iterations in 0.0338 sec
    Iteration  500, KL divergence 0.1271, 50 iterations in 0.0342 sec
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
      <td>0.034726</td>
      <td>-2.731626</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>0.035678</td>
      <td>-2.731897</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.062857</td>
      <td>-4.995836</td>
      <td>0.631613</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.020091</td>
      <td>-5.947439</td>
      <td>0.336541</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>2</td>
      <td>0.030160</td>
      <td>-5.117233</td>
      <td>1.434761</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

