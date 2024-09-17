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
      <td>[0.6024961471557617, 0.35198333859443665, -0.4...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[0.32680490612983704, 0.5390559434890747, -0.6...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[0.29470503330230713, 0.7621656656265259, -0.5...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[0.3304615020751953, 0.49313652515411377, -0.4...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[0.022592678666114807, 0.546297550201416, -0.4...</td>
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
    Iteration   50, KL divergence -0.5766, 50 iterations in 0.0559 sec
    Iteration  100, KL divergence 1.2300, 50 iterations in 0.0159 sec
    Iteration  150, KL divergence 1.2300, 50 iterations in 0.0149 sec
    Iteration  200, KL divergence 1.2300, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.2300, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1993, 50 iterations in 0.0520 sec
    Iteration  100, KL divergence 0.1576, 50 iterations in 0.0461 sec
    Iteration  150, KL divergence 0.1474, 50 iterations in 0.0450 sec
    Iteration  200, KL divergence 0.1475, 50 iterations in 0.0450 sec
    Iteration  250, KL divergence 0.1474, 50 iterations in 0.0450 sec
    Iteration  300, KL divergence 0.1474, 50 iterations in 0.0459 sec
    Iteration  350, KL divergence 0.1474, 50 iterations in 0.0457 sec
    Iteration  400, KL divergence 0.1474, 50 iterations in 0.0464 sec
    Iteration  450, KL divergence 0.1474, 50 iterations in 0.0449 sec
    Iteration  500, KL divergence 0.1475, 50 iterations in 0.0451 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>4.701237</td>
      <td>1.897590</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>3.737855</td>
      <td>3.873205</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>3.888038</td>
      <td>4.895320</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>3.558906</td>
      <td>4.276738</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>3.570009</td>
      <td>5.195748</td>
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
      <td>[0.6495190411806107, 1.0825317353010178, 0.216...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[-0.8660253882408142, 0.21650634706020355, 0.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[-0.4330126941204071, 0.6495190411806107, -0.8...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-1.5155444294214249, 0.0, -0.6495190411806107...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.4330126941204071, -0.21650634706020355, -0...</td>
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
    Iteration   50, KL divergence -0.3870, 50 iterations in 0.0667 sec
    Iteration  100, KL divergence -2.8253, 50 iterations in 0.0187 sec
    Iteration  150, KL divergence -2.8253, 50 iterations in 0.0166 sec
    Iteration  200, KL divergence -2.8253, 50 iterations in 0.0166 sec
    Iteration  250, KL divergence -2.8253, 50 iterations in 0.0162 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6233, 50 iterations in 0.0506 sec
    Iteration  100, KL divergence 0.5755, 50 iterations in 0.0473 sec
    Iteration  150, KL divergence 0.5520, 50 iterations in 0.0464 sec
    Iteration  200, KL divergence 0.5509, 50 iterations in 0.0449 sec
    Iteration  250, KL divergence 0.5481, 50 iterations in 0.0446 sec
    Iteration  300, KL divergence 0.5474, 50 iterations in 0.0450 sec
    Iteration  350, KL divergence 0.5478, 50 iterations in 0.0476 sec
    Iteration  400, KL divergence 0.5478, 50 iterations in 0.0466 sec
    Iteration  450, KL divergence 0.5481, 50 iterations in 0.0463 sec
    Iteration  500, KL divergence 0.5480, 50 iterations in 0.0464 sec
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
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>axon-disruptor-4.10.0</td>
      <td>0</td>
      <td>0.012594</td>
      <td>8.181498</td>
      <td>-0.366447</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-1.399236</td>
      <td>-6.791348</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-2.201944</td>
      <td>-6.136452</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>-2.898051</td>
      <td>-4.189304</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-3.060779</td>
      <td>-5.460687</td>
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
      <td>[0.0074424524791538715, 0.4412221610546112, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[0.1490171253681183, 0.2879519462585449, 0.067...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[0.4149872064590454, 0.19218377768993378, 0.18...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[0.008498914539813995, 0.3081889748573303, 0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.06737954169511795, 0.21962259709835052, 0....</td>
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
    Iteration   50, KL divergence -0.8722, 50 iterations in 0.0666 sec
    Iteration  100, KL divergence 1.1618, 50 iterations in 0.0171 sec
    Iteration  150, KL divergence 1.1618, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.1618, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.1618, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3906, 50 iterations in 0.0512 sec
    Iteration  100, KL divergence 0.3686, 50 iterations in 0.0486 sec
    Iteration  150, KL divergence 0.3652, 50 iterations in 0.0483 sec
    Iteration  200, KL divergence 0.3638, 50 iterations in 0.0475 sec
    Iteration  250, KL divergence 0.3637, 50 iterations in 0.0472 sec
    Iteration  300, KL divergence 0.3531, 50 iterations in 0.0468 sec
    Iteration  350, KL divergence 0.3417, 50 iterations in 0.0474 sec
    Iteration  400, KL divergence 0.3401, 50 iterations in 0.0476 sec
    Iteration  450, KL divergence 0.3403, 50 iterations in 0.0453 sec
    Iteration  500, KL divergence 0.3399, 50 iterations in 0.0600 sec
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
      <td>-2.625163</td>
      <td>-1.029917</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-4.367706</td>
      <td>-4.993975</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-4.607358</td>
      <td>-5.334240</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>-5.776352</td>
      <td>-4.032821</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-5.906987</td>
      <td>-4.035341</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

