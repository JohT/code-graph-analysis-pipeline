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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>[0.09464022517204285, -0.010115563869476318, -...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[-0.2440248727798462, 0.20696035027503967, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[-0.27170974016189575, 0.4956693649291992, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-0.2376946061849594, 0.2169816941022873, -0.4...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.39238303899765015, 0.3908323049545288, -0....</td>
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
    Iteration   50, KL divergence -0.2781, 50 iterations in 0.0548 sec
    Iteration  100, KL divergence 1.2424, 50 iterations in 0.0167 sec
    Iteration  150, KL divergence 1.2424, 50 iterations in 0.0153 sec
    Iteration  200, KL divergence 1.2424, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.2424, 50 iterations in 0.0150 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1838, 50 iterations in 0.0536 sec
    Iteration  100, KL divergence 0.1669, 50 iterations in 0.0477 sec
    Iteration  150, KL divergence 0.1582, 50 iterations in 0.0448 sec
    Iteration  200, KL divergence 0.1573, 50 iterations in 0.0439 sec
    Iteration  250, KL divergence 0.1576, 50 iterations in 0.0440 sec
    Iteration  300, KL divergence 0.1578, 50 iterations in 0.0445 sec
    Iteration  350, KL divergence 0.1578, 50 iterations in 0.0448 sec
    Iteration  400, KL divergence 0.1576, 50 iterations in 0.0440 sec
    Iteration  450, KL divergence 0.1577, 50 iterations in 0.0436 sec
    Iteration  500, KL divergence 0.1577, 50 iterations in 0.0436 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>-3.661770</td>
      <td>1.358733</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-3.087930</td>
      <td>2.813489</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-3.065791</td>
      <td>3.769562</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>-2.534441</td>
      <td>3.420608</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-2.535396</td>
      <td>3.948358</td>
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>[-0.8660253882408142, 0.21650634706020355, -1....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[-0.6495190411806107, -0.21650634706020355, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[0.0, 0.4330126941204071, -0.4330126941204071,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-1.7320507764816284, -0.4330126941204071, -1....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.4330126941204071, 0.21650634706020355, -0....</td>
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
    Iteration   50, KL divergence -0.0699, 50 iterations in 0.0682 sec
    Iteration  100, KL divergence -2.8493, 50 iterations in 0.0208 sec
    Iteration  150, KL divergence -2.8493, 50 iterations in 0.0167 sec
    Iteration  200, KL divergence -2.8493, 50 iterations in 0.0169 sec
    Iteration  250, KL divergence 1.1981, 50 iterations in 0.0163 sec
       --> Time elapsed: 0.14 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6348, 50 iterations in 0.0661 sec
    Iteration  100, KL divergence 0.6168, 50 iterations in 0.0480 sec
    Iteration  150, KL divergence 0.6153, 50 iterations in 0.0468 sec
    Iteration  200, KL divergence 0.6155, 50 iterations in 0.0459 sec
    Iteration  250, KL divergence 0.6152, 50 iterations in 0.0463 sec
    Iteration  300, KL divergence 0.6154, 50 iterations in 0.0475 sec
    Iteration  350, KL divergence 0.6157, 50 iterations in 0.0472 sec
    Iteration  400, KL divergence 0.6157, 50 iterations in 0.0467 sec
    Iteration  450, KL divergence 0.6159, 50 iterations in 0.0471 sec
    Iteration  500, KL divergence 0.6158, 50 iterations in 0.0478 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>-2.571735</td>
      <td>-3.274595</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-3.429140</td>
      <td>-2.671359</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-3.111828</td>
      <td>-4.560869</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>0.765721</td>
      <td>3.003259</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-3.347134</td>
      <td>-4.668212</td>
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>[-0.18941745162010193, 0.24193620681762695, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[0.0001506621192675084, 0.16934873163700104, -...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[-0.027306372299790382, -0.013707403093576431,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-0.0612686350941658, -0.16262005269527435, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.13323426246643066, -0.3811052441596985, 0....</td>
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
    Iteration   50, KL divergence -1.4831, 50 iterations in 0.0663 sec
    Iteration  100, KL divergence 1.1693, 50 iterations in 0.0175 sec
    Iteration  150, KL divergence 1.1693, 50 iterations in 0.0150 sec
    Iteration  200, KL divergence 1.1693, 50 iterations in 0.0151 sec
    Iteration  250, KL divergence 1.1693, 50 iterations in 0.0150 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3145, 50 iterations in 0.0528 sec
    Iteration  100, KL divergence 0.2989, 50 iterations in 0.0473 sec
    Iteration  150, KL divergence 0.2914, 50 iterations in 0.0537 sec
    Iteration  200, KL divergence 0.2918, 50 iterations in 0.0465 sec
    Iteration  250, KL divergence 0.2919, 50 iterations in 0.0472 sec
    Iteration  300, KL divergence 0.2915, 50 iterations in 0.0470 sec
    Iteration  350, KL divergence 0.2919, 50 iterations in 0.0475 sec
    Iteration  400, KL divergence 0.2913, 50 iterations in 0.0472 sec
    Iteration  450, KL divergence 0.2915, 50 iterations in 0.0466 sec
    Iteration  500, KL divergence 0.2916, 50 iterations in 0.0466 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>1.993040</td>
      <td>-1.310042</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-2.421247</td>
      <td>7.234642</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-1.872938</td>
      <td>7.452552</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>-3.590921</td>
      <td>8.203186</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-3.675407</td>
      <td>8.270181</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

