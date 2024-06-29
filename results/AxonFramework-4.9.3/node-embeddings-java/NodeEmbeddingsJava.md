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
       --> Time elapsed: 0.03 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -0.8850, 50 iterations in 0.0344 sec
    Iteration  100, KL divergence 1.0093, 50 iterations in 0.0130 sec
    Iteration  150, KL divergence 1.0093, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 1.0093, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0093, 50 iterations in 0.0129 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1123, 50 iterations in 0.0408 sec
    Iteration  100, KL divergence 0.0865, 50 iterations in 0.0573 sec
    Iteration  150, KL divergence 0.0863, 50 iterations in 0.0357 sec
    Iteration  200, KL divergence 0.0846, 50 iterations in 0.0351 sec
    Iteration  250, KL divergence 0.0836, 50 iterations in 0.0356 sec
    Iteration  300, KL divergence 0.0816, 50 iterations in 0.0341 sec
    Iteration  350, KL divergence 0.0820, 50 iterations in 0.0334 sec
    Iteration  400, KL divergence 0.0821, 50 iterations in 0.0339 sec
    Iteration  450, KL divergence 0.0816, 50 iterations in 0.0332 sec
    Iteration  500, KL divergence 0.0815, 50 iterations in 0.0325 sec
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
      <td>2.718003</td>
      <td>5.417453</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>2.506813</td>
      <td>5.589094</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>2.779025</td>
      <td>5.039153</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>2.813491</td>
      <td>5.066020</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>3.107139</td>
      <td>4.499797</td>
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
      <td>[-0.21650634706020355, 0.6495190411806107, 0.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>[-0.21650634706020355, 0.6495190411806107, 0.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>[-0.21650634706020355, 0.6495190411806107, 0.0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.21650634706020355, 0.6495190411806107, 0.0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>[-0.21650634706020355, 1.0825317353010178, -0....</td>
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
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -2.7839, 50 iterations in 0.0434 sec
    Iteration  100, KL divergence 1.0610, 50 iterations in 0.0149 sec
    Iteration  150, KL divergence 1.0610, 50 iterations in 0.0139 sec
    Iteration  200, KL divergence 1.0610, 50 iterations in 0.0140 sec
    Iteration  250, KL divergence 1.0610, 50 iterations in 0.0137 sec
       --> Time elapsed: 0.10 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.3190, 50 iterations in 0.0424 sec
    Iteration  100, KL divergence 0.2834, 50 iterations in 0.0467 sec
    Iteration  150, KL divergence 0.2802, 50 iterations in 0.0359 sec
    Iteration  200, KL divergence 0.2848, 50 iterations in 0.0357 sec
    Iteration  250, KL divergence 0.2825, 50 iterations in 0.0367 sec
    Iteration  300, KL divergence 0.2865, 50 iterations in 0.0363 sec
    Iteration  350, KL divergence 0.2889, 50 iterations in 0.0369 sec
    Iteration  400, KL divergence 0.2818, 50 iterations in 0.0364 sec
    Iteration  450, KL divergence 0.2802, 50 iterations in 0.0359 sec
    Iteration  500, KL divergence 0.2878, 50 iterations in 0.0364 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.107658</td>
      <td>-6.918494</td>
      <td>2.076180</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>-6.818971</td>
      <td>2.294127</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>-6.822393</td>
      <td>2.291829</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-6.818971</td>
      <td>2.294127</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>-6.325413</td>
      <td>1.941354</td>
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
      <td>[-0.6565729379653931, 0.1966460645198822, -0.4...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>[-0.5339991450309753, 0.2624044418334961, -0.5...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>[-0.8299940824508667, 0.0856533944606781, -0.4...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.45153915882110596, 0.08298685401678085, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>[-0.6761636734008789, 0.06620609760284424, -0....</td>
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
    Iteration   50, KL divergence -0.1200, 50 iterations in 0.0316 sec
    Iteration  100, KL divergence 0.9800, 50 iterations in 0.0131 sec
    Iteration  150, KL divergence 0.9800, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 0.9800, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 0.9800, 50 iterations in 0.0125 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1688, 50 iterations in 0.0389 sec
    Iteration  100, KL divergence 0.1383, 50 iterations in 0.0521 sec
    Iteration  150, KL divergence 0.1365, 50 iterations in 0.0369 sec
    Iteration  200, KL divergence 0.1358, 50 iterations in 0.0353 sec
    Iteration  250, KL divergence 0.1357, 50 iterations in 0.0357 sec
    Iteration  300, KL divergence 0.1352, 50 iterations in 0.0357 sec
    Iteration  350, KL divergence 0.1349, 50 iterations in 0.0355 sec
    Iteration  400, KL divergence 0.1344, 50 iterations in 0.0344 sec
    Iteration  450, KL divergence 0.1348, 50 iterations in 0.0349 sec
    Iteration  500, KL divergence 0.1351, 50 iterations in 0.0354 sec
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
      <td>-3.487991</td>
      <td>5.153075</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.044085</td>
      <td>-3.589641</td>
      <td>4.922077</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.179264</td>
      <td>-3.383295</td>
      <td>5.194582</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-3.222511</td>
      <td>4.343139</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>0</td>
      <td>0.041254</td>
      <td>-3.085900</td>
      <td>5.117950</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

