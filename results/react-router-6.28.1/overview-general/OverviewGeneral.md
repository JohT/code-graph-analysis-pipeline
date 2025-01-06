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
      <td>82761</td>
      <td>78.413742</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Commit]</td>
      <td>10698</td>
      <td>10.136057</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Git]</td>
      <td>5512</td>
      <td>5.222466</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Tag]</td>
      <td>1377</td>
      <td>1.304669</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Author, Git, Person]</td>
      <td>1232</td>
      <td>1.167286</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Json, Key]</td>
      <td>668</td>
      <td>0.632911</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Json, Value, Scalar]</td>
      <td>603</td>
      <td>0.571326</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Committer, Git, Person]</td>
      <td>371</td>
      <td>0.351512</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[NPM, Dependency]</td>
      <td>338</td>
      <td>0.320246</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Type, TS, Primitive]</td>
      <td>291</td>
      <td>0.275714</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Type, TS, Declared]</td>
      <td>276</td>
      <td>0.261502</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[TS, ExternalDeclaration]</td>
      <td>214</td>
      <td>0.202759</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Type, TS, Literal]</td>
      <td>136</td>
      <td>0.128856</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Json, Value, Object]</td>
      <td>133</td>
      <td>0.126014</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, TS, Union]</td>
      <td>119</td>
      <td>0.112749</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, TS, ObjectMember]</td>
      <td>101</td>
      <td>0.095695</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[NPM, Script]</td>
      <td>91</td>
      <td>0.086220</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[TS, Property]</td>
      <td>65</td>
      <td>0.061586</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, Function]</td>
      <td>47</td>
      <td>0.044531</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, TS, FunctionParameter]</td>
      <td>40</td>
      <td>0.037899</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, Object, TS]</td>
      <td>39</td>
      <td>0.036951</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Git, Branch]</td>
      <td>36</td>
      <td>0.034109</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[File, Directory]</td>
      <td>34</td>
      <td>0.032214</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Type, TS, Function]</td>
      <td>34</td>
      <td>0.032214</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[TS, Parameter]</td>
      <td>33</td>
      <td>0.031267</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Package, File, Json, NPM]</td>
      <td>29</td>
      <td>0.027477</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, Variable]</td>
      <td>24</td>
      <td>0.022739</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[TS, ExternalModule]</td>
      <td>23</td>
      <td>0.021792</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Value, TS, Literal]</td>
      <td>20</td>
      <td>0.018949</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.018002</td>
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
      <td>0.000947</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[File, TS, Scan]</td>
      <td>1</td>
      <td>0.000947</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[TS, Method]</td>
      <td>1</td>
      <td>0.000947</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Repository, File, Git]</td>
      <td>1</td>
      <td>0.000947</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[TS, Constructor]</td>
      <td>1</td>
      <td>0.000947</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Value, TS, ObjectMember]</td>
      <td>1</td>
      <td>0.000947</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[TS, Class]</td>
      <td>1</td>
      <td>0.000947</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[TS, Enum]</td>
      <td>2</td>
      <td>0.001895</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Value, Object, TS]</td>
      <td>3</td>
      <td>0.002842</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Type, TS, Tuple]</td>
      <td>3</td>
      <td>0.002842</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Value, TS, Function]</td>
      <td>4</td>
      <td>0.003790</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[TS, TypeParameter]</td>
      <td>4</td>
      <td>0.003790</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Value, TS, Complex]</td>
      <td>5</td>
      <td>0.004737</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[NPM, Engine]</td>
      <td>6</td>
      <td>0.005685</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Project, TS]</td>
      <td>6</td>
      <td>0.005685</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[File, Local]</td>
      <td>6</td>
      <td>0.005685</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Value, TS, Call]</td>
      <td>6</td>
      <td>0.005685</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Value, TS, Member]</td>
      <td>6</td>
      <td>0.005685</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[File, TS, Local, Module]</td>
      <td>6</td>
      <td>0.005685</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, TS, TypeParameterReference]</td>
      <td>6</td>
      <td>0.005685</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[TS, EnumMember]</td>
      <td>8</td>
      <td>0.007580</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Type, TS, NotIdentified]</td>
      <td>11</td>
      <td>0.010422</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Json, Value, Array]</td>
      <td>12</td>
      <td>0.011370</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Value, TS, Declared]</td>
      <td>13</td>
      <td>0.012317</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[TS, TypeAlias]</td>
      <td>16</td>
      <td>0.015160</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[File, Directory, Local]</td>
      <td>16</td>
      <td>0.015160</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, Interface]</td>
      <td>17</td>
      <td>0.016107</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Type, TS, Intersection]</td>
      <td>17</td>
      <td>0.016107</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.018002</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Value, TS, Literal]</td>
      <td>20</td>
      <td>0.018949</td>
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
      <td>101988</td>
      <td>96.630789</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>82761</td>
      <td>78.413742</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Commit</td>
      <td>10698</td>
      <td>10.136057</td>
    </tr>
    <tr>
      <th>3</th>
      <td>File</td>
      <td>5605</td>
      <td>5.310581</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Person</td>
      <td>1603</td>
      <td>1.518798</td>
    </tr>
    <tr>
      <th>5</th>
      <td>TS</td>
      <td>1600</td>
      <td>1.515955</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Json</td>
      <td>1445</td>
      <td>1.369097</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Tag</td>
      <td>1377</td>
      <td>1.304669</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Author</td>
      <td>1232</td>
      <td>1.167286</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Type</td>
      <td>1073</td>
      <td>1.016638</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Value</td>
      <td>806</td>
      <td>0.763663</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Key</td>
      <td>668</td>
      <td>0.632911</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Scalar</td>
      <td>603</td>
      <td>0.571326</td>
    </tr>
    <tr>
      <th>13</th>
      <td>NPM</td>
      <td>464</td>
      <td>0.439627</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Committer</td>
      <td>371</td>
      <td>0.351512</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Dependency</td>
      <td>338</td>
      <td>0.320246</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Primitive</td>
      <td>291</td>
      <td>0.275714</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Declared</td>
      <td>289</td>
      <td>0.273819</td>
    </tr>
    <tr>
      <th>18</th>
      <td>ExternalDeclaration</td>
      <td>214</td>
      <td>0.202759</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Object</td>
      <td>175</td>
      <td>0.165808</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Literal</td>
      <td>156</td>
      <td>0.147806</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Union</td>
      <td>119</td>
      <td>0.112749</td>
    </tr>
    <tr>
      <th>22</th>
      <td>ObjectMember</td>
      <td>102</td>
      <td>0.096642</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Script</td>
      <td>91</td>
      <td>0.086220</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Function</td>
      <td>85</td>
      <td>0.080535</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Property</td>
      <td>65</td>
      <td>0.061586</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Directory</td>
      <td>50</td>
      <td>0.047374</td>
    </tr>
    <tr>
      <th>27</th>
      <td>FunctionParameter</td>
      <td>40</td>
      <td>0.037899</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Branch</td>
      <td>36</td>
      <td>0.034109</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Parameter</td>
      <td>33</td>
      <td>0.031267</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Package</td>
      <td>29</td>
      <td>0.027477</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Local</td>
      <td>28</td>
      <td>0.026529</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Variable</td>
      <td>24</td>
      <td>0.022739</td>
    </tr>
    <tr>
      <th>33</th>
      <td>ExternalModule</td>
      <td>23</td>
      <td>0.021792</td>
    </tr>
    <tr>
      <th>34</th>
      <td>jQAssistant</td>
      <td>20</td>
      <td>0.018949</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Concept</td>
      <td>19</td>
      <td>0.018002</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Rule</td>
      <td>19</td>
      <td>0.018002</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Interface</td>
      <td>17</td>
      <td>0.016107</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Intersection</td>
      <td>17</td>
      <td>0.016107</td>
    </tr>
    <tr>
      <th>39</th>
      <td>TypeAlias</td>
      <td>16</td>
      <td>0.015160</td>
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

    Total number of relationships: 315395





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
      <td>82761</td>
      <td>26.240429</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>82761</td>
      <td>26.240429</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>54174</td>
      <td>17.176556</td>
    </tr>
    <tr>
      <th>3</th>
      <td>COMMITTED</td>
      <td>21396</td>
      <td>6.783874</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CREATES</td>
      <td>19882</td>
      <td>6.303841</td>
    </tr>
    <tr>
      <th>5</th>
      <td>DELETES</td>
      <td>11955</td>
      <td>3.790485</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_PARENT</td>
      <td>11750</td>
      <td>3.725487</td>
    </tr>
    <tr>
      <th>7</th>
      <td>HAS_COMMIT</td>
      <td>10698</td>
      <td>3.391937</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_FILE</td>
      <td>5512</td>
      <td>1.747650</td>
    </tr>
    <tr>
      <th>9</th>
      <td>RENAMES</td>
      <td>3250</td>
      <td>1.030454</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_NEW_NAME</td>
      <td>1729</td>
      <td>0.548201</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_TAG</td>
      <td>1377</td>
      <td>0.436595</td>
    </tr>
    <tr>
      <th>12</th>
      <td>ON_COMMIT</td>
      <td>1377</td>
      <td>0.436595</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_AUTHOR</td>
      <td>1232</td>
      <td>0.390621</td>
    </tr>
    <tr>
      <th>14</th>
      <td>DEPENDS_ON</td>
      <td>961</td>
      <td>0.304697</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_KEY</td>
      <td>668</td>
      <td>0.211798</td>
    </tr>
    <tr>
      <th>16</th>
      <td>HAS_VALUE</td>
      <td>668</td>
      <td>0.211798</td>
    </tr>
    <tr>
      <th>17</th>
      <td>CONTAINS</td>
      <td>594</td>
      <td>0.188335</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_COMMITTER</td>
      <td>371</td>
      <td>0.117630</td>
    </tr>
    <tr>
      <th>19</th>
      <td>OF_TYPE</td>
      <td>337</td>
      <td>0.106850</td>
    </tr>
    <tr>
      <th>20</th>
      <td>EXPORTS</td>
      <td>283</td>
      <td>0.089729</td>
    </tr>
    <tr>
      <th>21</th>
      <td>REFERENCES</td>
      <td>197</td>
      <td>0.062461</td>
    </tr>
    <tr>
      <th>22</th>
      <td>DECLARES</td>
      <td>186</td>
      <td>0.058974</td>
    </tr>
    <tr>
      <th>23</th>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>169</td>
      <td>0.053584</td>
    </tr>
    <tr>
      <th>24</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>0.051047</td>
    </tr>
    <tr>
      <th>25</th>
      <td>HAS_MEMBER</td>
      <td>102</td>
      <td>0.032340</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>94</td>
      <td>0.029804</td>
    </tr>
    <tr>
      <th>27</th>
      <td>DECLARES_SCRIPT</td>
      <td>91</td>
      <td>0.028853</td>
    </tr>
    <tr>
      <th>28</th>
      <td>RETURNS</td>
      <td>82</td>
      <td>0.025999</td>
    </tr>
    <tr>
      <th>29</th>
      <td>COPIES</td>
      <td>77</td>
      <td>0.024414</td>
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
      <td>PROVIDED_BY_NPM_DEPENDENCY</td>
      <td>1</td>
      <td>0.000317</td>
    </tr>
    <tr>
      <th>1</th>
      <td>IS_IMPLEMENTED_IN</td>
      <td>2</td>
      <td>0.000634</td>
    </tr>
    <tr>
      <th>2</th>
      <td>CONSTRAINED_BY</td>
      <td>4</td>
      <td>0.001268</td>
    </tr>
    <tr>
      <th>3</th>
      <td>REFERENCED_PROJECTS</td>
      <td>5</td>
      <td>0.001585</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CONTAINS_PROJECT</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>5</th>
      <td>DECLARES_ENGINE</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>6</th>
      <td>EXTENDS</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>7</th>
      <td>HAS_ARGUMENT</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>8</th>
      <td>CALLS</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>9</th>
      <td>HAS_NPM_PACKAGE</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_ROOT</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>11</th>
      <td>MEMBER</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>12</th>
      <td>PARENT</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_CONFIG</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>14</th>
      <td>SIMILAR</td>
      <td>6</td>
      <td>0.001902</td>
    </tr>
    <tr>
      <th>15</th>
      <td>DECLARES_PEER_DEPENDENCY</td>
      <td>8</td>
      <td>0.002537</td>
    </tr>
    <tr>
      <th>16</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.006024</td>
    </tr>
    <tr>
      <th>17</th>
      <td>USES</td>
      <td>23</td>
      <td>0.007292</td>
    </tr>
    <tr>
      <th>18</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.008878</td>
    </tr>
    <tr>
      <th>19</th>
      <td>INITIALIZED_WITH</td>
      <td>32</td>
      <td>0.010146</td>
    </tr>
    <tr>
      <th>20</th>
      <td>IS_DESCRIBED_IN_NPM_PACKAGE</td>
      <td>33</td>
      <td>0.010463</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_BRANCH</td>
      <td>36</td>
      <td>0.011414</td>
    </tr>
    <tr>
      <th>22</th>
      <td>HAS_HEAD</td>
      <td>37</td>
      <td>0.011731</td>
    </tr>
    <tr>
      <th>23</th>
      <td>RESOLVES_TO</td>
      <td>41</td>
      <td>0.013000</td>
    </tr>
    <tr>
      <th>24</th>
      <td>COPY_OF</td>
      <td>41</td>
      <td>0.013000</td>
    </tr>
    <tr>
      <th>25</th>
      <td>CONTAINS_VALUE</td>
      <td>51</td>
      <td>0.016170</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_PARAMETER</td>
      <td>73</td>
      <td>0.023146</td>
    </tr>
    <tr>
      <th>27</th>
      <td>COPIES</td>
      <td>77</td>
      <td>0.024414</td>
    </tr>
    <tr>
      <th>28</th>
      <td>RETURNS</td>
      <td>82</td>
      <td>0.025999</td>
    </tr>
    <tr>
      <th>29</th>
      <td>DECLARES_SCRIPT</td>
      <td>91</td>
      <td>0.028853</td>
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
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>82761</td>
      <td>82761</td>
      <td>5512</td>
      <td>0.018142</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Commit]</td>
      <td>CONTAINS_CHANGE</td>
      <td>[Git, Change]</td>
      <td>82761</td>
      <td>10698</td>
      <td>82761</td>
      <td>0.009348</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>54174</td>
      <td>82761</td>
      <td>5512</td>
      <td>0.011876</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>19882</td>
      <td>82761</td>
      <td>5512</td>
      <td>0.004358</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>11955</td>
      <td>82761</td>
      <td>5512</td>
      <td>0.002621</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>11750</td>
      <td>10698</td>
      <td>10698</td>
      <td>0.010267</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>10698</td>
      <td>1</td>
      <td>10698</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>10698</td>
      <td>1232</td>
      <td>10698</td>
      <td>0.081169</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>10698</td>
      <td>371</td>
      <td>10698</td>
      <td>0.269542</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_FILE</td>
      <td>[File, Git]</td>
      <td>5512</td>
      <td>1</td>
      <td>5512</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>3250</td>
      <td>82761</td>
      <td>5512</td>
      <td>0.000712</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>1729</td>
      <td>5512</td>
      <td>5512</td>
      <td>0.005691</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_TAG</td>
      <td>[Git, Tag]</td>
      <td>1377</td>
      <td>1</td>
      <td>1377</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Git, Tag]</td>
      <td>ON_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>1377</td>
      <td>1377</td>
      <td>10698</td>
      <td>0.009348</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_AUTHOR</td>
      <td>[Author, Git, Person]</td>
      <td>1232</td>
      <td>1</td>
      <td>1232</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Json, Value, Object]</td>
      <td>HAS_KEY</td>
      <td>[Json, Key]</td>
      <td>668</td>
      <td>133</td>
      <td>668</td>
      <td>0.751880</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Json, Key]</td>
      <td>HAS_VALUE</td>
      <td>[Json, Value, Scalar]</td>
      <td>552</td>
      <td>668</td>
      <td>603</td>
      <td>0.137039</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMITTER</td>
      <td>[Committer, Git, Person]</td>
      <td>371</td>
      <td>1</td>
      <td>371</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>289</td>
      <td>47</td>
      <td>214</td>
      <td>2.873335</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[File, TS, Local, Module, Mark4ModuleWeaklyCon...</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>232</td>
      <td>4</td>
      <td>214</td>
      <td>27.102804</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[TS, ExternalModule]</td>
      <td>EXPORTS</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>214</td>
      <td>23</td>
      <td>214</td>
      <td>4.347826</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>[NPM, Dependency]</td>
      <td>169</td>
      <td>29</td>
      <td>338</td>
      <td>1.724138</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_DEPENDENCY</td>
      <td>[NPM, Dependency]</td>
      <td>161</td>
      <td>29</td>
      <td>338</td>
      <td>1.642522</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Type, TS, Union]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Primitive]</td>
      <td>147</td>
      <td>119</td>
      <td>291</td>
      <td>0.424500</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, TS, Declared]</td>
      <td>REFERENCES</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>142</td>
      <td>276</td>
      <td>214</td>
      <td>0.240417</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalModule]</td>
      <td>132</td>
      <td>47</td>
      <td>23</td>
      <td>12.210916</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, TS, Union]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Literal]</td>
      <td>119</td>
      <td>119</td>
      <td>136</td>
      <td>0.735294</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Json, Key]</td>
      <td>HAS_VALUE</td>
      <td>[Json, Value, Object]</td>
      <td>104</td>
      <td>668</td>
      <td>133</td>
      <td>0.117059</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, Object, TS]</td>
      <td>HAS_MEMBER</td>
      <td>[Type, TS, ObjectMember]</td>
      <td>101</td>
      <td>39</td>
      <td>101</td>
      <td>2.564103</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_SCRIPT</td>
      <td>[NPM, Script]</td>
      <td>91</td>
      <td>29</td>
      <td>91</td>
      <td>3.448276</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 105544
    total_number_of_relationships (edges): 315395
    -> total directed graph density: 2.831338667249154e-05
    -> total directed graph density in percent: 0.002831338667249154

