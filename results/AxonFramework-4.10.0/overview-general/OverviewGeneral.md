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

    Total number of nodes: 307227





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
      <td>231081</td>
      <td>75.215069</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Commit]</td>
      <td>11637</td>
      <td>3.787753</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>11202</td>
      <td>3.646164</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Java, ByteCode, Method, Member]</td>
      <td>10655</td>
      <td>3.468120</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[File, Git]</td>
      <td>10547</td>
      <td>3.432967</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>6542</td>
      <td>2.129370</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>6316</td>
      <td>2.055809</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>2848</td>
      <td>0.927002</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2723</td>
      <td>0.886315</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>2225</td>
      <td>0.724220</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Java, ByteCode, Constructor, Method, Member]</td>
      <td>1648</td>
      <td>0.536411</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Xml, Element]</td>
      <td>1534</td>
      <td>0.499305</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Xml, Text]</td>
      <td>1016</td>
      <td>0.330700</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>989</td>
      <td>0.321912</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Method, Member, Lambda]</td>
      <td>769</td>
      <td>0.250304</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>699</td>
      <td>0.227519</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>597</td>
      <td>0.194319</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, File, Java, ByteCode, ResolvedDuplicate...</td>
      <td>542</td>
      <td>0.176417</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, ByteCode, Method, Member, GenericDeclar...</td>
      <td>525</td>
      <td>0.170883</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, Value, ByteCode, Primitive]</td>
      <td>467</td>
      <td>0.152005</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Author, Git, Person]</td>
      <td>288</td>
      <td>0.093742</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Committer, Git, Person]</td>
      <td>242</td>
      <td>0.078769</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>215</td>
      <td>0.069981</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Type, File, Java, ByteCode, ExternalType]</td>
      <td>194</td>
      <td>0.063145</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>167</td>
      <td>0.054357</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Git, Tag]</td>
      <td>165</td>
      <td>0.053706</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Java, ByteCode, Bound, GenericArrayType]</td>
      <td>145</td>
      <td>0.047196</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Java, Value, ByteCode, Enum]</td>
      <td>142</td>
      <td>0.046220</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Maven, Dependency]</td>
      <td>116</td>
      <td>0.037757</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, Property]</td>
      <td>109</td>
      <td>0.035479</td>
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
      <td>0.000325</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Maven, Exclusion]</td>
      <td>1</td>
      <td>0.000325</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Repository, File, Git]</td>
      <td>1</td>
      <td>0.000325</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[File, TS, Scan]</td>
      <td>1</td>
      <td>0.000325</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Java, ByteCode, Constructor, Method, Member, ...</td>
      <td>3</td>
      <td>0.000976</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[File, Xml, Maven, Pom, Document]</td>
      <td>6</td>
      <td>0.001953</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>6</td>
      <td>0.001953</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Java, ManifestSection]</td>
      <td>6</td>
      <td>0.001953</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[File, Java, Manifest]</td>
      <td>6</td>
      <td>0.001953</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Artifact, File, Jar, Archive, Zip, Java]</td>
      <td>6</td>
      <td>0.001953</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[File, Java, Properties]</td>
      <td>8</td>
      <td>0.002604</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[File, Java, ServiceLoader]</td>
      <td>9</td>
      <td>0.002929</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Xml, Attribute]</td>
      <td>12</td>
      <td>0.003906</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Maven, ExecutionGoal]</td>
      <td>14</td>
      <td>0.004557</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Maven, PluginExecution]</td>
      <td>14</td>
      <td>0.004557</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Maven, Plugin]</td>
      <td>16</td>
      <td>0.005208</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Maven, Configuration]</td>
      <td>16</td>
      <td>0.005208</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.006184</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[File]</td>
      <td>21</td>
      <td>0.006835</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, File, Java, ByteCode, PrimitiveType]</td>
      <td>21</td>
      <td>0.006835</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Git, Branch]</td>
      <td>23</td>
      <td>0.007486</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Xml, Namespace]</td>
      <td>24</td>
      <td>0.007812</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, Enum]</td>
      <td>25</td>
      <td>0.008137</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Java, Value, ByteCode, Class]</td>
      <td>28</td>
      <td>0.009114</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[File, Directory]</td>
      <td>39</td>
      <td>0.012694</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, File, Java, ByteCode, Annotation]</td>
      <td>40</td>
      <td>0.013020</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, File, Java, ByteCode, ExternalType, Ext...</td>
      <td>65</td>
      <td>0.021157</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Artifact, Maven]</td>
      <td>69</td>
      <td>0.022459</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>80</td>
      <td>0.026039</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, ManifestEntry]</td>
      <td>91</td>
      <td>0.029620</td>
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
      <td>Git</td>
      <td>253984</td>
      <td>82.669817</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>231081</td>
      <td>75.215069</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Java</td>
      <td>50020</td>
      <td>16.281121</td>
    </tr>
    <tr>
      <th>3</th>
      <td>ByteCode</td>
      <td>49878</td>
      <td>16.234901</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Bound</td>
      <td>16715</td>
      <td>5.440603</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Member</td>
      <td>16448</td>
      <td>5.353696</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Method</td>
      <td>13600</td>
      <td>4.426694</td>
    </tr>
    <tr>
      <th>7</th>
      <td>File</td>
      <td>13402</td>
      <td>4.362247</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Commit</td>
      <td>11637</td>
      <td>3.787753</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Parameter</td>
      <td>11202</td>
      <td>3.646164</td>
    </tr>
    <tr>
      <th>10</th>
      <td>ParameterizedType</td>
      <td>6542</td>
      <td>2.129370</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Value</td>
      <td>3166</td>
      <td>1.030508</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Field</td>
      <td>2848</td>
      <td>0.927002</td>
    </tr>
    <tr>
      <th>13</th>
      <td>WildcardType</td>
      <td>2723</td>
      <td>0.886315</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Type</td>
      <td>2651</td>
      <td>0.862880</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Xml</td>
      <td>2592</td>
      <td>0.843676</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Annotation</td>
      <td>2265</td>
      <td>0.737240</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Constructor</td>
      <td>1651</td>
      <td>0.537388</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Element</td>
      <td>1534</td>
      <td>0.499305</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Text</td>
      <td>1016</td>
      <td>0.330700</td>
    </tr>
    <tr>
      <th>20</th>
      <td>TypeVariable</td>
      <td>989</td>
      <td>0.321912</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Class</td>
      <td>942</td>
      <td>0.306614</td>
    </tr>
    <tr>
      <th>22</th>
      <td>GenericDeclaration</td>
      <td>823</td>
      <td>0.267880</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Lambda</td>
      <td>769</td>
      <td>0.250304</td>
    </tr>
    <tr>
      <th>24</th>
      <td>JavaType</td>
      <td>597</td>
      <td>0.194319</td>
    </tr>
    <tr>
      <th>25</th>
      <td>ResolvedDuplicateType</td>
      <td>542</td>
      <td>0.176417</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Person</td>
      <td>530</td>
      <td>0.172511</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Primitive</td>
      <td>467</td>
      <td>0.152005</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Author</td>
      <td>288</td>
      <td>0.093742</td>
    </tr>
    <tr>
      <th>29</th>
      <td>ExternalType</td>
      <td>259</td>
      <td>0.084302</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Maven</td>
      <td>252</td>
      <td>0.082024</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Interface</td>
      <td>247</td>
      <td>0.080397</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Committer</td>
      <td>242</td>
      <td>0.078769</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Enum</td>
      <td>167</td>
      <td>0.054357</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Tag</td>
      <td>165</td>
      <td>0.053706</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Directory</td>
      <td>146</td>
      <td>0.047522</td>
    </tr>
    <tr>
      <th>36</th>
      <td>GenericArrayType</td>
      <td>145</td>
      <td>0.047196</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Dependency</td>
      <td>116</td>
      <td>0.037757</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Property</td>
      <td>109</td>
      <td>0.035479</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Package</td>
      <td>107</td>
      <td>0.034828</td>
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

    Total number of relationships: 953778





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
      <td>231081</td>
      <td>24.227965</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>231081</td>
      <td>24.227965</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>148057</td>
      <td>15.523214</td>
    </tr>
    <tr>
      <th>3</th>
      <td>CREATES</td>
      <td>57541</td>
      <td>6.032955</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DELETES</td>
      <td>35338</td>
      <td>3.705055</td>
    </tr>
    <tr>
      <th>5</th>
      <td>INVOKES</td>
      <td>29713</td>
      <td>3.115295</td>
    </tr>
    <tr>
      <th>6</th>
      <td>COMMITTED</td>
      <td>23274</td>
      <td>2.440190</td>
    </tr>
    <tr>
      <th>7</th>
      <td>OF_TYPE</td>
      <td>17636</td>
      <td>1.849068</td>
    </tr>
    <tr>
      <th>8</th>
      <td>DEPENDS_ON</td>
      <td>17445</td>
      <td>1.829042</td>
    </tr>
    <tr>
      <th>9</th>
      <td>DECLARES</td>
      <td>16810</td>
      <td>1.762465</td>
    </tr>
    <tr>
      <th>10</th>
      <td>OF_RAW_TYPE</td>
      <td>15200</td>
      <td>1.593662</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_PARENT</td>
      <td>14145</td>
      <td>1.483050</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS</td>
      <td>11902</td>
      <td>1.247879</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_COMMIT</td>
      <td>11637</td>
      <td>1.220095</td>
    </tr>
    <tr>
      <th>14</th>
      <td>RETURNS</td>
      <td>10643</td>
      <td>1.115878</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_FILE</td>
      <td>10547</td>
      <td>1.105813</td>
    </tr>
    <tr>
      <th>16</th>
      <td>RENAMES</td>
      <td>9855</td>
      <td>1.033259</td>
    </tr>
    <tr>
      <th>17</th>
      <td>READS</td>
      <td>7695</td>
      <td>0.806792</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>7501</td>
      <td>0.786451</td>
    </tr>
    <tr>
      <th>19</th>
      <td>HAS_NEW_NAME</td>
      <td>6159</td>
      <td>0.645748</td>
    </tr>
    <tr>
      <th>20</th>
      <td>OF_GENERIC_TYPE</td>
      <td>5349</td>
      <td>0.560822</td>
    </tr>
    <tr>
      <th>21</th>
      <td>RESOLVES_TO</td>
      <td>3790</td>
      <td>0.397367</td>
    </tr>
    <tr>
      <th>22</th>
      <td>SIMILAR</td>
      <td>3419</td>
      <td>0.358469</td>
    </tr>
    <tr>
      <th>23</th>
      <td>RETURNS_GENERIC</td>
      <td>3253</td>
      <td>0.341065</td>
    </tr>
    <tr>
      <th>24</th>
      <td>CONTAINS</td>
      <td>3084</td>
      <td>0.323346</td>
    </tr>
    <tr>
      <th>25</th>
      <td>WRITES</td>
      <td>3066</td>
      <td>0.321458</td>
    </tr>
    <tr>
      <th>26</th>
      <td>ANNOTATED_BY</td>
      <td>2213</td>
      <td>0.232025</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_FIRST_CHILD</td>
      <td>1534</td>
      <td>0.160834</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_LAST_CHILD</td>
      <td>1534</td>
      <td>0.160834</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_ELEMENT</td>
      <td>1522</td>
      <td>0.159576</td>
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
      <td>0.000105</td>
    </tr>
    <tr>
      <th>1</th>
      <td>THROWS_GENERIC</td>
      <td>5</td>
      <td>0.000524</td>
    </tr>
    <tr>
      <th>2</th>
      <td>DESCRIBES</td>
      <td>6</td>
      <td>0.000629</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HAS_ROOT_ELEMENT</td>
      <td>7</td>
      <td>0.000734</td>
    </tr>
    <tr>
      <th>4</th>
      <td>OF_NAMESPACE</td>
      <td>12</td>
      <td>0.001258</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_ATTRIBUTE</td>
      <td>12</td>
      <td>0.001258</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_GOAL</td>
      <td>14</td>
      <td>0.001468</td>
    </tr>
    <tr>
      <th>7</th>
      <td>HAS_EXECUTION</td>
      <td>14</td>
      <td>0.001468</td>
    </tr>
    <tr>
      <th>8</th>
      <td>USES_PLUGIN</td>
      <td>16</td>
      <td>0.001678</td>
    </tr>
    <tr>
      <th>9</th>
      <td>IS_ARTIFACT</td>
      <td>16</td>
      <td>0.001678</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_CONFIGURATION</td>
      <td>16</td>
      <td>0.001678</td>
    </tr>
    <tr>
      <th>11</th>
      <td>REQUIRES_TYPE_PARAMETER</td>
      <td>17</td>
      <td>0.001782</td>
    </tr>
    <tr>
      <th>12</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.001992</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_BRANCH</td>
      <td>23</td>
      <td>0.002411</td>
    </tr>
    <tr>
      <th>14</th>
      <td>HAS_HEAD</td>
      <td>24</td>
      <td>0.002516</td>
    </tr>
    <tr>
      <th>15</th>
      <td>DECLARES_NAMESPACE</td>
      <td>24</td>
      <td>0.002516</td>
    </tr>
    <tr>
      <th>16</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.002936</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_DEFAULT</td>
      <td>34</td>
      <td>0.003565</td>
    </tr>
    <tr>
      <th>18</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>116</td>
      <td>0.012162</td>
    </tr>
    <tr>
      <th>19</th>
      <td>TO_ARTIFACT</td>
      <td>116</td>
      <td>0.012162</td>
    </tr>
    <tr>
      <th>20</th>
      <td>COPY_OF</td>
      <td>125</td>
      <td>0.013106</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_COMPONENT_TYPE</td>
      <td>145</td>
      <td>0.015203</td>
    </tr>
    <tr>
      <th>22</th>
      <td>ON_COMMIT</td>
      <td>165</td>
      <td>0.017300</td>
    </tr>
    <tr>
      <th>23</th>
      <td>HAS_TAG</td>
      <td>165</td>
      <td>0.017300</td>
    </tr>
    <tr>
      <th>24</th>
      <td>IS</td>
      <td>171</td>
      <td>0.017929</td>
    </tr>
    <tr>
      <th>25</th>
      <td>HAS_COMMITTER</td>
      <td>242</td>
      <td>0.025373</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_AUTHOR</td>
      <td>288</td>
      <td>0.030196</td>
    </tr>
    <tr>
      <th>27</th>
      <td>COPIES</td>
      <td>322</td>
      <td>0.033760</td>
    </tr>
    <tr>
      <th>28</th>
      <td>IMPLEMENTS_GENERIC</td>
      <td>325</td>
      <td>0.034075</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_LOWER_BOUND</td>
      <td>402</td>
      <td>0.042148</td>
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
      <td>[Git, Commit]</td>
      <td>CONTAINS_CHANGE</td>
      <td>[Git, Change]</td>
      <td>231081</td>
      <td>11637</td>
      <td>231081</td>
      <td>0.008593</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>231081</td>
      <td>231081</td>
      <td>10547</td>
      <td>0.009481</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>148057</td>
      <td>231081</td>
      <td>10547</td>
      <td>0.006075</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>57541</td>
      <td>231081</td>
      <td>10547</td>
      <td>0.002361</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>35338</td>
      <td>231081</td>
      <td>10547</td>
      <td>0.001450</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Method, Member]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Method, Member]</td>
      <td>18196</td>
      <td>10568</td>
      <td>10568</td>
      <td>0.016293</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>14139</td>
      <td>11637</td>
      <td>11637</td>
      <td>0.010441</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>11637</td>
      <td>1</td>
      <td>11637</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>11637</td>
      <td>288</td>
      <td>11637</td>
      <td>0.347222</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>11637</td>
      <td>242</td>
      <td>11637</td>
      <td>0.413223</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_FILE</td>
      <td>[File, Git]</td>
      <td>10547</td>
      <td>1</td>
      <td>10547</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>9855</td>
      <td>231081</td>
      <td>10547</td>
      <td>0.000404</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Java, ByteCode, Method, Member]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>7306</td>
      <td>10568</td>
      <td>11202</td>
      <td>0.006172</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Method, Member]</td>
      <td>READS</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>6917</td>
      <td>10568</td>
      <td>2848</td>
      <td>0.022982</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>6159</td>
      <td>10547</td>
      <td>10547</td>
      <td>0.005537</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>5730</td>
      <td>11202</td>
      <td>597</td>
      <td>0.085681</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3218</td>
      <td>6316</td>
      <td>597</td>
      <td>0.085343</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>2779</td>
      <td>6542</td>
      <td>597</td>
      <td>0.071155</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2723</td>
      <td>6542</td>
      <td>2723</td>
      <td>0.015286</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>2435</td>
      <td>11202</td>
      <td>6542</td>
      <td>0.003323</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>2230</td>
      <td>6542</td>
      <td>989</td>
      <td>0.034467</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Java, ByteCode, Constructor, Method, Member]</td>
      <td>WRITES</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>1971</td>
      <td>1648</td>
      <td>2848</td>
      <td>0.041994</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Java, ByteCode, Method, Member]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>1892</td>
      <td>10568</td>
      <td>597</td>
      <td>0.029988</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, ExternalType, Ext...</td>
      <td>1842</td>
      <td>2225</td>
      <td>65</td>
      <td>1.273639</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>1819</td>
      <td>11202</td>
      <td>6316</td>
      <td>0.002571</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Java, ByteCode, Constructor, Method, Member]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Constructor, Method, Member]</td>
      <td>1741</td>
      <td>1648</td>
      <td>1648</td>
      <td>0.064104</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Java, ByteCode, Constructor, Method, Member]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>1710</td>
      <td>1648</td>
      <td>11202</td>
      <td>0.009263</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Java, ByteCode, Method, Member]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Constructor, Method, Member]</td>
      <td>1697</td>
      <td>10568</td>
      <td>1648</td>
      <td>0.009744</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>ANNOTATED_BY</td>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>1594</td>
      <td>11202</td>
      <td>2225</td>
      <td>0.006395</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, ByteCode, Constructor, Method, Member]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Method, Member]</td>
      <td>1539</td>
      <td>1648</td>
      <td>10568</td>
      <td>0.008837</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 307227
    total_number_of_relationships (edges): 953778
    -> total directed graph density: 1.0104851931987106e-05
    -> total directed graph density in percent: 0.0010104851931987105

