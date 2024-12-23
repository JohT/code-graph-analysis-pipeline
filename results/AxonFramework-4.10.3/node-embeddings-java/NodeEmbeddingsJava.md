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
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>[0.03663591295480728, -0.09719465672969818, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-0.04645860195159912, -0.12424516677856445, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>[0.04735727980732918, -0.06709689646959305, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>[-0.07168608903884888, -0.1437755525112152, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>[-0.007688108831644058, -0.06441152095794678, ...</td>
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
    Iteration   50, KL divergence -1.0257, 50 iterations in 0.0557 sec
    Iteration  100, KL divergence 1.2255, 50 iterations in 0.0159 sec
    Iteration  150, KL divergence 1.2255, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.2255, 50 iterations in 0.0147 sec
    Iteration  250, KL divergence 1.2255, 50 iterations in 0.0148 sec
       --> Time elapsed: 0.12 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.1885, 50 iterations in 0.0525 sec
    Iteration  100, KL divergence 0.1660, 50 iterations in 0.0464 sec
    Iteration  150, KL divergence 0.1630, 50 iterations in 0.0426 sec
    Iteration  200, KL divergence 0.1631, 50 iterations in 0.0435 sec
    Iteration  250, KL divergence 0.1628, 50 iterations in 0.0431 sec
    Iteration  300, KL divergence 0.1630, 50 iterations in 0.0438 sec
    Iteration  350, KL divergence 0.1629, 50 iterations in 0.0432 sec
    Iteration  400, KL divergence 0.1628, 50 iterations in 0.0426 sec
    Iteration  450, KL divergence 0.1630, 50 iterations in 0.0426 sec
    Iteration  500, KL divergence 0.1629, 50 iterations in 0.0431 sec
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
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>-1.305761</td>
      <td>3.066239</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>-1.780161</td>
      <td>3.859126</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>-1.824363</td>
      <td>3.729593</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>-2.062459</td>
      <td>4.195927</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>-1.407756</td>
      <td>3.368596</td>
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
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>[0.0, -0.6495190411806107, -2.5980761647224426...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[-0.4330126941204071, -0.6495190411806107, -1....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>[0.0, -1.7320507764816284, -1.948557123541832,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>[-0.8660253882408142, -0.21650634706020355, -1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>[-0.21650634706020355, -0.8660253882408142, -1...</td>
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
    Iteration   50, KL divergence -0.0664, 50 iterations in 0.0673 sec
    Iteration  100, KL divergence 1.2321, 50 iterations in 0.0177 sec
    Iteration  150, KL divergence 1.2321, 50 iterations in 0.0148 sec
    Iteration  200, KL divergence 1.2321, 50 iterations in 0.0146 sec
    Iteration  250, KL divergence 1.2321, 50 iterations in 0.0150 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.7047, 50 iterations in 0.0502 sec
    Iteration  100, KL divergence 0.6412, 50 iterations in 0.0480 sec
    Iteration  150, KL divergence 0.6381, 50 iterations in 0.0469 sec
    Iteration  200, KL divergence 0.6375, 50 iterations in 0.0463 sec
    Iteration  250, KL divergence 0.6374, 50 iterations in 0.0459 sec
    Iteration  300, KL divergence 0.6375, 50 iterations in 0.0668 sec
    Iteration  350, KL divergence 0.6377, 50 iterations in 0.0474 sec
    Iteration  400, KL divergence 0.6378, 50 iterations in 0.0465 sec
    Iteration  450, KL divergence 0.6378, 50 iterations in 0.0465 sec
    Iteration  500, KL divergence 0.6378, 50 iterations in 0.0466 sec
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
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>3.047736</td>
      <td>4.392483</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>6.929471</td>
      <td>-0.276557</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>7.199463</td>
      <td>2.275915</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>7.014437</td>
      <td>-0.407372</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>2.457522</td>
      <td>2.894640</td>
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
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>[0.7302666306495667, 0.17408642172813416, 0.15...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>[0.6894717216491699, 0.16326789557933807, -0.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>[0.4767880141735077, -0.04358401894569397, 0.0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>[0.3314017355442047, 0.12554903328418732, 0.18...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>[0.6303045749664307, 0.1991668939590454, 0.002...</td>
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
    Iteration   50, KL divergence -1.2735, 50 iterations in 0.0645 sec
    Iteration  100, KL divergence 1.1636, 50 iterations in 0.0174 sec
    Iteration  150, KL divergence 1.1636, 50 iterations in 0.0150 sec
    Iteration  200, KL divergence 1.1636, 50 iterations in 0.0150 sec
    Iteration  250, KL divergence 1.1636, 50 iterations in 0.0150 sec
       --> Time elapsed: 0.13 seconds
    ===> Running optimization with exaggeration=1.00, lr=114.00 for 500 iterations...
    Iteration   50, KL divergence 0.3484, 50 iterations in 0.0529 sec
    Iteration  100, KL divergence 0.3100, 50 iterations in 0.0497 sec
    Iteration  150, KL divergence 0.2982, 50 iterations in 0.0477 sec
    Iteration  200, KL divergence 0.2894, 50 iterations in 0.0473 sec
    Iteration  250, KL divergence 0.2870, 50 iterations in 0.0439 sec
    Iteration  300, KL divergence 0.2868, 50 iterations in 0.0438 sec
    Iteration  350, KL divergence 0.2868, 50 iterations in 0.0443 sec
    Iteration  400, KL divergence 0.2863, 50 iterations in 0.0438 sec
    Iteration  450, KL divergence 0.2863, 50 iterations in 0.0492 sec
    Iteration  500, KL divergence 0.2864, 50 iterations in 0.0460 sec
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
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.073179</td>
      <td>4.587495</td>
      <td>1.456588</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.015708</td>
      <td>5.787610</td>
      <td>1.582286</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.023111</td>
      <td>6.053534</td>
      <td>3.695899</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013919</td>
      <td>6.066437</td>
      <td>3.737910</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>axon-messaging-4.10.3</td>
      <td>0</td>
      <td>0.013360</td>
      <td>5.520313</td>
      <td>1.505125</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

