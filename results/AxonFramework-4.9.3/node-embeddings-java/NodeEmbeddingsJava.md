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

    The scikit-learn version is 1.3.0.
    The pandas version is 1.5.1.


### Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

The following function takes the original node embeddings with a higher dimensionality, e.g. 64 floating point numbers, and reduces them into a two dimensional array for visualization. 

> It converts similarities between data points to joint probabilities and tries to minimize the Kullback-Leibler divergence between the joint probabilities of the low-dimensional embedding and the high-dimensional data.

(see https://scikit-learn.org/stable/modules/generated/sklearn.manifold.TSNE.html#sklearn.manifold.TSNE)





## 1. Java Packages

### 1.1 Generate Node Embeddings using Fast Random Projection (Fast RP) for Java Packages

[Fast Random Projection](https://neo4j.com/docs/graph-data-science/current/machine-learning/node-embeddings/fastrp) is used to reduce the dimensionality of the node feature space while preserving most of the distance information. Nodes with similar neighborhood result in node embedding with similar vectors.

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
      <td>[-0.2152683585882187, 0.0, 0.0, 0.0, -0.326492...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[-0.22790038585662842, 0.0, 0.0, 0.0, -0.38008...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.28117436170578003, 0.0, 0.0, 0.0, -0.39404...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[0.4041573405265808, -0.12932345271110535, 0.4...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[0.4111862778663635, -0.19701780378818512, 0.4...</td>
    </tr>
  </tbody>
</table>
</div>


### 1.2 Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

This step takes the original node embeddings with a higher dimensionality, e.g. 64 floating point numbers, and reduces them into a two dimensional array for visualization. For more details look up the function declaration for "prepare_node_embeddings_for_2d_visualization".

    t-SNE: Sample size (Number of nodes)=93
    t-SNE: perplexity=30.0
    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.037s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.574585
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 49.517479
    [t-SNE] KL divergence after 1000 iterations: 0.079684



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
      <td>-3.266079</td>
      <td>-4.222813</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>-3.262945</td>
      <td>-4.224000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-3.242641</td>
      <td>-4.216191</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>-4.742171</td>
      <td>-7.780855</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>-4.598917</td>
      <td>-8.042831</td>
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
      <td>[-0.4330126941204071, -0.21650634706020355, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[-0.4330126941204071, -0.21650634706020355, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.4330126941204071, -0.21650634706020355, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[0.0, -0.6495190411806107, 0.21650634706020355...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[0.0, -0.6495190411806107, 0.21650634706020355...</td>
    </tr>
  </tbody>
</table>
</div>


    t-SNE: Sample size (Number of nodes)=93
    t-SNE: perplexity=30.0
    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.001s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 2.905029
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 50.843010
    [t-SNE] KL divergence after 1000 iterations: 0.209599



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
      <td>-0.994492</td>
      <td>-9.025749</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>-0.994492</td>
      <td>-9.025749</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-1.239504</td>
      <td>-8.942394</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>-3.778385</td>
      <td>-5.326589</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>-3.778385</td>
      <td>-5.326589</td>
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
      <td>[0.04541820287704468, -0.07403725385665894, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[0.10988408327102661, -0.04785287752747536, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.0647360160946846, -0.041091881692409515, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[0.12291703373193741, 0.8706182241439819, 1.29...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[-0.08251871913671494, 0.8261094689369202, 1.3...</td>
    </tr>
  </tbody>
</table>
</div>


    t-SNE: Sample size (Number of nodes)=93
    t-SNE: perplexity=30.0
    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.002s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.664568
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 51.765137
    [t-SNE] KL divergence after 1000 iterations: 0.101871



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
      <td>0.187394</td>
      <td>3.082840</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>0.145544</td>
      <td>3.087847</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>0.106930</td>
      <td>3.039568</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>-2.579305</td>
      <td>-0.612422</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>-2.532568</td>
      <td>-0.378281</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

