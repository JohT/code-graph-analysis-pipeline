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

    Total number of nodes: 89929





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
      <td>70843</td>
      <td>78.776590</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Commit]</td>
      <td>9771</td>
      <td>10.865238</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Git]</td>
      <td>5030</td>
      <td>5.593301</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Author, Git, Person]</td>
      <td>1179</td>
      <td>1.311034</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Tag]</td>
      <td>1026</td>
      <td>1.140900</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Committer, Git, Person]</td>
      <td>370</td>
      <td>0.411436</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Type, TS, Primitive, ExternalType]</td>
      <td>291</td>
      <td>0.323589</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>286</td>
      <td>0.318029</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[TS, ExternalDeclaration]</td>
      <td>211</td>
      <td>0.234630</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Type, TS, Literal, ExternalType]</td>
      <td>136</td>
      <td>0.151230</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>120</td>
      <td>0.133439</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Type, TS, ObjectMember, ExternalType]</td>
      <td>98</td>
      <td>0.108975</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[TS, Property]</td>
      <td>65</td>
      <td>0.072279</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[TS, Function]</td>
      <td>47</td>
      <td>0.052263</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, TS, Object, ExternalType]</td>
      <td>38</td>
      <td>0.042256</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, TS, FunctionParameter, ExternalType]</td>
      <td>38</td>
      <td>0.042256</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[TS, Parameter]</td>
      <td>33</td>
      <td>0.036696</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, TS, Function, ExternalType]</td>
      <td>33</td>
      <td>0.036696</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, ExternalModule]</td>
      <td>25</td>
      <td>0.027800</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[File]</td>
      <td>25</td>
      <td>0.027800</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[TS, Variable]</td>
      <td>24</td>
      <td>0.026688</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[Git, Branch]</td>
      <td>24</td>
      <td>0.026688</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[TS, Literal, Value]</td>
      <td>20</td>
      <td>0.022240</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.021128</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[TS, Interface]</td>
      <td>18</td>
      <td>0.020016</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, TS, Intersection, ExternalType]</td>
      <td>17</td>
      <td>0.018904</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[File, Local, Directory]</td>
      <td>16</td>
      <td>0.017792</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[File, Directory]</td>
      <td>16</td>
      <td>0.017792</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[TS, TypeAlias]</td>
      <td>14</td>
      <td>0.015568</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[TS, Declared, Value]</td>
      <td>13</td>
      <td>0.014456</td>
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
      <td>0.001112</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[File, TS, Scan]</td>
      <td>1</td>
      <td>0.001112</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[TS, Class]</td>
      <td>1</td>
      <td>0.001112</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Repository, File, Git]</td>
      <td>1</td>
      <td>0.001112</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[TS, Method]</td>
      <td>1</td>
      <td>0.001112</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[TS, ObjectMember, Value]</td>
      <td>1</td>
      <td>0.001112</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[TS, Constructor]</td>
      <td>1</td>
      <td>0.001112</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[TS, Enum]</td>
      <td>2</td>
      <td>0.002224</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[TS, Object, Value]</td>
      <td>3</td>
      <td>0.003336</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Type, TS, Tuple, ExternalType]</td>
      <td>3</td>
      <td>0.003336</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[TS, Function, Value]</td>
      <td>4</td>
      <td>0.004448</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[TS, TypeParameter]</td>
      <td>4</td>
      <td>0.004448</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[TS, Value, Complex]</td>
      <td>5</td>
      <td>0.005560</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Project, TS]</td>
      <td>6</td>
      <td>0.006672</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[File, Local]</td>
      <td>6</td>
      <td>0.006672</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, TS, TypeParameterReference, ExternalType]</td>
      <td>6</td>
      <td>0.006672</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[TS, Value, Call]</td>
      <td>6</td>
      <td>0.006672</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[File, TS, Local, Module]</td>
      <td>6</td>
      <td>0.006672</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, Value, Member]</td>
      <td>6</td>
      <td>0.006672</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[TS, EnumMember]</td>
      <td>8</td>
      <td>0.008896</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, TS, NotIdentified, ExternalType]</td>
      <td>11</td>
      <td>0.012232</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[TS, Declared, Value]</td>
      <td>13</td>
      <td>0.014456</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[TS, TypeAlias]</td>
      <td>14</td>
      <td>0.015568</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[File, Local, Directory]</td>
      <td>16</td>
      <td>0.017792</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[File, Directory]</td>
      <td>16</td>
      <td>0.017792</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[Type, TS, Intersection, ExternalType]</td>
      <td>17</td>
      <td>0.018904</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, Interface]</td>
      <td>18</td>
      <td>0.020016</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.021128</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[TS, Literal, Value]</td>
      <td>20</td>
      <td>0.022240</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Git, Branch]</td>
      <td>24</td>
      <td>0.026688</td>
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
      <td>88244</td>
      <td>98.126300</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>70843</td>
      <td>78.776590</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Commit</td>
      <td>9771</td>
      <td>10.865238</td>
    </tr>
    <tr>
      <th>3</th>
      <td>File</td>
      <td>5101</td>
      <td>5.672253</td>
    </tr>
    <tr>
      <th>4</th>
      <td>TS</td>
      <td>1602</td>
      <td>1.781405</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Person</td>
      <td>1549</td>
      <td>1.722470</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Author</td>
      <td>1179</td>
      <td>1.311034</td>
    </tr>
    <tr>
      <th>7</th>
      <td>ExternalType</td>
      <td>1077</td>
      <td>1.197611</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Type</td>
      <td>1077</td>
      <td>1.197611</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Tag</td>
      <td>1026</td>
      <td>1.140900</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Committer</td>
      <td>370</td>
      <td>0.411436</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Declared</td>
      <td>299</td>
      <td>0.332485</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Primitive</td>
      <td>291</td>
      <td>0.323589</td>
    </tr>
    <tr>
      <th>13</th>
      <td>ExternalDeclaration</td>
      <td>211</td>
      <td>0.234630</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Literal</td>
      <td>156</td>
      <td>0.173470</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Union</td>
      <td>120</td>
      <td>0.133439</td>
    </tr>
    <tr>
      <th>16</th>
      <td>ObjectMember</td>
      <td>99</td>
      <td>0.110087</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Function</td>
      <td>84</td>
      <td>0.093407</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Property</td>
      <td>65</td>
      <td>0.072279</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Value</td>
      <td>58</td>
      <td>0.064495</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Object</td>
      <td>41</td>
      <td>0.045592</td>
    </tr>
    <tr>
      <th>21</th>
      <td>FunctionParameter</td>
      <td>38</td>
      <td>0.042256</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Parameter</td>
      <td>33</td>
      <td>0.036696</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Directory</td>
      <td>32</td>
      <td>0.035584</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Local</td>
      <td>28</td>
      <td>0.031136</td>
    </tr>
    <tr>
      <th>25</th>
      <td>ExternalModule</td>
      <td>25</td>
      <td>0.027800</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Branch</td>
      <td>24</td>
      <td>0.026688</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Variable</td>
      <td>24</td>
      <td>0.026688</td>
    </tr>
    <tr>
      <th>28</th>
      <td>jQAssistant</td>
      <td>20</td>
      <td>0.022240</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Concept</td>
      <td>19</td>
      <td>0.021128</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Rule</td>
      <td>19</td>
      <td>0.021128</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Interface</td>
      <td>18</td>
      <td>0.020016</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Intersection</td>
      <td>17</td>
      <td>0.018904</td>
    </tr>
    <tr>
      <th>33</th>
      <td>TypeAlias</td>
      <td>14</td>
      <td>0.015568</td>
    </tr>
    <tr>
      <th>34</th>
      <td>NotIdentified</td>
      <td>11</td>
      <td>0.012232</td>
    </tr>
    <tr>
      <th>35</th>
      <td>EnumMember</td>
      <td>8</td>
      <td>0.008896</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Call</td>
      <td>6</td>
      <td>0.006672</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Member</td>
      <td>6</td>
      <td>0.006672</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Module</td>
      <td>6</td>
      <td>0.006672</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Project</td>
      <td>6</td>
      <td>0.006672</td>
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

    Total number of relationships: 271259





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
      <td>70843</td>
      <td>26.116368</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>70843</td>
      <td>26.116368</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>47138</td>
      <td>17.377488</td>
    </tr>
    <tr>
      <th>3</th>
      <td>COMMITTED</td>
      <td>19542</td>
      <td>7.204185</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CREATES</td>
      <td>16540</td>
      <td>6.097494</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_PARENT</td>
      <td>10759</td>
      <td>3.966320</td>
    </tr>
    <tr>
      <th>6</th>
      <td>DELETES</td>
      <td>9848</td>
      <td>3.630479</td>
    </tr>
    <tr>
      <th>7</th>
      <td>HAS_COMMIT</td>
      <td>9771</td>
      <td>3.602092</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_FILE</td>
      <td>5030</td>
      <td>1.854316</td>
    </tr>
    <tr>
      <th>9</th>
      <td>RENAMES</td>
      <td>2683</td>
      <td>0.989092</td>
    </tr>
    <tr>
      <th>10</th>
      <td>HAS_NEW_NAME</td>
      <td>1540</td>
      <td>0.567723</td>
    </tr>
    <tr>
      <th>11</th>
      <td>HAS_AUTHOR</td>
      <td>1179</td>
      <td>0.434640</td>
    </tr>
    <tr>
      <th>12</th>
      <td>HAS_TAG</td>
      <td>1026</td>
      <td>0.378236</td>
    </tr>
    <tr>
      <th>13</th>
      <td>ON_COMMIT</td>
      <td>1026</td>
      <td>0.378236</td>
    </tr>
    <tr>
      <th>14</th>
      <td>DEPENDS_ON</td>
      <td>953</td>
      <td>0.351325</td>
    </tr>
    <tr>
      <th>15</th>
      <td>CONTAINS</td>
      <td>536</td>
      <td>0.197597</td>
    </tr>
    <tr>
      <th>16</th>
      <td>HAS_COMMITTER</td>
      <td>370</td>
      <td>0.136401</td>
    </tr>
    <tr>
      <th>17</th>
      <td>OF_TYPE</td>
      <td>330</td>
      <td>0.121655</td>
    </tr>
    <tr>
      <th>18</th>
      <td>EXPORTS</td>
      <td>271</td>
      <td>0.099905</td>
    </tr>
    <tr>
      <th>19</th>
      <td>REFERENCES</td>
      <td>198</td>
      <td>0.072993</td>
    </tr>
    <tr>
      <th>20</th>
      <td>DECLARES</td>
      <td>185</td>
      <td>0.068201</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_MEMBER</td>
      <td>99</td>
      <td>0.036496</td>
    </tr>
    <tr>
      <th>22</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>99</td>
      <td>0.036496</td>
    </tr>
    <tr>
      <th>23</th>
      <td>RETURNS</td>
      <td>81</td>
      <td>0.029861</td>
    </tr>
    <tr>
      <th>24</th>
      <td>HAS_PARAMETER</td>
      <td>71</td>
      <td>0.026174</td>
    </tr>
    <tr>
      <th>25</th>
      <td>INITIALIZED_WITH</td>
      <td>32</td>
      <td>0.011797</td>
    </tr>
    <tr>
      <th>26</th>
      <td>COPIES</td>
      <td>29</td>
      <td>0.010691</td>
    </tr>
    <tr>
      <th>27</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.010322</td>
    </tr>
    <tr>
      <th>28</th>
      <td>RESOLVES_TO</td>
      <td>27</td>
      <td>0.009954</td>
    </tr>
    <tr>
      <th>29</th>
      <td>HAS_HEAD</td>
      <td>25</td>
      <td>0.009216</td>
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
      <td>0.001475</td>
    </tr>
    <tr>
      <th>1</th>
      <td>REFERENCED_PROJECTS</td>
      <td>5</td>
      <td>0.001843</td>
    </tr>
    <tr>
      <th>2</th>
      <td>MEMBER</td>
      <td>6</td>
      <td>0.002212</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HAS_ROOT</td>
      <td>6</td>
      <td>0.002212</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HAS_CONFIG</td>
      <td>6</td>
      <td>0.002212</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_ARGUMENT</td>
      <td>6</td>
      <td>0.002212</td>
    </tr>
    <tr>
      <th>6</th>
      <td>CONTAINS_PROJECT</td>
      <td>6</td>
      <td>0.002212</td>
    </tr>
    <tr>
      <th>7</th>
      <td>CALLS</td>
      <td>6</td>
      <td>0.002212</td>
    </tr>
    <tr>
      <th>8</th>
      <td>PARENT</td>
      <td>6</td>
      <td>0.002212</td>
    </tr>
    <tr>
      <th>9</th>
      <td>EXTENDS</td>
      <td>7</td>
      <td>0.002581</td>
    </tr>
    <tr>
      <th>10</th>
      <td>SIMILAR</td>
      <td>10</td>
      <td>0.003687</td>
    </tr>
    <tr>
      <th>11</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.007004</td>
    </tr>
    <tr>
      <th>12</th>
      <td>COPY_OF</td>
      <td>21</td>
      <td>0.007742</td>
    </tr>
    <tr>
      <th>13</th>
      <td>HAS_BRANCH</td>
      <td>24</td>
      <td>0.008848</td>
    </tr>
    <tr>
      <th>14</th>
      <td>USES</td>
      <td>25</td>
      <td>0.009216</td>
    </tr>
    <tr>
      <th>15</th>
      <td>HAS_HEAD</td>
      <td>25</td>
      <td>0.009216</td>
    </tr>
    <tr>
      <th>16</th>
      <td>RESOLVES_TO</td>
      <td>27</td>
      <td>0.009954</td>
    </tr>
    <tr>
      <th>17</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.010322</td>
    </tr>
    <tr>
      <th>18</th>
      <td>COPIES</td>
      <td>29</td>
      <td>0.010691</td>
    </tr>
    <tr>
      <th>19</th>
      <td>INITIALIZED_WITH</td>
      <td>32</td>
      <td>0.011797</td>
    </tr>
    <tr>
      <th>20</th>
      <td>HAS_PARAMETER</td>
      <td>71</td>
      <td>0.026174</td>
    </tr>
    <tr>
      <th>21</th>
      <td>RETURNS</td>
      <td>81</td>
      <td>0.029861</td>
    </tr>
    <tr>
      <th>22</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>99</td>
      <td>0.036496</td>
    </tr>
    <tr>
      <th>23</th>
      <td>HAS_MEMBER</td>
      <td>99</td>
      <td>0.036496</td>
    </tr>
    <tr>
      <th>24</th>
      <td>DECLARES</td>
      <td>185</td>
      <td>0.068201</td>
    </tr>
    <tr>
      <th>25</th>
      <td>REFERENCES</td>
      <td>198</td>
      <td>0.072993</td>
    </tr>
    <tr>
      <th>26</th>
      <td>EXPORTS</td>
      <td>271</td>
      <td>0.099905</td>
    </tr>
    <tr>
      <th>27</th>
      <td>OF_TYPE</td>
      <td>330</td>
      <td>0.121655</td>
    </tr>
    <tr>
      <th>28</th>
      <td>HAS_COMMITTER</td>
      <td>370</td>
      <td>0.136401</td>
    </tr>
    <tr>
      <th>29</th>
      <td>CONTAINS</td>
      <td>536</td>
      <td>0.197597</td>
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
      <td>70843</td>
      <td>9771</td>
      <td>70843</td>
      <td>0.010234</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>70843</td>
      <td>70843</td>
      <td>5030</td>
      <td>0.019881</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>47138</td>
      <td>70843</td>
      <td>5030</td>
      <td>0.013228</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>16540</td>
      <td>70843</td>
      <td>5030</td>
      <td>0.004642</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>10759</td>
      <td>9771</td>
      <td>9771</td>
      <td>0.011269</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>9848</td>
      <td>70843</td>
      <td>5030</td>
      <td>0.002764</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>9771</td>
      <td>1</td>
      <td>9771</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>9771</td>
      <td>1179</td>
      <td>9771</td>
      <td>0.084818</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>9771</td>
      <td>370</td>
      <td>9771</td>
      <td>0.270270</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_FILE</td>
      <td>[File, Git]</td>
      <td>5030</td>
      <td>1</td>
      <td>5030</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>2683</td>
      <td>70843</td>
      <td>5030</td>
      <td>0.000753</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>1540</td>
      <td>5030</td>
      <td>5030</td>
      <td>0.006087</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_AUTHOR</td>
      <td>[Author, Git, Person]</td>
      <td>1179</td>
      <td>1</td>
      <td>1179</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_TAG</td>
      <td>[Git, Tag]</td>
      <td>1026</td>
      <td>1</td>
      <td>1026</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Git, Tag]</td>
      <td>ON_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>1026</td>
      <td>1026</td>
      <td>9771</td>
      <td>0.010234</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Repository, File, Git]</td>
      <td>HAS_COMMITTER</td>
      <td>[Committer, Git, Person]</td>
      <td>370</td>
      <td>1</td>
      <td>370</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>280</td>
      <td>47</td>
      <td>211</td>
      <td>2.823435</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[TS, ExternalModule]</td>
      <td>EXPORTS</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>211</td>
      <td>25</td>
      <td>211</td>
      <td>4.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Primitive, ExternalType]</td>
      <td>149</td>
      <td>120</td>
      <td>291</td>
      <td>0.426690</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[File, TS, Local, Module, Mark4ModuleWeaklyCon...</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>148</td>
      <td>1</td>
      <td>211</td>
      <td>70.142180</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>REFERENCES</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>139</td>
      <td>286</td>
      <td>211</td>
      <td>0.230338</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalModule]</td>
      <td>129</td>
      <td>47</td>
      <td>25</td>
      <td>10.978723</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Literal, ExternalType]</td>
      <td>119</td>
      <td>120</td>
      <td>136</td>
      <td>0.729167</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Type, TS, Object, ExternalType]</td>
      <td>HAS_MEMBER</td>
      <td>[Type, TS, ObjectMember, ExternalType]</td>
      <td>98</td>
      <td>38</td>
      <td>98</td>
      <td>2.631579</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>78</td>
      <td>120</td>
      <td>286</td>
      <td>0.227273</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[TS, Interface]</td>
      <td>DECLARES</td>
      <td>[TS, Property]</td>
      <td>61</td>
      <td>18</td>
      <td>65</td>
      <td>5.213675</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, Property]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>46</td>
      <td>65</td>
      <td>120</td>
      <td>0.589744</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[File, Directory]</td>
      <td>CONTAINS</td>
      <td>[File]</td>
      <td>46</td>
      <td>16</td>
      <td>25</td>
      <td>11.500000</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[TS, Variable]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>44</td>
      <td>24</td>
      <td>211</td>
      <td>0.868878</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>43</td>
      <td>286</td>
      <td>286</td>
      <td>0.052570</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 89929
    total_number_of_relationships (edges): 271259
    -> total directed graph density: 3.354203883616283e-05
    -> total directed graph density in percent: 0.0033542038836162826

