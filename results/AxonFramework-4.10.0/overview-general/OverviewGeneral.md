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

    Total number of nodes: 69405





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
      <td>11202</td>
      <td>16.140048</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>10658</td>
      <td>15.356242</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Git, Log]</td>
      <td>8142</td>
      <td>11.731143</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Commit, Log]</td>
      <td>7776</td>
      <td>11.203804</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>6542</td>
      <td>9.425834</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>6316</td>
      <td>9.100209</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>2845</td>
      <td>4.099128</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2723</td>
      <td>3.923348</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>2225</td>
      <td>3.205821</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>1654</td>
      <td>2.383114</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Xml, Element]</td>
      <td>1534</td>
      <td>2.210215</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Xml, Text]</td>
      <td>1016</td>
      <td>1.463871</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>989</td>
      <td>1.424969</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>769</td>
      <td>1.107989</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, File, Java, Class, ByteCode]</td>
      <td>699</td>
      <td>1.007132</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>597</td>
      <td>0.860169</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, File, Java, ByteCode, ResolvedDuplicate...</td>
      <td>542</td>
      <td>0.780924</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Java, ByteCode, Member, Method, GenericDeclar...</td>
      <td>525</td>
      <td>0.756430</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, Value, ByteCode, Primitive]</td>
      <td>467</td>
      <td>0.672862</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Git, Author, Log]</td>
      <td>269</td>
      <td>0.387580</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, File, Java, Class, ByteCode, GenericDec...</td>
      <td>215</td>
      <td>0.309776</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Type, File, Java, ByteCode, ExternalType]</td>
      <td>194</td>
      <td>0.279519</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>167</td>
      <td>0.240617</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Java, ByteCode, Bound, GenericArrayType]</td>
      <td>145</td>
      <td>0.208919</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Java, Value, ByteCode, Enum]</td>
      <td>142</td>
      <td>0.204596</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Maven, Dependency]</td>
      <td>116</td>
      <td>0.167135</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Value, Property]</td>
      <td>109</td>
      <td>0.157049</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Package, File, Directory, Java]</td>
      <td>107</td>
      <td>0.154168</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Value, Array]</td>
      <td>104</td>
      <td>0.149845</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, ManifestEntry]</td>
      <td>91</td>
      <td>0.131114</td>
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
      <td>[Repository, Git]</td>
      <td>1</td>
      <td>0.001441</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Analyze, Task, jQAssistant]</td>
      <td>1</td>
      <td>0.001441</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Maven, Exclusion]</td>
      <td>1</td>
      <td>0.001441</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Java, ByteCode, Member, Constructor, Method, ...</td>
      <td>3</td>
      <td>0.004322</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>6</td>
      <td>0.008645</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[File, Maven, Xml, Pom, Document]</td>
      <td>6</td>
      <td>0.008645</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ManifestSection]</td>
      <td>6</td>
      <td>0.008645</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[File, Java, Manifest]</td>
      <td>6</td>
      <td>0.008645</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Artifact, File, Jar, Archive, Zip, Java]</td>
      <td>6</td>
      <td>0.008645</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[File, Java, Properties]</td>
      <td>8</td>
      <td>0.011527</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[File, Java, ServiceLoader]</td>
      <td>9</td>
      <td>0.012967</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Xml, Attribute]</td>
      <td>12</td>
      <td>0.017290</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Maven, ExecutionGoal]</td>
      <td>14</td>
      <td>0.020171</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Maven, PluginExecution]</td>
      <td>14</td>
      <td>0.020171</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Maven, Plugin]</td>
      <td>16</td>
      <td>0.023053</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Maven, Configuration]</td>
      <td>16</td>
      <td>0.023053</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.027376</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, File, Java, ByteCode, PrimitiveType]</td>
      <td>21</td>
      <td>0.030257</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Xml, Namespace]</td>
      <td>24</td>
      <td>0.034580</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, File, Java, ByteCode, Enum]</td>
      <td>25</td>
      <td>0.036020</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Java, Value, Class, ByteCode]</td>
      <td>28</td>
      <td>0.040343</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[File, Directory]</td>
      <td>29</td>
      <td>0.041784</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, Annotation]</td>
      <td>40</td>
      <td>0.057633</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>65</td>
      <td>0.093653</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Artifact, Maven]</td>
      <td>69</td>
      <td>0.099416</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>80</td>
      <td>0.115265</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Value, ManifestEntry]</td>
      <td>91</td>
      <td>0.131114</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Value, Array]</td>
      <td>104</td>
      <td>0.149845</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Package, File, Directory, Java]</td>
      <td>107</td>
      <td>0.154168</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, Property]</td>
      <td>109</td>
      <td>0.157049</td>
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
      <td>50026</td>
      <td>72.078381</td>
    </tr>
    <tr>
      <th>1</th>
      <td>ByteCode</td>
      <td>49884</td>
      <td>71.873784</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Bound</td>
      <td>16715</td>
      <td>24.083279</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Member</td>
      <td>16454</td>
      <td>23.707226</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Git</td>
      <td>16188</td>
      <td>23.323968</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Log</td>
      <td>16187</td>
      <td>23.322527</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Method</td>
      <td>13609</td>
      <td>19.608097</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Parameter</td>
      <td>11202</td>
      <td>16.140048</td>
    </tr>
    <tr>
      <th>8</th>
      <td>File</td>
      <td>10964</td>
      <td>15.797133</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Commit</td>
      <td>7776</td>
      <td>11.203804</td>
    </tr>
    <tr>
      <th>10</th>
      <td>ParameterizedType</td>
      <td>6542</td>
      <td>9.425834</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Value</td>
      <td>3166</td>
      <td>4.561631</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Field</td>
      <td>2845</td>
      <td>4.099128</td>
    </tr>
    <tr>
      <th>13</th>
      <td>WildcardType</td>
      <td>2723</td>
      <td>3.923348</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Type</td>
      <td>2651</td>
      <td>3.819610</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Xml</td>
      <td>2592</td>
      <td>3.734601</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Annotation</td>
      <td>2265</td>
      <td>3.263454</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Constructor</td>
      <td>1657</td>
      <td>2.387436</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Element</td>
      <td>1534</td>
      <td>2.210215</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Text</td>
      <td>1016</td>
      <td>1.463871</td>
    </tr>
    <tr>
      <th>20</th>
      <td>TypeVariable</td>
      <td>989</td>
      <td>1.424969</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Class</td>
      <td>942</td>
      <td>1.357251</td>
    </tr>
    <tr>
      <th>22</th>
      <td>GenericDeclaration</td>
      <td>823</td>
      <td>1.185794</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Lambda</td>
      <td>769</td>
      <td>1.107989</td>
    </tr>
    <tr>
      <th>24</th>
      <td>JavaType</td>
      <td>597</td>
      <td>0.860169</td>
    </tr>
    <tr>
      <th>25</th>
      <td>ResolvedDuplicateType</td>
      <td>542</td>
      <td>0.780924</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Primitive</td>
      <td>467</td>
      <td>0.672862</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Author</td>
      <td>269</td>
      <td>0.387580</td>
    </tr>
    <tr>
      <th>28</th>
      <td>ExternalType</td>
      <td>259</td>
      <td>0.373172</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Maven</td>
      <td>252</td>
      <td>0.363086</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Interface</td>
      <td>247</td>
      <td>0.355882</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Enum</td>
      <td>167</td>
      <td>0.240617</td>
    </tr>
    <tr>
      <th>32</th>
      <td>GenericArrayType</td>
      <td>145</td>
      <td>0.208919</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Directory</td>
      <td>136</td>
      <td>0.195951</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Dependency</td>
      <td>116</td>
      <td>0.167135</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Property</td>
      <td>109</td>
      <td>0.157049</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Package</td>
      <td>107</td>
      <td>0.154168</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Array</td>
      <td>104</td>
      <td>0.149845</td>
    </tr>
    <tr>
      <th>38</th>
      <td>ManifestEntry</td>
      <td>91</td>
      <td>0.131114</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Artifact</td>
      <td>75</td>
      <td>0.108061</td>
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

    Total number of relationships: 249579





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
      <td>46599</td>
      <td>18.671042</td>
    </tr>
    <tr>
      <th>1</th>
      <td>INVOKES</td>
      <td>29663</td>
      <td>11.885215</td>
    </tr>
    <tr>
      <th>2</th>
      <td>OF_TYPE</td>
      <td>17636</td>
      <td>7.066300</td>
    </tr>
    <tr>
      <th>3</th>
      <td>DEPENDS_ON</td>
      <td>17445</td>
      <td>6.989771</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DECLARES</td>
      <td>16816</td>
      <td>6.737746</td>
    </tr>
    <tr>
      <th>5</th>
      <td>OF_RAW_TYPE</td>
      <td>15200</td>
      <td>6.090256</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS</td>
      <td>11902</td>
      <td>4.768831</td>
    </tr>
    <tr>
      <th>7</th>
      <td>RETURNS</td>
      <td>10643</td>
      <td>4.264381</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_FILE</td>
      <td>8142</td>
      <td>3.262294</td>
    </tr>
    <tr>
      <th>9</th>
      <td>AUTHORED</td>
      <td>7776</td>
      <td>3.115647</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_COMMIT</td>
      <td>7776</td>
      <td>3.115647</td>
    </tr>
    <tr>
      <th>11</th>
      <td>READS</td>
      <td>7697</td>
      <td>3.083993</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>7501</td>
      <td>3.005461</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_PARENT</td>
      <td>6288</td>
      <td>2.519443</td>
    </tr>
    <tr>
      <th>14</th>
      <td>OF_GENERIC_TYPE</td>
      <td>5349</td>
      <td>2.143209</td>
    </tr>
    <tr>
      <th>15</th>
      <td>SIMILAR</td>
      <td>3419</td>
      <td>1.369907</td>
    </tr>
    <tr>
      <th>16</th>
      <td>RETURNS_GENERIC</td>
      <td>3253</td>
      <td>1.303395</td>
    </tr>
    <tr>
      <th>17</th>
      <td>WRITES</td>
      <td>3066</td>
      <td>1.228469</td>
    </tr>
    <tr>
      <th>18</th>
      <td>CONTAINS</td>
      <td>3031</td>
      <td>1.214445</td>
    </tr>
    <tr>
      <th>19</th>
      <td>RESOLVES_TO</td>
      <td>2906</td>
      <td>1.164361</td>
    </tr>
    <tr>
      <th>20</th>
      <td>ANNOTATED_BY</td>
      <td>2213</td>
      <td>0.886693</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_FIRST_CHILD</td>
      <td>1534</td>
      <td>0.614635</td>
    </tr>
    <tr>
      <th>22</th>
      <td>HAS_LAST_CHILD</td>
      <td>1534</td>
      <td>0.614635</td>
    </tr>
    <tr>
      <th>23</th>
      <td>HAS_ELEMENT</td>
      <td>1522</td>
      <td>0.609827</td>
    </tr>
    <tr>
      <th>24</th>
      <td>REQUIRES</td>
      <td>1425</td>
      <td>0.570961</td>
    </tr>
    <tr>
      <th>25</th>
      <td>HAS_UPPER_BOUND</td>
      <td>1406</td>
      <td>0.563349</td>
    </tr>
    <tr>
      <th>26</th>
      <td>EXTENDS</td>
      <td>1269</td>
      <td>0.508456</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_TEXT</td>
      <td>1016</td>
      <td>0.407086</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_SIBLING</td>
      <td>1004</td>
      <td>0.402277</td>
    </tr>
    <tr>
      <th>29</th>
      <td>DECLARES_TYPE_PARAMETER</td>
      <td>972</td>
      <td>0.389456</td>
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
      <td>0.000401</td>
    </tr>
    <tr>
      <th>1</th>
      <td>THROWS_GENERIC</td>
      <td>5</td>
      <td>0.002003</td>
    </tr>
    <tr>
      <th>2</th>
      <td>DESCRIBES</td>
      <td>6</td>
      <td>0.002404</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HAS_ROOT_ELEMENT</td>
      <td>6</td>
      <td>0.002404</td>
    </tr>
    <tr>
      <th>4</th>
      <td>OF_NAMESPACE</td>
      <td>12</td>
      <td>0.004808</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_ATTRIBUTE</td>
      <td>12</td>
      <td>0.004808</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_GOAL</td>
      <td>14</td>
      <td>0.005609</td>
    </tr>
    <tr>
      <th>7</th>
      <td>HAS_EXECUTION</td>
      <td>14</td>
      <td>0.005609</td>
    </tr>
    <tr>
      <th>8</th>
      <td>USES_PLUGIN</td>
      <td>16</td>
      <td>0.006411</td>
    </tr>
    <tr>
      <th>9</th>
      <td>IS_ARTIFACT</td>
      <td>16</td>
      <td>0.006411</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_CONFIGURATION</td>
      <td>16</td>
      <td>0.006411</td>
    </tr>
    <tr>
      <th>11</th>
      <td>REQUIRES_TYPE_PARAMETER</td>
      <td>17</td>
      <td>0.006811</td>
    </tr>
    <tr>
      <th>12</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.007613</td>
    </tr>
    <tr>
      <th>13</th>
      <td>DECLARES_NAMESPACE</td>
      <td>24</td>
      <td>0.009616</td>
    </tr>
    <tr>
      <th>14</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.011219</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_DEFAULT</td>
      <td>34</td>
      <td>0.013623</td>
    </tr>
    <tr>
      <th>16</th>
      <td>TO_ARTIFACT</td>
      <td>116</td>
      <td>0.046478</td>
    </tr>
    <tr>
      <th>17</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>116</td>
      <td>0.046478</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_COMPONENT_TYPE</td>
      <td>145</td>
      <td>0.058098</td>
    </tr>
    <tr>
      <th>19</th>
      <td>IS</td>
      <td>171</td>
      <td>0.068515</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_AUTHOR</td>
      <td>269</td>
      <td>0.107782</td>
    </tr>
    <tr>
      <th>21</th>
      <td>IMPLEMENTS_GENERIC</td>
      <td>325</td>
      <td>0.130219</td>
    </tr>
    <tr>
      <th>22</th>
      <td>HAS_LOWER_BOUND</td>
      <td>402</td>
      <td>0.161071</td>
    </tr>
    <tr>
      <th>23</th>
      <td>EXTENDS_GENERIC</td>
      <td>450</td>
      <td>0.180304</td>
    </tr>
    <tr>
      <th>24</th>
      <td>THROWS</td>
      <td>634</td>
      <td>0.254028</td>
    </tr>
    <tr>
      <th>25</th>
      <td>IMPLEMENTS</td>
      <td>708</td>
      <td>0.283678</td>
    </tr>
    <tr>
      <th>26</th>
      <td>DECLARES_TYPE_PARAMETER</td>
      <td>972</td>
      <td>0.389456</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_SIBLING</td>
      <td>1004</td>
      <td>0.402277</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_TEXT</td>
      <td>1016</td>
      <td>0.407086</td>
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
      <td>[Git, Commit, Log]</td>
      <td>CONTAINS_CHANGED</td>
      <td>[File, Git, Log]</td>
      <td>46599</td>
      <td>7776</td>
      <td>8142</td>
      <td>0.073602</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>18169</td>
      <td>10566</td>
      <td>10566</td>
      <td>0.016275</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Repository, Git]</td>
      <td>HAS_FILE</td>
      <td>[File, Git, Log]</td>
      <td>8142</td>
      <td>1</td>
      <td>8142</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Repository, Git]</td>
      <td>HAS_COMMIT</td>
      <td>[Git, Commit, Log]</td>
      <td>7776</td>
      <td>1</td>
      <td>7776</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Author, Log]</td>
      <td>AUTHORED</td>
      <td>[Git, Commit, Log]</td>
      <td>7776</td>
      <td>269</td>
      <td>7776</td>
      <td>0.371747</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>7299</td>
      <td>10566</td>
      <td>11202</td>
      <td>0.006167</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>READS</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>6929</td>
      <td>10566</td>
      <td>2845</td>
      <td>0.023050</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Git, Commit, Log]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit, Log]</td>
      <td>6282</td>
      <td>7776</td>
      <td>7776</td>
      <td>0.010389</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>5730</td>
      <td>11202</td>
      <td>597</td>
      <td>0.085681</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3218</td>
      <td>6316</td>
      <td>597</td>
      <td>0.085343</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>2779</td>
      <td>6542</td>
      <td>597</td>
      <td>0.071155</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2723</td>
      <td>6542</td>
      <td>2723</td>
      <td>0.015286</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>2435</td>
      <td>11202</td>
      <td>6542</td>
      <td>0.003323</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>2230</td>
      <td>6542</td>
      <td>989</td>
      <td>0.034467</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>WRITES</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>1971</td>
      <td>1654</td>
      <td>2845</td>
      <td>0.041886</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>1892</td>
      <td>10566</td>
      <td>597</td>
      <td>0.029994</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>1842</td>
      <td>2225</td>
      <td>65</td>
      <td>1.273639</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>1819</td>
      <td>11202</td>
      <td>6316</td>
      <td>0.002571</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>1744</td>
      <td>1654</td>
      <td>1654</td>
      <td>0.063749</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>1710</td>
      <td>1654</td>
      <td>11202</td>
      <td>0.009229</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>1707</td>
      <td>10566</td>
      <td>1654</td>
      <td>0.009768</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>ANNOTATED_BY</td>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>1594</td>
      <td>11202</td>
      <td>2225</td>
      <td>0.006395</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1537</td>
      <td>1654</td>
      <td>10566</td>
      <td>0.008795</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1535</td>
      <td>769</td>
      <td>10566</td>
      <td>0.018892</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>1530</td>
      <td>6542</td>
      <td>6316</td>
      <td>0.003703</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Xml, Element]</td>
      <td>HAS_ELEMENT</td>
      <td>[Xml, Element]</td>
      <td>1522</td>
      <td>1534</td>
      <td>1534</td>
      <td>0.064679</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>1461</td>
      <td>10566</td>
      <td>6</td>
      <td>2.304562</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>DECLARES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1279</td>
      <td>597</td>
      <td>10566</td>
      <td>0.020276</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Java, ByteCode, Member, Method, GenericDeclar...</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1278</td>
      <td>510</td>
      <td>10566</td>
      <td>0.023716</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>1221</td>
      <td>1654</td>
      <td>6</td>
      <td>12.303507</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 69405
    total_number_of_relationships (edges): 249579
    -> total directed graph density: 5.181228915777605e-05
    -> total directed graph density in percent: 0.005181228915777605

