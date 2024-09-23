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
      <td>[0.5195624232292175, 0.08539564907550812, -0.4...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[0.31239837408065796, 0.28732404112815857, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[0.4152940511703491, 0.6067225933074951, -0.43...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[0.445267915725708, 0.2954491674900055, -0.485...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[0.12943659722805023, 0.4358472228050232, -0.4...</td>
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
    Iteration   50, KL divergence -0.1829, 50 iterations in 0.0561 sec
    Iteration  100, KL divergence 1.2022, 50 iterations in 0.0169 sec
    Iteration  150, KL divergence 1.2022, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.2022, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.2022, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1647, 50 iterations in 0.0528 sec
    Iteration  100, KL divergence 0.1493, 50 iterations in 0.0475 sec
    Iteration  150, KL divergence 0.1423, 50 iterations in 0.0460 sec
    Iteration  200, KL divergence 0.1416, 50 iterations in 0.0457 sec
    Iteration  250, KL divergence 0.1417, 50 iterations in 0.0461 sec
    Iteration  300, KL divergence 0.1416, 50 iterations in 0.0473 sec
    Iteration  350, KL divergence 0.1419, 50 iterations in 0.0472 sec
    Iteration  400, KL divergence 0.1417, 50 iterations in 0.0483 sec
    Iteration  450, KL divergence 0.1417, 50 iterations in 0.0474 sec
    Iteration  500, KL divergence 0.1418, 50 iterations in 0.0473 sec
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
      <td>1.954952</td>
      <td>-0.964519</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-1.521525</td>
      <td>-2.586553</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-1.197496</td>
      <td>-3.792419</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>-1.089217</td>
      <td>-3.380051</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-1.586675</td>
      <td>-4.263120</td>
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
      <td>[0.21650634706020355, 0.4330126941204071, -0.2...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[1.0825317353010178, 0.4330126941204071, -0.64...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[-0.8660253882408142, 0.6495190411806107, -1.9...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[0.6495190411806107, 0.4330126941204071, -0.86...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[0.0, -0.8660253882408142, -0.8660253882408142...</td>
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
    Iteration   50, KL divergence -0.2945, 50 iterations in 0.0683 sec
    Iteration  100, KL divergence 1.2172, 50 iterations in 0.0172 sec
    Iteration  150, KL divergence 1.2172, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2172, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2172, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6005, 50 iterations in 0.0524 sec
    Iteration  100, KL divergence 0.5827, 50 iterations in 0.0485 sec
    Iteration  150, KL divergence 0.5816, 50 iterations in 0.0476 sec
    Iteration  200, KL divergence 0.5816, 50 iterations in 0.0470 sec
    Iteration  250, KL divergence 0.5817, 50 iterations in 0.0470 sec
    Iteration  300, KL divergence 0.5817, 50 iterations in 0.0469 sec
    Iteration  350, KL divergence 0.5818, 50 iterations in 0.0486 sec
    Iteration  400, KL divergence 0.5818, 50 iterations in 0.0481 sec
    Iteration  450, KL divergence 0.5818, 50 iterations in 0.0474 sec
    Iteration  500, KL divergence 0.5817, 50 iterations in 0.0474 sec
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
      <td>-2.651083</td>
      <td>-0.846666</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-4.143179</td>
      <td>-4.085305</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-4.501064</td>
      <td>6.435607</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>-4.347200</td>
      <td>-3.729032</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-4.481479</td>
      <td>6.348183</td>
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
      <td>[-0.3274601101875305, 0.000887062749825418, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[-0.09275101870298386, 0.01061203982681036, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[-0.09063579142093658, -0.27841636538505554, -...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-0.4161336421966553, -0.3303450644016266, 0.0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.5131003260612488, -0.45767587423324585, 0....</td>
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
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.9994, 50 iterations in 0.0647 sec
    Iteration  100, KL divergence 1.1718, 50 iterations in 0.0168 sec
    Iteration  150, KL divergence 1.1718, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.1718, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.1718, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2827, 50 iterations in 0.0552 sec
    Iteration  100, KL divergence 0.2569, 50 iterations in 0.0495 sec
    Iteration  150, KL divergence 0.2512, 50 iterations in 0.0463 sec
    Iteration  200, KL divergence 0.2506, 50 iterations in 0.0459 sec
    Iteration  250, KL divergence 0.2509, 50 iterations in 0.0458 sec
    Iteration  300, KL divergence 0.2509, 50 iterations in 0.0461 sec
    Iteration  350, KL divergence 0.2510, 50 iterations in 0.0468 sec
    Iteration  400, KL divergence 0.2511, 50 iterations in 0.0462 sec
    Iteration  450, KL divergence 0.2511, 50 iterations in 0.0462 sec
    Iteration  500, KL divergence 0.2512, 50 iterations in 0.0461 sec
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
      <td>2.875767</td>
      <td>-0.856684</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>2.712344</td>
      <td>4.867671</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>3.601489</td>
      <td>5.599570</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>2.398011</td>
      <td>7.036631</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>2.397329</td>
      <td>7.072818</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

