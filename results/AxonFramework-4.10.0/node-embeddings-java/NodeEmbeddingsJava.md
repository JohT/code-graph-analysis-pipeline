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
      <td>0.081762</td>
      <td>[-0.23907749354839325, 0.25115057826042175, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.25671643018722534, 0.22634342312812805, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[-0.23002834618091583, 0.2406129688024521, 0.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[-0.2189161479473114, 0.23353014886379242, 0.2...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
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
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence -1.7483, 50 iterations in 0.0357 sec
    Iteration  100, KL divergence 0.9998, 50 iterations in 0.0129 sec
    Iteration  150, KL divergence 0.9998, 50 iterations in 0.0123 sec
    Iteration  200, KL divergence 0.9998, 50 iterations in 0.0123 sec
    Iteration  250, KL divergence 0.9998, 50 iterations in 0.0122 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1160, 50 iterations in 0.0390 sec
    Iteration  100, KL divergence 0.0791, 50 iterations in 0.0511 sec
    Iteration  150, KL divergence 0.0763, 50 iterations in 0.0355 sec
    Iteration  200, KL divergence 0.0749, 50 iterations in 0.0350 sec
    Iteration  250, KL divergence 0.0745, 50 iterations in 0.0343 sec
    Iteration  300, KL divergence 0.0725, 50 iterations in 0.0335 sec
    Iteration  350, KL divergence 0.0663, 50 iterations in 0.0320 sec
    Iteration  400, KL divergence 0.0627, 50 iterations in 0.0316 sec
    Iteration  450, KL divergence 0.0770, 50 iterations in 0.0315 sec
    Iteration  500, KL divergence 0.0768, 50 iterations in 0.0308 sec
       --> Time elapsed: 0.35 seconds



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
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.081762</td>
      <td>-5.273931</td>
      <td>4.074607</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-5.188345</td>
      <td>4.028302</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>-5.166245</td>
      <td>4.065271</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-5.279439</td>
      <td>4.084512</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>-5.018927</td>
      <td>4.253155</td>
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
      <td>0.081762</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.21650634706020355, -1.2990380823612213, 0.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[0.21650634706020355, -1.2990380823612213, 0.4...</td>
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
    Iteration   50, KL divergence -0.7368, 50 iterations in 0.0395 sec
    Iteration  100, KL divergence 0.6440, 50 iterations in 0.0337 sec
    Iteration  150, KL divergence 0.6827, 50 iterations in 0.0363 sec
    Iteration  200, KL divergence 0.6559, 50 iterations in 0.0357 sec
    Iteration  250, KL divergence 0.7192, 50 iterations in 0.0340 sec
       --> Time elapsed: 0.18 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.2753, 50 iterations in 0.0340 sec
    Iteration  100, KL divergence 0.2573, 50 iterations in 0.0332 sec
    Iteration  150, KL divergence 0.2448, 50 iterations in 0.0332 sec
    Iteration  200, KL divergence 0.2441, 50 iterations in 0.0340 sec
    Iteration  250, KL divergence 0.2374, 50 iterations in 0.0349 sec
    Iteration  300, KL divergence 0.2354, 50 iterations in 0.0362 sec
    Iteration  350, KL divergence 0.2384, 50 iterations in 0.0337 sec
    Iteration  400, KL divergence 0.2435, 50 iterations in 0.0340 sec
    Iteration  450, KL divergence 0.2438, 50 iterations in 0.0323 sec
    Iteration  500, KL divergence 0.2487, 50 iterations in 0.0314 sec
       --> Time elapsed: 0.34 seconds



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
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.081762</td>
      <td>-8.019059</td>
      <td>-1.028987</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-7.520718</td>
      <td>-1.237300</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>-8.019428</td>
      <td>-1.399467</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-8.020287</td>
      <td>-1.368537</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>-7.782899</td>
      <td>-1.356085</td>
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
      <td>0.081762</td>
      <td>[0.4730452597141266, 0.9239861369132996, 0.474...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.5250142216682434, 0.8661072254180908, 0.445...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>[0.46355095505714417, 0.8566349148750305, 0.45...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>[0.48215189576148987, 0.9036257863044739, 0.46...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>[0.4958169162273407, 0.8257923126220703, 0.499...</td>
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
    Iteration   50, KL divergence -1.1362, 50 iterations in 0.0322 sec
    Iteration  100, KL divergence 0.9820, 50 iterations in 0.0141 sec
    Iteration  150, KL divergence 0.9820, 50 iterations in 0.0121 sec
    Iteration  200, KL divergence 0.9820, 50 iterations in 0.0119 sec
    Iteration  250, KL divergence 0.9820, 50 iterations in 0.0118 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1688, 50 iterations in 0.0385 sec
    Iteration  100, KL divergence 0.1279, 50 iterations in 0.0487 sec
    Iteration  150, KL divergence 0.1266, 50 iterations in 0.0370 sec
    Iteration  200, KL divergence 0.1261, 50 iterations in 0.0338 sec
    Iteration  250, KL divergence 0.1261, 50 iterations in 0.0346 sec
    Iteration  300, KL divergence 0.1261, 50 iterations in 0.0355 sec
    Iteration  350, KL divergence 0.1263, 50 iterations in 0.0364 sec
    Iteration  400, KL divergence 0.1264, 50 iterations in 0.0369 sec
    Iteration  450, KL divergence 0.1267, 50 iterations in 0.0368 sec
    Iteration  500, KL divergence 0.1268, 50 iterations in 0.0353 sec
       --> Time elapsed: 0.37 seconds



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
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.081762</td>
      <td>-6.581324</td>
      <td>-3.466957</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-6.383842</td>
      <td>-3.538888</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.033417</td>
      <td>-6.434435</td>
      <td>-3.548786</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.016509</td>
      <td>-6.522747</td>
      <td>-3.469564</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.10.0</td>
      <td>0</td>
      <td>0.017834</td>
      <td>-6.456095</td>
      <td>-3.259839</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

