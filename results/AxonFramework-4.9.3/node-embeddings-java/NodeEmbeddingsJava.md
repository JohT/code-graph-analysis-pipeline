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
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>[-0.22466301918029785, 0.25969457626342773, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.26439180970191956, 0.21783214807510376, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[-0.21339406073093414, 0.24127791821956635, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.21123544871807098, 0.22235634922981262, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[-0.140242338180542, 0.19431671500205994, 0.28...</td>
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
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -0.4303, 50 iterations in 0.0333 sec
    Iteration  100, KL divergence 1.0113, 50 iterations in 0.0132 sec
    Iteration  150, KL divergence 1.0113, 50 iterations in 0.0125 sec
    Iteration  200, KL divergence 1.0113, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 1.0113, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1036, 50 iterations in 0.0373 sec
    Iteration  100, KL divergence 0.0650, 50 iterations in 0.0503 sec
    Iteration  150, KL divergence 0.0588, 50 iterations in 0.0328 sec
    Iteration  200, KL divergence 0.0580, 50 iterations in 0.0332 sec
    Iteration  250, KL divergence 0.0581, 50 iterations in 0.0351 sec
    Iteration  300, KL divergence 0.0581, 50 iterations in 0.0353 sec
    Iteration  350, KL divergence 0.0615, 50 iterations in 0.0345 sec
    Iteration  400, KL divergence 0.0615, 50 iterations in 0.0357 sec
    Iteration  450, KL divergence 0.0621, 50 iterations in 0.0344 sec
    Iteration  500, KL divergence 0.0612, 50 iterations in 0.0347 sec
       --> Time elapsed: 0.36 seconds



    (93, 2)



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
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>-0.413123</td>
      <td>-5.996298</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-0.545882</td>
      <td>-5.932424</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>-0.545739</td>
      <td>-5.969125</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-0.554232</td>
      <td>-6.105228</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>-0.691041</td>
      <td>-6.054960</td>
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
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.0,...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.21650634706020355, -1.2990380823612213, 0.2...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
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
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -1.1596, 50 iterations in 0.0383 sec
    Iteration  100, KL divergence 1.0715, 50 iterations in 0.0132 sec
    Iteration  150, KL divergence 1.0715, 50 iterations in 0.0126 sec
    Iteration  200, KL divergence 1.0715, 50 iterations in 0.0126 sec
    Iteration  250, KL divergence 1.0715, 50 iterations in 0.0125 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1767, 50 iterations in 0.0377 sec
    Iteration  100, KL divergence 0.1952, 50 iterations in 0.0508 sec
    Iteration  150, KL divergence 0.3214, 50 iterations in 0.0389 sec
    Iteration  200, KL divergence 0.3675, 50 iterations in 0.0397 sec
    Iteration  250, KL divergence 0.3672, 50 iterations in 0.0384 sec
    Iteration  300, KL divergence 0.3730, 50 iterations in 0.0374 sec
    Iteration  350, KL divergence 0.3659, 50 iterations in 0.0374 sec
    Iteration  400, KL divergence 0.3561, 50 iterations in 0.0390 sec
    Iteration  450, KL divergence 0.3509, 50 iterations in 0.0394 sec
    Iteration  500, KL divergence 0.3516, 50 iterations in 0.0383 sec
       --> Time elapsed: 0.40 seconds



    (93, 2)



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
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>-43.776660</td>
      <td>64.802696</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-46.762355</td>
      <td>57.313588</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>-51.911134</td>
      <td>63.597129</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-60.697332</td>
      <td>62.271878</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>-55.174689</td>
      <td>56.996377</td>
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
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>[1.5569006204605103, -0.22088493406772614, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[1.63756263256073, -0.22879859805107117, -0.36...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[1.6839793920516968, -0.2379874587059021, -0.3...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[1.551556944847107, -0.23808932304382324, -0.3...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[1.5061479806900024, -0.1964915245771408, -0.2...</td>
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
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence 0.2763, 50 iterations in 0.0321 sec
    Iteration  100, KL divergence 0.9803, 50 iterations in 0.0130 sec
    Iteration  150, KL divergence 0.9803, 50 iterations in 0.0126 sec
    Iteration  200, KL divergence 0.9803, 50 iterations in 0.0126 sec
    Iteration  250, KL divergence 0.9803, 50 iterations in 0.0335 sec
       --> Time elapsed: 0.10 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1838, 50 iterations in 0.0521 sec
    Iteration  100, KL divergence 0.1327, 50 iterations in 0.0461 sec
    Iteration  150, KL divergence 0.1308, 50 iterations in 0.0370 sec
    Iteration  200, KL divergence 0.1308, 50 iterations in 0.0368 sec
    Iteration  250, KL divergence 0.1309, 50 iterations in 0.0368 sec
    Iteration  300, KL divergence 0.1310, 50 iterations in 0.0370 sec
    Iteration  350, KL divergence 0.1310, 50 iterations in 0.0371 sec
    Iteration  400, KL divergence 0.1310, 50 iterations in 0.0376 sec
    Iteration  450, KL divergence 0.1310, 50 iterations in 0.0380 sec
    Iteration  500, KL divergence 0.1309, 50 iterations in 0.0376 sec
       --> Time elapsed: 0.40 seconds



    (93, 2)



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
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.081762</td>
      <td>0.745011</td>
      <td>6.754719</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>0.660447</td>
      <td>6.928363</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033417</td>
      <td>0.662582</td>
      <td>6.922226</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016509</td>
      <td>0.887389</td>
      <td>6.933420</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017834</td>
      <td>0.860154</td>
      <td>6.768646</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

