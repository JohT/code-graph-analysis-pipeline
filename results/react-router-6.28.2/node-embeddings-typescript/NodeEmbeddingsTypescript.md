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
      <td>About</td>
      <td>lazy-loading</td>
      <td>0</td>
      <td>0.056948</td>
      <td>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056948</td>
      <td>[-0.20673155784606934, -0.20673155784606934, 0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724882</td>
      <td>[-0.20059148967266083, -0.20059148967266083, 0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056948</td>
      <td>[-0.21884769201278687, -0.21884769201278687, 0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679392</td>
      <td>[-0.21108949184417725, -0.21108949184417725, 0...</td>
    </tr>
  </tbody>
</table>
</div>


### 1.2 Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

This step takes the original node embeddings with a higher dimensionality, e.g. 64 floating point numbers, and reduces them into a two dimensional array for visualization. For more details look up the function declaration for "prepare_node_embeddings_for_2d_visualization".

    Perplexity value 30 is too high. Using perplexity 1.67 instead


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 5 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.06 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.50 for 250 iterations...
    Iteration   50, KL divergence 0.9268, 50 iterations in 0.0103 sec
    Iteration  100, KL divergence 0.7773, 50 iterations in 0.0147 sec
    Iteration  150, KL divergence 0.7875, 50 iterations in 0.0211 sec
    Iteration  200, KL divergence 0.7873, 50 iterations in 0.0174 sec
    Iteration  250, KL divergence 0.7919, 50 iterations in 0.0132 sec
       --> Time elapsed: 0.08 seconds
    ===> Running optimization with exaggeration=1.00, lr=6.00 for 500 iterations...
    Iteration   50, KL divergence 0.0612, 50 iterations in 0.0069 sec
    Iteration  100, KL divergence 0.0556, 50 iterations in 0.0067 sec
    Iteration  150, KL divergence 0.0502, 50 iterations in 0.0065 sec
    Iteration  200, KL divergence 0.0471, 50 iterations in 0.0065 sec
    Iteration  250, KL divergence 0.0457, 50 iterations in 0.0066 sec
    Iteration  300, KL divergence 0.0446, 50 iterations in 0.0067 sec
    Iteration  350, KL divergence 0.0440, 50 iterations in 0.0067 sec
    Iteration  400, KL divergence 0.0435, 50 iterations in 0.0072 sec
    Iteration  450, KL divergence 0.0432, 50 iterations in 0.0073 sec
    Iteration  500, KL divergence 0.0429, 50 iterations in 0.0070 sec
       --> Time elapsed: 0.07 seconds



    (6, 2)



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
      <td>lazy-loading</td>
      <td>0</td>
      <td>0.056948</td>
      <td>21.346222</td>
      <td>3.407845</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056948</td>
      <td>-4.243350</td>
      <td>0.683841</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724882</td>
      <td>-14.786764</td>
      <td>2.590528</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056948</td>
      <td>-13.232161</td>
      <td>-4.841563</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679392</td>
      <td>-10.677416</td>
      <td>-1.315958</td>
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
      <td>About</td>
      <td>lazy-loading</td>
      <td>0</td>
      <td>0.056948</td>
      <td>[-0.3061862289905548, 0.3061862289905548, 0.0,...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056948</td>
      <td>[-0.6123724579811096, 0.9185586869716644, -0.9...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724882</td>
      <td>[-0.6123724579811096, 0.9185586869716644, -0.9...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056948</td>
      <td>[-0.6123724579811096, 0.9185586869716644, -0.9...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679392</td>
      <td>[-0.6123724579811096, 0.9185586869716644, -0.9...</td>
    </tr>
  </tbody>
</table>
</div>


    Perplexity value 30 is too high. Using perplexity 1.67 instead


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 5 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.01 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.50 for 250 iterations...
    Iteration   50, KL divergence 0.6115, 50 iterations in 0.0073 sec
    Iteration  100, KL divergence 0.5285, 50 iterations in 0.0179 sec
    Iteration  150, KL divergence 0.6041, 50 iterations in 0.0127 sec
    Iteration  200, KL divergence 0.6391, 50 iterations in 0.0076 sec
    Iteration  250, KL divergence 0.4475, 50 iterations in 0.0078 sec
       --> Time elapsed: 0.05 seconds
    ===> Running optimization with exaggeration=1.00, lr=6.00 for 500 iterations...
    Iteration   50, KL divergence 0.0199, 50 iterations in 0.0074 sec
    Iteration  100, KL divergence 0.0141, 50 iterations in 0.0073 sec
    Iteration  150, KL divergence 0.0139, 50 iterations in 0.0075 sec
    Iteration  200, KL divergence 0.0139, 50 iterations in 0.0075 sec
    Iteration  250, KL divergence 0.1353, 50 iterations in 0.0076 sec
    Iteration  300, KL divergence 0.0286, 50 iterations in 0.0068 sec
    Iteration  350, KL divergence 0.0278, 50 iterations in 0.0069 sec
    Iteration  400, KL divergence 0.0258, 50 iterations in 0.0069 sec
    Iteration  450, KL divergence 0.0139, 50 iterations in 0.0068 sec
    Iteration  500, KL divergence 0.0139, 50 iterations in 0.0072 sec
       --> Time elapsed: 0.07 seconds



    (6, 2)



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
      <td>lazy-loading</td>
      <td>0</td>
      <td>0.056948</td>
      <td>5.076960</td>
      <td>-0.493781</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056948</td>
      <td>-3.297696</td>
      <td>0.240774</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724882</td>
      <td>-2.544224</td>
      <td>1.011089</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056948</td>
      <td>-2.532201</td>
      <td>-0.517202</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679392</td>
      <td>-1.779799</td>
      <td>0.253355</td>
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
      <td>About</td>
      <td>lazy-loading</td>
      <td>0</td>
      <td>0.056948</td>
      <td>[0.01346324197947979, 0.015218385495245457, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056948</td>
      <td>[0.014961865730583668, 0.006625833455473185, -...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724882</td>
      <td>[0.0021461735013872385, 0.009314928203821182, ...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056948</td>
      <td>[0.00302307540550828, 0.006800586357712746, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679392</td>
      <td>[-0.009935382753610611, 0.0007766146445646882,...</td>
    </tr>
  </tbody>
</table>
</div>


    Perplexity value 30 is too high. Using perplexity 1.67 instead


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 5 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.00 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.50 for 250 iterations...
    Iteration   50, KL divergence 0.9277, 50 iterations in 0.0075 sec
    Iteration  100, KL divergence 0.7643, 50 iterations in 0.0074 sec
    Iteration  150, KL divergence 0.7841, 50 iterations in 0.0077 sec
    Iteration  200, KL divergence 0.7874, 50 iterations in 0.0078 sec
    Iteration  250, KL divergence 0.7849, 50 iterations in 0.0076 sec
       --> Time elapsed: 0.04 seconds
    ===> Running optimization with exaggeration=1.00, lr=6.00 for 500 iterations...
    Iteration   50, KL divergence 0.0458, 50 iterations in 0.0069 sec
    Iteration  100, KL divergence 0.0428, 50 iterations in 0.0067 sec
    Iteration  150, KL divergence 0.0396, 50 iterations in 0.0067 sec
    Iteration  200, KL divergence 0.0379, 50 iterations in 0.0067 sec
    Iteration  250, KL divergence 0.0368, 50 iterations in 0.0069 sec
    Iteration  300, KL divergence 0.0362, 50 iterations in 0.0071 sec
    Iteration  350, KL divergence 0.0357, 50 iterations in 0.0066 sec
    Iteration  400, KL divergence 0.0354, 50 iterations in 0.0067 sec
    Iteration  450, KL divergence 0.0351, 50 iterations in 0.0070 sec
    Iteration  500, KL divergence 0.0349, 50 iterations in 0.0066 sec
       --> Time elapsed: 0.07 seconds



    (6, 2)



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
      <td>lazy-loading</td>
      <td>0</td>
      <td>0.056948</td>
      <td>18.686637</td>
      <td>-2.951515</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056948</td>
      <td>-6.690709</td>
      <td>-5.774992</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724882</td>
      <td>-11.699085</td>
      <td>2.438138</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056948</td>
      <td>-9.391822</td>
      <td>6.600745</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679392</td>
      <td>-9.720475</td>
      <td>-0.869603</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsTypescript_files/NodeEmbeddingsTypescript_25_6.png)
    

