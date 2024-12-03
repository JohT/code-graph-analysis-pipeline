# Overview for Typescript

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
      <th>projectCount</th>
      <th>moduleCount</th>
      <th>functionCount</th>
      <th>objectCount</th>
      <th>typeAliasCount</th>
      <th>interfaceCount</th>
      <th>classCount</th>
      <th>methodCount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>103640</td>
      <td>309538</td>
      <td>6</td>
      <td>6</td>
      <td>85</td>
      <td>42</td>
      <td>16</td>
      <td>17</td>
      <td>1</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



## Modules

### Table 2a - Largest 30 elements per module

This table shows the largest (number of elements) modules and their kind of elements (Interface, TypeAlias, Variable).
The whole table can be found in the CSV report `Number_of_elements_per_module_for_Typescript`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>moduleName</th>
      <th>modulePath</th>
      <th>numberOfModuleElements</th>
      <th>languageElement</th>
      <th>numberOfElements</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-dom</td>
      <td>index.tsx</td>
      <td>35</td>
      <td>TypeAlias</td>
      <td>3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-dom</td>
      <td>index.tsx</td>
      <td>35</td>
      <td>Interface</td>
      <td>10</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-dom</td>
      <td>index.tsx</td>
      <td>35</td>
      <td>Function</td>
      <td>17</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-dom</td>
      <td>index.tsx</td>
      <td>35</td>
      <td>Variable</td>
      <td>5</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router-native</td>
      <td>index.tsx</td>
      <td>12</td>
      <td>TypeAlias</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router-native</td>
      <td>index.tsx</td>
      <td>12</td>
      <td>Function</td>
      <td>7</td>
    </tr>
    <tr>
      <th>6</th>
      <td>react-router-native</td>
      <td>index.tsx</td>
      <td>12</td>
      <td>Interface</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7</th>
      <td>react-router</td>
      <td>index.ts</td>
      <td>7</td>
      <td>TypeAlias</td>
      <td>5</td>
    </tr>
    <tr>
      <th>8</th>
      <td>react-router</td>
      <td>index.ts</td>
      <td>7</td>
      <td>Function</td>
      <td>2</td>
    </tr>
    <tr>
      <th>9</th>
      <td>server</td>
      <td>server.tsx</td>
      <td>6</td>
      <td>Interface</td>
      <td>2</td>
    </tr>
    <tr>
      <th>10</th>
      <td>server</td>
      <td>server.tsx</td>
      <td>6</td>
      <td>Function</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2b - Largest 30 elements per module grouped

This table shows the largest (number of elements) modules each in one row, their kind of elements in columns and the count of them as values.

The source data for this aggregated table can be found in the CSV report `Number_of_elements_per_module_for_Typescript`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>languageElement</th>
      <th>modulePath</th>
      <th>moduleName</th>
      <th>Function</th>
      <th>Interface</th>
      <th>TypeAlias</th>
      <th>Variable</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>index.tsx</td>
      <td>react-router-dom</td>
      <td>17</td>
      <td>10</td>
      <td>3</td>
      <td>5</td>
    </tr>
    <tr>
      <th>1</th>
      <td>index.tsx</td>
      <td>react-router-native</td>
      <td>7</td>
      <td>2</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>index.ts</td>
      <td>react-router</td>
      <td>2</td>
      <td>0</td>
      <td>5</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>server.tsx</td>
      <td>server</td>
      <td>4</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2b Chart 1 - 30 largest modules and their elements stacked


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewTypescript_files/OverviewTypescript_17_1.png)
    


### Table 2c - 30 highest element count per module (grouped and normalized in %)




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>languageElement</th>
      <th>modulePath</th>
      <th>moduleName</th>
      <th>Function</th>
      <th>Interface</th>
      <th>TypeAlias</th>
      <th>Variable</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>index.tsx</td>
      <td>react-router-dom</td>
      <td>48.571429</td>
      <td>28.571429</td>
      <td>8.571429</td>
      <td>14.285714</td>
    </tr>
    <tr>
      <th>1</th>
      <td>index.tsx</td>
      <td>react-router-native</td>
      <td>58.333333</td>
      <td>16.666667</td>
      <td>25.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>index.ts</td>
      <td>react-router</td>
      <td>28.571429</td>
      <td>0.000000</td>
      <td>71.428571</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>server.tsx</td>
      <td>server</td>
      <td>66.666667</td>
      <td>33.333333</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2c Chart 1 - Top 30 modules with the highest relative amount of type aliases in %


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewTypescript_files/OverviewTypescript_21_1.png)
    


### Table 2c Chart 2 - Top 30 module with the highest relative amount of interfaces in %


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewTypescript_files/OverviewTypescript_23_1.png)
    


### Table 2c Chart 3 - Top 30 modules with the highest relative amount of variables in %


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewTypescript_files/OverviewTypescript_25_1.png)
    


### Table 2c Chart 4 - Top 30 modules with the highest relative amount of functions in %


    <Figure size 640x480 with 0 Axes>



    
![png](OverviewTypescript_files/OverviewTypescript_27_1.png)
    

