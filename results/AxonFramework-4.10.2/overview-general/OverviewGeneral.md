# Overview in General
<br>  

This file contains a general overview of the data in the graph including node labels and relationships types.

### References
- [jqassistant](https://jqassistant.org)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)





## Node Labels

### Table 1a - Highest node count by label combination

Lists the 30 label combinations with the highest number of nodes. The labels with the lowest node count are listed in table 1b.
The total list would sum up to the total number of labels (100%).

The whole table can be found in the CSV report `Node_label_combination_count`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>nodeLabels</th>
      <th>nodesWithThatLabels</th>
      <th>nodesWithThatLabelsPercent</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>[Git, Change]</td>
      <td>246598</td>
      <td>73.539999</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>13200</td>
      <td>3.936480</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>13016</td>
      <td>3.881607</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Commit]</td>
      <td>12102</td>
      <td>3.609036</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[File, Git]</td>
      <td>10690</td>
      <td>3.187952</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, ParameterizedType, Bound]</td>
      <td>7172</td>
      <td>2.138821</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>7113</td>
      <td>2.121226</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>3503</td>
      <td>1.044658</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2908</td>
      <td>0.867218</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>2822</td>
      <td>0.841572</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Xml, Element]</td>
      <td>2144</td>
      <td>0.639380</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>2044</td>
      <td>0.609558</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Xml, Text]</td>
      <td>1436</td>
      <td>0.428241</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>1096</td>
      <td>0.326847</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>938</td>
      <td>0.279729</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, File, Java, ByteCode, ResolvedDuplicate...</td>
      <td>900</td>
      <td>0.268396</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>861</td>
      <td>0.256766</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>748</td>
      <td>0.223067</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, Value, ByteCode, Primitive]</td>
      <td>650</td>
      <td>0.193842</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, Member, Method, GenericDeclar...</td>
      <td>569</td>
      <td>0.169686</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Json, Key]</td>
      <td>560</td>
      <td>0.167002</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Value, Json, Scalar]</td>
      <td>544</td>
      <td>0.162231</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, ExternalType]</td>
      <td>396</td>
      <td>0.118094</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Author, Git, Person]</td>
      <td>293</td>
      <td>0.087378</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Value, Array]</td>
      <td>267</td>
      <td>0.079624</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Committer, Git, Person]</td>
      <td>248</td>
      <td>0.073958</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>236</td>
      <td>0.070379</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Value, Property]</td>
      <td>202</td>
      <td>0.060240</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>187</td>
      <td>0.055767</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, Value, ByteCode, Class]</td>
      <td>172</td>
      <td>0.051294</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 1a - Highest node count by label combination

Values under 0.5% will be grouped into "others" to get a cleaner plot. The group "others" is then broken down in Chart 1b.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_15_1.png)
    


### Table 1b - Lowest node count by label combination

Lists the 30 label combinations with the lowest number of nodes until they reach 0.5% of the total node count, which are shown above.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>nodeLabels</th>
      <th>nodesWithThatLabels</th>
      <th>nodesWithThatLabelsPercent</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>[Analyze, Task, jQAssistant]</td>
      <td>1</td>
      <td>0.000298</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Repository, File, Git]</td>
      <td>1</td>
      <td>0.000298</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Json]</td>
      <td>2</td>
      <td>0.000596</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[File]</td>
      <td>3</td>
      <td>0.000895</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Java, ByteCode, Member, Constructor, Method, ...</td>
      <td>4</td>
      <td>0.001193</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Maven, Exclusion]</td>
      <td>5</td>
      <td>0.001491</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Value, Json, Array]</td>
      <td>6</td>
      <td>0.001789</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[File, Maven, Xml, Pom, Document]</td>
      <td>9</td>
      <td>0.002684</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>9</td>
      <td>0.002684</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, ManifestSection]</td>
      <td>9</td>
      <td>0.002684</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[File, Java, Manifest]</td>
      <td>9</td>
      <td>0.002684</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Artifact, File, Jar, Archive, Zip, Java]</td>
      <td>9</td>
      <td>0.002684</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[File, Java, ServiceLoader]</td>
      <td>10</td>
      <td>0.002982</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[File, Java, Properties]</td>
      <td>12</td>
      <td>0.003579</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Maven, ExecutionGoal]</td>
      <td>16</td>
      <td>0.004771</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Maven, PluginExecution]</td>
      <td>16</td>
      <td>0.004771</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Xml, Attribute]</td>
      <td>18</td>
      <td>0.005368</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.005666</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Maven, Plugin]</td>
      <td>21</td>
      <td>0.006263</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Maven, Configuration]</td>
      <td>21</td>
      <td>0.006263</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, File, Java, ByteCode, Enum]</td>
      <td>28</td>
      <td>0.008350</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Git, Branch]</td>
      <td>29</td>
      <td>0.008648</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, PrimitiveType]</td>
      <td>29</td>
      <td>0.008648</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Xml, Namespace]</td>
      <td>36</td>
      <td>0.010736</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, File, Java, ByteCode, Annotation]</td>
      <td>43</td>
      <td>0.012823</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[File, Directory]</td>
      <td>44</td>
      <td>0.013122</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>85</td>
      <td>0.025349</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Artifact, Maven]</td>
      <td>92</td>
      <td>0.027436</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>93</td>
      <td>0.027734</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, ManifestEntry]</td>
      <td>120</td>
      <td>0.035786</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 1b - Lowest node count by label combination

Shows the lowest (less than 0.5% overall) node count label combinations. Therefore, this plot breaks down the "others" slice of the pie chart above. Values under 0.01% will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_19_1.png)
    


### Table 1c - Highest node count by single label

Lists the 40 labels with the highest number of nodes.
Doesn't sum up to the total number of nodes or 100% because one node can have multiple labels.
Helps to identify commonly used labels.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>nodeLabel</th>
      <th>nodesWithThatLabel</th>
      <th>nodesWithThatLabelPercent</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Git</td>
      <td>270129</td>
      <td>80.557370</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>246598</td>
      <td>73.539999</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Java</td>
      <td>59318</td>
      <td>17.689704</td>
    </tr>
    <tr>
      <th>3</th>
      <td>ByteCode</td>
      <td>59130</td>
      <td>17.633639</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Member</td>
      <td>20258</td>
      <td>6.041303</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Bound</td>
      <td>18447</td>
      <td>5.501230</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Method</td>
      <td>16755</td>
      <td>4.996645</td>
    </tr>
    <tr>
      <th>7</th>
      <td>File</td>
      <td>14543</td>
      <td>4.336987</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Parameter</td>
      <td>13016</td>
      <td>3.881607</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Commit</td>
      <td>12102</td>
      <td>3.609036</td>
    </tr>
    <tr>
      <th>10</th>
      <td>ParameterizedType</td>
      <td>7172</td>
      <td>2.138821</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Value</td>
      <td>5066</td>
      <td>1.510773</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Xml</td>
      <td>3643</td>
      <td>1.086409</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Type</td>
      <td>3615</td>
      <td>1.078059</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Field</td>
      <td>3503</td>
      <td>1.044658</td>
    </tr>
    <tr>
      <th>15</th>
      <td>WildcardType</td>
      <td>2908</td>
      <td>0.867218</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Annotation</td>
      <td>2865</td>
      <td>0.854395</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Element</td>
      <td>2144</td>
      <td>0.639380</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Constructor</td>
      <td>2048</td>
      <td>0.610751</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Text</td>
      <td>1436</td>
      <td>0.428241</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Class</td>
      <td>1269</td>
      <td>0.378439</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Json</td>
      <td>1245</td>
      <td>0.371282</td>
    </tr>
    <tr>
      <th>22</th>
      <td>TypeVariable</td>
      <td>1096</td>
      <td>0.326847</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Lambda</td>
      <td>938</td>
      <td>0.279729</td>
    </tr>
    <tr>
      <th>24</th>
      <td>ResolvedDuplicateType</td>
      <td>900</td>
      <td>0.268396</td>
    </tr>
    <tr>
      <th>25</th>
      <td>GenericDeclaration</td>
      <td>894</td>
      <td>0.266607</td>
    </tr>
    <tr>
      <th>26</th>
      <td>JavaType</td>
      <td>748</td>
      <td>0.223067</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Primitive</td>
      <td>650</td>
      <td>0.193842</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Key</td>
      <td>560</td>
      <td>0.167002</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Scalar</td>
      <td>544</td>
      <td>0.162231</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Person</td>
      <td>541</td>
      <td>0.161336</td>
    </tr>
    <tr>
      <th>31</th>
      <td>ExternalType</td>
      <td>489</td>
      <td>0.145829</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Maven</td>
      <td>343</td>
      <td>0.102289</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Author</td>
      <td>293</td>
      <td>0.087378</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Array</td>
      <td>273</td>
      <td>0.081414</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Interface</td>
      <td>272</td>
      <td>0.081115</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Committer</td>
      <td>248</td>
      <td>0.073958</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Property</td>
      <td>202</td>
      <td>0.060240</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Directory</td>
      <td>183</td>
      <td>0.054574</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Enum</td>
      <td>178</td>
      <td>0.053083</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 1c - Highest node count by label

Shows the 40 labels with the highest number of nodes.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_23_1.png)
    


## Relationship Types

### Table 2a - Highest relationship count by type

Lists the 30 relationship types with the highest number of occurrences.
The whole table can be found in the CSV report `Relationship_type_count`.

    Total number of relationships: 1040246





<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>relationshipType</th>
      <th>nodesWithThatRelationshipType</th>
      <th>nodesWithThatRelationshipTypePercent</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>CONTAINS_CHANGE</td>
      <td>246598</td>
      <td>23.705739</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>246598</td>
      <td>23.705739</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>159927</td>
      <td>15.373960</td>
    </tr>
    <tr>
      <th>3</th>
      <td>CREATES</td>
      <td>59754</td>
      <td>5.744218</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DELETES</td>
      <td>37207</td>
      <td>3.576750</td>
    </tr>
    <tr>
      <th>5</th>
      <td>INVOKES</td>
      <td>35677</td>
      <td>3.429670</td>
    </tr>
    <tr>
      <th>6</th>
      <td>COMMITTED</td>
      <td>24204</td>
      <td>2.326757</td>
    </tr>
    <tr>
      <th>7</th>
      <td>DEPENDS_ON</td>
      <td>21887</td>
      <td>2.104022</td>
    </tr>
    <tr>
      <th>8</th>
      <td>OF_TYPE</td>
      <td>21373</td>
      <td>2.054610</td>
    </tr>
    <tr>
      <th>9</th>
      <td>DECLARES</td>
      <td>20699</td>
      <td>1.989818</td>
    </tr>
    <tr>
      <th>10</th>
      <td>OF_RAW_TYPE</td>
      <td>17084</td>
      <td>1.642304</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_PARENT</td>
      <td>14710</td>
      <td>1.414089</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS</td>
      <td>14110</td>
      <td>1.356410</td>
    </tr>
    <tr>
      <th>13</th>
      <td>RETURNS</td>
      <td>12562</td>
      <td>1.207599</td>
    </tr>
    <tr>
      <th>14</th>
      <td>HAS_COMMIT</td>
      <td>12102</td>
      <td>1.163379</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_FILE</td>
      <td>10690</td>
      <td>1.027642</td>
    </tr>
    <tr>
      <th>16</th>
      <td>RENAMES</td>
      <td>10290</td>
      <td>0.989189</td>
    </tr>
    <tr>
      <th>17</th>
      <td>READS</td>
      <td>9097</td>
      <td>0.874505</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>8284</td>
      <td>0.796350</td>
    </tr>
    <tr>
      <th>19</th>
      <td>HAS_NEW_NAME</td>
      <td>6199</td>
      <td>0.595917</td>
    </tr>
    <tr>
      <th>20</th>
      <td>OF_GENERIC_TYPE</td>
      <td>5903</td>
      <td>0.567462</td>
    </tr>
    <tr>
      <th>21</th>
      <td>RESOLVES_TO</td>
      <td>5204</td>
      <td>0.500266</td>
    </tr>
    <tr>
      <th>22</th>
      <td>SIMILAR</td>
      <td>3968</td>
      <td>0.381448</td>
    </tr>
    <tr>
      <th>23</th>
      <td>WRITES</td>
      <td>3812</td>
      <td>0.366452</td>
    </tr>
    <tr>
      <th>24</th>
      <td>CONTAINS</td>
      <td>3806</td>
      <td>0.365875</td>
    </tr>
    <tr>
      <th>25</th>
      <td>RETURNS_GENERIC</td>
      <td>3543</td>
      <td>0.340593</td>
    </tr>
    <tr>
      <th>26</th>
      <td>ANNOTATED_BY</td>
      <td>2810</td>
      <td>0.270128</td>
    </tr>
    <tr>
      <th>27</th>
      <td>REQUIRES</td>
      <td>2175</td>
      <td>0.209085</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_FIRST_CHILD</td>
      <td>2144</td>
      <td>0.206105</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_LAST_CHILD</td>
      <td>2144</td>
      <td>0.206105</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 2a - Highest relationship count by type

Values under 0.5% will be grouped into "others" to get a cleaner plot. The group "others" is then broken down in the second chart.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_28_1.png)
    


### Table 2b - Lowest relationship count by type

Lists the 30 relationships type with the lowest number of occurrences up to 0.5% of the total node count. This is essentially breaking down the "others" slice from the chart above.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>relationshipType</th>
      <th>nodesWithThatRelationshipType</th>
      <th>nodesWithThatRelationshipTypePercent</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>HAS_PROPERTY</td>
      <td>1</td>
      <td>0.000096</td>
    </tr>
    <tr>
      <th>1</th>
      <td>THROWS_GENERIC</td>
      <td>5</td>
      <td>0.000481</td>
    </tr>
    <tr>
      <th>2</th>
      <td>EXCLUDES</td>
      <td>5</td>
      <td>0.000481</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HAS_ROOT_ELEMENT</td>
      <td>9</td>
      <td>0.000865</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DESCRIBES</td>
      <td>9</td>
      <td>0.000865</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_GOAL</td>
      <td>16</td>
      <td>0.001538</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_EXECUTION</td>
      <td>16</td>
      <td>0.001538</td>
    </tr>
    <tr>
      <th>7</th>
      <td>OF_NAMESPACE</td>
      <td>18</td>
      <td>0.001730</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_ATTRIBUTE</td>
      <td>18</td>
      <td>0.001730</td>
    </tr>
    <tr>
      <th>9</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.001826</td>
    </tr>
    <tr>
      <th>10</th>
      <td>USES_PLUGIN</td>
      <td>21</td>
      <td>0.002019</td>
    </tr>
    <tr>
      <th>11</th>
      <td>REQUIRES_TYPE_PARAMETER</td>
      <td>21</td>
      <td>0.002019</td>
    </tr>
    <tr>
      <th>12</th>
      <td>IS_ARTIFACT</td>
      <td>21</td>
      <td>0.002019</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_CONFIGURATION</td>
      <td>21</td>
      <td>0.002019</td>
    </tr>
    <tr>
      <th>14</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.002692</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_BRANCH</td>
      <td>29</td>
      <td>0.002788</td>
    </tr>
    <tr>
      <th>16</th>
      <td>HAS_HEAD</td>
      <td>30</td>
      <td>0.002884</td>
    </tr>
    <tr>
      <th>17</th>
      <td>DECLARES_NAMESPACE</td>
      <td>36</td>
      <td>0.003461</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_DEFAULT</td>
      <td>36</td>
      <td>0.003461</td>
    </tr>
    <tr>
      <th>19</th>
      <td>CONTAINS_VALUE</td>
      <td>121</td>
      <td>0.011632</td>
    </tr>
    <tr>
      <th>20</th>
      <td>COPY_OF</td>
      <td>126</td>
      <td>0.012113</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_COMPONENT_TYPE</td>
      <td>158</td>
      <td>0.015189</td>
    </tr>
    <tr>
      <th>22</th>
      <td>TO_ARTIFACT</td>
      <td>163</td>
      <td>0.015669</td>
    </tr>
    <tr>
      <th>23</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>163</td>
      <td>0.015669</td>
    </tr>
    <tr>
      <th>24</th>
      <td>ON_COMMIT</td>
      <td>168</td>
      <td>0.016150</td>
    </tr>
    <tr>
      <th>25</th>
      <td>HAS_TAG</td>
      <td>168</td>
      <td>0.016150</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_COMMITTER</td>
      <td>248</td>
      <td>0.023841</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_AUTHOR</td>
      <td>293</td>
      <td>0.028166</td>
    </tr>
    <tr>
      <th>28</th>
      <td>COPIES</td>
      <td>328</td>
      <td>0.031531</td>
    </tr>
    <tr>
      <th>29</th>
      <td>IMPLEMENTS_GENERIC</td>
      <td>373</td>
      <td>0.035857</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 2b - Lowest relationship count by type

Shows the lowest (less than 0.5% overall) relationship types. This plot breaks down the "others" slice of the pie chart above. Values under 0.01% will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_32_1.png)
    


## Node labels with their relationships

### Table 3a - Highest relationship count by node labels and relationship type

Lists the 30 node labels and their relationship types with the highest number of occurrences.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>sourceLabels</th>
      <th>relationType</th>
      <th>targetLabels</th>
      <th>numberOfRelationships</th>
      <th>numberOfNodesWithSameLabelsAsSource</th>
      <th>numberOfNodesWithSameLabelsAsTarget</th>
      <th>densityInPercent</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>[Git, Commit]</td>
      <td>CONTAINS_CHANGE</td>
      <td>[Git, Change]</td>
      <td>246598</td>
      <td>12102</td>
      <td>246598</td>
      <td>0.008263</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>246598</td>
      <td>246598</td>
      <td>10690</td>
      <td>0.009355</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>159927</td>
      <td>246598</td>
      <td>10690</td>
      <td>0.006067</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>59754</td>
      <td>246598</td>
      <td>10690</td>
      <td>0.002267</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>37207</td>
      <td>246598</td>
      <td>10690</td>
      <td>0.001411</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>21552</td>
      <td>13074</td>
      <td>13074</td>
      <td>0.012609</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>14701</td>
      <td>12102</td>
      <td>12102</td>
      <td>0.010038</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>12102</td>
      <td>1</td>
      <td>12102</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>12102</td>
      <td>293</td>
      <td>12102</td>
      <td>0.341297</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>12102</td>
      <td>248</td>
      <td>12102</td>
      <td>0.403226</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_FILE</td>
      <td>[File, Git]</td>
      <td>10690</td>
      <td>1</td>
      <td>10690</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>10290</td>
      <td>246598</td>
      <td>10690</td>
      <td>0.000390</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>8320</td>
      <td>13074</td>
      <td>13016</td>
      <td>0.004889</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>READS</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>8121</td>
      <td>13074</td>
      <td>3503</td>
      <td>0.017732</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>6368</td>
      <td>13016</td>
      <td>748</td>
      <td>0.065407</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>6199</td>
      <td>10690</td>
      <td>10690</td>
      <td>0.005425</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3570</td>
      <td>7113</td>
      <td>748</td>
      <td>0.067099</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Java, ByteCode, ParameterizedType, Bound]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3049</td>
      <td>7172</td>
      <td>748</td>
      <td>0.056835</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, ByteCode, ParameterizedType, Bound]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2908</td>
      <td>7172</td>
      <td>2908</td>
      <td>0.013943</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, ParameterizedType, Bound]</td>
      <td>2655</td>
      <td>13016</td>
      <td>7172</td>
      <td>0.002844</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Java, ByteCode, ParameterizedType, Bound]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>2454</td>
      <td>7172</td>
      <td>1096</td>
      <td>0.031219</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>WRITES</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>2432</td>
      <td>2044</td>
      <td>3503</td>
      <td>0.033966</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>2341</td>
      <td>2822</td>
      <td>93</td>
      <td>0.891993</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Xml, Element]</td>
      <td>HAS_ELEMENT</td>
      <td>[Xml, Element]</td>
      <td>2126</td>
      <td>2144</td>
      <td>2144</td>
      <td>0.046250</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>2113</td>
      <td>2044</td>
      <td>2044</td>
      <td>0.050575</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>2088</td>
      <td>13074</td>
      <td>748</td>
      <td>0.021351</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>2029</td>
      <td>13074</td>
      <td>2044</td>
      <td>0.007593</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>2023</td>
      <td>2044</td>
      <td>13016</td>
      <td>0.007604</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>2023</td>
      <td>13016</td>
      <td>7113</td>
      <td>0.002185</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1879</td>
      <td>938</td>
      <td>13074</td>
      <td>0.015322</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 335325
    total_number_of_relationships (edges): 1040246
    -> total directed graph density: 9.251357913577467e-06
    -> total directed graph density in percent: 0.0009251357913577467

