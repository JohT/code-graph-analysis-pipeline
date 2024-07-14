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

    Total number of nodes: 68813





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
      <td>[Java, ByteCode, Parameter]</td>
      <td>11184</td>
      <td>16.252743</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>10615</td>
      <td>15.425864</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Git, Log]</td>
      <td>7804</td>
      <td>11.340880</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Commit, Git, Log]</td>
      <td>7618</td>
      <td>11.070583</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>6537</td>
      <td>9.499658</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>6308</td>
      <td>9.166873</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>2846</td>
      <td>4.135846</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2722</td>
      <td>3.955648</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>2225</td>
      <td>3.233401</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>1649</td>
      <td>2.396350</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Xml, Element]</td>
      <td>1534</td>
      <td>2.229230</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Xml, Text]</td>
      <td>1016</td>
      <td>1.476465</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>988</td>
      <td>1.435775</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>767</td>
      <td>1.114615</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>699</td>
      <td>1.015796</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>596</td>
      <td>0.866115</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, File, Java, ByteCode, ResolvedDuplicate...</td>
      <td>542</td>
      <td>0.787642</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Java, ByteCode, GenericDeclaration, Member, M...</td>
      <td>525</td>
      <td>0.762937</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, Value, ByteCode, Primitive]</td>
      <td>467</td>
      <td>0.678651</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Author, Git, Log]</td>
      <td>260</td>
      <td>0.377836</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>215</td>
      <td>0.312441</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Type, File, Java, ByteCode, ExternalType]</td>
      <td>194</td>
      <td>0.281923</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>166</td>
      <td>0.241233</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Java, ByteCode, Bound, GenericArrayType]</td>
      <td>144</td>
      <td>0.209263</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Java, Value, ByteCode, Enum]</td>
      <td>142</td>
      <td>0.206356</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Maven, Dependency]</td>
      <td>116</td>
      <td>0.168573</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Value, Property]</td>
      <td>109</td>
      <td>0.158400</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Package, File, Directory, Java]</td>
      <td>107</td>
      <td>0.155494</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Value, Array]</td>
      <td>104</td>
      <td>0.151134</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, ManifestEntry]</td>
      <td>91</td>
      <td>0.132242</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 1a - Highest node count by label combination

Values under 0.5% will be grouped into "others" to get a cleaner plot. The group "others" is then broken down in Chart 1b.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_13_1.png)
    


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
      <td>0.001453</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Maven, Exclusion]</td>
      <td>1</td>
      <td>0.001453</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Java, ByteCode, GenericDeclaration, Member, C...</td>
      <td>3</td>
      <td>0.004360</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>6</td>
      <td>0.008719</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[File, Maven, Xml, Pom, Document]</td>
      <td>6</td>
      <td>0.008719</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ManifestSection]</td>
      <td>6</td>
      <td>0.008719</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[File, Java, Manifest]</td>
      <td>6</td>
      <td>0.008719</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Artifact, File, Jar, Archive, Zip, Java]</td>
      <td>6</td>
      <td>0.008719</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[File, Java, Properties]</td>
      <td>8</td>
      <td>0.011626</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[File, Java, ServiceLoader]</td>
      <td>9</td>
      <td>0.013079</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Xml, Attribute]</td>
      <td>12</td>
      <td>0.017439</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Maven, ExecutionGoal]</td>
      <td>14</td>
      <td>0.020345</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Maven, PluginExecution]</td>
      <td>14</td>
      <td>0.020345</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Maven, Plugin]</td>
      <td>16</td>
      <td>0.023251</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Maven, Configuration]</td>
      <td>16</td>
      <td>0.023251</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.027611</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, File, Java, ByteCode, PrimitiveType]</td>
      <td>21</td>
      <td>0.030517</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Xml, Namespace]</td>
      <td>24</td>
      <td>0.034877</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Type, File, Java, ByteCode, Enum]</td>
      <td>25</td>
      <td>0.036330</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, Value, ByteCode, Class]</td>
      <td>28</td>
      <td>0.040690</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[File, Directory]</td>
      <td>29</td>
      <td>0.042143</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Type, File, Java, ByteCode, Annotation]</td>
      <td>40</td>
      <td>0.058129</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>65</td>
      <td>0.094459</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Artifact, Maven]</td>
      <td>69</td>
      <td>0.100272</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>79</td>
      <td>0.114804</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Value, ManifestEntry]</td>
      <td>91</td>
      <td>0.132242</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Value, Array]</td>
      <td>104</td>
      <td>0.151134</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Package, File, Directory, Java]</td>
      <td>107</td>
      <td>0.155494</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Value, Property]</td>
      <td>109</td>
      <td>0.158400</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Maven, Dependency]</td>
      <td>116</td>
      <td>0.168573</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 1b - Lowest node count by label combination

Shows the lowest (less than 0.5% overall) node count label combinations. Therefore, this plot breaks down the "others" slice of the pie chart above. Values under 0.01% will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_17_1.png)
    


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
      <td>Java</td>
      <td>49940</td>
      <td>72.573496</td>
    </tr>
    <tr>
      <th>1</th>
      <td>ByteCode</td>
      <td>49798</td>
      <td>72.367140</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Bound</td>
      <td>16699</td>
      <td>24.267217</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Member</td>
      <td>16405</td>
      <td>23.839972</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Git</td>
      <td>15682</td>
      <td>22.789299</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Log</td>
      <td>15682</td>
      <td>22.789299</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Method</td>
      <td>13559</td>
      <td>19.704126</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Parameter</td>
      <td>11184</td>
      <td>16.252743</td>
    </tr>
    <tr>
      <th>8</th>
      <td>File</td>
      <td>10623</td>
      <td>15.437490</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Commit</td>
      <td>7618</td>
      <td>11.070583</td>
    </tr>
    <tr>
      <th>10</th>
      <td>ParameterizedType</td>
      <td>6537</td>
      <td>9.499658</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Value</td>
      <td>3166</td>
      <td>4.600875</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Field</td>
      <td>2846</td>
      <td>4.135846</td>
    </tr>
    <tr>
      <th>13</th>
      <td>WildcardType</td>
      <td>2722</td>
      <td>3.955648</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Type</td>
      <td>2648</td>
      <td>3.848110</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Xml</td>
      <td>2592</td>
      <td>3.766730</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Annotation</td>
      <td>2265</td>
      <td>3.291529</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Constructor</td>
      <td>1652</td>
      <td>2.400709</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Element</td>
      <td>1534</td>
      <td>2.229230</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Text</td>
      <td>1016</td>
      <td>1.476465</td>
    </tr>
    <tr>
      <th>20</th>
      <td>TypeVariable</td>
      <td>988</td>
      <td>1.435775</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Class</td>
      <td>942</td>
      <td>1.368927</td>
    </tr>
    <tr>
      <th>22</th>
      <td>GenericDeclaration</td>
      <td>822</td>
      <td>1.194542</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Lambda</td>
      <td>767</td>
      <td>1.114615</td>
    </tr>
    <tr>
      <th>24</th>
      <td>JavaType</td>
      <td>596</td>
      <td>0.866115</td>
    </tr>
    <tr>
      <th>25</th>
      <td>ResolvedDuplicateType</td>
      <td>542</td>
      <td>0.787642</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Primitive</td>
      <td>467</td>
      <td>0.678651</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Author</td>
      <td>260</td>
      <td>0.377836</td>
    </tr>
    <tr>
      <th>28</th>
      <td>ExternalType</td>
      <td>259</td>
      <td>0.376382</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Maven</td>
      <td>252</td>
      <td>0.366210</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Interface</td>
      <td>245</td>
      <td>0.356037</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Enum</td>
      <td>167</td>
      <td>0.242687</td>
    </tr>
    <tr>
      <th>32</th>
      <td>GenericArrayType</td>
      <td>144</td>
      <td>0.209263</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Directory</td>
      <td>136</td>
      <td>0.197637</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Dependency</td>
      <td>116</td>
      <td>0.168573</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Property</td>
      <td>109</td>
      <td>0.158400</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Package</td>
      <td>107</td>
      <td>0.155494</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Array</td>
      <td>104</td>
      <td>0.151134</td>
    </tr>
    <tr>
      <th>38</th>
      <td>ManifestEntry</td>
      <td>91</td>
      <td>0.132242</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Artifact</td>
      <td>75</td>
      <td>0.108991</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 1c - Highest node count by label

Shows the 40 labels with the highest number of nodes.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_21_1.png)
    


## Relationship Types

### Table 2a - Highest relationship count by type

Lists the 30 relationship types with the highest number of occurrences.
The whole table can be found in the CSV report `Relationship_type_count`.

    Total number of relationships: 232065





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
      <td>CONTAINS_CHANGED</td>
      <td>45786</td>
      <td>19.729817</td>
    </tr>
    <tr>
      <th>1</th>
      <td>INVOKES</td>
      <td>29614</td>
      <td>12.761080</td>
    </tr>
    <tr>
      <th>2</th>
      <td>OF_TYPE</td>
      <td>17618</td>
      <td>7.591838</td>
    </tr>
    <tr>
      <th>3</th>
      <td>DEPENDS_ON</td>
      <td>17426</td>
      <td>7.509103</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DECLARES</td>
      <td>16767</td>
      <td>7.225131</td>
    </tr>
    <tr>
      <th>5</th>
      <td>OF_RAW_TYPE</td>
      <td>15183</td>
      <td>6.542564</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS</td>
      <td>11884</td>
      <td>5.120979</td>
    </tr>
    <tr>
      <th>7</th>
      <td>RETURNS</td>
      <td>10623</td>
      <td>4.577597</td>
    </tr>
    <tr>
      <th>8</th>
      <td>READS</td>
      <td>7684</td>
      <td>3.311141</td>
    </tr>
    <tr>
      <th>9</th>
      <td>AUTHORED</td>
      <td>7618</td>
      <td>3.282701</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>7495</td>
      <td>3.229699</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_PARENT</td>
      <td>6162</td>
      <td>2.655291</td>
    </tr>
    <tr>
      <th>12</th>
      <td>OF_GENERIC_TYPE</td>
      <td>5346</td>
      <td>2.303665</td>
    </tr>
    <tr>
      <th>13</th>
      <td>SIMILAR</td>
      <td>3416</td>
      <td>1.472001</td>
    </tr>
    <tr>
      <th>14</th>
      <td>RETURNS_GENERIC</td>
      <td>3250</td>
      <td>1.400470</td>
    </tr>
    <tr>
      <th>15</th>
      <td>WRITES</td>
      <td>3065</td>
      <td>1.320751</td>
    </tr>
    <tr>
      <th>16</th>
      <td>CONTAINS</td>
      <td>3027</td>
      <td>1.304376</td>
    </tr>
    <tr>
      <th>17</th>
      <td>RESOLVES_TO</td>
      <td>2908</td>
      <td>1.253097</td>
    </tr>
    <tr>
      <th>18</th>
      <td>ANNOTATED_BY</td>
      <td>2213</td>
      <td>0.953612</td>
    </tr>
    <tr>
      <th>19</th>
      <td>HAS_FIRST_CHILD</td>
      <td>1534</td>
      <td>0.661022</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_LAST_CHILD</td>
      <td>1534</td>
      <td>0.661022</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_ELEMENT</td>
      <td>1522</td>
      <td>0.655851</td>
    </tr>
    <tr>
      <th>22</th>
      <td>REQUIRES</td>
      <td>1424</td>
      <td>0.613621</td>
    </tr>
    <tr>
      <th>23</th>
      <td>HAS_UPPER_BOUND</td>
      <td>1405</td>
      <td>0.605434</td>
    </tr>
    <tr>
      <th>24</th>
      <td>EXTENDS</td>
      <td>1267</td>
      <td>0.545968</td>
    </tr>
    <tr>
      <th>25</th>
      <td>HAS_TEXT</td>
      <td>1016</td>
      <td>0.437808</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_SIBLING</td>
      <td>1004</td>
      <td>0.432637</td>
    </tr>
    <tr>
      <th>27</th>
      <td>DECLARES_TYPE_PARAMETER</td>
      <td>971</td>
      <td>0.418417</td>
    </tr>
    <tr>
      <th>28</th>
      <td>IMPLEMENTS</td>
      <td>707</td>
      <td>0.304656</td>
    </tr>
    <tr>
      <th>29</th>
      <td>THROWS</td>
      <td>633</td>
      <td>0.272768</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 2a - Highest relationship count by type

Values under 0.5% will be grouped into "others" to get a cleaner plot. The group "others" is then broken down in the second chart.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_26_1.png)
    


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
      <td>EXCLUDES</td>
      <td>1</td>
      <td>0.000431</td>
    </tr>
    <tr>
      <th>1</th>
      <td>THROWS_GENERIC</td>
      <td>5</td>
      <td>0.002155</td>
    </tr>
    <tr>
      <th>2</th>
      <td>DESCRIBES</td>
      <td>6</td>
      <td>0.002585</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HAS_ROOT_ELEMENT</td>
      <td>8</td>
      <td>0.003447</td>
    </tr>
    <tr>
      <th>4</th>
      <td>OF_NAMESPACE</td>
      <td>12</td>
      <td>0.005171</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_ATTRIBUTE</td>
      <td>12</td>
      <td>0.005171</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_GOAL</td>
      <td>14</td>
      <td>0.006033</td>
    </tr>
    <tr>
      <th>7</th>
      <td>HAS_EXECUTION</td>
      <td>14</td>
      <td>0.006033</td>
    </tr>
    <tr>
      <th>8</th>
      <td>USES_PLUGIN</td>
      <td>16</td>
      <td>0.006895</td>
    </tr>
    <tr>
      <th>9</th>
      <td>IS_ARTIFACT</td>
      <td>16</td>
      <td>0.006895</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_CONFIGURATION</td>
      <td>16</td>
      <td>0.006895</td>
    </tr>
    <tr>
      <th>11</th>
      <td>REQUIRES_TYPE_PARAMETER</td>
      <td>17</td>
      <td>0.007326</td>
    </tr>
    <tr>
      <th>12</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.008187</td>
    </tr>
    <tr>
      <th>13</th>
      <td>DECLARES_NAMESPACE</td>
      <td>24</td>
      <td>0.010342</td>
    </tr>
    <tr>
      <th>14</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.012066</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_DEFAULT</td>
      <td>34</td>
      <td>0.014651</td>
    </tr>
    <tr>
      <th>16</th>
      <td>TO_ARTIFACT</td>
      <td>116</td>
      <td>0.049986</td>
    </tr>
    <tr>
      <th>17</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>116</td>
      <td>0.049986</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_COMPONENT_TYPE</td>
      <td>144</td>
      <td>0.062052</td>
    </tr>
    <tr>
      <th>19</th>
      <td>IS</td>
      <td>171</td>
      <td>0.073686</td>
    </tr>
    <tr>
      <th>20</th>
      <td>IMPLEMENTS_GENERIC</td>
      <td>324</td>
      <td>0.139616</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_LOWER_BOUND</td>
      <td>402</td>
      <td>0.173227</td>
    </tr>
    <tr>
      <th>22</th>
      <td>EXTENDS_GENERIC</td>
      <td>448</td>
      <td>0.193049</td>
    </tr>
    <tr>
      <th>23</th>
      <td>THROWS</td>
      <td>633</td>
      <td>0.272768</td>
    </tr>
    <tr>
      <th>24</th>
      <td>IMPLEMENTS</td>
      <td>707</td>
      <td>0.304656</td>
    </tr>
    <tr>
      <th>25</th>
      <td>DECLARES_TYPE_PARAMETER</td>
      <td>971</td>
      <td>0.418417</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_SIBLING</td>
      <td>1004</td>
      <td>0.432637</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_TEXT</td>
      <td>1016</td>
      <td>0.437808</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 2b - Lowest relationship count by type

Shows the lowest (less than 0.5% overall) relationship types. This plot breaks down the "others" slice of the pie chart above. Values under 0.01% will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewGeneral_files/OverviewGeneral_30_1.png)
    


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
      <td>[Commit, Git, Log]</td>
      <td>CONTAINS_CHANGED</td>
      <td>[File, Git, Log]</td>
      <td>45786</td>
      <td>7618</td>
      <td>7804</td>
      <td>0.077015</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>18173</td>
      <td>10535</td>
      <td>10535</td>
      <td>0.016374</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Author, Git, Log]</td>
      <td>AUTHORED</td>
      <td>[Commit, Git, Log]</td>
      <td>7618</td>
      <td>260</td>
      <td>7618</td>
      <td>0.384615</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>7303</td>
      <td>10535</td>
      <td>11184</td>
      <td>0.006198</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>READS</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>6939</td>
      <td>10535</td>
      <td>2846</td>
      <td>0.023143</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Commit, Git, Log]</td>
      <td>HAS_PARENT</td>
      <td>[Commit, Git, Log]</td>
      <td>6156</td>
      <td>7618</td>
      <td>7618</td>
      <td>0.010608</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>5720</td>
      <td>11184</td>
      <td>596</td>
      <td>0.085813</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3213</td>
      <td>6308</td>
      <td>596</td>
      <td>0.085462</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>2777</td>
      <td>6537</td>
      <td>596</td>
      <td>0.071277</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2722</td>
      <td>6537</td>
      <td>2722</td>
      <td>0.015298</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>2434</td>
      <td>11184</td>
      <td>6537</td>
      <td>0.003329</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>2228</td>
      <td>6537</td>
      <td>988</td>
      <td>0.034497</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>WRITES</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>1971</td>
      <td>1649</td>
      <td>2846</td>
      <td>0.041998</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>1889</td>
      <td>10535</td>
      <td>596</td>
      <td>0.030085</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>1842</td>
      <td>2225</td>
      <td>65</td>
      <td>1.273639</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>1818</td>
      <td>11184</td>
      <td>6308</td>
      <td>0.002577</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>1746</td>
      <td>1649</td>
      <td>1649</td>
      <td>0.064210</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>1724</td>
      <td>10535</td>
      <td>1649</td>
      <td>0.009924</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>1710</td>
      <td>1649</td>
      <td>11184</td>
      <td>0.009272</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>ANNOTATED_BY</td>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>1594</td>
      <td>11184</td>
      <td>2225</td>
      <td>0.006406</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1534</td>
      <td>767</td>
      <td>10535</td>
      <td>0.018984</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1531</td>
      <td>1649</td>
      <td>10535</td>
      <td>0.008813</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>1527</td>
      <td>6537</td>
      <td>6308</td>
      <td>0.003703</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Xml, Element]</td>
      <td>HAS_ELEMENT</td>
      <td>[Xml, Element]</td>
      <td>1522</td>
      <td>1534</td>
      <td>1534</td>
      <td>0.064679</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>1464</td>
      <td>10535</td>
      <td>6</td>
      <td>2.316089</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>DECLARES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1277</td>
      <td>596</td>
      <td>10535</td>
      <td>0.020338</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Java, ByteCode, GenericDeclaration, Member, M...</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1274</td>
      <td>510</td>
      <td>10535</td>
      <td>0.023712</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>1221</td>
      <td>1649</td>
      <td>6</td>
      <td>12.340813</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>1170</td>
      <td>2846</td>
      <td>596</td>
      <td>0.068977</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>RETURNS_GENERIC</td>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>1159</td>
      <td>10535</td>
      <td>6537</td>
      <td>0.001683</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 68813
    total_number_of_relationships (edges): 232065
    -> total directed graph density: 4.900890199161407e-05
    -> total directed graph density in percent: 0.004900890199161408

