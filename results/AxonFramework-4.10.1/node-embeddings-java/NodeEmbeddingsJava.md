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
      <td>[0.03805271536111832, 0.21033142507076263, 0.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.10207533091306686, 0.1409481018781662, 0.05...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[0.08560039103031158, 0.20812413096427917, 0.0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.20426517724990845, 0.18827323615550995, 0.1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[0.48003485798835754, 0.23245176672935486, 0.0...</td>
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
    Iteration   50, KL divergence -0.8770, 50 iterations in 0.0548 sec
    Iteration  100, KL divergence 1.2226, 50 iterations in 0.0155 sec
    Iteration  150, KL divergence 1.2226, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.2226, 50 iterations in 0.0145 sec
    Iteration  250, KL divergence 1.2226, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.11 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1880, 50 iterations in 0.0520 sec
    Iteration  100, KL divergence 0.1626, 50 iterations in 0.0475 sec
    Iteration  150, KL divergence 0.1564, 50 iterations in 0.0440 sec
    Iteration  200, KL divergence 0.1545, 50 iterations in 0.0439 sec
    Iteration  250, KL divergence 0.1544, 50 iterations in 0.0433 sec
    Iteration  300, KL divergence 0.1544, 50 iterations in 0.0445 sec
    Iteration  350, KL divergence 0.1545, 50 iterations in 0.0436 sec
    Iteration  400, KL divergence 0.1546, 50 iterations in 0.0433 sec
    Iteration  450, KL divergence 0.1547, 50 iterations in 0.0432 sec
    Iteration  500, KL divergence 0.1547, 50 iterations in 0.0431 sec
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
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>-7.230471</td>
      <td>-3.397184</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-6.759938</td>
      <td>-3.039499</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>-7.138777</td>
      <td>-3.503706</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-6.723875</td>
      <td>-3.818644</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>-6.125430</td>
      <td>-4.254728</td>
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
      <td>[0.4330126941204071, -1.7320507764816284, -1.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.0, -2.814582511782646, -0.8660253882408142,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[0.4330126941204071, -2.381569817662239, -1.08...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.4330126941204071, -1.7320507764816284, -0.8...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[-0.4330126941204071, -1.948557123541832, -1.5...</td>
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
    Iteration   50, KL divergence -0.6732, 50 iterations in 0.0626 sec
    Iteration  100, KL divergence -2.8274, 50 iterations in 0.0186 sec
    Iteration  150, KL divergence 1.2201, 50 iterations in 0.0146 sec
    Iteration  200, KL divergence 1.2201, 50 iterations in 0.0142 sec
    Iteration  250, KL divergence 1.2201, 50 iterations in 0.0142 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.5907, 50 iterations in 0.0551 sec
    Iteration  100, KL divergence 0.5627, 50 iterations in 0.0461 sec
    Iteration  150, KL divergence 0.5536, 50 iterations in 0.0446 sec
    Iteration  200, KL divergence 0.5514, 50 iterations in 0.0450 sec
    Iteration  250, KL divergence 0.5442, 50 iterations in 0.0451 sec
    Iteration  300, KL divergence 0.5301, 50 iterations in 0.0448 sec
    Iteration  350, KL divergence 0.5304, 50 iterations in 0.0456 sec
    Iteration  400, KL divergence 0.5302, 50 iterations in 0.0443 sec
    Iteration  450, KL divergence 0.5302, 50 iterations in 0.0439 sec
    Iteration  500, KL divergence 0.5306, 50 iterations in 0.0440 sec
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
      <td>2.991758</td>
      <td>3.895687</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>1.983255</td>
      <td>4.855841</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>3.302656</td>
      <td>3.761666</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>3.247760</td>
      <td>4.173491</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>2.994317</td>
      <td>2.112872</td>
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
      <td>[0.6982396841049194, -0.01869179494678974, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.7003304362297058, -0.10200608521699905, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>[0.9868415594100952, -0.1705016791820526, -0.2...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.8724585771560669, -0.22147177159786224, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>[0.8180669546127319, -0.24799375236034393, -0....</td>
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
    Iteration   50, KL divergence -0.8084, 50 iterations in 0.0665 sec
    Iteration  100, KL divergence -2.8890, 50 iterations in 0.0184 sec
    Iteration  150, KL divergence 1.1585, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.1585, 50 iterations in 0.0148 sec
    Iteration  250, KL divergence 1.1585, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3913, 50 iterations in 0.0553 sec
    Iteration  100, KL divergence 0.3711, 50 iterations in 0.0482 sec
    Iteration  150, KL divergence 0.3684, 50 iterations in 0.0478 sec
    Iteration  200, KL divergence 0.3675, 50 iterations in 0.0487 sec
    Iteration  250, KL divergence 0.3632, 50 iterations in 0.0471 sec
    Iteration  300, KL divergence 0.3627, 50 iterations in 0.0469 sec
    Iteration  350, KL divergence 0.3620, 50 iterations in 0.0479 sec
    Iteration  400, KL divergence 0.3623, 50 iterations in 0.0474 sec
    Iteration  450, KL divergence 0.3622, 50 iterations in 0.0528 sec
    Iteration  500, KL divergence 0.3625, 50 iterations in 0.0471 sec
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
      <td>org.axonframework.test</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.026851</td>
      <td>0.722627</td>
      <td>7.623540</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>0.775430</td>
      <td>8.101244</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.017966</td>
      <td>1.063267</td>
      <td>7.570711</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012211</td>
      <td>2.041492</td>
      <td>7.223169</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.1</td>
      <td>0</td>
      <td>0.012709</td>
      <td>2.584258</td>
      <td>6.766050</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

