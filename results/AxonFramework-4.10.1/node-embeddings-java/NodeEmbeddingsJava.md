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
      <td>[0.11787067353725433, 0.005168413743376732, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.16625595092773438, -0.03187565505504608, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[0.12843935191631317, 0.026327721774578094, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.1400860846042633, 0.11471225321292877, 0.22...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[0.2924308180809021, 0.18061289191246033, 0.19...</td>
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
    Iteration   50, KL divergence -0.3700, 50 iterations in 0.0532 sec
    Iteration  100, KL divergence 1.2330, 50 iterations in 0.0160 sec
    Iteration  150, KL divergence 1.2330, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.2330, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2330, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.11 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1579, 50 iterations in 0.0510 sec
    Iteration  100, KL divergence 0.1454, 50 iterations in 0.0498 sec
    Iteration  150, KL divergence 0.1411, 50 iterations in 0.0457 sec
    Iteration  200, KL divergence 0.1406, 50 iterations in 0.0453 sec
    Iteration  250, KL divergence 0.1398, 50 iterations in 0.0452 sec
    Iteration  300, KL divergence 0.1399, 50 iterations in 0.0459 sec
    Iteration  350, KL divergence 0.1401, 50 iterations in 0.0451 sec
    Iteration  400, KL divergence 0.1392, 50 iterations in 0.0452 sec
    Iteration  450, KL divergence 0.1395, 50 iterations in 0.0443 sec
    Iteration  500, KL divergence 0.1396, 50 iterations in 0.0442 sec
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
      <td>org.axonframework.test</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>8.305568</td>
      <td>1.480571</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>7.836555</td>
      <td>1.582968</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>8.295983</td>
      <td>1.339682</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>8.300832</td>
      <td>0.834546</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>8.269986</td>
      <td>0.394984</td>
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
      <td>[-0.6495190411806107, -2.1650634706020355, 0.2...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.21650634706020355, -2.5980761647224426, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[-0.8660253882408142, -3.0310888588428497, 0.0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.8660253882408142, -1.948557123541832, 0.0,...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[-0.4330126941204071, -1.5155444294214249, 0.0...</td>
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
    Iteration   50, KL divergence -0.5724, 50 iterations in 0.0642 sec
    Iteration  100, KL divergence 1.2222, 50 iterations in 0.0172 sec
    Iteration  150, KL divergence 1.2222, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2222, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.2222, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5864, 50 iterations in 0.0503 sec
    Iteration  100, KL divergence 0.5591, 50 iterations in 0.0486 sec
    Iteration  150, KL divergence 0.5527, 50 iterations in 0.0469 sec
    Iteration  200, KL divergence 0.5518, 50 iterations in 0.0463 sec
    Iteration  250, KL divergence 0.5514, 50 iterations in 0.0460 sec
    Iteration  300, KL divergence 0.5507, 50 iterations in 0.0456 sec
    Iteration  350, KL divergence 0.5514, 50 iterations in 0.0466 sec
    Iteration  400, KL divergence 0.5509, 50 iterations in 0.0460 sec
    Iteration  450, KL divergence 0.5513, 50 iterations in 0.0453 sec
    Iteration  500, KL divergence 0.5511, 50 iterations in 0.0452 sec
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
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>4.590395</td>
      <td>-1.370429</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.373798</td>
      <td>-1.707531</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>4.575410</td>
      <td>-0.916451</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>5.360637</td>
      <td>-1.411142</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>5.672203</td>
      <td>0.443218</td>
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
      <td>[0.42873048782348633, -0.08612282574176788, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.3526158034801483, -0.17100203037261963, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[0.203726664185524, 0.08670105785131454, -0.18...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.36470094323158264, 0.08761901408433914, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[0.2771420180797577, 0.05386091396212578, -0.2...</td>
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
    Iteration   50, KL divergence -0.8188, 50 iterations in 0.0644 sec
    Iteration  100, KL divergence 1.1514, 50 iterations in 0.0171 sec
    Iteration  150, KL divergence 1.1514, 50 iterations in 0.0149 sec
    Iteration  200, KL divergence 1.1514, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.1514, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3817, 50 iterations in 0.0543 sec
    Iteration  100, KL divergence 0.3677, 50 iterations in 0.0479 sec
    Iteration  150, KL divergence 0.3594, 50 iterations in 0.0472 sec
    Iteration  200, KL divergence 0.3553, 50 iterations in 0.0473 sec
    Iteration  250, KL divergence 0.3523, 50 iterations in 0.0474 sec
    Iteration  300, KL divergence 0.3522, 50 iterations in 0.0479 sec
    Iteration  350, KL divergence 0.3520, 50 iterations in 0.0489 sec
    Iteration  400, KL divergence 0.3518, 50 iterations in 0.0478 sec
    Iteration  450, KL divergence 0.3520, 50 iterations in 0.0473 sec
    Iteration  500, KL divergence 0.3521, 50 iterations in 0.0467 sec
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
      <td>8.199682</td>
      <td>-0.221364</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>8.041079</td>
      <td>-0.316576</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>8.767129</td>
      <td>0.334987</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>8.051112</td>
      <td>0.978881</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>7.892640</td>
      <td>1.364843</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

