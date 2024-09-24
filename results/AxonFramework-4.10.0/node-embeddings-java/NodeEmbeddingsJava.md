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
      <td>[-0.11648530513048172, 0.2578580677509308, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[-0.443376749753952, 0.4438689947128296, -0.33...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[-0.3714083731174469, 0.6715842485427856, -0.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-0.32478195428848267, 0.3659577965736389, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.3459252417087555, 0.40737485885620117, -0....</td>
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
    Iteration   50, KL divergence -1.0347, 50 iterations in 0.0605 sec
    Iteration  100, KL divergence 1.2195, 50 iterations in 0.0167 sec
    Iteration  150, KL divergence 1.2195, 50 iterations in 0.0149 sec
    Iteration  200, KL divergence 1.2195, 50 iterations in 0.0150 sec
    Iteration  250, KL divergence 1.2195, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2441, 50 iterations in 0.0499 sec
    Iteration  100, KL divergence 0.2086, 50 iterations in 0.0482 sec
    Iteration  150, KL divergence 0.2043, 50 iterations in 0.0495 sec
    Iteration  200, KL divergence 0.2038, 50 iterations in 0.0493 sec
    Iteration  250, KL divergence 0.2039, 50 iterations in 0.0485 sec
    Iteration  300, KL divergence 0.2038, 50 iterations in 0.0503 sec
    Iteration  350, KL divergence 0.2035, 50 iterations in 0.0497 sec
    Iteration  400, KL divergence 0.2035, 50 iterations in 0.0491 sec
    Iteration  450, KL divergence 0.2037, 50 iterations in 0.0496 sec
    Iteration  500, KL divergence 0.2039, 50 iterations in 0.0496 sec
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
      <td>1.393321</td>
      <td>-3.403883</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-0.811091</td>
      <td>-4.061912</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-1.037272</td>
      <td>-4.819926</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>-0.762790</td>
      <td>-4.509952</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-1.038585</td>
      <td>-5.258932</td>
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
      <td>[-1.0825317353010178, 0.6495190411806107, -0.4...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[0.0, 0.0, -1.7320507764816284, -0.21650634706...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[-1.0825317353010178, 0.8660253882408142, -0.8...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-0.8660253882408142, 1.5155444294214249, -0.6...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.21650634706020355, 1.5155444294214249, -1....</td>
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
    Iteration   50, KL divergence -0.5215, 50 iterations in 0.0694 sec
    Iteration  100, KL divergence 1.2098, 50 iterations in 0.0184 sec
    Iteration  150, KL divergence 1.2098, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.2098, 50 iterations in 0.0150 sec
    Iteration  250, KL divergence 1.2098, 50 iterations in 0.0146 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6728, 50 iterations in 0.0515 sec
    Iteration  100, KL divergence 0.6502, 50 iterations in 0.0529 sec
    Iteration  150, KL divergence 0.6471, 50 iterations in 0.0508 sec
    Iteration  200, KL divergence 0.6479, 50 iterations in 0.0507 sec
    Iteration  250, KL divergence 0.6479, 50 iterations in 0.0503 sec
    Iteration  300, KL divergence 0.6482, 50 iterations in 0.0505 sec
    Iteration  350, KL divergence 0.6485, 50 iterations in 0.0502 sec
    Iteration  400, KL divergence 0.6484, 50 iterations in 0.0504 sec
    Iteration  450, KL divergence 0.6483, 50 iterations in 0.0504 sec
    Iteration  500, KL divergence 0.6482, 50 iterations in 0.0517 sec
       --> Time elapsed: 0.51 seconds



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
      <td>1.964530</td>
      <td>-2.603106</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>1.762996</td>
      <td>-4.360161</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>4.348337</td>
      <td>1.204232</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>4.552946</td>
      <td>0.631376</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>3.766623</td>
      <td>3.342967</td>
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
      <td>[0.018408911302685738, 0.18306368589401245, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>[0.07986133545637131, -0.11644144356250763, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>[0.2119414508342743, -0.41426533460617065, 0.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>[-0.166618213057518, -0.2773071229457855, 0.32...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>[-0.24072252213954926, -0.2996034026145935, 0....</td>
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
    Iteration   50, KL divergence -0.8003, 50 iterations in 0.0674 sec
    Iteration  100, KL divergence 1.1617, 50 iterations in 0.0176 sec
    Iteration  150, KL divergence 1.1617, 50 iterations in 0.0150 sec
    Iteration  200, KL divergence 1.1617, 50 iterations in 0.0150 sec
    Iteration  250, KL divergence 1.1617, 50 iterations in 0.0150 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3646, 50 iterations in 0.0543 sec
    Iteration  100, KL divergence 0.3241, 50 iterations in 0.0514 sec
    Iteration  150, KL divergence 0.2898, 50 iterations in 0.0511 sec
    Iteration  200, KL divergence 0.2869, 50 iterations in 0.0489 sec
    Iteration  250, KL divergence 0.2853, 50 iterations in 0.0489 sec
    Iteration  300, KL divergence 0.2852, 50 iterations in 0.0486 sec
    Iteration  350, KL divergence 0.2833, 50 iterations in 0.0490 sec
    Iteration  400, KL divergence 0.2781, 50 iterations in 0.0483 sec
    Iteration  450, KL divergence 0.2770, 50 iterations in 0.0488 sec
    Iteration  500, KL divergence 0.2770, 50 iterations in 0.0494 sec
       --> Time elapsed: 0.50 seconds



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
      <td>-0.548828</td>
      <td>2.472541</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.073080</td>
      <td>-1.684540</td>
      <td>6.208335</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.015707</td>
      <td>-1.917200</td>
      <td>6.815908</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.023106</td>
      <td>-0.450534</td>
      <td>6.244583</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.0</td>
      <td>0</td>
      <td>0.013920</td>
      <td>-0.257964</td>
      <td>6.299296</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

