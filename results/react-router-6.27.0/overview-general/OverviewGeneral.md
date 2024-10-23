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
      <td>77001</td>
      <td>77.981224</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Commit]</td>
      <td>10243</td>
      <td>10.373394</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Git]</td>
      <td>5207</td>
      <td>5.273285</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Author, Git, Person]</td>
      <td>1190</td>
      <td>1.205149</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Tag]</td>
      <td>1149</td>
      <td>1.163627</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Json, Key]</td>
      <td>668</td>
      <td>0.676504</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Json, Value, Scalar]</td>
      <td>603</td>
      <td>0.610676</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Committer, Git, Person]</td>
      <td>371</td>
      <td>0.375723</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[NPM, Dependency]</td>
      <td>330</td>
      <td>0.334201</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Type, TS, Primitive, ExternalType]</td>
      <td>291</td>
      <td>0.294704</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>276</td>
      <td>0.279513</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[TS, ExternalDeclaration]</td>
      <td>215</td>
      <td>0.217737</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Type, TS, Literal, ExternalType]</td>
      <td>136</td>
      <td>0.137731</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Json, Value, Object]</td>
      <td>133</td>
      <td>0.134693</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>119</td>
      <td>0.120515</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, TS, ObjectMember, ExternalType]</td>
      <td>101</td>
      <td>0.102286</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[NPM, Script]</td>
      <td>91</td>
      <td>0.092158</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[TS, Property]</td>
      <td>65</td>
      <td>0.065827</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, Function]</td>
      <td>47</td>
      <td>0.047598</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, TS, FunctionParameter, ExternalType]</td>
      <td>40</td>
      <td>0.040509</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, Object, TS, ExternalType]</td>
      <td>39</td>
      <td>0.039496</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[File, Directory]</td>
      <td>34</td>
      <td>0.034433</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, TS, Function, ExternalType]</td>
      <td>34</td>
      <td>0.034433</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[TS, Parameter]</td>
      <td>33</td>
      <td>0.033420</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Git, Branch]</td>
      <td>31</td>
      <td>0.031395</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Package, File, Json, NPM]</td>
      <td>29</td>
      <td>0.029369</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, ExternalModule]</td>
      <td>25</td>
      <td>0.025318</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[TS, Variable]</td>
      <td>24</td>
      <td>0.024306</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Value, TS, Literal]</td>
      <td>20</td>
      <td>0.020255</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.019242</td>
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
      <td>0.001013</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[File, TS, Scan]</td>
      <td>1</td>
      <td>0.001013</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[TS, Method]</td>
      <td>1</td>
      <td>0.001013</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Value, TS, ObjectMember]</td>
      <td>1</td>
      <td>0.001013</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[TS, Constructor]</td>
      <td>1</td>
      <td>0.001013</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[TS, Class]</td>
      <td>1</td>
      <td>0.001013</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[TS, Enum]</td>
      <td>2</td>
      <td>0.002025</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Value, Object, TS]</td>
      <td>3</td>
      <td>0.003038</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Type, TS, Tuple, ExternalType]</td>
      <td>3</td>
      <td>0.003038</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Value, TS, Function]</td>
      <td>4</td>
      <td>0.004051</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[TS, TypeParameter]</td>
      <td>4</td>
      <td>0.004051</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Value, TS, Complex]</td>
      <td>5</td>
      <td>0.005064</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[NPM, Engine]</td>
      <td>6</td>
      <td>0.006076</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Project, TS]</td>
      <td>6</td>
      <td>0.006076</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[File, Local]</td>
      <td>6</td>
      <td>0.006076</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Value, TS, Call]</td>
      <td>6</td>
      <td>0.006076</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Value, TS, Member]</td>
      <td>6</td>
      <td>0.006076</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[File, TS, Local, Module]</td>
      <td>6</td>
      <td>0.006076</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Type, TS, TypeParameterReference, ExternalType]</td>
      <td>6</td>
      <td>0.006076</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[TS, EnumMember]</td>
      <td>8</td>
      <td>0.008102</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, TS, NotIdentified, ExternalType]</td>
      <td>11</td>
      <td>0.011140</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Json, Value, Array]</td>
      <td>12</td>
      <td>0.012153</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Value, TS, Declared]</td>
      <td>13</td>
      <td>0.013165</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[TS, TypeAlias]</td>
      <td>16</td>
      <td>0.016204</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[File, Directory, Local]</td>
      <td>16</td>
      <td>0.016204</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[TS, Interface]</td>
      <td>17</td>
      <td>0.017216</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, TS, Intersection, ExternalType]</td>
      <td>17</td>
      <td>0.017216</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.019242</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Value, TS, Literal]</td>
      <td>20</td>
      <td>0.020255</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[TS, Variable]</td>
      <td>24</td>
      <td>0.024306</td>
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
      <td>95192</td>
      <td>96.403796</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>77001</td>
      <td>77.981224</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Commit</td>
      <td>10243</td>
      <td>10.373394</td>
    </tr>
    <tr>
      <th>3</th>
      <td>File</td>
      <td>5299</td>
      <td>5.366456</td>
    </tr>
    <tr>
      <th>4</th>
      <td>TS</td>
      <td>1603</td>
      <td>1.623406</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Person</td>
      <td>1561</td>
      <td>1.580872</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Json</td>
      <td>1445</td>
      <td>1.463395</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Author</td>
      <td>1190</td>
      <td>1.205149</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Tag</td>
      <td>1149</td>
      <td>1.163627</td>
    </tr>
    <tr>
      <th>9</th>
      <td>ExternalType</td>
      <td>1073</td>
      <td>1.086659</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Type</td>
      <td>1073</td>
      <td>1.086659</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Value</td>
      <td>806</td>
      <td>0.816260</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Key</td>
      <td>668</td>
      <td>0.676504</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Scalar</td>
      <td>603</td>
      <td>0.610676</td>
    </tr>
    <tr>
      <th>14</th>
      <td>NPM</td>
      <td>456</td>
      <td>0.461805</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Committer</td>
      <td>371</td>
      <td>0.375723</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Dependency</td>
      <td>330</td>
      <td>0.334201</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Primitive</td>
      <td>291</td>
      <td>0.294704</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Declared</td>
      <td>289</td>
      <td>0.292679</td>
    </tr>
    <tr>
      <th>19</th>
      <td>ExternalDeclaration</td>
      <td>215</td>
      <td>0.217737</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Object</td>
      <td>175</td>
      <td>0.177228</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Literal</td>
      <td>156</td>
      <td>0.157986</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Union</td>
      <td>119</td>
      <td>0.120515</td>
    </tr>
    <tr>
      <th>23</th>
      <td>ObjectMember</td>
      <td>102</td>
      <td>0.103298</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Script</td>
      <td>91</td>
      <td>0.092158</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Function</td>
      <td>85</td>
      <td>0.086082</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Property</td>
      <td>65</td>
      <td>0.065827</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Directory</td>
      <td>50</td>
      <td>0.050637</td>
    </tr>
    <tr>
      <th>28</th>
      <td>FunctionParameter</td>
      <td>40</td>
      <td>0.040509</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Parameter</td>
      <td>33</td>
      <td>0.033420</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Branch</td>
      <td>31</td>
      <td>0.031395</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Package</td>
      <td>29</td>
      <td>0.029369</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Local</td>
      <td>28</td>
      <td>0.028356</td>
    </tr>
    <tr>
      <th>33</th>
      <td>ExternalModule</td>
      <td>25</td>
      <td>0.025318</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Variable</td>
      <td>24</td>
      <td>0.024306</td>
    </tr>
    <tr>
      <th>35</th>
      <td>jQAssistant</td>
      <td>20</td>
      <td>0.020255</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Concept</td>
      <td>19</td>
      <td>0.019242</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Rule</td>
      <td>19</td>
      <td>0.019242</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Interface</td>
      <td>17</td>
      <td>0.017216</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Intersection</td>
      <td>17</td>
      <td>0.017216</td>
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

    Total number of relationships: 276126





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
      <td>77001</td>
      <td>27.886182</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>77001</td>
      <td>27.886182</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>50933</td>
      <td>18.445565</td>
    </tr>
    <tr>
      <th>3</th>
      <td>COMMITTED</td>
      <td>20486</td>
      <td>7.419077</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CREATES</td>
      <td>18227</td>
      <td>6.600972</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_PARENT</td>
      <td>11272</td>
      <td>4.082194</td>
    </tr>
    <tr>
      <th>6</th>
      <td>DELETES</td>
      <td>10624</td>
      <td>3.847519</td>
    </tr>
    <tr>
      <th>7</th>
      <td>RENAMES</td>
      <td>2783</td>
      <td>1.007873</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_NEW_NAME</td>
      <td>1573</td>
      <td>0.569667</td>
    </tr>
    <tr>
      <th>9</th>
      <td>ON_COMMIT</td>
      <td>1149</td>
      <td>0.416114</td>
    </tr>
    <tr>
      <th>10</th>
      <td>DEPENDS_ON</td>
      <td>962</td>
      <td>0.348392</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_KEY</td>
      <td>668</td>
      <td>0.241919</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS_VALUE</td>
      <td>668</td>
      <td>0.241919</td>
    </tr>
    <tr>
      <th>13</th>
      <td>CONTAINS</td>
      <td>593</td>
      <td>0.214757</td>
    </tr>
    <tr>
      <th>14</th>
      <td>OF_TYPE</td>
      <td>337</td>
      <td>0.122046</td>
    </tr>
    <tr>
      <th>15</th>
      <td>EXPORTS</td>
      <td>276</td>
      <td>0.099954</td>
    </tr>
    <tr>
      <th>16</th>
      <td>REFERENCES</td>
      <td>197</td>
      <td>0.071344</td>
    </tr>
    <tr>
      <th>17</th>
      <td>DECLARES</td>
      <td>186</td>
      <td>0.067361</td>
    </tr>
    <tr>
      <th>18</th>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>169</td>
      <td>0.061204</td>
    </tr>
    <tr>
      <th>19</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>0.058307</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_MEMBER</td>
      <td>102</td>
      <td>0.036940</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>94</td>
      <td>0.034042</td>
    </tr>
    <tr>
      <th>22</th>
      <td>DECLARES_SCRIPT</td>
      <td>91</td>
      <td>0.032956</td>
    </tr>
    <tr>
      <th>23</th>
      <td>RETURNS</td>
      <td>82</td>
      <td>0.029697</td>
    </tr>
    <tr>
      <th>24</th>
      <td>RESOLVES_TO</td>
      <td>81</td>
      <td>0.029334</td>
    </tr>
    <tr>
      <th>25</th>
      <td>HAS_PARAMETER</td>
      <td>73</td>
      <td>0.026437</td>
    </tr>
    <tr>
      <th>26</th>
      <td>CONTAINS_VALUE</td>
      <td>51</td>
      <td>0.018470</td>
    </tr>
    <tr>
      <th>27</th>
      <td>COPIES</td>
      <td>43</td>
      <td>0.015573</td>
    </tr>
    <tr>
      <th>28</th>
      <td>INITIALIZED_WITH</td>
      <td>32</td>
      <td>0.011589</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_HEAD</td>
      <td>31</td>
      <td>0.011227</td>
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
      <td>0.000362</td>
    </tr>
    <tr>
      <th>1</th>
      <td>CONSTRAINED_BY</td>
      <td>4</td>
      <td>0.001449</td>
    </tr>
    <tr>
      <th>2</th>
      <td>REFERENCED_PROJECTS</td>
      <td>5</td>
      <td>0.001811</td>
    </tr>
    <tr>
      <th>3</th>
      <td>PARENT</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CONTAINS_PROJECT</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>5</th>
      <td>DECLARES_ENGINE</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>6</th>
      <td>EXTENDS</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>7</th>
      <td>CALLS</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_CONFIG</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>9</th>
      <td>HAS_NPM_PACKAGE</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_ROOT</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>11</th>
      <td>MEMBER</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS_ARGUMENT</td>
      <td>6</td>
      <td>0.002173</td>
    </tr>
    <tr>
      <th>13</th>
      <td>SIMILAR</td>
      <td>10</td>
      <td>0.003622</td>
    </tr>
    <tr>
      <th>14</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.006881</td>
    </tr>
    <tr>
      <th>15</th>
      <td>USES</td>
      <td>25</td>
      <td>0.009054</td>
    </tr>
    <tr>
      <th>16</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.010140</td>
    </tr>
    <tr>
      <th>17</th>
      <td>COPY_OF</td>
      <td>28</td>
      <td>0.010140</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_HEAD</td>
      <td>31</td>
      <td>0.011227</td>
    </tr>
    <tr>
      <th>19</th>
      <td>INITIALIZED_WITH</td>
      <td>32</td>
      <td>0.011589</td>
    </tr>
    <tr>
      <th>20</th>
      <td>COPIES</td>
      <td>43</td>
      <td>0.015573</td>
    </tr>
    <tr>
      <th>21</th>
      <td>CONTAINS_VALUE</td>
      <td>51</td>
      <td>0.018470</td>
    </tr>
    <tr>
      <th>22</th>
      <td>HAS_PARAMETER</td>
      <td>73</td>
      <td>0.026437</td>
    </tr>
    <tr>
      <th>23</th>
      <td>RESOLVES_TO</td>
      <td>81</td>
      <td>0.029334</td>
    </tr>
    <tr>
      <th>24</th>
      <td>RETURNS</td>
      <td>82</td>
      <td>0.029697</td>
    </tr>
    <tr>
      <th>25</th>
      <td>DECLARES_SCRIPT</td>
      <td>91</td>
      <td>0.032956</td>
    </tr>
    <tr>
      <th>26</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>94</td>
      <td>0.034042</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_MEMBER</td>
      <td>102</td>
      <td>0.036940</td>
    </tr>
    <tr>
      <th>28</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>0.058307</td>
    </tr>
    <tr>
      <th>29</th>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>169</td>
      <td>0.061204</td>
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
      <td>77001</td>
      <td>10243</td>
      <td>77001</td>
      <td>0.009763</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>77001</td>
      <td>77001</td>
      <td>5207</td>
      <td>0.019205</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>50933</td>
      <td>77001</td>
      <td>5207</td>
      <td>0.012703</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>18227</td>
      <td>77001</td>
      <td>5207</td>
      <td>0.004546</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>11272</td>
      <td>10243</td>
      <td>10243</td>
      <td>0.010744</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>10624</td>
      <td>77001</td>
      <td>5207</td>
      <td>0.002650</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>10243</td>
      <td>1190</td>
      <td>10243</td>
      <td>0.084034</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>10243</td>
      <td>371</td>
      <td>10243</td>
      <td>0.269542</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>2783</td>
      <td>77001</td>
      <td>5207</td>
      <td>0.000694</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>1573</td>
      <td>5207</td>
      <td>5207</td>
      <td>0.005802</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Git, Tag]</td>
      <td>ON_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>1149</td>
      <td>1149</td>
      <td>10243</td>
      <td>0.009763</td>
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
      <td>147</td>
      <td>119</td>
      <td>291</td>
      <td>0.424500</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>REFERENCES</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>142</td>
      <td>276</td>
      <td>215</td>
      <td>0.239299</td>
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
      <td>119</td>
      <td>136</td>
      <td>0.735294</td>
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
      <td>101</td>
      <td>39</td>
      <td>101</td>
      <td>2.564103</td>
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
      <td>70</td>
      <td>119</td>
      <td>276</td>
      <td>0.213129</td>
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
      <td>17</td>
      <td>65</td>
      <td>5.520362</td>
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
      <td>5207</td>
      <td>29</td>
      <td>0.037748</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 98743
    total_number_of_relationships (edges): 276126
    -> total directed graph density: 2.8320379218794587e-05
    -> total directed graph density in percent: 0.0028320379218794585

