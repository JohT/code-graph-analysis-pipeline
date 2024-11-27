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
      <td>org.axonframework.axonserver.connector</td>
      <td>connector</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>[-0.2603548765182495, -0.07574361562728882, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[-0.33090752363204956, -0.2527211010456085, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.30420365929603577, -0.17181679606437683, 0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.30354517698287964, -0.12501321732997894, 0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.32682645320892334, -0.1168103963136673, 0....</td>
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
    Iteration   50, KL divergence 0.1206, 50 iterations in 0.0570 sec
    Iteration  100, KL divergence 1.2243, 50 iterations in 0.0159 sec
    Iteration  150, KL divergence 1.2243, 50 iterations in 0.0145 sec
    Iteration  200, KL divergence 1.2243, 50 iterations in 0.0144 sec
    Iteration  250, KL divergence 1.2243, 50 iterations in 0.0144 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1848, 50 iterations in 0.0494 sec
    Iteration  100, KL divergence 0.1685, 50 iterations in 0.0459 sec
    Iteration  150, KL divergence 0.1626, 50 iterations in 0.0414 sec
    Iteration  200, KL divergence 0.1623, 50 iterations in 0.0409 sec
    Iteration  250, KL divergence 0.1623, 50 iterations in 0.0405 sec
    Iteration  300, KL divergence 0.1622, 50 iterations in 0.0415 sec
    Iteration  350, KL divergence 0.1615, 50 iterations in 0.0419 sec
    Iteration  400, KL divergence 0.1615, 50 iterations in 0.0422 sec
    Iteration  450, KL divergence 0.1617, 50 iterations in 0.0419 sec
    Iteration  500, KL divergence 0.1618, 50 iterations in 0.0423 sec
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
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>5.046729</td>
      <td>-3.882883</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>5.396283</td>
      <td>-5.138288</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>5.977518</td>
      <td>-4.681129</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.220865</td>
      <td>-4.286063</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.215912</td>
      <td>-4.489396</td>
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
      <td>org.axonframework.axonserver.connector</td>
      <td>connector</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>[0.0, 0.4330126941204071, 0.0, -0.433012694120...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[-0.4330126941204071, -0.6495190411806107, 0.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[1.2990380823612213, -0.4330126941204071, -0.4...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.21650634706020355, -0.21650634706020355, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.0, -0.21650634706020355, -0.216506347060203...</td>
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
    Iteration   50, KL divergence -0.4791, 50 iterations in 0.0871 sec
    Iteration  100, KL divergence -2.4263, 50 iterations in 0.0186 sec
    Iteration  150, KL divergence -2.8332, 50 iterations in 0.0161 sec
    Iteration  200, KL divergence 1.2142, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2142, 50 iterations in 0.0143 sec
       --> Time elapsed: 0.15 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6125, 50 iterations in 0.0447 sec
    Iteration  100, KL divergence 0.6080, 50 iterations in 0.0492 sec
    Iteration  150, KL divergence 0.6066, 50 iterations in 0.0480 sec
    Iteration  200, KL divergence 0.6066, 50 iterations in 0.0461 sec
    Iteration  250, KL divergence 0.6031, 50 iterations in 0.0450 sec
    Iteration  300, KL divergence 0.6003, 50 iterations in 0.0461 sec
    Iteration  350, KL divergence 0.5990, 50 iterations in 0.0458 sec
    Iteration  400, KL divergence 0.5993, 50 iterations in 0.0448 sec
    Iteration  450, KL divergence 0.5986, 50 iterations in 0.0452 sec
    Iteration  500, KL divergence 0.5987, 50 iterations in 0.0450 sec
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
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>-4.212043</td>
      <td>-1.520007</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>-2.249056</td>
      <td>3.864859</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>7.196457</td>
      <td>3.547838</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.608837</td>
      <td>4.463230</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>6.604395</td>
      <td>4.429149</td>
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
      <td>org.axonframework.axonserver.connector</td>
      <td>connector</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>[0.03222084790468216, 0.4568326473236084, 0.24...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>[0.018220767378807068, 0.28162190318107605, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[0.27966606616973877, 0.4769960045814514, 0.28...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.21488827466964722, 0.3287939131259918, 0.0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.0037822648882865906, 0.5424395799636841, 0....</td>
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
    Iteration   50, KL divergence -0.3323, 50 iterations in 0.0649 sec
    Iteration  100, KL divergence 1.1618, 50 iterations in 0.0167 sec
    Iteration  150, KL divergence 1.1618, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.1618, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.1618, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3370, 50 iterations in 0.0523 sec
    Iteration  100, KL divergence 0.3305, 50 iterations in 0.0465 sec
    Iteration  150, KL divergence 0.3309, 50 iterations in 0.0458 sec
    Iteration  200, KL divergence 0.3308, 50 iterations in 0.0450 sec
    Iteration  250, KL divergence 0.3314, 50 iterations in 0.0453 sec
    Iteration  300, KL divergence 0.3308, 50 iterations in 0.0461 sec
    Iteration  350, KL divergence 0.3305, 50 iterations in 0.0463 sec
    Iteration  400, KL divergence 0.3308, 50 iterations in 0.0460 sec
    Iteration  450, KL divergence 0.3307, 50 iterations in 0.0523 sec
    Iteration  500, KL divergence 0.3308, 50 iterations in 0.0449 sec
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
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.090491</td>
      <td>-0.896976</td>
      <td>-4.123030</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.023323</td>
      <td>-2.583214</td>
      <td>-5.619475</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.014287</td>
      <td>-1.115348</td>
      <td>-5.120780</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-1.246596</td>
      <td>-1.382827</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.2</td>
      <td>0</td>
      <td>0.012211</td>
      <td>-1.360960</td>
      <td>-4.706995</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

