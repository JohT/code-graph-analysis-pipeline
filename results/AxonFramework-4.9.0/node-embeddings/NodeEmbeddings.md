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
      <td>package-embeddings-notebook-cleaned</td>
      <td>package-embeddings-notebook</td>
      <td>93</td>
      <td>690</td>
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
      <td>org.axonframework.config</td>
      <td>0</td>
      <td>0.016234</td>
      <td>axon-configuration-4.9.0</td>
      <td>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command</td>
      <td>1</td>
      <td>0.155609</td>
      <td>axon-modelling-4.9.0</td>
      <td>[0.0, 0.13429172337055206, 0.344594269990921, ...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>1</td>
      <td>0.152740</td>
      <td>axon-modelling-4.9.0</td>
      <td>[0.0, 0.09356316924095154, 0.39389288425445557...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>1</td>
      <td>0.016234</td>
      <td>axon-modelling-4.9.0</td>
      <td>[0.0, 0.09204399585723877, 0.41912320256233215...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga</td>
      <td>2</td>
      <td>0.349429</td>
      <td>axon-modelling-4.9.0</td>
      <td>[-0.0934668779373169, 0.19118931889533997, -0....</td>
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
    [t-SNE] Computed neighbors for 93 samples in 0.049s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.578919
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 48.905323
    [t-SNE] KL divergence after 1000 iterations: 0.058425





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
      <td>org.axonframework.config</td>
      <td>axon-configuration-4.9.0</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-1.170518</td>
      <td>4.524333</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.modelling.command</td>
      <td>axon-modelling-4.9.0</td>
      <td>1</td>
      <td>0.155609</td>
      <td>-4.100165</td>
      <td>5.718683</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.0</td>
      <td>1</td>
      <td>0.152740</td>
      <td>-4.109707</td>
      <td>5.716646</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>axon-modelling-4.9.0</td>
      <td>1</td>
      <td>0.016234</td>
      <td>-4.123071</td>
      <td>5.725937</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.0</td>
      <td>2</td>
      <td>0.349429</td>
      <td>-1.368129</td>
      <td>7.469067</td>
    </tr>
  </tbody>
</table>
</div>




    
![png](NodeEmbeddings_files/NodeEmbeddings_18_0.png)
    

