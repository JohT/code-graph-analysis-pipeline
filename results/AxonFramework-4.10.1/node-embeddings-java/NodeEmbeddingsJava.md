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
      <td>[0.4021469056606293, -0.2524033784866333, 0.24...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.47164928913116455, -0.3621380925178528, 0.1...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.2598904073238373, -0.017650552093982697, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-0.06975991278886795, 0.007653098553419113, 0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.0915667787194252, -0.22240066528320312, 0.0...</td>
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
    Iteration   50, KL divergence -0.5833, 50 iterations in 0.0549 sec
    Iteration  100, KL divergence 1.2104, 50 iterations in 0.0160 sec
    Iteration  150, KL divergence 1.2104, 50 iterations in 0.0149 sec
    Iteration  200, KL divergence 1.2104, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.2104, 50 iterations in 0.0149 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1885, 50 iterations in 0.0533 sec
    Iteration  100, KL divergence 0.1622, 50 iterations in 0.0484 sec
    Iteration  150, KL divergence 0.1548, 50 iterations in 0.0458 sec
    Iteration  200, KL divergence 0.1549, 50 iterations in 0.0470 sec
    Iteration  250, KL divergence 0.1549, 50 iterations in 0.0475 sec
    Iteration  300, KL divergence 0.1550, 50 iterations in 0.0489 sec
    Iteration  350, KL divergence 0.1549, 50 iterations in 0.0492 sec
    Iteration  400, KL divergence 0.1547, 50 iterations in 0.0483 sec
    Iteration  450, KL divergence 0.1547, 50 iterations in 0.0483 sec
    Iteration  500, KL divergence 0.1548, 50 iterations in 0.0480 sec
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
      <td>4.325942</td>
      <td>-0.491807</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>3.505060</td>
      <td>0.145381</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>3.612484</td>
      <td>-3.239844</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>3.311228</td>
      <td>-3.972375</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>2.873593</td>
      <td>-3.727525</td>
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
      <td>[0.0, -0.4330126941204071, -0.6495190411806107...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.6495190411806107, 0.0, -0.21650634706020355...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.4330126941204071, 0.0, -0.8660253882408142,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[1.0825317353010178, -0.4330126941204071, 0.0,...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[1.0825317353010178, -0.21650634706020355, -1....</td>
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
       --> Time elapsed: 0.01 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.0391, 50 iterations in 0.0671 sec
    Iteration  100, KL divergence -2.4236, 50 iterations in 0.0212 sec
    Iteration  150, KL divergence -2.8276, 50 iterations in 0.0173 sec
    Iteration  200, KL divergence -2.8276, 50 iterations in 0.0166 sec
    Iteration  250, KL divergence 1.2199, 50 iterations in 0.0149 sec
       --> Time elapsed: 0.14 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6442, 50 iterations in 0.0491 sec
    Iteration  100, KL divergence 0.6276, 50 iterations in 0.0476 sec
    Iteration  150, KL divergence 0.6280, 50 iterations in 0.0459 sec
    Iteration  200, KL divergence 0.6268, 50 iterations in 0.0457 sec
    Iteration  250, KL divergence 0.6265, 50 iterations in 0.0459 sec
    Iteration  300, KL divergence 0.6267, 50 iterations in 0.0476 sec
    Iteration  350, KL divergence 0.6269, 50 iterations in 0.0479 sec
    Iteration  400, KL divergence 0.6267, 50 iterations in 0.0475 sec
    Iteration  450, KL divergence 0.6266, 50 iterations in 0.0479 sec
    Iteration  500, KL divergence 0.6265, 50 iterations in 0.0477 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>0.635707</td>
      <td>0.744587</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-0.979112</td>
      <td>-1.343819</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-1.149767</td>
      <td>1.992140</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-4.458266</td>
      <td>5.041405</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>-3.369174</td>
      <td>5.517791</td>
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
      <td>[-0.14582879841327667, -0.2807251214981079, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[-0.35659679770469666, -0.415604829788208, 0.4...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[-0.5995396971702576, 0.003818071912974119, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-0.6273948550224304, -0.14657530188560486, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[-0.7108625769615173, -0.33340224623680115, -0...</td>
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
    Iteration   50, KL divergence -0.6389, 50 iterations in 0.0650 sec
    Iteration  100, KL divergence 1.1602, 50 iterations in 0.0185 sec
    Iteration  150, KL divergence 1.1602, 50 iterations in 0.0153 sec
    Iteration  200, KL divergence 1.1602, 50 iterations in 0.0150 sec
    Iteration  250, KL divergence 1.1602, 50 iterations in 0.0151 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3029, 50 iterations in 0.0556 sec
    Iteration  100, KL divergence 0.2892, 50 iterations in 0.0492 sec
    Iteration  150, KL divergence 0.2773, 50 iterations in 0.0478 sec
    Iteration  200, KL divergence 0.2767, 50 iterations in 0.0472 sec
    Iteration  250, KL divergence 0.2765, 50 iterations in 0.0472 sec
    Iteration  300, KL divergence 0.2763, 50 iterations in 0.0479 sec
    Iteration  350, KL divergence 0.2763, 50 iterations in 0.0487 sec
    Iteration  400, KL divergence 0.2766, 50 iterations in 0.0484 sec
    Iteration  450, KL divergence 0.2767, 50 iterations in 0.0480 sec
    Iteration  500, KL divergence 0.2767, 50 iterations in 0.0477 sec
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
      <td>2.525874</td>
      <td>-2.889537</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>2.342551</td>
      <td>-2.502203</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>3.128796</td>
      <td>-6.233017</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>3.516675</td>
      <td>-6.654909</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>1.425617</td>
      <td>-7.142885</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

