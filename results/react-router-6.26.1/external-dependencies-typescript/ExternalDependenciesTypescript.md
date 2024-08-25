# External Dependencies
<br>  

### References
- [jqassistant](https://jqassistant.org)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)





## External Typescript Module Usage

### External Module

An external Typescript module is marked with the label `ExternalModule` and the declarations it provides with  `ExternalDeclaration`. In practice, the distinction between internal and external isn't always that clear. When there is a problem following the project configuration like discussed in [Missing Interfaces and other elements in the Graph](https://github.com/jqassistant-plugin/jqassistant-typescript-plugin/issues/35), some internal dependencies might be imported as external ones. 

To have a second indicator, the property `isNodeModule` is written with [Add_module_properties.cypher](./../cypher/Typescript_Enrichment/Add_module_properties.cypher) in [prepareAnalysis.sh](./../scripts/prepareAnalysis.sh). For most package managers this should then be sufficient. As of now (June 2024), it might not work with [Yarn Plug'n'Play](https://yarnpkg.com/features/pnp).

### Table 1 - Top 20 most used external packages overall

This table shows the external packages that are used by the most different internal types overall.
Additionally, it shows which types of the external modules are actually used. External annotations are also listed.

Only the top 20 entries are shown. The whole table can be found in the following CSV report:
`External_module_usage_overall_for_Typescript`

**Columns:**
- *externalModuleName* is the name of the external module prepended by its namespace if given. Example: "@types/react"
- *numberOfExternalCallerModules* is the number of modules that use that external module
- *numberOfExternalCallerElements* is the number of elements (functions, classes,...) that use that external module
- *numberOfExternalDeclarationCalls* is how often the external declarations of that external module are imported
- *numberOfExternalDeclarationCallsWeighted* is how often the external declarations of that external module are actually used
- *allModules* contains the total count of all analyzed internal modules
- *allInternalElements* contains the total count of all analyzed exported internal elements (function, classes,...)
- *exampleStories* contains a list of sentences that contain concrete examples (for explanation and debugging)




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalModuleName</th>
      <th>numberOfExternalCallerModules</th>
      <th>numberOfExternalCallerElements</th>
      <th>numberOfExternalDeclarationCalls</th>
      <th>numberOfExternalDeclarationCallsWeighted</th>
      <th>allModules</th>
      <th>allInternalElements</th>
      <th>exampleStories</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@types/react</td>
      <td>4</td>
      <td>34</td>
      <td>94</td>
      <td>145</td>
      <td>4</td>
      <td>59</td>
      <td>[&lt;mapRouteProperties&gt; of module &lt;react-router&gt;...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@types/react-native</td>
      <td>1</td>
      <td>5</td>
      <td>14</td>
      <td>18</td>
      <td>4</td>
      <td>59</td>
      <td>[&lt;useHardwareBackButton&gt; of module &lt;react-rout...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>@ungap/url-search-params</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>2</td>
      <td>4</td>
      <td>59</td>
      <td>[&lt;createSearchParams&gt; of module &lt;react-router-...</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 1 Chart 1 - Most called external modules in % by internal elements

External modules that are used less than 0.7% are grouped into "others" to get a cleaner chart
containing the most significant external modules and how ofter they are called by internal elements in percent.


    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_14_0.png)
    


#### Table 1 Chart 2 - Most called external modules in % by internal modules

External modules that are used less than 0.7% are grouped into "others" to get a cleaner chart
containing the most significant external modules and how ofter they are called by internal modules in percent.


    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_17_0.png)
    


### Table 2 - Top 20 most used external namespaces

This table shows external namespaces that are used by the most different internal elements (functions, classes,...) overall. 

Additionally, it shows how many of the declarations of the external namespace are actually used.

Only the top 20 entries are shown. The whole table can be found in the following CSV report:
`External_namespace_usage_overall_for_Typescript`

**Columns:**
- *externalNamespaceName* is the name of the external namespace (empty if none). Example: "@types". All other columns are aggregated/grouped by it.
- *numberOfExternalCallerModules* is the number of modules that use that external module
- *numberOfExternalCallerElements* is the number of elements (functions, classes,...) that use that external module
- *numberOfExternalDeclarationCalls* is how often the external declarations of that external module are imported
- *numberOfExternalDeclarationCallsWeighted* is how often the external declarations of that external module are actually used
- *allModules* contains the total count of all analyzed internal modules
- *allInternalElements* contains the total count of all analyzed exported internal elements (function, classes,...)
- *exampleStories* contains a list of sentences that contain concrete examples (for explanation and debugging)




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalNamespaceName</th>
      <th>numberOfExternalCallerModules</th>
      <th>numberOfExternalCallerElements</th>
      <th>numberOfExternalDeclarationCalls</th>
      <th>numberOfExternalDeclarationCallsWeighted</th>
      <th>allModules</th>
      <th>allInternalElements</th>
      <th>exampleStories</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@types</td>
      <td>4</td>
      <td>35</td>
      <td>108</td>
      <td>163</td>
      <td>4</td>
      <td>59</td>
      <td>[&lt;mapRouteProperties&gt; of module &lt;react-router&gt;...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@ungap</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>2</td>
      <td>4</td>
      <td>59</td>
      <td>[&lt;createSearchParams&gt; of module &lt;react-router-...</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 2 Chart 1 - Most called external namespaces in % by internal element

External namespaces that are used less than 0.7% are grouped into "others" to get a cleaner chart
containing the most significant external namespaces and how ofter they are called by internal elements in percent.


    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_21_0.png)
    


#### Table 2 Chart 2 - Most called external namespaces in % by internal modules

External namespaces that are used less than 0.7% are grouped into "others" to get a cleaner chart
containing the most significant external namespaces and how ofter they are called by internal modules in percent.


    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_23_0.png)
    


### Table 3 - Top 20 most widely spread external modules

The following tables shows external modules that are used by many different internal modules with the highest number of artifacts first.

Statistics like minimum, maximum, average, median and standard deviation are provided for the number of internally exported elements (function, class, ...) and the external declarations they use for every external module. 

The intuition behind that is to find external modules and the external declarations they provide that are used in a widely spread manner. This can help to distinguish widely used libraries and frameworks from external modules that are used for specific tasks. It can also be used to find external modules that are used sparsely regarding internal modules but where many different external declarations are used. 

Refactoring with [Hexagonal architecture](https://alistair.cockburn.us/hexagonal-architecture) in mind can be considered for non-framework external modules that are used for very specific tasks and that are used in many different internal locations. This makes the internal code more robust against changes of these external modules or it is easier to update and migrate to newer versions of them. 

External modules that are only used in very few internal locations overall might be considered for removal if they are easy to replace with a similar library that is already used more often. Or they might also simply be replaced by very few lines of code. Replacing libraries with own code isn't recommended when you need to write a lot of code or for external modules that provide security relevant implementations (encryption, sanitizers, ...), because they will be tracked and maintained globally and security updates need to be adopted fast.

Only the top 20 entries are shown. The whole table can be found in the following CSV report:
`External_module_usage_spread_for_Typescript`

**Columns:**
- *externalModuleName* is the name of the external package prepended by its namespace if given. Example: "@types/react"
external package.
- *numberOfInternalModules* is the number of internal modules that are using that external module
- *\[min,max,med,avg,std\]NumberOfUsedExternalDeclarations* provide statistics for all internal modules and how their usage of the declarations provided by the external module are distributed. This provides an indicator on how strong the coupling to the external module is. For example, if many (high sum) elements provided by that external module are used constantly (low std), a higher coupling can be presumed. If there is only one (sum) element in use, this could be an indicator for an external module that could get replaced or that there is just one central entry point for it.
- *\[min/max/med/avg/std\]NumberOfInternalElements* provide statistics for all internal modules and how their usage of the external module is distributed across their internal elements. This provides an indicator on how widely an external module is spread across internal elements and if there are great differences between internal modules (high standard deviation) or not.
- *\[min/max/med/avg/std\]NumberOfInternalElementsPercentage* is similar to [min/max/med/avg/std]NumberOfUsedExternalDeclarations but provides the value in percent in relation to the total number of internal elements per internal module.
- *internalModuleExamples* some examples of included internal modules for debugging




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalModuleName</th>
      <th>numberOfInternalModules</th>
      <th>sumNumberOfUsedExternalDeclarations</th>
      <th>minNumberOfUsedExternalDeclarations</th>
      <th>maxNumberOfUsedExternalDeclarations</th>
      <th>medNumberOfUsedExternalDeclarations</th>
      <th>avgNumberOfUsedExternalDeclarations</th>
      <th>stdNumberOfUsedExternalDeclarations</th>
      <th>sumNumberOfInternalElements</th>
      <th>minNumberOfInternalElements</th>
      <th>maxNumberOfInternalElements</th>
      <th>medNumberOfInternalElements</th>
      <th>avgNumberOfInternalElements</th>
      <th>stdNumberOfInternalElements</th>
      <th>minNumberOfInternalElementsPercentage</th>
      <th>maxNumberOfInternalElementsPercentage</th>
      <th>medNumberOfInternalElementsPercentage</th>
      <th>avgNumberOfInternalElementsPercentage</th>
      <th>stdNumberOfInternalElementsPercentage</th>
      <th>internalModuleExamples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@types/react</td>
      <td>4</td>
      <td>37</td>
      <td>1</td>
      <td>27</td>
      <td>4.5</td>
      <td>9.25</td>
      <td>12.120919</td>
      <td>34</td>
      <td>1</td>
      <td>24</td>
      <td>4.5</td>
      <td>8.5</td>
      <td>10.535654</td>
      <td>25.0</td>
      <td>600.0</td>
      <td>112.5</td>
      <td>212.5</td>
      <td>263.391344</td>
      <td>[react-router, react-router-dom, server, react...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@types/react-native</td>
      <td>1</td>
      <td>10</td>
      <td>10</td>
      <td>10</td>
      <td>10.0</td>
      <td>10.00</td>
      <td>0.000000</td>
      <td>5</td>
      <td>5</td>
      <td>5</td>
      <td>5.0</td>
      <td>5.0</td>
      <td>0.000000</td>
      <td>125.0</td>
      <td>125.0</td>
      <td>125.0</td>
      <td>125.0</td>
      <td>0.000000</td>
      <td>[react-router-native]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>@ungap/url-search-params</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.00</td>
      <td>0.000000</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>0.000000</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>0.000000</td>
      <td>[react-router-native]</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3a - Top 20 most widely spread external packages - number of internal modules

This table shows the top 20 most widely spread external packages focussing on the spread across the number of internal modules.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalModuleName</th>
      <th>numberOfInternalModules</th>
      <th>minNumberOfInternalElements</th>
      <th>maxNumberOfInternalElements</th>
      <th>medNumberOfInternalElements</th>
      <th>avgNumberOfInternalElements</th>
      <th>stdNumberOfInternalElements</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@types/react</td>
      <td>4</td>
      <td>1</td>
      <td>24</td>
      <td>4.5</td>
      <td>8.5</td>
      <td>10.535654</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@types/react-native</td>
      <td>1</td>
      <td>5</td>
      <td>5</td>
      <td>5.0</td>
      <td>5.0</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>@ungap/url-search-params</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3b - Top 20 most widely spread external packages - percentage of internal modules

This table shows the top 20 most widely spread external packages focussing on the spread across the percentage of internal modules.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalModuleName</th>
      <th>numberOfInternalModules</th>
      <th>minNumberOfInternalElementsPercentage</th>
      <th>maxNumberOfInternalElementsPercentage</th>
      <th>medNumberOfInternalElementsPercentage</th>
      <th>avgNumberOfInternalElementsPercentage</th>
      <th>stdNumberOfInternalElementsPercentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@types/react</td>
      <td>4</td>
      <td>25.0</td>
      <td>600.0</td>
      <td>112.5</td>
      <td>212.5</td>
      <td>263.391344</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@types/react-native</td>
      <td>1</td>
      <td>125.0</td>
      <td>125.0</td>
      <td>125.0</td>
      <td>125.0</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>@ungap/url-search-params</td>
      <td>1</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3c - Top 20 most widely spread external packages - number of internal elements

This table shows the top 20 most widely spread external packages focussing on the spread across the number of internal elements.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalModuleName</th>
      <th>numberOfInternalModules</th>
      <th>minNumberOfInternalElements</th>
      <th>maxNumberOfInternalElements</th>
      <th>medNumberOfInternalElements</th>
      <th>avgNumberOfInternalElements</th>
      <th>stdNumberOfInternalElements</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@types/react</td>
      <td>4</td>
      <td>1</td>
      <td>24</td>
      <td>4.5</td>
      <td>8.5</td>
      <td>10.535654</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@types/react-native</td>
      <td>1</td>
      <td>5</td>
      <td>5</td>
      <td>5.0</td>
      <td>5.0</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>@ungap/url-search-params</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3d - Top 20 most widely spread external packages - percentage of internal elements

This table shows the top 20 most widely spread external packages focussing on the spread across the percentage of internal elements.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalModuleName</th>
      <th>numberOfInternalModules</th>
      <th>minNumberOfInternalElementsPercentage</th>
      <th>maxNumberOfInternalElementsPercentage</th>
      <th>medNumberOfInternalElementsPercentage</th>
      <th>avgNumberOfInternalElementsPercentage</th>
      <th>stdNumberOfInternalElementsPercentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@types/react</td>
      <td>4</td>
      <td>25.0</td>
      <td>600.0</td>
      <td>112.5</td>
      <td>212.5</td>
      <td>263.391344</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@types/react-native</td>
      <td>1</td>
      <td>125.0</td>
      <td>125.0</td>
      <td>125.0</td>
      <td>125.0</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>@ungap/url-search-params</td>
      <td>1</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 3 Chart 1 - Most widely spread external packages in % by types

External packages that are used less than 0.5% are grouped into the name "others" to get a cleaner chart with the most significant external packages.


    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_35_0.png)
    


#### Table 3 Chart 2 - Most widely spread external modules in % by internal modules

External modules that are used less than 0.5% are grouped into "others" to get a cleaner chart containing the most significant external modules.


    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_37_0.png)
    


### Table 4 - Top 20 most widely spread external namespaces

This table shows external namespaces that are used by different internal modules with the most used first. 

Statistics like minimum, maximum, average, median and standard deviation are provided for the number of internally exported elements (function, class, ...) and the external declarations they use for every external namespace. 

The intuition behind that is to find external namespaces that are used in a widely spread manner. This can help to distinguish widely used libraries and frameworks from external modules that are used for specific tasks. It can also be used to find external modules that are used sparsely regarding internal modules but where many different external declarations are used. 

Refactoring with a [Hexagonal architecture](https://alistair.cockburn.us/hexagonal-architecture) in mind can be considered for non-framework external namespaces that are used for very specific tasks and that are used in many different internal locations. This makes the internal code more robust against changes of these external modules or it is easier to update and migrate to newer versions of them. 

External namespaces that are only used in very few internal locations overall might be considered for removal if they are easy to replace with a similar library that is already used more often. Or they might also simply be replaced by very few lines of code. Replacing libraries with own code isn't recommended when you need to write a lot of code or for external modules that provide security relevant implementations (encryption, sanitizers, ...), because they will be tracked and maintained globally and security updates need to be adopted fast.

Only the top 20 entries are shown. The whole table can be found in the following CSV report:
`External_namespace_usage_spread_for_Typescript`

**Columns:**
- *externalModuleNamespace* identifies the external namespace for at least on external module in use. All other columns contain aggregated data for it.
- *numberOfInternalModules* is the number of internal modules that are using that external module
- *\[min,max,med,avg,std\]NumberOfUsedExternalDeclarations* provide statistics for all internal modules and how their usage of the declarations provided by the external module are distributed. This provides an indicator on how strong the coupling to the external module is. For example, if many (high sum) elements provided by that external module are used constantly (low std), a higher coupling can be presumed. If there is only one (sum) element in use, this could be an indicator for an external module that could get replaced or that there is just one central entry point for it.
- *\[min/max/med/avg/std\]NumberOfInternalElements* provide statistics for all internal modules and how their usage of the external module is distributed across their internal elements. This provides an indicator on how widely an external module is spread across internal elements and if there are great differences between internal modules (high standard deviation) or not.
- *\[min/max/med/avg/std\]NumberOfInternalElementsPercentage* is similar to [min/max/med/avg/std]NumberOfUsedExternalDeclarations but provides the value in percent in relation to the total number of internal elements per internal module.
- *internalModuleExamples* some examples of included internal modules for debugging

### Table 4 - Top 20 most widely spread external namespaces

This table shows external namespaces that are used by different internal modules with the most used first. 

Statistics like minimum, maximum, average, median and standard deviation are provided for the number of internally exported elements (function, class, ...) and the external declarations they use for every external namespace. 

The intuition behind that is to find external namespaces that are used in a widely spread manner. This can help to distinguish widely used libraries and frameworks from external modules that are used for specific tasks. It can also be used to find external modules that are used sparsely regarding internal modules but where many different external declarations are used. 

Refactoring with a [Hexagonal architecture](https://alistair.cockburn.us/hexagonal-architecture) in mind can be considered for non-framework external namespaces that are used for very specific tasks and that are used in many different internal locations. This makes the internal code more robust against changes of these external modules or it is easier to update and migrate to newer versions of them. 

External namespaces that are only used in very few internal locations overall might be considered for removal if they are easy to replace with a similar library that is already used more often. Or they might also simply be replaced by very few lines of code. Replacing libraries with own code isn't recommended when you need to write a lot of code or for external modules that provide security relevant implementations (encryption, sanitizers, ...), because they will be tracked and maintained globally and security updates need to be adopted fast.

Only the top 20 entries are shown. The whole table can be found in the following CSV report:
`External_namespace_usage_spread_for_Typescript`

**Columns:**
- *externalModuleNamespace* identifies the external namespace for at least on external module in use. All other columns contain aggregated data for it.
- *numberOfInternalModules* is the number of internal modules that are using that external module
- *\[min,max,med,avg,std\]NumberOfUsedExternalDeclarations* provide statistics for all internal modules and how their usage of the declarations provided by the external module are distributed. This provides an indicator on how strong the coupling to the external module is. For example, if many (high sum) elements provided by that external module are used constantly (low std), a higher coupling can be presumed. If there is only one (sum) element in use, this could be an indicator for an external module that could get replaced or that there is just one central entry point for it.
- *\[min/max/med/avg/std\]NumberOfInternalElements* provide statistics for all internal modules and how their usage of the external module is distributed across their internal elements. This provides an indicator on how widely an external module is spread across internal elements and if there are great differences between internal modules (high standard deviation) or not.
- *\[min/max/med/avg/std\]NumberOfInternalElementsPercentage* is similar to [min/max/med/avg/std]NumberOfUsedExternalDeclarations but provides the value in percent in relation to the total number of internal elements per internal module.
- *internalModuleExamples* some examples of included internal modules for debugging




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalModuleNamespace</th>
      <th>numberOfInternalModules</th>
      <th>sumNumberOfUsedExternalDeclarations</th>
      <th>minNumberOfUsedExternalDeclarations</th>
      <th>maxNumberOfUsedExternalDeclarations</th>
      <th>medNumberOfUsedExternalDeclarations</th>
      <th>avgNumberOfUsedExternalDeclarations</th>
      <th>stdNumberOfUsedExternalDeclarations</th>
      <th>sumNumberOfInternalElements</th>
      <th>minNumberOfInternalElements</th>
      <th>maxNumberOfInternalElements</th>
      <th>medNumberOfInternalElements</th>
      <th>avgNumberOfInternalElements</th>
      <th>stdNumberOfInternalElements</th>
      <th>minNumberOfInternalElementsPercentage</th>
      <th>maxNumberOfInternalElementsPercentage</th>
      <th>medNumberOfInternalElementsPercentage</th>
      <th>avgNumberOfInternalElementsPercentage</th>
      <th>stdNumberOfInternalElementsPercentage</th>
      <th>internalModuleExamples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@types</td>
      <td>4</td>
      <td>47</td>
      <td>1</td>
      <td>27</td>
      <td>9.5</td>
      <td>11.75</td>
      <td>12.526638</td>
      <td>35</td>
      <td>1</td>
      <td>24</td>
      <td>5.0</td>
      <td>8.75</td>
      <td>10.468206</td>
      <td>25.0</td>
      <td>600.0</td>
      <td>125.0</td>
      <td>218.75</td>
      <td>261.705146</td>
      <td>[react-router, react-router-dom, server, react...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@ungap</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.00</td>
      <td>0.000000</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.00</td>
      <td>0.000000</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>25.0</td>
      <td>25.00</td>
      <td>0.000000</td>
      <td>[react-router-native]</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 4 Chart 1 - Most widely spread external namespaces in % by internal element

External namespaces that are used less than 0.5% are grouped into "others" to get a cleaner chart
containing the most significant external namespaces and how ofter they are called in percent.


    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_42_0.png)
    


#### Table 4 Chart 2 - Most widely spread external namespace in % by internal modules

External namespaces that are used less than 0.5% are grouped into "others" to get a cleaner chart
containing the most significant external namespaces and how ofter they are called in percent.


    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_44_0.png)
    


#### Table 4 Chart 3 - External namespaces with the most used declarations in %

External namespaces that are used less than 0.5% are grouped into "others" to get a cleaner chart
containing the most significant external namespaces and how ofter they are called in percent.


    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_46_0.png)
    


### Table 5 - Top 20 least used external modules overall

This table identifies external modules that aren't used very often. This could help to find libraries that aren't actually needed or maybe easily replaceable. Some of them might be used sparsely on purpose for example as an adapter to an external library that is actually important. Thus, decisions need to be made on a case-by-case basis.

Only the last 20 entries are shown. The whole table can be found in the following CSV report:
`External_module_usage_overall_for_Typescript`

**Columns:**
- *externalModuleName* identifies the external package as described above
- *numberOfExternalDeclarationCalls* includes every invocation or reference to the declarations in the external module




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalModuleName</th>
      <th>numberOfExternalDeclarationCalls</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@ungap/url-search-params</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@types/react-native</td>
      <td>14</td>
    </tr>
    <tr>
      <th>2</th>
      <td>@types/react</td>
      <td>94</td>
    </tr>
  </tbody>
</table>
</div>



### Table 6 - External usage per internal module sorted by highest external element usage rate descending

The following table shows the most used external packages separately for each artifact including external annotations. The results are sorted by the artifacts with the highest external type usage rate descending. 

The intention of this table is to find artifacts that use a lot of external dependencies in relation to their size and get all the external packages and their usage.

Only the first 40 entries are shown. The whole table can be found in the following CSV report:
`External_module_usage_per_internal_module_sorted_for_Typescript`

**Columns:**
- *internalModuleName* is the internal module that uses the external one. Both are used here as a group for a more detailed analysis.
- *externalModuleName* is the external module prepended by its namespace if given. Example: "@types/react"
- *numberOfExternalDeclarationCaller* is the count of distinct internal elements in the internal module that call the external module
- *numberOfExternalDeclarationCalls* is the count of how often the external module is called within the internal module
- *numberOfAllElementsInInternalModule* is the total count of all exported elements of the internal module
- *numberOfAllExternalDeclarationsUsedInInternalModule* is the total count of all distinct external declarations used in the internal module
- *numberOfAllExternalModulesUsedInInternalModule* is the total count of all distinct external modules used in the internal module
- *externalDeclarationRate* is the numberOfAllExternalDeclarationsUsedInInternalModule / numberOfAllElementsInInternalModule * 100 of the internal module for all external modules
- *externalDeclarationNames* contains a list of actually used external declarations

#### Table 6a - External module usage per internal module sorted by highest external element usage rate descending




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>internalModuleName</th>
      <th>externalModuleName</th>
      <th>numberOfExternalDeclarationCaller</th>
      <th>numberOfExternalDeclarationCalls</th>
      <th>numberOfAllElementsInInternalModule</th>
      <th>numberOfAllExternalDeclarationsUsedInInternalModule</th>
      <th>numberOfAllExternalModulesUsedInInternalModule</th>
      <th>externalDeclarationRate</th>
      <th>externalDeclarationNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-native</td>
      <td>@types/react-native</td>
      <td>11</td>
      <td>14</td>
      <td>12</td>
      <td>18</td>
      <td>3</td>
      <td>150.000000</td>
      <td>[BackHandlerStatic.addEventListener, BackHandl...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-native</td>
      <td>@types/react</td>
      <td>9</td>
      <td>14</td>
      <td>12</td>
      <td>18</td>
      <td>3</td>
      <td>150.000000</td>
      <td>[React.useEffect, React.ReactNode, React.JSX.E...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-native</td>
      <td>@ungap/url-search-params</td>
      <td>1</td>
      <td>2</td>
      <td>12</td>
      <td>18</td>
      <td>3</td>
      <td>150.000000</td>
      <td>[url-search-params]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-dom</td>
      <td>@types/react</td>
      <td>80</td>
      <td>124</td>
      <td>35</td>
      <td>27</td>
      <td>1</td>
      <td>77.142857</td>
      <td>[React.useContext, React.ForwardRefExoticCompo...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>server</td>
      <td>@types/react</td>
      <td>3</td>
      <td>3</td>
      <td>6</td>
      <td>2</td>
      <td>1</td>
      <td>33.333333</td>
      <td>[React.JSX.Element, React.ReactNode]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router</td>
      <td>@types/react</td>
      <td>1</td>
      <td>3</td>
      <td>6</td>
      <td>1</td>
      <td>1</td>
      <td>16.666667</td>
      <td>[React.createElement]</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 6b - External namespace usage per internal module sorted by highest external element usage rate descending




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>internalModuleName</th>
      <th>externalNamespaceName</th>
      <th>numberOfExternalDeclarationCaller</th>
      <th>numberOfExternalDeclarationCalls</th>
      <th>numberOfAllElementsInInternalModule</th>
      <th>numberOfAllExternalDeclarationsUsedInInternalModule</th>
      <th>numberOfAllExternalModulesUsedInInternalModule</th>
      <th>externalDeclarationRate</th>
      <th>externalDeclarationNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-native</td>
      <td>@types</td>
      <td>20</td>
      <td>28</td>
      <td>12</td>
      <td>18</td>
      <td>3</td>
      <td>150.000000</td>
      <td>[BackHandlerStatic.addEventListener, BackHandl...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-native</td>
      <td>@ungap</td>
      <td>1</td>
      <td>2</td>
      <td>12</td>
      <td>18</td>
      <td>3</td>
      <td>150.000000</td>
      <td>[url-search-params]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-dom</td>
      <td>@types</td>
      <td>80</td>
      <td>124</td>
      <td>35</td>
      <td>27</td>
      <td>1</td>
      <td>77.142857</td>
      <td>[React.useContext, React.ForwardRefExoticCompo...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>server</td>
      <td>@types</td>
      <td>3</td>
      <td>3</td>
      <td>6</td>
      <td>2</td>
      <td>1</td>
      <td>33.333333</td>
      <td>[React.JSX.Element, React.ReactNode]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>react-router</td>
      <td>@types</td>
      <td>1</td>
      <td>3</td>
      <td>6</td>
      <td>1</td>
      <td>1</td>
      <td>16.666667</td>
      <td>[React.createElement]</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 6c - Top 15 used external modules with the internal modules that use them the most

The following table uses pivot to show the internal modules in columns, the external modules in rows and the number of internal elements using them as values.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>internalModuleName</th>
      <th>react-router-dom</th>
      <th>react-router-native</th>
      <th>server</th>
      <th>react-router</th>
    </tr>
    <tr>
      <th>externalModuleName</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>@types/react</th>
      <td>80</td>
      <td>9</td>
      <td>3</td>
      <td>1</td>
    </tr>
    <tr>
      <th>@types/react-native</th>
      <td>0</td>
      <td>11</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>@ungap/url-search-params</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 6d - Top 15 used external namespaces with the internal modules that use them the most

The following table uses pivot to show the internal modules in columns, the external namespaces in rows and the number of internal elements using them as values.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>internalModuleName</th>
      <th>react-router-dom</th>
      <th>react-router-native</th>
      <th>server</th>
      <th>react-router</th>
    </tr>
    <tr>
      <th>externalNamespaceName</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>@types</th>
      <td>80</td>
      <td>20</td>
      <td>3</td>
      <td>1</td>
    </tr>
    <tr>
      <th>@ungap</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 6e - External usage per internal module and its elements

This table lists internal elements and the modules they belong to that use many different external declarations of a specific external module. 




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>internalModuleName</th>
      <th>numberOfAllExternalDeclarationsUsedInInternalModule</th>
      <th>numberOfAllElementsInInternalModule</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-native</td>
      <td>18</td>
      <td>12</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router-dom</td>
      <td>27</td>
      <td>35</td>
    </tr>
    <tr>
      <th>4</th>
      <td>server</td>
      <td>2</td>
      <td>6</td>
    </tr>
    <tr>
      <th>5</th>
      <td>react-router</td>
      <td>1</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 6 Chart 1 - Top 15 external dependency using artifacts and their external packages stacked

The following chart shows the top 15 external package using artifacts and breaks down which external packages they use in how many different internal packages with stacked bars. 

Note that every external dependency is counted separately so that if on internal package uses two external packages it will be displayed for both and so stacked twice.  


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_62_1.png)
    


#### Table 6 Chart 2 - Top 15 external dependency using artifacts and their external packages (first 2 levels) stacked

The following chart shows the top 15 external package using artifacts and breaks down which external packages (first 2 levels) are used in how many different internal packages with stacked bars. 

Note that every external dependency is counted separately so that if on internal package uses two external packages it will be displayed for both and so stacked twice.  


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_64_1.png)
    


### Table 7 - External module usage distribution per internal element

This table shows how many internal elements use one external module, how many use two, etc. .
This gives an overview of the distribution of external module calls and the overall coupling to external libraries. The higher the count of distinct external modules the lower should be the count of internal elements that use them. 
More details about which types have the highest external package dependency usage can be in the tables 4 and 5 above.

Only the last 40 entries are shown. The whole table can be found in the following CSV report:
`External_module_usage_per_internal_module_distribution_for_Typescript`

**Columns:**
- *internalModuleName* is the internal module that uses at least one external module. All other columns refer to it.
- *numberOfAllInternalElements* the total number of all elements that are exported by the internal module
- *externalModuleCount* is the number of distinct external modules used by the internal module
- *internalElementCount* is the number of distinct internal elements that use at least one external one
- *internalElementsCallingExternalRate* is internalElementCount / numberOfAllInternalElements * 100 (in %)




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>internalModuleName</th>
      <th>numberOfAllInternalElements</th>
      <th>externalModuleCount</th>
      <th>internalElementCount</th>
      <th>internalElementsCallingExternalRate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router-dom</td>
      <td>35</td>
      <td>1</td>
      <td>24</td>
      <td>68.571429</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-native</td>
      <td>12</td>
      <td>3</td>
      <td>8</td>
      <td>66.666667</td>
    </tr>
    <tr>
      <th>2</th>
      <td>server</td>
      <td>6</td>
      <td>1</td>
      <td>3</td>
      <td>50.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>react-router</td>
      <td>6</td>
      <td>1</td>
      <td>1</td>
      <td>16.666667</td>
    </tr>
  </tbody>
</table>
</div>



# TODO

### Table 8 - External package usage aggregated

This table lists all artifacts and their external package dependencies usage aggregated over internal packages. 

The intention behind this is to find artifacts that use an external dependency across multiple internal packages. This might be intended for frameworks and standardized libraries and helps to quantify how widely those are used. For some external dependencies it might be beneficial to only access it from one package and provide an abstraction for internal usage following a [Hexagonal architecture](https://alistair.cockburn.us/hexagonal-architecture). Thus, this table may also help in finding application for the Hexagonal architecture or similar approaches (Domain Driven Design Anti Corruption Layer). After all it is easier to update or replace such external dependencies when they are used in specific areas and not all over the code.

Only the last 40 entries are shown. The whole table can be found in the following CSV report:
`External_module_usage_per_internal_module_aggregated_for_Typescript`

**Columns:**
- *internalModuleName* that contains the type that calls the external package
- *internalModuleElementsCount* is the total count of packages in the internal module
- *numberOfExternalModules* the number of distinct external packages used
- *[min,max,med,avg,std]NumberOfInternalModules* provide statistics based on each external package and its package usage within the internal module
- *[min,max,med,avg,std]NumberOfInternalElements* provide statistics based on each external package and its type usage within the internal module
- *[min,max,med,avg,std]NumberOfTypePercentage* provide statistics in % based on each external package and its type usage within the internal module in respect to the overall count of packages in the internal module
- *numberOfinternalElements* in the internal module where the *numberOfExternalModules* applies
- *numberOfTypesPercentage* in the internal module where the *numberOfExternalModules* applies in %

#### Table 8a - External module usage aggregated - count of internal modules




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>internalModuleName</th>
      <th>internalModuleElementsCount</th>
      <th>numberOfExternalModules</th>
      <th>minNumberOfInternalModules</th>
      <th>medNumberOfInternalModules</th>
      <th>avgNumberOfInternalModules</th>
      <th>maxNumberOfInternalModules</th>
      <th>stdNumberOfInternalModules</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router</td>
      <td>6</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-dom</td>
      <td>35</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-native</td>
      <td>12</td>
      <td>3</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>server</td>
      <td>6</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 8b - External module usage aggregated - count of internal elements




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>internalModuleName</th>
      <th>internalModuleElementsCount</th>
      <th>numberOfExternalModules</th>
      <th>minNumberOfInternalElements</th>
      <th>medNumberOfInternalElements</th>
      <th>avgNumberOfInternalElements</th>
      <th>maxNumberOfInternalElements</th>
      <th>stdNumberOfInternalElements</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router</td>
      <td>6</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-dom</td>
      <td>35</td>
      <td>1</td>
      <td>24</td>
      <td>24</td>
      <td>24.0</td>
      <td>24</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-native</td>
      <td>12</td>
      <td>3</td>
      <td>1</td>
      <td>5</td>
      <td>4.0</td>
      <td>6</td>
      <td>2.645751</td>
    </tr>
    <tr>
      <th>3</th>
      <td>server</td>
      <td>6</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>3</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 8c - External module usage aggregated - percentage of internal elements




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>internalModuleName</th>
      <th>internalModuleElementsCount</th>
      <th>numberOfExternalModules</th>
      <th>minNumberOfInternalElementsPercentage</th>
      <th>medNumberOfInternalElementsPercentage</th>
      <th>avgNumberOfInternalElementsPercentage</th>
      <th>maxNumberOfInternalElementsPercentage</th>
      <th>stdNumberOfInternalElementsPercentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>react-router</td>
      <td>6</td>
      <td>1</td>
      <td>16.666667</td>
      <td>16.666667</td>
      <td>16.666667</td>
      <td>16.666667</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>react-router-dom</td>
      <td>35</td>
      <td>1</td>
      <td>68.571429</td>
      <td>68.571429</td>
      <td>68.571429</td>
      <td>68.571429</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>react-router-native</td>
      <td>12</td>
      <td>3</td>
      <td>8.333333</td>
      <td>41.666667</td>
      <td>33.333333</td>
      <td>50.000000</td>
      <td>22.047928</td>
    </tr>
    <tr>
      <th>3</th>
      <td>server</td>
      <td>6</td>
      <td>1</td>
      <td>50.000000</td>
      <td>50.000000</td>
      <td>50.000000</td>
      <td>50.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 8 Chart 1 - External module usage - max percentage of internal types

This chart shows per internal module the maximum percentage of internal packages (compared to all packages in that internal module) that use one specific external package. 

**Example:** One internal module might use 10 external packages where 7 of them are used in one internal package, 2 of them are used in two packages and one external dependency is used in 5 packages. So for this internal module there will be a point at x = 10 (external packages used by the internal module) and 5 (max internal packages). Instead of the count the percentage of internal packages compared to all packages in that internal module is used to get a normalized plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_77_1.png)
    


#### Table 8 Chart 2 - External package usage - median percentage of internal types

This chart shows per internal module the median (0.5 percentile) of internal packages (compared to all packages in that internal module) that use one specific external package. 

**Example:** One internal module might use 9 external packages where 3 of them are used in 1 internal package, 3 of them are used in 2 package and the last 3 ones are used in 3 packages. So for this internal module there will be a point at x = 10 (external packages used by the internal module) and 2 (median internal packages). Instead of the count the percentage of internal packages compared to all packages in that internal module is used to get a normalized plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesTypescript_files/ExternalDependenciesTypescript_79_1.png)
    

