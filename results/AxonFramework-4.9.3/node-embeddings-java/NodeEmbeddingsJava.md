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
      <td>org.axonframework.modelling.command</td>
      <td>command</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.155609</td>
      <td>[-0.2997018098831177, -0.1952381432056427, 0.2...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[-0.34666895866394043, -0.20513851940631866, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.3526989817619324, -0.24959245324134827, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[-0.11967099457979202, 0.2634722888469696, -0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[-0.12892881035804749, 0.3700981140136719, -0....</td>
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
       --> Time elapsed: 0.04 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=7.75 for 250 iterations...
    Iteration   50, KL divergence 0.5184, 50 iterations in 0.0356 sec
    Iteration  100, KL divergence 1.0080, 50 iterations in 0.0128 sec
    Iteration  150, KL divergence 1.0080, 50 iterations in 0.0123 sec
    Iteration  200, KL divergence 1.0080, 50 iterations in 0.0122 sec
    Iteration  250, KL divergence 1.0080, 50 iterations in 0.0123 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1071, 50 iterations in 0.0382 sec
    Iteration  100, KL divergence 0.0693, 50 iterations in 0.0518 sec
    Iteration  150, KL divergence 0.0627, 50 iterations in 0.0349 sec
    Iteration  200, KL divergence 0.0616, 50 iterations in 0.0344 sec
    Iteration  250, KL divergence 0.0617, 50 iterations in 0.0343 sec
    Iteration  300, KL divergence 0.0643, 50 iterations in 0.0365 sec
    Iteration  350, KL divergence 0.0645, 50 iterations in 0.0360 sec
    Iteration  400, KL divergence 0.0642, 50 iterations in 0.0349 sec
    Iteration  450, KL divergence 0.0655, 50 iterations in 0.0351 sec
    Iteration  500, KL divergence 0.0659, 50 iterations in 0.0343 sec
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
      <td>org.axonframework.modelling.command</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.155609</td>
      <td>7.784955</td>
      <td>-1.252583</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>7.786817</td>
      <td>-1.262462</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>7.812176</td>
      <td>-1.273545</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>7.896774</td>
      <td>2.144855</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>8.052854</td>
      <td>2.393195</td>
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
      <td>org.axonframework.modelling.command</td>
      <td>command</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.155609</td>
      <td>[-0.8660253882408142, 0.21650634706020355, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[-0.8660253882408142, 0.21650634706020355, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.8660253882408142, 0.21650634706020355, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[0.8660253882408142, -0.4330126941204071, -0.6...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[1.0825317353010178, -0.4330126941204071, -0.8...</td>
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
    Iteration   50, KL divergence -0.4280, 50 iterations in 0.0398 sec
    Iteration  100, KL divergence 1.0611, 50 iterations in 0.0130 sec
    Iteration  150, KL divergence 1.0611, 50 iterations in 0.0124 sec
    Iteration  200, KL divergence 1.0611, 50 iterations in 0.0123 sec
    Iteration  250, KL divergence 1.0611, 50 iterations in 0.0123 sec
       --> Time elapsed: 0.09 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.2600, 50 iterations in 0.0401 sec
    Iteration  100, KL divergence 0.2394, 50 iterations in 0.0480 sec
    Iteration  150, KL divergence 0.2330, 50 iterations in 0.0363 sec
    Iteration  200, KL divergence 0.2334, 50 iterations in 0.0356 sec
    Iteration  250, KL divergence 0.2389, 50 iterations in 0.0354 sec
    Iteration  300, KL divergence 0.2387, 50 iterations in 0.0357 sec
    Iteration  350, KL divergence 0.2387, 50 iterations in 0.0365 sec
    Iteration  400, KL divergence 0.2291, 50 iterations in 0.0365 sec
    Iteration  450, KL divergence 0.2238, 50 iterations in 0.0371 sec
    Iteration  500, KL divergence 0.2326, 50 iterations in 0.0365 sec
       --> Time elapsed: 0.38 seconds



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
      <td>org.axonframework.modelling.command</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.155609</td>
      <td>-3.731272</td>
      <td>-0.422812</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>-3.731272</td>
      <td>-0.422812</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-3.731505</td>
      <td>-0.420012</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>-4.254946</td>
      <td>-2.739341</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>-4.208859</td>
      <td>-2.463909</td>
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
      <td>org.axonframework.modelling.command</td>
      <td>command</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.155609</td>
      <td>[-0.3022383749485016, -2.1209213733673096, 0.9...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[-0.34468337893486023, -2.1290290355682373, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.2849268913269043, -2.042829990386963, 0.93...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[-0.23233601450920105, -0.749617338180542, 0.5...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[-0.1395985335111618, -0.8119386434555054, 0.5...</td>
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
    Iteration   50, KL divergence -0.2648, 50 iterations in 0.0322 sec
    Iteration  100, KL divergence 0.9723, 50 iterations in 0.0132 sec
    Iteration  150, KL divergence 0.9723, 50 iterations in 0.0126 sec
    Iteration  200, KL divergence 0.9723, 50 iterations in 0.0124 sec
    Iteration  250, KL divergence 0.9723, 50 iterations in 0.0124 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=93.00 for 500 iterations...
    Iteration   50, KL divergence 0.1788, 50 iterations in 0.0394 sec
    Iteration  100, KL divergence 0.1313, 50 iterations in 0.0503 sec
    Iteration  150, KL divergence 0.1304, 50 iterations in 0.0350 sec
    Iteration  200, KL divergence 0.1303, 50 iterations in 0.0359 sec
    Iteration  250, KL divergence 0.1303, 50 iterations in 0.0348 sec
    Iteration  300, KL divergence 0.1302, 50 iterations in 0.0345 sec
    Iteration  350, KL divergence 0.1305, 50 iterations in 0.0345 sec
    Iteration  400, KL divergence 0.1306, 50 iterations in 0.0344 sec
    Iteration  450, KL divergence 0.1306, 50 iterations in 0.0351 sec
    Iteration  500, KL divergence 0.1308, 50 iterations in 0.0351 sec
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
      <td>org.axonframework.modelling.command</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.155609</td>
      <td>-3.713257</td>
      <td>-4.333018</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>-3.710031</td>
      <td>-4.331603</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-3.709765</td>
      <td>-4.330778</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>-5.895465</td>
      <td>-3.425083</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>-5.826372</td>
      <td>-3.257305</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

