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
      <td>[0.05093193054199219, -0.3450390100479126, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>[-0.2022514045238495, -0.11786514520645142, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.11336085945367813, -0.14701107144355774, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>[-0.5276236534118652, 0.09687726944684982, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>statements</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>[-0.5550099611282349, 0.19112810492515564, -0....</td>
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
    Iteration   50, KL divergence -0.2840, 50 iterations in 0.0558 sec
    Iteration  100, KL divergence 1.2013, 50 iterations in 0.0161 sec
    Iteration  150, KL divergence 1.2013, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2013, 50 iterations in 0.0144 sec
    Iteration  250, KL divergence 1.2013, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1845, 50 iterations in 0.0525 sec
    Iteration  100, KL divergence 0.1710, 50 iterations in 0.0472 sec
    Iteration  150, KL divergence 0.1681, 50 iterations in 0.0439 sec
    Iteration  200, KL divergence 0.1681, 50 iterations in 0.0432 sec
    Iteration  250, KL divergence 0.1678, 50 iterations in 0.0429 sec
    Iteration  300, KL divergence 0.1679, 50 iterations in 0.0432 sec
    Iteration  350, KL divergence 0.1679, 50 iterations in 0.0431 sec
    Iteration  400, KL divergence 0.1678, 50 iterations in 0.0426 sec
    Iteration  450, KL divergence 0.1679, 50 iterations in 0.0431 sec
    Iteration  500, KL divergence 0.1680, 50 iterations in 0.0431 sec
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
      <td>org.axonframework.config</td>
      <td>axon-configuration-4.10.3</td>
      <td>0</td>
      <td>0.047302</td>
      <td>0.686673</td>
      <td>-0.115548</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>2.231185</td>
      <td>3.926552</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>1.442831</td>
      <td>2.390903</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>-0.809083</td>
      <td>5.164411</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>-0.811422</td>
      <td>5.152515</td>
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
      <td>[-1.0825317353010178, -2.1650634706020355, -1....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>[0.6495190411806107, -1.7320507764816284, -0.4...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-1.2990380823612213, -0.21650634706020355, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>[-0.4330126941204071, -0.21650634706020355, -1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>statements</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>[-1.0825317353010178, 0.0, -0.8660253882408142...</td>
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
    Iteration   50, KL divergence -0.3439, 50 iterations in 0.0718 sec
    Iteration  100, KL divergence 1.2175, 50 iterations in 0.0175 sec
    Iteration  150, KL divergence 1.2175, 50 iterations in 0.0144 sec
    Iteration  200, KL divergence 1.2175, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2175, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6710, 50 iterations in 0.0512 sec
    Iteration  100, KL divergence 0.6496, 50 iterations in 0.0476 sec
    Iteration  150, KL divergence 0.6388, 50 iterations in 0.0456 sec
    Iteration  200, KL divergence 0.6326, 50 iterations in 0.0454 sec
    Iteration  250, KL divergence 0.6233, 50 iterations in 0.0454 sec
    Iteration  300, KL divergence 0.6175, 50 iterations in 0.0461 sec
    Iteration  350, KL divergence 0.6150, 50 iterations in 0.0467 sec
    Iteration  400, KL divergence 0.6151, 50 iterations in 0.0459 sec
    Iteration  450, KL divergence 0.6153, 50 iterations in 0.0460 sec
    Iteration  500, KL divergence 0.6153, 50 iterations in 0.0467 sec
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
      <td>-3.746449</td>
      <td>5.976571</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>3.681591</td>
      <td>2.696897</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-7.381441</td>
      <td>-0.539348</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>1.072075</td>
      <td>1.066404</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>-2.965090</td>
      <td>-4.916114</td>
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
      <td>[0.45337367057800293, -0.38669702410697937, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>[0.4920412003993988, -0.025023452937602997, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.30597227811813354, -0.1897597759962082, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>[0.8498762845993042, 0.3660902678966522, -0.04...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>statements</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>[1.0375028848648071, 0.5215405225753784, 0.029...</td>
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
    Iteration   50, KL divergence -0.4814, 50 iterations in 0.0624 sec
    Iteration  100, KL divergence 1.1510, 50 iterations in 0.0166 sec
    Iteration  150, KL divergence 1.1510, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.1510, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.1510, 50 iterations in 0.0146 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2825, 50 iterations in 0.0528 sec
    Iteration  100, KL divergence 0.2754, 50 iterations in 0.0492 sec
    Iteration  150, KL divergence 0.2736, 50 iterations in 0.0486 sec
    Iteration  200, KL divergence 0.2737, 50 iterations in 0.0484 sec
    Iteration  250, KL divergence 0.2740, 50 iterations in 0.0490 sec
    Iteration  300, KL divergence 0.2741, 50 iterations in 0.0487 sec
    Iteration  350, KL divergence 0.2739, 50 iterations in 0.0494 sec
    Iteration  400, KL divergence 0.2741, 50 iterations in 0.0490 sec
    Iteration  450, KL divergence 0.2742, 50 iterations in 0.0488 sec
    Iteration  500, KL divergence 0.2742, 50 iterations in 0.0486 sec
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
      <td>org.axonframework.config</td>
      <td>axon-configuration-4.10.3</td>
      <td>0</td>
      <td>0.047302</td>
      <td>1.103807</td>
      <td>1.754215</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.037034</td>
      <td>-3.860936</td>
      <td>1.938097</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-1.044264</td>
      <td>1.878006</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.023525</td>
      <td>-5.931698</td>
      <td>3.026630</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>0</td>
      <td>0.015345</td>
      <td>-5.985063</td>
      <td>3.057606</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

