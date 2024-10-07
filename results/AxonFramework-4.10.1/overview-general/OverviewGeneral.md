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
      <td>240725</td>
      <td>73.160910</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>13180</td>
      <td>4.005653</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>13000</td>
      <td>3.950947</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Commit]</td>
      <td>11850</td>
      <td>3.601441</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[File, Git]</td>
      <td>10613</td>
      <td>3.225493</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>7166</td>
      <td>2.177884</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>7112</td>
      <td>2.161472</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>3490</td>
      <td>1.060677</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2906</td>
      <td>0.883189</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>2821</td>
      <td>0.857356</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Xml, Element]</td>
      <td>2144</td>
      <td>0.651602</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>2039</td>
      <td>0.619691</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Xml, Text]</td>
      <td>1436</td>
      <td>0.436428</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>1096</td>
      <td>0.333095</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>936</td>
      <td>0.284468</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, File, Java, ByteCode, ResolvedDuplicate...</td>
      <td>900</td>
      <td>0.273527</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>861</td>
      <td>0.261674</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>746</td>
      <td>0.226724</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, Value, ByteCode, Primitive]</td>
      <td>650</td>
      <td>0.197547</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, GenericDeclaration, Member, M...</td>
      <td>569</td>
      <td>0.172930</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Json, Key]</td>
      <td>555</td>
      <td>0.168675</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Value, Json, Scalar]</td>
      <td>539</td>
      <td>0.163812</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, ExternalType]</td>
      <td>396</td>
      <td>0.120352</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Author, Git, Person]</td>
      <td>290</td>
      <td>0.088137</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Value, Array]</td>
      <td>267</td>
      <td>0.081146</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Committer, Git, Person]</td>
      <td>244</td>
      <td>0.074156</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>236</td>
      <td>0.071725</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Value, Property]</td>
      <td>202</td>
      <td>0.061392</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>187</td>
      <td>0.056833</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, Value, ByteCode, Class]</td>
      <td>172</td>
      <td>0.052274</td>
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
      <td>0.000304</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[File, TS, Scan]</td>
      <td>1</td>
      <td>0.000304</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Json]</td>
      <td>2</td>
      <td>0.000608</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[File]</td>
      <td>3</td>
      <td>0.000912</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Java, ByteCode, GenericDeclaration, Member, C...</td>
      <td>4</td>
      <td>0.001216</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Maven, Exclusion]</td>
      <td>5</td>
      <td>0.001520</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Value, Array, Json]</td>
      <td>6</td>
      <td>0.001824</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>9</td>
      <td>0.002735</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[File, Maven, Xml, Pom, Document]</td>
      <td>9</td>
      <td>0.002735</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, ManifestSection]</td>
      <td>9</td>
      <td>0.002735</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[File, Java, Manifest]</td>
      <td>9</td>
      <td>0.002735</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Artifact, File, Jar, Archive, Zip, Java]</td>
      <td>9</td>
      <td>0.002735</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[File, Java, ServiceLoader]</td>
      <td>10</td>
      <td>0.003039</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[File, Java, Properties]</td>
      <td>12</td>
      <td>0.003647</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Maven, ExecutionGoal]</td>
      <td>16</td>
      <td>0.004863</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Maven, PluginExecution]</td>
      <td>16</td>
      <td>0.004863</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Xml, Attribute]</td>
      <td>18</td>
      <td>0.005471</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.005774</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Maven, Plugin]</td>
      <td>21</td>
      <td>0.006382</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Maven, Configuration]</td>
      <td>21</td>
      <td>0.006382</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Git, Branch]</td>
      <td>28</td>
      <td>0.008510</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Type, File, Java, ByteCode, Enum]</td>
      <td>28</td>
      <td>0.008510</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, PrimitiveType]</td>
      <td>29</td>
      <td>0.008814</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Xml, Namespace]</td>
      <td>36</td>
      <td>0.010941</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, File, Java, ByteCode, Annotation]</td>
      <td>43</td>
      <td>0.013069</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[File, Directory]</td>
      <td>44</td>
      <td>0.013372</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>85</td>
      <td>0.025833</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Artifact, Maven]</td>
      <td>92</td>
      <td>0.027961</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>93</td>
      <td>0.028264</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, ManifestEntry]</td>
      <td>120</td>
      <td>0.036470</td>
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
      <td>263917</td>
      <td>80.209400</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>240725</td>
      <td>73.160910</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Java</td>
      <td>59250</td>
      <td>18.007203</td>
    </tr>
    <tr>
      <th>3</th>
      <td>ByteCode</td>
      <td>59062</td>
      <td>17.950066</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Member</td>
      <td>20218</td>
      <td>6.144635</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Bound</td>
      <td>18438</td>
      <td>5.603659</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Method</td>
      <td>16728</td>
      <td>5.083958</td>
    </tr>
    <tr>
      <th>7</th>
      <td>File</td>
      <td>14464</td>
      <td>4.395885</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Parameter</td>
      <td>13000</td>
      <td>3.950947</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Commit</td>
      <td>11850</td>
      <td>3.601441</td>
    </tr>
    <tr>
      <th>10</th>
      <td>ParameterizedType</td>
      <td>7166</td>
      <td>2.177884</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Value</td>
      <td>5059</td>
      <td>1.537526</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Xml</td>
      <td>3643</td>
      <td>1.107177</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Type</td>
      <td>3613</td>
      <td>1.098059</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Field</td>
      <td>3490</td>
      <td>1.060677</td>
    </tr>
    <tr>
      <th>15</th>
      <td>WildcardType</td>
      <td>2906</td>
      <td>0.883189</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Annotation</td>
      <td>2864</td>
      <td>0.870424</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Element</td>
      <td>2144</td>
      <td>0.651602</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Constructor</td>
      <td>2043</td>
      <td>0.620907</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Text</td>
      <td>1436</td>
      <td>0.436428</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Class</td>
      <td>1269</td>
      <td>0.385673</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Json</td>
      <td>1234</td>
      <td>0.375036</td>
    </tr>
    <tr>
      <th>22</th>
      <td>TypeVariable</td>
      <td>1096</td>
      <td>0.333095</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Lambda</td>
      <td>936</td>
      <td>0.284468</td>
    </tr>
    <tr>
      <th>24</th>
      <td>ResolvedDuplicateType</td>
      <td>900</td>
      <td>0.273527</td>
    </tr>
    <tr>
      <th>25</th>
      <td>GenericDeclaration</td>
      <td>894</td>
      <td>0.271704</td>
    </tr>
    <tr>
      <th>26</th>
      <td>JavaType</td>
      <td>746</td>
      <td>0.226724</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Primitive</td>
      <td>650</td>
      <td>0.197547</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Key</td>
      <td>555</td>
      <td>0.168675</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Scalar</td>
      <td>539</td>
      <td>0.163812</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Person</td>
      <td>534</td>
      <td>0.162293</td>
    </tr>
    <tr>
      <th>31</th>
      <td>ExternalType</td>
      <td>489</td>
      <td>0.148616</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Maven</td>
      <td>343</td>
      <td>0.104244</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Author</td>
      <td>290</td>
      <td>0.088137</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Array</td>
      <td>273</td>
      <td>0.082970</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Interface</td>
      <td>272</td>
      <td>0.082666</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Committer</td>
      <td>244</td>
      <td>0.074156</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Property</td>
      <td>202</td>
      <td>0.061392</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Directory</td>
      <td>183</td>
      <td>0.055617</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Enum</td>
      <td>178</td>
      <td>0.054098</td>
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

    Total number of relationships: 997713





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
      <td>240725</td>
      <td>24.127680</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>240725</td>
      <td>24.127680</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>155355</td>
      <td>15.571111</td>
    </tr>
    <tr>
      <th>3</th>
      <td>CREATES</td>
      <td>58825</td>
      <td>5.895984</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DELETES</td>
      <td>36675</td>
      <td>3.675907</td>
    </tr>
    <tr>
      <th>5</th>
      <td>INVOKES</td>
      <td>35593</td>
      <td>3.567459</td>
    </tr>
    <tr>
      <th>6</th>
      <td>COMMITTED</td>
      <td>23700</td>
      <td>2.375433</td>
    </tr>
    <tr>
      <th>7</th>
      <td>DEPENDS_ON</td>
      <td>21873</td>
      <td>2.192314</td>
    </tr>
    <tr>
      <th>8</th>
      <td>OF_TYPE</td>
      <td>21347</td>
      <td>2.139593</td>
    </tr>
    <tr>
      <th>9</th>
      <td>DECLARES</td>
      <td>20659</td>
      <td>2.070636</td>
    </tr>
    <tr>
      <th>10</th>
      <td>OF_RAW_TYPE</td>
      <td>17077</td>
      <td>1.711614</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_PARENT</td>
      <td>14409</td>
      <td>1.444203</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS</td>
      <td>14094</td>
      <td>1.412631</td>
    </tr>
    <tr>
      <th>13</th>
      <td>RETURNS</td>
      <td>12547</td>
      <td>1.257576</td>
    </tr>
    <tr>
      <th>14</th>
      <td>RENAMES</td>
      <td>10130</td>
      <td>1.015322</td>
    </tr>
    <tr>
      <th>15</th>
      <td>READS</td>
      <td>9078</td>
      <td>0.909881</td>
    </tr>
    <tr>
      <th>16</th>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>8276</td>
      <td>0.829497</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_NEW_NAME</td>
      <td>6177</td>
      <td>0.619116</td>
    </tr>
    <tr>
      <th>18</th>
      <td>OF_GENERIC_TYPE</td>
      <td>5902</td>
      <td>0.591553</td>
    </tr>
    <tr>
      <th>19</th>
      <td>RESOLVES_TO</td>
      <td>5228</td>
      <td>0.523998</td>
    </tr>
    <tr>
      <th>20</th>
      <td>SIMILAR</td>
      <td>3968</td>
      <td>0.397710</td>
    </tr>
    <tr>
      <th>21</th>
      <td>CONTAINS</td>
      <td>3805</td>
      <td>0.381372</td>
    </tr>
    <tr>
      <th>22</th>
      <td>WRITES</td>
      <td>3803</td>
      <td>0.381172</td>
    </tr>
    <tr>
      <th>23</th>
      <td>RETURNS_GENERIC</td>
      <td>3543</td>
      <td>0.355112</td>
    </tr>
    <tr>
      <th>24</th>
      <td>ANNOTATED_BY</td>
      <td>2809</td>
      <td>0.281544</td>
    </tr>
    <tr>
      <th>25</th>
      <td>REQUIRES</td>
      <td>2173</td>
      <td>0.217798</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_FIRST_CHILD</td>
      <td>2144</td>
      <td>0.214891</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_LAST_CHILD</td>
      <td>2144</td>
      <td>0.214891</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_ELEMENT</td>
      <td>2126</td>
      <td>0.213087</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_UPPER_BOUND</td>
      <td>1521</td>
      <td>0.152449</td>
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
      <td>0.000100</td>
    </tr>
    <tr>
      <th>1</th>
      <td>THROWS_GENERIC</td>
      <td>5</td>
      <td>0.000501</td>
    </tr>
    <tr>
      <th>2</th>
      <td>EXCLUDES</td>
      <td>5</td>
      <td>0.000501</td>
    </tr>
    <tr>
      <th>3</th>
      <td>DESCRIBES</td>
      <td>9</td>
      <td>0.000902</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HAS_ROOT_ELEMENT</td>
      <td>10</td>
      <td>0.001002</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_GOAL</td>
      <td>16</td>
      <td>0.001604</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_EXECUTION</td>
      <td>16</td>
      <td>0.001604</td>
    </tr>
    <tr>
      <th>7</th>
      <td>OF_NAMESPACE</td>
      <td>18</td>
      <td>0.001804</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_ATTRIBUTE</td>
      <td>18</td>
      <td>0.001804</td>
    </tr>
    <tr>
      <th>9</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.001904</td>
    </tr>
    <tr>
      <th>10</th>
      <td>USES_PLUGIN</td>
      <td>21</td>
      <td>0.002105</td>
    </tr>
    <tr>
      <th>11</th>
      <td>REQUIRES_TYPE_PARAMETER</td>
      <td>21</td>
      <td>0.002105</td>
    </tr>
    <tr>
      <th>12</th>
      <td>IS_ARTIFACT</td>
      <td>21</td>
      <td>0.002105</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_CONFIGURATION</td>
      <td>21</td>
      <td>0.002105</td>
    </tr>
    <tr>
      <th>14</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.002806</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_HEAD</td>
      <td>28</td>
      <td>0.002806</td>
    </tr>
    <tr>
      <th>16</th>
      <td>DECLARES_NAMESPACE</td>
      <td>36</td>
      <td>0.003608</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_DEFAULT</td>
      <td>36</td>
      <td>0.003608</td>
    </tr>
    <tr>
      <th>18</th>
      <td>CONTAINS_VALUE</td>
      <td>120</td>
      <td>0.012028</td>
    </tr>
    <tr>
      <th>19</th>
      <td>COPY_OF</td>
      <td>125</td>
      <td>0.012529</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_COMPONENT_TYPE</td>
      <td>158</td>
      <td>0.015836</td>
    </tr>
    <tr>
      <th>21</th>
      <td>TO_ARTIFACT</td>
      <td>163</td>
      <td>0.016337</td>
    </tr>
    <tr>
      <th>22</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>163</td>
      <td>0.016337</td>
    </tr>
    <tr>
      <th>23</th>
      <td>ON_COMMIT</td>
      <td>167</td>
      <td>0.016738</td>
    </tr>
    <tr>
      <th>24</th>
      <td>COPIES</td>
      <td>326</td>
      <td>0.032675</td>
    </tr>
    <tr>
      <th>25</th>
      <td>IMPLEMENTS_GENERIC</td>
      <td>373</td>
      <td>0.037386</td>
    </tr>
    <tr>
      <th>26</th>
      <td>IS</td>
      <td>377</td>
      <td>0.037786</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_LOWER_BOUND</td>
      <td>435</td>
      <td>0.043600</td>
    </tr>
    <tr>
      <th>28</th>
      <td>EXTENDS_GENERIC</td>
      <td>508</td>
      <td>0.050916</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_VALUE</td>
      <td>555</td>
      <td>0.055627</td>
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
      <td>240725</td>
      <td>11850</td>
      <td>240725</td>
      <td>0.008439</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>240725</td>
      <td>240725</td>
      <td>10613</td>
      <td>0.009422</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>155355</td>
      <td>240725</td>
      <td>10613</td>
      <td>0.006081</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>58825</td>
      <td>240725</td>
      <td>10613</td>
      <td>0.002303</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>36675</td>
      <td>240725</td>
      <td>10613</td>
      <td>0.001436</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>21578</td>
      <td>13066</td>
      <td>13066</td>
      <td>0.012639</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>14400</td>
      <td>11850</td>
      <td>11850</td>
      <td>0.010255</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>11850</td>
      <td>290</td>
      <td>11850</td>
      <td>0.344828</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>11850</td>
      <td>244</td>
      <td>11850</td>
      <td>0.409836</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>10130</td>
      <td>240725</td>
      <td>10613</td>
      <td>0.000397</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>8316</td>
      <td>13066</td>
      <td>13000</td>
      <td>0.004896</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>READS</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>8138</td>
      <td>13066</td>
      <td>3490</td>
      <td>0.017846</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>6360</td>
      <td>13000</td>
      <td>746</td>
      <td>0.065581</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>6177</td>
      <td>10613</td>
      <td>10613</td>
      <td>0.005484</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3569</td>
      <td>7112</td>
      <td>746</td>
      <td>0.067269</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3043</td>
      <td>7166</td>
      <td>746</td>
      <td>0.056923</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2906</td>
      <td>7166</td>
      <td>2906</td>
      <td>0.013955</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>2655</td>
      <td>13000</td>
      <td>7166</td>
      <td>0.002850</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>2454</td>
      <td>7166</td>
      <td>1096</td>
      <td>0.031245</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>WRITES</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>2426</td>
      <td>2039</td>
      <td>3490</td>
      <td>0.034092</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>2340</td>
      <td>2821</td>
      <td>93</td>
      <td>0.891928</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Xml, Element]</td>
      <td>HAS_ELEMENT</td>
      <td>[Xml, Element]</td>
      <td>2126</td>
      <td>2144</td>
      <td>2144</td>
      <td>0.046250</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>2111</td>
      <td>2039</td>
      <td>2039</td>
      <td>0.050775</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>2087</td>
      <td>13066</td>
      <td>746</td>
      <td>0.021411</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>2032</td>
      <td>13066</td>
      <td>2039</td>
      <td>0.007627</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>2023</td>
      <td>2039</td>
      <td>13000</td>
      <td>0.007632</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>2023</td>
      <td>13000</td>
      <td>7112</td>
      <td>0.002188</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1882</td>
      <td>936</td>
      <td>13066</td>
      <td>0.015389</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>1802</td>
      <td>7166</td>
      <td>7112</td>
      <td>0.003536</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1797</td>
      <td>2039</td>
      <td>13066</td>
      <td>0.006745</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 329035
    total_number_of_relationships (edges): 997713
    -> total directed graph density: 9.215581767645813e-06
    -> total directed graph density in percent: 0.0009215581767645812

