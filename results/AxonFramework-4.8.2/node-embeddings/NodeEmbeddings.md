# Node Embeddings

Here we will have a look at node embeddings and how to further reduce their dimensionality to be able to visualize them in a 2D plot. 

### Note about data dependencies

PageRank centrality and Leiden community are also fetched from the Graph and need to be calculated first.
This makes it easier to see in the visualization if the embeddings approximate the structural information of the graph.
If these properties are missing you will only see black dots all of the same size without community coloring.
In future it might make sense to also run a community detection algorithm co-located in here to not depend on the order of execution.

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






## Preparation

### Create Graph Projection

Create an in-memory undirected graph projection containing Package nodes (vertices) and their dependencies (edges).




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>graphName</th>
      <th>fromGraphName</th>
      <th>nodeCount</th>
      <th>relationshipCount</th>
      <th>nodeFilter</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>package-embeddings-notebook-without-empty</td>
      <td>package-embeddings-notebook</td>
      <td>93</td>
      <td>1130</td>
      <td>n.outgoingDependencies &gt; 0 OR n.incomingDepend...</td>
    </tr>
  </tbody>
</table>
</div>



### Generate Node Embeddings using Fast Random Projection (Fast RP)

[Fast Random Projection](https://neo4j.com/docs/graph-data-science/current/machine-learning/node-embeddings/fastrp) calculates an array of floats (length = embedding dimension) for every node in the graph. These numbers approximate the relationship and similarity information of each node and are called node embeddings. Random Projections is used to reduce the dimensionality of the node feature space while preserving pairwise distances.

The result can be used in machine learning as features approximating the graph structure. It can also be used to further reduce the dimensionality to visualize the graph in a 2D plot, as we will be doing here.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>codeUnitName</th>
      <th>communityId</th>
      <th>centrality</th>
      <th>artifactName</th>
      <th>embedding</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.tracing.attributes</td>
      <td>5</td>
      <td>0.013868</td>
      <td>axon-messaging-4.8.2</td>
      <td>[-0.08407311141490936, -0.10319409519433975, -...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.util</td>
      <td>5</td>
      <td>0.027632</td>
      <td>axon-messaging-4.8.2</td>
      <td>[0.01044880598783493, 0.04373960569500923, -0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command</td>
      <td>0</td>
      <td>0.033153</td>
      <td>axon-modelling-4.8.2</td>
      <td>[0.03394953906536102, 0.01623348705470562, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>0</td>
      <td>0.023037</td>
      <td>axon-modelling-4.8.2</td>
      <td>[0.06496097147464752, 0.003628889564424753, -0...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>0</td>
      <td>0.013868</td>
      <td>axon-modelling-4.8.2</td>
      <td>[0.08117750287055969, 0.047742810100317, -0.12...</td>
    </tr>
  </tbody>
</table>
</div>



### Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

This step takes the original node embeddings with a higher dimensionality (e.g. list of 32 floats) and
reduces them to a 2 dimensional array for visualization. 

> It converts similarities between data points to joint probabilities and tries to minimize the Kullback-Leibler divergence between the joint probabilities of the low-dimensional embedding and the high-dimensional data.

(see https://scikit-learn.org/stable/modules/generated/sklearn.manifold.TSNE.html#sklearn.manifold.TSNE)

    [t-SNE] Computing 91 nearest neighbors...
    [t-SNE] Indexed 93 samples in 0.000s...
    [t-SNE] Computed neighbors for 93 samples in 0.046s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.441813
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 49.667824
    [t-SNE] KL divergence after 750 iterations: 0.164504





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
      <td>org.axonframework.tracing.attributes</td>
      <td>axon-messaging-4.8.2</td>
      <td>5</td>
      <td>0.013868</td>
      <td>-3.733143</td>
      <td>2.657122</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.util</td>
      <td>axon-messaging-4.8.2</td>
      <td>5</td>
      <td>0.027632</td>
      <td>-2.149618</td>
      <td>-1.073570</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command</td>
      <td>axon-modelling-4.8.2</td>
      <td>0</td>
      <td>0.033153</td>
      <td>-0.381026</td>
      <td>3.825725</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.8.2</td>
      <td>0</td>
      <td>0.023037</td>
      <td>-0.214617</td>
      <td>4.187713</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.8.2</td>
      <td>0</td>
      <td>0.013868</td>
      <td>0.403822</td>
      <td>4.714711</td>
    </tr>
  </tbody>
</table>
</div>




    
![png](NodeEmbeddings_files/NodeEmbeddings_18_0.png)
    

