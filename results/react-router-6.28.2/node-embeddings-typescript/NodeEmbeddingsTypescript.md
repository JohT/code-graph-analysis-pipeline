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
      <td>0.056949</td>
      <td>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056949</td>
      <td>[0.5664620399475098, -0.5664620399475098, 0.0,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724554</td>
      <td>[0.615138590335846, -0.615138590335846, 0.0, -...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056949</td>
      <td>[0.6284795999526978, -0.6284795999526978, 0.0,...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679742</td>
      <td>[0.6276408433914185, -0.6276408433914185, 0.0,...</td>
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
       --> Time elapsed: 0.05 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.50 for 250 iterations...
    Iteration   50, KL divergence 0.9279, 50 iterations in 0.0074 sec
    Iteration  100, KL divergence 0.7860, 50 iterations in 0.0072 sec
    Iteration  150, KL divergence 0.7899, 50 iterations in 0.0076 sec
    Iteration  200, KL divergence 0.7956, 50 iterations in 0.0075 sec
    Iteration  250, KL divergence 0.7895, 50 iterations in 0.0074 sec
       --> Time elapsed: 0.04 seconds
    ===> Running optimization with exaggeration=1.00, lr=6.00 for 500 iterations...
    Iteration   50, KL divergence 0.0555, 50 iterations in 0.0068 sec
    Iteration  100, KL divergence 0.0490, 50 iterations in 0.0066 sec
    Iteration  150, KL divergence 0.0457, 50 iterations in 0.0064 sec
    Iteration  200, KL divergence 0.0439, 50 iterations in 0.0064 sec
    Iteration  250, KL divergence 0.0426, 50 iterations in 0.0064 sec
    Iteration  300, KL divergence 0.0418, 50 iterations in 0.0064 sec
    Iteration  350, KL divergence 0.0411, 50 iterations in 0.0066 sec
    Iteration  400, KL divergence 0.0406, 50 iterations in 0.0064 sec
    Iteration  450, KL divergence 0.0403, 50 iterations in 0.0064 sec
    Iteration  500, KL divergence 0.0400, 50 iterations in 0.0065 sec
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
      <td>0.056949</td>
      <td>20.303717</td>
      <td>1.862447</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056949</td>
      <td>-4.104041</td>
      <td>-1.895946</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724554</td>
      <td>-12.581710</td>
      <td>4.697318</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056949</td>
      <td>-10.290488</td>
      <td>-0.317533</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679742</td>
      <td>-13.816775</td>
      <td>-2.454846</td>
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
      <td>0.056949</td>
      <td>[0.6123724579811096, 0.3061862289905548, -0.30...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056949</td>
      <td>[0.0, 0.3061862289905548, -0.6123724579811096,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724554</td>
      <td>[0.0, 0.3061862289905548, -0.6123724579811096,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056949</td>
      <td>[0.0, 0.3061862289905548, -0.6123724579811096,...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679742</td>
      <td>[0.0, 0.3061862289905548, -0.6123724579811096,...</td>
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
    Iteration   50, KL divergence 0.6790, 50 iterations in 0.0139 sec
    Iteration  100, KL divergence 0.5346, 50 iterations in 0.0079 sec
    Iteration  150, KL divergence 0.5361, 50 iterations in 0.0081 sec
    Iteration  200, KL divergence 0.5357, 50 iterations in 0.0082 sec
    Iteration  250, KL divergence 0.6285, 50 iterations in 0.0082 sec
       --> Time elapsed: 0.05 seconds
    ===> Running optimization with exaggeration=1.00, lr=6.00 for 500 iterations...
    Iteration   50, KL divergence 0.0142, 50 iterations in 0.0075 sec
    Iteration  100, KL divergence 0.0140, 50 iterations in 0.0076 sec
    Iteration  150, KL divergence 0.0139, 50 iterations in 0.0077 sec
    Iteration  200, KL divergence 0.0139, 50 iterations in 0.0078 sec
    Iteration  250, KL divergence 0.2593, 50 iterations in 0.0077 sec
    Iteration  300, KL divergence 0.0288, 50 iterations in 0.0071 sec
    Iteration  350, KL divergence 0.0285, 50 iterations in 0.0069 sec
    Iteration  400, KL divergence 0.0269, 50 iterations in 0.0067 sec
    Iteration  450, KL divergence 0.0139, 50 iterations in 0.0068 sec
    Iteration  500, KL divergence 0.0138, 50 iterations in 0.0070 sec
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
      <td>0.056949</td>
      <td>5.011341</td>
      <td>-0.879239</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056949</td>
      <td>-2.623775</td>
      <td>1.194174</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724554</td>
      <td>-3.255877</td>
      <td>0.321142</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056949</td>
      <td>-1.755855</td>
      <td>0.558493</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679742</td>
      <td>-2.387105</td>
      <td>-0.314856</td>
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
      <td>0.056949</td>
      <td>[0.012791382148861885, 0.005551357287913561, -...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056949</td>
      <td>[0.2646135687828064, 0.304097443819046, 0.1825...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724554</td>
      <td>[0.23909664154052734, 0.31312012672424316, 0.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056949</td>
      <td>[0.24631883203983307, 0.30623918771743774, 0.1...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679742</td>
      <td>[0.23724457621574402, 0.3119012713432312, 0.18...</td>
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
    Iteration   50, KL divergence 0.9271, 50 iterations in 0.0074 sec
    Iteration  100, KL divergence 0.7735, 50 iterations in 0.0074 sec
    Iteration  150, KL divergence 0.7828, 50 iterations in 0.0077 sec
    Iteration  200, KL divergence 0.7822, 50 iterations in 0.0077 sec
    Iteration  250, KL divergence 0.8973, 50 iterations in 0.0075 sec
       --> Time elapsed: 0.04 seconds
    ===> Running optimization with exaggeration=1.00, lr=6.00 for 500 iterations...
    Iteration   50, KL divergence 0.0620, 50 iterations in 0.0071 sec
    Iteration  100, KL divergence 0.0537, 50 iterations in 0.0067 sec
    Iteration  150, KL divergence 0.0493, 50 iterations in 0.0068 sec
    Iteration  200, KL divergence 0.0474, 50 iterations in 0.0067 sec
    Iteration  250, KL divergence 0.0464, 50 iterations in 0.0066 sec
    Iteration  300, KL divergence 0.0455, 50 iterations in 0.0067 sec
    Iteration  350, KL divergence 0.0449, 50 iterations in 0.0067 sec
    Iteration  400, KL divergence 0.0444, 50 iterations in 0.0065 sec
    Iteration  450, KL divergence 0.0440, 50 iterations in 0.0066 sec
    Iteration  500, KL divergence 0.0438, 50 iterations in 0.0067 sec
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
      <td>0.056949</td>
      <td>18.058721</td>
      <td>2.402263</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router</td>
      <td>1</td>
      <td>0.056949</td>
      <td>-11.051266</td>
      <td>-5.707020</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.724554</td>
      <td>-11.371338</td>
      <td>3.449096</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.056949</td>
      <td>-8.516256</td>
      <td>-0.467933</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>1</td>
      <td>0.679742</td>
      <td>-5.226363</td>
      <td>1.277406</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsTypescript_files/NodeEmbeddingsTypescript_25_6.png)
    

