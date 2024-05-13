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
- [Fast Random Projection](https://neo4j.com/docs/graph-data-science/current/machine-learning/node-embeddings/fastrp)
- [scikit-learn TSNE](https://scikit-learn.org/stable/modules/generated/sklearn.manifold.TSNE.html#sklearn.manifold.TSNE)
- [AttributeError: 'list' object has no attribute 'shape'](https://bobbyhadz.com/blog/python-attributeerror-list-object-has-no-attribute-shape)

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
      <td>org.axonframework.test</td>
      <td>test</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.080026</td>
      <td>[-0.22236235439777374, 0.24672456085681915, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.26334983110427856, 0.20723092555999756, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033857</td>
      <td>[-0.21329262852668762, 0.23033273220062256, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[-0.2046269029378891, 0.2115609496831894, 0.28...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017779</td>
      <td>[-0.12896481156349182, 0.18578116595745087, 0....</td>
    </tr>
  </tbody>
</table>
</div>


### 1.2 Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

This step takes the original node embeddings with a higher dimensionality, e.g. 64 floating point numbers, and reduces them into a two dimensional array for visualization. For more details look up the function declaration for "prepare_node_embeddings_for_2d_visualization".

    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.024s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.571124
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 48.945747
    [t-SNE] KL divergence after 800 iterations: 0.059866



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
      <td>0.080026</td>
      <td>9.369608</td>
      <td>2.336865</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>9.312291</td>
      <td>1.914303</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033857</td>
      <td>9.216743</td>
      <td>2.039072</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>9.453239</td>
      <td>1.966223</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017779</td>
      <td>9.136713</td>
      <td>2.282443</td>
    </tr>
  </tbody>
</table>
</div>


### 1.3 Visualization of the node embeddings reduced to two dimensions


    
![png](NodeEmbeddings_files/NodeEmbeddings_21_0.png)
    


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
      <td>0.080026</td>
      <td>[0.21650634706020355, -1.5155444294214249, 0.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.0, -1.2990380823612213, -0.2165063470602035...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033857</td>
      <td>[0.21650634706020355, -1.5155444294214249, 0.0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.4330126941204071, -1.5155444294214249, 0.21...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017779</td>
      <td>[0.21650634706020355, -1.2990380823612213, 0.4...</td>
    </tr>
  </tbody>
</table>
</div>


    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.001s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 2.707920
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 51.527191
    [t-SNE] KL divergence after 1000 iterations: 0.216329



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
      <td>0.080026</td>
      <td>8.474840</td>
      <td>-8.070415</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>9.172166</td>
      <td>-7.294824</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033857</td>
      <td>8.474840</td>
      <td>-8.070415</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>8.320222</td>
      <td>-7.203920</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017779</td>
      <td>9.125086</td>
      <td>-7.885941</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddings_files/NodeEmbeddings_23_5.png)
    


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
      <td>0.080026</td>
      <td>[0.704459011554718, 0.8241880536079407, 0.0868...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.7015915513038635, 0.8217386603355408, 0.018...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033857</td>
      <td>[0.6379087567329407, 0.7995917797088623, 0.013...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.8479170799255371, 0.9323347806930542, 0.125...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017779</td>
      <td>[0.6549021005630493, 0.7182769179344177, -0.02...</td>
    </tr>
  </tbody>
</table>
</div>


    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.002s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.696249
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 49.316971
    [t-SNE] KL divergence after 800 iterations: 0.138304



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
      <td>0.080026</td>
      <td>4.337696</td>
      <td>-1.266510</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>4.188378</td>
      <td>-1.502223</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.test.matchers</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.033857</td>
      <td>4.155691</td>
      <td>-1.499592</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.test.saga</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>4.393888</td>
      <td>-1.269987</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.test.utils</td>
      <td>axon-test-4.9.3</td>
      <td>0</td>
      <td>0.017779</td>
      <td>4.018260</td>
      <td>-1.167546</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddings_files/NodeEmbeddings_25_5.png)
    


## 2. Typescript Modules

### 2.1 Generate Node Embeddings for Typescript Modules using Fast Random Projection (Fast RP)

See section 1.1 for some background about node embeddings.

    No projected data for node embeddings calculation available


### 2.2 Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

See section 1.2 for some background about t-SNE.

    No projected data for node embeddings dimensionality reduction available


### 2.3 Plot the node embeddings reduced to two dimensions for Typescript

    No projected data to plot available


### 2.4 Node Embeddings for Typescript Modules using HashGNN

[HashGNN](https://neo4j.com/docs/graph-data-science/2.6/machine-learning/node-embeddings/hashgnn) resembles Graph Neural Networks (GNN) but does not include a model or require training. It combines ideas of GNNs and fast randomized algorithms. For more details see [HashGNN](https://neo4j.com/docs/graph-data-science/2.6/machine-learning/node-embeddings/hashgnn). Here, the latter 3 steps are combined into one for HashGNN.

    No projected data for node embeddings calculation available
    No projected data for node embeddings dimensionality reduction available
    No projected data to plot available


### 2.5 Node Embeddings for Typescript Modules using node2vec

    No projected data for node embeddings calculation available
    No projected data for node embeddings dimensionality reduction available
    No projected data to plot available

