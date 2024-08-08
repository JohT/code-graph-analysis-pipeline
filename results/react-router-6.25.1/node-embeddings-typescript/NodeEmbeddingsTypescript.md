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
      <td>0.577212</td>
      <td>[0.2955484390258789, -0.06563244760036469, 0.5...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.234789</td>
      <td>[0.30690157413482666, -0.0659116581082344, 0.5...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.182952</td>
      <td>[0.3941478729248047, -0.08976708352565765, 0.7...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.182952</td>
      <td>[0.29623112082481384, -0.06263356655836105, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>router</td>
      <td>0</td>
      <td>0.738076</td>
      <td>[0.3878895044326782, -0.08466154336929321, 0.7...</td>
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
    Iteration   50, KL divergence 0.4022, 50 iterations in 0.0073 sec
    Iteration  100, KL divergence 0.4541, 50 iterations in 0.0072 sec
    Iteration  150, KL divergence 0.4560, 50 iterations in 0.0073 sec
    Iteration  200, KL divergence 0.4571, 50 iterations in 0.0073 sec
    Iteration  250, KL divergence 0.4535, 50 iterations in 0.0077 sec
       --> Time elapsed: 0.04 seconds
    ===> Running optimization with exaggeration=1.00, lr=5.00 for 500 iterations...
    Iteration   50, KL divergence 0.0299, 50 iterations in 0.0065 sec
    Iteration  100, KL divergence 0.0233, 50 iterations in 0.0065 sec
    Iteration  150, KL divergence 0.0210, 50 iterations in 0.0074 sec
    Iteration  200, KL divergence 0.0195, 50 iterations in 0.0064 sec
    Iteration  250, KL divergence 0.0181, 50 iterations in 0.0064 sec
    Iteration  300, KL divergence 0.0164, 50 iterations in 0.0064 sec
    Iteration  350, KL divergence 0.0146, 50 iterations in 0.0064 sec
    Iteration  400, KL divergence 0.0138, 50 iterations in 0.0062 sec
    Iteration  450, KL divergence 0.0134, 50 iterations in 0.0062 sec
    Iteration  500, KL divergence 0.0131, 50 iterations in 0.0063 sec
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
      <td>0.577212</td>
      <td>-6.448307</td>
      <td>-1.948598</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.234789</td>
      <td>-8.611533</td>
      <td>0.390473</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.182952</td>
      <td>11.863060</td>
      <td>-0.952109</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.182952</td>
      <td>-10.098698</td>
      <td>1.963744</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>0</td>
      <td>0.738076</td>
      <td>13.295479</td>
      <td>0.546490</td>
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
      <td>0.577212</td>
      <td>[1.8371173739433289, -0.3061862289905548, 0.61...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.234789</td>
      <td>[1.8371173739433289, -0.3061862289905548, 0.61...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.182952</td>
      <td>[1.8371173739433289, -0.3061862289905548, 0.61...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.182952</td>
      <td>[1.8371173739433289, 0.0, 0.3061862289905548, ...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>router</td>
      <td>0</td>
      <td>0.738076</td>
      <td>[1.8371173739433289, -0.3061862289905548, 0.61...</td>
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
    Iteration   50, KL divergence -0.3095, 50 iterations in 0.0118 sec
    Iteration  100, KL divergence 0.7122, 50 iterations in 0.0132 sec
    Iteration  150, KL divergence 0.7122, 50 iterations in 0.0062 sec
    Iteration  200, KL divergence 0.7122, 50 iterations in 0.0061 sec
    Iteration  250, KL divergence 0.7122, 50 iterations in 0.0061 sec
       --> Time elapsed: 0.04 seconds
    ===> Running optimization with exaggeration=1.00, lr=5.00 for 500 iterations...
    Iteration   50, KL divergence 0.2924, 50 iterations in 0.0065 sec
    Iteration  100, KL divergence 0.1372, 50 iterations in 0.0064 sec
    Iteration  150, KL divergence 0.1351, 50 iterations in 0.0063 sec
    Iteration  200, KL divergence 0.1346, 50 iterations in 0.0062 sec
    Iteration  250, KL divergence 0.1348, 50 iterations in 0.0062 sec
    Iteration  300, KL divergence 0.1369, 50 iterations in 0.0063 sec
    Iteration  350, KL divergence 0.1338, 50 iterations in 0.0063 sec
    Iteration  400, KL divergence 0.1335, 50 iterations in 0.0062 sec
    Iteration  450, KL divergence 0.1341, 50 iterations in 0.0063 sec
    Iteration  500, KL divergence 0.1360, 50 iterations in 0.0062 sec
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
      <td>0.577212</td>
      <td>3.810531</td>
      <td>2.956781</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.234789</td>
      <td>1.819820</td>
      <td>-2.677379</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.182952</td>
      <td>-2.155648</td>
      <td>2.412603</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.182952</td>
      <td>-4.525381</td>
      <td>-3.510447</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>0</td>
      <td>0.738076</td>
      <td>1.050677</td>
      <td>0.818443</td>
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
      <td>0.577212</td>
      <td>[0.0028438575100153685, -0.2953944504261017, 0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.234789</td>
      <td>[-0.0025952665600925684, -0.2786877751350403, ...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.182952</td>
      <td>[-0.0016597701469436288, -0.2747211754322052, ...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.182952</td>
      <td>[0.001281277509406209, -0.26696333289146423, 0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>router</td>
      <td>0</td>
      <td>0.738076</td>
      <td>[-0.002613719319924712, -0.29328668117523193, ...</td>
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
    Iteration   50, KL divergence 0.5922, 50 iterations in 0.0068 sec
    Iteration  100, KL divergence 0.9778, 50 iterations in 0.0063 sec
    Iteration  150, KL divergence 0.9778, 50 iterations in 0.0061 sec
    Iteration  200, KL divergence 0.9778, 50 iterations in 0.0061 sec
    Iteration  250, KL divergence 0.9778, 50 iterations in 0.0061 sec
       --> Time elapsed: 0.03 seconds
    ===> Running optimization with exaggeration=1.00, lr=5.00 for 500 iterations...
    Iteration   50, KL divergence 0.1842, 50 iterations in 0.0064 sec
    Iteration  100, KL divergence 0.1704, 50 iterations in 0.0065 sec
    Iteration  150, KL divergence 0.1699, 50 iterations in 0.0063 sec
    Iteration  200, KL divergence 0.1693, 50 iterations in 0.0063 sec
    Iteration  250, KL divergence 0.1688, 50 iterations in 0.0063 sec
    Iteration  300, KL divergence 0.1684, 50 iterations in 0.0231 sec
    Iteration  350, KL divergence 0.1681, 50 iterations in 0.0127 sec
    Iteration  400, KL divergence 0.1679, 50 iterations in 0.0064 sec
    Iteration  450, KL divergence 0.1678, 50 iterations in 0.0064 sec
    Iteration  500, KL divergence 0.1676, 50 iterations in 0.0064 sec
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
      <td>0.577212</td>
      <td>2.790151</td>
      <td>-15.599818</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.234789</td>
      <td>3.763629</td>
      <td>7.638938</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-dom</td>
      <td>0</td>
      <td>0.182952</td>
      <td>-3.604807</td>
      <td>-4.730990</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>react-router-native</td>
      <td>0</td>
      <td>0.182952</td>
      <td>-11.798683</td>
      <td>-5.690626</td>
    </tr>
    <tr>
      <th>4</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>router</td>
      <td>0</td>
      <td>0.738076</td>
      <td>8.849710</td>
      <td>18.382496</td>
    </tr>
  </tbody>
</table>
</div>



    
![png](NodeEmbeddingsTypescript_files/NodeEmbeddingsTypescript_25_6.png)
    

