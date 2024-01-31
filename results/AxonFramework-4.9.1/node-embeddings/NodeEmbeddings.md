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
      <td>org.axonframework.eventsourcing</td>
      <td>0</td>
      <td>0.107658</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>[-0.10240350663661957, 0.08315573632717133, 0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>0</td>
      <td>0.044085</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>[-0.10593780130147934, 0.08139060437679291, 0....</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>0</td>
      <td>0.179264</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>[-0.0942290872335434, 0.04106825590133667, 0.2...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>0</td>
      <td>0.016234</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>[-0.11833885312080383, 0.07616469264030457, 0....</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>0</td>
      <td>0.041254</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>[-0.03822258859872818, 0.09719608724117279, 0....</td>
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
    [t-SNE] Computed neighbors for 93 samples in 0.025s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.584190
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 49.847305
    [t-SNE] KL divergence after 900 iterations: 0.055680





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
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>0</td>
      <td>0.107658</td>
      <td>2.966021</td>
      <td>-1.073276</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>0</td>
      <td>0.044085</td>
      <td>3.351823</td>
      <td>-1.000695</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>0</td>
      <td>0.179264</td>
      <td>2.646034</td>
      <td>-0.579950</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>0</td>
      <td>0.016234</td>
      <td>2.663354</td>
      <td>-0.924613</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.1</td>
      <td>0</td>
      <td>0.041254</td>
      <td>1.950294</td>
      <td>-0.564048</td>
    </tr>
  </tbody>
</table>
</div>




    
![png](NodeEmbeddings_files/NodeEmbeddings_18_0.png)
    

