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
      <td>0.416895</td>
      <td>[0.5187332630157471, 0.31736159324645996, 0.31...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.198017</td>
      <td>[0.6525251269340515, 0.25236713886260986, 0.13...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.229576</td>
      <td>[0.4520477056503296, 0.3224243223667145, 0.271...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.198017</td>
      <td>[0.5515021681785583, 0.3436492681503296, 0.317...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>router</td>
      <td>1</td>
      <td>0.833710</td>
      <td>[0.469546914100647, 0.301737904548645, 0.29044...</td>
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
       --> Time elapsed: 0.06 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.42 for 250 iterations...
    Iteration   50, KL divergence 0.4242, 50 iterations in 0.0071 sec
    Iteration  100, KL divergence 0.7527, 50 iterations in 0.0127 sec
    Iteration  150, KL divergence 0.7527, 50 iterations in 0.0163 sec
    Iteration  200, KL divergence 0.7527, 50 iterations in 0.0131 sec
    Iteration  250, KL divergence 0.7527, 50 iterations in 0.0095 sec
       --> Time elapsed: 0.06 seconds
    ===> Running optimization with exaggeration=1.00, lr=5.00 for 500 iterations...
    Iteration   50, KL divergence 0.0575, 50 iterations in 0.0116 sec
    Iteration  100, KL divergence 0.0458, 50 iterations in 0.0167 sec
    Iteration  150, KL divergence 0.0457, 50 iterations in 0.0102 sec
    Iteration  200, KL divergence 0.0455, 50 iterations in 0.0066 sec
    Iteration  250, KL divergence 0.0453, 50 iterations in 0.0064 sec
    Iteration  300, KL divergence 0.0451, 50 iterations in 0.0065 sec
    Iteration  350, KL divergence 0.0449, 50 iterations in 0.0064 sec
    Iteration  400, KL divergence 0.0448, 50 iterations in 0.0074 sec
    Iteration  450, KL divergence 0.0447, 50 iterations in 0.0072 sec
    Iteration  500, KL divergence 0.0446, 50 iterations in 0.0066 sec
       --> Time elapsed: 0.09 seconds



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
      <td>0.416895</td>
      <td>-14.771813</td>
      <td>4.227666</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.198017</td>
      <td>0.457922</td>
      <td>-13.133346</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.229576</td>
      <td>12.824027</td>
      <td>1.486377</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.198017</td>
      <td>-4.467238</td>
      <td>4.296535</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>1</td>
      <td>0.833710</td>
      <td>5.957102</td>
      <td>3.122768</td>
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
      <td>0.416895</td>
      <td>[-0.6123724579811096, 0.6123724579811096, 0.0,...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.198017</td>
      <td>[-0.6123724579811096, 0.6123724579811096, 0.0,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.229576</td>
      <td>[-0.6123724579811096, 0.6123724579811096, 0.0,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.198017</td>
      <td>[-0.6123724579811096, 0.6123724579811096, 0.0,...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>router</td>
      <td>1</td>
      <td>0.833710</td>
      <td>[-0.6123724579811096, 0.6123724579811096, 0.0,...</td>
    </tr>
  </tbody>
</table>
</div>


    Perplexity value 30 is too high. Using perplexity 1.33 instead


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 4 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.00 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.42 for 250 iterations...
    Iteration   50, KL divergence    nan, 50 iterations in 0.0051 sec
    Iteration  100, KL divergence    nan, 50 iterations in 0.0048 sec
    Iteration  150, KL divergence    nan, 50 iterations in 0.0047 sec
    Iteration  200, KL divergence    nan, 50 iterations in 0.0046 sec
    Iteration  250, KL divergence    nan, 50 iterations in 0.0058 sec
       --> Time elapsed: 0.03 seconds
    ===> Running optimization with exaggeration=1.00, lr=5.00 for 500 iterations...
    Iteration   50, KL divergence    nan, 50 iterations in 0.0062 sec
    Iteration  100, KL divergence    nan, 50 iterations in 0.0062 sec
    Iteration  150, KL divergence    nan, 50 iterations in 0.0061 sec
    Iteration  200, KL divergence    nan, 50 iterations in 0.0061 sec
    Iteration  250, KL divergence    nan, 50 iterations in 0.0061 sec
    Iteration  300, KL divergence    nan, 50 iterations in 0.0061 sec
    Iteration  350, KL divergence    nan, 50 iterations in 0.0061 sec
    Iteration  400, KL divergence    nan, 50 iterations in 0.0061 sec
    Iteration  450, KL divergence    nan, 50 iterations in 0.0061 sec
    Iteration  500, KL divergence    nan, 50 iterations in 0.0061 sec
       --> Time elapsed: 0.06 seconds


    /home/runner/miniconda3/envs/codegraph/lib/python3.11/site-packages/sklearn/decomposition/_pca.py:527: RuntimeWarning: invalid value encountered in divide
      explained_variance_ratio_ = explained_variance_ / total_var
    /home/runner/miniconda3/envs/codegraph/lib/python3.11/site-packages/openTSNE/initialization.py:27: RuntimeWarning: invalid value encountered in divide
      x /= np.std(x[:, 0]) / target_std



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
      <td>0.416895</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.198017</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.229576</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.198017</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>1</td>
      <td>0.833710</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsTypescript_files/NodeEmbeddingsTypescript_23_7.png)
    


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
      <td>0.416895</td>
      <td>[0.08672907203435898, 0.07888095825910568, 0.0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.198017</td>
      <td>[0.08857010304927826, 0.07089825719594955, 0.0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.229576</td>
      <td>[0.07596069574356079, 0.053717877715826035, 0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.198017</td>
      <td>[0.07606938481330872, 0.05936235189437866, 0.0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>router</td>
      <td>1</td>
      <td>0.833710</td>
      <td>[0.08328866213560104, 0.05584773048758507, 0.0...</td>
    </tr>
  </tbody>
</table>
</div>


    Perplexity value 30 is too high. Using perplexity 1.33 instead


    --------------------------------------------------------------------------------
    TSNE(early_exaggeration=12, random_state=47, verbose=1)
    --------------------------------------------------------------------------------
    ===> Finding 4 nearest neighbors using exact search using euclidean distance...
       --> Time elapsed: 0.00 seconds
    ===> Calculating affinity matrix...
       --> Time elapsed: 0.00 seconds
    ===> Calculating PCA-based initialization...
       --> Time elapsed: 0.00 seconds
    ===> Running optimization with exaggeration=12.00, lr=0.42 for 250 iterations...
    Iteration   50, KL divergence 0.6332, 50 iterations in 0.0075 sec
    Iteration  100, KL divergence 0.5604, 50 iterations in 0.0077 sec
    Iteration  150, KL divergence 0.5585, 50 iterations in 0.0078 sec
    Iteration  200, KL divergence 0.5586, 50 iterations in 0.0073 sec
    Iteration  250, KL divergence 0.5585, 50 iterations in 0.0072 sec
       --> Time elapsed: 0.04 seconds
    ===> Running optimization with exaggeration=1.00, lr=5.00 for 500 iterations...
    Iteration   50, KL divergence 0.0393, 50 iterations in 0.0068 sec
    Iteration  100, KL divergence 0.0358, 50 iterations in 0.0068 sec
    Iteration  150, KL divergence 0.0339, 50 iterations in 0.0067 sec
    Iteration  200, KL divergence 0.0328, 50 iterations in 0.0067 sec
    Iteration  250, KL divergence 0.0321, 50 iterations in 0.0067 sec
    Iteration  300, KL divergence 0.0315, 50 iterations in 0.0068 sec
    Iteration  350, KL divergence 0.0311, 50 iterations in 0.0067 sec
    Iteration  400, KL divergence 0.0308, 50 iterations in 0.0067 sec
    Iteration  450, KL divergence 0.0305, 50 iterations in 0.0067 sec
    Iteration  500, KL divergence 0.0303, 50 iterations in 0.0067 sec
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
      <td>0.416895</td>
      <td>10.565283</td>
      <td>-0.015308</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.198017</td>
      <td>12.663004</td>
      <td>-0.025754</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.229576</td>
      <td>-10.628627</td>
      <td>0.134620</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>1</td>
      <td>0.198017</td>
      <td>-7.378373</td>
      <td>0.002609</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>1</td>
      <td>0.833710</td>
      <td>-5.221286</td>
      <td>-0.096167</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsTypescript_files/NodeEmbeddingsTypescript_25_6.png)
    

