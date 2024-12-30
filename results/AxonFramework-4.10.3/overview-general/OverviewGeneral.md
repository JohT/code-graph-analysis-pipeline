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
      <td>254349</td>
      <td>74.075401</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>13191</td>
      <td>3.841685</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>13029</td>
      <td>3.794504</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Commit]</td>
      <td>12296</td>
      <td>3.581029</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[File, Git]</td>
      <td>10743</td>
      <td>3.128741</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>7176</td>
      <td>2.089904</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>7118</td>
      <td>2.073013</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>3505</td>
      <td>1.020780</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2908</td>
      <td>0.846912</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>2822</td>
      <td>0.821866</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Xml, Element]</td>
      <td>2144</td>
      <td>0.624408</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Java, ByteCode, Member, Method, Constructor]</td>
      <td>2051</td>
      <td>0.597324</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Xml, Text]</td>
      <td>1436</td>
      <td>0.418214</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>1096</td>
      <td>0.319194</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>942</td>
      <td>0.274344</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, File, Java, ByteCode, ResolvedDuplicate...</td>
      <td>899</td>
      <td>0.261821</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>864</td>
      <td>0.251627</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>748</td>
      <td>0.217844</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, Value, ByteCode, Primitive]</td>
      <td>652</td>
      <td>0.189885</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, GenericDeclaration, Member, M...</td>
      <td>569</td>
      <td>0.165713</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Json, Key]</td>
      <td>560</td>
      <td>0.163092</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Value, Json, Scalar]</td>
      <td>544</td>
      <td>0.158432</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, ExternalType]</td>
      <td>396</td>
      <td>0.115329</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Author, Git, Person]</td>
      <td>298</td>
      <td>0.086788</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Value, Array]</td>
      <td>267</td>
      <td>0.077760</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Committer, Git, Person]</td>
      <td>252</td>
      <td>0.073391</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>236</td>
      <td>0.068732</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Value, Property]</td>
      <td>202</td>
      <td>0.058830</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>188</td>
      <td>0.054752</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, Value, ByteCode, Class]</td>
      <td>172</td>
      <td>0.050092</td>
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
      <td>0.000291</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Repository, File, Git]</td>
      <td>1</td>
      <td>0.000291</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Json]</td>
      <td>2</td>
      <td>0.000582</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[File]</td>
      <td>3</td>
      <td>0.000874</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Java, ByteCode, GenericDeclaration, Member, M...</td>
      <td>4</td>
      <td>0.001165</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Maven, Exclusion]</td>
      <td>5</td>
      <td>0.001456</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Value, Array, Json]</td>
      <td>6</td>
      <td>0.001747</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>9</td>
      <td>0.002621</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[File, Maven, Xml, Pom, Document]</td>
      <td>9</td>
      <td>0.002621</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, ManifestSection]</td>
      <td>9</td>
      <td>0.002621</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[File, Java, Manifest]</td>
      <td>9</td>
      <td>0.002621</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Artifact, File, Jar, Archive, Zip, Java]</td>
      <td>9</td>
      <td>0.002621</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[File, Java, ServiceLoader]</td>
      <td>10</td>
      <td>0.002912</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[File, Java, Properties]</td>
      <td>12</td>
      <td>0.003495</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Maven, ExecutionGoal]</td>
      <td>16</td>
      <td>0.004660</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Maven, PluginExecution]</td>
      <td>16</td>
      <td>0.004660</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Xml, Attribute]</td>
      <td>18</td>
      <td>0.005242</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.005533</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Maven, Plugin]</td>
      <td>21</td>
      <td>0.006116</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Maven, Configuration]</td>
      <td>21</td>
      <td>0.006116</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, File, Java, ByteCode, Enum]</td>
      <td>28</td>
      <td>0.008155</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Type, File, Java, ByteCode, PrimitiveType]</td>
      <td>29</td>
      <td>0.008446</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Git, Branch]</td>
      <td>30</td>
      <td>0.008737</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Xml, Namespace]</td>
      <td>36</td>
      <td>0.010484</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, File, Java, ByteCode, Annotation]</td>
      <td>43</td>
      <td>0.012523</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[File, Directory]</td>
      <td>44</td>
      <td>0.012814</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>85</td>
      <td>0.024755</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Artifact, Maven]</td>
      <td>92</td>
      <td>0.026794</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>93</td>
      <td>0.027085</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, ManifestEntry]</td>
      <td>120</td>
      <td>0.034948</td>
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
      <td>278138</td>
      <td>81.003597</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>254349</td>
      <td>74.075401</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Java</td>
      <td>59349</td>
      <td>17.284522</td>
    </tr>
    <tr>
      <th>3</th>
      <td>ByteCode</td>
      <td>59161</td>
      <td>17.229770</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Member</td>
      <td>20262</td>
      <td>5.901009</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Bound</td>
      <td>18456</td>
      <td>5.375038</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Method</td>
      <td>16757</td>
      <td>4.880229</td>
    </tr>
    <tr>
      <th>7</th>
      <td>File</td>
      <td>14599</td>
      <td>4.251744</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Parameter</td>
      <td>13029</td>
      <td>3.794504</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Commit</td>
      <td>12296</td>
      <td>3.581029</td>
    </tr>
    <tr>
      <th>10</th>
      <td>ParameterizedType</td>
      <td>7176</td>
      <td>2.089904</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Value</td>
      <td>5068</td>
      <td>1.475980</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Xml</td>
      <td>3643</td>
      <td>1.060970</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Type</td>
      <td>3618</td>
      <td>1.053689</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Field</td>
      <td>3505</td>
      <td>1.020780</td>
    </tr>
    <tr>
      <th>15</th>
      <td>WildcardType</td>
      <td>2908</td>
      <td>0.846912</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Annotation</td>
      <td>2865</td>
      <td>0.834389</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Element</td>
      <td>2144</td>
      <td>0.624408</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Constructor</td>
      <td>2055</td>
      <td>0.598488</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Text</td>
      <td>1436</td>
      <td>0.418214</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Class</td>
      <td>1272</td>
      <td>0.370451</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Json</td>
      <td>1245</td>
      <td>0.362588</td>
    </tr>
    <tr>
      <th>22</th>
      <td>TypeVariable</td>
      <td>1096</td>
      <td>0.319194</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Lambda</td>
      <td>942</td>
      <td>0.274344</td>
    </tr>
    <tr>
      <th>24</th>
      <td>ResolvedDuplicateType</td>
      <td>899</td>
      <td>0.261821</td>
    </tr>
    <tr>
      <th>25</th>
      <td>GenericDeclaration</td>
      <td>894</td>
      <td>0.260364</td>
    </tr>
    <tr>
      <th>26</th>
      <td>JavaType</td>
      <td>748</td>
      <td>0.217844</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Primitive</td>
      <td>652</td>
      <td>0.189885</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Key</td>
      <td>560</td>
      <td>0.163092</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Person</td>
      <td>550</td>
      <td>0.160179</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Scalar</td>
      <td>544</td>
      <td>0.158432</td>
    </tr>
    <tr>
      <th>31</th>
      <td>ExternalType</td>
      <td>489</td>
      <td>0.142414</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Maven</td>
      <td>343</td>
      <td>0.099894</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Author</td>
      <td>298</td>
      <td>0.086788</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Array</td>
      <td>273</td>
      <td>0.079507</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Interface</td>
      <td>273</td>
      <td>0.079507</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Committer</td>
      <td>252</td>
      <td>0.073391</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Property</td>
      <td>202</td>
      <td>0.058830</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Directory</td>
      <td>183</td>
      <td>0.053296</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Enum</td>
      <td>178</td>
      <td>0.051840</td>
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

    Total number of relationships: 1065593





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
      <td>254349</td>
      <td>23.869245</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>254349</td>
      <td>23.869245</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>166350</td>
      <td>15.611026</td>
    </tr>
    <tr>
      <th>3</th>
      <td>CREATES</td>
      <td>60677</td>
      <td>5.694200</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DELETES</td>
      <td>37782</td>
      <td>3.545631</td>
    </tr>
    <tr>
      <th>5</th>
      <td>INVOKES</td>
      <td>35654</td>
      <td>3.345930</td>
    </tr>
    <tr>
      <th>6</th>
      <td>COMMITTED</td>
      <td>24592</td>
      <td>2.307823</td>
    </tr>
    <tr>
      <th>7</th>
      <td>DEPENDS_ON</td>
      <td>21931</td>
      <td>2.058103</td>
    </tr>
    <tr>
      <th>8</th>
      <td>OF_TYPE</td>
      <td>21394</td>
      <td>2.007708</td>
    </tr>
    <tr>
      <th>9</th>
      <td>DECLARES</td>
      <td>20707</td>
      <td>1.943237</td>
    </tr>
    <tr>
      <th>10</th>
      <td>OF_RAW_TYPE</td>
      <td>17093</td>
      <td>1.604083</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_PARENT</td>
      <td>14944</td>
      <td>1.402412</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS</td>
      <td>14125</td>
      <td>1.325553</td>
    </tr>
    <tr>
      <th>13</th>
      <td>RETURNS</td>
      <td>12578</td>
      <td>1.180376</td>
    </tr>
    <tr>
      <th>14</th>
      <td>HAS_COMMIT</td>
      <td>12296</td>
      <td>1.153911</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_FILE</td>
      <td>10743</td>
      <td>1.008171</td>
    </tr>
    <tr>
      <th>16</th>
      <td>RENAMES</td>
      <td>10460</td>
      <td>0.981613</td>
    </tr>
    <tr>
      <th>17</th>
      <td>READS</td>
      <td>9164</td>
      <td>0.859991</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>8288</td>
      <td>0.777783</td>
    </tr>
    <tr>
      <th>19</th>
      <td>HAS_NEW_NAME</td>
      <td>6212</td>
      <td>0.582962</td>
    </tr>
    <tr>
      <th>20</th>
      <td>OF_GENERIC_TYPE</td>
      <td>5906</td>
      <td>0.554245</td>
    </tr>
    <tr>
      <th>21</th>
      <td>RESOLVES_TO</td>
      <td>5171</td>
      <td>0.485270</td>
    </tr>
    <tr>
      <th>22</th>
      <td>SIMILAR</td>
      <td>3977</td>
      <td>0.373219</td>
    </tr>
    <tr>
      <th>23</th>
      <td>WRITES</td>
      <td>3818</td>
      <td>0.358298</td>
    </tr>
    <tr>
      <th>24</th>
      <td>CONTAINS</td>
      <td>3814</td>
      <td>0.357923</td>
    </tr>
    <tr>
      <th>25</th>
      <td>RETURNS_GENERIC</td>
      <td>3545</td>
      <td>0.332679</td>
    </tr>
    <tr>
      <th>26</th>
      <td>ANNOTATED_BY</td>
      <td>2810</td>
      <td>0.263703</td>
    </tr>
    <tr>
      <th>27</th>
      <td>REQUIRES</td>
      <td>2174</td>
      <td>0.204018</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_FIRST_CHILD</td>
      <td>2144</td>
      <td>0.201203</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_LAST_CHILD</td>
      <td>2144</td>
      <td>0.201203</td>
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
      <td>0.000094</td>
    </tr>
    <tr>
      <th>1</th>
      <td>THROWS_GENERIC</td>
      <td>5</td>
      <td>0.000469</td>
    </tr>
    <tr>
      <th>2</th>
      <td>EXCLUDES</td>
      <td>5</td>
      <td>0.000469</td>
    </tr>
    <tr>
      <th>3</th>
      <td>DESCRIBES</td>
      <td>9</td>
      <td>0.000845</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HAS_ROOT_ELEMENT</td>
      <td>11</td>
      <td>0.001032</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_GOAL</td>
      <td>16</td>
      <td>0.001502</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_EXECUTION</td>
      <td>16</td>
      <td>0.001502</td>
    </tr>
    <tr>
      <th>7</th>
      <td>OF_NAMESPACE</td>
      <td>18</td>
      <td>0.001689</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_ATTRIBUTE</td>
      <td>18</td>
      <td>0.001689</td>
    </tr>
    <tr>
      <th>9</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.001783</td>
    </tr>
    <tr>
      <th>10</th>
      <td>USES_PLUGIN</td>
      <td>21</td>
      <td>0.001971</td>
    </tr>
    <tr>
      <th>11</th>
      <td>REQUIRES_TYPE_PARAMETER</td>
      <td>21</td>
      <td>0.001971</td>
    </tr>
    <tr>
      <th>12</th>
      <td>IS_ARTIFACT</td>
      <td>21</td>
      <td>0.001971</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_CONFIGURATION</td>
      <td>21</td>
      <td>0.001971</td>
    </tr>
    <tr>
      <th>14</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.002628</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_BRANCH</td>
      <td>30</td>
      <td>0.002815</td>
    </tr>
    <tr>
      <th>16</th>
      <td>HAS_HEAD</td>
      <td>31</td>
      <td>0.002909</td>
    </tr>
    <tr>
      <th>17</th>
      <td>DECLARES_NAMESPACE</td>
      <td>36</td>
      <td>0.003378</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_DEFAULT</td>
      <td>36</td>
      <td>0.003378</td>
    </tr>
    <tr>
      <th>19</th>
      <td>CONTAINS_VALUE</td>
      <td>121</td>
      <td>0.011355</td>
    </tr>
    <tr>
      <th>20</th>
      <td>COPY_OF</td>
      <td>126</td>
      <td>0.011824</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_COMPONENT_TYPE</td>
      <td>158</td>
      <td>0.014827</td>
    </tr>
    <tr>
      <th>22</th>
      <td>TO_ARTIFACT</td>
      <td>163</td>
      <td>0.015297</td>
    </tr>
    <tr>
      <th>23</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>163</td>
      <td>0.015297</td>
    </tr>
    <tr>
      <th>24</th>
      <td>ON_COMMIT</td>
      <td>169</td>
      <td>0.015860</td>
    </tr>
    <tr>
      <th>25</th>
      <td>HAS_TAG</td>
      <td>169</td>
      <td>0.015860</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_COMMITTER</td>
      <td>252</td>
      <td>0.023649</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_AUTHOR</td>
      <td>298</td>
      <td>0.027966</td>
    </tr>
    <tr>
      <th>28</th>
      <td>COPIES</td>
      <td>331</td>
      <td>0.031063</td>
    </tr>
    <tr>
      <th>29</th>
      <td>IMPLEMENTS_GENERIC</td>
      <td>373</td>
      <td>0.035004</td>
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
      <td>254349</td>
      <td>12296</td>
      <td>254349</td>
      <td>0.008133</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>254349</td>
      <td>254349</td>
      <td>10743</td>
      <td>0.009308</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>166350</td>
      <td>254349</td>
      <td>10743</td>
      <td>0.006088</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>60677</td>
      <td>254349</td>
      <td>10743</td>
      <td>0.002221</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>37782</td>
      <td>254349</td>
      <td>10743</td>
      <td>0.001383</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>21702</td>
      <td>13097</td>
      <td>13097</td>
      <td>0.012652</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>14935</td>
      <td>12296</td>
      <td>12296</td>
      <td>0.009878</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>12296</td>
      <td>1</td>
      <td>12296</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>12296</td>
      <td>298</td>
      <td>12296</td>
      <td>0.335570</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>12296</td>
      <td>252</td>
      <td>12296</td>
      <td>0.396825</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_FILE</td>
      <td>[File, Git]</td>
      <td>10743</td>
      <td>1</td>
      <td>10743</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>10460</td>
      <td>254349</td>
      <td>10743</td>
      <td>0.000383</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>8362</td>
      <td>13097</td>
      <td>13029</td>
      <td>0.004900</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>READS</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>8218</td>
      <td>13097</td>
      <td>3505</td>
      <td>0.017902</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>6371</td>
      <td>13029</td>
      <td>748</td>
      <td>0.065372</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>6212</td>
      <td>10743</td>
      <td>10743</td>
      <td>0.005382</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>DECLARES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>5108</td>
      <td>814</td>
      <td>13097</td>
      <td>0.047913</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>DEPENDS_ON</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>4481</td>
      <td>814</td>
      <td>748</td>
      <td>0.735951</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3570</td>
      <td>7118</td>
      <td>748</td>
      <td>0.067052</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3053</td>
      <td>7176</td>
      <td>748</td>
      <td>0.056878</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2908</td>
      <td>7176</td>
      <td>2908</td>
      <td>0.013935</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>2657</td>
      <td>13029</td>
      <td>7176</td>
      <td>0.002842</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>2454</td>
      <td>7176</td>
      <td>1096</td>
      <td>0.031202</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Java, ByteCode, Member, Method, Constructor]</td>
      <td>WRITES</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>2438</td>
      <td>2051</td>
      <td>3505</td>
      <td>0.033914</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>2341</td>
      <td>2822</td>
      <td>93</td>
      <td>0.891993</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>DECLARES</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>2204</td>
      <td>814</td>
      <td>3505</td>
      <td>0.077250</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Xml, Element]</td>
      <td>HAS_ELEMENT</td>
      <td>[Xml, Element]</td>
      <td>2126</td>
      <td>2144</td>
      <td>2144</td>
      <td>0.046250</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Java, ByteCode, Member, Method, Constructor]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method, Constructor]</td>
      <td>2118</td>
      <td>2051</td>
      <td>2051</td>
      <td>0.050349</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>DECLARES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>2115</td>
      <td>231</td>
      <td>13097</td>
      <td>0.069908</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>2091</td>
      <td>13097</td>
      <td>748</td>
      <td>0.021344</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 343365
    total_number_of_relationships (edges): 1065593
    -> total directed graph density: 9.038171438218179e-06
    -> total directed graph density in percent: 0.0009038171438218179

