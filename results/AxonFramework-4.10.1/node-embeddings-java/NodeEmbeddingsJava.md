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
      <td>[0.12163390219211578, -0.45836174488067627, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.024388067424297333, -0.6180813312530518, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.37081408500671387, -0.3059995174407959, 0.3...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[0.43471795320510864, -0.06723399460315704, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.46703988313674927, -0.26482442021369934, 0....</td>
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
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.3691, 50 iterations in 0.0596 sec
    Iteration  100, KL divergence 1.2324, 50 iterations in 0.0171 sec
    Iteration  150, KL divergence 1.2324, 50 iterations in 0.0158 sec
    Iteration  200, KL divergence 1.2324, 50 iterations in 0.0160 sec
    Iteration  250, KL divergence 1.2324, 50 iterations in 0.0157 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2148, 50 iterations in 0.0538 sec
    Iteration  100, KL divergence 0.1640, 50 iterations in 0.0454 sec
    Iteration  150, KL divergence 0.1496, 50 iterations in 0.0433 sec
    Iteration  200, KL divergence 0.1494, 50 iterations in 0.0431 sec
    Iteration  250, KL divergence 0.1497, 50 iterations in 0.0433 sec
    Iteration  300, KL divergence 0.1498, 50 iterations in 0.0446 sec
    Iteration  350, KL divergence 0.1498, 50 iterations in 0.0441 sec
    Iteration  400, KL divergence 0.1496, 50 iterations in 0.0444 sec
    Iteration  450, KL divergence 0.1496, 50 iterations in 0.0447 sec
    Iteration  500, KL divergence 0.1496, 50 iterations in 0.0439 sec
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
      <td>4.646020</td>
      <td>-1.565343</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>3.642539</td>
      <td>-1.363402</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>6.814093</td>
      <td>-1.868744</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>7.805996</td>
      <td>-2.017837</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>7.591191</td>
      <td>-2.484997</td>
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
      <td>[-0.8660253882408142, 0.21650634706020355, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.21650634706020355, 0.6495190411806107, -0.6...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.21650634706020355, -0.8660253882408142, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-0.4330126941204071, 0.0, -1.0825317353010178...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.8660253882408142, -1.0825317353010178, -1.0...</td>
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
    Iteration   50, KL divergence -0.0798, 50 iterations in 0.0654 sec
    Iteration  100, KL divergence 1.2235, 50 iterations in 0.0170 sec
    Iteration  150, KL divergence 1.2235, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.2235, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.2235, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5797, 50 iterations in 0.0514 sec
    Iteration  100, KL divergence 0.5655, 50 iterations in 0.0486 sec
    Iteration  150, KL divergence 0.5610, 50 iterations in 0.0474 sec
    Iteration  200, KL divergence 0.5603, 50 iterations in 0.0468 sec
    Iteration  250, KL divergence 0.5602, 50 iterations in 0.0463 sec
    Iteration  300, KL divergence 0.5602, 50 iterations in 0.0464 sec
    Iteration  350, KL divergence 0.5601, 50 iterations in 0.0480 sec
    Iteration  400, KL divergence 0.5600, 50 iterations in 0.0481 sec
    Iteration  450, KL divergence 0.5601, 50 iterations in 0.0478 sec
    Iteration  500, KL divergence 0.5599, 50 iterations in 0.0477 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>-7.575481</td>
      <td>2.084238</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-0.210524</td>
      <td>1.701332</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-7.529248</td>
      <td>-3.155047</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-5.521919</td>
      <td>-2.875316</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>-6.667449</td>
      <td>-2.347989</td>
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
      <td>[0.5846269726753235, 0.4707794487476349, 0.019...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>[0.40350866317749023, 0.3240987956523895, 0.02...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>[0.2586008608341217, 0.687234103679657, -0.246...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[0.4632216989994049, 0.6411672830581665, -0.33...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>[0.2673313021659851, 0.979340672492981, -0.059...</td>
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
    Iteration   50, KL divergence -0.6850, 50 iterations in 0.0662 sec
    Iteration  100, KL divergence 1.1623, 50 iterations in 0.0181 sec
    Iteration  150, KL divergence 1.1623, 50 iterations in 0.0150 sec
    Iteration  200, KL divergence 1.1623, 50 iterations in 0.0150 sec
    Iteration  250, KL divergence 1.1623, 50 iterations in 0.0150 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3353, 50 iterations in 0.0516 sec
    Iteration  100, KL divergence 0.3150, 50 iterations in 0.0469 sec
    Iteration  150, KL divergence 0.3134, 50 iterations in 0.0455 sec
    Iteration  200, KL divergence 0.3134, 50 iterations in 0.0445 sec
    Iteration  250, KL divergence 0.3133, 50 iterations in 0.0445 sec
    Iteration  300, KL divergence 0.3135, 50 iterations in 0.0444 sec
    Iteration  350, KL divergence 0.3136, 50 iterations in 0.0458 sec
    Iteration  400, KL divergence 0.3136, 50 iterations in 0.0450 sec
    Iteration  450, KL divergence 0.3135, 50 iterations in 0.0446 sec
    Iteration  500, KL divergence 0.3135, 50 iterations in 0.0443 sec
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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.018608</td>
      <td>-3.421525</td>
      <td>1.653019</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.10.1</td>
      <td>0</td>
      <td>0.012619</td>
      <td>-2.183763</td>
      <td>1.917056</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.073174</td>
      <td>-0.394794</td>
      <td>5.526225</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-1.137351</td>
      <td>6.862015</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.1</td>
      <td>0</td>
      <td>0.023112</td>
      <td>1.248820</td>
      <td>6.785845</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

