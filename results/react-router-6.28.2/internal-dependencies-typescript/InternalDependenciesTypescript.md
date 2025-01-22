# Internal Dependencies
<br>  

### References
- [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html)
- [Calculate metrics](https://101.jqassistant.org/calculate-metrics/index.html)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)





## 1 - Modules

List the modules this notebook is based on. Different sorting variations help finding modules by their features and support larger code bases where the list of all modules gets very long.

Only the top 30 entries are shown. The whole table can be found in the following CSV report:  
`List_all_Typescript_modules`

### Table 1a - Top 30 modules with the highest element count




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>rootProjectName</th>
      <th>moduleName</th>
      <th>numberOfElements</th>
      <th>numberOfGitCommits</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-6.28.2</td>
      <td>react-router-dom</td>
      <td>63</td>
      <td>423</td>
      <td>26</td>
      <td>312</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-6.28.2</td>
      <td>react-router-native</td>
      <td>17</td>
      <td>154</td>
      <td>10</td>
      <td>48</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-6.28.2</td>
      <td>react-router</td>
      <td>7</td>
      <td>250</td>
      <td>0</td>
      <td>34</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-6.28.2</td>
      <td>todos</td>
      <td>7</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router-6.28.2</td>
      <td>server</td>
      <td>6</td>
      <td>164</td>
      <td>0</td>
      <td>78</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router-6.28.2</td>
      <td>snkrs</td>
      <td>4</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>react-router-6.28.2</td>
      <td>data</td>
      <td>3</td>
      <td>8</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>react-router-6.28.2</td>
      <td>App</td>
      <td>1</td>
      <td>6</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>10</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1b - Top 30 modules with the highest number of incoming dependencies

The following table lists the top 30 internal modules that are used the most by other modules (highest count of incoming dependencies, highest in-degree).




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>rootProjectName</th>
      <th>moduleName</th>
      <th>numberOfElements</th>
      <th>numberOfGitCommits</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-6.28.2</td>
      <td>react-router-dom</td>
      <td>63</td>
      <td>423</td>
      <td>26</td>
      <td>312</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-6.28.2</td>
      <td>react-router-native</td>
      <td>17</td>
      <td>154</td>
      <td>10</td>
      <td>48</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-6.28.2</td>
      <td>App</td>
      <td>1</td>
      <td>6</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router-6.28.2</td>
      <td>data</td>
      <td>3</td>
      <td>8</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>react-router-6.28.2</td>
      <td>react-router</td>
      <td>7</td>
      <td>250</td>
      <td>0</td>
      <td>34</td>
    </tr>
    <tr>
      <th>9</th>
      <td>react-router-6.28.2</td>
      <td>server</td>
      <td>6</td>
      <td>164</td>
      <td>0</td>
      <td>78</td>
    </tr>
    <tr>
      <th>10</th>
      <td>react-router-6.28.2</td>
      <td>snkrs</td>
      <td>4</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>react-router-6.28.2</td>
      <td>todos</td>
      <td>7</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1c - Top 30 modules with the highest number of outgoing dependencies

The following table lists the top 30 internal modules that are depending on the highest number of other modules (highest count of outgoing dependencies, highest out-degree).




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>rootProjectName</th>
      <th>moduleName</th>
      <th>numberOfElements</th>
      <th>numberOfGitCommits</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-6.28.2</td>
      <td>react-router-dom</td>
      <td>63</td>
      <td>423</td>
      <td>26</td>
      <td>312</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-6.28.2</td>
      <td>server</td>
      <td>6</td>
      <td>164</td>
      <td>0</td>
      <td>78</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-6.28.2</td>
      <td>react-router-native</td>
      <td>17</td>
      <td>154</td>
      <td>10</td>
      <td>48</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-6.28.2</td>
      <td>react-router</td>
      <td>7</td>
      <td>250</td>
      <td>0</td>
      <td>34</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router-6.28.2</td>
      <td>App</td>
      <td>1</td>
      <td>6</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>react-router-6.28.2</td>
      <td>data</td>
      <td>3</td>
      <td>8</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>react-router-6.28.2</td>
      <td>snkrs</td>
      <td>4</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>react-router-6.28.2</td>
      <td>todos</td>
      <td>7</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1d - Top 30 modules with the lowest element count




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>rootProjectName</th>
      <th>moduleName</th>
      <th>numberOfElements</th>
      <th>numberOfGitCommits</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-6.28.2</td>
      <td>App</td>
      <td>1</td>
      <td>6</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router-6.28.2</td>
      <td>data</td>
      <td>3</td>
      <td>8</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>react-router-6.28.2</td>
      <td>snkrs</td>
      <td>4</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>react-router-6.28.2</td>
      <td>server</td>
      <td>6</td>
      <td>164</td>
      <td>0</td>
      <td>78</td>
    </tr>
    <tr>
      <th>8</th>
      <td>react-router-6.28.2</td>
      <td>react-router</td>
      <td>7</td>
      <td>250</td>
      <td>0</td>
      <td>34</td>
    </tr>
    <tr>
      <th>9</th>
      <td>react-router-6.28.2</td>
      <td>todos</td>
      <td>7</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>react-router-6.28.2</td>
      <td>react-router-native</td>
      <td>17</td>
      <td>154</td>
      <td>10</td>
      <td>48</td>
    </tr>
    <tr>
      <th>11</th>
      <td>react-router-6.28.2</td>
      <td>react-router-dom</td>
      <td>63</td>
      <td>423</td>
      <td>26</td>
      <td>312</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1e - Top 30 modules with the lowest number of incoming dependencies

The following table lists the top 30 internal modules that are used the least by other modules (lowest count of incoming dependencies, lowest in-degree).




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>rootProjectName</th>
      <th>moduleName</th>
      <th>numberOfElements</th>
      <th>numberOfGitCommits</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-6.28.2</td>
      <td>App</td>
      <td>1</td>
      <td>6</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-6.28.2</td>
      <td>data</td>
      <td>3</td>
      <td>8</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>react-router-6.28.2</td>
      <td>react-router</td>
      <td>7</td>
      <td>250</td>
      <td>0</td>
      <td>34</td>
    </tr>
    <tr>
      <th>7</th>
      <td>react-router-6.28.2</td>
      <td>server</td>
      <td>6</td>
      <td>164</td>
      <td>0</td>
      <td>78</td>
    </tr>
    <tr>
      <th>8</th>
      <td>react-router-6.28.2</td>
      <td>snkrs</td>
      <td>4</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>react-router-6.28.2</td>
      <td>todos</td>
      <td>7</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>react-router-6.28.2</td>
      <td>react-router-native</td>
      <td>17</td>
      <td>154</td>
      <td>10</td>
      <td>48</td>
    </tr>
    <tr>
      <th>11</th>
      <td>react-router-6.28.2</td>
      <td>react-router-dom</td>
      <td>63</td>
      <td>423</td>
      <td>26</td>
      <td>312</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1f - Top 30 modules with the lowest number of outgoing dependencies

The following table lists the top 30 internal modules that are depending on the lowest number of other modules (lowest count of outgoing dependencies, lowest out-degree).




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>rootProjectName</th>
      <th>moduleName</th>
      <th>numberOfElements</th>
      <th>numberOfGitCommits</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-6.28.2</td>
      <td>auth</td>
      <td>1</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-6.28.2</td>
      <td>data</td>
      <td>3</td>
      <td>8</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router-6.28.2</td>
      <td>images</td>
      <td>2</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router-6.28.2</td>
      <td>snkrs</td>
      <td>4</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>react-router-6.28.2</td>
      <td>todos</td>
      <td>7</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>react-router-6.28.2</td>
      <td>App</td>
      <td>1</td>
      <td>6</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>react-router-6.28.2</td>
      <td>react-router</td>
      <td>7</td>
      <td>250</td>
      <td>0</td>
      <td>34</td>
    </tr>
    <tr>
      <th>9</th>
      <td>react-router-6.28.2</td>
      <td>react-router-native</td>
      <td>17</td>
      <td>154</td>
      <td>10</td>
      <td>48</td>
    </tr>
    <tr>
      <th>10</th>
      <td>react-router-6.28.2</td>
      <td>server</td>
      <td>6</td>
      <td>164</td>
      <td>0</td>
      <td>78</td>
    </tr>
    <tr>
      <th>11</th>
      <td>react-router-6.28.2</td>
      <td>react-router-dom</td>
      <td>63</td>
      <td>423</td>
      <td>26</td>
      <td>312</td>
    </tr>
  </tbody>
</table>
</div>



## 2 - Cyclic Dependencies

Cyclic dependencies occur when one module uses an elements of another module and vice versa. 
These dependencies can lead to problems when one of these modules needs to be changed.

### Table 2a - Cyclic Dependencies Overview

Show the top 40 cyclic dependencies sorted by the most promising to resolve first. This is done by calculating the number of forward dependencies (first cycle participant to second cycle participant) in relation to backward dependencies (second cycle participant back to first cycle participant). The higher this rate (approaching 1), the easier it should be to resolve the cycle by focussing on the few backward dependencies.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Cyclic_Dependencies_for_Typescript`

**Columns:**
- *projectFileName* identifies the project of the first participant of the cycle
- *modulePathName* identifies the module of the first participant of the cycle
- *dependentProjectFileName* identifies the project of the second participant of the cycle
- *dependentModulePathName* identifies the module of the second participant of the cycle
- *forwardToBackwardBalance* is between 0 and 1. High for many forward and few backward dependencies.
- *numberForward* contains the number of dependencies from the first participant of the cycle to the second one
- *numberBackward* contains the number of dependencies from the second participant of the cycle back to the first one
- *someForwardDependencies* lists some forward dependencies in the text format "type1 -> type2"
- *backwardDependencies* lists the backward dependencies in the format "type1 <- type2" that are recommended to get resolved




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>projectFileName</th>
      <th>moduleName</th>
      <th>dependentProjectFileName</th>
      <th>dependentModulePathName</th>
      <th>forwardToBackwardBalance</th>
      <th>numberForward</th>
      <th>numberBackward</th>
      <th>forwardDependencyExamples</th>
      <th>backwardDependencyExamples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
      <td>[useFormAction-&gt;useLocation, useLinkClickHandler-&gt;useLocation, NavLink-&gt;useLocation, useScrollRestoration-&gt;useLocation, useSearchParams-&gt;useLocation, SetURLSearchParams-&gt;NavigateOptions, LinkProps-&gt;To, useLinkClickHandler-&gt;To, useViewTransitionState-&gt;To]</td>
      <td>[To&lt;-LinkProps, NavigateOptions&lt;-SetURLSearchParams, useNavigate&lt;-useSearchParams, useLocation&lt;-useSearchParams, useNavigate&lt;-useDeepLinking, useNavigate&lt;-useLinkPressHandler, To&lt;-useLinkPressHandler]</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2b - Cyclic Dependencies Break Down

Lists modules with cyclic dependencies with every dependency in a separate row sorted by the most promising dependency first.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Cyclic_Dependencies_Breakdown_for_Typescript`

**Columns in addition to Table 2a:**
- *dependency* shows the cycle dependency in the text format "type1 -> type2" (forward) or "type2<-type1" (backward)




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>projectFileName</th>
      <th>moduleName</th>
      <th>dependentProjectFileName</th>
      <th>dependentModulePathName</th>
      <th>dependency</th>
      <th>forwardToBackwardBalance</th>
      <th>numberForward</th>
      <th>numberBackward</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>To&lt;-LinkProps</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>NavigateOptions&lt;-SetURLSearchParams</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useNavigate&lt;-useSearchParams</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useLocation&lt;-useSearchParams</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useNavigate&lt;-useDeepLinking</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useNavigate&lt;-useLinkPressHandler</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>6</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>To&lt;-useLinkPressHandler</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>7</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useFormAction-&gt;useLocation</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useLinkClickHandler-&gt;useLocation</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>9</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>NavLink-&gt;useLocation</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>10</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useScrollRestoration-&gt;useLocation</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>11</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useSearchParams-&gt;useLocation</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>12</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>SetURLSearchParams-&gt;NavigateOptions</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>13</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>LinkProps-&gt;To</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>14</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useLinkClickHandler-&gt;To</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>15</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useViewTransitionState-&gt;To</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>16</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useLinkClickHandler-&gt;useNavigate</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>17</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useSearchParams-&gt;useNavigate</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2c - Cyclic Dependencies Break Down - Backward Dependencies Only

Lists modules with cyclic dependencies with every dependency in a separate row sorted by the most promising  dependency first. This table only contains the backward dependencies from the second participant of the cycle back to the first one that are the most promising to resolve.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Cyclic_Dependencies_Breakdown_BackwardOnly_for_Typescript`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>projectFileName</th>
      <th>moduleName</th>
      <th>dependentProjectFileName</th>
      <th>dependentModulePathName</th>
      <th>dependency</th>
      <th>forwardToBackwardBalance</th>
      <th>numberForward</th>
      <th>numberBackward</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>To&lt;-LinkProps</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>NavigateOptions&lt;-SetURLSearchParams</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useNavigate&lt;-useSearchParams</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useLocation&lt;-useSearchParams</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useNavigate&lt;-useDeepLinking</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>useNavigate&lt;-useLinkPressHandler</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
    <tr>
      <th>6</th>
      <td>react-router-dom</td>
      <td>./index.tsx</td>
      <td>react-router-native</td>
      <td>./index.tsx</td>
      <td>To&lt;-useLinkPressHandler</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
</div>



## 3 - Module Usage

### Table 3a - Elements that are used by multiple modules

This table shows the top 40 modules that are used by the highest number of different modules. The whole table can be found in the CSV report `WidelyUsedTypescriptElements`.





<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>fullQualifiedDependentElementName</th>
      <th>dependentElementModuleName</th>
      <th>dependentElementName</th>
      <th>dependentElementLabels</th>
      <th>numberOfUsingModules</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>"@remix-run/router".NavigateOptions</td>
      <td>router</td>
      <td>NavigateOptions</td>
      <td>ExternalDeclaration</td>
      <td>2</td>
    </tr>
    <tr>
      <th>1</th>
      <td>"@remix-run/router".Router</td>
      <td>router</td>
      <td>Router</td>
      <td>ExternalDeclaration</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>"@remix-run/router".To</td>
      <td>router</td>
      <td>To</td>
      <td>ExternalDeclaration</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>"@remix-run/router".useLocation</td>
      <td>router</td>
      <td>useLocation</td>
      <td>ExternalDeclaration</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>"@remix-run/router".useNavigate</td>
      <td>router</td>
      <td>useNavigate</td>
      <td>ExternalDeclaration</td>
      <td>2</td>
    </tr>
    <tr>
      <th>5</th>
      <td>"@remix-run/router".DataStrategyFunction</td>
      <td>router</td>
      <td>DataStrategyFunction</td>
      <td>ExternalDeclaration</td>
      <td>1</td>
    </tr>
    <tr>
      <th>6</th>
      <td>"@remix-run/router".RouteObject</td>
      <td>router</td>
      <td>RouteObject</td>
      <td>ExternalDeclaration</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>"@remix-run/router".RouteObject</td>
      <td>router</td>
      <td>RouteObject</td>
      <td>ExternalDeclaration</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>"@remix-run/router".Router</td>
      <td>router</td>
      <td>Router</td>
      <td>ExternalDeclaration</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3b - Elements that are used by multiple modules

This table shows the top 30 modules that only use a few (compared to all existing) elements of another module.
The whole table can be found in the CSV report `ModuleElementsUsageTypescript`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>sourceModuleName</th>
      <th>dependentModuleName</th>
      <th>dependentElementsCount</th>
      <th>dependentModuleElementsCount</th>
      <th>elementUsagePercentage</th>
      <th>dependentElementFullNameExamples</th>
      <th>dependentElementNameExamples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>server</td>
      <td>react-router-dom</td>
      <td>2</td>
      <td>63</td>
      <td>0.031746</td>
      <td>["@remix-run/router".RouteObject, "@remix-run/router".Router]</td>
      <td>[RouteObject, Router]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router</td>
      <td>react-router-dom</td>
      <td>2</td>
      <td>63</td>
      <td>0.031746</td>
      <td>["@remix-run/router".Router, "@remix-run/router".DataStrategyFunction]</td>
      <td>[Router, DataStrategyFunction]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-native</td>
      <td>react-router-dom</td>
      <td>4</td>
      <td>63</td>
      <td>0.063492</td>
      <td>["@remix-run/router".useNavigate, "@remix-run/router".useLocation, "@remix-run/router".NavigateOptions, "@remix-run/router".To]</td>
      <td>[useNavigate, useLocation, NavigateOptions, To]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-dom</td>
      <td>react-router-native</td>
      <td>4</td>
      <td>17</td>
      <td>0.235294</td>
      <td>["@remix-run/router".useLocation, "@remix-run/router".NavigateOptions, "@remix-run/router".To, "@remix-run/router".useNavigate]</td>
      <td>[useLocation, NavigateOptions, To, useNavigate]</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3c - Distance distribution between dependent files

This table shows the file directory distance distribution between dependent files. Intuitively, the distance is given by the fewest number of change directory commands needed to navigate between a file and a dependency it uses. Those are aggregate to see how many dependent files are in the same directory, how many are just one change directory command apart, and so on.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>dependency.fileDistanceAsFewestChangeDirectoryCommands</th>
      <th>numberOfDependencies</th>
      <th>numberOfDependencyUsers</th>
      <th>numberOfDependencyProviders</th>
      <th>examples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>[./server.tsx uses ./index.tsx]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4</td>
      <td>4</td>
      <td>4</td>
      <td>2</td>
      <td>[./index.ts uses ./index.tsx, ./index.tsx uses ./index.tsx, ./index.tsx uses ./index.tsx, ./server.tsx uses ./index.tsx]</td>
    </tr>
  </tbody>
</table>
</div>


