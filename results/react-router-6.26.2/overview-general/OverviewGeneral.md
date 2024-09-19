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

    Total number of nodes: 95259





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
      <td>73974</td>
      <td>77.655655</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Commit]</td>
      <td>9993</td>
      <td>10.490347</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Git]</td>
      <td>5102</td>
      <td>5.355924</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Author, Git, Person]</td>
      <td>1183</td>
      <td>1.241877</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Tag]</td>
      <td>1080</td>
      <td>1.133751</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Json, Key]</td>
      <td>668</td>
      <td>0.701246</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Json, Value, Scalar]</td>
      <td>603</td>
      <td>0.633011</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Committer, Git, Person]</td>
      <td>371</td>
      <td>0.389465</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[NPM, Dependency]</td>
      <td>330</td>
      <td>0.346424</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Type, TS, Primitive, ExternalType]</td>
      <td>285</td>
      <td>0.299184</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>272</td>
      <td>0.285537</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[TS, ExternalDeclaration]</td>
      <td>215</td>
      <td>0.225700</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Type, TS, Literal, ExternalType]</td>
      <td>136</td>
      <td>0.142769</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Json, Value, Object]</td>
      <td>133</td>
      <td>0.139619</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>117</td>
      <td>0.122823</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, TS, ObjectMember, ExternalType]</td>
      <td>98</td>
      <td>0.102877</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[NPM, Script]</td>
      <td>91</td>
      <td>0.095529</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[TS, Property]</td>
      <td>65</td>
      <td>0.068235</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, Function]</td>
      <td>47</td>
      <td>0.049339</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, Object, TS, ExternalType]</td>
      <td>38</td>
      <td>0.039891</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, TS, FunctionParameter, ExternalType]</td>
      <td>37</td>
      <td>0.038841</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[File, Directory]</td>
      <td>34</td>
      <td>0.035692</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[TS, Parameter]</td>
      <td>33</td>
      <td>0.034642</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Type, TS, Function, ExternalType]</td>
      <td>32</td>
      <td>0.033593</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Package, File, Json, NPM]</td>
      <td>29</td>
      <td>0.030443</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Git, Branch]</td>
      <td>27</td>
      <td>0.028344</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, ExternalModule]</td>
      <td>25</td>
      <td>0.026244</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[TS, Variable]</td>
      <td>24</td>
      <td>0.025194</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Value, TS, Literal]</td>
      <td>20</td>
      <td>0.020995</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.019946</td>
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
      <td>0.001050</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[File, TS, Scan]</td>
      <td>1</td>
      <td>0.001050</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[TS, Method]</td>
      <td>1</td>
      <td>0.001050</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Value, TS, ObjectMember]</td>
      <td>1</td>
      <td>0.001050</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[TS, Constructor]</td>
      <td>1</td>
      <td>0.001050</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[TS, Class]</td>
      <td>1</td>
      <td>0.001050</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[TS, Enum]</td>
      <td>2</td>
      <td>0.002100</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Value, Object, TS]</td>
      <td>3</td>
      <td>0.003149</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Type, TS, Tuple, ExternalType]</td>
      <td>3</td>
      <td>0.003149</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Value, TS, Function]</td>
      <td>4</td>
      <td>0.004199</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[TS, TypeParameter]</td>
      <td>4</td>
      <td>0.004199</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Value, TS, Complex]</td>
      <td>5</td>
      <td>0.005249</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[NPM, Engine]</td>
      <td>6</td>
      <td>0.006299</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Project, TS]</td>
      <td>6</td>
      <td>0.006299</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[File, Local]</td>
      <td>6</td>
      <td>0.006299</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Value, TS, Call]</td>
      <td>6</td>
      <td>0.006299</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Value, TS, Member]</td>
      <td>6</td>
      <td>0.006299</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[File, TS, Local, Module]</td>
      <td>6</td>
      <td>0.006299</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Type, TS, TypeParameterReference, ExternalType]</td>
      <td>6</td>
      <td>0.006299</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[TS, EnumMember]</td>
      <td>8</td>
      <td>0.008398</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, TS, NotIdentified, ExternalType]</td>
      <td>11</td>
      <td>0.011547</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Json, Value, Array]</td>
      <td>12</td>
      <td>0.012597</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Value, TS, Declared]</td>
      <td>13</td>
      <td>0.013647</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[TS, TypeAlias]</td>
      <td>14</td>
      <td>0.014697</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[File, Directory, Local]</td>
      <td>16</td>
      <td>0.016796</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, TS, Intersection, ExternalType]</td>
      <td>17</td>
      <td>0.017846</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, Interface]</td>
      <td>18</td>
      <td>0.018896</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.019946</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Value, TS, Literal]</td>
      <td>20</td>
      <td>0.020995</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[TS, Variable]</td>
      <td>24</td>
      <td>0.025194</td>
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
      <td>91730</td>
      <td>96.295363</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>73974</td>
      <td>77.655655</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Commit</td>
      <td>9993</td>
      <td>10.490347</td>
    </tr>
    <tr>
      <th>3</th>
      <td>File</td>
      <td>5194</td>
      <td>5.452503</td>
    </tr>
    <tr>
      <th>4</th>
      <td>TS</td>
      <td>1581</td>
      <td>1.659686</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Person</td>
      <td>1554</td>
      <td>1.631342</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Json</td>
      <td>1445</td>
      <td>1.516917</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Author</td>
      <td>1183</td>
      <td>1.241877</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Tag</td>
      <td>1080</td>
      <td>1.133751</td>
    </tr>
    <tr>
      <th>9</th>
      <td>ExternalType</td>
      <td>1052</td>
      <td>1.104358</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Type</td>
      <td>1052</td>
      <td>1.104358</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Value</td>
      <td>806</td>
      <td>0.846114</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Key</td>
      <td>668</td>
      <td>0.701246</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Scalar</td>
      <td>603</td>
      <td>0.633011</td>
    </tr>
    <tr>
      <th>14</th>
      <td>NPM</td>
      <td>456</td>
      <td>0.478695</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Committer</td>
      <td>371</td>
      <td>0.389465</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Dependency</td>
      <td>330</td>
      <td>0.346424</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Declared</td>
      <td>285</td>
      <td>0.299184</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Primitive</td>
      <td>285</td>
      <td>0.299184</td>
    </tr>
    <tr>
      <th>19</th>
      <td>ExternalDeclaration</td>
      <td>215</td>
      <td>0.225700</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Object</td>
      <td>174</td>
      <td>0.182660</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Literal</td>
      <td>156</td>
      <td>0.163764</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Union</td>
      <td>117</td>
      <td>0.122823</td>
    </tr>
    <tr>
      <th>23</th>
      <td>ObjectMember</td>
      <td>99</td>
      <td>0.103927</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Script</td>
      <td>91</td>
      <td>0.095529</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Function</td>
      <td>83</td>
      <td>0.087131</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Property</td>
      <td>65</td>
      <td>0.068235</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Directory</td>
      <td>50</td>
      <td>0.052488</td>
    </tr>
    <tr>
      <th>28</th>
      <td>FunctionParameter</td>
      <td>37</td>
      <td>0.038841</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Parameter</td>
      <td>33</td>
      <td>0.034642</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Package</td>
      <td>29</td>
      <td>0.030443</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Local</td>
      <td>28</td>
      <td>0.029394</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Branch</td>
      <td>27</td>
      <td>0.028344</td>
    </tr>
    <tr>
      <th>33</th>
      <td>ExternalModule</td>
      <td>25</td>
      <td>0.026244</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Variable</td>
      <td>24</td>
      <td>0.025194</td>
    </tr>
    <tr>
      <th>35</th>
      <td>jQAssistant</td>
      <td>20</td>
      <td>0.020995</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Concept</td>
      <td>19</td>
      <td>0.019946</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Rule</td>
      <td>19</td>
      <td>0.019946</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Interface</td>
      <td>18</td>
      <td>0.018896</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Intersection</td>
      <td>17</td>
      <td>0.017846</td>
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

    Total number of relationships: 266102





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
      <td>73974</td>
      <td>27.799115</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>73974</td>
      <td>27.799115</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>49121</td>
      <td>18.459463</td>
    </tr>
    <tr>
      <th>3</th>
      <td>COMMITTED</td>
      <td>19986</td>
      <td>7.510654</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CREATES</td>
      <td>17384</td>
      <td>6.532833</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_PARENT</td>
      <td>11005</td>
      <td>4.135632</td>
    </tr>
    <tr>
      <th>6</th>
      <td>DELETES</td>
      <td>10220</td>
      <td>3.840633</td>
    </tr>
    <tr>
      <th>7</th>
      <td>RENAMES</td>
      <td>2751</td>
      <td>1.033814</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_NEW_NAME</td>
      <td>1560</td>
      <td>0.586241</td>
    </tr>
    <tr>
      <th>9</th>
      <td>ON_COMMIT</td>
      <td>1080</td>
      <td>0.405859</td>
    </tr>
    <tr>
      <th>10</th>
      <td>DEPENDS_ON</td>
      <td>962</td>
      <td>0.361516</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_KEY</td>
      <td>668</td>
      <td>0.251032</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS_VALUE</td>
      <td>668</td>
      <td>0.251032</td>
    </tr>
    <tr>
      <th>13</th>
      <td>CONTAINS</td>
      <td>589</td>
      <td>0.221344</td>
    </tr>
    <tr>
      <th>14</th>
      <td>OF_TYPE</td>
      <td>329</td>
      <td>0.123637</td>
    </tr>
    <tr>
      <th>15</th>
      <td>EXPORTS</td>
      <td>275</td>
      <td>0.103344</td>
    </tr>
    <tr>
      <th>16</th>
      <td>REFERENCES</td>
      <td>196</td>
      <td>0.073656</td>
    </tr>
    <tr>
      <th>17</th>
      <td>DECLARES</td>
      <td>185</td>
      <td>0.069522</td>
    </tr>
    <tr>
      <th>18</th>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>169</td>
      <td>0.063509</td>
    </tr>
    <tr>
      <th>19</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>0.060503</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_MEMBER</td>
      <td>99</td>
      <td>0.037204</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>92</td>
      <td>0.034573</td>
    </tr>
    <tr>
      <th>22</th>
      <td>DECLARES_SCRIPT</td>
      <td>91</td>
      <td>0.034197</td>
    </tr>
    <tr>
      <th>23</th>
      <td>RESOLVES_TO</td>
      <td>80</td>
      <td>0.030064</td>
    </tr>
    <tr>
      <th>24</th>
      <td>RETURNS</td>
      <td>80</td>
      <td>0.030064</td>
    </tr>
    <tr>
      <th>25</th>
      <td>HAS_PARAMETER</td>
      <td>70</td>
      <td>0.026306</td>
    </tr>
    <tr>
      <th>26</th>
      <td>CONTAINS_VALUE</td>
      <td>51</td>
      <td>0.019166</td>
    </tr>
    <tr>
      <th>27</th>
      <td>COPIES</td>
      <td>43</td>
      <td>0.016159</td>
    </tr>
    <tr>
      <th>28</th>
      <td>INITIALIZED_WITH</td>
      <td>32</td>
      <td>0.012025</td>
    </tr>
    <tr>
      <th>29</th>
      <td>COPY_OF</td>
      <td>28</td>
      <td>0.010522</td>
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
      <td>CONSTRAINED_BY</td>
      <td>4</td>
      <td>0.001503</td>
    </tr>
    <tr>
      <th>1</th>
      <td>REFERENCED_PROJECTS</td>
      <td>5</td>
      <td>0.001879</td>
    </tr>
    <tr>
      <th>2</th>
      <td>MEMBER</td>
      <td>6</td>
      <td>0.002255</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HAS_ROOT</td>
      <td>6</td>
      <td>0.002255</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HAS_NPM_PACKAGE</td>
      <td>6</td>
      <td>0.002255</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_CONFIG</td>
      <td>6</td>
      <td>0.002255</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_ARGUMENT</td>
      <td>6</td>
      <td>0.002255</td>
    </tr>
    <tr>
      <th>7</th>
      <td>DECLARES_ENGINE</td>
      <td>6</td>
      <td>0.002255</td>
    </tr>
    <tr>
      <th>8</th>
      <td>CONTAINS_PROJECT</td>
      <td>6</td>
      <td>0.002255</td>
    </tr>
    <tr>
      <th>9</th>
      <td>CALLS</td>
      <td>6</td>
      <td>0.002255</td>
    </tr>
    <tr>
      <th>10</th>
      <td>PARENT</td>
      <td>6</td>
      <td>0.002255</td>
    </tr>
    <tr>
      <th>11</th>
      <td>EXTENDS</td>
      <td>7</td>
      <td>0.002631</td>
    </tr>
    <tr>
      <th>12</th>
      <td>SIMILAR</td>
      <td>10</td>
      <td>0.003758</td>
    </tr>
    <tr>
      <th>13</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.007140</td>
    </tr>
    <tr>
      <th>14</th>
      <td>USES</td>
      <td>25</td>
      <td>0.009395</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_HEAD</td>
      <td>27</td>
      <td>0.010146</td>
    </tr>
    <tr>
      <th>16</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.010522</td>
    </tr>
    <tr>
      <th>17</th>
      <td>COPY_OF</td>
      <td>28</td>
      <td>0.010522</td>
    </tr>
    <tr>
      <th>18</th>
      <td>INITIALIZED_WITH</td>
      <td>32</td>
      <td>0.012025</td>
    </tr>
    <tr>
      <th>19</th>
      <td>COPIES</td>
      <td>43</td>
      <td>0.016159</td>
    </tr>
    <tr>
      <th>20</th>
      <td>CONTAINS_VALUE</td>
      <td>51</td>
      <td>0.019166</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_PARAMETER</td>
      <td>70</td>
      <td>0.026306</td>
    </tr>
    <tr>
      <th>22</th>
      <td>RETURNS</td>
      <td>80</td>
      <td>0.030064</td>
    </tr>
    <tr>
      <th>23</th>
      <td>RESOLVES_TO</td>
      <td>80</td>
      <td>0.030064</td>
    </tr>
    <tr>
      <th>24</th>
      <td>DECLARES_SCRIPT</td>
      <td>91</td>
      <td>0.034197</td>
    </tr>
    <tr>
      <th>25</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>92</td>
      <td>0.034573</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_MEMBER</td>
      <td>99</td>
      <td>0.037204</td>
    </tr>
    <tr>
      <th>27</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>0.060503</td>
    </tr>
    <tr>
      <th>28</th>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>169</td>
      <td>0.063509</td>
    </tr>
    <tr>
      <th>29</th>
      <td>DECLARES</td>
      <td>185</td>
      <td>0.069522</td>
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
      <td>73974</td>
      <td>9993</td>
      <td>73974</td>
      <td>0.010007</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>73974</td>
      <td>73974</td>
      <td>5102</td>
      <td>0.019600</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>49121</td>
      <td>73974</td>
      <td>5102</td>
      <td>0.013015</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>17384</td>
      <td>73974</td>
      <td>5102</td>
      <td>0.004606</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>11005</td>
      <td>9993</td>
      <td>9993</td>
      <td>0.011020</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>10220</td>
      <td>73974</td>
      <td>5102</td>
      <td>0.002708</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>9993</td>
      <td>1183</td>
      <td>9993</td>
      <td>0.084531</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>9993</td>
      <td>371</td>
      <td>9993</td>
      <td>0.269542</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>2751</td>
      <td>73974</td>
      <td>5102</td>
      <td>0.000729</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>1560</td>
      <td>5102</td>
      <td>5102</td>
      <td>0.005993</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Git, Tag]</td>
      <td>ON_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>1080</td>
      <td>1080</td>
      <td>9993</td>
      <td>0.010007</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Json, Value, Object]</td>
      <td>HAS_KEY</td>
      <td>[Json, Key]</td>
      <td>668</td>
      <td>133</td>
      <td>668</td>
      <td>0.751880</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Json, Key]</td>
      <td>HAS_VALUE</td>
      <td>[Json, Value, Scalar]</td>
      <td>552</td>
      <td>668</td>
      <td>603</td>
      <td>0.137039</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>285</td>
      <td>47</td>
      <td>215</td>
      <td>2.820386</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[TS, ExternalModule]</td>
      <td>EXPORTS</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>215</td>
      <td>25</td>
      <td>215</td>
      <td>4.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>[NPM, Dependency]</td>
      <td>169</td>
      <td>29</td>
      <td>330</td>
      <td>1.765935</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_DEPENDENCY</td>
      <td>[NPM, Dependency]</td>
      <td>161</td>
      <td>29</td>
      <td>330</td>
      <td>1.682341</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[File, TS, Local, Module, Mark4ModuleWeaklyCon...</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>152</td>
      <td>2</td>
      <td>215</td>
      <td>35.348837</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Primitive, ExternalType]</td>
      <td>144</td>
      <td>117</td>
      <td>285</td>
      <td>0.431849</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>REFERENCES</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>141</td>
      <td>272</td>
      <td>215</td>
      <td>0.241108</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalModule]</td>
      <td>131</td>
      <td>47</td>
      <td>25</td>
      <td>11.148936</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Literal, ExternalType]</td>
      <td>119</td>
      <td>117</td>
      <td>136</td>
      <td>0.747863</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Json, Key]</td>
      <td>HAS_VALUE</td>
      <td>[Json, Value, Object]</td>
      <td>104</td>
      <td>668</td>
      <td>133</td>
      <td>0.117059</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Type, Object, TS, ExternalType]</td>
      <td>HAS_MEMBER</td>
      <td>[Type, TS, ObjectMember, ExternalType]</td>
      <td>98</td>
      <td>38</td>
      <td>98</td>
      <td>2.631579</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_SCRIPT</td>
      <td>[NPM, Script]</td>
      <td>91</td>
      <td>29</td>
      <td>91</td>
      <td>3.448276</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>69</td>
      <td>117</td>
      <td>272</td>
      <td>0.216817</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[File, Directory]</td>
      <td>CONTAINS</td>
      <td>[File, Directory]</td>
      <td>63</td>
      <td>34</td>
      <td>34</td>
      <td>5.449827</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[TS, Interface]</td>
      <td>DECLARES</td>
      <td>[TS, Property]</td>
      <td>61</td>
      <td>18</td>
      <td>65</td>
      <td>5.213675</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[File, Directory]</td>
      <td>CONTAINS</td>
      <td>[Package, File, Json, NPM]</td>
      <td>58</td>
      <td>34</td>
      <td>29</td>
      <td>5.882353</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[File, Git]</td>
      <td>RESOLVES_TO</td>
      <td>[Package, File, Json, NPM]</td>
      <td>57</td>
      <td>5102</td>
      <td>29</td>
      <td>0.038524</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 95259
    total_number_of_relationships (edges): 266102
    -> total directed graph density: 2.932517831578447e-05
    -> total directed graph density in percent: 0.0029325178315784467

