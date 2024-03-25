# External Dependencies
<br>  

### References
- [jqassistant](https://jqassistant.org)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)





## External Package Usage

### External Package

An external type has no `byteCodeVersion` since it only occurs as a dependency but wasn't analyzed itself (missing bytecode). Core Java types like `java.lang.Integer` and primitives like `int` are considered "build-in" and therefore aren't interpreted as "external" even though their byte code is also missing. A package is categorized as "external" if the types it contains are classified as external.

### External annotation dependency

The aforementioned classification encompasses external annotation dependencies as well. These dependencies introduce significantly less coupling and are not indispensable for compiling code. Without the external annotation the code would most probably behave differently. Hence, they are included in the first more overall and general tables and then left out in the later more specific ones.

### Table 1 - Top 20 most used external packages overall

This table shows the external packages that are used by the most different internal types overall.
Additionally, it shows which types of the external package are actually used. External annotations are also listed.

Only the top 20 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_overall`

**Columns:**
- *externalPackageName* identifies the external package as described above
- *numberOfExternalCallerPackages* refers to the distinct packages that make use of the external package
- *numberOfExternalCallerTypes* refers to the distinct types that make use of the external package
- *numberOfExternalTypeCalls* includes every dependency to the types in the external package
- *numberOfExternalTypeCallsWeighted* includes every invocation or reference (sum of weights) to the types in the external package
- *allPackages* contains the total count of all analyzed packages in general
- *allTypes* contains the total count of all analyzed types in general
- *externalTypeNames* contains a list of actually utilized types of the external package




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalPackageName</th>
      <th>numberOfExternalCallerPackages</th>
      <th>numberOfExternalCallerTypes</th>
      <th>numberOfExternalTypeCalls</th>
      <th>numberOfExternalTypeCallsWeighted</th>
      <th>allPackages</th>
      <th>allTypes</th>
      <th>tenExternalTypeNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>javax.annotation</td>
      <td>63</td>
      <td>310</td>
      <td>342</td>
      <td>1602</td>
      <td>93</td>
      <td>1224</td>
      <td>[Nonnull, Nullable, PreDestroy]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.slf4j</td>
      <td>53</td>
      <td>117</td>
      <td>208</td>
      <td>608</td>
      <td>93</td>
      <td>1224</td>
      <td>[Logger, LoggerFactory]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>13</td>
      <td>23</td>
      <td>57</td>
      <td>87</td>
      <td>93</td>
      <td>1224</td>
      <td>[JsonProperty, JsonCreator, JsonTypeInfo, Json...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>javax.persistence</td>
      <td>13</td>
      <td>24</td>
      <td>78</td>
      <td>340</td>
      <td>93</td>
      <td>1224</td>
      <td>[EntityManager, LockModeType, Id, Column, Enti...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>jakarta.persistence</td>
      <td>8</td>
      <td>22</td>
      <td>69</td>
      <td>328</td>
      <td>93</td>
      <td>1224</td>
      <td>[EntityManager, LockModeType, Query, EntityNot...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.hamcrest</td>
      <td>5</td>
      <td>27</td>
      <td>61</td>
      <td>498</td>
      <td>93</td>
      <td>1224</td>
      <td>[Matcher, Description, StringDescription, Core...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>2</td>
      <td>4</td>
      <td>7</td>
      <td>54</td>
      <td>93</td>
      <td>1224</td>
      <td>[Scheduler, ScheduledExecution, SchedulerState]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>2</td>
      <td>4</td>
      <td>10</td>
      <td>52</td>
      <td>93</td>
      <td>1224</td>
      <td>[TaskInstanceId, ExecutionContext, TaskWithDat...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.thoughtworks.xstream.io</td>
      <td>2</td>
      <td>4</td>
      <td>9</td>
      <td>46</td>
      <td>93</td>
      <td>1224</td>
      <td>[HierarchicalStreamReader, HierarchicalStreamW...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.jobrunr.scheduling</td>
      <td>2</td>
      <td>4</td>
      <td>6</td>
      <td>37</td>
      <td>93</td>
      <td>1224</td>
      <td>[JobScheduler, JobBuilder]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.quartz</td>
      <td>2</td>
      <td>9</td>
      <td>39</td>
      <td>232</td>
      <td>93</td>
      <td>1224</td>
      <td>[JobDataMap, JobBuilder, JobDetail, SchedulerC...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>reactor.core.publisher</td>
      <td>2</td>
      <td>18</td>
      <td>35</td>
      <td>157</td>
      <td>93</td>
      <td>1224</td>
      <td>[Mono, Flux, FluxSink$OverflowStrategy, Signal...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>3</td>
      <td>4</td>
      <td>11</td>
      <td>93</td>
      <td>1224</td>
      <td>[JacksonException, JsonParser, JsonProcessingE...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>1</td>
      <td>7</td>
      <td>15</td>
      <td>73</td>
      <td>93</td>
      <td>1224</td>
      <td>[DeserializationContext, JsonDeserializer, Jso...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>14</td>
      <td>93</td>
      <td>1224</td>
      <td>[ObjectNode, JsonNodeType]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.google.gson</td>
      <td>1</td>
      <td>1</td>
      <td>4</td>
      <td>9</td>
      <td>93</td>
      <td>1224</td>
      <td>[JsonElement, JsonParser, JsonArray, JsonObject]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.lmax.disruptor</td>
      <td>1</td>
      <td>7</td>
      <td>9</td>
      <td>29</td>
      <td>93</td>
      <td>1224</td>
      <td>[WaitStrategy, BlockingWaitStrategy, Exception...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.lmax.disruptor.dsl</td>
      <td>1</td>
      <td>4</td>
      <td>5</td>
      <td>22</td>
      <td>93</td>
      <td>1224</td>
      <td>[ProducerType, Disruptor, EventHandlerGroup]</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.thoughtworks.xstream.converters</td>
      <td>1</td>
      <td>3</td>
      <td>6</td>
      <td>12</td>
      <td>93</td>
      <td>1224</td>
      <td>[UnmarshallingContext, MarshallingContext]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.thoughtworks.xstream.io.xml</td>
      <td>1</td>
      <td>2</td>
      <td>4</td>
      <td>13</td>
      <td>93</td>
      <td>1224</td>
      <td>[CompactWriter, XppDriver, XomReader, Dom4JRea...</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 1 Chart 1 - Most called external packages in % by types

External packages that are used less than 0.7% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    
![png](ExternalDependencies_files/ExternalDependencies_14_0.png)
    


#### Table 1 Chart 2 - Most called external packages in % by packages

External packages that are used less than 0.7% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    
![png](ExternalDependencies_files/ExternalDependencies_17_0.png)
    


### Table 2 - Top 20 most used external packages grouped by their first 2 layers

This table shows external packages grouped by their first 2 layers that are used by the most different internal types overall including external annotations. For example, "javax.xml.stream" and "javax.xml.parsers" are grouped together to "javax.xml".

Additionally, it shows which types of the external packages are actually used.

Only the top 20 entries are shown. The whole table can be found in the following CSV report:
`External_second_level_package_usage_overall`

**Columns:**
- *externalSecondLevelPackageName* identifies the first 2 levels of the external package as described above
- *numberOfExternalCallerPackages* refers to the distinct packages that make use of the external package
- *numberOfExternalCallerTypes* refers to the distinct types that make use of the external package
- *numberOfExternalTypeCalls* includes every dependency to the types in the external package
- *numberOfExternalTypeCallsWeighted* includes every invocation or reference (sum of weights) to the types in the external package
- *allPackages* contains the total count of all analyzed packages in general
- *allTypes* contains the total count of all analyzed types in general
- *externalTypeNames* contains a list of actually utilized types of the external package




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalSecondLevelPackageName</th>
      <th>numberOfExternalCallerPackages</th>
      <th>numberOfExternalCallerTypes</th>
      <th>numberOfExternalTypeCalls</th>
      <th>numberOfExternalTypeCallsWeighted</th>
      <th>allPackages</th>
      <th>allTypes</th>
      <th>tenExternalTypeNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>javax.annotation</td>
      <td>63</td>
      <td>310</td>
      <td>342</td>
      <td>1602</td>
      <td>93</td>
      <td>1224</td>
      <td>[Nonnull, Nullable, PreDestroy]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.slf4j</td>
      <td>53</td>
      <td>117</td>
      <td>208</td>
      <td>608</td>
      <td>93</td>
      <td>1224</td>
      <td>[Logger, LoggerFactory]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>com.fasterxml</td>
      <td>14</td>
      <td>30</td>
      <td>85</td>
      <td>196</td>
      <td>93</td>
      <td>1224</td>
      <td>[JsonProperty, JsonCreator, JsonTypeInfo, Json...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>javax.persistence</td>
      <td>13</td>
      <td>24</td>
      <td>78</td>
      <td>340</td>
      <td>93</td>
      <td>1224</td>
      <td>[EntityManager, LockModeType, Id, Column, Enti...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>jakarta.persistence</td>
      <td>8</td>
      <td>22</td>
      <td>69</td>
      <td>328</td>
      <td>93</td>
      <td>1224</td>
      <td>[EntityManager, LockModeType, Query, EntityNot...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.hamcrest</td>
      <td>5</td>
      <td>27</td>
      <td>61</td>
      <td>498</td>
      <td>93</td>
      <td>1224</td>
      <td>[Matcher, Description, StringDescription, Core...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.github</td>
      <td>2</td>
      <td>6</td>
      <td>19</td>
      <td>120</td>
      <td>93</td>
      <td>1224</td>
      <td>[TaskInstanceId, Scheduler, ExecutionContext, ...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>com.thoughtworks</td>
      <td>2</td>
      <td>8</td>
      <td>31</td>
      <td>135</td>
      <td>93</td>
      <td>1224</td>
      <td>[XStream, Mapper, HierarchicalStreamReader, Un...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.jobrunr</td>
      <td>2</td>
      <td>4</td>
      <td>8</td>
      <td>39</td>
      <td>93</td>
      <td>1224</td>
      <td>[JobScheduler, JobId, JobBuilder]</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.junit</td>
      <td>2</td>
      <td>4</td>
      <td>8</td>
      <td>18</td>
      <td>93</td>
      <td>1224</td>
      <td>[TestRule, Statement, Description, AfterEachCa...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.quartz</td>
      <td>2</td>
      <td>9</td>
      <td>40</td>
      <td>234</td>
      <td>93</td>
      <td>1224</td>
      <td>[JobDataMap, JobBuilder, JobDetail, SchedulerC...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>reactor.core</td>
      <td>2</td>
      <td>18</td>
      <td>36</td>
      <td>159</td>
      <td>93</td>
      <td>1224</td>
      <td>[Mono, Flux, FluxSink$OverflowStrategy, Signal...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.google</td>
      <td>1</td>
      <td>1</td>
      <td>4</td>
      <td>9</td>
      <td>93</td>
      <td>1224</td>
      <td>[JsonElement, JsonParser, JsonArray, JsonObject]</td>
    </tr>
    <tr>
      <th>13</th>
      <td>com.lmax</td>
      <td>1</td>
      <td>7</td>
      <td>14</td>
      <td>51</td>
      <td>93</td>
      <td>1224</td>
      <td>[WaitStrategy, ProducerType, BlockingWaitStrat...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>jakarta.validation</td>
      <td>1</td>
      <td>2</td>
      <td>5</td>
      <td>22</td>
      <td>93</td>
      <td>1224</td>
      <td>[Validator, ConstraintViolation, ValidatorFact...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>javax.cache</td>
      <td>1</td>
      <td>2</td>
      <td>12</td>
      <td>59</td>
      <td>93</td>
      <td>1224</td>
      <td>[CacheEntryEventFilter, CacheEntryUpdatedListe...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>javax.validation</td>
      <td>1</td>
      <td>2</td>
      <td>5</td>
      <td>22</td>
      <td>93</td>
      <td>1224</td>
      <td>[ConstraintViolation, ValidatorFactory, Valida...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>net.sf</td>
      <td>1</td>
      <td>2</td>
      <td>8</td>
      <td>72</td>
      <td>93</td>
      <td>1224</td>
      <td>[CacheException, Element, CacheEventListener, ...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>nu.xom</td>
      <td>1</td>
      <td>3</td>
      <td>5</td>
      <td>16</td>
      <td>93</td>
      <td>1224</td>
      <td>[Document, Builder, ParsingException]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.dom4j</td>
      <td>1</td>
      <td>3</td>
      <td>4</td>
      <td>15</td>
      <td>93</td>
      <td>1224</td>
      <td>[Document, STAXEventReader]</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 2 Chart 1 - Most called second level external packages in % by type

External package groups that are used less than 0.7% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    
![png](ExternalDependencies_files/ExternalDependencies_21_0.png)
    


#### Table 2 Chart 2 - Most called second level external packages in % by package

External package groups that are used less than 0.7% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    
![png](ExternalDependencies_files/ExternalDependencies_23_0.png)
    


### Table 3 - Top 20 most widely spread external packages

The following tables shows external packages that are used by many different artifacts with the highest number of artifacts first. External annotations are filtered out to only get those external packages that significantly add to coupling.

Statistics like minimum, maximum, average, median and standard deviation are provided for the number of packages and number of types in every artifact that uses the listed external package. 

The intuition behind that is to find external package dependencies that are used in a widely spread manner. This should uncover libraries and frameworks and make it easier to distinguish them from external dependencies that are used for specific tasks. It can also be used to find external dependencies that are used sparsely regarding artifacts but are used in many different packages there. This could then be improved by applying a [Hexagonal architecture](https://alistair.cockburn.us/hexagonal-architecture).

Only the top 20 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_spread`

**Columns:**
- *externalPackageName* identifies the external package as defined above. All other columns contain aggregated data for this external package.
- *numberOfArtifacts* contains the number of artifacts that use the external package
- *sumNumberOfPackages* contains the sum of all packages that use the external package
- *min/max/med/avg/stdNumberOfPackages* provide statistics based on the number of packages of each artifact that uses the external package
- *min/max/med/avg/stdNumberOfPackagesPercentage* provide statistics in percent (%) based on the number of packages of each artifact that uses the external package
- *min/max/med/avg/stdNumberOfTypes* provide statistics based on the number of types of each artifact that uses the external package
- *min/max/med/avg/stdNumberOfPackagesPercentage* provide statistics in percent (%) based on the number of types of each artifact that uses the external package
- *someArtifactNames* contain some of the artifacts that contain the external package for reference




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalPackageName</th>
      <th>numberOfArtifacts</th>
      <th>sumNumberOfPackages</th>
      <th>minNumberOfPackages</th>
      <th>maxNumberOfPackages</th>
      <th>medNumberOfPackages</th>
      <th>avgNumberOfPackages</th>
      <th>stdNumberOfPackages</th>
      <th>minNumberOfPackagesPercentage</th>
      <th>maxNumberOfPackagesPercentage</th>
      <th>...</th>
      <th>maxNumberOfTypes</th>
      <th>medNumberOfTypes</th>
      <th>avgNumberOfTypes</th>
      <th>stdNumberOfTypes</th>
      <th>minNumberOfTypesPercentage</th>
      <th>maxNumberOfTypesPercentage</th>
      <th>medNumberOfTypesPercentage</th>
      <th>avgNumberOfTypesPercentage</th>
      <th>stdNumberOfTypesPercentage</th>
      <th>someArtifactNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.slf4j</td>
      <td>6</td>
      <td>53</td>
      <td>1</td>
      <td>38</td>
      <td>3.5</td>
      <td>8.833333</td>
      <td>14.441837</td>
      <td>25.0000</td>
      <td>100.0000</td>
      <td>...</td>
      <td>78</td>
      <td>8.5</td>
      <td>19.500000</td>
      <td>28.925767</td>
      <td>2.298851</td>
      <td>36.363636</td>
      <td>10.224990</td>
      <td>13.313616</td>
      <td>12.096702</td>
      <td>[axon-disruptor-4.9.3, axon-modelling-4.9.3, a...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>3</td>
      <td>6</td>
      <td>1</td>
      <td>3</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>1.000000</td>
      <td>4.6875</td>
      <td>20.0000</td>
      <td>...</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.666667</td>
      <td>2.886751</td>
      <td>1.017812</td>
      <td>2.255639</td>
      <td>1.923077</td>
      <td>1.732176</td>
      <td>0.640614</td>
      <td>[axon-modelling-4.9.3, axon-messaging-4.9.3, a...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>3</td>
      <td>9</td>
      <td>2</td>
      <td>4</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>1.000000</td>
      <td>6.2500</td>
      <td>30.0000</td>
      <td>...</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.666667</td>
      <td>2.886751</td>
      <td>1.017812</td>
      <td>2.255639</td>
      <td>1.923077</td>
      <td>1.732176</td>
      <td>0.640614</td>
      <td>[axon-modelling-4.9.3, axon-messaging-4.9.3, a...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>12.5000</td>
      <td>12.5000</td>
      <td>...</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>0.000000</td>
      <td>[axon-test-4.9.3]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>100.0000</td>
      <td>100.0000</td>
      <td>...</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>0.000000</td>
      <td>[axon-disruptor-4.9.3]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
      <td>4.6875</td>
      <td>4.6875</td>
      <td>...</td>
      <td>5</td>
      <td>5.0</td>
      <td>5.000000</td>
      <td>0.000000</td>
      <td>0.636132</td>
      <td>0.636132</td>
      <td>0.636132</td>
      <td>0.636132</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>7</td>
      <td>7.0</td>
      <td>7.000000</td>
      <td>0.000000</td>
      <td>0.890585</td>
      <td>0.890585</td>
      <td>0.890585</td>
      <td>0.890585</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>9</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
  </tbody>
</table>
<p>10 rows × 25 columns</p>
</div>



### Table 3a - Top 20 most widely spread external packages - number of internal packages

This table shows the top 20 most widely spread external packages focussing on the spread across the number of internal packages.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalPackageName</th>
      <th>numberOfArtifacts</th>
      <th>minNumberOfPackages</th>
      <th>maxNumberOfPackages</th>
      <th>medNumberOfPackages</th>
      <th>avgNumberOfPackages</th>
      <th>stdNumberOfPackages</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.slf4j</td>
      <td>6</td>
      <td>1</td>
      <td>38</td>
      <td>3.5</td>
      <td>8.833333</td>
      <td>14.441837</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>3</td>
      <td>1</td>
      <td>3</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>3</td>
      <td>2</td>
      <td>4</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>9</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>com.fasterxml.jackson.databind.type</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.fasterxml.jackson.datatype.jsr310</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.github.kagkarlsson.scheduler.task.helper</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.google.gson</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.lmax.disruptor</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.lmax.disruptor.dsl</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.thoughtworks.xstream</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3b - Top 20 most widely spread external packages - percentage of internal packages

This table shows the top 20 most widely spread external packages focussing on the spread across the percentage of internal packages.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalPackageName</th>
      <th>numberOfArtifacts</th>
      <th>minNumberOfPackagesPercentage</th>
      <th>maxNumberOfPackagesPercentage</th>
      <th>medNumberOfPackagesPercentage</th>
      <th>avgNumberOfPackagesPercentage</th>
      <th>stdNumberOfPackagesPercentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.slf4j</td>
      <td>6</td>
      <td>25.0000</td>
      <td>100.0000</td>
      <td>59.687500</td>
      <td>66.655093</td>
      <td>28.911597</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>3</td>
      <td>4.6875</td>
      <td>20.0000</td>
      <td>11.111111</td>
      <td>11.932870</td>
      <td>7.689254</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>3</td>
      <td>6.2500</td>
      <td>30.0000</td>
      <td>22.222222</td>
      <td>19.490741</td>
      <td>12.108318</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>12.5000</td>
      <td>12.5000</td>
      <td>12.500000</td>
      <td>12.500000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>100.0000</td>
      <td>100.0000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>1</td>
      <td>4.6875</td>
      <td>4.6875</td>
      <td>4.687500</td>
      <td>4.687500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>1</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>1</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>9</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>1</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>1</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>com.fasterxml.jackson.databind.type</td>
      <td>1</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.fasterxml.jackson.datatype.jsr310</td>
      <td>1</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>1</td>
      <td>3.1250</td>
      <td>3.1250</td>
      <td>3.125000</td>
      <td>3.125000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>1</td>
      <td>3.1250</td>
      <td>3.1250</td>
      <td>3.125000</td>
      <td>3.125000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.github.kagkarlsson.scheduler.task.helper</td>
      <td>1</td>
      <td>3.1250</td>
      <td>3.1250</td>
      <td>3.125000</td>
      <td>3.125000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.google.gson</td>
      <td>1</td>
      <td>12.5000</td>
      <td>12.5000</td>
      <td>12.500000</td>
      <td>12.500000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.lmax.disruptor</td>
      <td>1</td>
      <td>100.0000</td>
      <td>100.0000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.lmax.disruptor.dsl</td>
      <td>1</td>
      <td>100.0000</td>
      <td>100.0000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.thoughtworks.xstream</td>
      <td>1</td>
      <td>3.1250</td>
      <td>3.1250</td>
      <td>3.125000</td>
      <td>3.125000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3c - Top 20 most widely spread external packages - number of internal types

This table shows the top 20 most widely spread external packages focussing on the spread across the number of internal types.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalPackageName</th>
      <th>numberOfArtifacts</th>
      <th>minNumberOfTypes</th>
      <th>maxNumberOfTypes</th>
      <th>medNumberOfTypes</th>
      <th>avgNumberOfTypes</th>
      <th>stdNumberOfTypes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.slf4j</td>
      <td>6</td>
      <td>2</td>
      <td>78</td>
      <td>8.5</td>
      <td>19.500000</td>
      <td>28.925767</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>3</td>
      <td>3</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.666667</td>
      <td>2.886751</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>3</td>
      <td>3</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.666667</td>
      <td>2.886751</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>1</td>
      <td>5</td>
      <td>5</td>
      <td>5.0</td>
      <td>5.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>1</td>
      <td>7</td>
      <td>7</td>
      <td>7.0</td>
      <td>7.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>9</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>com.fasterxml.jackson.databind.type</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.fasterxml.jackson.datatype.jsr310</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>1</td>
      <td>4</td>
      <td>4</td>
      <td>4.0</td>
      <td>4.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>1</td>
      <td>4</td>
      <td>4</td>
      <td>4.0</td>
      <td>4.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.github.kagkarlsson.scheduler.task.helper</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.google.gson</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.lmax.disruptor</td>
      <td>1</td>
      <td>7</td>
      <td>7</td>
      <td>7.0</td>
      <td>7.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.lmax.disruptor.dsl</td>
      <td>1</td>
      <td>4</td>
      <td>4</td>
      <td>4.0</td>
      <td>4.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.thoughtworks.xstream</td>
      <td>1</td>
      <td>4</td>
      <td>4</td>
      <td>4.0</td>
      <td>4.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3d - Top 20 most widely spread external packages - percentage of internal types

This table shows the top 20 most widely spread external packages focussing on the spread across the percentage of internal types.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalPackageName</th>
      <th>numberOfArtifacts</th>
      <th>minNumberOfTypesPercentage</th>
      <th>maxNumberOfTypesPercentage</th>
      <th>medNumberOfTypesPercentage</th>
      <th>avgNumberOfTypesPercentage</th>
      <th>stdNumberOfTypesPercentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.slf4j</td>
      <td>6</td>
      <td>2.298851</td>
      <td>36.363636</td>
      <td>10.224990</td>
      <td>13.313616</td>
      <td>12.096702</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>3</td>
      <td>1.017812</td>
      <td>2.255639</td>
      <td>1.923077</td>
      <td>1.732176</td>
      <td>0.640614</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>3</td>
      <td>1.017812</td>
      <td>2.255639</td>
      <td>1.923077</td>
      <td>1.732176</td>
      <td>0.640614</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>1</td>
      <td>0.636132</td>
      <td>0.636132</td>
      <td>0.636132</td>
      <td>0.636132</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>1</td>
      <td>0.890585</td>
      <td>0.890585</td>
      <td>0.890585</td>
      <td>0.890585</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>1</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>9</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>1</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>1</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>com.fasterxml.jackson.databind.type</td>
      <td>1</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.fasterxml.jackson.datatype.jsr310</td>
      <td>1</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.127226</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>1</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>1</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.github.kagkarlsson.scheduler.task.helper</td>
      <td>1</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.google.gson</td>
      <td>1</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.lmax.disruptor</td>
      <td>1</td>
      <td>31.818182</td>
      <td>31.818182</td>
      <td>31.818182</td>
      <td>31.818182</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.lmax.disruptor.dsl</td>
      <td>1</td>
      <td>18.181818</td>
      <td>18.181818</td>
      <td>18.181818</td>
      <td>18.181818</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.thoughtworks.xstream</td>
      <td>1</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 3 Chart 1 - Most widely spread external packages in % by types

External packages that are used less than 0.5% are grouped into the name "others" to get a cleaner chart with the most significant external packages.


    
![png](ExternalDependencies_files/ExternalDependencies_35_0.png)
    


#### Table 3 Chart 2 - Most widely spread external packages in % by packages

External packages that are used less than 0.5% are grouped into the name "others" to get a cleaner chart with the most significant external packages.


    
![png](ExternalDependencies_files/ExternalDependencies_37_0.png)
    


### Table 4 - Top 20 most widely spread external packages grouped by their first 2 layers

This table shows external packages grouped by their first 2 layers that are used by many different artifacts with the highest number of artifacts first. External annotations are filtered out to only get those external packages that significantly add to coupling.

Statistics like minimum, maximum, average, median and standard deviation are provided for the number of packages and number of types in every artifact that uses the listed external package. 

The intuition behind that is to find external package dependencies that are used in a widely spread manner. This should uncover libraries and frameworks and make it easier to distinguish them from external dependencies that are used for specific tasks. It can also be used to find external dependencies that are used sparsely regarding artifacts but are used in many different packages there. This could then be improved by applying a [Hexagonal architecture](https://alistair.cockburn.us/hexagonal-architecture).

Only the top 20 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_spread`

**Columns:**
- *externalPackageName* identifies the external package as defined above. All other columns contain aggregated data for this external package.
- *numberOfArtifacts* contains the number of artifacts that use the external package
- *sumNumberOfPackages* contains the sum of all packages that use the external package
- *min/max/med/avg/stdNumberOfPackages* provide statistics based on the number of packages of each artifact that uses the external package
- *min/max/med/avg/stdNumberOfPackagesPercentage* provide statistics in percent (%) based on the number of packages of each artifact that uses the external package
- *min/max/med/avg/stdNumberOfTypes* provide statistics based on the number of types of each artifact that uses the external package
- *min/max/med/avg/stdNumberOfPackagesPercentage* provide statistics in percent (%) based on the number of types of each artifact that uses the external package
- *someArtifactNames* contain some of the artifacts that contain the external package for reference




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalSecondLevelPackageName</th>
      <th>numberOfArtifacts</th>
      <th>sumNumberOfPackages</th>
      <th>minNumberOfPackages</th>
      <th>maxNumberOfPackages</th>
      <th>medNumberOfPackages</th>
      <th>avgNumberOfPackages</th>
      <th>stdNumberOfPackages</th>
      <th>minNumberOfPackagesPercentage</th>
      <th>maxNumberOfPackagesPercentage</th>
      <th>...</th>
      <th>maxNumberOfTypes</th>
      <th>medNumberOfTypes</th>
      <th>avgNumberOfTypes</th>
      <th>stdNumberOfTypes</th>
      <th>minNumberOfTypesPercentage</th>
      <th>maxNumberOfTypesPercentage</th>
      <th>medNumberOfTypesPercentage</th>
      <th>avgNumberOfTypesPercentage</th>
      <th>stdNumberOfTypesPercentage</th>
      <th>someArtifactNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.slf4j</td>
      <td>6</td>
      <td>53</td>
      <td>1</td>
      <td>38</td>
      <td>3.5</td>
      <td>8.833333</td>
      <td>14.441837</td>
      <td>25.0000</td>
      <td>100.0000</td>
      <td>...</td>
      <td>78</td>
      <td>8.5</td>
      <td>19.500000</td>
      <td>28.925767</td>
      <td>2.298851</td>
      <td>36.363636</td>
      <td>10.224990</td>
      <td>13.313616</td>
      <td>12.096702</td>
      <td>[axon-disruptor-4.9.3, axon-modelling-4.9.3, a...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>3</td>
      <td>6</td>
      <td>1</td>
      <td>3</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>1.000000</td>
      <td>4.6875</td>
      <td>20.0000</td>
      <td>...</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.666667</td>
      <td>2.886751</td>
      <td>1.017812</td>
      <td>2.255639</td>
      <td>1.923077</td>
      <td>1.732176</td>
      <td>0.640614</td>
      <td>[axon-modelling-4.9.3, axon-messaging-4.9.3, a...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>3</td>
      <td>9</td>
      <td>2</td>
      <td>4</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>1.000000</td>
      <td>6.2500</td>
      <td>30.0000</td>
      <td>...</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.666667</td>
      <td>2.886751</td>
      <td>1.017812</td>
      <td>2.255639</td>
      <td>1.923077</td>
      <td>1.732176</td>
      <td>0.640614</td>
      <td>[axon-modelling-4.9.3, axon-messaging-4.9.3, a...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>12.5000</td>
      <td>12.5000</td>
      <td>...</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>0.000000</td>
      <td>[axon-test-4.9.3]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>100.0000</td>
      <td>100.0000</td>
      <td>...</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>0.000000</td>
      <td>[axon-disruptor-4.9.3]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.fasterxml</td>
      <td>1</td>
      <td>4</td>
      <td>4</td>
      <td>4</td>
      <td>4.0</td>
      <td>4.000000</td>
      <td>0.000000</td>
      <td>6.2500</td>
      <td>6.2500</td>
      <td>...</td>
      <td>12</td>
      <td>12.0</td>
      <td>12.000000</td>
      <td>0.000000</td>
      <td>1.526718</td>
      <td>1.526718</td>
      <td>1.526718</td>
      <td>1.526718</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.github</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>3.1250</td>
      <td>3.1250</td>
      <td>...</td>
      <td>6</td>
      <td>6.0</td>
      <td>6.000000</td>
      <td>0.000000</td>
      <td>0.763359</td>
      <td>0.763359</td>
      <td>0.763359</td>
      <td>0.763359</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>com.google</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>12.5000</td>
      <td>12.5000</td>
      <td>...</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>0.000000</td>
      <td>[axon-test-4.9.3]</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.lmax</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>100.0000</td>
      <td>100.0000</td>
      <td>...</td>
      <td>7</td>
      <td>7.0</td>
      <td>7.000000</td>
      <td>0.000000</td>
      <td>31.818182</td>
      <td>31.818182</td>
      <td>31.818182</td>
      <td>31.818182</td>
      <td>0.000000</td>
      <td>[axon-disruptor-4.9.3]</td>
    </tr>
    <tr>
      <th>9</th>
      <td>com.thoughtworks</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>3.1250</td>
      <td>3.1250</td>
      <td>...</td>
      <td>8</td>
      <td>8.0</td>
      <td>8.000000</td>
      <td>0.000000</td>
      <td>1.017812</td>
      <td>1.017812</td>
      <td>1.017812</td>
      <td>1.017812</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>jakarta.validation</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>javax.cache</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>12</th>
      <td>javax.validation</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>13</th>
      <td>net.sf</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.254453</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>nu.xom</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.dom4j</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.ehcache</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.5625</td>
      <td>1.5625</td>
      <td>...</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.381679</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.hamcrest</td>
      <td>1</td>
      <td>5</td>
      <td>5</td>
      <td>5</td>
      <td>5.0</td>
      <td>5.000000</td>
      <td>0.000000</td>
      <td>62.5000</td>
      <td>62.5000</td>
      <td>...</td>
      <td>27</td>
      <td>27.0</td>
      <td>27.000000</td>
      <td>0.000000</td>
      <td>31.034483</td>
      <td>31.034483</td>
      <td>31.034483</td>
      <td>31.034483</td>
      <td>0.000000</td>
      <td>[axon-test-4.9.3]</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.jobrunr</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>3.1250</td>
      <td>3.1250</td>
      <td>...</td>
      <td>4</td>
      <td>4.0</td>
      <td>4.000000</td>
      <td>0.000000</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.508906</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.9.3]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.junit</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>25.0000</td>
      <td>25.0000</td>
      <td>...</td>
      <td>4</td>
      <td>4.0</td>
      <td>4.000000</td>
      <td>0.000000</td>
      <td>4.597701</td>
      <td>4.597701</td>
      <td>4.597701</td>
      <td>4.597701</td>
      <td>0.000000</td>
      <td>[axon-test-4.9.3]</td>
    </tr>
  </tbody>
</table>
<p>20 rows × 25 columns</p>
</div>



#### Table 4 Chart 1 - Most widely spread second level external packages in % by type

External package groups that are used less than 0.5% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    
![png](ExternalDependencies_files/ExternalDependencies_41_0.png)
    


#### Table 4 Chart 2 - Most widely spread second level external packages in % by package

External package groups that are used less than 0.5% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    
![png](ExternalDependencies_files/ExternalDependencies_43_0.png)
    


### Table 5 - Top 20 least used external packages overall

This table identifies external packages that aren't used very often. This could help to find libraries that aren't actually needed or maybe easily replaceable. Some of them might be used sparsely on purpose for example as an adapter to an external library that is actually important. Thus, decisions need to be made on a case-by-case basis.

Only the last 20 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_overall`

**Columns:**
- *externalPackageName* identifies the external package as described above
- *numberOfExternalTypeCalls* includes every invocation or reference to the types in the external package




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalPackageName</th>
      <th>numberOfExternalTypeCalls</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.junit.jupiter.api.extension</td>
      <td>3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>net.sf.ehcache.event</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>javax.cache.configuration</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.testcontainers.containers</td>
      <td>4</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.testcontainers.containers.wait.strategy</td>
      <td>4</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.google.gson</td>
      <td>4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>com.fasterxml.jackson.core</td>
      <td>4</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.thoughtworks.xstream.io.xml</td>
      <td>4</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.testcontainers.utility</td>
      <td>5</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.lmax.disruptor.dsl</td>
      <td>5</td>
    </tr>
    <tr>
      <th>11</th>
      <td>jakarta.validation</td>
      <td>5</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.thoughtworks.xstream.mapper</td>
      <td>5</td>
    </tr>
    <tr>
      <th>13</th>
      <td>javax.validation</td>
      <td>5</td>
    </tr>
    <tr>
      <th>14</th>
      <td>net.sf.ehcache</td>
      <td>5</td>
    </tr>
    <tr>
      <th>15</th>
      <td>nu.xom</td>
      <td>5</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.thoughtworks.xstream.converters</td>
      <td>6</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.jobrunr.scheduling</td>
      <td>6</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>7</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.ehcache.event</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>



### Table 6 - External usage per artifact sorted by highest external type rate descending

The following table shows the most used external packages separately for each artifact including external annotations. The results are sorted by the artifacts with the highest external type usage rate descending. 

The intention of this table is to find artifacts that use a lot of external dependencies in relation to their size and get all the external packages and their usage.

Only the last 40 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_per_artifact_sorted`

**Columns:**
- *artifactName* is used to group the the external package usage per artifact for a more detailed analysis.
- *externalPackageName* identifies the external package as described above
- *numberOfExternalTypeCaller* refers to the distinct types that make use of the external package
- *numberOfExternalTypeCalls* includes every invocation or reference to the types in the external package
- *numberOfTypesInArtifact* represents the total count of all analyzed types for the artifact
- *numberOfExternalTypesInArtifact* is the number of all external types that are used by the artifact
- *numberOfExternalPackagesInArtifact* is the number of all external packages that are used by the artifact
- *externalTypeRate* is the numberOfExternalTypesInArtifact / numberOfTypesInArtifact * 100
- *externalTypeNames* contains a list of actually utilized types of the external package




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>externalPackageName</th>
      <th>numberOfExternalTypeCaller</th>
      <th>numberOfExternalTypeCalls</th>
      <th>numberOfTypesInArtifact</th>
      <th>numberOfExternalTypesInArtifact</th>
      <th>numberOfExternalPackagesInArtifact</th>
      <th>externalTypeRate</th>
      <th>externalTypeNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-disruptor-4.9.3</td>
      <td>org.slf4j</td>
      <td>12</td>
      <td>22</td>
      <td>22</td>
      <td>13</td>
      <td>5</td>
      <td>59.090909</td>
      <td>[Logger, LoggerFactory]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.9.3</td>
      <td>com.lmax.disruptor</td>
      <td>9</td>
      <td>29</td>
      <td>22</td>
      <td>13</td>
      <td>5</td>
      <td>59.090909</td>
      <td>[RingBuffer, EventHandler, LifecycleAware, Wai...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.9.3</td>
      <td>javax.annotation</td>
      <td>6</td>
      <td>23</td>
      <td>22</td>
      <td>13</td>
      <td>5</td>
      <td>59.090909</td>
      <td>[Nonnull]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.9.3</td>
      <td>com.lmax.disruptor.dsl</td>
      <td>5</td>
      <td>22</td>
      <td>22</td>
      <td>13</td>
      <td>5</td>
      <td>59.090909</td>
      <td>[Disruptor, EventHandlerGroup, ProducerType]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.9.3</td>
      <td>WeakValue</td>
      <td>1</td>
      <td>5</td>
      <td>22</td>
      <td>13</td>
      <td>5</td>
      <td>59.090909</td>
      <td>[WeakValue]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-test-4.9.3</td>
      <td>org.hamcrest</td>
      <td>61</td>
      <td>498</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[StringDescription, Description, Matchers, Mat...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-test-4.9.3</td>
      <td>javax.annotation</td>
      <td>10</td>
      <td>52</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[Nonnull]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-test-4.9.3</td>
      <td>org.testcontainers.utility</td>
      <td>5</td>
      <td>27</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[DockerImageName, MountableFile]</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-test-4.9.3</td>
      <td>com.google.gson</td>
      <td>4</td>
      <td>9</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[JsonElement, JsonParser, JsonArray, JsonObject]</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-test-4.9.3</td>
      <td>org.slf4j</td>
      <td>4</td>
      <td>13</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[Logger, LoggerFactory]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-test-4.9.3</td>
      <td>org.testcontainers.containers</td>
      <td>4</td>
      <td>15</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[GenericContainer, ContainerLaunchException]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-test-4.9.3</td>
      <td>org.testcontainers.containers.wait.strategy</td>
      <td>4</td>
      <td>5</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[Wait, HttpWaitStrategy]</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-test-4.9.3</td>
      <td>org.junit.jupiter.api.extension</td>
      <td>3</td>
      <td>6</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[AfterEachCallback, BeforeEachCallback, Extens...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-test-4.9.3</td>
      <td>org.junit.runners.model</td>
      <td>2</td>
      <td>8</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[Statement]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-test-4.9.3</td>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>2</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[AggregateEventPublisherImpl]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-test-4.9.3</td>
      <td>org.junit.jupiter.api</td>
      <td>1</td>
      <td>1</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[Assertions]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-test-4.9.3</td>
      <td>org.junit.rules</td>
      <td>1</td>
      <td>1</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[TestRule]</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-test-4.9.3</td>
      <td>org.junit.runner</td>
      <td>1</td>
      <td>2</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>[Description]</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-modelling-4.9.3</td>
      <td>javax.annotation</td>
      <td>37</td>
      <td>132</td>
      <td>156</td>
      <td>35</td>
      <td>5</td>
      <td>22.435897</td>
      <td>[Nullable, Nonnull]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-modelling-4.9.3</td>
      <td>javax.persistence</td>
      <td>23</td>
      <td>96</td>
      <td>156</td>
      <td>35</td>
      <td>5</td>
      <td>22.435897</td>
      <td>[Id, Column, Entity, Basic, Lob, MappedSupercl...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-modelling-4.9.3</td>
      <td>jakarta.persistence</td>
      <td>18</td>
      <td>90</td>
      <td>156</td>
      <td>35</td>
      <td>5</td>
      <td>22.435897</td>
      <td>[Id, Entity, Lob, Basic, Column, GeneratedValu...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-modelling-4.9.3</td>
      <td>org.slf4j</td>
      <td>17</td>
      <td>58</td>
      <td>156</td>
      <td>35</td>
      <td>5</td>
      <td>22.435897</td>
      <td>[Logger, LoggerFactory]</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-modelling-4.9.3</td>
      <td>com.fasterxml.jackson.annotation</td>
      <td>4</td>
      <td>6</td>
      <td>156</td>
      <td>35</td>
      <td>5</td>
      <td>22.435897</td>
      <td>[JsonCreator, JsonProperty]</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.9.3</td>
      <td>javax.annotation</td>
      <td>247</td>
      <td>1191</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[Nonnull, Nullable]</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.slf4j</td>
      <td>141</td>
      <td>440</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[Logger, LoggerFactory]</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-messaging-4.9.3</td>
      <td>com.fasterxml.jackson.annotation</td>
      <td>53</td>
      <td>81</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[JsonTypeInfo$As, JsonTypeInfo$Id, JsonTypeInf...</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-messaging-4.9.3</td>
      <td>javax.persistence</td>
      <td>44</td>
      <td>194</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[LockModeType, GeneratedValue, Id, MappedSuper...</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.9.3</td>
      <td>jakarta.persistence</td>
      <td>40</td>
      <td>188</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[Query, EntityManager, LockModeType, TypedQuer...</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.quartz</td>
      <td>39</td>
      <td>232</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[Scheduler, JobKey, JobDetail, Job, SchedulerC...</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-messaging-4.9.3</td>
      <td>reactor.core.publisher</td>
      <td>35</td>
      <td>157</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[MonoSink, Flux, Mono, FluxSink$OverflowStrate...</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-messaging-4.9.3</td>
      <td>com.fasterxml.jackson.databind</td>
      <td>15</td>
      <td>73</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[DeserializationContext, JsonDeserializer, Jso...</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.reactivestreams</td>
      <td>13</td>
      <td>41</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[Publisher]</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-messaging-4.9.3</td>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>10</td>
      <td>52</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[ExecutionContext, TaskWithDataDescriptor, Tas...</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-messaging-4.9.3</td>
      <td>com.thoughtworks.xstream.io</td>
      <td>9</td>
      <td>46</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[HierarchicalStreamWriter, HierarchicalStreamR...</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-messaging-4.9.3</td>
      <td>javax.cache.event</td>
      <td>8</td>
      <td>34</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[CacheEntryEventFilter, CacheEntryUpdatedListe...</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.ehcache.event</td>
      <td>8</td>
      <td>33</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[EventType, EventOrdering, CacheEventListener,...</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-messaging-4.9.3</td>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>7</td>
      <td>54</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[Scheduler, ScheduledExecution, SchedulerState]</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-messaging-4.9.3</td>
      <td>com.thoughtworks.xstream.converters</td>
      <td>6</td>
      <td>12</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[UnmarshallingContext, MarshallingContext]</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.jobrunr.scheduling</td>
      <td>6</td>
      <td>37</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[JobScheduler, JobBuilder]</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-messaging-4.9.3</td>
      <td>com.thoughtworks.xstream.mapper</td>
      <td>5</td>
      <td>10</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>[Mapper, CannotResolveClassException]</td>
    </tr>
  </tbody>
</table>
</div>



### Table 7 - Artifacts and their external packages

The following table shows the artifacts with the highest external dependency usage broken down by each external package including external annotations. The results are sorted by the artifacts with the highest external package usage rate descending. 

The intention of this table is to find artifacts that use a lot of external dependencies and show in detail which external packages are used by them and how many internal packages.

Only the last 30 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_per_artifact_and_external_package`

**Columns:**
- *artifactName* is the name of the artifact with external dependencies (first grouping column)
- *artifactPackages* is the number of packages in the artifact
- *artifactTypes* is the number of types in the artifact
- *artifactExternalPackages* is the number of external packages used by the artifact
- *artifactExternalCallingPackages* is the number of packages that use external packages in the artifact 
- *artifactExternalCallingPackagesRate* is artifactExternalCallingPackages / artifactPackages * 100%
- *externalPackageName* the name of the external package (second grouping column)
- *numberOfPackages* is the number of internal packages of the artifact that use the external packages
- *numberOfTypes* is the number of internal types of the artifact that use the external packages
- *packagesCallingExternalRate* is numberOfPackages / artifactPackages * 100%
- *typesCallingExternalRate* is numberOfTypes / artifactTypes * 100%
- *nameOfPackages* names of the internal packages that use the external package in the artifact
- *someTypeNames* some (10) names of the internal types that use the external package in the artifact




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>artifactPackages</th>
      <th>artifactTypes</th>
      <th>artifactExternalPackages</th>
      <th>artifactExternalCallingPackages</th>
      <th>artifactExternalCallingPackagesRate</th>
      <th>externalPackageName</th>
      <th>numberOfPackages</th>
      <th>numberOfTypes</th>
      <th>packagesCallingExternalRate</th>
      <th>typesCallingExternalRate</th>
      <th>nameOfPackages</th>
      <th>someTypeNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-configuration-4.9.3</td>
      <td>1</td>
      <td>40</td>
      <td>2</td>
      <td>1</td>
      <td>100.00</td>
      <td>javax.annotation</td>
      <td>1</td>
      <td>13</td>
      <td>100.0000</td>
      <td>32.500000</td>
      <td>[org.axonframework.config]</td>
      <td>[org.axonframework.config.AxonIQConsoleModule,...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.9.3</td>
      <td>1</td>
      <td>40</td>
      <td>2</td>
      <td>1</td>
      <td>100.00</td>
      <td>org.slf4j</td>
      <td>1</td>
      <td>6</td>
      <td>100.0000</td>
      <td>15.000000</td>
      <td>[org.axonframework.config]</td>
      <td>[org.axonframework.config.AxonIQConsoleModule,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.00</td>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>100.0000</td>
      <td>4.545455</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.F...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.00</td>
      <td>com.lmax.disruptor</td>
      <td>1</td>
      <td>7</td>
      <td>100.0000</td>
      <td>31.818182</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.00</td>
      <td>com.lmax.disruptor.dsl</td>
      <td>1</td>
      <td>4</td>
      <td>100.0000</td>
      <td>18.181818</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.00</td>
      <td>javax.annotation</td>
      <td>1</td>
      <td>6</td>
      <td>100.0000</td>
      <td>27.272727</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.C...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.00</td>
      <td>org.slf4j</td>
      <td>1</td>
      <td>8</td>
      <td>100.0000</td>
      <td>36.363636</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.C...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.hamcrest</td>
      <td>5</td>
      <td>27</td>
      <td>62.5000</td>
      <td>31.034483</td>
      <td>[org.axonframework.test.aggregate, org.axonfra...</td>
      <td>[org.axonframework.test.aggregate.ResultValida...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>javax.annotation</td>
      <td>4</td>
      <td>10</td>
      <td>50.0000</td>
      <td>11.494253</td>
      <td>[org.axonframework.test.aggregate, org.axonfra...</td>
      <td>[org.axonframework.test.aggregate.AggregateTes...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.slf4j</td>
      <td>2</td>
      <td>2</td>
      <td>25.0000</td>
      <td>2.298851</td>
      <td>[org.axonframework.test.aggregate, org.axonfra...</td>
      <td>[org.axonframework.test.aggregate.AggregateTes...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1</td>
      <td>12.5000</td>
      <td>1.149425</td>
      <td>[org.axonframework.test.saga]</td>
      <td>[org.axonframework.test.saga.SagaTestFixture]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>com.google.gson</td>
      <td>1</td>
      <td>1</td>
      <td>12.5000</td>
      <td>1.149425</td>
      <td>[org.axonframework.test.server]</td>
      <td>[org.axonframework.test.server.AxonServerConta...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.junit.jupiter.api</td>
      <td>1</td>
      <td>1</td>
      <td>12.5000</td>
      <td>1.149425</td>
      <td>[org.axonframework.test.saga]</td>
      <td>[org.axonframework.test.saga.FixtureExecutionR...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.junit.jupiter.api.extension</td>
      <td>1</td>
      <td>1</td>
      <td>12.5000</td>
      <td>1.149425</td>
      <td>[org.axonframework.test.aggregate]</td>
      <td>[org.axonframework.test.aggregate.StubAggregat...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.junit.rules</td>
      <td>1</td>
      <td>1</td>
      <td>12.5000</td>
      <td>1.149425</td>
      <td>[org.axonframework.test.aggregate]</td>
      <td>[org.axonframework.test.aggregate.StubAggregat...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.junit.runner</td>
      <td>1</td>
      <td>1</td>
      <td>12.5000</td>
      <td>1.149425</td>
      <td>[org.axonframework.test.aggregate]</td>
      <td>[org.axonframework.test.aggregate.StubAggregat...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.junit.runners.model</td>
      <td>1</td>
      <td>2</td>
      <td>12.5000</td>
      <td>2.298851</td>
      <td>[org.axonframework.test.aggregate]</td>
      <td>[org.axonframework.test.aggregate.StubAggregat...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.testcontainers.containers</td>
      <td>1</td>
      <td>3</td>
      <td>12.5000</td>
      <td>3.448276</td>
      <td>[org.axonframework.test.server]</td>
      <td>[org.axonframework.test.server.AxonServerEECon...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.testcontainers.containers.wait.strategy</td>
      <td>1</td>
      <td>3</td>
      <td>12.5000</td>
      <td>3.448276</td>
      <td>[org.axonframework.test.server]</td>
      <td>[org.axonframework.test.server.AxonServerEECon...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>13</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.testcontainers.utility</td>
      <td>1</td>
      <td>3</td>
      <td>12.5000</td>
      <td>3.448276</td>
      <td>[org.axonframework.test.server]</td>
      <td>[org.axonframework.test.server.AxonServerEECon...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>javax.annotation</td>
      <td>47</td>
      <td>221</td>
      <td>73.4375</td>
      <td>28.117048</td>
      <td>[org.axonframework.commandhandling, org.axonfr...</td>
      <td>[org.axonframework.commandhandling.CommandBus,...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>org.slf4j</td>
      <td>38</td>
      <td>78</td>
      <td>59.3750</td>
      <td>9.923664</td>
      <td>[org.axonframework.commandhandling, org.axonfr...</td>
      <td>[org.axonframework.commandhandling.SimpleComma...</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>com.fasterxml.jackson.annotation</td>
      <td>11</td>
      <td>21</td>
      <td>17.1875</td>
      <td>2.671756</td>
      <td>[org.axonframework.commandhandling.distributed...</td>
      <td>[org.axonframework.commandhandling.distributed...</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>javax.persistence</td>
      <td>7</td>
      <td>14</td>
      <td>10.9375</td>
      <td>1.781170</td>
      <td>[org.axonframework.common.legacyjpa, org.axonf...</td>
      <td>[org.axonframework.common.legacyjpa.EntityMana...</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>jakarta.persistence</td>
      <td>4</td>
      <td>13</td>
      <td>6.2500</td>
      <td>1.653944</td>
      <td>[org.axonframework.common.jpa, org.axonframewo...</td>
      <td>[org.axonframework.common.jpa.PagingJpaQueryIt...</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>2</td>
      <td>4</td>
      <td>3.1250</td>
      <td>0.508906</td>
      <td>[org.axonframework.deadline.dbscheduler, org.a...</td>
      <td>[org.axonframework.deadline.dbscheduler.DbSche...</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>2</td>
      <td>4</td>
      <td>3.1250</td>
      <td>0.508906</td>
      <td>[org.axonframework.deadline.dbscheduler, org.a...</td>
      <td>[org.axonframework.deadline.dbscheduler.DbSche...</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>com.github.kagkarlsson.scheduler.task.helper</td>
      <td>2</td>
      <td>2</td>
      <td>3.1250</td>
      <td>0.254453</td>
      <td>[org.axonframework.deadline.dbscheduler, org.a...</td>
      <td>[org.axonframework.deadline.dbscheduler.DbSche...</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>com.thoughtworks.xstream</td>
      <td>2</td>
      <td>4</td>
      <td>3.1250</td>
      <td>0.508906</td>
      <td>[org.axonframework.serialization, org.axonfram...</td>
      <td>[org.axonframework.serialization.AbstractXStre...</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>43</td>
      <td>52</td>
      <td>81.25</td>
      <td>com.thoughtworks.xstream.io</td>
      <td>2</td>
      <td>4</td>
      <td>3.1250</td>
      <td>0.508906</td>
      <td>[org.axonframework.serialization, org.axonfram...</td>
      <td>[org.axonframework.serialization.GapAwareTrack...</td>
    </tr>
  </tbody>
</table>
</div>



### Table 7a - Artifacts and their external packages (first 2 levels)

The following table groups the external packages by their first two levels. For example `javax.xml.namespace` and `javax.xml.stream` will be grouped together to `javax.xml`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>artifactPackages</th>
      <th>artifactTypes</th>
      <th>artifactExternalPackagesFirst2Levels</th>
      <th>artifactExternalCallingPackages</th>
      <th>artifactExternalCallingPackagesRate</th>
      <th>externalPackageNameFirst2Levels</th>
      <th>numberOfPackages</th>
      <th>numberOfTypes</th>
      <th>packagesCallingExternalRate</th>
      <th>typesCallingExternalRate</th>
      <th>nameOfPackages</th>
      <th>someTypeNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-configuration-4.9.3</td>
      <td>1</td>
      <td>40</td>
      <td>2</td>
      <td>1</td>
      <td>100.00</td>
      <td>javax.annotation</td>
      <td>1</td>
      <td>13</td>
      <td>100.0000</td>
      <td>32.500000</td>
      <td>[org.axonframework.config]</td>
      <td>[org.axonframework.config.AxonIQConsoleModule,...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.9.3</td>
      <td>1</td>
      <td>40</td>
      <td>2</td>
      <td>1</td>
      <td>100.00</td>
      <td>org.slf4j</td>
      <td>1</td>
      <td>6</td>
      <td>100.0000</td>
      <td>15.000000</td>
      <td>[org.axonframework.config]</td>
      <td>[org.axonframework.config.AxonIQConsoleModule,...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>100.00</td>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>100.0000</td>
      <td>4.545455</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.F...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>100.00</td>
      <td>com.lmax</td>
      <td>1</td>
      <td>7</td>
      <td>100.0000</td>
      <td>31.818182</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>100.00</td>
      <td>javax.annotation</td>
      <td>1</td>
      <td>6</td>
      <td>100.0000</td>
      <td>27.272727</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.C...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>100.00</td>
      <td>org.slf4j</td>
      <td>1</td>
      <td>8</td>
      <td>100.0000</td>
      <td>36.363636</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.C...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>7</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.hamcrest</td>
      <td>5</td>
      <td>27</td>
      <td>62.5000</td>
      <td>31.034483</td>
      <td>[org.axonframework.test.aggregate, org.axonfra...</td>
      <td>[org.axonframework.test.aggregate.ResultValida...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>7</td>
      <td>7</td>
      <td>87.50</td>
      <td>javax.annotation</td>
      <td>4</td>
      <td>10</td>
      <td>50.0000</td>
      <td>11.494253</td>
      <td>[org.axonframework.test.aggregate, org.axonfra...</td>
      <td>[org.axonframework.test.aggregate.AggregateTes...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>7</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.junit</td>
      <td>2</td>
      <td>4</td>
      <td>25.0000</td>
      <td>4.597701</td>
      <td>[org.axonframework.test.aggregate, org.axonfra...</td>
      <td>[org.axonframework.test.aggregate.StubAggregat...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>7</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.slf4j</td>
      <td>2</td>
      <td>2</td>
      <td>25.0000</td>
      <td>2.298851</td>
      <td>[org.axonframework.test.aggregate, org.axonfra...</td>
      <td>[org.axonframework.test.aggregate.AggregateTes...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>7</td>
      <td>7</td>
      <td>87.50</td>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1</td>
      <td>12.5000</td>
      <td>1.149425</td>
      <td>[org.axonframework.test.saga]</td>
      <td>[org.axonframework.test.saga.SagaTestFixture]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>7</td>
      <td>7</td>
      <td>87.50</td>
      <td>com.google</td>
      <td>1</td>
      <td>1</td>
      <td>12.5000</td>
      <td>1.149425</td>
      <td>[org.axonframework.test.server]</td>
      <td>[org.axonframework.test.server.AxonServerConta...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>7</td>
      <td>7</td>
      <td>87.50</td>
      <td>org.testcontainers</td>
      <td>1</td>
      <td>3</td>
      <td>12.5000</td>
      <td>3.448276</td>
      <td>[org.axonframework.test.server]</td>
      <td>[org.axonframework.test.server.AxonServerEECon...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>javax.annotation</td>
      <td>47</td>
      <td>221</td>
      <td>73.4375</td>
      <td>28.117048</td>
      <td>[org.axonframework.commandhandling, org.axonfr...</td>
      <td>[org.axonframework.commandhandling.CommandBus,...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>org.slf4j</td>
      <td>38</td>
      <td>78</td>
      <td>59.3750</td>
      <td>9.923664</td>
      <td>[org.axonframework.commandhandling, org.axonfr...</td>
      <td>[org.axonframework.commandhandling.SimpleComma...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>com.fasterxml</td>
      <td>12</td>
      <td>28</td>
      <td>18.7500</td>
      <td>3.562341</td>
      <td>[org.axonframework.commandhandling.distributed...</td>
      <td>[org.axonframework.commandhandling.distributed...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>javax.persistence</td>
      <td>7</td>
      <td>14</td>
      <td>10.9375</td>
      <td>1.781170</td>
      <td>[org.axonframework.common.legacyjpa, org.axonf...</td>
      <td>[org.axonframework.common.legacyjpa.EntityMana...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>jakarta.persistence</td>
      <td>4</td>
      <td>13</td>
      <td>6.2500</td>
      <td>1.653944</td>
      <td>[org.axonframework.common.jpa, org.axonframewo...</td>
      <td>[org.axonframework.common.jpa.PagingJpaQueryIt...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>com.github</td>
      <td>2</td>
      <td>6</td>
      <td>3.1250</td>
      <td>0.763359</td>
      <td>[org.axonframework.deadline.dbscheduler, org.a...</td>
      <td>[org.axonframework.deadline.dbscheduler.DbSche...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>com.thoughtworks</td>
      <td>2</td>
      <td>8</td>
      <td>3.1250</td>
      <td>1.017812</td>
      <td>[org.axonframework.serialization, org.axonfram...</td>
      <td>[org.axonframework.serialization.AbstractXStre...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>org.jobrunr</td>
      <td>2</td>
      <td>4</td>
      <td>3.1250</td>
      <td>0.508906</td>
      <td>[org.axonframework.deadline.jobrunr, org.axonf...</td>
      <td>[org.axonframework.deadline.jobrunr.JobRunrDea...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>org.quartz</td>
      <td>2</td>
      <td>9</td>
      <td>3.1250</td>
      <td>1.145038</td>
      <td>[org.axonframework.deadline.quartz, org.axonfr...</td>
      <td>[org.axonframework.deadline.quartz.DeadlineJob...</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>org.reactivestreams</td>
      <td>2</td>
      <td>13</td>
      <td>3.1250</td>
      <td>1.653944</td>
      <td>[org.axonframework.messaging.responsetypes, or...</td>
      <td>[org.axonframework.messaging.responsetypes.Res...</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>reactor.core</td>
      <td>2</td>
      <td>18</td>
      <td>3.1250</td>
      <td>2.290076</td>
      <td>[org.axonframework.messaging.responsetypes, or...</td>
      <td>[org.axonframework.messaging.responsetypes.Opt...</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>jakarta.validation</td>
      <td>1</td>
      <td>2</td>
      <td>1.5625</td>
      <td>0.254453</td>
      <td>[org.axonframework.messaging.interceptors]</td>
      <td>[org.axonframework.messaging.interceptors.Bean...</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>javax.cache</td>
      <td>1</td>
      <td>2</td>
      <td>1.5625</td>
      <td>0.254453</td>
      <td>[org.axonframework.common.caching]</td>
      <td>[org.axonframework.common.caching.JCacheAdapte...</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>javax.validation</td>
      <td>1</td>
      <td>2</td>
      <td>1.5625</td>
      <td>0.254453</td>
      <td>[org.axonframework.messaging.interceptors.lega...</td>
      <td>[org.axonframework.messaging.interceptors.lega...</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>net.sf</td>
      <td>1</td>
      <td>2</td>
      <td>1.5625</td>
      <td>0.254453</td>
      <td>[org.axonframework.common.caching]</td>
      <td>[org.axonframework.common.caching.EhCacheAdapt...</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>nu.xom</td>
      <td>1</td>
      <td>3</td>
      <td>1.5625</td>
      <td>0.381679</td>
      <td>[org.axonframework.serialization.xml]</td>
      <td>[org.axonframework.serialization.xml.XomToStri...</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>19</td>
      <td>52</td>
      <td>81.25</td>
      <td>org.dom4j</td>
      <td>1</td>
      <td>3</td>
      <td>1.5625</td>
      <td>0.381679</td>
      <td>[org.axonframework.serialization.xml]</td>
      <td>[org.axonframework.serialization.xml.InputStre...</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 7b - Top 15 external dependency using artifacts as columns with their external packages

The following table uses pivot to show the artifacts in columns, the external dependencies in rows and the number of internal packages as values.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>artifactName</th>
      <th>axon-messaging-4.9.3</th>
      <th>axon-test-4.9.3</th>
      <th>axon-modelling-4.9.3</th>
      <th>axon-eventsourcing-4.9.3</th>
      <th>axon-disruptor-4.9.3</th>
      <th>axon-configuration-4.9.3</th>
    </tr>
    <tr>
      <th>externalPackageName</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>AggregateEventPublisherImpl</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>WeakValue</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml.jackson.annotation</th>
      <td>11</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml.jackson.core</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml.jackson.databind</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml.jackson.databind.jsontype</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml.jackson.databind.module</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml.jackson.databind.node</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml.jackson.databind.type</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml.jackson.datatype.jsr310</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.github.kagkarlsson.scheduler</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.github.kagkarlsson.scheduler.task</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.github.kagkarlsson.scheduler.task.helper</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.google.gson</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.lmax.disruptor</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.lmax.disruptor.dsl</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.thoughtworks.xstream</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.thoughtworks.xstream.converters</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.thoughtworks.xstream.converters.collections</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.thoughtworks.xstream.io</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.thoughtworks.xstream.io.xml</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.thoughtworks.xstream.mapper</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>jakarta.persistence</th>
      <td>4</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>jakarta.validation</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.annotation</th>
      <td>47</td>
      <td>4</td>
      <td>4</td>
      <td>6</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>javax.cache</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.cache.configuration</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.cache.event</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.persistence</th>
      <td>7</td>
      <td>0</td>
      <td>3</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.validation</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>net.sf.ehcache</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>net.sf.ehcache.event</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>nu.xom</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.dom4j</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.dom4j.io</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.ehcache.config</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.ehcache.core</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.ehcache.event</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.hamcrest</th>
      <td>0</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.jobrunr.jobs</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.jobrunr.scheduling</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.junit.jupiter.api</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.junit.jupiter.api.extension</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.junit.rules</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.junit.runner</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.junit.runners.model</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.quartz</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.quartz.impl.matchers</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.reactivestreams</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.slf4j</th>
      <td>38</td>
      <td>2</td>
      <td>6</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>org.testcontainers.containers</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.testcontainers.containers.wait.strategy</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.testcontainers.utility</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>reactor.core</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>reactor.core.publisher</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>reactor.util.concurrent</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>reactor.util.context</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 7c - Top 15 external dependency using artifacts as columns with their external packages (first 2 levels)

The following table uses pivot to show the artifacts in columns, the external package name grouped by its first two levels in rows and the number of internal packages as values. For example `javax.xml.namespace` and `javax.xml.stream` will be grouped together to `javax.xml`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>artifactName</th>
      <th>axon-messaging-4.9.3</th>
      <th>axon-modelling-4.9.3</th>
      <th>axon-eventsourcing-4.9.3</th>
      <th>axon-test-4.9.3</th>
      <th>axon-disruptor-4.9.3</th>
      <th>axon-configuration-4.9.3</th>
    </tr>
    <tr>
      <th>externalPackageNameFirst2Levels</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>AggregateEventPublisherImpl</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>WeakValue</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml</th>
      <td>12</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.github</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.google</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.lmax</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.thoughtworks</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>jakarta.persistence</th>
      <td>4</td>
      <td>2</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>jakarta.validation</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.annotation</th>
      <td>47</td>
      <td>4</td>
      <td>6</td>
      <td>4</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>javax.cache</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.persistence</th>
      <td>7</td>
      <td>3</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.validation</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>net.sf</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>nu.xom</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.dom4j</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.ehcache</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.hamcrest</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.jobrunr</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.junit</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.quartz</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.reactivestreams</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.slf4j</th>
      <td>38</td>
      <td>6</td>
      <td>5</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>org.testcontainers</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>reactor.core</th>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>reactor.util</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 7 Chart 1 - Top 15 external dependency using artifacts and their external packages stacked

The following chart shows the top 15 external package using artifacts and breaks down which external packages they use in how many different internal packages with stacked bars. 

Note that every external dependency is counted separately so that if on internal package uses two external packages it will be displayed for both and so stacked twice.  


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependencies_files/ExternalDependencies_58_1.png)
    


#### Table 7 Chart 2 - Top 15 external dependency using artifacts and their external packages (first 2 levels) stacked

The following chart shows the top 15 external package using artifacts and breaks down which external packages (first 2 levels) are used in how many different internal packages with stacked bars. 

Note that every external dependency is counted separately so that if on internal package uses two external packages it will be displayed for both and so stacked twice.  


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependencies_files/ExternalDependencies_60_1.png)
    


### Table 8 - External usage per artifact

The following table shows the most used external packages separately for each artifact including external annotations. The results are grouped per artifact and sorted by the artifacts with the highest external type usage rate descending. Additionally, for each artifact the top 5 used external packages are listed in the top5ExternalPackages column. 

The intention of this table is to find artifacts that use a lot of external dependencies in relation to their size and get an overview per artifact with the top 5 used external packages, the number of external types and packages used etc. .

Only the last 40 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_per_artifact_sorted_top`

**Columns:**
- *artifactName* is used to group the the external package usage per artifact for a more detailed analysis.
- *numberOfTypesInArtifact* represents the total count of all analyzed types for the artifact
- *numberOfExternalTypesInArtifact* is the number of all external types that are used by the artifact
- *numberOfExternalPackagesInArtifact* is the number of all external packages that are used by the artifact
- *externalTypeRate* is the numberOfExternalTypesInArtifact / numberOfTypesInArtifact * 100
- *numberOfExternalTypeCaller* refers to the distinct types that make use of the external package
- *numberOfExternalTypeCalls* includes every invocation or reference to the types in the external package
- *numberOfExternalPackages* is the number of distinct external packages used by the artifact
- *top5ExternalPackages* contains a list of the top 5 most used external packages of the artifact
- *someExternalTypes* contains a list of lists and is also mean't to provide some examples of external types used




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>numberOfTypesInArtifact</th>
      <th>numberOfExternalTypesInArtifact</th>
      <th>numberOfExternalPackagesInArtifact</th>
      <th>externalTypeRate</th>
      <th>numberOfExternalTypeCaller</th>
      <th>numberOfExternalTypeCalls</th>
      <th>numberOfExternalPackages</th>
      <th>top5ExternalPackages</th>
      <th>someExternalTypes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-disruptor-4.9.3</td>
      <td>22</td>
      <td>13</td>
      <td>5</td>
      <td>59.090909</td>
      <td>33</td>
      <td>101</td>
      <td>5</td>
      <td>[org.slf4j, com.lmax.disruptor, javax.annotati...</td>
      <td>[Logger, LoggerFactory, RingBuffer, EventHandl...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-test-4.9.3</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>101</td>
      <td>639</td>
      <td>13</td>
      <td>[org.hamcrest, javax.annotation, org.testconta...</td>
      <td>[StringDescription, Description, Matchers, Mat...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-modelling-4.9.3</td>
      <td>156</td>
      <td>35</td>
      <td>5</td>
      <td>22.435897</td>
      <td>99</td>
      <td>382</td>
      <td>5</td>
      <td>[javax.annotation, javax.persistence, jakarta....</td>
      <td>[Nullable, Nonnull, Id, Column, Entity, Basic,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.9.3</td>
      <td>786</td>
      <td>155</td>
      <td>43</td>
      <td>19.720102</td>
      <td>753</td>
      <td>3196</td>
      <td>43</td>
      <td>[javax.annotation, org.slf4j, com.fasterxml.ja...</td>
      <td>[Nonnull, Nullable, Logger, LoggerFactory, Jso...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>133</td>
      <td>25</td>
      <td>4</td>
      <td>18.796992</td>
      <td>74</td>
      <td>242</td>
      <td>4</td>
      <td>[javax.annotation, org.slf4j, jakarta.persiste...</td>
      <td>[Nonnull, Nullable, PreDestroy, Logger, Logger...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-configuration-4.9.3</td>
      <td>40</td>
      <td>4</td>
      <td>2</td>
      <td>10.000000</td>
      <td>24</td>
      <td>137</td>
      <td>2</td>
      <td>[javax.annotation, org.slf4j]</td>
      <td>[Nonnull, Nullable, Logger, LoggerFactory]</td>
    </tr>
  </tbody>
</table>
</div>



### Table 9 - External usage per artifact and package

This table lists internal packages and the artifacts they belong to that use many different external types of a specific external package without taking external annotations into account. 

Only the last 40 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_per_artifact_and_package`

**Columns:**
- *artifactName* that contains the type that calls the external package
- *fullPackageName* is the package within the artifact that contains the type that calls the external package
- *externalPackageName* identifies the external package as described above
- *numberOfExternalTypeCaller* refers to the distinct types that make use of the external package
- *numberOfExternalTypeCalls* includes every invocation or reference to the types in the external package
- *numberOfTypesInPackage* represents the total count of all types in that package
- *externalTypeNames* contains a list of actually utilized types of the external package
- *packageName* contains the name of the package (last part of *fullPackageName*)




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>fullPackageName</th>
      <th>externalPackageName</th>
      <th>numberOfExternalTypeCaller</th>
      <th>numberOfExternalTypeCalls</th>
      <th>numberOfTypesInPackage</th>
      <th>externalTypeNames</th>
      <th>packageName</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-test-4.9.3</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.hamcrest</td>
      <td>38</td>
      <td>188</td>
      <td>24</td>
      <td>[Matcher, TypeSafeMatcher, Description, BaseMa...</td>
      <td>matchers</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>reactor.core.publisher</td>
      <td>28</td>
      <td>123</td>
      <td>48</td>
      <td>[FluxSink$OverflowStrategy, Mono, Flux, Signal...</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.deadline.quartz</td>
      <td>org.quartz</td>
      <td>20</td>
      <td>137</td>
      <td>4</td>
      <td>[JobDataMap, JobBuilder, JobDetail, SchedulerC...</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.scheduling.quartz</td>
      <td>org.quartz</td>
      <td>19</td>
      <td>95</td>
      <td>6</td>
      <td>[JobDataMap, Scheduler, SchedulerException, Jo...</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>org.slf4j</td>
      <td>16</td>
      <td>57</td>
      <td>100</td>
      <td>[Logger, LoggerFactory]</td>
      <td>eventhandling</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.pooled</td>
      <td>org.slf4j</td>
      <td>15</td>
      <td>70</td>
      <td>21</td>
      <td>[Logger, LoggerFactory]</td>
      <td>pooled</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization.json</td>
      <td>com.fasterxml.jackson.databind</td>
      <td>15</td>
      <td>73</td>
      <td>7</td>
      <td>[DeserializationContext, JsonDeserializer, Jso...</td>
      <td>json</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-disruptor-4.9.3</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>org.slf4j</td>
      <td>12</td>
      <td>22</td>
      <td>22</td>
      <td>[Logger, LoggerFactory]</td>
      <td>commandhandling</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-configuration-4.9.3</td>
      <td>org.axonframework.config</td>
      <td>org.slf4j</td>
      <td>11</td>
      <td>32</td>
      <td>40</td>
      <td>[LoggerFactory, Logger]</td>
      <td>config</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-disruptor-4.9.3</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>com.lmax.disruptor</td>
      <td>9</td>
      <td>29</td>
      <td>22</td>
      <td>[WaitStrategy, BlockingWaitStrategy, Exception...</td>
      <td>commandhandling</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-test-4.9.3</td>
      <td>org.axonframework.test.saga</td>
      <td>org.hamcrest</td>
      <td>9</td>
      <td>91</td>
      <td>21</td>
      <td>[Description, Matcher, CoreMatchers, StringDes...</td>
      <td>saga</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>org.slf4j</td>
      <td>8</td>
      <td>15</td>
      <td>10</td>
      <td>[LoggerFactory, Logger]</td>
      <td>legacyjpa</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.common.caching</td>
      <td>org.ehcache.event</td>
      <td>8</td>
      <td>33</td>
      <td>15</td>
      <td>[EventType, EventOrdering, CacheEventListener,...</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.common.caching</td>
      <td>javax.cache.event</td>
      <td>8</td>
      <td>34</td>
      <td>15</td>
      <td>[CacheEntryEventFilter, CacheEntryUpdatedListe...</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>org.slf4j</td>
      <td>8</td>
      <td>15</td>
      <td>54</td>
      <td>[Logger, LoggerFactory]</td>
      <td>annotation</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>reactor.core.publisher</td>
      <td>7</td>
      <td>34</td>
      <td>8</td>
      <td>[Mono, Flux]</td>
      <td>responsetypes</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>org.reactivestreams</td>
      <td>7</td>
      <td>27</td>
      <td>48</td>
      <td>[Publisher]</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>org.slf4j</td>
      <td>7</td>
      <td>16</td>
      <td>48</td>
      <td>[Logger, LoggerFactory]</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-test-4.9.3</td>
      <td>org.axonframework.test.aggregate</td>
      <td>org.hamcrest</td>
      <td>7</td>
      <td>136</td>
      <td>19</td>
      <td>[Matcher, Description, StringDescription, Core...</td>
      <td>aggregate</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>org.slf4j</td>
      <td>6</td>
      <td>9</td>
      <td>31</td>
      <td>[LoggerFactory, Logger]</td>
      <td>eventstore</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.deadletter</td>
      <td>org.slf4j</td>
      <td>6</td>
      <td>25</td>
      <td>5</td>
      <td>[LoggerFactory, Logger]</td>
      <td>deadletter</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>org.reactivestreams</td>
      <td>6</td>
      <td>14</td>
      <td>8</td>
      <td>[Publisher]</td>
      <td>responsetypes</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>com.thoughtworks.xstream.io</td>
      <td>6</td>
      <td>39</td>
      <td>34</td>
      <td>[HierarchicalStreamReader, HierarchicalStreamW...</td>
      <td>serialization</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>com.thoughtworks.xstream.converters</td>
      <td>6</td>
      <td>12</td>
      <td>34</td>
      <td>[UnmarshallingContext, MarshallingContext]</td>
      <td>serialization</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.modelling.saga.repository.jpa</td>
      <td>jakarta.persistence</td>
      <td>6</td>
      <td>68</td>
      <td>7</td>
      <td>[Query, EntityManager, EntityNotFoundException...</td>
      <td>jpa</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-disruptor-4.9.3</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>com.lmax.disruptor.dsl</td>
      <td>5</td>
      <td>22</td>
      <td>22</td>
      <td>[ProducerType, Disruptor, EventHandlerGroup]</td>
      <td>commandhandling</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>jakarta.persistence</td>
      <td>5</td>
      <td>42</td>
      <td>7</td>
      <td>[TypedQuery, Query, EntityManager, Index, Enti...</td>
      <td>jpa</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.common</td>
      <td>org.slf4j</td>
      <td>5</td>
      <td>15</td>
      <td>28</td>
      <td>[Logger, LoggerFactory]</td>
      <td>common</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.common.caching</td>
      <td>net.sf.ehcache</td>
      <td>5</td>
      <td>63</td>
      <td>15</td>
      <td>[CacheException, Element, Ehcache]</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.deadline.dbscheduler</td>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>5</td>
      <td>27</td>
      <td>7</td>
      <td>[TaskInstanceId, ExecutionContext, TaskWithDat...</td>
      <td>dbscheduler</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>org.slf4j</td>
      <td>5</td>
      <td>16</td>
      <td>15</td>
      <td>[Logger, LoggerFactory]</td>
      <td>async</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.deadletter.jpa</td>
      <td>jakarta.persistence</td>
      <td>5</td>
      <td>54</td>
      <td>9</td>
      <td>[TypedQuery, EntityManager, Query, NoResultExc...</td>
      <td>jpa</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.scheduling.dbs...</td>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>5</td>
      <td>25</td>
      <td>7</td>
      <td>[TaskInstanceId, TaskWithDataDescriptor, TaskI...</td>
      <td>dbscheduler</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.tokenstore.jpa</td>
      <td>jakarta.persistence</td>
      <td>5</td>
      <td>64</td>
      <td>4</td>
      <td>[LockModeType, Query, EntityManager, TypedQuery]</td>
      <td>jpa</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.tokenstore.leg...</td>
      <td>javax.persistence</td>
      <td>5</td>
      <td>64</td>
      <td>2</td>
      <td>[TypedQuery, Query, EntityManager, LockModeType]</td>
      <td>legacyjpa</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.interceptors</td>
      <td>jakarta.validation</td>
      <td>5</td>
      <td>22</td>
      <td>8</td>
      <td>[Validator, ConstraintViolation, ValidatorFact...</td>
      <td>interceptors</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.interceptors.legac...</td>
      <td>javax.validation</td>
      <td>5</td>
      <td>22</td>
      <td>2</td>
      <td>[ConstraintViolation, ValidatorFactory, Valida...</td>
      <td>legacyvalidation</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>com.thoughtworks.xstream.mapper</td>
      <td>5</td>
      <td>10</td>
      <td>34</td>
      <td>[Mapper, CannotResolveClassException]</td>
      <td>serialization</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization.xml</td>
      <td>nu.xom</td>
      <td>5</td>
      <td>16</td>
      <td>7</td>
      <td>[Document, Builder, ParsingException]</td>
      <td>xml</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.modelling.saga.repository.le...</td>
      <td>javax.persistence</td>
      <td>5</td>
      <td>66</td>
      <td>3</td>
      <td>[EntityManagerFactory, TypedQuery, EntityManag...</td>
      <td>legacyjpa</td>
    </tr>
  </tbody>
</table>
</div>



### Table 10 - Top 20 external package usage per type

This table shows internal types that utilize the most different external types and packages. These have the highest probability of change depending on external libraries. A case-by-case approach is also advisable here because there could for example also be code units that encapsulate an external library and have this high count of external dependencies on purpose.

Only the last 20 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_per_type`

**Columns:**
- *artifactName* that contains the type that calls the external package
- *fullPackageName* is the package within the artifact that contains the type that calls external types
- *typeName* identifies the internal type within the package and artifact that calls external types
- *numberOfExternalTypeCaller* and *numberOfExternalTypes* refers to the distinct external types that are used by the internal type
- *numberOfExternalTypeCalls* includes every invocation or reference to the types in the external package
- *numberOfTypesInPackage* represents the total count of all types in that package
- *numberOfExternalPackages* shows how many different external packages are used by the internal type
- *externalPackageNames* contains the list of names of the different external packages that are used by the internal type
- *externalTypeNames* contains a list of actually utilized types of the external package
- *packageName* contains the name of the package (last part of *fullPackageName*)




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>fullPackageName</th>
      <th>typeName</th>
      <th>numberOfExternalTypeCaller</th>
      <th>numberOfExternalTypeCalls</th>
      <th>numberOfExternalPackages</th>
      <th>numberOfExternalTypes</th>
      <th>externalPackageNames</th>
      <th>externalTypeNames</th>
      <th>packageName</th>
      <th>fullTypeName</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization.json</td>
      <td>JacksonSerializer</td>
      <td>9</td>
      <td>29</td>
      <td>6</td>
      <td>9</td>
      <td>[javax.annotation, com.fasterxml.jackson.datab...</td>
      <td>[javax.annotation.Nonnull, com.fasterxml.jacks...</td>
      <td>json</td>
      <td>org.axonframework.serialization.json.JacksonSe...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.deadline.dbscheduler</td>
      <td>DbSchedulerDeadlineManager</td>
      <td>12</td>
      <td>93</td>
      <td>5</td>
      <td>12</td>
      <td>[javax.annotation, org.slf4j, com.github.kagka...</td>
      <td>[javax.annotation.Nonnull, javax.annotation.Nu...</td>
      <td>dbscheduler</td>
      <td>org.axonframework.deadline.dbscheduler.DbSched...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.scheduling.dbs...</td>
      <td>DbSchedulerEventScheduler</td>
      <td>10</td>
      <td>46</td>
      <td>5</td>
      <td>10</td>
      <td>[javax.annotation, org.slf4j, com.github.kagka...</td>
      <td>[javax.annotation.Nonnull, org.slf4j.Logger, o...</td>
      <td>dbscheduler</td>
      <td>org.axonframework.eventhandling.scheduling.dbs...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization.xml</td>
      <td>XStreamSerializer</td>
      <td>7</td>
      <td>22</td>
      <td>5</td>
      <td>7</td>
      <td>[org.slf4j, com.thoughtworks.xstream, org.dom4...</td>
      <td>[org.slf4j.Logger, org.slf4j.LoggerFactory, co...</td>
      <td>xml</td>
      <td>org.axonframework.serialization.xml.XStreamSer...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.9.3</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>DisruptorCommandBus</td>
      <td>6</td>
      <td>34</td>
      <td>4</td>
      <td>6</td>
      <td>[org.slf4j, com.lmax.disruptor, javax.annotati...</td>
      <td>[org.slf4j.LoggerFactory, org.slf4j.Logger, co...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Di...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>DisruptorCommandBus$DisruptorRepository</td>
      <td>4</td>
      <td>14</td>
      <td>4</td>
      <td>4</td>
      <td>[org.slf4j, com.lmax.disruptor, javax.annotati...</td>
      <td>[org.slf4j.Logger, com.lmax.disruptor.RingBuff...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Di...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.deadline.jobrunr</td>
      <td>JobRunrDeadlineManager</td>
      <td>7</td>
      <td>29</td>
      <td>4</td>
      <td>7</td>
      <td>[javax.annotation, org.slf4j, org.jobrunr.sche...</td>
      <td>[javax.annotation.Nonnull, javax.annotation.Nu...</td>
      <td>jobrunr</td>
      <td>org.axonframework.deadline.jobrunr.JobRunrDead...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.deadline.quartz</td>
      <td>QuartzDeadlineManager</td>
      <td>13</td>
      <td>78</td>
      <td>4</td>
      <td>13</td>
      <td>[javax.annotation, org.slf4j, org.quartz, org....</td>
      <td>[javax.annotation.Nonnull, org.slf4j.Logger, o...</td>
      <td>quartz</td>
      <td>org.axonframework.deadline.quartz.QuartzDeadli...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.scheduling.job...</td>
      <td>JobRunrEventScheduler</td>
      <td>6</td>
      <td>27</td>
      <td>4</td>
      <td>6</td>
      <td>[javax.annotation, org.slf4j, org.jobrunr.sche...</td>
      <td>[javax.annotation.Nonnull, org.slf4j.Logger, o...</td>
      <td>jobrunr</td>
      <td>org.axonframework.eventhandling.scheduling.job...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>MultipleInstancesResponseType</td>
      <td>7</td>
      <td>17</td>
      <td>4</td>
      <td>7</td>
      <td>[org.slf4j, com.fasterxml.jackson.annotation, ...</td>
      <td>[org.slf4j.Logger, org.slf4j.LoggerFactory, co...</td>
      <td>responsetypes</td>
      <td>org.axonframework.messaging.responsetypes.Mult...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>SimpleQueryBus</td>
      <td>6</td>
      <td>54</td>
      <td>4</td>
      <td>6</td>
      <td>[javax.annotation, org.slf4j, org.reactivestre...</td>
      <td>[javax.annotation.Nonnull, org.slf4j.Logger, o...</td>
      <td>queryhandling</td>
      <td>org.axonframework.queryhandling.SimpleQueryBus</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>SimpleQueryUpdateEmitter</td>
      <td>13</td>
      <td>33</td>
      <td>4</td>
      <td>13</td>
      <td>[javax.annotation, org.slf4j, org.reactivestre...</td>
      <td>[javax.annotation.Nonnull, org.slf4j.Logger, o...</td>
      <td>queryhandling</td>
      <td>org.axonframework.queryhandling.SimpleQueryUpd...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>AbstractXStreamSerializer$MetaDataConverter</td>
      <td>6</td>
      <td>14</td>
      <td>4</td>
      <td>6</td>
      <td>[com.thoughtworks.xstream.converters.collectio...</td>
      <td>[com.thoughtworks.xstream.converters.collectio...</td>
      <td>serialization</td>
      <td>org.axonframework.serialization.AbstractXStrea...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>GapAwareTrackingTokenConverter$ReflectivelyCon...</td>
      <td>6</td>
      <td>25</td>
      <td>4</td>
      <td>6</td>
      <td>[com.thoughtworks.xstream.mapper, com.thoughtw...</td>
      <td>[com.thoughtworks.xstream.mapper.Mapper, com.t...</td>
      <td>serialization</td>
      <td>org.axonframework.serialization.GapAwareTracki...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>GapAwareTrackingTokenConverter</td>
      <td>6</td>
      <td>25</td>
      <td>4</td>
      <td>6</td>
      <td>[com.thoughtworks.xstream.mapper, com.thoughtw...</td>
      <td>[com.thoughtworks.xstream.mapper.Mapper, com.t...</td>
      <td>serialization</td>
      <td>org.axonframework.serialization.GapAwareTracki...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization.json</td>
      <td>MetaDataDeserializer</td>
      <td>6</td>
      <td>21</td>
      <td>4</td>
      <td>6</td>
      <td>[com.fasterxml.jackson.databind.type, com.fast...</td>
      <td>[com.fasterxml.jackson.databind.type.TypeFacto...</td>
      <td>json</td>
      <td>org.axonframework.serialization.json.MetaDataD...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-disruptor-4.9.3</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>BlacklistDetectingCallback</td>
      <td>4</td>
      <td>11</td>
      <td>3</td>
      <td>4</td>
      <td>[org.slf4j, com.lmax.disruptor, javax.annotation]</td>
      <td>[org.slf4j.LoggerFactory, org.slf4j.Logger, co...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Bl...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-disruptor-4.9.3</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>DisruptorCommandBus$ExceptionHandler</td>
      <td>3</td>
      <td>5</td>
      <td>3</td>
      <td>3</td>
      <td>[org.slf4j, com.lmax.disruptor.dsl, com.lmax.d...</td>
      <td>[org.slf4j.Logger, com.lmax.disruptor.dsl.Disr...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Di...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>JpaEventStorageEngine</td>
      <td>6</td>
      <td>47</td>
      <td>3</td>
      <td>6</td>
      <td>[javax.annotation, org.slf4j, jakarta.persiste...</td>
      <td>[javax.annotation.Nonnull, org.slf4j.Logger, o...</td>
      <td>jpa</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>JpaEventStorageEngine</td>
      <td>6</td>
      <td>47</td>
      <td>3</td>
      <td>6</td>
      <td>[javax.annotation, org.slf4j, javax.persistence]</td>
      <td>[javax.annotation.Nonnull, org.slf4j.Logger, o...</td>
      <td>legacyjpa</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
    </tr>
  </tbody>
</table>
</div>



### Table 11 - External package usage distribution per type

This table shows how many types use one external package, how many use two, etc. .
This gives an overview of the distribution of external package calls and the overall coupling to external libraries. The higher the count of distinct external packages the lower should be the count of types that use them. Dependencies to external annotations are left out here.

More details about which types have the highest external package dependency usage can be in the tables 4 and 5 above.

Only the last 40 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_per_artifact_distribution`

**Columns:**
- *artifactName* that contains the type that calls the external package
- *artifactTypes* the total count of types in the artifact
- *numberOfExternalPackages* the number of distinct external packages used
- *numberOfTypes* in the artifact where the *numberOfExternalPackages* applies
- *numberOfTypesPercentage* in the artifact where the *numberOfExternalPackages* applies in %




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>artifactPackages</th>
      <th>artifactTypes</th>
      <th>numberOfExternalPackages</th>
      <th>numberOfPackages</th>
      <th>numberOfTypes</th>
      <th>typesCallingExternalRate</th>
      <th>packagesCallingExternalRate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>786</td>
      <td>42</td>
      <td>44</td>
      <td>155</td>
      <td>19.720102</td>
      <td>68.750000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3</td>
      <td>10</td>
      <td>156</td>
      <td>3</td>
      <td>7</td>
      <td>12</td>
      <td>7.692308</td>
      <td>70.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>87</td>
      <td>12</td>
      <td>6</td>
      <td>36</td>
      <td>41.379310</td>
      <td>75.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>5</td>
      <td>15</td>
      <td>11.278195</td>
      <td>55.555556</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.9.3</td>
      <td>1</td>
      <td>40</td>
      <td>1</td>
      <td>1</td>
      <td>6</td>
      <td>15.000000</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>10</td>
      <td>45.454545</td>
      <td>100.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 12 - External package usage per artifact grouped by number of internal packages

The following table shows the external package usage for every artifact grouped by the number of distinct internal dependent packages. The intention is to find external package usage spread across multiple internal packages in artifacts. 

Artifacts that encapsulate external dependency calls in one internal package overall (or each) are easier to change if those external dependencies change and are most likely applying a [Hexagonal architecture](https://alistair.cockburn.us/hexagonal-architecture). Artifacts that use external dependencies in multiple internal packages need more effort to adapt to changes of those external dependencies. On one hand this could be intended e.g. when using standardized libraries. On the other hand this might indicate higher than necessary coupling.

The whole table can be found in the following CSV report:
`External_package_usage_per_internal_package_count`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>artifactName</th>
      <th>axon-eventsourcing-4.9.3</th>
      <th>axon-messaging-4.9.3</th>
      <th>axon-modelling-4.9.3</th>
      <th>axon-test-4.9.3</th>
    </tr>
    <tr>
      <th>numberOfPackages</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>22.222222</td>
      <td>3.1250</td>
      <td>20.0</td>
      <td>25.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>33.333333</td>
      <td>0.0000</td>
      <td>30.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.000000</td>
      <td>6.2500</td>
      <td>40.0</td>
      <td>50.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>55.555556</td>
      <td>0.0000</td>
      <td>0.0</td>
      <td>62.5</td>
    </tr>
    <tr>
      <th>6</th>
      <td>66.666667</td>
      <td>0.0000</td>
      <td>60.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0.000000</td>
      <td>10.9375</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>0.000000</td>
      <td>17.1875</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>38</th>
      <td>0.000000</td>
      <td>59.3750</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>47</th>
      <td>0.000000</td>
      <td>73.4375</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 13 - External package usage aggregated

This table lists all artifacts and their external package dependencies usage aggregated over internal packages. 

The intention behind this is to find artifacts that use an external dependency across multiple internal packages. This might be intended for frameworks and standardized libraries and helps to quantify how widely those are used. For some external dependencies it might be beneficial to only access it from one package and provide an abstraction for internal usage following a [Hexagonal architecture](https://alistair.cockburn.us/hexagonal-architecture). Thus, this table may also help in finding application for the Hexagonal architecture or similar approaches (Domain Driven Design Anti Corruption Layer). After all it is easier to update or replace such external dependencies when they are used in specific areas and not all over the code.

Only the last 40 entries are shown. The whole table can be found in the following CSV report:
`External_package_usage_per_artifact_package_aggregated`

**Columns:**
- *artifactName* that contains the type that calls the external package
- *artifactPackages* is the total count of packages in the artifact
- *artifactTypes* is the total count of types in the artifact
- *numberOfExternalPackages* the number of distinct external packages used
- *[min,max,med,avg,std]NumberOfPackages* provide statistics based on each external package and its package usage within the artifact
- *[min,max,med,avg,std]NumberOfPackagesPercentage* provide statistics in % based on each external package and its package usage within the artifact in respect to the overall count of packages in the artifact
- *[min,max,med,avg,std]NumberOfTypes* provide statistics based on each external package and its type usage within the artifact
- *[min,max,med,avg,std]NumberOfTypePercentage* provide statistics in % based on each external package and its type usage within the artifact in respect to the overall count of packages in the artifact
- *numberOfTypes* in the artifact where the *numberOfExternalPackages* applies
- *numberOfTypesPercentage* in the artifact where the *numberOfExternalPackages* applies in %

#### Table 13a - External package usage aggregated - count of internal packages




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>artifactPackages</th>
      <th>numberOfExternalPackages</th>
      <th>minNumberOfPackages</th>
      <th>medNumberOfPackages</th>
      <th>avgNumberOfPackages</th>
      <th>maxNumberOfPackages</th>
      <th>stdNumberOfPackages</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>42</td>
      <td>1</td>
      <td>1.0</td>
      <td>2.285714</td>
      <td>38</td>
      <td>5.688181</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3</td>
      <td>10</td>
      <td>3</td>
      <td>2</td>
      <td>3.0</td>
      <td>3.666667</td>
      <td>6</td>
      <td>2.081666</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>9</td>
      <td>3</td>
      <td>1</td>
      <td>2.0</td>
      <td>2.666667</td>
      <td>5</td>
      <td>2.081666</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>12</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.416667</td>
      <td>5</td>
      <td>1.164500</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.9.3</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>1</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>4</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>1</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 13b - External package usage aggregated - percentage of internal packages




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>artifactPackages</th>
      <th>numberOfExternalPackages</th>
      <th>minNumberOfPackagesPercentage</th>
      <th>medNumberOfPackagesPercentage</th>
      <th>avgNumberOfPackagesPercentage</th>
      <th>maxNumberOfPackagesPercentage</th>
      <th>stdNumberOfPackagesPercentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3</td>
      <td>64</td>
      <td>42</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>3.571429</td>
      <td>59.375000</td>
      <td>8.887782</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3</td>
      <td>10</td>
      <td>3</td>
      <td>20.000000</td>
      <td>30.000000</td>
      <td>36.666667</td>
      <td>60.000000</td>
      <td>20.816660</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>9</td>
      <td>3</td>
      <td>11.111111</td>
      <td>22.222222</td>
      <td>29.629630</td>
      <td>55.555556</td>
      <td>23.129622</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.9.3</td>
      <td>8</td>
      <td>12</td>
      <td>12.500000</td>
      <td>12.500000</td>
      <td>17.708333</td>
      <td>62.500000</td>
      <td>14.556252</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.9.3</td>
      <td>1</td>
      <td>1</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3</td>
      <td>1</td>
      <td>4</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 13c - External package usage aggregated - count of internal types




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>artifactTypes</th>
      <th>numberOfExternalPackages</th>
      <th>minNumberOfTypes</th>
      <th>medNumberOfTypes</th>
      <th>avgNumberOfTypes</th>
      <th>maxNumberOfTypes</th>
      <th>stdNumberOfTypes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3</td>
      <td>786</td>
      <td>42</td>
      <td>1</td>
      <td>2.5</td>
      <td>5.309524</td>
      <td>78</td>
      <td>11.984722</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3</td>
      <td>156</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>5.000000</td>
      <td>9</td>
      <td>3.464102</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>133</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>6.666667</td>
      <td>14</td>
      <td>6.350853</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.9.3</td>
      <td>87</td>
      <td>12</td>
      <td>1</td>
      <td>1.5</td>
      <td>3.833333</td>
      <td>27</td>
      <td>7.346407</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.9.3</td>
      <td>40</td>
      <td>1</td>
      <td>6</td>
      <td>6.0</td>
      <td>6.000000</td>
      <td>6</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>5.5</td>
      <td>5.000000</td>
      <td>8</td>
      <td>3.162278</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 13d - External package usage aggregated - percentage of internal types




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>artifactTypes</th>
      <th>numberOfExternalPackages</th>
      <th>minNumberOfTypesPercentage</th>
      <th>medNumberOfTypesPercentage</th>
      <th>avgNumberOfTypesPercentage</th>
      <th>maxNumberOfTypesPercentage</th>
      <th>stdNumberOfTypesPercentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3</td>
      <td>786</td>
      <td>42</td>
      <td>0.127226</td>
      <td>0.318066</td>
      <td>0.675512</td>
      <td>9.923664</td>
      <td>1.524774</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3</td>
      <td>156</td>
      <td>3</td>
      <td>1.923077</td>
      <td>1.923077</td>
      <td>3.205128</td>
      <td>5.769231</td>
      <td>2.220578</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>133</td>
      <td>3</td>
      <td>2.255639</td>
      <td>2.255639</td>
      <td>5.012531</td>
      <td>10.526316</td>
      <td>4.775077</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.9.3</td>
      <td>87</td>
      <td>12</td>
      <td>1.149425</td>
      <td>1.724138</td>
      <td>4.406130</td>
      <td>31.034483</td>
      <td>8.444146</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.9.3</td>
      <td>40</td>
      <td>1</td>
      <td>15.000000</td>
      <td>15.000000</td>
      <td>15.000000</td>
      <td>15.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3</td>
      <td>22</td>
      <td>4</td>
      <td>4.545455</td>
      <td>25.000000</td>
      <td>22.727273</td>
      <td>36.363636</td>
      <td>14.373989</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 13 Chart 1 - External package usage - max percentage of internal types

This chart shows per artifact the maximum percentage of internal packages (compared to all packages in that artifact) that use one specific external package. 

**Example:** One artifact might use 10 external packages where 7 of them are used in one internal package, 2 of them are used in two packages and one external dependency is used in 5 packages. So for this artifact there will be a point at x = 10 (external packages used by the artifact) and 5 (max internal packages). Instead of the count the percentage of internal packages compared to all packages in that artifact is used to get a normalized plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependencies_files/ExternalDependencies_82_1.png)
    


#### Table 13 Chart 2 - External package usage - median percentage of internal types

This chart shows per artifact the median (0.5 percentile) of internal packages (compared to all packages in that artifact) that use one specific external package. 

**Example:** One artifact might use 9 external packages where 3 of them are used in 1 internal package, 3 of them are used in 2 package and the last 3 ones are used in 3 packages. So for this artifact there will be a point at x = 10 (external packages used by the artifact) and 2 (median internal packages). Instead of the count the percentage of internal packages compared to all packages in that artifact is used to get a normalized plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependencies_files/ExternalDependencies_84_1.png)
    


## Maven POMs


### Table 14 - Maven POMs and their declared dependencies

If Maven is used as for package and dependency management and a ".pom" file is included in the artifact, the following table shows the external dependencies that are declared there.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>pom.artifactId</th>
      <th>pom.name</th>
      <th>scope</th>
      <th>dependency.optional</th>
      <th>dependentArtifact.group</th>
      <th>dependentArtifact.name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>default</td>
      <td>True</td>
      <td>jakarta.annotation</td>
      <td>jakarta.annotation-api</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>test</td>
      <td>False</td>
      <td>org.hibernate</td>
      <td>hibernate-core-jakarta</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>default</td>
      <td>False</td>
      <td>org.axonframework</td>
      <td>axon-messaging</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>default</td>
      <td>False</td>
      <td>${project.groupId}</td>
      <td>axon-disruptor</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>default</td>
      <td>False</td>
      <td>org.axonframework</td>
      <td>axon-modelling</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>111</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>True</td>
      <td>org.hamcrest</td>
      <td>hamcrest-library</td>
    </tr>
    <tr>
      <th>112</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>True</td>
      <td>org.hamcrest</td>
      <td>hamcrest</td>
    </tr>
    <tr>
      <th>113</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>True</td>
      <td>junit</td>
      <td>junit</td>
    </tr>
    <tr>
      <th>114</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>False</td>
      <td>org.junit.jupiter</td>
      <td>junit-jupiter</td>
    </tr>
    <tr>
      <th>115</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>test</td>
      <td>False</td>
      <td>jakarta.persistence</td>
      <td>jakarta.persistence-api</td>
    </tr>
  </tbody>
</table>
<p>116 rows × 6 columns</p>
</div>


