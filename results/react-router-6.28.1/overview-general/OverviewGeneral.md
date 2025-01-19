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
      <td>[Type, TS, Primitive]</td>
      <td>811</td>
      <td>13.503164</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Json, Key]</td>
      <td>668</td>
      <td>11.122211</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Json, Value, Scalar]</td>
      <td>603</td>
      <td>10.039960</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Type, TS, Declared]</td>
      <td>598</td>
      <td>9.956710</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[TS, ExternalDeclaration]</td>
      <td>444</td>
      <td>7.392607</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[NPM, Dependency]</td>
      <td>338</td>
      <td>5.627706</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Type, TS, ObjectMember]</td>
      <td>318</td>
      <td>5.294705</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Type, TS, Literal]</td>
      <td>274</td>
      <td>4.562105</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Type, TS, Union]</td>
      <td>246</td>
      <td>4.095904</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[TS, Property]</td>
      <td>137</td>
      <td>2.281052</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Json, Value, Object]</td>
      <td>133</td>
      <td>2.214452</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Value, TS, Literal]</td>
      <td>124</td>
      <td>2.064602</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Type, Object, TS]</td>
      <td>109</td>
      <td>1.814852</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[TS, Function]</td>
      <td>109</td>
      <td>1.814852</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[NPM, Script]</td>
      <td>91</td>
      <td>1.515152</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Value, TS, ObjectMember]</td>
      <td>88</td>
      <td>1.465201</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Type, TS, FunctionParameter]</td>
      <td>80</td>
      <td>1.332001</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[TS, Parameter]</td>
      <td>76</td>
      <td>1.265401</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Type, TS, Function]</td>
      <td>70</td>
      <td>1.165501</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[File, Directory, Local]</td>
      <td>64</td>
      <td>1.065601</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[TS, Variable]</td>
      <td>59</td>
      <td>0.982351</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[File, TS, Local, Module]</td>
      <td>46</td>
      <td>0.765901</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[TS, Interface]</td>
      <td>37</td>
      <td>0.616051</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[File, Directory]</td>
      <td>34</td>
      <td>0.566101</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, TS, Intersection]</td>
      <td>34</td>
      <td>0.566101</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Project, TS]</td>
      <td>33</td>
      <td>0.549451</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, ExternalModule]</td>
      <td>33</td>
      <td>0.549451</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[TS, TypeAlias]</td>
      <td>32</td>
      <td>0.532801</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Value, TS, Declared]</td>
      <td>30</td>
      <td>0.499500</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Package, File, Json, NPM]</td>
      <td>29</td>
      <td>0.482850</td>
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
      <td>0.01665</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Value, TS, Null]</td>
      <td>1</td>
      <td>0.01665</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[TS, Class]</td>
      <td>2</td>
      <td>0.03330</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[TS, Constructor]</td>
      <td>2</td>
      <td>0.03330</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[TS, Enum]</td>
      <td>4</td>
      <td>0.06660</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[TS, Method]</td>
      <td>4</td>
      <td>0.06660</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Value, Array, TS]</td>
      <td>5</td>
      <td>0.08325</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Type, TS, Tuple]</td>
      <td>6</td>
      <td>0.09990</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[NPM, Engine]</td>
      <td>6</td>
      <td>0.09990</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[TS, TypeParameter]</td>
      <td>8</td>
      <td>0.13320</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Value, TS, Complex]</td>
      <td>11</td>
      <td>0.18315</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Type, TS, TypeParameterReference]</td>
      <td>12</td>
      <td>0.19980</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Json, Value, Array]</td>
      <td>12</td>
      <td>0.19980</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Value, TS, Function]</td>
      <td>13</td>
      <td>0.21645</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Value, TS, Call]</td>
      <td>14</td>
      <td>0.23310</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Value, TS, Member]</td>
      <td>14</td>
      <td>0.23310</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[TS, EnumMember]</td>
      <td>16</td>
      <td>0.26640</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.31635</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Type, TS, NotIdentified]</td>
      <td>23</td>
      <td>0.38295</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Value, Object, TS]</td>
      <td>28</td>
      <td>0.46620</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[File, Local]</td>
      <td>28</td>
      <td>0.46620</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[File, TS, Scan]</td>
      <td>29</td>
      <td>0.48285</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Package, File, Json, NPM]</td>
      <td>29</td>
      <td>0.48285</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Value, TS, Declared]</td>
      <td>30</td>
      <td>0.49950</td>
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
      <td>TS</td>
      <td>3980</td>
      <td>66.267066</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Type</td>
      <td>2581</td>
      <td>42.973693</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Json</td>
      <td>1445</td>
      <td>24.059274</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Value</td>
      <td>1076</td>
      <td>17.915418</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Primitive</td>
      <td>811</td>
      <td>13.503164</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Key</td>
      <td>668</td>
      <td>11.122211</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Declared</td>
      <td>628</td>
      <td>10.456210</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Scalar</td>
      <td>603</td>
      <td>10.039960</td>
    </tr>
    <tr>
      <th>8</th>
      <td>NPM</td>
      <td>464</td>
      <td>7.725608</td>
    </tr>
    <tr>
      <th>9</th>
      <td>ExternalDeclaration</td>
      <td>444</td>
      <td>7.392607</td>
    </tr>
    <tr>
      <th>10</th>
      <td>ObjectMember</td>
      <td>406</td>
      <td>6.759907</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Literal</td>
      <td>398</td>
      <td>6.626707</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Dependency</td>
      <td>338</td>
      <td>5.627706</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Object</td>
      <td>270</td>
      <td>4.495504</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Union</td>
      <td>246</td>
      <td>4.095904</td>
    </tr>
    <tr>
      <th>15</th>
      <td>File</td>
      <td>230</td>
      <td>3.829504</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Function</td>
      <td>192</td>
      <td>3.196803</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Local</td>
      <td>138</td>
      <td>2.297702</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Property</td>
      <td>137</td>
      <td>2.281052</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Directory</td>
      <td>98</td>
      <td>1.631702</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Script</td>
      <td>91</td>
      <td>1.515152</td>
    </tr>
    <tr>
      <th>21</th>
      <td>FunctionParameter</td>
      <td>80</td>
      <td>1.332001</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Parameter</td>
      <td>76</td>
      <td>1.265401</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Variable</td>
      <td>59</td>
      <td>0.982351</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Module</td>
      <td>46</td>
      <td>0.765901</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Interface</td>
      <td>37</td>
      <td>0.616051</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Intersection</td>
      <td>34</td>
      <td>0.566101</td>
    </tr>
    <tr>
      <th>27</th>
      <td>ExternalModule</td>
      <td>33</td>
      <td>0.549451</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Project</td>
      <td>33</td>
      <td>0.549451</td>
    </tr>
    <tr>
      <th>29</th>
      <td>TypeAlias</td>
      <td>32</td>
      <td>0.532801</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Package</td>
      <td>29</td>
      <td>0.482850</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Scan</td>
      <td>29</td>
      <td>0.482850</td>
    </tr>
    <tr>
      <th>32</th>
      <td>NotIdentified</td>
      <td>23</td>
      <td>0.382950</td>
    </tr>
    <tr>
      <th>33</th>
      <td>jQAssistant</td>
      <td>20</td>
      <td>0.333000</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Concept</td>
      <td>19</td>
      <td>0.316350</td>
    </tr>
    <tr>
      <th>35</th>
      <td>Rule</td>
      <td>19</td>
      <td>0.316350</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Array</td>
      <td>17</td>
      <td>0.283050</td>
    </tr>
    <tr>
      <th>37</th>
      <td>EnumMember</td>
      <td>16</td>
      <td>0.266400</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Call</td>
      <td>14</td>
      <td>0.233100</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Member</td>
      <td>14</td>
      <td>0.233100</td>
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

    Total number of relationships: 8796





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
      <td>DEPENDS_ON</td>
      <td>1823</td>
      <td>20.725330</td>
    </tr>
    <tr>
      <th>1</th>
      <td>CONTAINS</td>
      <td>1195</td>
      <td>13.585721</td>
    </tr>
    <tr>
      <th>2</th>
      <td>OF_TYPE</td>
      <td>1030</td>
      <td>11.709868</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HAS_KEY</td>
      <td>668</td>
      <td>7.594361</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HAS_VALUE</td>
      <td>668</td>
      <td>7.594361</td>
    </tr>
    <tr>
      <th>5</th>
      <td>EXPORTS</td>
      <td>651</td>
      <td>7.401091</td>
    </tr>
    <tr>
      <th>6</th>
      <td>REFERENCES</td>
      <td>489</td>
      <td>5.559345</td>
    </tr>
    <tr>
      <th>7</th>
      <td>DECLARES</td>
      <td>410</td>
      <td>4.661210</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_MEMBER</td>
      <td>406</td>
      <td>4.615734</td>
    </tr>
    <tr>
      <th>9</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>202</td>
      <td>2.296498</td>
    </tr>
    <tr>
      <th>10</th>
      <td>RETURNS</td>
      <td>183</td>
      <td>2.080491</td>
    </tr>
    <tr>
      <th>11</th>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>169</td>
      <td>1.921328</td>
    </tr>
    <tr>
      <th>12</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>1.830377</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_PARAMETER</td>
      <td>155</td>
      <td>1.762165</td>
    </tr>
    <tr>
      <th>14</th>
      <td>DECLARES_SCRIPT</td>
      <td>91</td>
      <td>1.034561</td>
    </tr>
    <tr>
      <th>15</th>
      <td>INITIALIZED_WITH</td>
      <td>75</td>
      <td>0.852660</td>
    </tr>
    <tr>
      <th>16</th>
      <td>CONTAINS_VALUE</td>
      <td>51</td>
      <td>0.579809</td>
    </tr>
    <tr>
      <th>17</th>
      <td>CONTAINS_PROJECT</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_CONFIG</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>19</th>
      <td>HAS_NPM_PACKAGE</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_ROOT</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>21</th>
      <td>IS_DESCRIBED_IN_NPM_PACKAGE</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>22</th>
      <td>USES</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>23</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.318327</td>
    </tr>
    <tr>
      <th>24</th>
      <td>PROVIDED_BY_NPM_DEPENDENCY</td>
      <td>20</td>
      <td>0.227376</td>
    </tr>
    <tr>
      <th>25</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.216007</td>
    </tr>
    <tr>
      <th>26</th>
      <td>CALLS</td>
      <td>14</td>
      <td>0.159163</td>
    </tr>
    <tr>
      <th>27</th>
      <td>HAS_ARGUMENT</td>
      <td>14</td>
      <td>0.159163</td>
    </tr>
    <tr>
      <th>28</th>
      <td>MEMBER</td>
      <td>14</td>
      <td>0.159163</td>
    </tr>
    <tr>
      <th>29</th>
      <td>PARENT</td>
      <td>14</td>
      <td>0.159163</td>
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
      <td>HAS</td>
      <td>1</td>
      <td>0.011369</td>
    </tr>
    <tr>
      <th>1</th>
      <td>REFERENCED_PROJECTS</td>
      <td>5</td>
      <td>0.056844</td>
    </tr>
    <tr>
      <th>2</th>
      <td>DECLARES_ENGINE</td>
      <td>6</td>
      <td>0.068213</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SIMILAR</td>
      <td>8</td>
      <td>0.090950</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DECLARES_PEER_DEPENDENCY</td>
      <td>8</td>
      <td>0.090950</td>
    </tr>
    <tr>
      <th>5</th>
      <td>CONSTRAINED_BY</td>
      <td>8</td>
      <td>0.090950</td>
    </tr>
    <tr>
      <th>6</th>
      <td>EXTENDS</td>
      <td>12</td>
      <td>0.136426</td>
    </tr>
    <tr>
      <th>7</th>
      <td>PARENT</td>
      <td>14</td>
      <td>0.159163</td>
    </tr>
    <tr>
      <th>8</th>
      <td>MEMBER</td>
      <td>14</td>
      <td>0.159163</td>
    </tr>
    <tr>
      <th>9</th>
      <td>CALLS</td>
      <td>14</td>
      <td>0.159163</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_ARGUMENT</td>
      <td>14</td>
      <td>0.159163</td>
    </tr>
    <tr>
      <th>11</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.216007</td>
    </tr>
    <tr>
      <th>12</th>
      <td>PROVIDED_BY_NPM_DEPENDENCY</td>
      <td>20</td>
      <td>0.227376</td>
    </tr>
    <tr>
      <th>13</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.318327</td>
    </tr>
    <tr>
      <th>14</th>
      <td>HAS_NPM_PACKAGE</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>15</th>
      <td>USES</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>16</th>
      <td>IS_DESCRIBED_IN_NPM_PACKAGE</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_ROOT</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_CONFIG</td>
      <td>33</td>
      <td>0.375171</td>
    </tr>
    <tr>
      <th>19</th>
      <td>CONTAINS_PROJECT</td>
      <td>33</td>
      <td>0.375171</td>
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
      <td>[Json, Value, Object]</td>
      <td>HAS_KEY</td>
      <td>[Json, Key]</td>
      <td>668</td>
      <td>133</td>
      <td>668</td>
      <td>0.751880</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>580</td>
      <td>109</td>
      <td>444</td>
      <td>1.198446</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Json, Key]</td>
      <td>HAS_VALUE</td>
      <td>[Json, Value, Scalar]</td>
      <td>552</td>
      <td>668</td>
      <td>603</td>
      <td>0.137039</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[TS, ExternalModule]</td>
      <td>EXPORTS</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>444</td>
      <td>33</td>
      <td>444</td>
      <td>3.030303</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Type, Object, TS]</td>
      <td>HAS_MEMBER</td>
      <td>[Type, TS, ObjectMember]</td>
      <td>318</td>
      <td>109</td>
      <td>318</td>
      <td>0.917431</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[File, TS, Local, Module, Mark4ModuleWeaklyCon...</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>308</td>
      <td>1</td>
      <td>444</td>
      <td>69.369369</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Type, TS, Union]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Primitive]</td>
      <td>303</td>
      <td>246</td>
      <td>811</td>
      <td>0.151875</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Type, TS, Declared]</td>
      <td>REFERENCES</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>288</td>
      <td>598</td>
      <td>444</td>
      <td>0.108470</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Type, TS, Union]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Literal]</td>
      <td>238</td>
      <td>246</td>
      <td>274</td>
      <td>0.353095</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Type, TS, ObjectMember]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Primitive]</td>
      <td>173</td>
      <td>318</td>
      <td>811</td>
      <td>0.067081</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>[NPM, Dependency]</td>
      <td>169</td>
      <td>29</td>
      <td>338</td>
      <td>1.724138</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_DEPENDENCY</td>
      <td>[NPM, Dependency]</td>
      <td>161</td>
      <td>29</td>
      <td>338</td>
      <td>1.642522</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalModule]</td>
      <td>148</td>
      <td>109</td>
      <td>33</td>
      <td>4.114540</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Type, TS, Union]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Declared]</td>
      <td>145</td>
      <td>246</td>
      <td>598</td>
      <td>0.098567</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[TS, Interface]</td>
      <td>DECLARES</td>
      <td>[TS, Property]</td>
      <td>129</td>
      <td>37</td>
      <td>137</td>
      <td>2.544881</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[File, TS, Local, Module, Mark4ModuleWeaklyCon...</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>124</td>
      <td>2</td>
      <td>444</td>
      <td>13.963964</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Value, TS, Literal]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Primitive]</td>
      <td>118</td>
      <td>124</td>
      <td>811</td>
      <td>0.117338</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Json, Key]</td>
      <td>HAS_VALUE</td>
      <td>[Json, Value, Object]</td>
      <td>104</td>
      <td>668</td>
      <td>133</td>
      <td>0.117059</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, Property]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Union]</td>
      <td>93</td>
      <td>137</td>
      <td>246</td>
      <td>0.275948</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_SCRIPT</td>
      <td>[NPM, Script]</td>
      <td>91</td>
      <td>29</td>
      <td>91</td>
      <td>3.448276</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Value, Object, TS]</td>
      <td>HAS_MEMBER</td>
      <td>[Value, TS, ObjectMember]</td>
      <td>88</td>
      <td>28</td>
      <td>88</td>
      <td>3.571429</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[TS, Variable]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>88</td>
      <td>59</td>
      <td>444</td>
      <td>0.335929</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, TS, Declared]</td>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>[Type, TS, Declared]</td>
      <td>86</td>
      <td>598</td>
      <td>598</td>
      <td>0.024049</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Value, TS, ObjectMember]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Primitive]</td>
      <td>84</td>
      <td>88</td>
      <td>811</td>
      <td>0.117700</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Value, TS, ObjectMember]</td>
      <td>REFERENCES</td>
      <td>[Value, TS, Literal]</td>
      <td>83</td>
      <td>88</td>
      <td>124</td>
      <td>0.760630</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, TS, Function]</td>
      <td>HAS_PARAMETER</td>
      <td>[Type, TS, FunctionParameter]</td>
      <td>80</td>
      <td>70</td>
      <td>80</td>
      <td>1.428571</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, Function]</td>
      <td>HAS_PARAMETER</td>
      <td>[TS, Parameter]</td>
      <td>75</td>
      <td>109</td>
      <td>76</td>
      <td>0.905360</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Type, TS, ObjectMember]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Union]</td>
      <td>70</td>
      <td>318</td>
      <td>246</td>
      <td>0.089482</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, Function]</td>
      <td>67</td>
      <td>109</td>
      <td>109</td>
      <td>0.563926</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[File, Directory]</td>
      <td>CONTAINS</td>
      <td>[File, Directory]</td>
      <td>65</td>
      <td>34</td>
      <td>34</td>
      <td>5.622837</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 6006
    total_number_of_relationships (edges): 8796
    -> total directed graph density: 0.00024388600575111816
    -> total directed graph density in percent: 0.024388600575111816

