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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing</td>
      <td>eventsourcing</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.109853</td>
      <td>[-0.34342852234840393, 0.015980778262019157, -...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.043972</td>
      <td>[-0.30521315336227417, 0.01402642298489809, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.183029</td>
      <td>[-0.38695839047431946, 0.015329143032431602, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>[-0.3564606308937073, 0.017619408667087555, -0...</td>
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
    Iteration   50, KL divergence 0.5081, 50 iterations in 0.0324 sec
    Iteration  100, KL divergence 1.0154, 50 iterations in 0.0131 sec
    Iteration  150, KL divergence 1.0154, 50 iterations in 0.0126 sec
    Iteration  200, KL divergence 1.0154, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0154, 50 iterations in 0.0123 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1013, 50 iterations in 0.0381 sec
    Iteration  100, KL divergence 0.0771, 50 iterations in 0.0497 sec
    Iteration  150, KL divergence 0.0688, 50 iterations in 0.0352 sec
    Iteration  200, KL divergence 0.0653, 50 iterations in 0.0336 sec
    Iteration  250, KL divergence 0.0655, 50 iterations in 0.0338 sec
    Iteration  300, KL divergence 0.0653, 50 iterations in 0.0336 sec
    Iteration  350, KL divergence 0.0656, 50 iterations in 0.0339 sec
    Iteration  400, KL divergence 0.0680, 50 iterations in 0.0349 sec
    Iteration  450, KL divergence 0.0692, 50 iterations in 0.0339 sec
    Iteration  500, KL divergence 0.0689, 50 iterations in 0.0329 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-4.577265</td>
      <td>1.090414</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.109853</td>
      <td>-7.066632</td>
      <td>1.131519</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.043972</td>
      <td>-7.315634</td>
      <td>1.065816</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.183029</td>
      <td>-6.953780</td>
      <td>0.638877</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>-6.879144</td>
      <td>1.042106</td>
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.0, 0.0, 0.0, -0.21650634706020355, 0.0, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing</td>
      <td>eventsourcing</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.109853</td>
      <td>[0.0, 0.21650634706020355, 0.0, 0.433012694120...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.043972</td>
      <td>[0.0, 0.21650634706020355, 0.0, 0.433012694120...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.183029</td>
      <td>[0.21650634706020355, 0.21650634706020355, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>[0.0, 0.21650634706020355, 0.0, 0.433012694120...</td>
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
    Iteration   50, KL divergence -0.6716, 50 iterations in 0.0412 sec
    Iteration  100, KL divergence 1.0898, 50 iterations in 0.0132 sec
    Iteration  150, KL divergence 1.0898, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 1.0898, 50 iterations in 0.0125 sec
    Iteration  250, KL divergence 1.0898, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.2639, 50 iterations in 0.0384 sec
    Iteration  100, KL divergence 0.2371, 50 iterations in 0.0495 sec
    Iteration  150, KL divergence 0.2299, 50 iterations in 0.0356 sec
    Iteration  200, KL divergence 0.2296, 50 iterations in 0.0360 sec
    Iteration  250, KL divergence 0.2295, 50 iterations in 0.0364 sec
    Iteration  300, KL divergence 0.2296, 50 iterations in 0.0366 sec
    Iteration  350, KL divergence 0.2294, 50 iterations in 0.0358 sec
    Iteration  400, KL divergence 0.2295, 50 iterations in 0.0361 sec
    Iteration  450, KL divergence 0.2295, 50 iterations in 0.0363 sec
    Iteration  500, KL divergence 0.2293, 50 iterations in 0.0364 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-5.065451</td>
      <td>-0.409419</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.109853</td>
      <td>-5.796058</td>
      <td>1.498367</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.043972</td>
      <td>-5.795772</td>
      <td>1.497461</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.183029</td>
      <td>-5.538697</td>
      <td>1.892100</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>-5.794216</td>
      <td>1.491794</td>
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.007343717385083437, 0.003469955874606967, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing</td>
      <td>eventsourcing</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.109853</td>
      <td>[-0.5156768560409546, 1.2198609113693237, -0.2...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.043972</td>
      <td>[-0.4873678982257843, 1.1189712285995483, -0.2...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.183029</td>
      <td>[-0.700867772102356, 0.9722988605499268, -0.26...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>[-0.44419217109680176, 0.7563993334770203, -0....</td>
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
    Iteration   50, KL divergence -1.2597, 50 iterations in 0.0313 sec
    Iteration  100, KL divergence 0.1466, 50 iterations in 0.0225 sec
    Iteration  150, KL divergence 0.0422, 50 iterations in 0.0250 sec
    Iteration  200, KL divergence 0.2249, 50 iterations in 0.0249 sec
    Iteration  250, KL divergence 0.2936, 50 iterations in 0.0239 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1635, 50 iterations in 0.0496 sec
    Iteration  100, KL divergence 0.1495, 50 iterations in 0.0372 sec
    Iteration  150, KL divergence 0.1474, 50 iterations in 0.0351 sec
    Iteration  200, KL divergence 0.1472, 50 iterations in 0.0349 sec
    Iteration  250, KL divergence 0.1472, 50 iterations in 0.0360 sec
    Iteration  300, KL divergence 0.1470, 50 iterations in 0.0360 sec
    Iteration  350, KL divergence 0.1473, 50 iterations in 0.0359 sec
    Iteration  400, KL divergence 0.1471, 50 iterations in 0.0375 sec
    Iteration  450, KL divergence 0.1472, 50 iterations in 0.0359 sec
    Iteration  500, KL divergence 0.1473, 50 iterations in 0.0362 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>1.100617</td>
      <td>4.560502</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.109853</td>
      <td>6.408902</td>
      <td>0.514644</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.043972</td>
      <td>6.136811</td>
      <td>0.524398</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.183029</td>
      <td>6.421001</td>
      <td>0.816899</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.10.0</td>
      <td>1</td>
      <td>0.016509</td>
      <td>5.667165</td>
      <td>0.495340</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

