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
      <td>0.107658</td>
      <td>[0.22776228189468384, 0.2050343155860901, 0.04...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>[0.183696910738945, 0.2740611135959625, 0.1361...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>[0.289802610874176, 0.06702718138694763, 0.009...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.219371035695076, 0.10349257290363312, 0.007...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>[0.176451176404953, -0.18880468606948853, 0.00...</td>
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
    Iteration   50, KL divergence -0.2028, 50 iterations in 0.0348 sec
    Iteration  100, KL divergence 0.9984, 50 iterations in 0.0127 sec
    Iteration  150, KL divergence 0.9984, 50 iterations in 0.0124 sec
    Iteration  200, KL divergence 0.9984, 50 iterations in 0.0122 sec
    Iteration  250, KL divergence 0.9984, 50 iterations in 0.0122 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1330, 50 iterations in 0.0367 sec
    Iteration  100, KL divergence 0.0898, 50 iterations in 0.0497 sec
    Iteration  150, KL divergence 0.0698, 50 iterations in 0.0368 sec
    Iteration  200, KL divergence 0.0715, 50 iterations in 0.0343 sec
    Iteration  250, KL divergence 0.0708, 50 iterations in 0.0350 sec
    Iteration  300, KL divergence 0.0710, 50 iterations in 0.0354 sec
    Iteration  350, KL divergence 0.0729, 50 iterations in 0.0355 sec
    Iteration  400, KL divergence 0.0730, 50 iterations in 0.0367 sec
    Iteration  450, KL divergence 0.0731, 50 iterations in 0.0352 sec
    Iteration  500, KL divergence 0.0730, 50 iterations in 0.0347 sec
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
      <td>0.107658</td>
      <td>4.378874</td>
      <td>3.863533</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>4.513428</td>
      <td>4.059245</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>3.949252</td>
      <td>3.689032</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>4.127184</td>
      <td>3.599694</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>3.547613</td>
      <td>3.199222</td>
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
      <td>0.107658</td>
      <td>[-0.21650634706020355, 0.21650634706020355, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>[-0.21650634706020355, 0.21650634706020355, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>[-0.21650634706020355, 0.8660253882408142, 0.0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.6495190411806107, 0.6495190411806107, 0.0,...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>[-0.21650634706020355, 0.8660253882408142, 0.0...</td>
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
    Iteration   50, KL divergence -0.2510, 50 iterations in 0.0465 sec
    Iteration  100, KL divergence 1.0632, 50 iterations in 0.0133 sec
    Iteration  150, KL divergence 1.0632, 50 iterations in 0.0126 sec
    Iteration  200, KL divergence 1.0632, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0632, 50 iterations in 0.0125 sec
       --> Time elapsed: 0.10 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.2715, 50 iterations in 0.0394 sec
    Iteration  100, KL divergence 0.2574, 50 iterations in 0.0481 sec
    Iteration  150, KL divergence 0.2487, 50 iterations in 0.0357 sec
    Iteration  200, KL divergence 0.2401, 50 iterations in 0.0367 sec
    Iteration  250, KL divergence 0.2373, 50 iterations in 0.0364 sec
    Iteration  300, KL divergence 0.2371, 50 iterations in 0.0361 sec
    Iteration  350, KL divergence 0.2350, 50 iterations in 0.0364 sec
    Iteration  400, KL divergence 0.2436, 50 iterations in 0.0352 sec
    Iteration  450, KL divergence 0.2373, 50 iterations in 0.0355 sec
    Iteration  500, KL divergence 0.2388, 50 iterations in 0.0347 sec
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
      <td>0.107658</td>
      <td>4.010558</td>
      <td>8.954351</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>4.010558</td>
      <td>8.954351</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>4.894568</td>
      <td>9.854278</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>3.990220</td>
      <td>9.419382</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>4.497185</td>
      <td>9.843567</td>
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
      <td>0.107658</td>
      <td>[0.43901100754737854, 0.5521003007888794, 0.56...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>[0.4412213861942291, 0.519889771938324, 0.5091...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>[0.21557866036891937, 0.50147944688797, 0.4337...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.23159633576869965, 0.29079243540763855, 0.3...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>[0.028573578223586082, 0.3628169000148773, 0.4...</td>
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
    Iteration   50, KL divergence -0.1420, 50 iterations in 0.0320 sec
    Iteration  100, KL divergence 0.9898, 50 iterations in 0.0132 sec
    Iteration  150, KL divergence 0.9898, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 0.9898, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 0.9898, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1373, 50 iterations in 0.0393 sec
    Iteration  100, KL divergence 0.0997, 50 iterations in 0.0501 sec
    Iteration  150, KL divergence 0.0961, 50 iterations in 0.0397 sec
    Iteration  200, KL divergence 0.0958, 50 iterations in 0.0366 sec
    Iteration  250, KL divergence 0.0963, 50 iterations in 0.0370 sec
    Iteration  300, KL divergence 0.0967, 50 iterations in 0.0362 sec
    Iteration  350, KL divergence 0.0961, 50 iterations in 0.0379 sec
    Iteration  400, KL divergence 0.0959, 50 iterations in 0.0353 sec
    Iteration  450, KL divergence 0.0962, 50 iterations in 0.0364 sec
    Iteration  500, KL divergence 0.0966, 50 iterations in 0.0365 sec
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
      <td>0.107658</td>
      <td>3.450640</td>
      <td>-5.842373</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>3.542317</td>
      <td>-5.587276</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>3.149919</td>
      <td>-5.838306</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>3.318795</td>
      <td>-4.906902</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>2.897810</td>
      <td>-5.615866</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

