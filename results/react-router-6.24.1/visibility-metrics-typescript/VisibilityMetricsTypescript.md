# Visibility Metrics for Typescript
<br>  

### References
- [Visibility Metrics and the Importance of Hiding Things](https://dzone.com/articles/visibility-metrics-and-the-importance-of-hiding-th)
- [Calculate metrics](https://101.jqassistant.org/calculate-metrics/index.html)
- [Controlling Access to Members of a Class](https://docs.oracle.com/javase/tutorial/java/javaOO/accesscontrol.html)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)









## Relative Visibility Of Elements

A Typescript element (variable, function, class, ...) may be exported in which case it is visible and can be imported everywhere (if there are no other rules defined). If there is no "export" keyword and the element (variable, function, class, ...) is only declared, then it is only visible within the file or module.

The relative visibility is the number of inner components that are visible outside (exported) divided by the number of all components:

$$ relative visibility = \frac{exported\:elements}{all\:declared\:elements} $$

Using directories with an index file as a module and exporting only the elements (variables, function, classes, ...) that the caller of the module should use is a good way to improve encapsulation and implementation detail hiding.

### How to apply the results

The relative visibility is between zero (no element is exported) and one (all elements are exported). A value lower than one means that there are elements that are not exported. The lower the value is, the better the encapsulation and the better the implementation details are hidden. 

Non exported elements can't be accessed from another modules so they can be changed without affecting code in other modules. They clearly indicate functionality that only belongs to one modules. This also motivates to split up code into smaller pieces with a dedicated reason to change (single responsibility).

### Table 1a - Top 40 projects with lowest median of module encapsulation

This table shows the relative visibility statistics aggregated for all modules per project and focusses on projects with many modules and hardly any non-exported elements (lowest median, high visibility). Module directories with an index file and intentional exporting helps to improve encapsulation.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Global_relative_visibility_statistics_for_elements_for_Typescript`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>projectPath</th>
      <th>all</th>
      <th>exported</th>
      <th>min</th>
      <th>max</th>
      <th>average</th>
      <th>percentile25</th>
      <th>percentile50</th>
      <th>percentile75</th>
      <th>percentile90</th>
      <th>percentile95</th>
      <th>percentile99</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>6</td>
      <td>6</td>
      <td>1.000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>15</td>
      <td>12</td>
      <td>0.800</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>84</td>
      <td>41</td>
      <td>0.375</td>
      <td>0.514706</td>
      <td>0.444853</td>
      <td>0.409926</td>
      <td>0.444853</td>
      <td>0.479779</td>
      <td>0.500735</td>
      <td>0.507721</td>
      <td>0.513309</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1b - Top 40 projects with highest median of module encapsulation

This table shows the relative visibility statistics aggregated for all modules per project and focusses on project with many modules and the highest median of non-exported elements (variables, functions, classes, ...) (low visibility). Module directories with an index file and intentional exporting helps to improve encapsulation.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Global_relative_visibility_statistics_for_elements_for_Typescript`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>projectPath</th>
      <th>all</th>
      <th>exported</th>
      <th>min</th>
      <th>max</th>
      <th>average</th>
      <th>percentile25</th>
      <th>percentile50</th>
      <th>percentile75</th>
      <th>percentile90</th>
      <th>percentile95</th>
      <th>percentile99</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>84</td>
      <td>41</td>
      <td>0.375</td>
      <td>0.514706</td>
      <td>0.444853</td>
      <td>0.409926</td>
      <td>0.444853</td>
      <td>0.479779</td>
      <td>0.500735</td>
      <td>0.507721</td>
      <td>0.513309</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>15</td>
      <td>12</td>
      <td>0.800</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
      <td>0.800000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>6</td>
      <td>6</td>
      <td>1.000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1 Chart 1 - Relative visibility in projects

    /home/runner/miniconda3/envs/codegraph/lib/python3.11/site-packages/pandas/plotting/_matplotlib/core.py:1259: UserWarning: No data for colormapping provided via 'c'. Parameters 'cmap' will be ignored
      scatter = ax.scatter(



    <Figure size 640x480 with 0 Axes>



    
![png](VisibilityMetricsTypescript_files/VisibilityMetricsTypescript_17_2.png)
    


### Table 2a - Top 40 modules with the highest visibility and lowest encapsulation

This table shows the relative visibility statistics per module and project and focusses on modules with many elements (variables, functions, classes, ...), hardly any non-exported ones and therefore the highest relative visibility (lowest encapsulation). Module directories with an index file and intentional exporting helps to improve encapsulation.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Relative_visibility_exported_elements_to_all_elements_per_module_for_Typescript`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>projectPath</th>
      <th>modulePath</th>
      <th>moduleName</th>
      <th>exportedElements</th>
      <th>allElements</th>
      <th>relativeVisibility</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>index.ts</td>
      <td>react-router</td>
      <td>6</td>
      <td>6</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>index.tsx</td>
      <td>react-router-native</td>
      <td>13</td>
      <td>15</td>
      <td>0.866667</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>index.tsx</td>
      <td>react-router-dom</td>
      <td>35</td>
      <td>68</td>
      <td>0.514706</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server.tsx</td>
      <td>server</td>
      <td>6</td>
      <td>16</td>
      <td>0.375000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2b - Top 40 modules with the lowest visibility and highest encapsulation

This table shows the relative visibility statistics per modules and project and focusses on modules with many elements (variables, functions, classes, ...), many non-exported ones and therefore the lowest relative visibility (highest encapsulation). Non-exported elements help to improve encapsulation. Zero percent visibility and therefore modules with no exported elements are suspicious to contain dead code.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Relative_visibility_public_types_to_all_types_per_package`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>projectPath</th>
      <th>modulePath</th>
      <th>moduleName</th>
      <th>exportedElements</th>
      <th>allElements</th>
      <th>relativeVisibility</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>server.tsx</td>
      <td>server</td>
      <td>6</td>
      <td>16</td>
      <td>0.375000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>index.tsx</td>
      <td>react-router-dom</td>
      <td>35</td>
      <td>68</td>
      <td>0.514706</td>
    </tr>
    <tr>
      <th>2</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>index.tsx</td>
      <td>react-router-native</td>
      <td>13</td>
      <td>15</td>
      <td>0.866667</td>
    </tr>
    <tr>
      <th>3</th>
      <td>/home/runner/work/code-graph-analysis-pipeline...</td>
      <td>index.ts</td>
      <td>react-router</td>
      <td>6</td>
      <td>6</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2 Chart 1 - Relative visibility of modules

    /home/runner/miniconda3/envs/codegraph/lib/python3.11/site-packages/pandas/plotting/_matplotlib/core.py:1259: UserWarning: No data for colormapping provided via 'c'. Parameters 'cmap' will be ignored
      scatter = ax.scatter(



    <Figure size 640x480 with 0 Axes>



    
![png](VisibilityMetricsTypescript_files/VisibilityMetricsTypescript_24_2.png)
    

