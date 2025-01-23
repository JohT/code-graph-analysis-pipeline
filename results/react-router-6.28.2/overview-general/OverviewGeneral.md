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
      <td>83727</td>
      <td>76.605731</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Commit]</td>
      <td>10855</td>
      <td>9.931745</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Git]</td>
      <td>5591</td>
      <td>5.115466</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Tag]</td>
      <td>1459</td>
      <td>1.334907</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Author, Git, Person]</td>
      <td>1238</td>
      <td>1.132704</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Type, TS, Primitive]</td>
      <td>811</td>
      <td>0.742022</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Json, Key]</td>
      <td>668</td>
      <td>0.611184</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Json, Value, Scalar]</td>
      <td>603</td>
      <td>0.551713</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Type, TS, Declared]</td>
      <td>598</td>
      <td>0.547138</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[TS, ExternalDeclaration]</td>
      <td>450</td>
      <td>0.411726</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Committer, Git, Person]</td>
      <td>370</td>
      <td>0.338530</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[NPM, Dependency]</td>
      <td>338</td>
      <td>0.309252</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Type, TS, ObjectMember]</td>
      <td>318</td>
      <td>0.290953</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Type, TS, Literal]</td>
      <td>274</td>
      <td>0.250695</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, TS, Union]</td>
      <td>246</td>
      <td>0.225077</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[TS, Property]</td>
      <td>137</td>
      <td>0.125348</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Json, Value, Object]</td>
      <td>133</td>
      <td>0.121688</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Value, TS, Literal]</td>
      <td>124</td>
      <td>0.113453</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, Function]</td>
      <td>109</td>
      <td>0.099729</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, Object, TS]</td>
      <td>109</td>
      <td>0.099729</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[NPM, Script]</td>
      <td>91</td>
      <td>0.083260</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Value, TS, ObjectMember]</td>
      <td>88</td>
      <td>0.080515</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, TS, FunctionParameter]</td>
      <td>80</td>
      <td>0.073196</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[TS, Parameter]</td>
      <td>76</td>
      <td>0.069536</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, TS, Function]</td>
      <td>70</td>
      <td>0.064046</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[File, Directory, Local]</td>
      <td>64</td>
      <td>0.058557</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, Variable]</td>
      <td>59</td>
      <td>0.053982</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[File, TS, Local, Module]</td>
      <td>46</td>
      <td>0.042088</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Git, Branch]</td>
      <td>42</td>
      <td>0.038428</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[TS, Interface]</td>
      <td>37</td>
      <td>0.033853</td>
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
      <td>0.001830</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[TS, Class]</td>
      <td>2</td>
      <td>0.001830</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[TS, Enum]</td>
      <td>4</td>
      <td>0.003660</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[TS, Method]</td>
      <td>4</td>
      <td>0.003660</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Value, Array, TS]</td>
      <td>5</td>
      <td>0.004575</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Type, TS, Tuple]</td>
      <td>6</td>
      <td>0.005490</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[NPM, Engine]</td>
      <td>6</td>
      <td>0.005490</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[TS, TypeParameter]</td>
      <td>8</td>
      <td>0.007320</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Value, TS, Complex]</td>
      <td>11</td>
      <td>0.010064</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Type, TS, TypeParameterReference]</td>
      <td>12</td>
      <td>0.010979</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Json, Value, Array]</td>
      <td>12</td>
      <td>0.010979</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Value, TS, Function]</td>
      <td>13</td>
      <td>0.011894</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Value, TS, Call]</td>
      <td>14</td>
      <td>0.012809</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Value, TS, Member]</td>
      <td>14</td>
      <td>0.012809</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[TS, EnumMember]</td>
      <td>16</td>
      <td>0.014639</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.017384</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, TS, NotIdentified]</td>
      <td>23</td>
      <td>0.021044</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Value, Object, TS]</td>
      <td>28</td>
      <td>0.025619</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[File, Local]</td>
      <td>28</td>
      <td>0.025619</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[File, TS, Scan]</td>
      <td>29</td>
      <td>0.026533</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Package, File, Json, NPM]</td>
      <td>29</td>
      <td>0.026533</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Value, TS, Declared]</td>
      <td>30</td>
      <td>0.027448</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[TS, TypeAlias]</td>
      <td>32</td>
      <td>0.029278</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, ExternalModule]</td>
      <td>33</td>
      <td>0.030193</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[Project, TS]</td>
      <td>33</td>
      <td>0.030193</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, TS, Intersection]</td>
      <td>34</td>
      <td>0.031108</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[File, Directory]</td>
      <td>35</td>
      <td>0.032023</td>
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
      <td>103283</td>
      <td>94.498426</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>83727</td>
      <td>76.605731</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Commit</td>
      <td>10855</td>
      <td>9.931745</td>
    </tr>
    <tr>
      <th>3</th>
      <td>File</td>
      <td>5823</td>
      <td>5.327734</td>
    </tr>
    <tr>
      <th>4</th>
      <td>TS</td>
      <td>3986</td>
      <td>3.646977</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Type</td>
      <td>2581</td>
      <td>2.361477</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Person</td>
      <td>1608</td>
      <td>1.471234</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Tag</td>
      <td>1459</td>
      <td>1.334907</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Json</td>
      <td>1445</td>
      <td>1.322098</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Author</td>
      <td>1238</td>
      <td>1.132704</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Value</td>
      <td>1076</td>
      <td>0.984483</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Primitive</td>
      <td>811</td>
      <td>0.742022</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Key</td>
      <td>668</td>
      <td>0.611184</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Declared</td>
      <td>628</td>
      <td>0.574586</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Scalar</td>
      <td>603</td>
      <td>0.551713</td>
    </tr>
    <tr>
      <th>15</th>
      <td>NPM</td>
      <td>464</td>
      <td>0.424535</td>
    </tr>
    <tr>
      <th>16</th>
      <td>ExternalDeclaration</td>
      <td>450</td>
      <td>0.411726</td>
    </tr>
    <tr>
      <th>17</th>
      <td>ObjectMember</td>
      <td>406</td>
      <td>0.371468</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Literal</td>
      <td>398</td>
      <td>0.364149</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Committer</td>
      <td>370</td>
      <td>0.338530</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Dependency</td>
      <td>338</td>
      <td>0.309252</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Object</td>
      <td>270</td>
      <td>0.247036</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Union</td>
      <td>246</td>
      <td>0.225077</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Function</td>
      <td>192</td>
      <td>0.175670</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Local</td>
      <td>138</td>
      <td>0.126263</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Property</td>
      <td>137</td>
      <td>0.125348</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Directory</td>
      <td>99</td>
      <td>0.090580</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Script</td>
      <td>91</td>
      <td>0.083260</td>
    </tr>
    <tr>
      <th>28</th>
      <td>FunctionParameter</td>
      <td>80</td>
      <td>0.073196</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Parameter</td>
      <td>76</td>
      <td>0.069536</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Variable</td>
      <td>59</td>
      <td>0.053982</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Module</td>
      <td>46</td>
      <td>0.042088</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Branch</td>
      <td>42</td>
      <td>0.038428</td>
    </tr>
    <tr>
      <th>33</th>
      <td>Interface</td>
      <td>37</td>
      <td>0.033853</td>
    </tr>
    <tr>
      <th>34</th>
      <td>Intersection</td>
      <td>34</td>
      <td>0.031108</td>
    </tr>
    <tr>
      <th>35</th>
      <td>ExternalModule</td>
      <td>33</td>
      <td>0.030193</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Project</td>
      <td>33</td>
      <td>0.030193</td>
    </tr>
    <tr>
      <th>37</th>
      <td>TypeAlias</td>
      <td>32</td>
      <td>0.029278</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Package</td>
      <td>29</td>
      <td>0.026533</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Scan</td>
      <td>29</td>
      <td>0.026533</td>
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

    Total number of relationships: 323206





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
      <td>83727</td>
      <td>25.905150</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>83727</td>
      <td>25.905150</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>54984</td>
      <td>17.012060</td>
    </tr>
    <tr>
      <th>3</th>
      <td>COMMITTED</td>
      <td>21710</td>
      <td>6.717078</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CREATES</td>
      <td>19972</td>
      <td>6.179341</td>
    </tr>
    <tr>
      <th>5</th>
      <td>DELETES</td>
      <td>12041</td>
      <td>3.725488</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HAS_PARENT</td>
      <td>11912</td>
      <td>3.685575</td>
    </tr>
    <tr>
      <th>7</th>
      <td>HAS_COMMIT</td>
      <td>10855</td>
      <td>3.358539</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_FILE</td>
      <td>5591</td>
      <td>1.729857</td>
    </tr>
    <tr>
      <th>9</th>
      <td>RENAMES</td>
      <td>3270</td>
      <td>1.011739</td>
    </tr>
    <tr>
      <th>10</th>
      <td>DEPENDS_ON</td>
      <td>1845</td>
      <td>0.570843</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_NEW_NAME</td>
      <td>1751</td>
      <td>0.541760</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS_TAG</td>
      <td>1459</td>
      <td>0.451415</td>
    </tr>
    <tr>
      <th>13</th>
      <td>ON_COMMIT</td>
      <td>1459</td>
      <td>0.451415</td>
    </tr>
    <tr>
      <th>14</th>
      <td>HAS_AUTHOR</td>
      <td>1238</td>
      <td>0.383037</td>
    </tr>
    <tr>
      <th>15</th>
      <td>CONTAINS</td>
      <td>1199</td>
      <td>0.370971</td>
    </tr>
    <tr>
      <th>16</th>
      <td>OF_TYPE</td>
      <td>1030</td>
      <td>0.318682</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_KEY</td>
      <td>668</td>
      <td>0.206679</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_VALUE</td>
      <td>668</td>
      <td>0.206679</td>
    </tr>
    <tr>
      <th>19</th>
      <td>EXPORTS</td>
      <td>659</td>
      <td>0.203895</td>
    </tr>
    <tr>
      <th>20</th>
      <td>REFERENCES</td>
      <td>489</td>
      <td>0.151297</td>
    </tr>
    <tr>
      <th>21</th>
      <td>DECLARES</td>
      <td>410</td>
      <td>0.126854</td>
    </tr>
    <tr>
      <th>22</th>
      <td>HAS_MEMBER</td>
      <td>406</td>
      <td>0.125616</td>
    </tr>
    <tr>
      <th>23</th>
      <td>HAS_COMMITTER</td>
      <td>370</td>
      <td>0.114478</td>
    </tr>
    <tr>
      <th>24</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>202</td>
      <td>0.062499</td>
    </tr>
    <tr>
      <th>25</th>
      <td>RETURNS</td>
      <td>183</td>
      <td>0.056620</td>
    </tr>
    <tr>
      <th>26</th>
      <td>DECLARES_DEV_DEPENDENCY</td>
      <td>169</td>
      <td>0.052289</td>
    </tr>
    <tr>
      <th>27</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>0.049813</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_PARAMETER</td>
      <td>155</td>
      <td>0.047957</td>
    </tr>
    <tr>
      <th>29</th>
      <td>RESOLVES_TO</td>
      <td>103</td>
      <td>0.031868</td>
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
      <td>0.000309</td>
    </tr>
    <tr>
      <th>1</th>
      <td>REFERENCED_PROJECTS</td>
      <td>5</td>
      <td>0.001547</td>
    </tr>
    <tr>
      <th>2</th>
      <td>DECLARES_ENGINE</td>
      <td>6</td>
      <td>0.001856</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SIMILAR</td>
      <td>8</td>
      <td>0.002475</td>
    </tr>
    <tr>
      <th>4</th>
      <td>DECLARES_PEER_DEPENDENCY</td>
      <td>8</td>
      <td>0.002475</td>
    </tr>
    <tr>
      <th>5</th>
      <td>CONSTRAINED_BY</td>
      <td>8</td>
      <td>0.002475</td>
    </tr>
    <tr>
      <th>6</th>
      <td>EXTENDS</td>
      <td>12</td>
      <td>0.003713</td>
    </tr>
    <tr>
      <th>7</th>
      <td>PARENT</td>
      <td>14</td>
      <td>0.004332</td>
    </tr>
    <tr>
      <th>8</th>
      <td>MEMBER</td>
      <td>14</td>
      <td>0.004332</td>
    </tr>
    <tr>
      <th>9</th>
      <td>HAS_ARGUMENT</td>
      <td>14</td>
      <td>0.004332</td>
    </tr>
    <tr>
      <th>10</th>
      <td>CALLS</td>
      <td>14</td>
      <td>0.004332</td>
    </tr>
    <tr>
      <th>11</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.005879</td>
    </tr>
    <tr>
      <th>12</th>
      <td>PROVIDED_BY_NPM_DEPENDENCY</td>
      <td>20</td>
      <td>0.006188</td>
    </tr>
    <tr>
      <th>13</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.008663</td>
    </tr>
    <tr>
      <th>14</th>
      <td>CONTAINS_PROJECT</td>
      <td>33</td>
      <td>0.010210</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_CONFIG</td>
      <td>33</td>
      <td>0.010210</td>
    </tr>
    <tr>
      <th>16</th>
      <td>IS_DESCRIBED_IN_NPM_PACKAGE</td>
      <td>33</td>
      <td>0.010210</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_ROOT</td>
      <td>33</td>
      <td>0.010210</td>
    </tr>
    <tr>
      <th>18</th>
      <td>HAS_NPM_PACKAGE</td>
      <td>33</td>
      <td>0.010210</td>
    </tr>
    <tr>
      <th>19</th>
      <td>USES</td>
      <td>33</td>
      <td>0.010210</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_BRANCH</td>
      <td>42</td>
      <td>0.012995</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_HEAD</td>
      <td>43</td>
      <td>0.013304</td>
    </tr>
    <tr>
      <th>22</th>
      <td>COPY_OF</td>
      <td>43</td>
      <td>0.013304</td>
    </tr>
    <tr>
      <th>23</th>
      <td>CONTAINS_VALUE</td>
      <td>51</td>
      <td>0.015779</td>
    </tr>
    <tr>
      <th>24</th>
      <td>INITIALIZED_WITH</td>
      <td>75</td>
      <td>0.023205</td>
    </tr>
    <tr>
      <th>25</th>
      <td>COPIES</td>
      <td>79</td>
      <td>0.024443</td>
    </tr>
    <tr>
      <th>26</th>
      <td>DECLARES_SCRIPT</td>
      <td>91</td>
      <td>0.028155</td>
    </tr>
    <tr>
      <th>27</th>
      <td>RESOLVES_TO</td>
      <td>103</td>
      <td>0.031868</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_PARAMETER</td>
      <td>155</td>
      <td>0.047957</td>
    </tr>
    <tr>
      <th>29</th>
      <td>DECLARES_DEPENDENCY</td>
      <td>161</td>
      <td>0.049813</td>
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
      <td>83727</td>
      <td>10855</td>
      <td>83727</td>
      <td>0.009212</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>83727</td>
      <td>83727</td>
      <td>5591</td>
      <td>0.017886</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>54984</td>
      <td>83727</td>
      <td>5591</td>
      <td>0.011746</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>19972</td>
      <td>83727</td>
      <td>5591</td>
      <td>0.004266</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>12041</td>
      <td>83727</td>
      <td>5591</td>
      <td>0.002572</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>11912</td>
      <td>10855</td>
      <td>10855</td>
      <td>0.010109</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>10855</td>
      <td>1</td>
      <td>10855</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>10855</td>
      <td>1238</td>
      <td>10855</td>
      <td>0.080775</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>10855</td>
      <td>370</td>
      <td>10855</td>
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
      <td>83727</td>
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
      <td>1459</td>
      <td>1</td>
      <td>1459</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Git, Tag]</td>
      <td>ON_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>1459</td>
      <td>1459</td>
      <td>10855</td>
      <td>0.009212</td>
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

    total_number_of_nodes (vertices): 109296
    total_number_of_relationships (edges): 323206
    -> total directed graph density: 2.7056701603251926e-05
    -> total directed graph density in percent: 0.0027056701603251927

