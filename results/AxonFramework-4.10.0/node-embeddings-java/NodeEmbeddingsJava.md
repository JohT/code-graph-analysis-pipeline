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
      <td>org.axonframework.test</td>
      <td>test</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.071069</td>
      <td>[-0.23907749354839325, 0.25115057826042175, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>[-0.25671643018722534, 0.22634342312812805, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>[-0.23002834618091583, 0.2406129688024521, 0.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>[-0.2189161479473114, 0.23353014886379242, 0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>[-0.15309275686740875, 0.18397949635982513, 0....</td>
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
    Iteration   50, KL divergence 0.5178, 50 iterations in 0.0451 sec
    Iteration  100, KL divergence 1.2289, 50 iterations in 0.0155 sec
    Iteration  150, KL divergence 1.2289, 50 iterations in 0.0144 sec
    Iteration  200, KL divergence 1.2289, 50 iterations in 0.0144 sec
    Iteration  250, KL divergence 1.2289, 50 iterations in 0.0143 sec
       --> Time elapsed: 0.10 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1238, 50 iterations in 0.0475 sec
    Iteration  100, KL divergence 0.0973, 50 iterations in 0.0500 sec
    Iteration  150, KL divergence 0.0790, 50 iterations in 0.0443 sec
    Iteration  200, KL divergence 0.0795, 50 iterations in 0.0442 sec
    Iteration  250, KL divergence 0.0823, 50 iterations in 0.0439 sec
    Iteration  300, KL divergence 0.0826, 50 iterations in 0.0433 sec
    Iteration  350, KL divergence 0.0823, 50 iterations in 0.0448 sec
    Iteration  400, KL divergence 0.0671, 50 iterations in 0.0447 sec
    Iteration  450, KL divergence 0.0835, 50 iterations in 0.0438 sec
    Iteration  500, KL divergence 0.0854, 50 iterations in 0.0431 sec
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
      <td>org.axonframework.test</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.071069</td>
      <td>3.305623</td>
      <td>-4.731573</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>3.262036</td>
      <td>-4.658428</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>3.286259</td>
      <td>-4.688288</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>3.263377</td>
      <td>-4.698020</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>3.088212</td>
      <td>-4.643765</td>
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
      <td>org.axonframework.test</td>
      <td>test</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.071069</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.0,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
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
    Iteration   50, KL divergence 0.6219, 50 iterations in 0.0490 sec
    Iteration  100, KL divergence 1.0068, 50 iterations in 0.0430 sec
    Iteration  150, KL divergence 1.0468, 50 iterations in 0.0443 sec
    Iteration  200, KL divergence 1.0016, 50 iterations in 0.0432 sec
    Iteration  250, KL divergence 1.0545, 50 iterations in 0.0335 sec
       --> Time elapsed: 0.21 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2577, 50 iterations in 0.0452 sec
    Iteration  100, KL divergence 0.2472, 50 iterations in 0.0468 sec
    Iteration  150, KL divergence 0.2338, 50 iterations in 0.0460 sec
    Iteration  200, KL divergence 0.2324, 50 iterations in 0.0454 sec
    Iteration  250, KL divergence 0.2304, 50 iterations in 0.0466 sec
    Iteration  300, KL divergence 0.2307, 50 iterations in 0.0454 sec
    Iteration  350, KL divergence 0.2315, 50 iterations in 0.0459 sec
    Iteration  400, KL divergence 0.2297, 50 iterations in 0.0459 sec
    Iteration  450, KL divergence 0.2274, 50 iterations in 0.0453 sec
    Iteration  500, KL divergence 0.2280, 50 iterations in 0.0526 sec
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
      <td>org.axonframework.test</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.071069</td>
      <td>-9.696099</td>
      <td>2.851755</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>-9.600915</td>
      <td>3.419174</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>-9.702023</td>
      <td>2.862324</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>-9.202490</td>
      <td>2.908449</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>-9.247173</td>
      <td>3.146432</td>
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
      <td>org.axonframework.test</td>
      <td>test</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.071069</td>
      <td>[-1.5495059490203857, -0.02293143980205059, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>[-1.6644877195358276, 0.008333014324307442, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>[-1.639358639717102, -0.03277219459414482, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>[-1.552009105682373, 0.022692786529660225, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>[-1.595945954322815, -0.037009019404649734, -0...</td>
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
    Iteration   50, KL divergence -1.2441, 50 iterations in 0.0406 sec
    Iteration  100, KL divergence 1.1895, 50 iterations in 0.0154 sec
    Iteration  150, KL divergence 1.1895, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.1895, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.1895, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.10 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1776, 50 iterations in 0.0506 sec
    Iteration  100, KL divergence 0.1526, 50 iterations in 0.0538 sec
    Iteration  150, KL divergence 0.1457, 50 iterations in 0.0453 sec
    Iteration  200, KL divergence 0.1361, 50 iterations in 0.0444 sec
    Iteration  250, KL divergence 0.1365, 50 iterations in 0.0441 sec
    Iteration  300, KL divergence 0.1362, 50 iterations in 0.0452 sec
    Iteration  350, KL divergence 0.1363, 50 iterations in 0.0457 sec
    Iteration  400, KL divergence 0.1361, 50 iterations in 0.0456 sec
    Iteration  450, KL divergence 0.1359, 50 iterations in 0.0459 sec
    Iteration  500, KL divergence 0.1361, 50 iterations in 0.0455 sec
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
      <td>org.axonframework.test</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.071069</td>
      <td>-3.682955</td>
      <td>5.418816</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>-3.672920</td>
      <td>5.400627</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>-3.653168</td>
      <td>5.416667</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>-3.741331</td>
      <td>5.340232</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>-3.725544</td>
      <td>5.337157</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

