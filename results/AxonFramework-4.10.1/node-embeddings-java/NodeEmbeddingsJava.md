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
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>[-0.13814978301525116, 0.1995980441570282, 0.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.13518595695495605, 0.13514412939548492, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[-0.09232665598392487, 0.20275390148162842, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.02883017808198929, 0.19333955645561218, 0.1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[0.2953413724899292, 0.22564911842346191, 0.01...</td>
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
    Iteration   50, KL divergence -1.5719, 50 iterations in 0.0563 sec
    Iteration  100, KL divergence 1.2197, 50 iterations in 0.0159 sec
    Iteration  150, KL divergence 1.2197, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2197, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2197, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.2151, 50 iterations in 0.0505 sec
    Iteration  100, KL divergence 0.1607, 50 iterations in 0.0474 sec
    Iteration  150, KL divergence 0.1515, 50 iterations in 0.0434 sec
    Iteration  200, KL divergence 0.1515, 50 iterations in 0.0426 sec
    Iteration  250, KL divergence 0.1516, 50 iterations in 0.0430 sec
    Iteration  300, KL divergence 0.1511, 50 iterations in 0.0428 sec
    Iteration  350, KL divergence 0.1512, 50 iterations in 0.0435 sec
    Iteration  400, KL divergence 0.1513, 50 iterations in 0.0430 sec
    Iteration  450, KL divergence 0.1510, 50 iterations in 0.0428 sec
    Iteration  500, KL divergence 0.1512, 50 iterations in 0.0432 sec
       --> Time elapsed: 0.44 seconds



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
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>7.607371</td>
      <td>0.444341</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>7.121735</td>
      <td>0.676824</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>7.471860</td>
      <td>0.193693</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>7.202337</td>
      <td>-0.405968</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>6.850629</td>
      <td>-0.766227</td>
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
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>[0.0, -1.5155444294214249, -0.4330126941204071...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.8660253882408142, -2.5980761647224426, -1.2...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[0.0, -2.1650634706020355, -0.8660253882408142...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.8660253882408142, -2.1650634706020355, -0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[-0.4330126941204071, -1.2990380823612213, -1....</td>
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
    Iteration   50, KL divergence -0.2733, 50 iterations in 0.0654 sec
    Iteration  100, KL divergence 1.2132, 50 iterations in 0.0172 sec
    Iteration  150, KL divergence 1.2132, 50 iterations in 0.0144 sec
    Iteration  200, KL divergence 1.2132, 50 iterations in 0.0144 sec
    Iteration  250, KL divergence 1.2132, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6341, 50 iterations in 0.0526 sec
    Iteration  100, KL divergence 0.6102, 50 iterations in 0.0491 sec
    Iteration  150, KL divergence 0.6114, 50 iterations in 0.0483 sec
    Iteration  200, KL divergence 0.6064, 50 iterations in 0.0477 sec
    Iteration  250, KL divergence 0.5964, 50 iterations in 0.0467 sec
    Iteration  300, KL divergence 0.5802, 50 iterations in 0.0473 sec
    Iteration  350, KL divergence 0.5798, 50 iterations in 0.0479 sec
    Iteration  400, KL divergence 0.5800, 50 iterations in 0.0469 sec
    Iteration  450, KL divergence 0.5803, 50 iterations in 0.0461 sec
    Iteration  500, KL divergence 0.5801, 50 iterations in 0.0478 sec
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
      <td>org.axonframework.test</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>4.331952</td>
      <td>-4.017741</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.896765</td>
      <td>-3.330276</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>5.409278</td>
      <td>-3.546163</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>5.692207</td>
      <td>4.708922</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>5.150287</td>
      <td>-2.945214</td>
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
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>[0.7165266275405884, 0.05093897506594658, -0.1...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.5989314317703247, -0.11039327830076218, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[0.7928187847137451, 0.047785986214876175, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.7096303105354309, 0.04717385023832321, -0.1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[0.5345285534858704, 0.09103350341320038, -0.0...</td>
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
    Iteration   50, KL divergence -0.9418, 50 iterations in 0.0639 sec
    Iteration  100, KL divergence 1.1591, 50 iterations in 0.0170 sec
    Iteration  150, KL divergence 1.1591, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.1591, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.1591, 50 iterations in 0.0146 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3820, 50 iterations in 0.0556 sec
    Iteration  100, KL divergence 0.3519, 50 iterations in 0.0470 sec
    Iteration  150, KL divergence 0.3416, 50 iterations in 0.0497 sec
    Iteration  200, KL divergence 0.3381, 50 iterations in 0.0471 sec
    Iteration  250, KL divergence 0.3379, 50 iterations in 0.0459 sec
    Iteration  300, KL divergence 0.3383, 50 iterations in 0.0459 sec
    Iteration  350, KL divergence 0.3378, 50 iterations in 0.0464 sec
    Iteration  400, KL divergence 0.3383, 50 iterations in 0.0469 sec
    Iteration  450, KL divergence 0.3383, 50 iterations in 0.0465 sec
    Iteration  500, KL divergence 0.3384, 50 iterations in 0.0465 sec
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
      <td>org.axonframework.test</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>-3.101034</td>
      <td>-8.700191</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-1.788666</td>
      <td>-8.259625</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>-2.934318</td>
      <td>-8.497903</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-3.745395</td>
      <td>-7.532114</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>-3.767149</td>
      <td>-7.130975</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

