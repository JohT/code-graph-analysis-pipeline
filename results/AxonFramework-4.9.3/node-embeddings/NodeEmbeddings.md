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
      <td>org.axonframework.modelling.command</td>
      <td>command</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.155609</td>
      <td>[0.0, 0.0, 0.0, 0.0, 0.0, 0.4744147062301636, ...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[0.0, 0.0, 0.0, 0.0, 0.0, 0.44183439016342163,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.0, 0.0, 0.0, 0.0, 0.0, 0.48884743452072144,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[0.547947108745575, 0.0, -0.2763155996799469, ...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[0.6282529234886169, 0.0, -0.3879297971725464,...</td>
    </tr>
  </tbody>
</table>
</div>


### 1.2 Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

This step takes the original node embeddings with a higher dimensionality, e.g. 64 floating point numbers, and reduces them into a two dimensional array for visualization. For more details look up the function declaration for "prepare_node_embeddings_for_2d_visualization".

    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.038s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.605718
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 48.157574
    [t-SNE] KL divergence after 1000 iterations: 0.140873



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
      <td>-5.984459</td>
      <td>1.591714</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>-5.996661</td>
      <td>1.603274</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-6.018620</td>
      <td>1.613458</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>-0.568303</td>
      <td>-2.404437</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>-0.309986</td>
      <td>-2.472639</td>
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
      <td>org.axonframework.modelling.command</td>
      <td>command</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.155609</td>
      <td>[0.4330126941204071, 0.4330126941204071, 0.0, ...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[0.4330126941204071, 0.4330126941204071, 0.0, ...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.4330126941204071, 0.4330126941204071, 0.0, ...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[0.4330126941204071, -0.4330126941204071, -0.4...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[0.4330126941204071, -0.6495190411806107, -0.4...</td>
    </tr>
  </tbody>
</table>
</div>


    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.001s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 2.750054
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 48.837646
    [t-SNE] KL divergence after 1000 iterations: -0.065712



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
      <td>43.949684</td>
      <td>236.020798</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>43.949684</td>
      <td>236.020798</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>43.949684</td>
      <td>236.020798</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>67.926430</td>
      <td>142.122147</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>49.684147</td>
      <td>119.744423</td>
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
      <td>org.axonframework.modelling.command</td>
      <td>command</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.155609</td>
      <td>[1.0180115699768066, 0.9696140289306641, 0.604...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[0.9976913928985596, 0.9408471584320068, 0.633...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.9963914752006531, 0.9348244667053223, 0.605...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[-0.3185178339481354, 0.7194064259529114, 0.68...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[-0.3213884234428406, 0.6567391157150269, 0.51...</td>
    </tr>
  </tbody>
</table>
</div>


    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.002s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.683568
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 47.223454
    [t-SNE] KL divergence after 1000 iterations: 0.113261



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
      <td>-3.079287</td>
      <td>-1.341806</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>-3.082808</td>
      <td>-1.339177</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-3.080321</td>
      <td>-1.341932</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>1.643651</td>
      <td>5.185021</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>1.542703</td>
      <td>5.175893</td>
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

