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

    Total number of nodes: 90841





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
      <td>71686</td>
      <td>78.913706</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Commit]</td>
      <td>9839</td>
      <td>10.831012</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[File, Git]</td>
      <td>5048</td>
      <td>5.556962</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Author, Git, Person]</td>
      <td>1181</td>
      <td>1.300074</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Tag]</td>
      <td>1047</td>
      <td>1.152563</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Committer, Git, Person]</td>
      <td>371</td>
      <td>0.408406</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Type, TS, Primitive, ExternalType]</td>
      <td>291</td>
      <td>0.320340</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>286</td>
      <td>0.314836</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[TS, ExternalDeclaration]</td>
      <td>211</td>
      <td>0.232274</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Type, TS, Literal, ExternalType]</td>
      <td>136</td>
      <td>0.149712</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>120</td>
      <td>0.132099</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[Type, TS, ObjectMember, ExternalType]</td>
      <td>98</td>
      <td>0.107881</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[TS, Property]</td>
      <td>65</td>
      <td>0.071554</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[TS, Function]</td>
      <td>47</td>
      <td>0.051739</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, TS, Object, ExternalType]</td>
      <td>38</td>
      <td>0.041831</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, TS, FunctionParameter, ExternalType]</td>
      <td>38</td>
      <td>0.041831</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[TS, Parameter]</td>
      <td>33</td>
      <td>0.036327</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, TS, Function, ExternalType]</td>
      <td>33</td>
      <td>0.036327</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, ExternalModule]</td>
      <td>25</td>
      <td>0.027521</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[TS, Variable]</td>
      <td>24</td>
      <td>0.026420</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Git, Branch]</td>
      <td>24</td>
      <td>0.026420</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[TS, Literal, Value]</td>
      <td>20</td>
      <td>0.022016</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.020916</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[TS, Interface]</td>
      <td>18</td>
      <td>0.019815</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, TS, Intersection, ExternalType]</td>
      <td>17</td>
      <td>0.018714</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[File, Local, Directory]</td>
      <td>16</td>
      <td>0.017613</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[TS, TypeAlias]</td>
      <td>14</td>
      <td>0.015412</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[TS, Declared, Value]</td>
      <td>13</td>
      <td>0.014311</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, TS, NotIdentified, ExternalType]</td>
      <td>11</td>
      <td>0.012109</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[TS, EnumMember]</td>
      <td>8</td>
      <td>0.008807</td>
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
      <td>0.001101</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[File, TS, Scan]</td>
      <td>1</td>
      <td>0.001101</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[TS, Class]</td>
      <td>1</td>
      <td>0.001101</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[File, Directory]</td>
      <td>1</td>
      <td>0.001101</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[TS, Method]</td>
      <td>1</td>
      <td>0.001101</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[TS, ObjectMember, Value]</td>
      <td>1</td>
      <td>0.001101</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[TS, Constructor]</td>
      <td>1</td>
      <td>0.001101</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[TS, Enum]</td>
      <td>2</td>
      <td>0.002202</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[TS, Object, Value]</td>
      <td>3</td>
      <td>0.003302</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[Type, TS, Tuple, ExternalType]</td>
      <td>3</td>
      <td>0.003302</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[TS, Function, Value]</td>
      <td>4</td>
      <td>0.004403</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[TS, TypeParameter]</td>
      <td>4</td>
      <td>0.004403</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[TS, Value, Complex]</td>
      <td>5</td>
      <td>0.005504</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[Type, TS, TypeParameterReference, ExternalType]</td>
      <td>6</td>
      <td>0.006605</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[File, TS, Local, Module]</td>
      <td>6</td>
      <td>0.006605</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[File, Local]</td>
      <td>6</td>
      <td>0.006605</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[Project, TS]</td>
      <td>6</td>
      <td>0.006605</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[TS, Value, Member]</td>
      <td>6</td>
      <td>0.006605</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[TS, Value, Call]</td>
      <td>6</td>
      <td>0.006605</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[TS, EnumMember]</td>
      <td>8</td>
      <td>0.008807</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[Type, TS, NotIdentified, ExternalType]</td>
      <td>11</td>
      <td>0.012109</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[TS, Declared, Value]</td>
      <td>13</td>
      <td>0.014311</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[TS, TypeAlias]</td>
      <td>14</td>
      <td>0.015412</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[File, Local, Directory]</td>
      <td>16</td>
      <td>0.017613</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, TS, Intersection, ExternalType]</td>
      <td>17</td>
      <td>0.018714</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[TS, Interface]</td>
      <td>18</td>
      <td>0.019815</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[jQAssistant, Rule, Concept]</td>
      <td>19</td>
      <td>0.020916</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[TS, Literal, Value]</td>
      <td>20</td>
      <td>0.022016</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Git, Branch]</td>
      <td>24</td>
      <td>0.026420</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[TS, Variable]</td>
      <td>24</td>
      <td>0.026420</td>
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
      <td>89196</td>
      <td>98.189144</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Change</td>
      <td>71686</td>
      <td>78.913706</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Commit</td>
      <td>9839</td>
      <td>10.831012</td>
    </tr>
    <tr>
      <th>3</th>
      <td>File</td>
      <td>5078</td>
      <td>5.589987</td>
    </tr>
    <tr>
      <th>4</th>
      <td>TS</td>
      <td>1602</td>
      <td>1.763521</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Person</td>
      <td>1552</td>
      <td>1.708480</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Author</td>
      <td>1181</td>
      <td>1.300074</td>
    </tr>
    <tr>
      <th>7</th>
      <td>ExternalType</td>
      <td>1077</td>
      <td>1.185588</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Type</td>
      <td>1077</td>
      <td>1.185588</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Tag</td>
      <td>1047</td>
      <td>1.152563</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Committer</td>
      <td>371</td>
      <td>0.408406</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Declared</td>
      <td>299</td>
      <td>0.329147</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Primitive</td>
      <td>291</td>
      <td>0.320340</td>
    </tr>
    <tr>
      <th>13</th>
      <td>ExternalDeclaration</td>
      <td>211</td>
      <td>0.232274</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Literal</td>
      <td>156</td>
      <td>0.171729</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Union</td>
      <td>120</td>
      <td>0.132099</td>
    </tr>
    <tr>
      <th>16</th>
      <td>ObjectMember</td>
      <td>99</td>
      <td>0.108982</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Function</td>
      <td>84</td>
      <td>0.092469</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Property</td>
      <td>65</td>
      <td>0.071554</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Value</td>
      <td>58</td>
      <td>0.063848</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Object</td>
      <td>41</td>
      <td>0.045134</td>
    </tr>
    <tr>
      <th>21</th>
      <td>FunctionParameter</td>
      <td>38</td>
      <td>0.041831</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Parameter</td>
      <td>33</td>
      <td>0.036327</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Local</td>
      <td>28</td>
      <td>0.030823</td>
    </tr>
    <tr>
      <th>24</th>
      <td>ExternalModule</td>
      <td>25</td>
      <td>0.027521</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Branch</td>
      <td>24</td>
      <td>0.026420</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Variable</td>
      <td>24</td>
      <td>0.026420</td>
    </tr>
    <tr>
      <th>27</th>
      <td>jQAssistant</td>
      <td>20</td>
      <td>0.022016</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Concept</td>
      <td>19</td>
      <td>0.020916</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Rule</td>
      <td>19</td>
      <td>0.020916</td>
    </tr>
    <tr>
      <th>30</th>
      <td>Interface</td>
      <td>18</td>
      <td>0.019815</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Directory</td>
      <td>17</td>
      <td>0.018714</td>
    </tr>
    <tr>
      <th>32</th>
      <td>Intersection</td>
      <td>17</td>
      <td>0.018714</td>
    </tr>
    <tr>
      <th>33</th>
      <td>TypeAlias</td>
      <td>14</td>
      <td>0.015412</td>
    </tr>
    <tr>
      <th>34</th>
      <td>NotIdentified</td>
      <td>11</td>
      <td>0.012109</td>
    </tr>
    <tr>
      <th>35</th>
      <td>EnumMember</td>
      <td>8</td>
      <td>0.008807</td>
    </tr>
    <tr>
      <th>36</th>
      <td>Call</td>
      <td>6</td>
      <td>0.006605</td>
    </tr>
    <tr>
      <th>37</th>
      <td>Member</td>
      <td>6</td>
      <td>0.006605</td>
    </tr>
    <tr>
      <th>38</th>
      <td>Module</td>
      <td>6</td>
      <td>0.006605</td>
    </tr>
    <tr>
      <th>39</th>
      <td>Project</td>
      <td>6</td>
      <td>0.006605</td>
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

    Total number of relationships: 256591





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
      <td>71686</td>
      <td>27.937847</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MODIFIES</td>
      <td>71686</td>
      <td>27.937847</td>
    </tr>
    <tr>
      <th>2</th>
      <td>UPDATES</td>
      <td>47839</td>
      <td>18.644068</td>
    </tr>
    <tr>
      <th>3</th>
      <td>COMMITTED</td>
      <td>19678</td>
      <td>7.669014</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CREATES</td>
      <td>16663</td>
      <td>6.493992</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_PARENT</td>
      <td>10834</td>
      <td>4.222284</td>
    </tr>
    <tr>
      <th>6</th>
      <td>DELETES</td>
      <td>9889</td>
      <td>3.853993</td>
    </tr>
    <tr>
      <th>7</th>
      <td>RENAMES</td>
      <td>2705</td>
      <td>1.054207</td>
    </tr>
    <tr>
      <th>8</th>
      <td>HAS_NEW_NAME</td>
      <td>1543</td>
      <td>0.601346</td>
    </tr>
    <tr>
      <th>9</th>
      <td>ON_COMMIT</td>
      <td>1047</td>
      <td>0.408042</td>
    </tr>
    <tr>
      <th>10</th>
      <td>DEPENDS_ON</td>
      <td>953</td>
      <td>0.371408</td>
    </tr>
    <tr>
      <th>11</th>
      <td>CONTAINS</td>
      <td>465</td>
      <td>0.181222</td>
    </tr>
    <tr>
      <th>12</th>
      <td>OF_TYPE</td>
      <td>330</td>
      <td>0.128609</td>
    </tr>
    <tr>
      <th>13</th>
      <td>EXPORTS</td>
      <td>271</td>
      <td>0.105616</td>
    </tr>
    <tr>
      <th>14</th>
      <td>REFERENCES</td>
      <td>198</td>
      <td>0.077166</td>
    </tr>
    <tr>
      <th>15</th>
      <td>DECLARES</td>
      <td>185</td>
      <td>0.072099</td>
    </tr>
    <tr>
      <th>16</th>
      <td>HAS_MEMBER</td>
      <td>99</td>
      <td>0.038583</td>
    </tr>
    <tr>
      <th>17</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>99</td>
      <td>0.038583</td>
    </tr>
    <tr>
      <th>18</th>
      <td>RETURNS</td>
      <td>81</td>
      <td>0.031568</td>
    </tr>
    <tr>
      <th>19</th>
      <td>HAS_PARAMETER</td>
      <td>71</td>
      <td>0.027670</td>
    </tr>
    <tr>
      <th>20</th>
      <td>INITIALIZED_WITH</td>
      <td>32</td>
      <td>0.012471</td>
    </tr>
    <tr>
      <th>21</th>
      <td>COPIES</td>
      <td>29</td>
      <td>0.011302</td>
    </tr>
    <tr>
      <th>22</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.010912</td>
    </tr>
    <tr>
      <th>23</th>
      <td>USES</td>
      <td>25</td>
      <td>0.009743</td>
    </tr>
    <tr>
      <th>24</th>
      <td>HAS_HEAD</td>
      <td>24</td>
      <td>0.009353</td>
    </tr>
    <tr>
      <th>25</th>
      <td>RESOLVES_TO</td>
      <td>23</td>
      <td>0.008964</td>
    </tr>
    <tr>
      <th>26</th>
      <td>COPY_OF</td>
      <td>21</td>
      <td>0.008184</td>
    </tr>
    <tr>
      <th>27</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.007405</td>
    </tr>
    <tr>
      <th>28</th>
      <td>SIMILAR</td>
      <td>10</td>
      <td>0.003897</td>
    </tr>
    <tr>
      <th>29</th>
      <td>EXTENDS</td>
      <td>7</td>
      <td>0.002728</td>
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
      <td>0.001559</td>
    </tr>
    <tr>
      <th>1</th>
      <td>REFERENCED_PROJECTS</td>
      <td>5</td>
      <td>0.001949</td>
    </tr>
    <tr>
      <th>2</th>
      <td>MEMBER</td>
      <td>6</td>
      <td>0.002338</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HAS_ROOT</td>
      <td>6</td>
      <td>0.002338</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HAS_CONFIG</td>
      <td>6</td>
      <td>0.002338</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HAS_ARGUMENT</td>
      <td>6</td>
      <td>0.002338</td>
    </tr>
    <tr>
      <th>6</th>
      <td>CONTAINS_PROJECT</td>
      <td>6</td>
      <td>0.002338</td>
    </tr>
    <tr>
      <th>7</th>
      <td>CALLS</td>
      <td>6</td>
      <td>0.002338</td>
    </tr>
    <tr>
      <th>8</th>
      <td>PARENT</td>
      <td>6</td>
      <td>0.002338</td>
    </tr>
    <tr>
      <th>9</th>
      <td>EXTENDS</td>
      <td>7</td>
      <td>0.002728</td>
    </tr>
    <tr>
      <th>10</th>
      <td>SIMILAR</td>
      <td>10</td>
      <td>0.003897</td>
    </tr>
    <tr>
      <th>11</th>
      <td>INCLUDES_CONCEPT</td>
      <td>19</td>
      <td>0.007405</td>
    </tr>
    <tr>
      <th>12</th>
      <td>COPY_OF</td>
      <td>21</td>
      <td>0.008184</td>
    </tr>
    <tr>
      <th>13</th>
      <td>RESOLVES_TO</td>
      <td>23</td>
      <td>0.008964</td>
    </tr>
    <tr>
      <th>14</th>
      <td>HAS_HEAD</td>
      <td>24</td>
      <td>0.009353</td>
    </tr>
    <tr>
      <th>15</th>
      <td>USES</td>
      <td>25</td>
      <td>0.009743</td>
    </tr>
    <tr>
      <th>16</th>
      <td>REQUIRES_CONCEPT</td>
      <td>28</td>
      <td>0.010912</td>
    </tr>
    <tr>
      <th>17</th>
      <td>COPIES</td>
      <td>29</td>
      <td>0.011302</td>
    </tr>
    <tr>
      <th>18</th>
      <td>INITIALIZED_WITH</td>
      <td>32</td>
      <td>0.012471</td>
    </tr>
    <tr>
      <th>19</th>
      <td>HAS_PARAMETER</td>
      <td>71</td>
      <td>0.027670</td>
    </tr>
    <tr>
      <th>20</th>
      <td>RETURNS</td>
      <td>81</td>
      <td>0.031568</td>
    </tr>
    <tr>
      <th>21</th>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>99</td>
      <td>0.038583</td>
    </tr>
    <tr>
      <th>22</th>
      <td>HAS_MEMBER</td>
      <td>99</td>
      <td>0.038583</td>
    </tr>
    <tr>
      <th>23</th>
      <td>DECLARES</td>
      <td>185</td>
      <td>0.072099</td>
    </tr>
    <tr>
      <th>24</th>
      <td>REFERENCES</td>
      <td>198</td>
      <td>0.077166</td>
    </tr>
    <tr>
      <th>25</th>
      <td>EXPORTS</td>
      <td>271</td>
      <td>0.105616</td>
    </tr>
    <tr>
      <th>26</th>
      <td>OF_TYPE</td>
      <td>330</td>
      <td>0.128609</td>
    </tr>
    <tr>
      <th>27</th>
      <td>CONTAINS</td>
      <td>465</td>
      <td>0.181222</td>
    </tr>
    <tr>
      <th>28</th>
      <td>DEPENDS_ON</td>
      <td>953</td>
      <td>0.371408</td>
    </tr>
    <tr>
      <th>29</th>
      <td>ON_COMMIT</td>
      <td>1047</td>
      <td>0.408042</td>
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
      <td>71686</td>
      <td>9839</td>
      <td>71686</td>
      <td>0.010164</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[Git, Change]</td>
      <td>MODIFIES</td>
      <td>[File, Git]</td>
      <td>71686</td>
      <td>71686</td>
      <td>5048</td>
      <td>0.019810</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[Git, Change]</td>
      <td>UPDATES</td>
      <td>[File, Git]</td>
      <td>47839</td>
      <td>71686</td>
      <td>5048</td>
      <td>0.013220</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[Git, Change]</td>
      <td>CREATES</td>
      <td>[File, Git]</td>
      <td>16663</td>
      <td>71686</td>
      <td>5048</td>
      <td>0.004605</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[Git, Commit]</td>
      <td>HAS_PARENT</td>
      <td>[Git, Commit]</td>
      <td>10834</td>
      <td>9839</td>
      <td>9839</td>
      <td>0.011191</td>
    </tr>
    <tr>
      <th>5</th>
      <td>[Git, Change]</td>
      <td>DELETES</td>
      <td>[File, Git]</td>
      <td>9889</td>
      <td>71686</td>
      <td>5048</td>
      <td>0.002733</td>
    </tr>
    <tr>
      <th>6</th>
      <td>[Author, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>9839</td>
      <td>1181</td>
      <td>9839</td>
      <td>0.084674</td>
    </tr>
    <tr>
      <th>7</th>
      <td>[Committer, Git, Person]</td>
      <td>COMMITTED</td>
      <td>[Git, Commit]</td>
      <td>9839</td>
      <td>371</td>
      <td>9839</td>
      <td>0.269542</td>
    </tr>
    <tr>
      <th>8</th>
      <td>[Git, Change]</td>
      <td>RENAMES</td>
      <td>[File, Git]</td>
      <td>2705</td>
      <td>71686</td>
      <td>5048</td>
      <td>0.000748</td>
    </tr>
    <tr>
      <th>9</th>
      <td>[File, Git]</td>
      <td>HAS_NEW_NAME</td>
      <td>[File, Git]</td>
      <td>1543</td>
      <td>5048</td>
      <td>5048</td>
      <td>0.006055</td>
    </tr>
    <tr>
      <th>10</th>
      <td>[Git, Tag]</td>
      <td>ON_COMMIT</td>
      <td>[Git, Commit]</td>
      <td>1047</td>
      <td>1047</td>
      <td>9839</td>
      <td>0.010164</td>
    </tr>
    <tr>
      <th>11</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>280</td>
      <td>47</td>
      <td>211</td>
      <td>2.823435</td>
    </tr>
    <tr>
      <th>12</th>
      <td>[TS, ExternalModule]</td>
      <td>EXPORTS</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>211</td>
      <td>25</td>
      <td>211</td>
      <td>4.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>[File, TS, Local, Module, Mark4ModuleWeaklyCon...</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>188</td>
      <td>3</td>
      <td>211</td>
      <td>29.699842</td>
    </tr>
    <tr>
      <th>14</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Primitive, ExternalType]</td>
      <td>149</td>
      <td>120</td>
      <td>291</td>
      <td>0.426690</td>
    </tr>
    <tr>
      <th>15</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>REFERENCES</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>139</td>
      <td>286</td>
      <td>211</td>
      <td>0.230338</td>
    </tr>
    <tr>
      <th>16</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalModule]</td>
      <td>129</td>
      <td>47</td>
      <td>25</td>
      <td>10.978723</td>
    </tr>
    <tr>
      <th>17</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Literal, ExternalType]</td>
      <td>119</td>
      <td>120</td>
      <td>136</td>
      <td>0.729167</td>
    </tr>
    <tr>
      <th>18</th>
      <td>[Type, TS, Object, ExternalType]</td>
      <td>HAS_MEMBER</td>
      <td>[Type, TS, ObjectMember, ExternalType]</td>
      <td>98</td>
      <td>38</td>
      <td>98</td>
      <td>2.631579</td>
    </tr>
    <tr>
      <th>19</th>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>CONTAINS</td>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>78</td>
      <td>120</td>
      <td>286</td>
      <td>0.227273</td>
    </tr>
    <tr>
      <th>20</th>
      <td>[TS, Interface]</td>
      <td>DECLARES</td>
      <td>[TS, Property]</td>
      <td>61</td>
      <td>18</td>
      <td>65</td>
      <td>5.213675</td>
    </tr>
    <tr>
      <th>21</th>
      <td>[TS, Property]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>46</td>
      <td>65</td>
      <td>120</td>
      <td>0.589744</td>
    </tr>
    <tr>
      <th>22</th>
      <td>[TS, Variable]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, ExternalDeclaration]</td>
      <td>44</td>
      <td>24</td>
      <td>211</td>
      <td>0.868878</td>
    </tr>
    <tr>
      <th>23</th>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>HAS_TYPE_ARGUMENT</td>
      <td>[Type, TS, Declared, ExternalType]</td>
      <td>43</td>
      <td>286</td>
      <td>286</td>
      <td>0.052570</td>
    </tr>
    <tr>
      <th>24</th>
      <td>[Type, TS, Function, ExternalType]</td>
      <td>HAS_PARAMETER</td>
      <td>[Type, TS, FunctionParameter, ExternalType]</td>
      <td>38</td>
      <td>33</td>
      <td>38</td>
      <td>3.030303</td>
    </tr>
    <tr>
      <th>25</th>
      <td>[File, TS, Local, Module, Mark4ModuleWeaklyCon...</td>
      <td>DECLARES</td>
      <td>[TS, Function]</td>
      <td>37</td>
      <td>3</td>
      <td>47</td>
      <td>26.241135</td>
    </tr>
    <tr>
      <th>26</th>
      <td>[Type, TS, ObjectMember, ExternalType]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Union, ExternalType]</td>
      <td>35</td>
      <td>98</td>
      <td>120</td>
      <td>0.297619</td>
    </tr>
    <tr>
      <th>27</th>
      <td>[TS, Function]</td>
      <td>HAS_PARAMETER</td>
      <td>[TS, Parameter]</td>
      <td>33</td>
      <td>47</td>
      <td>33</td>
      <td>2.127660</td>
    </tr>
    <tr>
      <th>28</th>
      <td>[Type, TS, ObjectMember, ExternalType]</td>
      <td>OF_TYPE</td>
      <td>[Type, TS, Primitive, ExternalType]</td>
      <td>31</td>
      <td>98</td>
      <td>291</td>
      <td>0.108703</td>
    </tr>
    <tr>
      <th>29</th>
      <td>[TS, Function]</td>
      <td>DEPENDS_ON</td>
      <td>[TS, Function]</td>
      <td>30</td>
      <td>47</td>
      <td>47</td>
      <td>1.358081</td>
    </tr>
  </tbody>
</table>
</div>



## Graph Density

    total_number_of_nodes (vertices): 90841
    total_number_of_relationships (edges): 256591
    -> total directed graph density: 3.1094414771705836e-05
    -> total directed graph density in percent: 0.0031094414771705835

