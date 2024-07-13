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
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.109854</td>
      <td>[0.26645565032958984, 0.07370127737522125, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>[0.2220543473958969, 0.2426307052373886, -0.20...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>[0.2750019431114197, 0.053093090653419495, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.3109222650527954, -0.02053418755531311, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>[0.2896043062210083, -0.09199318289756775, -0....</td>
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
       --> Time elapsed: 0.06 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.01 seconds
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -0.0572, 50 iterations in 0.0672 sec
    Iteration  100, KL divergence 1.0104, 50 iterations in 0.0287 sec
    Iteration  150, KL divergence 1.0104, 50 iterations in 0.0213 sec
    Iteration  200, KL divergence 1.0104, 50 iterations in 0.0246 sec
    Iteration  250, KL divergence 1.0104, 50 iterations in 0.0126 sec
       --> Time elapsed: 0.15 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1119, 50 iterations in 0.0308 sec
    Iteration  100, KL divergence 0.0703, 50 iterations in 0.0345 sec
    Iteration  150, KL divergence 0.0677, 50 iterations in 0.0336 sec
    Iteration  200, KL divergence 0.0648, 50 iterations in 0.0339 sec
    Iteration  250, KL divergence 0.0624, 50 iterations in 0.0325 sec
    Iteration  300, KL divergence 0.0624, 50 iterations in 0.0342 sec
    Iteration  350, KL divergence 0.0604, 50 iterations in 0.0341 sec
    Iteration  400, KL divergence 0.0616, 50 iterations in 0.0343 sec
    Iteration  450, KL divergence 0.0605, 50 iterations in 0.0348 sec
    Iteration  500, KL divergence 0.0592, 50 iterations in 0.0338 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.109854</td>
      <td>0.280239</td>
      <td>6.360146</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>0.593727</td>
      <td>6.447300</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>0.101947</td>
      <td>6.364716</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-0.045044</td>
      <td>6.603030</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>-0.560282</td>
      <td>6.460873</td>
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
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.109854</td>
      <td>[-1.0825317353010178, -0.6495190411806107, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>[-1.0825317353010178, -0.6495190411806107, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>[-0.8660253882408142, -0.8660253882408142, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-1.0825317353010178, -0.6495190411806107, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>[-0.6495190411806107, -0.6495190411806107, -0....</td>
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
    Iteration   50, KL divergence -0.8503, 50 iterations in 0.0411 sec
    Iteration  100, KL divergence 1.0440, 50 iterations in 0.0133 sec
    Iteration  150, KL divergence 1.0440, 50 iterations in 0.0124 sec
    Iteration  200, KL divergence 1.0440, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0440, 50 iterations in 0.0123 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.3245, 50 iterations in 0.0618 sec
    Iteration  100, KL divergence 0.2906, 50 iterations in 0.0435 sec
    Iteration  150, KL divergence 0.2818, 50 iterations in 0.0348 sec
    Iteration  200, KL divergence 0.3233, 50 iterations in 0.0358 sec
    Iteration  250, KL divergence 0.4068, 50 iterations in 0.0362 sec
    Iteration  300, KL divergence 0.3833, 50 iterations in 0.0352 sec
    Iteration  350, KL divergence 0.3710, 50 iterations in 0.0340 sec
    Iteration  400, KL divergence 0.3374, 50 iterations in 0.0356 sec
    Iteration  450, KL divergence 0.3034, 50 iterations in 0.0383 sec
    Iteration  500, KL divergence 0.2964, 50 iterations in 0.0363 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.109854</td>
      <td>5.596281</td>
      <td>4.536882</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>5.594991</td>
      <td>4.520649</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>5.986594</td>
      <td>4.746047</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>5.726148</td>
      <td>4.272231</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>6.214502</td>
      <td>4.028169</td>
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
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.109854</td>
      <td>[-0.06436332315206528, -0.4427911639213562, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>[-0.10400954633951187, -0.34757938981056213, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>[-0.017670072615146637, -0.4968084394931793, 0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.16399043798446655, -0.29188045859336853, 0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>[-0.11632795631885529, -0.41345086693763733, 0...</td>
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
    Iteration   50, KL divergence 0.1870, 50 iterations in 0.0332 sec
    Iteration  100, KL divergence -1.7686, 50 iterations in 0.0228 sec
    Iteration  150, KL divergence 0.9758, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 0.9758, 50 iterations in 0.0123 sec
    Iteration  250, KL divergence 0.9758, 50 iterations in 0.0125 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1322, 50 iterations in 0.0395 sec
    Iteration  100, KL divergence 0.1029, 50 iterations in 0.0506 sec
    Iteration  150, KL divergence 0.1012, 50 iterations in 0.0356 sec
    Iteration  200, KL divergence 0.1015, 50 iterations in 0.0354 sec
    Iteration  250, KL divergence 0.1017, 50 iterations in 0.0350 sec
    Iteration  300, KL divergence 0.1016, 50 iterations in 0.0352 sec
    Iteration  350, KL divergence 0.1015, 50 iterations in 0.0349 sec
    Iteration  400, KL divergence 0.1013, 50 iterations in 0.0348 sec
    Iteration  450, KL divergence 0.1014, 50 iterations in 0.0361 sec
    Iteration  500, KL divergence 0.1016, 50 iterations in 0.0360 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.109854</td>
      <td>-6.462864</td>
      <td>-2.483946</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>-6.353423</td>
      <td>-2.109908</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>-6.511416</td>
      <td>-2.519952</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-5.773790</td>
      <td>-1.952948</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>-5.981670</td>
      <td>-2.644858</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

