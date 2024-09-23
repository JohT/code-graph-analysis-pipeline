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

    Total number of nodes: 321907





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
      <td>233757</td>
      <td>72.616315</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>13204</td>
      <td>4.101806</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>12968</td>
      <td>4.028493</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Commit]</td>
      <td>11775</td>
      <td>3.657889</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[File, Git]</td>
      <td>10597</td>
      <td>3.291945</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>7154</td>
      <td>2.222381</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>7094</td>
      <td>2.203742</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>3491</td>
      <td>1.084475</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2902</td>
      <td>0.901503</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>2813</td>
      <td>0.873855</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Xml, Element]</td>
      <td>2144</td>
      <td>0.666031</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>2044</td>
      <td>0.634966</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Xml, Text]</td>
      <td>1436</td>
      <td>0.446092</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>1094</td>
      <td>0.339850</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>931</td>
      <td>0.289214</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, File, Java, ByteCode, ResolvedDuplicate...</td>
      <td>899</td>
      <td>0.279273</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, File, Java, Class, ByteCode]</td>
      <td>858</td>
      <td>0.266537</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>746</td>
      <td>0.231744</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, Value, ByteCode, Primitive]</td>
      <td>647</td>
      <td>0.200990</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, Member, Method, GenericDeclar...</td>
      <td>567</td>
      <td>0.176138</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Json, Key]</td>
      <td>555</td>
      <td>0.172410</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Value, Json, Scalar]</td>
      <td>539</td>
      <td>0.167440</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, ExternalType]</td>
      <td>396</td>
      <td>0.123017</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Author, Git, Person]</td>
      <td>289</td>
      <td>0.089777</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Value, Array]</td>
      <td>267</td>
      <td>0.082943</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Committer, Git, Person]</td>
      <td>243</td>
      <td>0.075488</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, File, Java, Class, ByteCode, GenericDec...</td>
      <td>236</td>
      <td>0.073313</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Value, Property]</td>
      <td>202</td>
      <td>0.062751</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>186</td>
      <td>0.057781</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, Value, Class, ByteCode]</td>
      <td>170</td>
      <td>0.052810</td>
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
      <td>0.000311</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[File, TS, Scan]</td>
      <td>1</td>
      <td>0.000311</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Json]</td>
      <td>2</td>
      <td>0.000621</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[File]</td>
      <td>3</td>
      <td>0.000932</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Java, ByteCode, Member, Constructor, Method, ...</td>
      <td>4</td>
      <td>0.001243</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Maven, Exclusion]</td>
      <td>5</td>
      <td>0.001553</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Value, Array, Json]</td>
      <td>6</td>
      <td>0.001864</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Type, File, Java, ByteCode, Void]</td>
      <td>9</td>
      <td>0.002796</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[File, Maven, Xml, Pom, Document]</td>
      <td>9</td>
      <td>0.002796</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Java, ManifestSection]</td>
      <td>9</td>
      <td>0.002796</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[File, Java, Manifest]</td>
      <td>9</td>
      <td>0.002796</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Artifact, File, Jar, Archive, Zip, Java]</td>
      <td>9</td>
      <td>0.002796</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[File, Java, ServiceLoader]</td>
      <td>10</td>
      <td>0.003106</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[File, Java, Properties]</td>
      <td>12</td>
      <td>0.003728</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Maven, ExecutionGoal]</td>
      <td>16</td>
      <td>0.004970</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Maven, PluginExecution]</td>
      <td>16</td>
      <td>0.004970</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Xml, Attribute]</td>
      <td>18</td>
      <td>0.005592</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.005902</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Maven, Plugin]</td>
      <td>21</td>
      <td>0.006524</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Maven, Configuration]</td>
      <td>21</td>
      <td>0.006524</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Git, Branch]</td>
      <td>24</td>
      <td>0.007456</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Type, File, Java, ByteCode, Enum]</td>
      <td>28</td>
      <td>0.008698</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, File, Java, ByteCode, PrimitiveType]</td>
      <td>29</td>
      <td>0.009009</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Xml, Namespace]</td>
      <td>36</td>
      <td>0.011183</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, File, Java, ByteCode, Annotation]</td>
      <td>43</td>
      <td>0.013358</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[File, Directory]</td>
      <td>44</td>
      <td>0.013669</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>85</td>
      <td>0.026405</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Artifact, Maven]</td>
      <td>92</td>
      <td>0.028580</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>93</td>
      <td>0.028890</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, ManifestEntry]</td>
      <td>120</td>
      <td>0.037278</td>
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
      <td>256852</td>
      <td>79.790747</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>233757</td>
      <td>72.616315</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Java</td>
      <td>59187</td>
      <td>18.386366</td>
    </tr>
    <tr>
      <th>3</th>
      <td>ByteCode</td>
      <td>58999</td>
      <td>18.327964</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Member</td>
      <td>20241</td>
      <td>6.287841</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Bound</td>
      <td>18402</td>
      <td>5.716558</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Method</td>
      <td>16750</td>
      <td>5.203366</td>
    </tr>
    <tr>
      <th>7</th>
      <td>File</td>
      <td>14443</td>
      <td>4.486700</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Parameter</td>
      <td>12968</td>
      <td>4.028493</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Commit</td>
      <td>11775</td>
      <td>3.657889</td>
    </tr>
    <tr>
      <th>10</th>
      <td>ParameterizedType</td>
      <td>7154</td>
      <td>2.222381</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Value</td>
      <td>5046</td>
      <td>1.567533</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Xml</td>
      <td>3643</td>
      <td>1.131693</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Type</td>
      <td>3608</td>
      <td>1.120821</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Field</td>
      <td>3491</td>
      <td>1.084475</td>
    </tr>
    <tr>
      <th>15</th>
      <td>WildcardType</td>
      <td>2902</td>
      <td>0.901503</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Annotation</td>
      <td>2856</td>
      <td>0.887213</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Element</td>
      <td>2144</td>
      <td>0.666031</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Constructor</td>
      <td>2048</td>
      <td>0.636209</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Text</td>
      <td>1436</td>
      <td>0.446092</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Class</td>
      <td>1264</td>
      <td>0.392660</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Json</td>
      <td>1234</td>
      <td>0.383341</td>
    </tr>
    <tr>
      <th>22</th>
      <td>TypeVariable</td>
      <td>1094</td>
      <td>0.339850</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Lambda</td>
      <td>931</td>
      <td>0.289214</td>
    </tr>
    <tr>
      <th>24</th>
      <td>ResolvedDuplicateType</td>
      <td>899</td>
      <td>0.279273</td>
    </tr>
    <tr>
      <th>25</th>
      <td>GenericDeclaration</td>
      <td>892</td>
      <td>0.277099</td>
    </tr>
    <tr>
      <th>26</th>
      <td>JavaType</td>
      <td>746</td>
      <td>0.231744</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Primitive</td>
      <td>647</td>
      <td>0.200990</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Key</td>
      <td>555</td>
      <td>0.172410</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Scalar</td>
      <td>539</td>
      <td>0.167440</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Person</td>
      <td>532</td>
      <td>0.165265</td>
    </tr>
    <tr>
      <th>31</th>
      <td>ExternalType</td>
      <td>489</td>
      <td>0.151907</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Maven</td>
      <td>343</td>
      <td>0.106553</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Author</td>
      <td>289</td>
      <td>0.089777</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Array</td>
      <td>273</td>
      <td>0.084807</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Interface</td>
      <td>271</td>
      <td>0.084186</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Committer</td>
      <td>243</td>
      <td>0.075488</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Property</td>
      <td>202</td>
      <td>0.062751</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Directory</td>
      <td>183</td>
      <td>0.056849</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Enum</td>
      <td>178</td>
      <td>0.055295</td>
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

    Total number of relationships: 975790





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
      <td>233757</td>
      <td>23.955667</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>233757</td>
      <td>23.955667</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>150076</td>
      <td>15.379949</td>
    </tr>
    <tr>
      <th>3</th>
      <td>CREATES</td>
      <td>57924</td>
      <td>5.936113</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DELETES</td>
      <td>35673</td>
      <td>3.655807</td>
    </tr>
    <tr>
      <th>5</th>
      <td>INVOKES</td>
      <td>35534</td>
      <td>3.641562</td>
    </tr>
    <tr>
      <th>6</th>
      <td>COMMITTED</td>
      <td>23550</td>
      <td>2.413429</td>
    </tr>
    <tr>
      <th>7</th>
      <td>DEPENDS_ON</td>
      <td>21820</td>
      <td>2.236137</td>
    </tr>
    <tr>
      <th>8</th>
      <td>OF_TYPE</td>
      <td>21292</td>
      <td>2.182027</td>
    </tr>
    <tr>
      <th>9</th>
      <td>DECLARES</td>
      <td>20680</td>
      <td>2.119308</td>
    </tr>
    <tr>
      <th>10</th>
      <td>OF_RAW_TYPE</td>
      <td>17041</td>
      <td>1.746380</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_PARENT</td>
      <td>14309</td>
      <td>1.466402</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS</td>
      <td>14057</td>
      <td>1.440576</td>
    </tr>
    <tr>
      <th>13</th>
      <td>RETURNS</td>
      <td>12524</td>
      <td>1.283473</td>
    </tr>
    <tr>
      <th>14</th>
      <td>RENAMES</td>
      <td>9916</td>
      <td>1.016202</td>
    </tr>
    <tr>
      <th>15</th>
      <td>READS</td>
      <td>9069</td>
      <td>0.929401</td>
    </tr>
    <tr>
      <th>16</th>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>8261</td>
      <td>0.846596</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_NEW_NAME</td>
      <td>6165</td>
      <td>0.631796</td>
    </tr>
    <tr>
      <th>18</th>
      <td>OF_GENERIC_TYPE</td>
      <td>5892</td>
      <td>0.603818</td>
    </tr>
    <tr>
      <th>19</th>
      <td>RESOLVES_TO</td>
      <td>5241</td>
      <td>0.537103</td>
    </tr>
    <tr>
      <th>20</th>
      <td>SIMILAR</td>
      <td>3955</td>
      <td>0.405313</td>
    </tr>
    <tr>
      <th>21</th>
      <td>CONTAINS</td>
      <td>3797</td>
      <td>0.389121</td>
    </tr>
    <tr>
      <th>22</th>
      <td>WRITES</td>
      <td>3796</td>
      <td>0.389018</td>
    </tr>
    <tr>
      <th>23</th>
      <td>RETURNS_GENERIC</td>
      <td>3538</td>
      <td>0.362578</td>
    </tr>
    <tr>
      <th>24</th>
      <td>ANNOTATED_BY</td>
      <td>2801</td>
      <td>0.287049</td>
    </tr>
    <tr>
      <th>25</th>
      <td>REQUIRES</td>
      <td>2172</td>
      <td>0.222589</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_FIRST_CHILD</td>
      <td>2144</td>
      <td>0.219719</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_LAST_CHILD</td>
      <td>2144</td>
      <td>0.219719</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_ELEMENT</td>
      <td>2126</td>
      <td>0.217875</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_UPPER_BOUND</td>
      <td>1519</td>
      <td>0.155669</td>
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
      <td>HAS_PROPERTY</td>
      <td>1</td>
      <td>0.000102</td>
    </tr>
    <tr>
      <th>1</th>
      <td>THROWS_GENERIC</td>
      <td>5</td>
      <td>0.000512</td>
    </tr>
    <tr>
      <th>2</th>
      <td>EXCLUDES</td>
      <td>5</td>
      <td>0.000512</td>
    </tr>
    <tr>
      <th>3</th>
      <td>DESCRIBES</td>
      <td>9</td>
      <td>0.000922</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HAS_ROOT_ELEMENT</td>
      <td>11</td>
      <td>0.001127</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_GOAL</td>
      <td>16</td>
      <td>0.001640</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_EXECUTION</td>
      <td>16</td>
      <td>0.001640</td>
    </tr>
    <tr>
      <th>7</th>
      <td>OF_NAMESPACE</td>
      <td>18</td>
      <td>0.001845</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_ATTRIBUTE</td>
      <td>18</td>
      <td>0.001845</td>
    </tr>
    <tr>
      <th>9</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.001947</td>
    </tr>
    <tr>
      <th>10</th>
      <td>USES_PLUGIN</td>
      <td>21</td>
      <td>0.002152</td>
    </tr>
    <tr>
      <th>11</th>
      <td>REQUIRES_TYPE_PARAMETER</td>
      <td>21</td>
      <td>0.002152</td>
    </tr>
    <tr>
      <th>12</th>
      <td>IS_ARTIFACT</td>
      <td>21</td>
      <td>0.002152</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_CONFIGURATION</td>
      <td>21</td>
      <td>0.002152</td>
    </tr>
    <tr>
      <th>14</th>
      <td>HAS_HEAD</td>
      <td>24</td>
      <td>0.002460</td>
    </tr>
    <tr>
      <th>15</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.002869</td>
    </tr>
    <tr>
      <th>16</th>
      <td>DECLARES_NAMESPACE</td>
      <td>36</td>
      <td>0.003689</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_DEFAULT</td>
      <td>36</td>
      <td>0.003689</td>
    </tr>
    <tr>
      <th>18</th>
      <td>CONTAINS_VALUE</td>
      <td>120</td>
      <td>0.012298</td>
    </tr>
    <tr>
      <th>19</th>
      <td>COPY_OF</td>
      <td>125</td>
      <td>0.012810</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_COMPONENT_TYPE</td>
      <td>158</td>
      <td>0.016192</td>
    </tr>
    <tr>
      <th>21</th>
      <td>TO_ARTIFACT</td>
      <td>163</td>
      <td>0.016704</td>
    </tr>
    <tr>
      <th>22</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>163</td>
      <td>0.016704</td>
    </tr>
    <tr>
      <th>23</th>
      <td>ON_COMMIT</td>
      <td>167</td>
      <td>0.017114</td>
    </tr>
    <tr>
      <th>24</th>
      <td>COPIES</td>
      <td>323</td>
      <td>0.033101</td>
    </tr>
    <tr>
      <th>25</th>
      <td>IMPLEMENTS_GENERIC</td>
      <td>371</td>
      <td>0.038020</td>
    </tr>
    <tr>
      <th>26</th>
      <td>IS</td>
      <td>375</td>
      <td>0.038430</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_LOWER_BOUND</td>
      <td>433</td>
      <td>0.044374</td>
    </tr>
    <tr>
      <th>28</th>
      <td>EXTENDS_GENERIC</td>
      <td>506</td>
      <td>0.051855</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_VALUE</td>
      <td>555</td>
      <td>0.056877</td>
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
      <td>233757</td>
      <td>11775</td>
      <td>233757</td>
      <td>0.008493</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>233757</td>
      <td>233757</td>
      <td>10597</td>
      <td>0.009437</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>150076</td>
      <td>233757</td>
      <td>10597</td>
      <td>0.006058</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>57924</td>
      <td>233757</td>
      <td>10597</td>
      <td>0.002338</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>35673</td>
      <td>233757</td>
      <td>10597</td>
      <td>0.001440</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>21587</td>
      <td>13094</td>
      <td>13094</td>
      <td>0.012591</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>14300</td>
      <td>11775</td>
      <td>11775</td>
      <td>0.010314</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>11775</td>
      <td>289</td>
      <td>11775</td>
      <td>0.346021</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>11775</td>
      <td>243</td>
      <td>11775</td>
      <td>0.411523</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>9916</td>
      <td>233757</td>
      <td>10597</td>
      <td>0.000400</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>8297</td>
      <td>13094</td>
      <td>12968</td>
      <td>0.004886</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>READS</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>8140</td>
      <td>13094</td>
      <td>3491</td>
      <td>0.017807</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>6335</td>
      <td>12968</td>
      <td>746</td>
      <td>0.065484</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>6165</td>
      <td>10597</td>
      <td>10597</td>
      <td>0.005490</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Java, ByteCode, Bound]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3554</td>
      <td>7094</td>
      <td>746</td>
      <td>0.067156</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>OF_RAW_TYPE</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>3034</td>
      <td>7154</td>
      <td>746</td>
      <td>0.056850</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, WildcardType]</td>
      <td>2902</td>
      <td>7154</td>
      <td>2902</td>
      <td>0.013978</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>2650</td>
      <td>12968</td>
      <td>7154</td>
      <td>0.002856</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound, TypeVariable]</td>
      <td>2453</td>
      <td>7154</td>
      <td>1094</td>
      <td>0.031342</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>WRITES</td>
      <td>[Java, ByteCode, Member, Field]</td>
      <td>2423</td>
      <td>2044</td>
      <td>3491</td>
      <td>0.033956</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Java, Value, ByteCode, Annotation]</td>
      <td>OF_TYPE</td>
      <td>[Type, File, Java, ByteCode, ExternalAnnotatio...</td>
      <td>2336</td>
      <td>2813</td>
      <td>93</td>
      <td>0.892936</td>
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
      <td>2109</td>
      <td>2044</td>
      <td>2044</td>
      <td>0.050479</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>RETURNS</td>
      <td>[Type, File, Java, ByteCode, JavaType]</td>
      <td>2087</td>
      <td>13094</td>
      <td>746</td>
      <td>0.021365</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>2032</td>
      <td>13094</td>
      <td>2044</td>
      <td>0.007592</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>HAS</td>
      <td>[Java, ByteCode, Parameter]</td>
      <td>2021</td>
      <td>2044</td>
      <td>12968</td>
      <td>0.007625</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Java, ByteCode, Parameter]</td>
      <td>OF_GENERIC_TYPE</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>2020</td>
      <td>12968</td>
      <td>7094</td>
      <td>0.002196</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Java, ByteCode, Member, Method, Lambda]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1866</td>
      <td>931</td>
      <td>13094</td>
      <td>0.015307</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Java, ByteCode, Member, Constructor, Method]</td>
      <td>INVOKES</td>
      <td>[Java, ByteCode, Member, Method]</td>
      <td>1795</td>
      <td>2044</td>
      <td>13094</td>
      <td>0.006707</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Java, ByteCode, Bound, ParameterizedType]</td>
      <td>HAS_ACTUAL_TYPE_ARGUMENT</td>
      <td>[Java, ByteCode, Bound]</td>
      <td>1792</td>
      <td>7154</td>
      <td>7094</td>
      <td>0.003531</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 321907
    total_number_of_relationships (edges): 975790
    -> total directed graph density: 9.416659585083697e-06
    -> total directed graph density in percent: 0.0009416659585083697

