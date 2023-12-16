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

    The scikit-learn version is 1.3.1.
    The pandas version is 1.5.3.






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
      <td>package-embeddings-notebook-cleaned</td>
      <td>package-embeddings-notebook</td>
      <td>89</td>
      <td>634</td>
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
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>0</td>
      <td>0.020769</td>
      <td>axon-messaging-4.7.6</td>
      <td>[-0.11198288947343826, -0.2420406937599182, -0...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>0</td>
      <td>0.029473</td>
      <td>axon-messaging-4.7.6</td>
      <td>[-0.11337780952453613, -0.29292231798171997, -...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>0</td>
      <td>0.018713</td>
      <td>axon-messaging-4.7.6</td>
      <td>[-0.185805082321167, -0.31464821100234985, -0....</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>0</td>
      <td>0.016748</td>
      <td>axon-messaging-4.7.6</td>
      <td>[-0.11655731499195099, -0.29508155584335327, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.common</td>
      <td>0</td>
      <td>0.579575</td>
      <td>axon-messaging-4.7.6</td>
      <td>[-0.06140819191932678, -0.1362229883670807, -0...</td>
    </tr>
  </tbody>
</table>
</div>



### Dimensionality reduction with t-distributed stochastic neighbor embedding (t-SNE)

This step takes the original node embeddings with a higher dimensionality (e.g. list of 32 floats) and
reduces them to a 2 dimensional array for visualization. 

> It converts similarities between data points to joint probabilities and tries to minimize the Kullback-Leibler divergence between the joint probabilities of the low-dimensional embedding and the high-dimensional data.

(see https://scikit-learn.org/stable/modules/generated/sklearn.manifold.TSNE.html#sklearn.manifold.TSNE)

    [t-SNE] Computing 88 nearest neighbors...
    [t-SNE] Indexed 89 samples in 0.000s...
    [t-SNE] Computed neighbors for 89 samples in 0.021s...
    [t-SNE] Computed conditional probabilities for sample 89 / 89
    [t-SNE] Mean sigma: 0.559787
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 48.115852
    [t-SNE] KL divergence after 800 iterations: 0.074152





    (89, 2)






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
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.7.6</td>
      <td>0</td>
      <td>0.020769</td>
      <td>-0.777637</td>
      <td>3.675467</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.7.6</td>
      <td>0</td>
      <td>0.029473</td>
      <td>-1.017740</td>
      <td>2.856290</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.7.6</td>
      <td>0</td>
      <td>0.018713</td>
      <td>-0.542060</td>
      <td>3.420087</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>axon-messaging-4.7.6</td>
      <td>0</td>
      <td>0.016748</td>
      <td>-0.996501</td>
      <td>3.307906</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.common</td>
      <td>axon-messaging-4.7.6</td>
      <td>0</td>
      <td>0.579575</td>
      <td>-2.503302</td>
      <td>-0.645303</td>
    </tr>
  </tbody>
</table>
</div>




    
![png](NodeEmbeddings_files/NodeEmbeddings_18_0.png)
    

