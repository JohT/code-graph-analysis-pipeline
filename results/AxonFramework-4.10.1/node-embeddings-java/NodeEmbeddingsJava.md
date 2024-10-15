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
      <td>[-0.019180692732334137, 0.21249032020568848, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.01227600872516632, 0.1341705173254013, 0.15...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[-0.029208779335021973, 0.20531219244003296, 0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.0795229822397232, 0.22743287682533264, 0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[-0.033622100949287415, 0.1735793650150299, 0....</td>
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
    Iteration   50, KL divergence -0.7343, 50 iterations in 0.0543 sec
    Iteration  100, KL divergence 1.2315, 50 iterations in 0.0163 sec
    Iteration  150, KL divergence 1.2315, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2315, 50 iterations in 0.0144 sec
    Iteration  250, KL divergence 1.2315, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.11 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1785, 50 iterations in 0.0484 sec
    Iteration  100, KL divergence 0.1544, 50 iterations in 0.0480 sec
    Iteration  150, KL divergence 0.1418, 50 iterations in 0.0415 sec
    Iteration  200, KL divergence 0.1401, 50 iterations in 0.0421 sec
    Iteration  250, KL divergence 0.1399, 50 iterations in 0.0418 sec
    Iteration  300, KL divergence 0.1403, 50 iterations in 0.0425 sec
    Iteration  350, KL divergence 0.1403, 50 iterations in 0.0428 sec
    Iteration  400, KL divergence 0.1400, 50 iterations in 0.0428 sec
    Iteration  450, KL divergence 0.1400, 50 iterations in 0.0420 sec
    Iteration  500, KL divergence 0.1403, 50 iterations in 0.0422 sec
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
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>-6.557197</td>
      <td>-4.829211</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-6.123569</td>
      <td>-4.431115</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>-6.450886</td>
      <td>-4.916198</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-6.201222</td>
      <td>-5.182496</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>-5.601924</td>
      <td>-5.325667</td>
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
      <td>[0.0, -2.1650634706020355, 0.21650634706020355...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.6495190411806107, -3.464101552963257, -0.2...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[0.4330126941204071, -2.5980761647224426, 0.64...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.0, -1.7320507764816284, -0.4330126941204071...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[-0.8660253882408142, -2.1650634706020355, -1....</td>
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
    Iteration   50, KL divergence -0.5313, 50 iterations in 0.0644 sec
    Iteration  100, KL divergence 1.2215, 50 iterations in 0.0165 sec
    Iteration  150, KL divergence 1.2215, 50 iterations in 0.0144 sec
    Iteration  200, KL divergence 1.2215, 50 iterations in 0.0143 sec
    Iteration  250, KL divergence 1.2215, 50 iterations in 0.0143 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6008, 50 iterations in 0.0496 sec
    Iteration  100, KL divergence 0.5728, 50 iterations in 0.0494 sec
    Iteration  150, KL divergence 0.5632, 50 iterations in 0.0459 sec
    Iteration  200, KL divergence 0.5626, 50 iterations in 0.0447 sec
    Iteration  250, KL divergence 0.5625, 50 iterations in 0.0446 sec
    Iteration  300, KL divergence 0.5625, 50 iterations in 0.0450 sec
    Iteration  350, KL divergence 0.5628, 50 iterations in 0.0458 sec
    Iteration  400, KL divergence 0.5628, 50 iterations in 0.0454 sec
    Iteration  450, KL divergence 0.5630, 50 iterations in 0.0450 sec
    Iteration  500, KL divergence 0.5629, 50 iterations in 0.0449 sec
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
      <td>0.759108</td>
      <td>-6.000784</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-2.623865</td>
      <td>-3.924797</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>0.625027</td>
      <td>-5.859955</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>0.444032</td>
      <td>-4.416388</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>2.726560</td>
      <td>-3.496248</td>
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
      <td>[0.6596012115478516, 0.08967316150665283, -0.1...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.18693025410175323, 0.027614105492830276, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[0.739078938961029, 0.16577795147895813, -0.25...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.5286282896995544, 0.09397175908088684, -0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[0.6060330271720886, 0.024078601971268654, 0.0...</td>
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
    Iteration   50, KL divergence -0.9413, 50 iterations in 0.0640 sec
    Iteration  100, KL divergence 1.1577, 50 iterations in 0.0170 sec
    Iteration  150, KL divergence 1.1577, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.1577, 50 iterations in 0.0149 sec
    Iteration  250, KL divergence 1.1577, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3481, 50 iterations in 0.0533 sec
    Iteration  100, KL divergence 0.3097, 50 iterations in 0.0468 sec
    Iteration  150, KL divergence 0.3070, 50 iterations in 0.0477 sec
    Iteration  200, KL divergence 0.3077, 50 iterations in 0.0475 sec
    Iteration  250, KL divergence 0.3078, 50 iterations in 0.0474 sec
    Iteration  300, KL divergence 0.3077, 50 iterations in 0.0476 sec
    Iteration  350, KL divergence 0.3076, 50 iterations in 0.0482 sec
    Iteration  400, KL divergence 0.3079, 50 iterations in 0.0475 sec
    Iteration  450, KL divergence 0.3079, 50 iterations in 0.0470 sec
    Iteration  500, KL divergence 0.3079, 50 iterations in 0.0471 sec
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
      <td>4.762013</td>
      <td>6.893301</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>5.573660</td>
      <td>7.123151</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>4.820869</td>
      <td>6.825086</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>4.738472</td>
      <td>5.835073</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>4.715592</td>
      <td>5.057615</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

