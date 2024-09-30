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
      <td>0.012594</td>
      <td>[0.4096416234970093, 0.11835406720638275, 0.00...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[0.08293566852807999, 0.3612525761127472, -0.2...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[0.09236978739500046, 0.6710652709007263, -0.0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[0.1076347753405571, 0.3581780791282654, 0.075...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.15407651662826538, 0.43103471398353577, 0....</td>
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
       --> Time elapsed: 0.05 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.7831, 50 iterations in 0.0556 sec
    Iteration  100, KL divergence 1.2462, 50 iterations in 0.0160 sec
    Iteration  150, KL divergence 1.2462, 50 iterations in 0.0149 sec
    Iteration  200, KL divergence 1.2462, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2462, 50 iterations in 0.0146 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1946, 50 iterations in 0.0509 sec
    Iteration  100, KL divergence 0.1783, 50 iterations in 0.0458 sec
    Iteration  150, KL divergence 0.1656, 50 iterations in 0.0439 sec
    Iteration  200, KL divergence 0.1614, 50 iterations in 0.0431 sec
    Iteration  250, KL divergence 0.1615, 50 iterations in 0.0431 sec
    Iteration  300, KL divergence 0.1615, 50 iterations in 0.0438 sec
    Iteration  350, KL divergence 0.1616, 50 iterations in 0.0437 sec
    Iteration  400, KL divergence 0.1615, 50 iterations in 0.0435 sec
    Iteration  450, KL divergence 0.1615, 50 iterations in 0.0434 sec
    Iteration  500, KL divergence 0.1616, 50 iterations in 0.0440 sec
       --> Time elapsed: 0.45 seconds



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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>2.959556</td>
      <td>0.596045</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-1.108732</td>
      <td>3.661711</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-1.257149</td>
      <td>4.669687</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>-1.207483</td>
      <td>4.248732</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-1.513001</td>
      <td>4.934089</td>
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
      <td>0.012594</td>
      <td>[0.21650634706020355, -0.21650634706020355, -1...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[0.21650634706020355, 0.0, -2.381569817662239,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[-1.7320507764816284, 0.4330126941204071, -0.6...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-0.8660253882408142, 1.2990380823612213, -1.5...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.8660253882408142, 1.7320507764816284, -0.8...</td>
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
    Iteration   50, KL divergence -1.0172, 50 iterations in 0.0651 sec
    Iteration  100, KL divergence 1.2312, 50 iterations in 0.0166 sec
    Iteration  150, KL divergence 1.2312, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.2312, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.2312, 50 iterations in 0.0149 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6370, 50 iterations in 0.0518 sec
    Iteration  100, KL divergence 0.6261, 50 iterations in 0.0504 sec
    Iteration  150, KL divergence 0.6244, 50 iterations in 0.0484 sec
    Iteration  200, KL divergence 0.6159, 50 iterations in 0.0466 sec
    Iteration  250, KL divergence 0.6100, 50 iterations in 0.0463 sec
    Iteration  300, KL divergence 0.6079, 50 iterations in 0.0460 sec
    Iteration  350, KL divergence 0.6077, 50 iterations in 0.0472 sec
    Iteration  400, KL divergence 0.6076, 50 iterations in 0.0469 sec
    Iteration  450, KL divergence 0.6078, 50 iterations in 0.0464 sec
    Iteration  500, KL divergence 0.6072, 50 iterations in 0.0464 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>5.773058</td>
      <td>1.469020</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>3.580486</td>
      <td>1.638997</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-5.377119</td>
      <td>0.365812</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>2.943630</td>
      <td>1.364404</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-4.433381</td>
      <td>-0.087532</td>
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
      <td>0.012594</td>
      <td>[-0.1944786012172699, -0.05930459126830101, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[-0.05812596157193184, -0.22006504237651825, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[0.1642570197582245, -0.4014912545681, 0.05540...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-0.11866246163845062, -0.3151770830154419, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.05773572623729706, -0.49442175030708313, 0...</td>
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
    Iteration   50, KL divergence -0.7371, 50 iterations in 0.0665 sec
    Iteration  100, KL divergence 1.1654, 50 iterations in 0.0170 sec
    Iteration  150, KL divergence 1.1654, 50 iterations in 0.0150 sec
    Iteration  200, KL divergence 1.1654, 50 iterations in 0.0149 sec
    Iteration  250, KL divergence 1.1654, 50 iterations in 0.0149 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3131, 50 iterations in 0.0518 sec
    Iteration  100, KL divergence 0.2851, 50 iterations in 0.0485 sec
    Iteration  150, KL divergence 0.2779, 50 iterations in 0.0488 sec
    Iteration  200, KL divergence 0.2758, 50 iterations in 0.0473 sec
    Iteration  250, KL divergence 0.2758, 50 iterations in 0.0469 sec
    Iteration  300, KL divergence 0.2748, 50 iterations in 0.0470 sec
    Iteration  350, KL divergence 0.2752, 50 iterations in 0.0487 sec
    Iteration  400, KL divergence 0.2752, 50 iterations in 0.0483 sec
    Iteration  450, KL divergence 0.2752, 50 iterations in 0.0468 sec
    Iteration  500, KL divergence 0.2749, 50 iterations in 0.0470 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>3.839836</td>
      <td>-0.801927</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>5.368116</td>
      <td>-1.960119</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>6.317045</td>
      <td>-2.196667</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>5.415338</td>
      <td>-2.995969</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>5.595464</td>
      <td>-3.240300</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

