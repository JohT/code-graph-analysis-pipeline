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
       --> Time elapsed: 0.02 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=9.50 for 250 iterations...
    Iteration   50, KL divergence -0.6252, 50 iterations in 0.0415 sec
    Iteration  100, KL divergence 1.2216, 50 iterations in 0.0202 sec
    Iteration  150, KL divergence 1.2216, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.2216, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2216, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.11 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1143, 50 iterations in 0.0478 sec
    Iteration  100, KL divergence 0.0965, 50 iterations in 0.0506 sec
    Iteration  150, KL divergence 0.0879, 50 iterations in 0.0513 sec
    Iteration  200, KL divergence 0.0875, 50 iterations in 0.0412 sec
    Iteration  250, KL divergence 0.0874, 50 iterations in 0.0403 sec
    Iteration  300, KL divergence 0.0886, 50 iterations in 0.0396 sec
    Iteration  350, KL divergence 0.0881, 50 iterations in 0.0398 sec
    Iteration  400, KL divergence 0.0885, 50 iterations in 0.0391 sec
    Iteration  450, KL divergence 0.0883, 50 iterations in 0.0388 sec
    Iteration  500, KL divergence 0.0885, 50 iterations in 0.0390 sec
       --> Time elapsed: 0.43 seconds



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
      <td>-3.193766</td>
      <td>-6.993016</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>-3.191930</td>
      <td>-6.960685</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>-3.224554</td>
      <td>-6.988756</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>-3.276860</td>
      <td>-7.017493</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>-3.303815</td>
      <td>-7.206221</td>
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
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
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
    Iteration   50, KL divergence 1.2184, 50 iterations in 0.0604 sec
    Iteration  100, KL divergence 1.2273, 50 iterations in 0.0532 sec
    Iteration  150, KL divergence 1.2365, 50 iterations in 0.0524 sec
    Iteration  200, KL divergence 1.2242, 50 iterations in 0.0412 sec
    Iteration  250, KL divergence 1.2260, 50 iterations in 0.0377 sec
       --> Time elapsed: 0.25 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2195, 50 iterations in 0.0448 sec
    Iteration  100, KL divergence 0.2162, 50 iterations in 0.0444 sec
    Iteration  150, KL divergence 0.2159, 50 iterations in 0.0446 sec
    Iteration  200, KL divergence 0.2158, 50 iterations in 0.0458 sec
    Iteration  250, KL divergence 0.2160, 50 iterations in 0.0460 sec
    Iteration  300, KL divergence 0.2140, 50 iterations in 0.0458 sec
    Iteration  350, KL divergence 0.2073, 50 iterations in 0.0454 sec
    Iteration  400, KL divergence 0.2097, 50 iterations in 0.0454 sec
    Iteration  450, KL divergence 0.2107, 50 iterations in 0.0461 sec
    Iteration  500, KL divergence 0.2148, 50 iterations in 0.0458 sec
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
      <td>3.537798</td>
      <td>-2.542631</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>3.537798</td>
      <td>-2.542631</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>3.538692</td>
      <td>-2.542428</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>3.466137</td>
      <td>-2.474337</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>3.466137</td>
      <td>-2.474337</td>
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
      <td>[-0.659627377986908, 0.7030194401741028, -0.57...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>[-0.6862159967422485, 0.5118538737297058, -0.6...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>[-0.5968789458274841, 0.6037926077842712, -0.5...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>[-0.5173227190971375, 0.5896386504173279, -0.7...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>[-0.7721093893051147, 0.5893887877464294, -0.5...</td>
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
    Iteration   50, KL divergence -1.4622, 50 iterations in 0.0394 sec
    Iteration  100, KL divergence 1.1956, 50 iterations in 0.0154 sec
    Iteration  150, KL divergence 1.1956, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.1956, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.1956, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.10 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2117, 50 iterations in 0.0474 sec
    Iteration  100, KL divergence 0.1482, 50 iterations in 0.0547 sec
    Iteration  150, KL divergence 0.1412, 50 iterations in 0.0439 sec
    Iteration  200, KL divergence 0.1399, 50 iterations in 0.0445 sec
    Iteration  250, KL divergence 0.1387, 50 iterations in 0.0441 sec
    Iteration  300, KL divergence 0.1387, 50 iterations in 0.0451 sec
    Iteration  350, KL divergence 0.1384, 50 iterations in 0.0441 sec
    Iteration  400, KL divergence 0.1385, 50 iterations in 0.0450 sec
    Iteration  450, KL divergence 0.1385, 50 iterations in 0.0433 sec
    Iteration  500, KL divergence 0.1385, 50 iterations in 0.0424 sec
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
      <td>-0.121984</td>
      <td>-6.024510</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>-0.036560</td>
      <td>-6.000993</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.029047</td>
      <td>-0.071749</td>
      <td>-6.018202</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.014350</td>
      <td>-0.031238</td>
      <td>-6.137924</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.015502</td>
      <td>-0.138051</td>
      <td>-5.920181</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

