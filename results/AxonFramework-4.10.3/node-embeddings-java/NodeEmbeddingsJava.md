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
      <td>axon-configuration-4.10.3</td>
      <td>0</td>
      <td>0.047302</td>
      <td>[0.2620307505130768, -0.16623878479003906, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>[-0.09079179167747498, -0.006333380937576294, ...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.28706541657447815, 0.0232041347771883, -0.4...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>[-0.49391722679138184, 0.13322685658931732, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>statements</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>[-0.5326073169708252, 0.21447494626045227, -0....</td>
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
    Iteration   50, KL divergence -1.7423, 50 iterations in 0.0553 sec
    Iteration  100, KL divergence 1.2066, 50 iterations in 0.0156 sec
    Iteration  150, KL divergence 1.2066, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2066, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2066, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.11 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1902, 50 iterations in 0.0512 sec
    Iteration  100, KL divergence 0.1713, 50 iterations in 0.0485 sec
    Iteration  150, KL divergence 0.1638, 50 iterations in 0.0451 sec
    Iteration  200, KL divergence 0.1624, 50 iterations in 0.0441 sec
    Iteration  250, KL divergence 0.1626, 50 iterations in 0.0439 sec
    Iteration  300, KL divergence 0.1629, 50 iterations in 0.0454 sec
    Iteration  350, KL divergence 0.1629, 50 iterations in 0.0464 sec
    Iteration  400, KL divergence 0.1633, 50 iterations in 0.0467 sec
    Iteration  450, KL divergence 0.1631, 50 iterations in 0.0452 sec
    Iteration  500, KL divergence 0.1629, 50 iterations in 0.0444 sec
       --> Time elapsed: 0.46 seconds



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
      <td>org.axonframework.config</td>
      <td>axon-configuration-4.10.3</td>
      <td>0</td>
      <td>0.047302</td>
      <td>0.695418</td>
      <td>-0.866715</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>1.817866</td>
      <td>-3.779398</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-0.300429</td>
      <td>-4.027914</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>-4.176720</td>
      <td>-4.519949</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>-4.167485</td>
      <td>-4.504787</td>
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
      <td>axon-configuration-4.10.3</td>
      <td>0</td>
      <td>0.047302</td>
      <td>[0.4330126941204071, -2.1650634706020355, -0.6...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>[0.0, -1.948557123541832, -1.0825317353010178,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.21650634706020355, -1.2990380823612213, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>[-0.21650634706020355, -1.2990380823612213, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>statements</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>[-0.4330126941204071, -1.2990380823612213, -0....</td>
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
    Iteration   50, KL divergence -0.2694, 50 iterations in 0.0654 sec
    Iteration  100, KL divergence 1.2165, 50 iterations in 0.0168 sec
    Iteration  150, KL divergence 1.2165, 50 iterations in 0.0142 sec
    Iteration  200, KL divergence 1.2165, 50 iterations in 0.0142 sec
    Iteration  250, KL divergence 1.2165, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6516, 50 iterations in 0.0516 sec
    Iteration  100, KL divergence 0.6224, 50 iterations in 0.0496 sec
    Iteration  150, KL divergence 0.6109, 50 iterations in 0.0465 sec
    Iteration  200, KL divergence 0.6109, 50 iterations in 0.0455 sec
    Iteration  250, KL divergence 0.6113, 50 iterations in 0.0454 sec
    Iteration  300, KL divergence 0.6115, 50 iterations in 0.0461 sec
    Iteration  350, KL divergence 0.6115, 50 iterations in 0.0470 sec
    Iteration  400, KL divergence 0.6115, 50 iterations in 0.0465 sec
    Iteration  450, KL divergence 0.6115, 50 iterations in 0.0527 sec
    Iteration  500, KL divergence 0.6115, 50 iterations in 0.0470 sec
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
      <td>org.axonframework.config</td>
      <td>axon-configuration-4.10.3</td>
      <td>0</td>
      <td>0.047302</td>
      <td>3.763831</td>
      <td>-6.318581</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>0.742759</td>
      <td>-4.933720</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-2.386420</td>
      <td>5.726051</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>-1.278167</td>
      <td>-4.108791</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>-6.817947</td>
      <td>1.249824</td>
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
      <td>axon-configuration-4.10.3</td>
      <td>0</td>
      <td>0.047302</td>
      <td>[0.06730452179908752, -0.33492279052734375, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>[0.14006678760051727, -0.03767256811261177, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.0299423485994339, -0.06651098281145096, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>[0.6322472095489502, 0.12474610656499863, 0.18...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>statements</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>[0.7179538607597351, 0.2249232977628708, 0.241...</td>
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
    Iteration   50, KL divergence -0.2703, 50 iterations in 0.0637 sec
    Iteration  100, KL divergence 1.1571, 50 iterations in 0.0177 sec
    Iteration  150, KL divergence 1.1571, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.1571, 50 iterations in 0.0150 sec
    Iteration  250, KL divergence 1.1571, 50 iterations in 0.0146 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3317, 50 iterations in 0.0534 sec
    Iteration  100, KL divergence 0.3082, 50 iterations in 0.0482 sec
    Iteration  150, KL divergence 0.3005, 50 iterations in 0.0458 sec
    Iteration  200, KL divergence 0.2994, 50 iterations in 0.0463 sec
    Iteration  250, KL divergence 0.2988, 50 iterations in 0.0463 sec
    Iteration  300, KL divergence 0.2988, 50 iterations in 0.0468 sec
    Iteration  350, KL divergence 0.2988, 50 iterations in 0.0475 sec
    Iteration  400, KL divergence 0.2985, 50 iterations in 0.0469 sec
    Iteration  450, KL divergence 0.2984, 50 iterations in 0.0464 sec
    Iteration  500, KL divergence 0.2986, 50 iterations in 0.0466 sec
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
      <td>org.axonframework.config</td>
      <td>axon-configuration-4.10.3</td>
      <td>0</td>
      <td>0.047302</td>
      <td>-0.219140</td>
      <td>-0.386250</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>3.171413</td>
      <td>-1.556873</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>1.425012</td>
      <td>-1.941952</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>3.147093</td>
      <td>8.328047</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>3.148180</td>
      <td>8.344025</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

