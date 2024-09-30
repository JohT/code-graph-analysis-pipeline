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
      <td>[0.20953455567359924, 0.22634854912757874, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.2527863681316376, 0.10570403188467026, -0.1...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.1309746354818344, 0.4380137324333191, -0.19...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-0.11374451220035553, 0.535956621170044, -0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.0019695963710546494, 0.10277430713176727, -...</td>
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
    Iteration   50, KL divergence -0.8959, 50 iterations in 0.0591 sec
    Iteration  100, KL divergence 1.1900, 50 iterations in 0.0167 sec
    Iteration  150, KL divergence 1.1900, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.1900, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.1900, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2227, 50 iterations in 0.0523 sec
    Iteration  100, KL divergence 0.1857, 50 iterations in 0.0451 sec
    Iteration  150, KL divergence 0.1804, 50 iterations in 0.0433 sec
    Iteration  200, KL divergence 0.1805, 50 iterations in 0.0446 sec
    Iteration  250, KL divergence 0.1804, 50 iterations in 0.0439 sec
    Iteration  300, KL divergence 0.1805, 50 iterations in 0.0446 sec
    Iteration  350, KL divergence 0.1805, 50 iterations in 0.0443 sec
    Iteration  400, KL divergence 0.1805, 50 iterations in 0.0439 sec
    Iteration  450, KL divergence 0.1799, 50 iterations in 0.0439 sec
    Iteration  500, KL divergence 0.1790, 50 iterations in 0.0431 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>4.112389</td>
      <td>-0.232991</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>2.571180</td>
      <td>0.122632</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>3.851777</td>
      <td>-1.485737</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>3.649227</td>
      <td>-2.080951</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>4.340593</td>
      <td>2.040711</td>
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
      <td>[-0.6495190411806107, -0.21650634706020355, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.4330126941204071, 0.8660253882408142, 0.433...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.21650634706020355, 1.0825317353010178, 0.21...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[1.2990380823612213, 0.6495190411806107, -0.43...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.21650634706020355, 0.0, 0.6495190411806107,...</td>
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
    Iteration   50, KL divergence -0.5351, 50 iterations in 0.0669 sec
    Iteration  100, KL divergence -2.4372, 50 iterations in 0.0211 sec
    Iteration  150, KL divergence -2.4372, 50 iterations in 0.0176 sec
    Iteration  200, KL divergence 1.2062, 50 iterations in 0.0160 sec
    Iteration  250, KL divergence 1.2062, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.14 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6662, 50 iterations in 0.0559 sec
    Iteration  100, KL divergence 0.5971, 50 iterations in 0.0474 sec
    Iteration  150, KL divergence 0.5860, 50 iterations in 0.0468 sec
    Iteration  200, KL divergence 0.5860, 50 iterations in 0.0459 sec
    Iteration  250, KL divergence 0.5851, 50 iterations in 0.0458 sec
    Iteration  300, KL divergence 0.5850, 50 iterations in 0.0467 sec
    Iteration  350, KL divergence 0.5850, 50 iterations in 0.0468 sec
    Iteration  400, KL divergence 0.5847, 50 iterations in 0.0462 sec
    Iteration  450, KL divergence 0.5848, 50 iterations in 0.0462 sec
    Iteration  500, KL divergence 0.5844, 50 iterations in 0.0462 sec
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
      <td>3.182762</td>
      <td>4.560848</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-0.322996</td>
      <td>-6.399471</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-2.917131</td>
      <td>-6.718766</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>7.580553</td>
      <td>-2.599087</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>-3.315419</td>
      <td>-5.587848</td>
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
      <td>[0.41590070724487305, 0.10952764004468918, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.4096340835094452, 0.14989015460014343, -0.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.353615403175354, 0.3333543539047241, -0.529...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[0.31881269812583923, 0.7616813778877258, -0.9...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.1420489400625229, 0.16272026300430298, -0.7...</td>
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
    Iteration   50, KL divergence -1.0857, 50 iterations in 0.0636 sec
    Iteration  100, KL divergence 1.1685, 50 iterations in 0.0169 sec
    Iteration  150, KL divergence 1.1685, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.1685, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.1685, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2917, 50 iterations in 0.0526 sec
    Iteration  100, KL divergence 0.2778, 50 iterations in 0.0478 sec
    Iteration  150, KL divergence 0.2744, 50 iterations in 0.0466 sec
    Iteration  200, KL divergence 0.2744, 50 iterations in 0.0464 sec
    Iteration  250, KL divergence 0.2740, 50 iterations in 0.0459 sec
    Iteration  300, KL divergence 0.2747, 50 iterations in 0.0458 sec
    Iteration  350, KL divergence 0.2741, 50 iterations in 0.0465 sec
    Iteration  400, KL divergence 0.2742, 50 iterations in 0.0467 sec
    Iteration  450, KL divergence 0.2744, 50 iterations in 0.0463 sec
    Iteration  500, KL divergence 0.2745, 50 iterations in 0.0456 sec
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
      <td>-1.461423</td>
      <td>-2.663160</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-0.988354</td>
      <td>-2.759712</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-4.433357</td>
      <td>0.543486</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-5.483789</td>
      <td>0.343738</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>-6.976226</td>
      <td>1.654679</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

