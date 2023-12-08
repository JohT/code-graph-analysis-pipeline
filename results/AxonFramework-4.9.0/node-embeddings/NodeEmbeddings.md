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
      <td>org.axonframework.commandhandling</td>
      <td>0</td>
      <td>0.062492</td>
      <td>axon-messaging-4.9.0</td>
      <td>[0.10886185616254807, -0.0904235988855362, -0....</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>0</td>
      <td>0.019602</td>
      <td>axon-messaging-4.9.0</td>
      <td>[0.20682232081890106, -0.07204115390777588, -0...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>0</td>
      <td>0.028509</td>
      <td>axon-messaging-4.9.0</td>
      <td>[0.10303518176078796, -0.07290735095739365, -0...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>0</td>
      <td>0.018051</td>
      <td>axon-messaging-4.9.0</td>
      <td>[0.10667519271373749, -0.010812338441610336, -...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>0</td>
      <td>0.016234</td>
      <td>axon-messaging-4.9.0</td>
      <td>[0.19502374529838562, -0.09658371657133102, -0...</td>
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
    [t-SNE] Computed neighbors for 93 samples in 0.054s...
    [t-SNE] Computed conditional probabilities for sample 93 / 93
    [t-SNE] Mean sigma: 0.550452
    [t-SNE] KL divergence after 250 iterations with early exaggeration: 49.284126
    [t-SNE] KL divergence after 750 iterations: 0.070199





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
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.9.0</td>
      <td>0</td>
      <td>0.062492</td>
      <td>-5.806868</td>
      <td>-1.147245</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.9.0</td>
      <td>0</td>
      <td>0.019602</td>
      <td>-6.504912</td>
      <td>-0.813952</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>axon-messaging-4.9.0</td>
      <td>0</td>
      <td>0.028509</td>
      <td>-5.372363</td>
      <td>-1.015420</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.9.0</td>
      <td>0</td>
      <td>0.018051</td>
      <td>-6.155689</td>
      <td>-0.587476</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>axon-messaging-4.9.0</td>
      <td>0</td>
      <td>0.016234</td>
      <td>-6.143025</td>
      <td>-1.031680</td>
    </tr>
  </tbody>
</table>
</div>




    
![png](NodeEmbeddings_files/NodeEmbeddings_18_0.png)
    

