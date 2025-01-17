# Overview
<br>  

### References
- [jqassistant](https://jqassistant.org)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)





## Overview

### Table 1 - Size




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>nodeCount</th>
      <th>relationshipCount</th>
      <th>artifactCount</th>
      <th>packageCount</th>
      <th>typeCount</th>
      <th>methodCount</th>
      <th>memberCount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>66220</td>
      <td>191354</td>
      <td>6</td>
      <td>94</td>
      <td>1556</td>
      <td>6304</td>
      <td>7667</td>
    </tr>
  </tbody>
</table>
</div>



## Artifacts

### Table 2a - Largest 30 types per artifact

This table shows the largest (number of types) artifacts and their kind of types (Class, Interface, Enum, Annotation).
The whole table can be found in the CSV report `Number_of_types_per_artifact`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>numberOfArtifactTypes</th>
      <th>languageElement</th>
      <th>numberOfTypes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.7.6</td>
      <td>729</td>
      <td>Interface</td>
      <td>143</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.7.6</td>
      <td>729</td>
      <td>Class</td>
      <td>541</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.7.6</td>
      <td>729</td>
      <td>Annotation</td>
      <td>26</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.7.6</td>
      <td>729</td>
      <td>Enum</td>
      <td>19</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-modelling-4.7.6</td>
      <td>149</td>
      <td>Enum</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-modelling-4.7.6</td>
      <td>149</td>
      <td>Class</td>
      <td>108</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-modelling-4.7.6</td>
      <td>149</td>
      <td>Interface</td>
      <td>26</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-modelling-4.7.6</td>
      <td>149</td>
      <td>Annotation</td>
      <td>12</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-eventsourcing-4.7.6</td>
      <td>130</td>
      <td>Class</td>
      <td>96</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-eventsourcing-4.7.6</td>
      <td>130</td>
      <td>Annotation</td>
      <td>1</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-eventsourcing-4.7.6</td>
      <td>130</td>
      <td>Interface</td>
      <td>31</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-eventsourcing-4.7.6</td>
      <td>130</td>
      <td>Enum</td>
      <td>2</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-test-4.7.6</td>
      <td>85</td>
      <td>Class</td>
      <td>69</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-test-4.7.6</td>
      <td>85</td>
      <td>Interface</td>
      <td>16</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-configuration-4.7.6</td>
      <td>39</td>
      <td>Class</td>
      <td>22</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-configuration-4.7.6</td>
      <td>39</td>
      <td>Interface</td>
      <td>15</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-configuration-4.7.6</td>
      <td>39</td>
      <td>Enum</td>
      <td>1</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-configuration-4.7.6</td>
      <td>39</td>
      <td>Annotation</td>
      <td>1</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-disruptor-4.7.6</td>
      <td>22</td>
      <td>Class</td>
      <td>22</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2b - Largest 30 types per artifact grouped

This table shows the largest (number of types) artifacts each in one row, their kind of types in columns and the count of them as values.

The source data for this aggregated table can be found in the CSV report `Number_of_types_per_artifact`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>languageElement</th>
      <th>Class</th>
      <th>Interface</th>
      <th>Annotation</th>
      <th>Enum</th>
    </tr>
    <tr>
      <th>artifactName</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>axon-messaging-4.7.6</th>
      <td>541</td>
      <td>143</td>
      <td>26</td>
      <td>19</td>
    </tr>
    <tr>
      <th>axon-modelling-4.7.6</th>
      <td>108</td>
      <td>26</td>
      <td>12</td>
      <td>3</td>
    </tr>
    <tr>
      <th>axon-eventsourcing-4.7.6</th>
      <td>96</td>
      <td>31</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>axon-test-4.7.6</th>
      <td>69</td>
      <td>16</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>axon-configuration-4.7.6</th>
      <td>22</td>
      <td>15</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>axon-disruptor-4.7.6</th>
      <td>22</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2b Chart 1 - 30 largest artifacts and their types stacked


    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_17_1.png)
    


### Table 2c - Largest 30 types per artifact (grouped and normalized in %)




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>languageElement</th>
      <th>Class</th>
      <th>Interface</th>
      <th>Annotation</th>
      <th>Enum</th>
    </tr>
    <tr>
      <th>artifactName</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>axon-messaging-4.7.6</th>
      <td>74.211248</td>
      <td>19.615912</td>
      <td>3.566529</td>
      <td>2.606310</td>
    </tr>
    <tr>
      <th>axon-modelling-4.7.6</th>
      <td>72.483221</td>
      <td>17.449664</td>
      <td>8.053691</td>
      <td>2.013423</td>
    </tr>
    <tr>
      <th>axon-eventsourcing-4.7.6</th>
      <td>73.846154</td>
      <td>23.846154</td>
      <td>0.769231</td>
      <td>1.538462</td>
    </tr>
    <tr>
      <th>axon-test-4.7.6</th>
      <td>81.176471</td>
      <td>18.823529</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>axon-configuration-4.7.6</th>
      <td>56.410256</td>
      <td>38.461538</td>
      <td>2.564103</td>
      <td>2.564103</td>
    </tr>
    <tr>
      <th>axon-disruptor-4.7.6</th>
      <td>100.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2c Chart 1 - Top 30 artifacts with the highest relative amount of classes in %


    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_21_1.png)
    


### Table 2c Chart 2 - Top 30 artifacts with the highest relative amount of interfaces in %


    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_23_1.png)
    


### Table 2c Chart 3 - Top 30 artifacts with the highest relative amount of enums in %


    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_25_1.png)
    


### Table 2c Chart 4 - Top 30 artifacts with the highest relative amount of annotations in %


    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_27_1.png)
    


### Table 3 - Top 30 artifacts with the highest package count

The whole table can be found in the CSV report `Number_of_packages_per_artifact`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>numberOfPackages</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.7.6</td>
      <td>61</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.7.6</td>
      <td>10</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.7.6</td>
      <td>9</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.7.6</td>
      <td>8</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.7.6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-configuration-4.7.6</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3 Chart 1 - Number of packages per artifact

The following chat shows artifacts with the largest package count in percentage. Artifacts with less than 0.7% package count are grouped into "others" to focus on the most significant artifacts regarding their package count.


    
![png](Overview_files/Overview_32_0.png)
    

