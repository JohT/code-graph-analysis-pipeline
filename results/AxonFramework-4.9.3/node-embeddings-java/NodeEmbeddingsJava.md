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
       --> Time elapsed: 0.03 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence 0.6836, 50 iterations in 0.0347 sec
    Iteration  100, KL divergence 0.9968, 50 iterations in 0.0129 sec
    Iteration  150, KL divergence 0.9968, 50 iterations in 0.0124 sec
    Iteration  200, KL divergence 0.9968, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 0.9968, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1172, 50 iterations in 0.0390 sec
    Iteration  100, KL divergence 0.0799, 50 iterations in 0.0538 sec
    Iteration  150, KL divergence 0.0750, 50 iterations in 0.0354 sec
    Iteration  200, KL divergence 0.0743, 50 iterations in 0.0348 sec
    Iteration  250, KL divergence 0.0767, 50 iterations in 0.0366 sec
    Iteration  300, KL divergence 0.0766, 50 iterations in 0.0338 sec
    Iteration  350, KL divergence 0.0767, 50 iterations in 0.0335 sec
    Iteration  400, KL divergence 0.0779, 50 iterations in 0.0339 sec
    Iteration  450, KL divergence 0.0779, 50 iterations in 0.0333 sec
    Iteration  500, KL divergence 0.0779, 50 iterations in 0.0331 sec
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
      <td>6.400994</td>
      <td>1.516995</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>6.557078</td>
      <td>1.735574</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>6.474945</td>
      <td>1.265365</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>6.399911</td>
      <td>1.244923</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>6.225588</td>
      <td>0.834352</td>
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
      <td>[-0.8660253882408142, -0.6495190411806107, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>[-0.8660253882408142, -0.6495190411806107, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>[-0.6495190411806107, -0.6495190411806107, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.8660253882408142, -0.8660253882408142, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>[-0.6495190411806107, -0.4330126941204071, -0....</td>
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
    Iteration   50, KL divergence -0.9777, 50 iterations in 0.0382 sec
    Iteration  100, KL divergence 1.0718, 50 iterations in 0.0130 sec
    Iteration  150, KL divergence 1.0718, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 1.0718, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0718, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.2467, 50 iterations in 0.0380 sec
    Iteration  100, KL divergence 0.2187, 50 iterations in 0.0496 sec
    Iteration  150, KL divergence 0.2111, 50 iterations in 0.0357 sec
    Iteration  200, KL divergence 0.2101, 50 iterations in 0.0357 sec
    Iteration  250, KL divergence 0.2096, 50 iterations in 0.0352 sec
    Iteration  300, KL divergence 0.2122, 50 iterations in 0.0354 sec
    Iteration  350, KL divergence 0.2155, 50 iterations in 0.0343 sec
    Iteration  400, KL divergence 0.2141, 50 iterations in 0.0333 sec
    Iteration  450, KL divergence 0.2143, 50 iterations in 0.0343 sec
    Iteration  500, KL divergence 0.2146, 50 iterations in 0.0349 sec
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
      <td>6.120125</td>
      <td>3.782798</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>6.112906</td>
      <td>3.776796</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>6.039537</td>
      <td>4.313734</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>6.200224</td>
      <td>4.127772</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>5.808705</td>
      <td>4.280659</td>
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
      <td>[0.9174003601074219, -0.8986847400665283, 0.86...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>[0.8730266690254211, -0.8425220847129822, 0.79...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>[0.7689021229743958, -0.9835399389266968, 0.77...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.5376073122024536, -0.6038811802864075, 0.58...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>[0.7914322018623352, -0.906976044178009, 0.786...</td>
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
    Iteration   50, KL divergence 0.6081, 50 iterations in 0.0309 sec
    Iteration  100, KL divergence 0.9820, 50 iterations in 0.0139 sec
    Iteration  150, KL divergence 0.9820, 50 iterations in 0.0128 sec
    Iteration  200, KL divergence 0.9820, 50 iterations in 0.0127 sec
    Iteration  250, KL divergence 0.9820, 50 iterations in 0.0131 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1480, 50 iterations in 0.0711 sec
    Iteration  100, KL divergence 0.1188, 50 iterations in 0.0535 sec
    Iteration  150, KL divergence 0.1131, 50 iterations in 0.0348 sec
    Iteration  200, KL divergence 0.1090, 50 iterations in 0.0352 sec
    Iteration  250, KL divergence 0.1094, 50 iterations in 0.0347 sec
    Iteration  300, KL divergence 0.1096, 50 iterations in 0.0357 sec
    Iteration  350, KL divergence 0.1095, 50 iterations in 0.0357 sec
    Iteration  400, KL divergence 0.1096, 50 iterations in 0.0365 sec
    Iteration  450, KL divergence 0.1096, 50 iterations in 0.0363 sec
    Iteration  500, KL divergence 0.1096, 50 iterations in 0.0360 sec
       --> Time elapsed: 0.41 seconds



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
      <td>-5.781331</td>
      <td>3.404861</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.043972</td>
      <td>-6.011055</td>
      <td>3.126353</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.183029</td>
      <td>-5.891990</td>
      <td>3.160951</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-6.601781</td>
      <td>2.975398</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041023</td>
      <td>-6.075767</td>
      <td>3.656416</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

