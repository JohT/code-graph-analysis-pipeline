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
      <td>83692</td>
      <td>76.608755</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Commit]</td>
      <td>10839</td>
      <td>9.921645</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Git]</td>
      <td>5591</td>
      <td>5.117808</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Tag]</td>
      <td>1461</td>
      <td>1.337349</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Author, Git, Person]</td>
      <td>1238</td>
      <td>1.133222</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Type, TS, Primitive]</td>
      <td>811</td>
      <td>0.742361</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Json, Key]</td>
      <td>668</td>
      <td>0.611464</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Json, Value, Scalar]</td>
      <td>603</td>
      <td>0.551965</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Type, TS, Declared]</td>
      <td>598</td>
      <td>0.547388</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[TS, ExternalDeclaration]</td>
      <td>450</td>
      <td>0.411914</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Committer, Git, Person]</td>
      <td>370</td>
      <td>0.338685</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[NPM, Dependency]</td>
      <td>338</td>
      <td>0.309393</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Type, TS, ObjectMember]</td>
      <td>318</td>
      <td>0.291086</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Type, TS, Literal]</td>
      <td>274</td>
      <td>0.250810</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, TS, Union]</td>
      <td>246</td>
      <td>0.225180</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[TS, Property]</td>
      <td>137</td>
      <td>0.125405</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Json, Value, Object]</td>
      <td>133</td>
      <td>0.121744</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Value, TS, Literal]</td>
      <td>124</td>
      <td>0.113505</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, Function]</td>
      <td>109</td>
      <td>0.099775</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, Object, TS]</td>
      <td>109</td>
      <td>0.099775</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[NPM, Script]</td>
      <td>91</td>
      <td>0.083298</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Value, TS, ObjectMember]</td>
      <td>88</td>
      <td>0.080552</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, TS, FunctionParameter]</td>
      <td>80</td>
      <td>0.073229</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[TS, Parameter]</td>
      <td>76</td>
      <td>0.069568</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, TS, Function]</td>
      <td>70</td>
      <td>0.064076</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[File, Directory, Local]</td>
      <td>64</td>
      <td>0.058583</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, Variable]</td>
      <td>59</td>
      <td>0.054007</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[File, TS, Local, Module]</td>
      <td>46</td>
      <td>0.042107</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Git, Branch]</td>
      <td>41</td>
      <td>0.037530</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[TS, Interface]</td>
      <td>37</td>
      <td>0.033869</td>
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
      <td>0.000915</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Repository, File, Git]</td>
      <td>1</td>
      <td>0.000915</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Value, TS, Null]</td>
      <td>1</td>
      <td>0.000915</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[TS, Constructor]</td>
      <td>2</td>
      <td>0.001831</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[TS, Class]</td>
      <td>2</td>
      <td>0.001831</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[TS, Enum]</td>
      <td>4</td>
      <td>0.003661</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[TS, Method]</td>
      <td>4</td>
      <td>0.003661</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Value, Array, TS]</td>
      <td>5</td>
      <td>0.004577</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Type, TS, Tuple]</td>
      <td>6</td>
      <td>0.005492</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[NPM, Engine]</td>
      <td>6</td>
      <td>0.005492</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[TS, TypeParameter]</td>
      <td>8</td>
      <td>0.007323</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Value, TS, Complex]</td>
      <td>11</td>
      <td>0.010069</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Type, TS, TypeParameterReference]</td>
      <td>12</td>
      <td>0.010984</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Json, Value, Array]</td>
      <td>12</td>
      <td>0.010984</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Value, TS, Function]</td>
      <td>13</td>
      <td>0.011900</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Value, TS, Call]</td>
      <td>14</td>
      <td>0.012815</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Value, TS, Member]</td>
      <td>14</td>
      <td>0.012815</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[TS, EnumMember]</td>
      <td>16</td>
      <td>0.014646</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.017392</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, TS, NotIdentified]</td>
      <td>23</td>
      <td>0.021053</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Value, Object, TS]</td>
      <td>28</td>
      <td>0.025630</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[File, Local]</td>
      <td>28</td>
      <td>0.025630</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[File, TS, Scan]</td>
      <td>29</td>
      <td>0.026546</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Package, File, Json, NPM]</td>
      <td>29</td>
      <td>0.026546</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Value, TS, Declared]</td>
      <td>30</td>
      <td>0.027461</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[TS, TypeAlias]</td>
      <td>32</td>
      <td>0.029292</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, ExternalModule]</td>
      <td>33</td>
      <td>0.030207</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Project, TS]</td>
      <td>33</td>
      <td>0.030207</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, TS, Intersection]</td>
      <td>34</td>
      <td>0.031122</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[File, Directory]</td>
      <td>35</td>
      <td>0.032038</td>
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
      <td>103233</td>
      <td>94.495908</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>83692</td>
      <td>76.608755</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Commit</td>
      <td>10839</td>
      <td>9.921645</td>
    </tr>
    <tr>
      <th>3</th>
      <td>File</td>
      <td>5823</td>
      <td>5.330172</td>
    </tr>
    <tr>
      <th>4</th>
      <td>TS</td>
      <td>3986</td>
      <td>3.648646</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Type</td>
      <td>2581</td>
      <td>2.362558</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Person</td>
      <td>1608</td>
      <td>1.471907</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Tag</td>
      <td>1461</td>
      <td>1.337349</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Json</td>
      <td>1445</td>
      <td>1.322703</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Author</td>
      <td>1238</td>
      <td>1.133222</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Value</td>
      <td>1076</td>
      <td>0.984933</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Primitive</td>
      <td>811</td>
      <td>0.742361</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Key</td>
      <td>668</td>
      <td>0.611464</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Declared</td>
      <td>628</td>
      <td>0.574849</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Scalar</td>
      <td>603</td>
      <td>0.551965</td>
    </tr>
    <tr>
      <th>15</th>
      <td>NPM</td>
      <td>464</td>
      <td>0.424730</td>
    </tr>
    <tr>
      <th>16</th>
      <td>ExternalDeclaration</td>
      <td>450</td>
      <td>0.411914</td>
    </tr>
    <tr>
      <th>17</th>
      <td>ObjectMember</td>
      <td>406</td>
      <td>0.371638</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Literal</td>
      <td>398</td>
      <td>0.364315</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Committer</td>
      <td>370</td>
      <td>0.338685</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Dependency</td>
      <td>338</td>
      <td>0.309393</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Object</td>
      <td>270</td>
      <td>0.247149</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Union</td>
      <td>246</td>
      <td>0.225180</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Function</td>
      <td>192</td>
      <td>0.175750</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Local</td>
      <td>138</td>
      <td>0.126320</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Property</td>
      <td>137</td>
      <td>0.125405</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Directory</td>
      <td>99</td>
      <td>0.090621</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Script</td>
      <td>91</td>
      <td>0.083298</td>
    </tr>
    <tr>
      <th>28</th>
      <td>FunctionParameter</td>
      <td>80</td>
      <td>0.073229</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Parameter</td>
      <td>76</td>
      <td>0.069568</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Variable</td>
      <td>59</td>
      <td>0.054007</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Module</td>
      <td>46</td>
      <td>0.042107</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Branch</td>
      <td>41</td>
      <td>0.037530</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Interface</td>
      <td>37</td>
      <td>0.033869</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Intersection</td>
      <td>34</td>
      <td>0.031122</td>
    </tr>
    <tr>
      <th>35</th>
      <td>ExternalModule</td>
      <td>33</td>
      <td>0.030207</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Project</td>
      <td>33</td>
      <td>0.030207</td>
    </tr>
    <tr>
      <th>37</th>
      <td>TypeAlias</td>
      <td>32</td>
      <td>0.029292</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Package</td>
      <td>29</td>
      <td>0.026546</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Scan</td>
      <td>29</td>
      <td>0.026546</td>
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

    Total number of relationships: 323039





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
      <td>83692</td>
      <td>25.907708</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>83692</td>
      <td>25.907708</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>54949</td>
      <td>17.010020</td>
    </tr>
    <tr>
      <th>3</th>
      <td>COMMITTED</td>
      <td>21678</td>
      <td>6.710645</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CREATES</td>
      <td>19972</td>
      <td>6.182535</td>
    </tr>
    <tr>
      <th>5</th>
      <td>DELETES</td>
      <td>12041</td>
      <td>3.727414</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_PARENT</td>
      <td>11896</td>
      <td>3.682527</td>
    </tr>
    <tr>
      <th>7</th>
      <td>HAS_COMMIT</td>
      <td>10839</td>
      <td>3.355322</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_FILE</td>
      <td>5591</td>
      <td>1.730751</td>
    </tr>
    <tr>
      <th>9</th>
      <td>RENAMES</td>
      <td>3270</td>
      <td>1.012262</td>
    </tr>
    <tr>
      <th>10</th>
      <td>DEPENDS_ON</td>
      <td>1845</td>
      <td>0.571138</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_NEW_NAME</td>
      <td>1751</td>
      <td>0.542040</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS_TAG</td>
      <td>1461</td>
      <td>0.452267</td>
    </tr>
    <tr>
      <th>13</th>
      <td>ON_COMMIT</td>
      <td>1461</td>
      <td>0.452267</td>
    </tr>
    <tr>
      <th>14</th>
      <td>HAS_AUTHOR</td>
      <td>1238</td>
      <td>0.383235</td>
    </tr>
    <tr>
      <th>15</th>
      <td>CONTAINS</td>
      <td>1199</td>
      <td>0.371163</td>
    </tr>
    <tr>
      <th>16</th>
      <td>OF_TYPE</td>
      <td>1030</td>
      <td>0.318847</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_KEY</td>
      <td>668</td>
      <td>0.206786</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_VALUE</td>
      <td>668</td>
      <td>0.206786</td>
    </tr>
    <tr>
      <th>19</th>
      <td>EXPORTS</td>
      <td>659</td>
      <td>0.204000</td>
    </tr>
    <tr>
      <th>20</th>
      <td>REFERENCES</td>
      <td>489</td>
      <td>0.151375</td>
    </tr>
    <tr>
      <th>21</th>
      <td>DECLARES</td>
      <td>410</td>
      <td>0.126920</td>
    </tr>
    <tr>
      <th>22</th>
      <td>HAS_MEMBER</td>
      <td>406</td>
      <td>0.125681</td>
    </tr>
    <tr>
      <th>23</th>
      <td>HAS_COMMITTER</td>
      <td>370</td>
      <td>0.114537</td>
    </tr>
    <tr>
      <th>24</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>202</td>
      <td>0.062531</td>
    </tr>
    <tr>
      <th>25</th>
      <td>RETURNS</td>
      <td>183</td>
      <td>0.056650</td>
    </tr>
    <tr>
      <th>26</th>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>169</td>
      <td>0.052316</td>
    </tr>
    <tr>
      <th>27</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>0.049839</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_PARAMETER</td>
      <td>155</td>
      <td>0.047982</td>
    </tr>
    <tr>
      <th>29</th>
      <td>RESOLVES_TO</td>
      <td>103</td>
      <td>0.031885</td>
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
      <td>0.000310</td>
    </tr>
    <tr>
      <th>1</th>
      <td>REFERENCED_PROJECTS</td>
      <td>5</td>
      <td>0.001548</td>
    </tr>
    <tr>
      <th>2</th>
      <td>DECLARES_ENGINE</td>
      <td>6</td>
      <td>0.001857</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SIMILAR</td>
      <td>8</td>
      <td>0.002476</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DECLARES_PEER_DEPENDENCY</td>
      <td>8</td>
      <td>0.002476</td>
    </tr>
    <tr>
      <th>5</th>
      <td>CONSTRAINED_BY</td>
      <td>8</td>
      <td>0.002476</td>
    </tr>
    <tr>
      <th>6</th>
      <td>EXTENDS</td>
      <td>12</td>
      <td>0.003715</td>
    </tr>
    <tr>
      <th>7</th>
      <td>PARENT</td>
      <td>14</td>
      <td>0.004334</td>
    </tr>
    <tr>
      <th>8</th>
      <td>MEMBER</td>
      <td>14</td>
      <td>0.004334</td>
    </tr>
    <tr>
      <th>9</th>
      <td>HAS_ARGUMENT</td>
      <td>14</td>
      <td>0.004334</td>
    </tr>
    <tr>
      <th>10</th>
      <td>CALLS</td>
      <td>14</td>
      <td>0.004334</td>
    </tr>
    <tr>
      <th>11</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.005882</td>
    </tr>
    <tr>
      <th>12</th>
      <td>PROVIDED_BY_NPM_DEPENDENCY</td>
      <td>20</td>
      <td>0.006191</td>
    </tr>
    <tr>
      <th>13</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.008668</td>
    </tr>
    <tr>
      <th>14</th>
      <td>CONTAINS_PROJECT</td>
      <td>33</td>
      <td>0.010215</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_CONFIG</td>
      <td>33</td>
      <td>0.010215</td>
    </tr>
    <tr>
      <th>16</th>
      <td>IS_DESCRIBED_IN_NPM_PACKAGE</td>
      <td>33</td>
      <td>0.010215</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_ROOT</td>
      <td>33</td>
      <td>0.010215</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_NPM_PACKAGE</td>
      <td>33</td>
      <td>0.010215</td>
    </tr>
    <tr>
      <th>19</th>
      <td>USES</td>
      <td>33</td>
      <td>0.010215</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_BRANCH</td>
      <td>41</td>
      <td>0.012692</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_HEAD</td>
      <td>42</td>
      <td>0.013002</td>
    </tr>
    <tr>
      <th>22</th>
      <td>COPY_OF</td>
      <td>43</td>
      <td>0.013311</td>
    </tr>
    <tr>
      <th>23</th>
      <td>CONTAINS_VALUE</td>
      <td>51</td>
      <td>0.015788</td>
    </tr>
    <tr>
      <th>24</th>
      <td>INITIALIZED_WITH</td>
      <td>75</td>
      <td>0.023217</td>
    </tr>
    <tr>
      <th>25</th>
      <td>COPIES</td>
      <td>79</td>
      <td>0.024455</td>
    </tr>
    <tr>
      <th>26</th>
      <td>DECLARES_SCRIPT</td>
      <td>91</td>
      <td>0.028170</td>
    </tr>
    <tr>
      <th>27</th>
      <td>RESOLVES_TO</td>
      <td>103</td>
      <td>0.031885</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_PARAMETER</td>
      <td>155</td>
      <td>0.047982</td>
    </tr>
    <tr>
      <th>29</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>0.049839</td>
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
      <td>83692</td>
      <td>10839</td>
      <td>83692</td>
      <td>0.009226</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>83692</td>
      <td>83692</td>
      <td>5591</td>
      <td>0.017886</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>54949</td>
      <td>83692</td>
      <td>5591</td>
      <td>0.011743</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>19972</td>
      <td>83692</td>
      <td>5591</td>
      <td>0.004268</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>12041</td>
      <td>83692</td>
      <td>5591</td>
      <td>0.002573</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>11896</td>
      <td>10839</td>
      <td>10839</td>
      <td>0.010126</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>10839</td>
      <td>1</td>
      <td>10839</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>10839</td>
      <td>1238</td>
      <td>10839</td>
      <td>0.080775</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>10839</td>
      <td>370</td>
      <td>10839</td>
      <td>0.270270</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_FILE</td>
      <td>[File, Git]</td>
      <td>5591</td>
      <td>1</td>
      <td>5591</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>3270</td>
      <td>83692</td>
      <td>5591</td>
      <td>0.000699</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>1751</td>
      <td>5591</td>
      <td>5591</td>
      <td>0.005602</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_TAG</td>
      <td>[Git, Tag]</td>
      <td>1461</td>
      <td>1</td>
      <td>1461</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Git, Tag]</td>
      <td>ON_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>1461</td>
      <td>1461</td>
      <td>10839</td>
      <td>0.009226</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_AUTHOR</td>
      <td>[Author, Git, Person]</td>
      <td>1238</td>
      <td>1</td>
      <td>1238</td>
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
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>588</td>
      <td>109</td>
      <td>450</td>
      <td>1.198777</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Json, Key]</td>
      <td>HAS_VALUE</td>
      <td>[Json, Value, Scalar]</td>
      <td>552</td>
      <td>668</td>
      <td>603</td>
      <td>0.137039</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, ExternalModule]</td>
      <td>EXPORTS</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>450</td>
      <td>33</td>
      <td>450</td>
      <td>3.030303</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMITTER</td>
      <td>[Committer, Git, Person]</td>
      <td>370</td>
      <td>1</td>
      <td>370</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, Object, TS]</td>
      <td>HAS_MEMBER</td>
      <td>[Type, TS, ObjectMember]</td>
      <td>318</td>
      <td>109</td>
      <td>318</td>
      <td>0.917431</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[File, TS, Local, Module, Mark4ModuleWeaklyCon...</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>312</td>
      <td>1</td>
      <td>450</td>
      <td>69.333333</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, TS, Union]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Primitive]</td>
      <td>303</td>
      <td>246</td>
      <td>811</td>
      <td>0.151875</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Type, TS, Declared]</td>
      <td>REFERENCES</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>288</td>
      <td>598</td>
      <td>450</td>
      <td>0.107023</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, TS, Union]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Literal]</td>
      <td>238</td>
      <td>246</td>
      <td>274</td>
      <td>0.353095</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, TS, ObjectMember]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Primitive]</td>
      <td>173</td>
      <td>318</td>
      <td>811</td>
      <td>0.067081</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>[NPM, Dependency]</td>
      <td>169</td>
      <td>29</td>
      <td>338</td>
      <td>1.724138</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Package, File, Json, NPM]</td>
      <td>DECLARES_DEPENDENCY</td>
      <td>[NPM, Dependency]</td>
      <td>161</td>
      <td>29</td>
      <td>338</td>
      <td>1.642522</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalModule]</td>
      <td>148</td>
      <td>109</td>
      <td>33</td>
      <td>4.114540</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Type, TS, Union]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Declared]</td>
      <td>145</td>
      <td>246</td>
      <td>598</td>
      <td>0.098567</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 109246
    total_number_of_relationships (edges): 323039
    -> total directed graph density: 2.7067481198271015e-05
    -> total directed graph density in percent: 0.0027067481198271015

