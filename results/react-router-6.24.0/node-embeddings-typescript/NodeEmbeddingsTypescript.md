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
    The pandas version is 1.5.1.


### Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

The following function takes the original node embeddings with a higher dimensionality, e.g. 64 floating point numbers, and reduces them into a two dimensional array for visualization. 

> It converts similarities between data points to joint probabilities and tries to minimize the Kullback-Leibler divergence between the joint probabilities of the low-dimensional embedding and the high-dimensional data.

(see https://opentsne.readthedocs.io)





## 1. Typescript Modules

### 1.1 Generate Node Embeddings for Typescript Modules using Fast Random Projection (Fast RP)

[Fast Random Projection](https://neo4j.com/docs/graph-data-science/current/machine-learning/node-embeddings/fastrp) is used to reduce the dimensionality of the node feature space while preserving most of the distance information. Nodes with similar neighborhood result in node embedding with similar vectors.

**👉 Hint:** To skip existing node embeddings and always calculate them based on the parameters below edit `Node_Embeddings_0a_Query_Calculated` so that it won't return any results.

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
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>react-router</td>
      <td>0</td>
      <td>0.507805</td>
      <td>[-0.37168076634407043, -0.33165255188941956, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.221261</td>
      <td>[-0.4033167362213135, -0.3276975154876709, 0.4...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.190845</td>
      <td>[-0.37127387523651123, -0.2766003906726837, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.190845</td>
      <td>[-0.452966570854187, -0.38334864377975464, 0.4...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>router</td>
      <td>1</td>
      <td>0.787613</td>
      <td>[-0.3997058868408203, -0.38092681765556335, 0....</td>
    </tr>
  </tbody>
</table>
</div>


### 1.2 Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

This step takes the original node embeddings with a higher dimensionality, e.g. 64 floating point numbers, and reduces them into a two dimensional array for visualization. For more details look up the function declaration for "prepare_node_embeddings_for_2d_visualization".

    Perplexity value 30 is too high. Using perplexity 1.33 instead


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 4 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.02 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.42 for 250 iterations...
    Iteration   50, KL divergence 0.9125, 50 iterations in 0.0069 sec
    Iteration  100, KL divergence 0.1140, 50 iterations in 0.0063 sec
    Iteration  150, KL divergence 1.1356, 50 iterations in 0.0060 sec
    Iteration  200, KL divergence 1.1356, 50 iterations in 0.0060 sec
    Iteration  250, KL divergence 1.1356, 50 iterations in 0.0060 sec
       --> Time elapsed: 0.03 seconds
    ===> Running optimization with exaggeration=1.00, lr=5.00 for 500 iterations...
    Iteration   50, KL divergence 0.1031, 50 iterations in 0.0064 sec
    Iteration  100, KL divergence 0.1027, 50 iterations in 0.0065 sec
    Iteration  150, KL divergence 0.1022, 50 iterations in 0.0064 sec
    Iteration  200, KL divergence 0.1018, 50 iterations in 0.0064 sec
    Iteration  250, KL divergence 0.1016, 50 iterations in 0.0063 sec
    Iteration  300, KL divergence 0.1016, 50 iterations in 0.0063 sec
    Iteration  350, KL divergence 0.1015, 50 iterations in 0.0064 sec
    Iteration  400, KL divergence 0.1015, 50 iterations in 0.0064 sec
    Iteration  450, KL divergence 0.1015, 50 iterations in 0.0063 sec
    Iteration  500, KL divergence 0.1015, 50 iterations in 0.0064 sec
       --> Time elapsed: 0.06 seconds



    (5, 2)



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
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>0</td>
      <td>0.507805</td>
      <td>-2.173134</td>
      <td>0.014156</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.221261</td>
      <td>8.133508</td>
      <td>-0.052694</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.190845</td>
      <td>11.673398</td>
      <td>-0.075813</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.190845</td>
      <td>-11.480069</td>
      <td>0.074414</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>1</td>
      <td>0.787613</td>
      <td>-6.153703</td>
      <td>0.039937</td>
    </tr>
  </tbody>
</table>
</div>


### 1.3 Plot the node embeddings reduced to two dimensions for Typescript


    
![png](NodeEmbeddingsTypescript_files/NodeEmbeddingsTypescript_21_0.png)
    


### 1.4 Node Embeddings for Typescript Modules using HashGNN

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
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>react-router</td>
      <td>0</td>
      <td>0.507805</td>
      <td>[0.9185586869716644, 0.3061862289905548, 1.530...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.221261</td>
      <td>[0.9185586869716644, 0.0, 1.530931144952774, -...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.190845</td>
      <td>[0.9185586869716644, 0.3061862289905548, 1.530...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.190845</td>
      <td>[0.9185586869716644, 0.0, 1.530931144952774, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>router</td>
      <td>1</td>
      <td>0.787613</td>
      <td>[0.9185586869716644, 0.0, 1.530931144952774, -...</td>
    </tr>
  </tbody>
</table>
</div>


    Perplexity value 30 is too high. Using perplexity 1.33 instead


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 4 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.01 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.42 for 250 iterations...
    Iteration   50, KL divergence 0.1979, 50 iterations in 0.0107 sec
    Iteration  100, KL divergence 0.2871, 50 iterations in 0.0190 sec
    Iteration  150, KL divergence 0.2831, 50 iterations in 0.0122 sec
    Iteration  200, KL divergence 0.2885, 50 iterations in 0.0179 sec
    Iteration  250, KL divergence 0.2847, 50 iterations in 0.0157 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=5.00 for 500 iterations...
    Iteration   50, KL divergence 0.0006, 50 iterations in 0.0070 sec
    Iteration  100, KL divergence 0.0000, 50 iterations in 0.0070 sec
    Iteration  150, KL divergence 0.0000, 50 iterations in 0.0070 sec
    Iteration  200, KL divergence 0.0000, 50 iterations in 0.0070 sec
    Iteration  250, KL divergence 0.0000, 50 iterations in 0.0069 sec
    Iteration  300, KL divergence 0.0000, 50 iterations in 0.0071 sec
    Iteration  350, KL divergence 0.0000, 50 iterations in 0.0070 sec
    Iteration  400, KL divergence 0.0000, 50 iterations in 0.0071 sec
    Iteration  450, KL divergence 0.0000, 50 iterations in 0.0070 sec
    Iteration  500, KL divergence 0.0000, 50 iterations in 0.0069 sec
       --> Time elapsed: 0.07 seconds



    (5, 2)



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
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>0</td>
      <td>0.507805</td>
      <td>5.846425</td>
      <td>0.249226</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.221261</td>
      <td>-3.708924</td>
      <td>-0.674430</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.190845</td>
      <td>5.846416</td>
      <td>0.249022</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.190845</td>
      <td>-3.552198</td>
      <td>0.251623</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>1</td>
      <td>0.787613</td>
      <td>-4.431718</td>
      <td>-0.075441</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsTypescript_files/NodeEmbeddingsTypescript_23_6.png)
    


### 1.5 Node Embeddings for Typescript Modules using node2vec

[node2vec](https://neo4j.com/docs/graph-data-science/current/machine-learning/node-embeddings/node2vec) computes a vector representation of a node based on second order random walks in the graph. 
The [node2vec](https://towardsdatascience.com/complete-guide-to-understanding-node2vec-algorithm-4e9a35e5d147) algorithm is a transductive node embedding algorithm, meaning that it needs the whole graph to be available to learn the node embeddings.

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
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>react-router</td>
      <td>0</td>
      <td>0.507805</td>
      <td>[0.02140948176383972, 0.20995435118675232, 0.1...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.221261</td>
      <td>[0.02285935916006565, 0.20625843107700348, 0.1...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.190845</td>
      <td>[0.020562628284096718, 0.20823869109153748, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.190845</td>
      <td>[0.020888203755021095, 0.19285006821155548, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>router</td>
      <td>1</td>
      <td>0.787613</td>
      <td>[0.019077815115451813, 0.20519119501113892, 0....</td>
    </tr>
  </tbody>
</table>
</div>


    Perplexity value 30 is too high. Using perplexity 1.33 instead


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 4 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.01 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.42 for 250 iterations...
    Iteration   50, KL divergence 0.6436, 50 iterations in 0.0116 sec
    Iteration  100, KL divergence 1.0899, 50 iterations in 0.0173 sec
    Iteration  150, KL divergence 1.0899, 50 iterations in 0.0176 sec
    Iteration  200, KL divergence 1.0899, 50 iterations in 0.0141 sec
    Iteration  250, KL divergence 1.0899, 50 iterations in 0.0114 sec
       --> Time elapsed: 0.07 seconds
    ===> Running optimization with exaggeration=1.00, lr=5.00 for 500 iterations...
    Iteration   50, KL divergence 0.1115, 50 iterations in 0.0166 sec
    Iteration  100, KL divergence 0.1110, 50 iterations in 0.0065 sec
    Iteration  150, KL divergence 0.1110, 50 iterations in 0.0064 sec
    Iteration  200, KL divergence 0.1110, 50 iterations in 0.0064 sec
    Iteration  250, KL divergence 0.1109, 50 iterations in 0.0064 sec
    Iteration  300, KL divergence 0.1108, 50 iterations in 0.0064 sec
    Iteration  350, KL divergence 0.1107, 50 iterations in 0.0064 sec
    Iteration  400, KL divergence 0.1106, 50 iterations in 0.0064 sec
    Iteration  450, KL divergence 0.1106, 50 iterations in 0.0063 sec
    Iteration  500, KL divergence 0.1105, 50 iterations in 0.0064 sec
       --> Time elapsed: 0.07 seconds



    (5, 2)



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
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>0</td>
      <td>0.507805</td>
      <td>7.562123</td>
      <td>0.434115</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.221261</td>
      <td>-1.344804</td>
      <td>-0.077216</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.190845</td>
      <td>11.398268</td>
      <td>0.654344</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.190845</td>
      <td>-11.601173</td>
      <td>-0.665972</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>1</td>
      <td>0.787613</td>
      <td>-6.014414</td>
      <td>-0.345272</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsTypescript_files/NodeEmbeddingsTypescript_25_6.png)
    

