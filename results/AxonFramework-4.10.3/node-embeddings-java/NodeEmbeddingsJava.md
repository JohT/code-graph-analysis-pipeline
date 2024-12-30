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
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>[0.06938987970352173, 0.2114604115486145, 0.02...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[0.025113776326179504, 0.13587705790996552, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>[-0.0034596931654959917, 0.2303972840309143, 0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>[-0.15128359198570251, 0.03668508678674698, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>[0.09955477714538574, 0.2348729968070984, 0.30...</td>
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
    Iteration   50, KL divergence -1.0356, 50 iterations in 0.0572 sec
    Iteration  100, KL divergence 1.2171, 50 iterations in 0.0158 sec
    Iteration  150, KL divergence 1.2171, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.2171, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2171, 50 iterations in 0.0149 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1930, 50 iterations in 0.0506 sec
    Iteration  100, KL divergence 0.1748, 50 iterations in 0.0490 sec
    Iteration  150, KL divergence 0.1696, 50 iterations in 0.0438 sec
    Iteration  200, KL divergence 0.1688, 50 iterations in 0.0429 sec
    Iteration  250, KL divergence 0.1685, 50 iterations in 0.0431 sec
    Iteration  300, KL divergence 0.1686, 50 iterations in 0.0439 sec
    Iteration  350, KL divergence 0.1686, 50 iterations in 0.0442 sec
    Iteration  400, KL divergence 0.1690, 50 iterations in 0.0438 sec
    Iteration  450, KL divergence 0.1687, 50 iterations in 0.0436 sec
    Iteration  500, KL divergence 0.1684, 50 iterations in 0.0436 sec
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
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>-3.967972</td>
      <td>-1.000564</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-4.527263</td>
      <td>-2.016536</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>-3.743593</td>
      <td>-1.947129</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>-4.298050</td>
      <td>-2.396275</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>-4.484737</td>
      <td>-1.033450</td>
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
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>[-0.6495190411806107, -0.8660253882408142, -1....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[0.4330126941204071, 0.21650634706020355, -0.6...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>[0.21650634706020355, -0.21650634706020355, -1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>[0.21650634706020355, -0.21650634706020355, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>[-0.4330126941204071, 0.6495190411806107, -1.2...</td>
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
       --> Time elapsed: 0.01 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.01 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.8089, 50 iterations in 0.0741 sec
    Iteration  100, KL divergence 1.2122, 50 iterations in 0.0173 sec
    Iteration  150, KL divergence 1.2122, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.2122, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.2122, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.14 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6075, 50 iterations in 0.0472 sec
    Iteration  100, KL divergence 0.5854, 50 iterations in 0.0467 sec
    Iteration  150, KL divergence 0.5766, 50 iterations in 0.0483 sec
    Iteration  200, KL divergence 0.5759, 50 iterations in 0.0464 sec
    Iteration  250, KL divergence 0.5761, 50 iterations in 0.0467 sec
    Iteration  300, KL divergence 0.5760, 50 iterations in 0.0473 sec
    Iteration  350, KL divergence 0.5755, 50 iterations in 0.0476 sec
    Iteration  400, KL divergence 0.5755, 50 iterations in 0.0473 sec
    Iteration  450, KL divergence 0.5756, 50 iterations in 0.0472 sec
    Iteration  500, KL divergence 0.5755, 50 iterations in 0.0472 sec
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
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>-1.655852</td>
      <td>6.386998</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-6.685441</td>
      <td>-0.875815</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>-5.662075</td>
      <td>-1.689153</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>-6.026430</td>
      <td>-0.694282</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>-2.441738</td>
      <td>3.924593</td>
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
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>[0.8723815083503723, 0.2112804800271988, 0.024...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[0.8434499502182007, 0.16630597412586212, 0.09...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>[0.9046720266342163, 0.31170305609703064, -0.0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>[0.9393641948699951, 0.3134734332561493, 0.010...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>[1.007604956626892, -0.060863468796014786, 0.0...</td>
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
    Iteration   50, KL divergence -0.5102, 50 iterations in 0.0672 sec
    Iteration  100, KL divergence -2.8895, 50 iterations in 0.0208 sec
    Iteration  150, KL divergence 1.1580, 50 iterations in 0.0156 sec
    Iteration  200, KL divergence 1.1580, 50 iterations in 0.0149 sec
    Iteration  250, KL divergence 1.1580, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3813, 50 iterations in 0.0565 sec
    Iteration  100, KL divergence 0.3488, 50 iterations in 0.0485 sec
    Iteration  150, KL divergence 0.3447, 50 iterations in 0.0458 sec
    Iteration  200, KL divergence 0.3449, 50 iterations in 0.0465 sec
    Iteration  250, KL divergence 0.3452, 50 iterations in 0.0457 sec
    Iteration  300, KL divergence 0.3451, 50 iterations in 0.0458 sec
    Iteration  350, KL divergence 0.3450, 50 iterations in 0.0469 sec
    Iteration  400, KL divergence 0.3448, 50 iterations in 0.0465 sec
    Iteration  450, KL divergence 0.3451, 50 iterations in 0.0459 sec
    Iteration  500, KL divergence 0.3452, 50 iterations in 0.0465 sec
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
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>4.955623</td>
      <td>-3.509587</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>5.656386</td>
      <td>-3.876297</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>3.176350</td>
      <td>-4.480323</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>3.253020</td>
      <td>-4.513075</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>5.961347</td>
      <td>-3.493649</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

