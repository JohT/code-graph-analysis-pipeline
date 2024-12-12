# External Dependencies for Java
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
      <td>76</td>
      <td>342</td>
      <td>374</td>
      <td>1731</td>
      <td>114</td>
      <td>1440</td>
      <td>[Nonnull, Nullable, PreDestroy]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.slf4j</td>
      <td>66</td>
      <td>142</td>
      <td>255</td>
      <td>718</td>
      <td>114</td>
      <td>1440</td>
      <td>[LoggerFactory, Logger]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>15</td>
      <td>27</td>
      <td>82</td>
      <td>311</td>
      <td>114</td>
      <td>1440</td>
      <td>[Id, IdClass, MappedSuperclass, Entity, Index,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>13</td>
      <td>23</td>
      <td>57</td>
      <td>87</td>
      <td>114</td>
      <td>1440</td>
      <td>[JsonTypeInfo, JsonTypeInfo$Id, JsonGetter, Js...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>jakarta.persistence</td>
      <td>10</td>
      <td>25</td>
      <td>73</td>
      <td>299</td>
      <td>114</td>
      <td>1440</td>
      <td>[MappedSuperclass, IdClass, Id, Entity, Query,...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>io.axoniq.axonserver.grpc</td>
      <td>7</td>
      <td>30</td>
      <td>55</td>
      <td>273</td>
      <td>114</td>
      <td>1440</td>
      <td>[ErrorMessage, ErrorMessage$Builder, Instructi...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>io.axoniq.axonserver.connector</td>
      <td>6</td>
      <td>21</td>
      <td>30</td>
      <td>126</td>
      <td>114</td>
      <td>1440</td>
      <td>[AxonServerConnectionFactory$Builder, AxonServ...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.hamcrest</td>
      <td>5</td>
      <td>27</td>
      <td>59</td>
      <td>370</td>
      <td>114</td>
      <td>1440</td>
      <td>[Matcher, StringDescription, Description, Core...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>io.grpc</td>
      <td>4</td>
      <td>12</td>
      <td>50</td>
      <td>94</td>
      <td>114</td>
      <td>1440</td>
      <td>[ManagedChannelBuilder, Channel, Metadata$Key,...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>reactor.core.publisher</td>
      <td>4</td>
      <td>27</td>
      <td>49</td>
      <td>198</td>
      <td>114</td>
      <td>1440</td>
      <td>[Mono, Flux, SignalType, BaseSubscriber, FluxS...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>3</td>
      <td>5</td>
      <td>8</td>
      <td>49</td>
      <td>114</td>
      <td>1440</td>
      <td>[ScheduledExecution, Scheduler, SchedulerState]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>3</td>
      <td>5</td>
      <td>11</td>
      <td>44</td>
      <td>114</td>
      <td>1440</td>
      <td>[ExecutionContext, TaskInstance, TaskWithDataD...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>io.grpc.stub</td>
      <td>3</td>
      <td>6</td>
      <td>7</td>
      <td>27</td>
      <td>114</td>
      <td>1440</td>
      <td>[StreamObserver, ClientResponseObserver, Clien...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.jobrunr.scheduling</td>
      <td>3</td>
      <td>5</td>
      <td>7</td>
      <td>34</td>
      <td>114</td>
      <td>1440</td>
      <td>[JobScheduler, JobBuilder]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.springframework.boot.actuate.health</td>
      <td>3</td>
      <td>4</td>
      <td>7</td>
      <td>24</td>
      <td>114</td>
      <td>1440</td>
      <td>[Status, Health$Builder, AbstractHealthIndicat...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.springframework.boot.autoconfigure</td>
      <td>3</td>
      <td>24</td>
      <td>54</td>
      <td>55</td>
      <td>114</td>
      <td>1440</td>
      <td>[AutoConfigurationPackages, AutoConfiguration,...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.springframework.boot.autoconfigure.condition</td>
      <td>3</td>
      <td>32</td>
      <td>65</td>
      <td>152</td>
      <td>114</td>
      <td>1440</td>
      <td>[ConditionOutcome, SpringBootCondition, Condit...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.springframework.context.annotation</td>
      <td>3</td>
      <td>30</td>
      <td>41</td>
      <td>135</td>
      <td>114</td>
      <td>1440</td>
      <td>[Import, Conditional, ImportBeanDefinitionRegi...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>2</td>
      <td>9</td>
      <td>17</td>
      <td>75</td>
      <td>114</td>
      <td>1440</td>
      <td>[JsonNode, ObjectMapper$DefaultTyping, Deseria...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.thoughtworks.xstream.io</td>
      <td>2</td>
      <td>4</td>
      <td>9</td>
      <td>39</td>
      <td>114</td>
      <td>1440</td>
      <td>[HierarchicalStreamReader, HierarchicalStreamW...</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 1 Chart 1a - Most called external packages in % by types (more than 0.7% overall)

External packages that are used less than 0.7% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_16_1.png)
    


#### Table 1 Chart 1b - Most called external packages in % by types (less than 0.7% overall "others" drill-down)

Shows the lowest (less than 0.7% overall) most called external package. Therefore, this plot breaks down the "others" slice of the pie chart above. Values under 0.3% from that will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_18_1.png)
    


#### Table 1 Chart 2a - Most called external packages in % by packages (more than 0.7% overall)

External packages that are used less than 0.7% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_20_1.png)
    


#### Table 1 Chart 2b - Most called external packages in % by packages (less than 0.7% overall "others" drill-down)

Shows the lowest (less than 0.7% overall) most called external package. Therefore, this plot breaks down the "others" slice of the pie chart above. Values under 0.3% from that will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_22_1.png)
    


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
      <td>76</td>
      <td>342</td>
      <td>374</td>
      <td>1731</td>
      <td>114</td>
      <td>1440</td>
      <td>[Nonnull, Nullable, PreDestroy]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.slf4j</td>
      <td>66</td>
      <td>142</td>
      <td>255</td>
      <td>718</td>
      <td>114</td>
      <td>1440</td>
      <td>[LoggerFactory, Logger]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>com.fasterxml</td>
      <td>15</td>
      <td>33</td>
      <td>89</td>
      <td>199</td>
      <td>114</td>
      <td>1440</td>
      <td>[JsonTypeInfo, JsonTypeInfo$Id, JsonGetter, Js...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>javax.persistence</td>
      <td>15</td>
      <td>27</td>
      <td>82</td>
      <td>311</td>
      <td>114</td>
      <td>1440</td>
      <td>[Id, IdClass, MappedSuperclass, Entity, Index,...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>jakarta.persistence</td>
      <td>10</td>
      <td>25</td>
      <td>73</td>
      <td>299</td>
      <td>114</td>
      <td>1440</td>
      <td>[MappedSuperclass, IdClass, Id, Entity, Query,...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>io.axoniq</td>
      <td>9</td>
      <td>67</td>
      <td>198</td>
      <td>984</td>
      <td>114</td>
      <td>1440</td>
      <td>[NodeInfo$Builder, NodeInfo, ServerAddress, Ax...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.springframework</td>
      <td>8</td>
      <td>53</td>
      <td>245</td>
      <td>528</td>
      <td>114</td>
      <td>1440</td>
      <td>[ConfigurationProperties, Status, Health$Build...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>io.grpc</td>
      <td>5</td>
      <td>18</td>
      <td>61</td>
      <td>126</td>
      <td>114</td>
      <td>1440</td>
      <td>[SslContextBuilder, GrpcSslContexts, ManagedCh...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.hamcrest</td>
      <td>5</td>
      <td>27</td>
      <td>59</td>
      <td>370</td>
      <td>114</td>
      <td>1440</td>
      <td>[Matcher, StringDescription, Description, Core...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>reactor.core</td>
      <td>5</td>
      <td>28</td>
      <td>53</td>
      <td>203</td>
      <td>114</td>
      <td>1440</td>
      <td>[Scheduler, Schedulers, Mono, Flux, SignalType...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.google</td>
      <td>4</td>
      <td>9</td>
      <td>12</td>
      <td>18</td>
      <td>114</td>
      <td>1440</td>
      <td>[ByteString, Strings, JsonParser, JsonObject, ...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>com.github</td>
      <td>3</td>
      <td>7</td>
      <td>21</td>
      <td>107</td>
      <td>114</td>
      <td>1440</td>
      <td>[ExecutionContext, TaskInstance, Tasks$OneTime...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.thoughtworks</td>
      <td>3</td>
      <td>10</td>
      <td>33</td>
      <td>121</td>
      <td>114</td>
      <td>1440</td>
      <td>[XStream, HierarchicalStreamReader, Unmarshall...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.jobrunr</td>
      <td>3</td>
      <td>5</td>
      <td>7</td>
      <td>34</td>
      <td>114</td>
      <td>1440</td>
      <td>[JobScheduler, JobBuilder]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework</td>
      <td>2</td>
      <td>7</td>
      <td>17</td>
      <td>59</td>
      <td>114</td>
      <td>1440</td>
      <td>[SpringUtils, MetricsConfigurerModule, GlobalM...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.junit</td>
      <td>2</td>
      <td>4</td>
      <td>8</td>
      <td>14</td>
      <td>114</td>
      <td>1440</td>
      <td>[Statement, Description, TestRule, ExtensionCo...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.quartz</td>
      <td>2</td>
      <td>9</td>
      <td>36</td>
      <td>187</td>
      <td>114</td>
      <td>1440</td>
      <td>[Scheduler, JobExecutionContext, SchedulerCont...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.lmax</td>
      <td>1</td>
      <td>7</td>
      <td>14</td>
      <td>46</td>
      <td>114</td>
      <td>1440</td>
      <td>[ExceptionHandler, Disruptor, RingBuffer, Wait...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>io.micrometer</td>
      <td>1</td>
      <td>1</td>
      <td>2</td>
      <td>6</td>
      <td>114</td>
      <td>1440</td>
      <td>[SimpleMeterRegistry, MeterRegistry]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>io.opentelemetry</td>
      <td>1</td>
      <td>5</td>
      <td>21</td>
      <td>74</td>
      <td>114</td>
      <td>1440</td>
      <td>[Span, SpanContext, Scope, StatusCode, SpanBui...</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 2 Chart 1a - Most called second level external packages in % by type

External package groups that are used less than 0.7% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_26_1.png)
    


#### Table 2 Chart 1b - Most called second level external packages in % by type (less than 0.7% overall "others" drill-down)

Shows the lowest (less than 0.7% overall) most called external package. Therefore, this plot breaks down the "others" slice of the pie chart above. Values under 0.3% from that will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_28_1.png)
    


#### Table 2 Chart 2a - Most called second level external packages in % by package (more than 0.7% overall)

External package groups that are used less than 0.7% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_30_1.png)
    


#### Table 2 Chart 2b - Most called second level external packages in % by package (less than 0.7% overall "others" drill-down)

Shows the lowest (less than 0.7% overall) most called external package. Therefore, this plot breaks down the "others" slice of the pie chart above. Values under 0.3% from that will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_32_1.png)
    


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
      <td>9</td>
      <td>66</td>
      <td>1</td>
      <td>38</td>
      <td>3.0</td>
      <td>7.333333</td>
      <td>11.821590</td>
      <td>25.000000</td>
      <td>100.000000</td>
      <td>...</td>
      <td>79</td>
      <td>8.0</td>
      <td>15.777778</td>
      <td>24.391483</td>
      <td>2.298851</td>
      <td>36.363636</td>
      <td>10.526316</td>
      <td>13.253838</td>
      <td>10.249529</td>
      <td>[axon-server-connector-4.10.2, axon-tracing-op...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>4</td>
      <td>8</td>
      <td>1</td>
      <td>3</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.816497</td>
      <td>4.687500</td>
      <td>22.222222</td>
      <td>...</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.250000</td>
      <td>2.500000</td>
      <td>1.016518</td>
      <td>4.000000</td>
      <td>2.077187</td>
      <td>2.292723</td>
      <td>1.251678</td>
      <td>[axon-eventsourcing-4.10.2, axon-messaging-4.1...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>4</td>
      <td>11</td>
      <td>2</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.750000</td>
      <td>0.957427</td>
      <td>6.250000</td>
      <td>30.000000</td>
      <td>...</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.250000</td>
      <td>2.500000</td>
      <td>1.016518</td>
      <td>4.000000</td>
      <td>2.077187</td>
      <td>2.292723</td>
      <td>1.251678</td>
      <td>[axon-eventsourcing-4.10.2, axon-messaging-4.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>2</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.562500</td>
      <td>11.111111</td>
      <td>...</td>
      <td>7</td>
      <td>4.5</td>
      <td>4.500000</td>
      <td>3.535534</td>
      <td>0.889454</td>
      <td>2.666667</td>
      <td>1.778060</td>
      <td>1.778060</td>
      <td>1.256679</td>
      <td>[axon-messaging-4.10.2, axon-spring-boot-autoc...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>2</td>
      <td>3</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>...</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
      <td>0.508259</td>
      <td>1.333333</td>
      <td>0.920796</td>
      <td>0.920796</td>
      <td>0.583416</td>
      <td>[axon-messaging-4.10.2, axon-spring-boot-autoc...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>2</td>
      <td>3</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>...</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
      <td>0.508259</td>
      <td>1.333333</td>
      <td>0.920796</td>
      <td>0.920796</td>
      <td>0.583416</td>
      <td>[axon-messaging-4.10.2, axon-spring-boot-autoc...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.thoughtworks.xstream</td>
      <td>2</td>
      <td>3</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>...</td>
      <td>4</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>1.414214</td>
      <td>0.508259</td>
      <td>2.666667</td>
      <td>1.587463</td>
      <td>1.587463</td>
      <td>1.526225</td>
      <td>[axon-messaging-4.10.2, axon-spring-boot-autoc...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>io.axoniq.axonserver.connector.event</td>
      <td>2</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>9.090909</td>
      <td>11.111111</td>
      <td>...</td>
      <td>11</td>
      <td>6.5</td>
      <td>6.500000</td>
      <td>6.363961</td>
      <td>2.666667</td>
      <td>8.333333</td>
      <td>5.500000</td>
      <td>5.500000</td>
      <td>4.006938</td>
      <td>[axon-server-connector-4.10.2, axon-spring-boo...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>io.axoniq.axonserver.connector.impl</td>
      <td>2</td>
      <td>4</td>
      <td>1</td>
      <td>3</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>1.414214</td>
      <td>11.111111</td>
      <td>27.272727</td>
      <td>...</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
      <td>1.333333</td>
      <td>3.030303</td>
      <td>2.181818</td>
      <td>2.181818</td>
      <td>1.199939</td>
      <td>[axon-server-connector-4.10.2, axon-spring-boo...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.jobrunr.scheduling</td>
      <td>2</td>
      <td>3</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>...</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
      <td>0.508259</td>
      <td>1.333333</td>
      <td>0.920796</td>
      <td>0.920796</td>
      <td>0.583416</td>
      <td>[axon-messaging-4.10.2, axon-spring-boot-autoc...</td>
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
      <td>9</td>
      <td>1</td>
      <td>38</td>
      <td>3.0</td>
      <td>7.333333</td>
      <td>11.821590</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>4</td>
      <td>1</td>
      <td>3</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.816497</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>4</td>
      <td>2</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.750000</td>
      <td>0.957427</td>
    </tr>
    <tr>
      <th>3</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>2</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>2</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.thoughtworks.xstream</td>
      <td>2</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
    </tr>
    <tr>
      <th>7</th>
      <td>io.axoniq.axonserver.connector.event</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>io.axoniq.axonserver.connector.impl</td>
      <td>2</td>
      <td>1</td>
      <td>3</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>1.414214</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.jobrunr.scheduling</td>
      <td>2</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.reactivestreams</td>
      <td>2</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
    </tr>
    <tr>
      <th>11</th>
      <td>reactor.core.publisher</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.codahale.metrics</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
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
      <td>9</td>
      <td>25.000000</td>
      <td>100.000000</td>
      <td>60.000000</td>
      <td>68.342452</td>
      <td>28.735691</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>4</td>
      <td>4.687500</td>
      <td>22.222222</td>
      <td>15.555556</td>
      <td>14.505208</td>
      <td>8.116903</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>4</td>
      <td>6.250000</td>
      <td>30.000000</td>
      <td>22.222222</td>
      <td>20.173611</td>
      <td>9.980289</td>
    </tr>
    <tr>
      <th>3</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>2</td>
      <td>1.562500</td>
      <td>11.111111</td>
      <td>6.336806</td>
      <td>6.336806</td>
      <td>6.751888</td>
    </tr>
    <tr>
      <th>4</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>2</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>7.118056</td>
      <td>7.118056</td>
      <td>5.647033</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>2</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>7.118056</td>
      <td>7.118056</td>
      <td>5.647033</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.thoughtworks.xstream</td>
      <td>2</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>7.118056</td>
      <td>7.118056</td>
      <td>5.647033</td>
    </tr>
    <tr>
      <th>7</th>
      <td>io.axoniq.axonserver.connector.event</td>
      <td>2</td>
      <td>9.090909</td>
      <td>11.111111</td>
      <td>10.101010</td>
      <td>10.101010</td>
      <td>1.428499</td>
    </tr>
    <tr>
      <th>8</th>
      <td>io.axoniq.axonserver.connector.impl</td>
      <td>2</td>
      <td>11.111111</td>
      <td>27.272727</td>
      <td>19.191919</td>
      <td>19.191919</td>
      <td>11.427988</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.jobrunr.scheduling</td>
      <td>2</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>7.118056</td>
      <td>7.118056</td>
      <td>5.647033</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.reactivestreams</td>
      <td>2</td>
      <td>3.125000</td>
      <td>9.090909</td>
      <td>6.107955</td>
      <td>6.107955</td>
      <td>4.218535</td>
    </tr>
    <tr>
      <th>11</th>
      <td>reactor.core.publisher</td>
      <td>2</td>
      <td>3.125000</td>
      <td>18.181818</td>
      <td>10.653409</td>
      <td>10.653409</td>
      <td>10.646778</td>
    </tr>
    <tr>
      <th>12</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>12.500000</td>
      <td>12.500000</td>
      <td>12.500000</td>
      <td>12.500000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.codahale.metrics</td>
      <td>1</td>
      <td>11.111111</td>
      <td>11.111111</td>
      <td>11.111111</td>
      <td>11.111111</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>1</td>
      <td>4.687500</td>
      <td>4.687500</td>
      <td>4.687500</td>
      <td>4.687500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>1</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>1</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>1</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>1.562500</td>
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
      <td>9</td>
      <td>1</td>
      <td>79</td>
      <td>8.0</td>
      <td>15.777778</td>
      <td>24.391483</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>4</td>
      <td>3</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.250000</td>
      <td>2.500000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>4</td>
      <td>3</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.250000</td>
      <td>2.500000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>2</td>
      <td>2</td>
      <td>7</td>
      <td>4.5</td>
      <td>4.500000</td>
      <td>3.535534</td>
    </tr>
    <tr>
      <th>4</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>2</td>
      <td>1</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>2</td>
      <td>1</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.thoughtworks.xstream</td>
      <td>2</td>
      <td>2</td>
      <td>4</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>1.414214</td>
    </tr>
    <tr>
      <th>7</th>
      <td>io.axoniq.axonserver.connector.event</td>
      <td>2</td>
      <td>2</td>
      <td>11</td>
      <td>6.5</td>
      <td>6.500000</td>
      <td>6.363961</td>
    </tr>
    <tr>
      <th>8</th>
      <td>io.axoniq.axonserver.connector.impl</td>
      <td>2</td>
      <td>1</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.jobrunr.scheduling</td>
      <td>2</td>
      <td>1</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.reactivestreams</td>
      <td>2</td>
      <td>4</td>
      <td>13</td>
      <td>8.5</td>
      <td>8.500000</td>
      <td>6.363961</td>
    </tr>
    <tr>
      <th>11</th>
      <td>reactor.core.publisher</td>
      <td>2</td>
      <td>9</td>
      <td>18</td>
      <td>13.5</td>
      <td>13.500000</td>
      <td>6.363961</td>
    </tr>
    <tr>
      <th>12</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.codahale.metrics</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>1</td>
      <td>5</td>
      <td>5</td>
      <td>5.0</td>
      <td>5.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>3.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.fasterxml.jackson.databind.node</td>
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
      <td>9</td>
      <td>2.298851</td>
      <td>36.363636</td>
      <td>10.526316</td>
      <td>13.253838</td>
      <td>10.249529</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>4</td>
      <td>1.016518</td>
      <td>4.000000</td>
      <td>2.077187</td>
      <td>2.292723</td>
      <td>1.251678</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>4</td>
      <td>1.016518</td>
      <td>4.000000</td>
      <td>2.077187</td>
      <td>2.292723</td>
      <td>1.251678</td>
    </tr>
    <tr>
      <th>3</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>2</td>
      <td>0.889454</td>
      <td>2.666667</td>
      <td>1.778060</td>
      <td>1.778060</td>
      <td>1.256679</td>
    </tr>
    <tr>
      <th>4</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>2</td>
      <td>0.508259</td>
      <td>1.333333</td>
      <td>0.920796</td>
      <td>0.920796</td>
      <td>0.583416</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>2</td>
      <td>0.508259</td>
      <td>1.333333</td>
      <td>0.920796</td>
      <td>0.920796</td>
      <td>0.583416</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.thoughtworks.xstream</td>
      <td>2</td>
      <td>0.508259</td>
      <td>2.666667</td>
      <td>1.587463</td>
      <td>1.587463</td>
      <td>1.526225</td>
    </tr>
    <tr>
      <th>7</th>
      <td>io.axoniq.axonserver.connector.event</td>
      <td>2</td>
      <td>2.666667</td>
      <td>8.333333</td>
      <td>5.500000</td>
      <td>5.500000</td>
      <td>4.006938</td>
    </tr>
    <tr>
      <th>8</th>
      <td>io.axoniq.axonserver.connector.impl</td>
      <td>2</td>
      <td>1.333333</td>
      <td>3.030303</td>
      <td>2.181818</td>
      <td>2.181818</td>
      <td>1.199939</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.jobrunr.scheduling</td>
      <td>2</td>
      <td>0.508259</td>
      <td>1.333333</td>
      <td>0.920796</td>
      <td>0.920796</td>
      <td>0.583416</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.reactivestreams</td>
      <td>2</td>
      <td>1.651842</td>
      <td>3.030303</td>
      <td>2.341073</td>
      <td>2.341073</td>
      <td>0.974719</td>
    </tr>
    <tr>
      <th>11</th>
      <td>reactor.core.publisher</td>
      <td>2</td>
      <td>2.287166</td>
      <td>6.818182</td>
      <td>4.552674</td>
      <td>4.552674</td>
      <td>3.203912</td>
    </tr>
    <tr>
      <th>12</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>1.149425</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>4.545455</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.codahale.metrics</td>
      <td>1</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>1</td>
      <td>0.635324</td>
      <td>0.635324</td>
      <td>0.635324</td>
      <td>0.635324</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.fasterxml.jackson.core</td>
      <td>1</td>
      <td>0.381194</td>
      <td>0.381194</td>
      <td>0.381194</td>
      <td>0.381194</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>1</td>
      <td>0.127065</td>
      <td>0.127065</td>
      <td>0.127065</td>
      <td>0.127065</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>1</td>
      <td>0.127065</td>
      <td>0.127065</td>
      <td>0.127065</td>
      <td>0.127065</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>1</td>
      <td>0.254130</td>
      <td>0.254130</td>
      <td>0.254130</td>
      <td>0.254130</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 3 Chart 1a - Most widely spread external packages in % by types (more than 0.5% overall)

External packages that are used less than 0.5% are grouped into the name "others" to get a cleaner chart with the most significant external packages.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_44_1.png)
    


#### Table 3 Chart 1b - Most widely spread external packages in % by types (less than 0.5% overall "others" drill-down)

Shows the lowest (less than 0.5% overall) most spread external packages. Therefore, this plot breaks down the "others" slice of the pie chart above. Values under 0.3% from that will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_46_1.png)
    


#### Table 3 Chart 2a - Most widely spread external packages in % by packages (more than 0.5% overall)

External packages that are used less than 0.5% are grouped into the name "others" to get a cleaner chart with the most significant external packages.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_48_1.png)
    


#### Table 3 Chart 2b - Most widely spread external packages in % by packages (less than 0.5% overall "others" drill-down)

Shows the lowest (less than 0.5% overall) most spread external packages. Therefore, this plot breaks down the "others" slice of the pie chart above. Values under 0.3% from that will be grouped into "others" to get a cleaner plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_50_1.png)
    


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
      <td>9</td>
      <td>66</td>
      <td>1</td>
      <td>38</td>
      <td>3.0</td>
      <td>7.333333</td>
      <td>11.821590</td>
      <td>25.000000</td>
      <td>100.000000</td>
      <td>...</td>
      <td>79</td>
      <td>8.0</td>
      <td>15.777778</td>
      <td>24.391483</td>
      <td>2.298851</td>
      <td>36.363636</td>
      <td>10.526316</td>
      <td>13.253838</td>
      <td>10.249529</td>
      <td>[axon-server-connector-4.10.2, axon-tracing-op...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>jakarta.persistence</td>
      <td>4</td>
      <td>8</td>
      <td>1</td>
      <td>3</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.816497</td>
      <td>4.687500</td>
      <td>22.222222</td>
      <td>...</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.250000</td>
      <td>2.500000</td>
      <td>1.016518</td>
      <td>4.000000</td>
      <td>2.077187</td>
      <td>2.292723</td>
      <td>1.251678</td>
      <td>[axon-eventsourcing-4.10.2, axon-messaging-4.1...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>4</td>
      <td>11</td>
      <td>2</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.750000</td>
      <td>0.957427</td>
      <td>6.250000</td>
      <td>30.000000</td>
      <td>...</td>
      <td>8</td>
      <td>3.0</td>
      <td>4.250000</td>
      <td>2.500000</td>
      <td>1.016518</td>
      <td>4.000000</td>
      <td>2.077187</td>
      <td>2.292723</td>
      <td>1.251678</td>
      <td>[axon-eventsourcing-4.10.2, axon-messaging-4.1...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>com.fasterxml</td>
      <td>2</td>
      <td>5</td>
      <td>1</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
      <td>6.250000</td>
      <td>11.111111</td>
      <td>...</td>
      <td>12</td>
      <td>7.5</td>
      <td>7.500000</td>
      <td>6.363961</td>
      <td>1.524778</td>
      <td>4.000000</td>
      <td>2.762389</td>
      <td>2.762389</td>
      <td>1.750247</td>
      <td>[axon-messaging-4.10.2, axon-spring-boot-autoc...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>com.github</td>
      <td>2</td>
      <td>3</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>...</td>
      <td>6</td>
      <td>3.5</td>
      <td>3.500000</td>
      <td>3.535534</td>
      <td>0.762389</td>
      <td>1.333333</td>
      <td>1.047861</td>
      <td>1.047861</td>
      <td>0.403719</td>
      <td>[axon-messaging-4.10.2, axon-spring-boot-autoc...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.google</td>
      <td>2</td>
      <td>4</td>
      <td>1</td>
      <td>3</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>1.414214</td>
      <td>12.500000</td>
      <td>27.272727</td>
      <td>...</td>
      <td>8</td>
      <td>4.5</td>
      <td>4.500000</td>
      <td>4.949747</td>
      <td>1.149425</td>
      <td>6.060606</td>
      <td>3.605016</td>
      <td>3.605016</td>
      <td>3.472729</td>
      <td>[axon-server-connector-4.10.2, axon-test-4.10.2]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>com.thoughtworks</td>
      <td>2</td>
      <td>3</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>...</td>
      <td>8</td>
      <td>5.0</td>
      <td>5.000000</td>
      <td>4.242641</td>
      <td>1.016518</td>
      <td>2.666667</td>
      <td>1.841593</td>
      <td>1.841593</td>
      <td>1.166831</td>
      <td>[axon-messaging-4.10.2, axon-spring-boot-autoc...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>io.axoniq</td>
      <td>2</td>
      <td>9</td>
      <td>1</td>
      <td>8</td>
      <td>4.5</td>
      <td>4.500000</td>
      <td>4.949747</td>
      <td>11.111111</td>
      <td>72.727273</td>
      <td>...</td>
      <td>65</td>
      <td>33.5</td>
      <td>33.500000</td>
      <td>44.547727</td>
      <td>2.666667</td>
      <td>49.242424</td>
      <td>25.954545</td>
      <td>25.954545</td>
      <td>32.934034</td>
      <td>[axon-server-connector-4.10.2, axon-spring-boo...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.jobrunr</td>
      <td>2</td>
      <td>3</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
      <td>3.125000</td>
      <td>11.111111</td>
      <td>...</td>
      <td>4</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>2.121320</td>
      <td>0.508259</td>
      <td>1.333333</td>
      <td>0.920796</td>
      <td>0.920796</td>
      <td>0.583416</td>
      <td>[axon-messaging-4.10.2, axon-spring-boot-autoc...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.reactivestreams</td>
      <td>2</td>
      <td>3</td>
      <td>1</td>
      <td>2</td>
      <td>1.5</td>
      <td>1.500000</td>
      <td>0.707107</td>
      <td>3.125000</td>
      <td>9.090909</td>
      <td>...</td>
      <td>13</td>
      <td>8.5</td>
      <td>8.500000</td>
      <td>6.363961</td>
      <td>1.651842</td>
      <td>3.030303</td>
      <td>2.341073</td>
      <td>2.341073</td>
      <td>0.974719</td>
      <td>[axon-server-connector-4.10.2, axon-messaging-...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>reactor.core</td>
      <td>2</td>
      <td>5</td>
      <td>2</td>
      <td>3</td>
      <td>2.5</td>
      <td>2.500000</td>
      <td>0.707107</td>
      <td>3.125000</td>
      <td>27.272727</td>
      <td>...</td>
      <td>18</td>
      <td>14.0</td>
      <td>14.000000</td>
      <td>5.656854</td>
      <td>2.287166</td>
      <td>7.575758</td>
      <td>4.931462</td>
      <td>4.931462</td>
      <td>3.739599</td>
      <td>[axon-server-connector-4.10.2, axon-messaging-...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>AggregateEventPublisherImpl</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>12.500000</td>
      <td>12.500000</td>
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
      <td>[axon-test-4.10.2]</td>
    </tr>
    <tr>
      <th>12</th>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
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
      <td>[axon-disruptor-4.10.2]</td>
    </tr>
    <tr>
      <th>13</th>
      <td>com.codahale</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>11.111111</td>
      <td>11.111111</td>
      <td>...</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>0.000000</td>
      <td>[axon-spring-boot-autoconfigure-4.10.2]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.lmax</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
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
      <td>[axon-disruptor-4.10.2]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>io.grpc</td>
      <td>1</td>
      <td>5</td>
      <td>5</td>
      <td>5</td>
      <td>5.0</td>
      <td>5.000000</td>
      <td>0.000000</td>
      <td>45.454545</td>
      <td>45.454545</td>
      <td>...</td>
      <td>18</td>
      <td>18.0</td>
      <td>18.000000</td>
      <td>0.000000</td>
      <td>13.636364</td>
      <td>13.636364</td>
      <td>13.636364</td>
      <td>13.636364</td>
      <td>0.000000</td>
      <td>[axon-server-connector-4.10.2]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>io.micrometer</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>11.111111</td>
      <td>11.111111</td>
      <td>...</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>0.000000</td>
      <td>[axon-spring-boot-autoconfigure-4.10.2]</td>
    </tr>
    <tr>
      <th>17</th>
      <td>io.opentelemetry</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>...</td>
      <td>5</td>
      <td>5.0</td>
      <td>5.000000</td>
      <td>0.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>0.000000</td>
      <td>[axon-tracing-opentelemetry-4.10.2]</td>
    </tr>
    <tr>
      <th>18</th>
      <td>jakarta.validation</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>...</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>0.254130</td>
      <td>0.254130</td>
      <td>0.254130</td>
      <td>0.254130</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.10.2]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>javax.cache</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>...</td>
      <td>2</td>
      <td>2.0</td>
      <td>2.000000</td>
      <td>0.000000</td>
      <td>0.254130</td>
      <td>0.254130</td>
      <td>0.254130</td>
      <td>0.254130</td>
      <td>0.000000</td>
      <td>[axon-messaging-4.10.2]</td>
    </tr>
  </tbody>
</table>
<p>20 rows × 25 columns</p>
</div>



#### Table 4 Chart 1a - Most widely spread second level external packages in % by type (more than 0.5% overall)

External package groups that are used less than 0.5% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_54_1.png)
    


#### Table 4 Chart 1b - Most widely spread second level external packages in % by type  (less than 0.5% overall "others" drill-down)

External packages that are used less than 0.5% are grouped into the name "others" to get a cleaner chart with the most significant external packages.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_56_1.png)
    


#### Table 4 Chart 2a - Most widely spread second level external packages in % by package (more than 0.5% overall)

External package groups that are used less than 0.5% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_58_1.png)
    


#### Table 4 Chart 2b - Most widely spread second level external packages in % by package (less than 0.5% overall "others" drill-down)

External packages that are used less than 0.5% are grouped into the name "others" to get a cleaner chart with the most significant external packages.

    No data to plot for title 'Top external package (less than 0.7% overall "others" drill-down)'.


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
      <td>org.springframework.boot.docker.compose.servic...</td>
      <td>2</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.springframework.boot.docker.compose.core</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.spring.eventsourcing</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.spring.config.annotation</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.micrometer</td>
      <td>2</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.metrics</td>
      <td>2</td>
    </tr>
    <tr>
      <th>6</th>
      <td>reactor.core.scheduler</td>
      <td>3</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.springframework.boot.context.properties.bind</td>
      <td>3</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.databind.node</td>
      <td>3</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.junit.jupiter.api.extension</td>
      <td>3</td>
    </tr>
    <tr>
      <th>10</th>
      <td>net.sf.ehcache.event</td>
      <td>3</td>
    </tr>
    <tr>
      <th>11</th>
      <td>javax.cache.configuration</td>
      <td>3</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.fasterxml.jackson.core</td>
      <td>4</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.testcontainers.containers.wait.strategy</td>
      <td>4</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.google.gson</td>
      <td>4</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.thoughtworks.xstream.io.xml</td>
      <td>4</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.springframework.beans.factory.config</td>
      <td>4</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.springframework.beans.factory.support</td>
      <td>4</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.springframework.beans.factory</td>
      <td>4</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.springframework.boot.testcontainers.servic...</td>
      <td>4</td>
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
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>io.opentelemetry.api.trace</td>
      <td>9</td>
      <td>47</td>
      <td>5</td>
      <td>16</td>
      <td>6</td>
      <td>320.000000</td>
      <td>[SpanKind, Tracer, Span, SpanBuilder, SpanCont...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>io.opentelemetry.context.propagation</td>
      <td>9</td>
      <td>18</td>
      <td>5</td>
      <td>16</td>
      <td>6</td>
      <td>320.000000</td>
      <td>[TextMapGetter, TextMapSetter, TextMapPropagat...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>javax.annotation</td>
      <td>3</td>
      <td>8</td>
      <td>5</td>
      <td>16</td>
      <td>6</td>
      <td>320.000000</td>
      <td>[Nonnull]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>io.opentelemetry.context</td>
      <td>2</td>
      <td>7</td>
      <td>5</td>
      <td>16</td>
      <td>6</td>
      <td>320.000000</td>
      <td>[Context, Scope]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>org.slf4j</td>
      <td>2</td>
      <td>7</td>
      <td>5</td>
      <td>16</td>
      <td>6</td>
      <td>320.000000</td>
      <td>[LoggerFactory, Logger]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>io.opentelemetry.api</td>
      <td>1</td>
      <td>2</td>
      <td>5</td>
      <td>16</td>
      <td>6</td>
      <td>320.000000</td>
      <td>[GlobalOpenTelemetry]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.autoconfigure.condition</td>
      <td>65</td>
      <td>152</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[ConditionalOnProperty, ConditionalOnMissingBe...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.autoconfigure</td>
      <td>54</td>
      <td>55</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[AutoConfigureAfter, AutoConfiguration, AutoCo...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.context.annotation</td>
      <td>41</td>
      <td>135</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[Bean, ImportBeanDefinitionRegistrar, Primary,...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.context.properties</td>
      <td>18</td>
      <td>18</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[ConfigurationProperties, EnableConfigurationP...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.beans.factory.annotation</td>
      <td>11</td>
      <td>28</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[Qualifier, Autowired]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>javax.annotation</td>
      <td>8</td>
      <td>9</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[Nonnull]</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.slf4j</td>
      <td>8</td>
      <td>13</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[Logger, LoggerFactory]</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.actuate.health</td>
      <td>7</td>
      <td>24</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[Health$Builder, Status, AbstractHealthIndicat...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.context</td>
      <td>6</td>
      <td>24</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[ApplicationContext, ApplicationContextAware]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.spring.config</td>
      <td>5</td>
      <td>17</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[SpringConfigurer, SpringAggregateLookup, Mess...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>jakarta.persistence</td>
      <td>4</td>
      <td>6</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[EntityManagerFactory, EntityManager, Persiste...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>javax.persistence</td>
      <td>4</td>
      <td>6</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[PersistenceContext, EntityManager, EntityMana...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.beans.factory</td>
      <td>4</td>
      <td>14</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[BeanClassLoaderAware, BeanFactoryUtils, NoSuc...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.beans.factory.config</td>
      <td>4</td>
      <td>7</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[ConfigurableListableBeanFactory, RuntimeBeanR...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.beans.factory.support</td>
      <td>4</td>
      <td>21</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[BeanDefinitionRegistry, BeanDefinitionBuilder...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.testcontainers.servic...</td>
      <td>4</td>
      <td>9</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[ContainerConnectionDetailsFactory, ContainerC...</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.core.annotation</td>
      <td>4</td>
      <td>4</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[Order, AnnotationAwareOrderComparator]</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.autoconfigure.orm.jpa</td>
      <td>3</td>
      <td>3</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[HibernateJpaAutoConfiguration]</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.autoconfigure.service...</td>
      <td>3</td>
      <td>3</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[ConnectionDetails]</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.context.properties.bind</td>
      <td>3</td>
      <td>4</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[BindResult, Bindable, Binder]</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>com.fasterxml.jackson.databind</td>
      <td>2</td>
      <td>10</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[ObjectMapper]</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>com.fasterxml.jackson.dataformat.cbor.databind</td>
      <td>2</td>
      <td>8</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[CBORMapper]</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>com.thoughtworks.xstream</td>
      <td>2</td>
      <td>8</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[XStream]</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>io.axoniq.axonserver.connector.event</td>
      <td>2</td>
      <td>2</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[PersistentStreamProperties]</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.metrics</td>
      <td>2</td>
      <td>8</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[MetricsConfigurerModule, GlobalMetricRegistry]</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.micrometer</td>
      <td>2</td>
      <td>10</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[GlobalMetricRegistry, MetricsConfigurerModule]</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.spring.config.annotation</td>
      <td>2</td>
      <td>7</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[HandlerDefinitionFactoryBean, SpringParameter...</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.spring.eventsourcing</td>
      <td>2</td>
      <td>10</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[SpringAggregateSnapshotter$Builder, SpringAgg...</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.beans</td>
      <td>2</td>
      <td>3</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[BeansException]</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.docker.compose.core</td>
      <td>2</td>
      <td>5</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[RunningService, ConnectionPorts]</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.boot.docker.compose.servic...</td>
      <td>2</td>
      <td>5</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[DockerComposeConnectionDetailsFactory, Docker...</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.core.env</td>
      <td>2</td>
      <td>2</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[Environment]</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.springframework.core.type</td>
      <td>2</td>
      <td>4</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[AnnotationMetadata, AnnotatedTypeMetadata]</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>com.codahale.metrics</td>
      <td>1</td>
      <td>6</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>[MetricRegistry]</td>
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
      <td>axon-configuration-4.10.2</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>1</td>
      <td>100.0</td>
      <td>javax.annotation</td>
      <td>1</td>
      <td>13</td>
      <td>100.000000</td>
      <td>31.707317</td>
      <td>[org.axonframework.config]</td>
      <td>[org.axonframework.config.LifecycleHandlerInsp...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.10.2</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>1</td>
      <td>100.0</td>
      <td>org.slf4j</td>
      <td>1</td>
      <td>6</td>
      <td>100.000000</td>
      <td>14.634146</td>
      <td>[org.axonframework.config]</td>
      <td>[org.axonframework.config.DefaultConfigurer, o...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.0</td>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>100.000000</td>
      <td>4.545455</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.F...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.0</td>
      <td>com.lmax.disruptor</td>
      <td>1</td>
      <td>7</td>
      <td>100.000000</td>
      <td>31.818182</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.0</td>
      <td>com.lmax.disruptor.dsl</td>
      <td>1</td>
      <td>4</td>
      <td>100.000000</td>
      <td>18.181818</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.0</td>
      <td>javax.annotation</td>
      <td>1</td>
      <td>6</td>
      <td>100.000000</td>
      <td>27.272727</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>5</td>
      <td>1</td>
      <td>100.0</td>
      <td>org.slf4j</td>
      <td>1</td>
      <td>8</td>
      <td>100.000000</td>
      <td>36.363636</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>javax.annotation</td>
      <td>4</td>
      <td>8</td>
      <td>44.444444</td>
      <td>10.666667</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.DefaultEnti...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.slf4j</td>
      <td>3</td>
      <td>4</td>
      <td>33.333333</td>
      <td>5.333333</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.XStreamSecu...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.boot.actuate.health</td>
      <td>3</td>
      <td>4</td>
      <td>33.333333</td>
      <td>5.333333</td>
      <td>[org.axonframework.actuator, org.axonframework...</td>
      <td>[org.axonframework.actuator.HealthStatus, org....</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.boot.autoconfigure</td>
      <td>3</td>
      <td>24</td>
      <td>33.333333</td>
      <td>32.000000</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.XStreamSecu...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.boot.autoconfigure.condition</td>
      <td>3</td>
      <td>32</td>
      <td>33.333333</td>
      <td>42.666667</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.OnQualified...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.boot.context.properties</td>
      <td>3</td>
      <td>18</td>
      <td>33.333333</td>
      <td>24.000000</td>
      <td>[org.axonframework.springboot, org.axonframewo...</td>
      <td>[org.axonframework.springboot.TracingPropertie...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.context.annotation</td>
      <td>3</td>
      <td>30</td>
      <td>33.333333</td>
      <td>40.000000</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.RegisterDef...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>jakarta.persistence</td>
      <td>2</td>
      <td>3</td>
      <td>22.222222</td>
      <td>4.000000</td>
      <td>[org.axonframework.springboot.util.jpa, org.ax...</td>
      <td>[org.axonframework.springboot.util.jpa.Contain...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>javax.persistence</td>
      <td>2</td>
      <td>3</td>
      <td>22.222222</td>
      <td>4.000000</td>
      <td>[org.axonframework.springboot.util.legacyjpa, ...</td>
      <td>[org.axonframework.springboot.util.legacyjpa.C...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.beans.factory.annotation</td>
      <td>2</td>
      <td>10</td>
      <td>22.222222</td>
      <td>13.333333</td>
      <td>[org.axonframework.springboot.autoconfig, org....</td>
      <td>[org.axonframework.springboot.autoconfig.AxonJ...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.beans.factory.config</td>
      <td>2</td>
      <td>3</td>
      <td>22.222222</td>
      <td>4.000000</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.AbstractQua...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.beans.factory.support</td>
      <td>2</td>
      <td>2</td>
      <td>22.222222</td>
      <td>2.666667</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.DefaultEnti...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.boot.autoconfigure.orm.jpa</td>
      <td>2</td>
      <td>3</td>
      <td>22.222222</td>
      <td>4.000000</td>
      <td>[org.axonframework.springboot.autoconfig, org....</td>
      <td>[org.axonframework.springboot.autoconfig.JpaEv...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.context</td>
      <td>2</td>
      <td>5</td>
      <td>22.222222</td>
      <td>6.666667</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.XStreamSecu...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>org.springframework.core.annotation</td>
      <td>2</td>
      <td>4</td>
      <td>22.222222</td>
      <td>5.333333</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.OnQualified...</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>com.codahale.metrics</td>
      <td>1</td>
      <td>1</td>
      <td>11.111111</td>
      <td>1.333333</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.Metri...</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>com.fasterxml.jackson.databind</td>
      <td>1</td>
      <td>2</td>
      <td>11.111111</td>
      <td>2.666667</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.Objec...</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>com.fasterxml.jackson.dataformat.cbor.databind</td>
      <td>1</td>
      <td>2</td>
      <td>11.111111</td>
      <td>2.666667</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.CBORM...</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>1</td>
      <td>1</td>
      <td>11.111111</td>
      <td>1.333333</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.AxonD...</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>1</td>
      <td>1</td>
      <td>11.111111</td>
      <td>1.333333</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.AxonD...</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>com.thoughtworks.xstream</td>
      <td>1</td>
      <td>2</td>
      <td>11.111111</td>
      <td>2.666667</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.AxonA...</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>io.axoniq.axonserver.connector.event</td>
      <td>1</td>
      <td>2</td>
      <td>11.111111</td>
      <td>2.666667</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.Persi...</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>47</td>
      <td>9</td>
      <td>100.0</td>
      <td>io.axoniq.axonserver.connector.impl</td>
      <td>1</td>
      <td>1</td>
      <td>11.111111</td>
      <td>1.333333</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.Persi...</td>
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
      <td>axon-configuration-4.10.2</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>1</td>
      <td>100.00</td>
      <td>javax.annotation</td>
      <td>1</td>
      <td>13</td>
      <td>100.000000</td>
      <td>31.707317</td>
      <td>[org.axonframework.config]</td>
      <td>[org.axonframework.config.LifecycleHandlerInsp...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.10.2</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>1</td>
      <td>100.00</td>
      <td>org.slf4j</td>
      <td>1</td>
      <td>6</td>
      <td>100.000000</td>
      <td>14.634146</td>
      <td>[org.axonframework.config]</td>
      <td>[org.axonframework.config.DefaultConfigurer, o...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>100.00</td>
      <td>WeakValue</td>
      <td>1</td>
      <td>1</td>
      <td>100.000000</td>
      <td>4.545455</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.F...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>100.00</td>
      <td>com.lmax</td>
      <td>1</td>
      <td>7</td>
      <td>100.000000</td>
      <td>31.818182</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>100.00</td>
      <td>javax.annotation</td>
      <td>1</td>
      <td>6</td>
      <td>100.000000</td>
      <td>27.272727</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>100.00</td>
      <td>org.slf4j</td>
      <td>1</td>
      <td>8</td>
      <td>100.000000</td>
      <td>36.363636</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[org.axonframework.disruptor.commandhandling.D...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>org.springframework</td>
      <td>7</td>
      <td>52</td>
      <td>77.777778</td>
      <td>69.333333</td>
      <td>[org.axonframework.actuator, org.axonframework...</td>
      <td>[org.axonframework.actuator.HealthStatus, org....</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>javax.annotation</td>
      <td>4</td>
      <td>8</td>
      <td>44.444444</td>
      <td>10.666667</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.DefaultEnti...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>org.slf4j</td>
      <td>3</td>
      <td>4</td>
      <td>33.333333</td>
      <td>5.333333</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.XStreamSecu...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>jakarta.persistence</td>
      <td>2</td>
      <td>3</td>
      <td>22.222222</td>
      <td>4.000000</td>
      <td>[org.axonframework.springboot.util.jpa, org.ax...</td>
      <td>[org.axonframework.springboot.util.jpa.Contain...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>javax.persistence</td>
      <td>2</td>
      <td>3</td>
      <td>22.222222</td>
      <td>4.000000</td>
      <td>[org.axonframework.springboot.util.legacyjpa, ...</td>
      <td>[org.axonframework.springboot.util.legacyjpa.C...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>org.axonframework</td>
      <td>2</td>
      <td>7</td>
      <td>22.222222</td>
      <td>9.333333</td>
      <td>[org.axonframework.springboot.util, org.axonfr...</td>
      <td>[org.axonframework.springboot.util.AbstractQua...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>com.codahale</td>
      <td>1</td>
      <td>1</td>
      <td>11.111111</td>
      <td>1.333333</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.Metri...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>com.fasterxml</td>
      <td>1</td>
      <td>3</td>
      <td>11.111111</td>
      <td>4.000000</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.CBORM...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>com.github</td>
      <td>1</td>
      <td>1</td>
      <td>11.111111</td>
      <td>1.333333</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.AxonD...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>com.thoughtworks</td>
      <td>1</td>
      <td>2</td>
      <td>11.111111</td>
      <td>2.666667</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.AxonA...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>io.axoniq</td>
      <td>1</td>
      <td>2</td>
      <td>11.111111</td>
      <td>2.666667</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.Persi...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>io.micrometer</td>
      <td>1</td>
      <td>1</td>
      <td>11.111111</td>
      <td>1.333333</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.Micro...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>13</td>
      <td>9</td>
      <td>100.00</td>
      <td>org.jobrunr</td>
      <td>1</td>
      <td>1</td>
      <td>11.111111</td>
      <td>1.333333</td>
      <td>[org.axonframework.springboot.autoconfig]</td>
      <td>[org.axonframework.springboot.autoconfig.AxonJ...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>1</td>
      <td>5</td>
      <td>3</td>
      <td>1</td>
      <td>100.00</td>
      <td>io.opentelemetry</td>
      <td>1</td>
      <td>5</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>[org.axonframework.tracing.opentelemetry]</td>
      <td>[org.axonframework.tracing.opentelemetry.OpenT...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>1</td>
      <td>5</td>
      <td>3</td>
      <td>1</td>
      <td>100.00</td>
      <td>javax.annotation</td>
      <td>1</td>
      <td>3</td>
      <td>100.000000</td>
      <td>60.000000</td>
      <td>[org.axonframework.tracing.opentelemetry]</td>
      <td>[org.axonframework.tracing.opentelemetry.Metad...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>1</td>
      <td>5</td>
      <td>3</td>
      <td>1</td>
      <td>100.00</td>
      <td>org.slf4j</td>
      <td>1</td>
      <td>1</td>
      <td>100.000000</td>
      <td>20.000000</td>
      <td>[org.axonframework.tracing.opentelemetry]</td>
      <td>[org.axonframework.tracing.opentelemetry.OpenT...</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>132</td>
      <td>8</td>
      <td>10</td>
      <td>90.91</td>
      <td>org.slf4j</td>
      <td>9</td>
      <td>19</td>
      <td>81.818182</td>
      <td>14.393939</td>
      <td>[org.axonframework.axonserver.connector, org.a...</td>
      <td>[org.axonframework.axonserver.connector.Server...</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>132</td>
      <td>8</td>
      <td>10</td>
      <td>90.91</td>
      <td>io.axoniq</td>
      <td>8</td>
      <td>65</td>
      <td>72.727273</td>
      <td>49.242424</td>
      <td>[org.axonframework.axonserver.connector, org.a...</td>
      <td>[org.axonframework.axonserver.connector.AxonSe...</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>132</td>
      <td>8</td>
      <td>10</td>
      <td>90.91</td>
      <td>javax.annotation</td>
      <td>8</td>
      <td>21</td>
      <td>72.727273</td>
      <td>15.909091</td>
      <td>[org.axonframework.axonserver.connector, org.a...</td>
      <td>[org.axonframework.axonserver.connector.Server...</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>132</td>
      <td>8</td>
      <td>10</td>
      <td>90.91</td>
      <td>io.grpc</td>
      <td>5</td>
      <td>18</td>
      <td>45.454545</td>
      <td>13.636364</td>
      <td>[org.axonframework.axonserver.connector, org.a...</td>
      <td>[org.axonframework.axonserver.connector.AxonSe...</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>132</td>
      <td>8</td>
      <td>10</td>
      <td>90.91</td>
      <td>com.google</td>
      <td>3</td>
      <td>8</td>
      <td>27.272727</td>
      <td>6.060606</td>
      <td>[org.axonframework.axonserver.connector.util, ...</td>
      <td>[org.axonframework.axonserver.connector.util.G...</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>132</td>
      <td>8</td>
      <td>10</td>
      <td>90.91</td>
      <td>reactor.core</td>
      <td>3</td>
      <td>10</td>
      <td>27.272727</td>
      <td>7.575758</td>
      <td>[org.axonframework.axonserver.connector.util, ...</td>
      <td>[org.axonframework.axonserver.connector.util.P...</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>132</td>
      <td>8</td>
      <td>10</td>
      <td>90.91</td>
      <td>org.reactivestreams</td>
      <td>1</td>
      <td>4</td>
      <td>9.090909</td>
      <td>3.030303</td>
      <td>[org.axonframework.axonserver.connector.query]</td>
      <td>[org.axonframework.axonserver.connector.query....</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>132</td>
      <td>8</td>
      <td>10</td>
      <td>90.91</td>
      <td>org.springframework</td>
      <td>1</td>
      <td>1</td>
      <td>9.090909</td>
      <td>0.757576</td>
      <td>[org.axonframework.axonserver.connector]</td>
      <td>[org.axonframework.axonserver.connector.AxonSe...</td>
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
      <th>axon-messaging-4.10.2</th>
      <th>axon-spring-boot-autoconfigure-4.10.2</th>
      <th>axon-server-connector-4.10.2</th>
      <th>axon-test-4.10.2</th>
      <th>axon-modelling-4.10.2</th>
      <th>axon-eventsourcing-4.10.2</th>
      <th>axon-tracing-opentelemetry-4.10.2</th>
      <th>axon-disruptor-4.10.2</th>
      <th>axon-configuration-4.10.2</th>
    </tr>
    <tr>
      <th>externalPackageName</th>
      <th></th>
      <th></th>
      <th></th>
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
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.codahale.metrics</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml.jackson.annotation</th>
      <td>11</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
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
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>reactor.core</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
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
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>reactor.core.scheduler</th>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
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
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>117 rows × 9 columns</p>
</div>



#### Table 7c - Top 15 external dependency using artifacts as columns with their external packages (first 2 levels)

The following table uses pivot to show the artifacts in columns, the external package name grouped by its first two levels in rows and the number of internal packages as values. For example `javax.xml.namespace` and `javax.xml.stream` will be grouped together to `javax.xml`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>artifactName</th>
      <th>axon-messaging-4.10.2</th>
      <th>axon-server-connector-4.10.2</th>
      <th>axon-spring-boot-autoconfigure-4.10.2</th>
      <th>axon-modelling-4.10.2</th>
      <th>axon-eventsourcing-4.10.2</th>
      <th>axon-test-4.10.2</th>
      <th>axon-disruptor-4.10.2</th>
      <th>axon-tracing-opentelemetry-4.10.2</th>
      <th>axon-configuration-4.10.2</th>
    </tr>
    <tr>
      <th>externalPackageNameFirst2Levels</th>
      <th></th>
      <th></th>
      <th></th>
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
      <td>0</td>
      <td>0</td>
      <td>1</td>
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
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.codahale</th>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.fasterxml</th>
      <td>12</td>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.github</th>
      <td>2</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.google</th>
      <td>0</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.lmax</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>com.thoughtworks</th>
      <td>2</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>io.axoniq</th>
      <td>0</td>
      <td>8</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>io.grpc</th>
      <td>0</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>io.micrometer</th>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>io.opentelemetry</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>jakarta.persistence</th>
      <td>4</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>0</td>
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
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.annotation</th>
      <td>47</td>
      <td>8</td>
      <td>4</td>
      <td>4</td>
      <td>6</td>
      <td>4</td>
      <td>1</td>
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
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>javax.persistence</th>
      <td>7</td>
      <td>0</td>
      <td>2</td>
      <td>3</td>
      <td>3</td>
      <td>0</td>
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
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.axonframework</th>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
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
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.hamcrest</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.jobrunr</th>
      <td>2</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
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
      <td>0</td>
      <td>0</td>
      <td>2</td>
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
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.reactivestreams</th>
      <td>2</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.slf4j</th>
      <td>38</td>
      <td>9</td>
      <td>3</td>
      <td>6</td>
      <td>5</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>org.springframework</th>
      <td>0</td>
      <td>1</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>org.testcontainers</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>reactor.core</th>
      <td>2</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
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



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_75_1.png)
    


#### Table 7 Chart 2 - Top 15 external dependency using artifacts and their external packages (first 2 levels) stacked

The following chart shows the top 15 external package using artifacts and breaks down which external packages (first 2 levels) are used in how many different internal packages with stacked bars. 

Note that every external dependency is counted separately so that if on internal package uses two external packages it will be displayed for both and so stacked twice.  


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_77_1.png)
    


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
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>5</td>
      <td>16</td>
      <td>6</td>
      <td>320.000000</td>
      <td>26</td>
      <td>89</td>
      <td>6</td>
      <td>[io.opentelemetry.context.propagation, io.open...</td>
      <td>[TextMapGetter, TextMapSetter, TextMapPropagat...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>75</td>
      <td>101</td>
      <td>47</td>
      <td>134.666667</td>
      <td>300</td>
      <td>670</td>
      <td>47</td>
      <td>[org.springframework.boot.autoconfigure.condit...</td>
      <td>[ConditionalOnProperty, ConditionalOnMissingBe...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-server-connector-4.10.2</td>
      <td>132</td>
      <td>113</td>
      <td>26</td>
      <td>85.606061</td>
      <td>342</td>
      <td>1396</td>
      <td>26</td>
      <td>[io.axoniq.axonserver.grpc, io.grpc, io.axoniq...</td>
      <td>[ErrorMessage, ErrorMessage$Builder, MetaDataV...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.10.2</td>
      <td>22</td>
      <td>13</td>
      <td>5</td>
      <td>59.090909</td>
      <td>33</td>
      <td>93</td>
      <td>5</td>
      <td>[org.slf4j, com.lmax.disruptor, javax.annotati...</td>
      <td>[Logger, LoggerFactory, ExceptionHandler, Ring...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.2</td>
      <td>87</td>
      <td>28</td>
      <td>13</td>
      <td>32.183908</td>
      <td>99</td>
      <td>500</td>
      <td>13</td>
      <td>[org.hamcrest, javax.annotation, org.testconta...</td>
      <td>[Description, BaseMatcher, StringDescription, ...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-modelling-4.10.2</td>
      <td>158</td>
      <td>35</td>
      <td>5</td>
      <td>22.151899</td>
      <td>99</td>
      <td>356</td>
      <td>5</td>
      <td>[javax.annotation, javax.persistence, jakarta....</td>
      <td>[Nonnull, Nullable, Query, EntityManagerFactor...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.10.2</td>
      <td>787</td>
      <td>154</td>
      <td>42</td>
      <td>19.567980</td>
      <td>749</td>
      <td>2975</td>
      <td>42</td>
      <td>[javax.annotation, org.slf4j, com.fasterxml.ja...</td>
      <td>[Nonnull, Nullable, Logger, LoggerFactory, Jso...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-eventsourcing-4.10.2</td>
      <td>133</td>
      <td>25</td>
      <td>4</td>
      <td>18.796992</td>
      <td>74</td>
      <td>238</td>
      <td>4</td>
      <td>[javax.annotation, org.slf4j, javax.persistenc...</td>
      <td>[Nonnull, Nullable, PreDestroy, LoggerFactory,...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-configuration-4.10.2</td>
      <td>41</td>
      <td>4</td>
      <td>2</td>
      <td>9.756098</td>
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
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>io.grpc</td>
      <td>39</td>
      <td>69</td>
      <td>26</td>
      <td>[Metadata$Key, ClientCall, ForwardingClientCal...</td>
      <td>util</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-test-4.10.2</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.hamcrest</td>
      <td>38</td>
      <td>147</td>
      <td>24</td>
      <td>[Matcher, TypeSafeMatcher, Description, BaseMa...</td>
      <td>matchers</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.queryhandling</td>
      <td>reactor.core.publisher</td>
      <td>28</td>
      <td>108</td>
      <td>48</td>
      <td>[Signal, Mono, Flux, Sinks$EmitResult, Sinks$M...</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>io.axoniq.axonserver.grpc.query</td>
      <td>25</td>
      <td>124</td>
      <td>21</td>
      <td>[QueryProviderOutbound, QueryProviderInbound, ...</td>
      <td>query</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.query.s...</td>
      <td>io.axoniq.axonserver.grpc.query</td>
      <td>21</td>
      <td>113</td>
      <td>6</td>
      <td>[SubscriptionQuery, QueryUpdate, QueryResponse...</td>
      <td>subscription</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>io.axoniq.axonserver.grpc</td>
      <td>20</td>
      <td>106</td>
      <td>26</td>
      <td>[MetaDataValue, SerializedObject, ErrorMessage...</td>
      <td>util</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.deadline.quartz</td>
      <td>org.quartz</td>
      <td>18</td>
      <td>109</td>
      <td>4</td>
      <td>[Scheduler, JobExecutionContext, SchedulerCont...</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>io.axoniq.axonserver.connector.event</td>
      <td>18</td>
      <td>89</td>
      <td>27</td>
      <td>[EventQueryResultEntry, EventStream, Persisten...</td>
      <td>axon</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.eventhandling.scheduling.quartz</td>
      <td>org.quartz</td>
      <td>17</td>
      <td>76</td>
      <td>6</td>
      <td>[SchedulerContext, Scheduler, JobDetail, JobBu...</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>io.axoniq.axonserver.connector</td>
      <td>17</td>
      <td>53</td>
      <td>21</td>
      <td>[ResultStreamPublisher, Registration, AxonServ...</td>
      <td>query</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.eventhandling</td>
      <td>org.slf4j</td>
      <td>16</td>
      <td>56</td>
      <td>100</td>
      <td>[Logger, LoggerFactory]</td>
      <td>eventhandling</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.eventhandling.pooled</td>
      <td>org.slf4j</td>
      <td>15</td>
      <td>71</td>
      <td>22</td>
      <td>[Logger, LoggerFactory]</td>
      <td>pooled</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.serialization.json</td>
      <td>com.fasterxml.jackson.databind</td>
      <td>15</td>
      <td>65</td>
      <td>7</td>
      <td>[JsonNode, ObjectMapper$DefaultTyping, Deseria...</td>
      <td>json</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-disruptor-4.10.2</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>org.slf4j</td>
      <td>12</td>
      <td>22</td>
      <td>22</td>
      <td>[Logger, LoggerFactory]</td>
      <td>commandhandling</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-configuration-4.10.2</td>
      <td>org.axonframework.config</td>
      <td>org.slf4j</td>
      <td>11</td>
      <td>32</td>
      <td>41</td>
      <td>[Logger, LoggerFactory]</td>
      <td>config</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-disruptor-4.10.2</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>com.lmax.disruptor</td>
      <td>9</td>
      <td>25</td>
      <td>22</td>
      <td>[ExceptionHandler, RingBuffer, WaitStrategy, B...</td>
      <td>commandhandling</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.queryhandling</td>
      <td>org.slf4j</td>
      <td>9</td>
      <td>18</td>
      <td>48</td>
      <td>[Logger, LoggerFactory]</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.command</td>
      <td>io.axoniq.axonserver.grpc.command</td>
      <td>9</td>
      <td>52</td>
      <td>11</td>
      <td>[Command, CommandResponse, Command$Builder, Co...</td>
      <td>command</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>io.axoniq.axonserver.grpc</td>
      <td>9</td>
      <td>46</td>
      <td>21</td>
      <td>[ErrorMessage, ProcessingKey, ProcessingInstru...</td>
      <td>query</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>org.axonframework.tracing.opentelemetry</td>
      <td>io.opentelemetry.api.trace</td>
      <td>9</td>
      <td>47</td>
      <td>5</td>
      <td>[Span, SpanContext, StatusCode, SpanBuilder, S...</td>
      <td>opentelemetry</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>org.axonframework.tracing.opentelemetry</td>
      <td>io.opentelemetry.context.propagation</td>
      <td>9</td>
      <td>18</td>
      <td>5</td>
      <td>[TextMapSetter, TextMapGetter, TextMapPropagat...</td>
      <td>opentelemetry</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-eventsourcing-4.10.2</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>org.slf4j</td>
      <td>8</td>
      <td>15</td>
      <td>10</td>
      <td>[LoggerFactory, Logger]</td>
      <td>legacyjpa</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.common.caching</td>
      <td>org.ehcache.event</td>
      <td>8</td>
      <td>30</td>
      <td>15</td>
      <td>[EventType, EventFiring, CacheEventListener, E...</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.common.caching</td>
      <td>javax.cache.event</td>
      <td>8</td>
      <td>26</td>
      <td>15</td>
      <td>[CacheEntryListener, CacheEntryCreatedListener...</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>org.slf4j</td>
      <td>8</td>
      <td>15</td>
      <td>54</td>
      <td>[Logger, LoggerFactory]</td>
      <td>annotation</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>io.axoniq.axonserver.grpc</td>
      <td>8</td>
      <td>68</td>
      <td>27</td>
      <td>[ErrorMessage, ErrorMessage$Builder, Instructi...</td>
      <td>connector</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.command</td>
      <td>io.axoniq.axonserver.grpc</td>
      <td>8</td>
      <td>25</td>
      <td>11</td>
      <td>[ErrorMessage, MetaDataValue$Builder, Processi...</td>
      <td>command</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>io.axoniq.axonserver.grpc.event</td>
      <td>8</td>
      <td>43</td>
      <td>27</td>
      <td>[Event, EventWithToken, Event$Builder, Confirm...</td>
      <td>axon</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>org.slf4j</td>
      <td>8</td>
      <td>24</td>
      <td>27</td>
      <td>[LoggerFactory, Logger]</td>
      <td>axon</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-test-4.10.2</td>
      <td>org.axonframework.test.saga</td>
      <td>org.hamcrest</td>
      <td>8</td>
      <td>66</td>
      <td>21</td>
      <td>[CoreMatchers, Matcher, Description, StringDes...</td>
      <td>saga</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>reactor.core.publisher</td>
      <td>7</td>
      <td>34</td>
      <td>8</td>
      <td>[Mono, Flux]</td>
      <td>responsetypes</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.queryhandling</td>
      <td>org.reactivestreams</td>
      <td>7</td>
      <td>23</td>
      <td>48</td>
      <td>[Publisher]</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>io.axoniq.axonserver.grpc</td>
      <td>7</td>
      <td>18</td>
      <td>27</td>
      <td>[SerializedObject, SerializedObject$Builder, I...</td>
      <td>axon</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>reactor.core.publisher</td>
      <td>7</td>
      <td>27</td>
      <td>21</td>
      <td>[Mono, Flux, SignalType, BaseSubscriber]</td>
      <td>query</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.query.s...</td>
      <td>reactor.core.publisher</td>
      <td>7</td>
      <td>29</td>
      <td>6</td>
      <td>[Flux, Mono, FluxSink]</td>
      <td>subscription</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-eventsourcing-4.10.2</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>org.slf4j</td>
      <td>6</td>
      <td>9</td>
      <td>31</td>
      <td>[Logger, LoggerFactory]</td>
      <td>eventstore</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.eventhandling.deadletter</td>
      <td>org.slf4j</td>
      <td>6</td>
      <td>25</td>
      <td>5</td>
      <td>[Logger, LoggerFactory]</td>
      <td>deadletter</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>org.reactivestreams</td>
      <td>6</td>
      <td>14</td>
      <td>8</td>
      <td>[Publisher]</td>
      <td>responsetypes</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.serialization</td>
      <td>com.thoughtworks.xstream.io</td>
      <td>6</td>
      <td>32</td>
      <td>34</td>
      <td>[HierarchicalStreamReader, HierarchicalStreamW...</td>
      <td>serialization</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.serialization</td>
      <td>com.thoughtworks.xstream.converters</td>
      <td>6</td>
      <td>6</td>
      <td>34</td>
      <td>[UnmarshallingContext, MarshallingContext]</td>
      <td>serialization</td>
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
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>AxonAutoConfiguration</td>
      <td>19</td>
      <td>91</td>
      <td>12</td>
      <td>19</td>
      <td>[org.springframework.boot.autoconfigure, org.s...</td>
      <td>[org.springframework.boot.autoconfigure.AutoCo...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.AxonAu...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>AxonServerAutoConfiguration</td>
      <td>16</td>
      <td>48</td>
      <td>11</td>
      <td>16</td>
      <td>[org.springframework.boot.autoconfigure.condit...</td>
      <td>[org.springframework.boot.autoconfigure.condit...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.AxonSe...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>InfraConfiguration</td>
      <td>18</td>
      <td>53</td>
      <td>9</td>
      <td>18</td>
      <td>[org.springframework.boot.autoconfigure, org.s...</td>
      <td>[org.springframework.boot.autoconfigure.AutoCo...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.InfraC...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>AxonServerQueryBus</td>
      <td>15</td>
      <td>73</td>
      <td>8</td>
      <td>15</td>
      <td>[javax.annotation, reactor.core.scheduler, org...</td>
      <td>[javax.annotation.Nonnull, reactor.core.schedu...</td>
      <td>query</td>
      <td>org.axonframework.axonserver.connector.query.A...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>PersistentStreamMessageSourceRegistrar</td>
      <td>13</td>
      <td>34</td>
      <td>8</td>
      <td>13</td>
      <td>[javax.annotation, org.springframework.beans.f...</td>
      <td>[javax.annotation.Nonnull, org.springframework...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.Persis...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.util</td>
      <td>AbstractQualifiedBeanCondition</td>
      <td>12</td>
      <td>24</td>
      <td>8</td>
      <td>12</td>
      <td>[org.springframework.boot.autoconfigure.condit...</td>
      <td>[org.springframework.boot.autoconfigure.condit...</td>
      <td>util</td>
      <td>org.axonframework.springboot.util.AbstractQual...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>AxonServerEventStore$AxonIQEventStorageEngine</td>
      <td>12</td>
      <td>58</td>
      <td>7</td>
      <td>12</td>
      <td>[javax.annotation, io.axoniq.axonserver.grpc, ...</td>
      <td>[javax.annotation.Nonnull, io.axoniq.axonserve...</td>
      <td>axon</td>
      <td>org.axonframework.axonserver.connector.event.a...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>MicrometerMetricsAutoConfiguration</td>
      <td>13</td>
      <td>30</td>
      <td>7</td>
      <td>13</td>
      <td>[org.springframework.boot.autoconfigure.condit...</td>
      <td>[org.springframework.boot.autoconfigure.condit...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.Microm...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>AxonDbSchedulerAutoConfiguration</td>
      <td>9</td>
      <td>26</td>
      <td>7</td>
      <td>9</td>
      <td>[org.springframework.boot.autoconfigure, org.s...</td>
      <td>[org.springframework.boot.autoconfigure.AutoCo...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.AxonDb...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>JpaAutoConfiguration</td>
      <td>10</td>
      <td>19</td>
      <td>7</td>
      <td>10</td>
      <td>[org.springframework.boot.autoconfigure, org.s...</td>
      <td>[org.springframework.boot.autoconfigure.AutoCo...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.JpaAut...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>XStreamAutoConfiguration</td>
      <td>11</td>
      <td>15</td>
      <td>7</td>
      <td>11</td>
      <td>[org.springframework.boot.autoconfigure, org.s...</td>
      <td>[org.springframework.boot.autoconfigure.AutoCo...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.XStrea...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig.legacyjpa</td>
      <td>JpaJavaxAutoConfiguration</td>
      <td>11</td>
      <td>20</td>
      <td>7</td>
      <td>11</td>
      <td>[org.springframework.boot.autoconfigure, org.s...</td>
      <td>[org.springframework.boot.autoconfigure.AutoCo...</td>
      <td>legacyjpa</td>
      <td>org.axonframework.springboot.autoconfig.legacy...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.10.2</td>
      <td>org.axonframework.serialization.json</td>
      <td>JacksonSerializer</td>
      <td>9</td>
      <td>28</td>
      <td>6</td>
      <td>9</td>
      <td>[javax.annotation, com.fasterxml.jackson.datab...</td>
      <td>[javax.annotation.Nonnull, com.fasterxml.jacks...</td>
      <td>json</td>
      <td>org.axonframework.serialization.json.JacksonSe...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerConnectionManager$Builder</td>
      <td>8</td>
      <td>40</td>
      <td>6</td>
      <td>8</td>
      <td>[io.grpc, io.axoniq.axonserver.connector, io.a...</td>
      <td>[io.grpc.ManagedChannelBuilder, io.axoniq.axon...</td>
      <td>connector</td>
      <td>org.axonframework.axonserver.connector.AxonSer...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>AxonServerEventScheduler</td>
      <td>10</td>
      <td>26</td>
      <td>6</td>
      <td>10</td>
      <td>[javax.annotation, io.axoniq.axonserver.grpc, ...</td>
      <td>[javax.annotation.Nonnull, io.axoniq.axonserve...</td>
      <td>axon</td>
      <td>org.axonframework.axonserver.connector.event.a...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.processor</td>
      <td>EventProcessorControlService</td>
      <td>8</td>
      <td>36</td>
      <td>6</td>
      <td>8</td>
      <td>[javax.annotation, org.slf4j, io.axoniq.axonse...</td>
      <td>[javax.annotation.Nonnull, org.slf4j.Logger, o...</td>
      <td>processor</td>
      <td>org.axonframework.axonserver.connector.process...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-server-connector-4.10.2</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>QueryProcessingTask</td>
      <td>10</td>
      <td>38</td>
      <td>6</td>
      <td>10</td>
      <td>[org.slf4j, io.grpc.netty.shaded.io.netty.util...</td>
      <td>[org.slf4j.Logger, io.grpc.netty.shaded.io.net...</td>
      <td>query</td>
      <td>org.axonframework.axonserver.connector.query.Q...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>MetricsAutoConfiguration</td>
      <td>11</td>
      <td>28</td>
      <td>6</td>
      <td>11</td>
      <td>[org.springframework.boot.autoconfigure.condit...</td>
      <td>[org.springframework.boot.autoconfigure.condit...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.Metric...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>JdbcAutoConfiguration</td>
      <td>9</td>
      <td>30</td>
      <td>6</td>
      <td>9</td>
      <td>[org.springframework.boot.autoconfigure, org.s...</td>
      <td>[org.springframework.boot.autoconfigure.AutoCo...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.JdbcAu...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>org.axonframework.springboot.autoconfig</td>
      <td>JpaEventStoreAutoConfiguration</td>
      <td>9</td>
      <td>9</td>
      <td>6</td>
      <td>9</td>
      <td>[org.springframework.boot.autoconfigure, org.s...</td>
      <td>[org.springframework.boot.autoconfigure.AutoCo...</td>
      <td>autoconfig</td>
      <td>org.axonframework.springboot.autoconfig.JpaEve...</td>
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
      <td>axon-messaging-4.10.2</td>
      <td>64</td>
      <td>787</td>
      <td>41</td>
      <td>44</td>
      <td>155</td>
      <td>19.695044</td>
      <td>68.750000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>132</td>
      <td>24</td>
      <td>10</td>
      <td>82</td>
      <td>62.121212</td>
      <td>90.909091</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>75</td>
      <td>43</td>
      <td>8</td>
      <td>33</td>
      <td>44.000000</td>
      <td>88.888889</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-modelling-4.10.2</td>
      <td>10</td>
      <td>158</td>
      <td>3</td>
      <td>7</td>
      <td>12</td>
      <td>7.594937</td>
      <td>70.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.2</td>
      <td>8</td>
      <td>87</td>
      <td>12</td>
      <td>6</td>
      <td>36</td>
      <td>41.379310</td>
      <td>75.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-eventsourcing-4.10.2</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>5</td>
      <td>15</td>
      <td>11.278195</td>
      <td>55.555556</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-configuration-4.10.2</td>
      <td>1</td>
      <td>41</td>
      <td>1</td>
      <td>1</td>
      <td>6</td>
      <td>14.634146</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>10</td>
      <td>45.454545</td>
      <td>100.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>1</td>
      <td>5</td>
      <td>5</td>
      <td>1</td>
      <td>5</td>
      <td>100.000000</td>
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
      <th>axon-eventsourcing-4.10.2</th>
      <th>axon-messaging-4.10.2</th>
      <th>axon-modelling-4.10.2</th>
      <th>axon-server-connector-4.10.2</th>
      <th>axon-spring-boot-autoconfigure-4.10.2</th>
      <th>axon-test-4.10.2</th>
    </tr>
    <tr>
      <th>numberOfPackages</th>
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
      <th>2</th>
      <td>22.222222</td>
      <td>3.1250</td>
      <td>20.0</td>
      <td>18.181818</td>
      <td>22.222222</td>
      <td>25.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>33.333333</td>
      <td>0.0000</td>
      <td>30.0</td>
      <td>27.272727</td>
      <td>33.333333</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.000000</td>
      <td>6.2500</td>
      <td>40.0</td>
      <td>36.363636</td>
      <td>44.444444</td>
      <td>50.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>55.555556</td>
      <td>0.0000</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>62.5</td>
    </tr>
    <tr>
      <th>6</th>
      <td>66.666667</td>
      <td>0.0000</td>
      <td>60.0</td>
      <td>54.545455</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0.000000</td>
      <td>10.9375</td>
      <td>0.0</td>
      <td>63.636364</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>0.000000</td>
      <td>0.0000</td>
      <td>0.0</td>
      <td>72.727273</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0.000000</td>
      <td>0.0000</td>
      <td>0.0</td>
      <td>81.818182</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>0.000000</td>
      <td>17.1875</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>38</th>
      <td>0.000000</td>
      <td>59.3750</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>47</th>
      <td>0.000000</td>
      <td>73.4375</td>
      <td>0.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
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
      <td>axon-messaging-4.10.2</td>
      <td>64</td>
      <td>41</td>
      <td>1</td>
      <td>1.0</td>
      <td>2.292683</td>
      <td>38</td>
      <td>5.758663</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>24</td>
      <td>1</td>
      <td>2.0</td>
      <td>2.500000</td>
      <td>9</td>
      <td>2.085144</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-modelling-4.10.2</td>
      <td>10</td>
      <td>3</td>
      <td>2</td>
      <td>3.0</td>
      <td>3.666667</td>
      <td>6</td>
      <td>2.081666</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.10.2</td>
      <td>9</td>
      <td>3</td>
      <td>1</td>
      <td>2.0</td>
      <td>2.666667</td>
      <td>5</td>
      <td>2.081666</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.2</td>
      <td>8</td>
      <td>12</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.416667</td>
      <td>5</td>
      <td>1.164500</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>43</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.279070</td>
      <td>3</td>
      <td>0.548833</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-configuration-4.10.2</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>1</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>4</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.000000</td>
      <td>1</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>1</td>
      <td>5</td>
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
      <td>axon-messaging-4.10.2</td>
      <td>64</td>
      <td>41</td>
      <td>1.562500</td>
      <td>1.562500</td>
      <td>3.582317</td>
      <td>59.375000</td>
      <td>8.997910</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-server-connector-4.10.2</td>
      <td>11</td>
      <td>24</td>
      <td>9.090909</td>
      <td>18.181818</td>
      <td>22.727273</td>
      <td>81.818182</td>
      <td>18.955856</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-modelling-4.10.2</td>
      <td>10</td>
      <td>3</td>
      <td>20.000000</td>
      <td>30.000000</td>
      <td>36.666667</td>
      <td>60.000000</td>
      <td>20.816660</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.10.2</td>
      <td>9</td>
      <td>3</td>
      <td>11.111111</td>
      <td>22.222222</td>
      <td>29.629630</td>
      <td>55.555556</td>
      <td>23.129622</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.2</td>
      <td>8</td>
      <td>12</td>
      <td>12.500000</td>
      <td>12.500000</td>
      <td>17.708333</td>
      <td>62.500000</td>
      <td>14.556252</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>9</td>
      <td>43</td>
      <td>11.111111</td>
      <td>11.111111</td>
      <td>14.211886</td>
      <td>33.333333</td>
      <td>6.098150</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-configuration-4.10.2</td>
      <td>1</td>
      <td>1</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-disruptor-4.10.2</td>
      <td>1</td>
      <td>4</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>100.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>1</td>
      <td>5</td>
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
      <td>axon-messaging-4.10.2</td>
      <td>787</td>
      <td>41</td>
      <td>1</td>
      <td>3.0</td>
      <td>5.414634</td>
      <td>79</td>
      <td>12.271869</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-server-connector-4.10.2</td>
      <td>132</td>
      <td>24</td>
      <td>1</td>
      <td>4.0</td>
      <td>7.125000</td>
      <td>30</td>
      <td>7.719611</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-modelling-4.10.2</td>
      <td>158</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>5.000000</td>
      <td>9</td>
      <td>3.464102</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.10.2</td>
      <td>133</td>
      <td>3</td>
      <td>3</td>
      <td>3.0</td>
      <td>6.666667</td>
      <td>14</td>
      <td>6.350853</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.2</td>
      <td>87</td>
      <td>12</td>
      <td>1</td>
      <td>1.5</td>
      <td>3.833333</td>
      <td>27</td>
      <td>7.346407</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>75</td>
      <td>43</td>
      <td>1</td>
      <td>1.0</td>
      <td>1.837209</td>
      <td>5</td>
      <td>1.067490</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-configuration-4.10.2</td>
      <td>41</td>
      <td>1</td>
      <td>6</td>
      <td>6.0</td>
      <td>6.000000</td>
      <td>6</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-disruptor-4.10.2</td>
      <td>22</td>
      <td>4</td>
      <td>1</td>
      <td>5.5</td>
      <td>5.000000</td>
      <td>8</td>
      <td>3.162278</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>5</td>
      <td>5</td>
      <td>1</td>
      <td>2.0</td>
      <td>2.200000</td>
      <td>4</td>
      <td>1.303840</td>
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
      <td>axon-messaging-4.10.2</td>
      <td>787</td>
      <td>41</td>
      <td>0.127065</td>
      <td>0.381194</td>
      <td>0.688009</td>
      <td>10.038119</td>
      <td>1.559323</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-server-connector-4.10.2</td>
      <td>132</td>
      <td>24</td>
      <td>0.757576</td>
      <td>3.030303</td>
      <td>5.397727</td>
      <td>22.727273</td>
      <td>5.848190</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-modelling-4.10.2</td>
      <td>158</td>
      <td>3</td>
      <td>1.898734</td>
      <td>1.898734</td>
      <td>3.164557</td>
      <td>5.696203</td>
      <td>2.192469</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.10.2</td>
      <td>133</td>
      <td>3</td>
      <td>2.255639</td>
      <td>2.255639</td>
      <td>5.012531</td>
      <td>10.526316</td>
      <td>4.775077</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.2</td>
      <td>87</td>
      <td>12</td>
      <td>1.149425</td>
      <td>1.724138</td>
      <td>4.406130</td>
      <td>31.034483</td>
      <td>8.444146</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-spring-boot-autoconfigure-4.10.2</td>
      <td>75</td>
      <td>43</td>
      <td>1.333333</td>
      <td>1.333333</td>
      <td>2.449612</td>
      <td>6.666667</td>
      <td>1.423320</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-configuration-4.10.2</td>
      <td>41</td>
      <td>1</td>
      <td>14.634146</td>
      <td>14.634146</td>
      <td>14.634146</td>
      <td>14.634146</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-disruptor-4.10.2</td>
      <td>22</td>
      <td>4</td>
      <td>4.545455</td>
      <td>25.000000</td>
      <td>22.727273</td>
      <td>36.363636</td>
      <td>14.373989</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-tracing-opentelemetry-4.10.2</td>
      <td>5</td>
      <td>5</td>
      <td>20.000000</td>
      <td>40.000000</td>
      <td>44.000000</td>
      <td>80.000000</td>
      <td>26.076810</td>
    </tr>
  </tbody>
</table>
</div>



#### Table 13 Chart 1 - External package usage - max percentage of internal types

This chart shows per artifact the maximum percentage of internal packages (compared to all packages in that artifact) that use one specific external package. 

**Example:** One artifact might use 10 external packages where 7 of them are used in one internal package, 2 of them are used in two packages and one external dependency is used in 5 packages. So for this artifact there will be a point at x = 10 (external packages used by the artifact) and 5 (max internal packages). Instead of the count the percentage of internal packages compared to all packages in that artifact is used to get a normalized plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_99_1.png)
    


#### Table 13 Chart 2 - External package usage - median percentage of internal types

This chart shows per artifact the median (0.5 percentile) of internal packages (compared to all packages in that artifact) that use one specific external package. 

**Example:** One artifact might use 9 external packages where 3 of them are used in 1 internal package, 3 of them are used in 2 package and the last 3 ones are used in 3 packages. So for this artifact there will be a point at x = 10 (external packages used by the artifact) and 2 (median internal packages). Instead of the count the percentage of internal packages compared to all packages in that artifact is used to get a normalized plot.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependenciesJava_files/ExternalDependenciesJava_101_1.png)
    


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
      <td>test</td>
      <td>True</td>
      <td>io.projectreactor</td>
      <td>reactor-core</td>
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
      <td>test</td>
      <td>False</td>
      <td>org.hsqldb</td>
      <td>hsqldb</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>test</td>
      <td>False</td>
      <td>org.quartz-scheduler</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>default</td>
      <td>False</td>
      <td>org.axonframework</td>
      <td>axon-messaging</td>
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
      <th>158</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>True</td>
      <td>org.hamcrest</td>
      <td>hamcrest-library</td>
    </tr>
    <tr>
      <th>159</th>
      <td>axon-tracing-opentelemetry</td>
      <td>Axon Framework - OpenTelemetry Tracing</td>
      <td>default</td>
      <td>False</td>
      <td>${project.groupId}</td>
      <td>axon-configuration</td>
    </tr>
    <tr>
      <th>160</th>
      <td>axon-tracing-opentelemetry</td>
      <td>Axon Framework - OpenTelemetry Tracing</td>
      <td>default</td>
      <td>False</td>
      <td>${project.groupId}</td>
      <td>axon-messaging</td>
    </tr>
    <tr>
      <th>161</th>
      <td>axon-tracing-opentelemetry</td>
      <td>Axon Framework - OpenTelemetry Tracing</td>
      <td>provided</td>
      <td>False</td>
      <td>com.google.code.findbugs</td>
      <td>jsr305</td>
    </tr>
    <tr>
      <th>162</th>
      <td>axon-tracing-opentelemetry</td>
      <td>Axon Framework - OpenTelemetry Tracing</td>
      <td>default</td>
      <td>False</td>
      <td>io.opentelemetry</td>
      <td>opentelemetry-api</td>
    </tr>
  </tbody>
</table>
<p>163 rows × 6 columns</p>
</div>


