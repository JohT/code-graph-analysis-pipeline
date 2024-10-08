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
      <td>org.axonframework.eventsourcing</td>
      <td>eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>[-0.17504505813121796, 0.12676210701465607, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[-0.14112624526023865, 0.06958717107772827, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[-0.10237214714288712, 0.05154474824666977, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-0.2316024899482727, -0.08357937633991241, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[-0.07437186688184738, 0.07961605489253998, -0...</td>
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
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.5423, 50 iterations in 0.0595 sec
    Iteration  100, KL divergence 1.2307, 50 iterations in 0.0180 sec
    Iteration  150, KL divergence 1.2307, 50 iterations in 0.0149 sec
    Iteration  200, KL divergence 1.2307, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.2307, 50 iterations in 0.0149 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1945, 50 iterations in 0.0485 sec
    Iteration  100, KL divergence 0.1798, 50 iterations in 0.0444 sec
    Iteration  150, KL divergence 0.1757, 50 iterations in 0.0507 sec
    Iteration  200, KL divergence 0.1757, 50 iterations in 0.0414 sec
    Iteration  250, KL divergence 0.1758, 50 iterations in 0.0418 sec
    Iteration  300, KL divergence 0.1761, 50 iterations in 0.0441 sec
    Iteration  350, KL divergence 0.1761, 50 iterations in 0.0436 sec
    Iteration  400, KL divergence 0.1759, 50 iterations in 0.0427 sec
    Iteration  450, KL divergence 0.1765, 50 iterations in 0.0423 sec
    Iteration  500, KL divergence 0.1765, 50 iterations in 0.0427 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>-2.508163</td>
      <td>-1.229883</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-2.104820</td>
      <td>0.080070</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-2.453720</td>
      <td>-3.549774</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-2.642748</td>
      <td>-4.443400</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>-1.542977</td>
      <td>-4.843167</td>
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
      <td>org.axonframework.eventsourcing</td>
      <td>eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>[-0.8660253882408142, -0.21650634706020355, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[-0.21650634706020355, 0.8660253882408142, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[-0.6495190411806107, 0.0, 0.4330126941204071,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-1.7320507764816284, -0.21650634706020355, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.21650634706020355, 1.5155444294214249, 0.64...</td>
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
    Iteration   50, KL divergence -0.5060, 50 iterations in 0.0665 sec
    Iteration  100, KL divergence 1.2089, 50 iterations in 0.0171 sec
    Iteration  150, KL divergence 1.2089, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.2089, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2089, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5947, 50 iterations in 0.0534 sec
    Iteration  100, KL divergence 0.5775, 50 iterations in 0.0525 sec
    Iteration  150, KL divergence 0.5741, 50 iterations in 0.0499 sec
    Iteration  200, KL divergence 0.5741, 50 iterations in 0.0498 sec
    Iteration  250, KL divergence 0.5739, 50 iterations in 0.0486 sec
    Iteration  300, KL divergence 0.5739, 50 iterations in 0.0483 sec
    Iteration  350, KL divergence 0.5741, 50 iterations in 0.0488 sec
    Iteration  400, KL divergence 0.5742, 50 iterations in 0.0489 sec
    Iteration  450, KL divergence 0.5745, 50 iterations in 0.0483 sec
    Iteration  500, KL divergence 0.5734, 50 iterations in 0.0485 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>-0.325051</td>
      <td>-2.254853</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-1.809744</td>
      <td>-1.302889</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-3.880237</td>
      <td>-0.058177</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-4.315744</td>
      <td>-2.663219</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>1.502782</td>
      <td>4.363099</td>
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
      <td>org.axonframework.eventsourcing</td>
      <td>eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>[0.3923887014389038, -0.013336903415620327, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.44643357396125793, 0.11965005099773407, 0.1...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.2908444106578827, 0.3162674009799957, 0.226...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-0.1238182932138443, 0.3499346077442169, 0.29...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.2755412757396698, 0.32220152020454407, 0.39...</td>
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
    Iteration   50, KL divergence -0.8703, 50 iterations in 0.0646 sec
    Iteration  100, KL divergence 1.1602, 50 iterations in 0.0176 sec
    Iteration  150, KL divergence 1.1602, 50 iterations in 0.0150 sec
    Iteration  200, KL divergence 1.1602, 50 iterations in 0.0149 sec
    Iteration  250, KL divergence 1.1602, 50 iterations in 0.0149 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3784, 50 iterations in 0.0545 sec
    Iteration  100, KL divergence 0.3607, 50 iterations in 0.0477 sec
    Iteration  150, KL divergence 0.3571, 50 iterations in 0.0474 sec
    Iteration  200, KL divergence 0.3431, 50 iterations in 0.0481 sec
    Iteration  250, KL divergence 0.3435, 50 iterations in 0.0574 sec
    Iteration  300, KL divergence 0.3435, 50 iterations in 0.0472 sec
    Iteration  350, KL divergence 0.3435, 50 iterations in 0.0482 sec
    Iteration  400, KL divergence 0.3434, 50 iterations in 0.0477 sec
    Iteration  450, KL divergence 0.3434, 50 iterations in 0.0474 sec
    Iteration  500, KL divergence 0.3434, 50 iterations in 0.0471 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>-2.380345</td>
      <td>2.201174</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-2.854310</td>
      <td>1.401659</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-3.024905</td>
      <td>4.951155</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-3.915037</td>
      <td>5.597044</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>6.309336</td>
      <td>4.607753</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

