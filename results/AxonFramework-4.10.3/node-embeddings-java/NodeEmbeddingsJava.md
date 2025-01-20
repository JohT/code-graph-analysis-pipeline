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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>[-0.21103507280349731, -0.18831247091293335, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>[-0.25916367769241333, -0.12870511412620544, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.2757379710674286, -0.25459837913513184, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.24588952958583832, -0.25064313411712646, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.2661723494529724, -0.25586026906967163, -0...</td>
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
    Iteration   50, KL divergence -0.8936, 50 iterations in 0.0565 sec
    Iteration  100, KL divergence 1.2041, 50 iterations in 0.0155 sec
    Iteration  150, KL divergence 1.2041, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.2041, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2041, 50 iterations in 0.0145 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1944, 50 iterations in 0.0511 sec
    Iteration  100, KL divergence 0.1720, 50 iterations in 0.0490 sec
    Iteration  150, KL divergence 0.1644, 50 iterations in 0.0462 sec
    Iteration  200, KL divergence 0.1641, 50 iterations in 0.0459 sec
    Iteration  250, KL divergence 0.1644, 50 iterations in 0.0460 sec
    Iteration  300, KL divergence 0.1644, 50 iterations in 0.0472 sec
    Iteration  350, KL divergence 0.1641, 50 iterations in 0.0477 sec
    Iteration  400, KL divergence 0.1643, 50 iterations in 0.0469 sec
    Iteration  450, KL divergence 0.1643, 50 iterations in 0.0465 sec
    Iteration  500, KL divergence 0.1643, 50 iterations in 0.0466 sec
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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>3.845333</td>
      <td>4.493561</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>3.911221</td>
      <td>5.574625</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>4.628319</td>
      <td>5.283987</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>4.982841</td>
      <td>5.014225</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>4.935108</td>
      <td>5.148738</td>
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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>[0.8660253882408142, -0.6495190411806107, 0.0,...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>[0.0, 0.0, -0.6495190411806107, 0.433012694120...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[-0.8660253882408142, -1.5155444294214249, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-1.0825317353010178, -0.21650634706020355, -1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[-0.4330126941204071, 0.0, -0.4330126941204071...</td>
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
    Iteration   50, KL divergence -0.4662, 50 iterations in 0.0623 sec
    Iteration  100, KL divergence 1.2259, 50 iterations in 0.0165 sec
    Iteration  150, KL divergence 1.2259, 50 iterations in 0.0143 sec
    Iteration  200, KL divergence 1.2259, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2259, 50 iterations in 0.0147 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.6139, 50 iterations in 0.0534 sec
    Iteration  100, KL divergence 0.5883, 50 iterations in 0.0517 sec
    Iteration  150, KL divergence 0.5726, 50 iterations in 0.0491 sec
    Iteration  200, KL divergence 0.5669, 50 iterations in 0.0460 sec
    Iteration  250, KL divergence 0.5668, 50 iterations in 0.0459 sec
    Iteration  300, KL divergence 0.5666, 50 iterations in 0.0456 sec
    Iteration  350, KL divergence 0.5667, 50 iterations in 0.0467 sec
    Iteration  400, KL divergence 0.5669, 50 iterations in 0.0464 sec
    Iteration  450, KL divergence 0.5664, 50 iterations in 0.0459 sec
    Iteration  500, KL divergence 0.5666, 50 iterations in 0.0460 sec
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
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>0.298444</td>
      <td>8.272108</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>0.875031</td>
      <td>6.000820</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>0.183674</td>
      <td>6.235903</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>0.967826</td>
      <td>7.248448</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>0.881524</td>
      <td>7.332090</td>
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
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>[0.08706338703632355, -0.507854700088501, -0.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>[0.09605108946561813, -0.46312230825424194, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>[0.17445127665996552, -0.3908997178077698, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>source</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.013896928168833256, -0.45843368768692017, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>checker</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>[0.14929407835006714, -0.41531631350517273, -0...</td>
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
    Iteration   50, KL divergence -0.4631, 50 iterations in 0.0502 sec
    Iteration  100, KL divergence 1.1584, 50 iterations in 0.0165 sec
    Iteration  150, KL divergence 1.1584, 50 iterations in 0.0147 sec
    Iteration  200, KL divergence 1.1584, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.1584, 50 iterations in 0.0146 sec
       --> Time elapsed: 0.11 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3928, 50 iterations in 0.0539 sec
    Iteration  100, KL divergence 0.3683, 50 iterations in 0.0531 sec
    Iteration  150, KL divergence 0.3631, 50 iterations in 0.0486 sec
    Iteration  200, KL divergence 0.3628, 50 iterations in 0.0489 sec
    Iteration  250, KL divergence 0.3627, 50 iterations in 0.0486 sec
    Iteration  300, KL divergence 0.3628, 50 iterations in 0.0488 sec
    Iteration  350, KL divergence 0.3628, 50 iterations in 0.0499 sec
    Iteration  400, KL divergence 0.3630, 50 iterations in 0.0500 sec
    Iteration  450, KL divergence 0.3628, 50 iterations in 0.0492 sec
    Iteration  500, KL divergence 0.3630, 50 iterations in 0.0494 sec
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
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.090489</td>
      <td>4.223713</td>
      <td>0.423423</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.023322</td>
      <td>4.995405</td>
      <td>2.008515</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.axonserver.connector.heartbeat</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.014287</td>
      <td>5.146849</td>
      <td>0.576746</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>2.696713</td>
      <td>-0.521818</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.axonserver.connector.heartbe...</td>
      <td>axon-server-connector-4.10.3</td>
      <td>0</td>
      <td>0.012211</td>
      <td>3.892968</td>
      <td>1.306622</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

