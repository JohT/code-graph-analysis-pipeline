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

    t-SNE: Sample size (Number of nodes)=93
    t-SNE: perplexity=30.0
    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.082s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.655771
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 48.126137
    [t-SNE] KL divergence after 800 iterations: 0.050790



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
      <td>-0.188775</td>
      <td>-4.077829</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>-0.187209</td>
      <td>-4.069431</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-0.216587</td>
      <td>-4.061156</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>4.956002</td>
      <td>-6.678513</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>5.414717</td>
      <td>-6.707891</td>
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
      <td>[0.8660253882408142, -0.4330126941204071, -0.6...</td>
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
    [t-SNE] Mean sigma: 2.844971
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 47.890877
    [t-SNE] KL divergence after 1000 iterations: 0.095945



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
      <td>55.115955</td>
      <td>-10.507041</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>55.115955</td>
      <td>-10.507041</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>55.115955</td>
      <td>-10.507041</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>55.845608</td>
      <td>-34.690697</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>55.845608</td>
      <td>-34.690697</td>
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
      <td>[0.09866541624069214, -2.0777676105499268, 1.5...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>[0.13471074402332306, -2.0186145305633545, 1.6...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>[0.077057845890522, -1.932939052581787, 1.5184...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>[0.186208114027977, -0.8858957886695862, 0.633...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>[0.05101150646805763, -0.9541137218475342, 0.4...</td>
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
    [t-SNE] Mean sigma: 0.647886
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 50.072601
    [t-SNE] KL divergence after 900 iterations: 0.131736



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
      <td>1.841828</td>
      <td>3.176171</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.152740</td>
      <td>1.830896</td>
      <td>3.161993</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.3</td>
      <td>0</td>
      <td>0.016234</td>
      <td>1.834886</td>
      <td>3.152582</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.349429</td>
      <td>-2.549339</td>
      <td>2.266320</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>axon-modelling-4.9.3</td>
      <td>1</td>
      <td>0.315690</td>
      <td>-2.399351</td>
      <td>2.300525</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsJava_files/NodeEmbeddingsJava_25_5.png)
    

