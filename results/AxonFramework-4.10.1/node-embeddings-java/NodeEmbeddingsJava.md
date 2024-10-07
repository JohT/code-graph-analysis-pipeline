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
      <td>[0.1685531884431839, 0.09634149074554443, 0.21...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.1837533861398697, 0.11030310392379761, 0.23...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.15669268369674683, 0.05830341577529907, 0.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[0.08836400508880615, 0.031252048909664154, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.11144561320543289, 0.04129263386130333, 0.3...</td>
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
    Iteration   50, KL divergence -0.7323, 50 iterations in 0.0592 sec
    Iteration  100, KL divergence 1.2042, 50 iterations in 0.0162 sec
    Iteration  150, KL divergence 1.2042, 50 iterations in 0.0149 sec
    Iteration  200, KL divergence 1.2042, 50 iterations in 0.0149 sec
    Iteration  250, KL divergence 1.2042, 50 iterations in 0.0149 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1951, 50 iterations in 0.0531 sec
    Iteration  100, KL divergence 0.1733, 50 iterations in 0.0449 sec
    Iteration  150, KL divergence 0.1669, 50 iterations in 0.0429 sec
    Iteration  200, KL divergence 0.1670, 50 iterations in 0.0431 sec
    Iteration  250, KL divergence 0.1670, 50 iterations in 0.0425 sec
    Iteration  300, KL divergence 0.1668, 50 iterations in 0.0427 sec
    Iteration  350, KL divergence 0.1667, 50 iterations in 0.0427 sec
    Iteration  400, KL divergence 0.1668, 50 iterations in 0.0426 sec
    Iteration  450, KL divergence 0.1666, 50 iterations in 0.0424 sec
    Iteration  500, KL divergence 0.1667, 50 iterations in 0.0422 sec
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
      <td>-2.471867</td>
      <td>1.602566</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-3.172363</td>
      <td>0.118576</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>1.255252</td>
      <td>3.968469</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>1.991096</td>
      <td>4.973443</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>1.708174</td>
      <td>4.559070</td>
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
      <td>[-0.8660253882408142, -1.2990380823612213, -1....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[-1.5155444294214249, -0.6495190411806107, -1....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.8660253882408142, -0.6495190411806107, -0.8...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[0.8660253882408142, -0.4330126941204071, -0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.21650634706020355, -0.4330126941204071, 0.6...</td>
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
    Iteration   50, KL divergence -0.3537, 50 iterations in 0.0637 sec
    Iteration  100, KL divergence 1.2401, 50 iterations in 0.0168 sec
    Iteration  150, KL divergence 1.2401, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.2401, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.2401, 50 iterations in 0.0146 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5516, 50 iterations in 0.0499 sec
    Iteration  100, KL divergence 0.5301, 50 iterations in 0.0472 sec
    Iteration  150, KL divergence 0.5279, 50 iterations in 0.0467 sec
    Iteration  200, KL divergence 0.5210, 50 iterations in 0.0661 sec
    Iteration  250, KL divergence 0.5212, 50 iterations in 0.0476 sec
    Iteration  300, KL divergence 0.5214, 50 iterations in 0.0464 sec
    Iteration  350, KL divergence 0.5215, 50 iterations in 0.0464 sec
    Iteration  400, KL divergence 0.5215, 50 iterations in 0.0459 sec
    Iteration  450, KL divergence 0.5215, 50 iterations in 0.0458 sec
    Iteration  500, KL divergence 0.5214, 50 iterations in 0.0461 sec
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
      <td>-3.534220</td>
      <td>1.142724</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-0.964336</td>
      <td>-0.155948</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-5.558260</td>
      <td>4.870234</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>7.133767</td>
      <td>2.231660</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>5.760871</td>
      <td>4.764533</td>
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
      <td>[0.2018052488565445, 0.19426172971725464, -0.1...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.27717798948287964, 0.247170090675354, -0.28...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[-0.3286151587963104, 0.1160610169172287, -0.4...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-0.18284869194030762, -0.26960113644599915, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[-0.4194028973579407, 0.24329619109630585, -0....</td>
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
    Iteration   50, KL divergence -0.5404, 50 iterations in 0.0663 sec
    Iteration  100, KL divergence 1.1639, 50 iterations in 0.0177 sec
    Iteration  150, KL divergence 1.1639, 50 iterations in 0.0150 sec
    Iteration  200, KL divergence 1.1639, 50 iterations in 0.0150 sec
    Iteration  250, KL divergence 1.1639, 50 iterations in 0.0150 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3572, 50 iterations in 0.0540 sec
    Iteration  100, KL divergence 0.3351, 50 iterations in 0.0466 sec
    Iteration  150, KL divergence 0.3338, 50 iterations in 0.0459 sec
    Iteration  200, KL divergence 0.3291, 50 iterations in 0.0462 sec
    Iteration  250, KL divergence 0.2968, 50 iterations in 0.0471 sec
    Iteration  300, KL divergence 0.2936, 50 iterations in 0.0500 sec
    Iteration  350, KL divergence 0.2939, 50 iterations in 0.0563 sec
    Iteration  400, KL divergence 0.2938, 50 iterations in 0.0481 sec
    Iteration  450, KL divergence 0.2930, 50 iterations in 0.0467 sec
    Iteration  500, KL divergence 0.2932, 50 iterations in 0.0460 sec
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
      <td>-2.211463</td>
      <td>0.818042</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-2.008122</td>
      <td>1.219590</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-2.475760</td>
      <td>-2.434186</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-3.425256</td>
      <td>-3.463170</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>0.853849</td>
      <td>-7.316015</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

