# External Dependencies of Java Artifacts with Neo4j
<br>  

### References
- [jqassistant](https://jqassistant.org)
- [py2neo](https://py2neo.org/2021.1/)





## External Package Usage

### External Package

A package is categorized as "external" if it is utilized as a dependency, or if any of its enclosed types are used as dependencies, but the code within it has not been analyzed (missing bytecode). This also applies to all build-in Java types, but they are explicitly filtered out here.

### External annotation dependency

The aforementioned classification encompasses external annotation dependencies as well. These dependencies introduce significantly less coupling and are not indispensable for compiling code. Without the external annotation the code would most probably behave differently. Hence, they are included in the first more overall and general tables and then left out in the later more specific ones.

### Table 1 - Top 20 most used external packages overall

This table shows the external packages that are used by the most different internal types overall.
Additionally, it shows which types of the external package are actually used. External annotations are also listed.

**Columns:**
- *externalPackageName* identifies the external package as described above
- *numberOfExternalTypeCaller* refers to the distinct types that make use of the external package
- *numberOfExternalTypeCalls* includes every invocation or reference to the types in the external package
- *allTypes* represents the total count of all analyzed types in general
- *externalTypeNames* contains a list of actually utilized types of the external package




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>externalPackageName</th>
      <th>numberOfExternalTypeCaller</th>
      <th>numberOfExternalTypeCalls</th>
      <th>allTypes</th>
      <th>externalTypeNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>javax.annotation</td>
      <td>325</td>
      <td>1419</td>
      <td>2506</td>
      <td>[Nonnull, Nullable, PreDestroy]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.slf4j</td>
      <td>193</td>
      <td>541</td>
      <td>2506</td>
      <td>[LoggerFactory, Logger]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>78</td>
      <td>339</td>
      <td>2506</td>
      <td>[MappedSuperclass, IdClass, Id, Entity, Index,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>jakarta.persistence</td>
      <td>69</td>
      <td>327</td>
      <td>2506</td>
      <td>[IdClass, Id, MappedSuperclass, Index, Table, ...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.hamcrest</td>
      <td>61</td>
      <td>498</td>
      <td>2506</td>
      <td>[Description, StringDescription, CoreMatchers,...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>54</td>
      <td>84</td>
      <td>2506</td>
      <td>[JsonProperty, JsonCreator, JsonGetter, JsonTy...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.quartz</td>
      <td>37</td>
      <td>226</td>
      <td>2506</td>
      <td>[JobDataMap, Job, JobExecutionContext, JobDeta...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>reactor.core.publisher</td>
      <td>33</td>
      <td>149</td>
      <td>2506</td>
      <td>[Mono, Flux, FluxSink$OverflowStrategy, FluxSi...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>15</td>
      <td>73</td>
      <td>2506</td>
      <td>[JsonDeserializer, DeserializationContext, Jso...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.reactivestreams</td>
      <td>13</td>
      <td>41</td>
      <td>2506</td>
      <td>[Publisher]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.thoughtworks.xstream.io</td>
      <td>9</td>
      <td>46</td>
      <td>2506</td>
      <td>[HierarchicalStreamWriter, HierarchicalStreamR...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>com.lmax.disruptor</td>
      <td>9</td>
      <td>29</td>
      <td>2506</td>
      <td>[RingBuffer, EventHandler, LifecycleAware, Blo...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>javax.cache.event</td>
      <td>8</td>
      <td>34</td>
      <td>2506</td>
      <td>[CacheEntryListener, CacheEntryListenerExcepti...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>javax.sql</td>
      <td>6</td>
      <td>24</td>
      <td>2506</td>
      <td>[DataSource]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.thoughtworks.xstream.converters</td>
      <td>6</td>
      <td>12</td>
      <td>2506</td>
      <td>[MarshallingContext, UnmarshallingContext]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>javax.validation</td>
      <td>5</td>
      <td>22</td>
      <td>2506</td>
      <td>[ConstraintViolation, Validation, Validator, V...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>nu.xom</td>
      <td>5</td>
      <td>16</td>
      <td>2506</td>
      <td>[Document, Builder, ParsingException]</td>
    </tr>
    <tr>
      <th>17</th>
      <td>net.sf.ehcache</td>
      <td>5</td>
      <td>63</td>
      <td>2506</td>
      <td>[Ehcache, Element, CacheException]</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.lmax.disruptor.dsl</td>
      <td>5</td>
      <td>22</td>
      <td>2506</td>
      <td>[EventHandlerGroup, Disruptor, ProducerType]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.thoughtworks.xstream.mapper</td>
      <td>5</td>
      <td>10</td>
      <td>2506</td>
      <td>[Mapper, CannotResolveClassException]</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 1 - Most called external packages in %

Packages that are used less than 0.7% are grouped into the name "others" to get a cleaner chart
with the most significant external packages and how ofter they are called in percent.


    
![png](ExternalDependencies_files/ExternalDependencies_13_0.png)
    


### Table 2 - Top 20 least used external packages overall

This table identifies external packages that aren't used very often. This could help to find libraries that aren't actually needed or maybe easily replaceable. Some of them might be used sparsely on purpose for example as an adapter to an external library that is actually important. Thus, decisions need to be made on a case-by-case basis.

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
      <td>org.junit.rules</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.junit.jupiter.api</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.xml.stream</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.testcontainers.containers.wait.strategy</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>com.fasterxml.jackson.datatype.jsr310</td>
      <td>2</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.quartz.impl.matchers</td>
      <td>2</td>
    </tr>
    <tr>
      <th>6</th>
      <td>reactor.core</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.junit.runner</td>
      <td>2</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.databind.type</td>
      <td>3</td>
    </tr>
    <tr>
      <th>9</th>
      <td>reactor.util.concurrent</td>
      <td>3</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>3</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.dom4j.io</td>
      <td>3</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>3</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.junit.jupiter.api.extension</td>
      <td>6</td>
    </tr>
    <tr>
      <th>14</th>
      <td>reactor.util.context</td>
      <td>7</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.thoughtworks.xstream.converters.collections</td>
      <td>7</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.junit.runners.model</td>
      <td>8</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.testcontainers.containers</td>
      <td>8</td>
    </tr>
    <tr>
      <th>18</th>
      <td>net.sf.ehcache.event</td>
      <td>9</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.thoughtworks.xstream.mapper</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3 - External usage per artifact

The following table shows the most used external packages separately for each artifact including external annotations. 

**Columns:**
- *artifactName* is used to group the the external package usage per artifact for a more detailed analysis.
- *externalPackageName* identifies the external package as described above
- *numberOfExternalTypeCaller* refers to the distinct types that make use of the external package
- *numberOfExternalTypeCalls* includes every invocation or reference to the types in the external package
- *numberOfTypesInArtifact* represents the total count of all analyzed types for the artifact
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
      <th>externalTypeNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-configuration-4.7.5</td>
      <td>javax.annotation</td>
      <td>12</td>
      <td>104</td>
      <td>39</td>
      <td>[Nonnull]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.7.5</td>
      <td>org.slf4j</td>
      <td>9</td>
      <td>28</td>
      <td>39</td>
      <td>[LoggerFactory, Logger]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.7.5</td>
      <td>org.slf4j</td>
      <td>12</td>
      <td>22</td>
      <td>22</td>
      <td>[LoggerFactory, Logger]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.7.5</td>
      <td>com.lmax.disruptor</td>
      <td>9</td>
      <td>29</td>
      <td>22</td>
      <td>[EventHandler, LifecycleAware, RingBuffer, Exc...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.7.5</td>
      <td>javax.annotation</td>
      <td>6</td>
      <td>23</td>
      <td>22</td>
      <td>[Nonnull]</td>
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
      <th>61</th>
      <td>axon-test-4.7.5</td>
      <td>org.testcontainers.containers</td>
      <td>2</td>
      <td>8</td>
      <td>85</td>
      <td>[GenericContainer]</td>
    </tr>
    <tr>
      <th>62</th>
      <td>axon-test-4.7.5</td>
      <td>org.junit.runners.model</td>
      <td>2</td>
      <td>8</td>
      <td>85</td>
      <td>[Statement]</td>
    </tr>
    <tr>
      <th>63</th>
      <td>axon-test-4.7.5</td>
      <td>org.junit.jupiter.api</td>
      <td>1</td>
      <td>1</td>
      <td>85</td>
      <td>[Assertions]</td>
    </tr>
    <tr>
      <th>64</th>
      <td>axon-test-4.7.5</td>
      <td>org.junit.rules</td>
      <td>1</td>
      <td>1</td>
      <td>85</td>
      <td>[TestRule]</td>
    </tr>
    <tr>
      <th>65</th>
      <td>axon-test-4.7.5</td>
      <td>org.junit.runner</td>
      <td>1</td>
      <td>2</td>
      <td>85</td>
      <td>[Description]</td>
    </tr>
  </tbody>
</table>
<p>66 rows × 6 columns</p>
</div>



### Table 4 - External usage per artifact and package

The next table lists internal packages and the artifacts they belong to that use many different external types of a specific external package without taken external annotations into account. Only the first 30 rows are shown.

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
      <td>axon-test-4.7.5</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.hamcrest</td>
      <td>38</td>
      <td>188</td>
      <td>24</td>
      <td>[Description, Matcher, TypeSafeMatcher, BaseMa...</td>
      <td>matchers</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.queryhandling</td>
      <td>reactor.core.publisher</td>
      <td>26</td>
      <td>115</td>
      <td>40</td>
      <td>[Signal, MonoSink, Flux, Sinks$ManySpec, Emitt...</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.scheduling.quartz</td>
      <td>org.quartz</td>
      <td>19</td>
      <td>95</td>
      <td>6</td>
      <td>[Scheduler, Job, SchedulerContext, JobExecutio...</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.deadline.quartz</td>
      <td>org.quartz</td>
      <td>18</td>
      <td>131</td>
      <td>4</td>
      <td>[JobDataMap, Trigger, JobDetail, Scheduler, Sc...</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling</td>
      <td>org.slf4j</td>
      <td>15</td>
      <td>55</td>
      <td>93</td>
      <td>[Logger, LoggerFactory]</td>
      <td>eventhandling</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization.json</td>
      <td>com.fasterxml.jackson.databind</td>
      <td>15</td>
      <td>73</td>
      <td>7</td>
      <td>[JsonNode, ObjectMapper, ObjectWriter, ObjectR...</td>
      <td>json</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.pooled</td>
      <td>org.slf4j</td>
      <td>13</td>
      <td>59</td>
      <td>20</td>
      <td>[Logger, LoggerFactory]</td>
      <td>pooled</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-disruptor-4.7.5</td>
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
      <td>axon-configuration-4.7.5</td>
      <td>org.axonframework.config</td>
      <td>org.slf4j</td>
      <td>9</td>
      <td>28</td>
      <td>39</td>
      <td>[LoggerFactory, Logger]</td>
      <td>config</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-disruptor-4.7.5</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>com.lmax.disruptor</td>
      <td>9</td>
      <td>29</td>
      <td>22</td>
      <td>[ExceptionHandler, RingBuffer, EventHandler, L...</td>
      <td>commandhandling</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-test-4.7.5</td>
      <td>org.axonframework.test.saga</td>
      <td>org.hamcrest</td>
      <td>9</td>
      <td>91</td>
      <td>21</td>
      <td>[Description, StringDescription, Matcher, Core...</td>
      <td>saga</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>org.slf4j</td>
      <td>8</td>
      <td>15</td>
      <td>10</td>
      <td>[Logger, LoggerFactory]</td>
      <td>legacyjpa</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.common.caching</td>
      <td>javax.cache.event</td>
      <td>8</td>
      <td>34</td>
      <td>12</td>
      <td>[CacheEntryListener, CacheEntryListenerExcepti...</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>org.slf4j</td>
      <td>8</td>
      <td>15</td>
      <td>54</td>
      <td>[LoggerFactory, Logger]</td>
      <td>annotation</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>reactor.core.publisher</td>
      <td>7</td>
      <td>34</td>
      <td>8</td>
      <td>[Mono, Flux]</td>
      <td>responsetypes</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.queryhandling</td>
      <td>org.reactivestreams</td>
      <td>7</td>
      <td>27</td>
      <td>40</td>
      <td>[Publisher]</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.queryhandling</td>
      <td>org.slf4j</td>
      <td>7</td>
      <td>16</td>
      <td>40</td>
      <td>[LoggerFactory, Logger]</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-test-4.7.5</td>
      <td>org.axonframework.test.aggregate</td>
      <td>org.hamcrest</td>
      <td>7</td>
      <td>136</td>
      <td>19</td>
      <td>[StringDescription, Description, CoreMatchers,...</td>
      <td>aggregate</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>org.slf4j</td>
      <td>6</td>
      <td>9</td>
      <td>31</td>
      <td>[Logger, LoggerFactory]</td>
      <td>eventstore</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>org.reactivestreams</td>
      <td>6</td>
      <td>14</td>
      <td>8</td>
      <td>[Publisher]</td>
      <td>responsetypes</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization</td>
      <td>com.thoughtworks.xstream.io</td>
      <td>6</td>
      <td>39</td>
      <td>34</td>
      <td>[HierarchicalStreamWriter, HierarchicalStreamR...</td>
      <td>serialization</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization</td>
      <td>com.thoughtworks.xstream.converters</td>
      <td>6</td>
      <td>12</td>
      <td>34</td>
      <td>[MarshallingContext, UnmarshallingContext]</td>
      <td>serialization</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-modelling-4.7.5</td>
      <td>org.axonframework.modelling.saga.repository.jpa</td>
      <td>jakarta.persistence</td>
      <td>6</td>
      <td>68</td>
      <td>7</td>
      <td>[TypedQuery, EntityNotFoundException, EntityMa...</td>
      <td>jpa</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-disruptor-4.7.5</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>com.lmax.disruptor.dsl</td>
      <td>5</td>
      <td>22</td>
      <td>22</td>
      <td>[Disruptor, EventHandlerGroup, ProducerType]</td>
      <td>commandhandling</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>jakarta.persistence</td>
      <td>5</td>
      <td>42</td>
      <td>7</td>
      <td>[EntityManager, Query, TypedQuery, EntityExist...</td>
      <td>jpa</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.common</td>
      <td>org.slf4j</td>
      <td>5</td>
      <td>15</td>
      <td>28</td>
      <td>[Logger, LoggerFactory]</td>
      <td>common</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.common.caching</td>
      <td>net.sf.ehcache</td>
      <td>5</td>
      <td>63</td>
      <td>12</td>
      <td>[Element, Ehcache, CacheException]</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>org.slf4j</td>
      <td>5</td>
      <td>16</td>
      <td>15</td>
      <td>[LoggerFactory, Logger]</td>
      <td>async</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.deadletter.jpa</td>
      <td>jakarta.persistence</td>
      <td>5</td>
      <td>54</td>
      <td>9</td>
      <td>[Query, NoResultException, TypedQuery, EntityM...</td>
      <td>jpa</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.tokenstore.jpa</td>
      <td>jakarta.persistence</td>
      <td>5</td>
      <td>64</td>
      <td>4</td>
      <td>[LockModeType, Query, TypedQuery, EntityManager]</td>
      <td>jpa</td>
    </tr>
  </tbody>
</table>
</div>



### Table 5 - Top 20 external package usage per type

This table lists the internal types that utilize the most different external types and packages. These have the highest probability of change depending on external libraries. A case-by-case approach is also advisable here because there could for example also be code units that encapsulate an external library and have this high count of external dependencies on purpose.

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
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization.json</td>
      <td>JacksonSerializer</td>
      <td>9</td>
      <td>29</td>
      <td>6</td>
      <td>9</td>
      <td>[com.fasterxml.jackson.core, com.fasterxml.jac...</td>
      <td>[com.fasterxml.jackson.core.JsonProcessingExce...</td>
      <td>json</td>
      <td>org.axonframework.serialization.json.JacksonSe...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization.xml</td>
      <td>XStreamSerializer</td>
      <td>7</td>
      <td>22</td>
      <td>5</td>
      <td>7</td>
      <td>[nu.xom, com.thoughtworks.xstream.io.xml, org....</td>
      <td>[nu.xom.Document, com.thoughtworks.xstream.io....</td>
      <td>xml</td>
      <td>org.axonframework.serialization.xml.XStreamSer...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.7.5</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>DisruptorCommandBus$DisruptorRepository</td>
      <td>4</td>
      <td>14</td>
      <td>4</td>
      <td>4</td>
      <td>[com.lmax.disruptor, org.slf4j, javax.annotati...</td>
      <td>[com.lmax.disruptor.RingBuffer, org.slf4j.Logg...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Di...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.7.5</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>DisruptorCommandBus</td>
      <td>6</td>
      <td>34</td>
      <td>4</td>
      <td>6</td>
      <td>[org.slf4j, com.lmax.disruptor.dsl, javax.anno...</td>
      <td>[org.slf4j.Logger, com.lmax.disruptor.dsl.Even...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Di...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.deadline.quartz</td>
      <td>QuartzDeadlineManager</td>
      <td>13</td>
      <td>78</td>
      <td>4</td>
      <td>13</td>
      <td>[org.quartz.impl.matchers, org.slf4j, org.quar...</td>
      <td>[org.quartz.impl.matchers.GroupMatcher, org.sl...</td>
      <td>quartz</td>
      <td>org.axonframework.deadline.quartz.QuartzDeadli...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>MultipleInstancesResponseType</td>
      <td>7</td>
      <td>17</td>
      <td>4</td>
      <td>7</td>
      <td>[reactor.core.publisher, com.fasterxml.jackson...</td>
      <td>[reactor.core.publisher.Mono, com.fasterxml.ja...</td>
      <td>responsetypes</td>
      <td>org.axonframework.messaging.responsetypes.Mult...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.queryhandling</td>
      <td>SimpleQueryUpdateEmitter</td>
      <td>13</td>
      <td>33</td>
      <td>4</td>
      <td>13</td>
      <td>[reactor.core.publisher, org.reactivestreams, ...</td>
      <td>[reactor.core.publisher.Sinks$ManySpec, reacto...</td>
      <td>queryhandling</td>
      <td>org.axonframework.queryhandling.SimpleQueryUpd...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.queryhandling</td>
      <td>SimpleQueryBus</td>
      <td>6</td>
      <td>55</td>
      <td>4</td>
      <td>6</td>
      <td>[org.slf4j, org.reactivestreams, javax.annotat...</td>
      <td>[org.slf4j.LoggerFactory, org.reactivestreams....</td>
      <td>queryhandling</td>
      <td>org.axonframework.queryhandling.SimpleQueryBus</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization</td>
      <td>GapAwareTrackingTokenConverter</td>
      <td>6</td>
      <td>25</td>
      <td>4</td>
      <td>6</td>
      <td>[com.thoughtworks.xstream.io, com.thoughtworks...</td>
      <td>[com.thoughtworks.xstream.io.HierarchicalStrea...</td>
      <td>serialization</td>
      <td>org.axonframework.serialization.GapAwareTracki...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization</td>
      <td>GapAwareTrackingTokenConverter$ReflectivelyCon...</td>
      <td>6</td>
      <td>25</td>
      <td>4</td>
      <td>6</td>
      <td>[com.thoughtworks.xstream.converters.collectio...</td>
      <td>[com.thoughtworks.xstream.converters.collectio...</td>
      <td>serialization</td>
      <td>org.axonframework.serialization.GapAwareTracki...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.7.5</td>
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
      <th>11</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization.json</td>
      <td>MetaDataDeserializer</td>
      <td>6</td>
      <td>21</td>
      <td>4</td>
      <td>6</td>
      <td>[com.fasterxml.jackson.core, com.fasterxml.jac...</td>
      <td>[com.fasterxml.jackson.core.JacksonException, ...</td>
      <td>json</td>
      <td>org.axonframework.serialization.json.MetaDataD...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-disruptor-4.7.5</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>DisruptorCommandBus$ExceptionHandler</td>
      <td>3</td>
      <td>5</td>
      <td>3</td>
      <td>3</td>
      <td>[com.lmax.disruptor, com.lmax.disruptor.dsl, o...</td>
      <td>[com.lmax.disruptor.ExceptionHandler, com.lmax...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Di...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-disruptor-4.7.5</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>BlacklistDetectingCallback</td>
      <td>4</td>
      <td>11</td>
      <td>3</td>
      <td>4</td>
      <td>[javax.annotation, org.slf4j, com.lmax.disruptor]</td>
      <td>[javax.annotation.Nonnull, org.slf4j.LoggerFac...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Bl...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>JpaEventStorageEngine</td>
      <td>6</td>
      <td>47</td>
      <td>3</td>
      <td>6</td>
      <td>[org.slf4j, jakarta.persistence, javax.annotat...</td>
      <td>[org.slf4j.Logger, jakarta.persistence.EntityM...</td>
      <td>jpa</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>SQLErrorCodesResolver</td>
      <td>4</td>
      <td>12</td>
      <td>3</td>
      <td>4</td>
      <td>[org.slf4j, javax.sql, jakarta.persistence]</td>
      <td>[org.slf4j.LoggerFactory, org.slf4j.Logger, ja...</td>
      <td>jpa</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>SQLErrorCodesResolver</td>
      <td>4</td>
      <td>12</td>
      <td>3</td>
      <td>4</td>
      <td>[org.slf4j, javax.sql, javax.persistence]</td>
      <td>[org.slf4j.LoggerFactory, javax.sql.DataSource...</td>
      <td>legacyjpa</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>JpaEventStorageEngine</td>
      <td>6</td>
      <td>47</td>
      <td>3</td>
      <td>6</td>
      <td>[javax.persistence, org.slf4j, javax.annotation]</td>
      <td>[javax.persistence.Query, org.slf4j.LoggerFact...</td>
      <td>legacyjpa</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.deadline.jobrunr</td>
      <td>JobRunrDeadlineManager</td>
      <td>5</td>
      <td>18</td>
      <td>3</td>
      <td>5</td>
      <td>[javax.annotation, org.slf4j, org.jobrunr.sche...</td>
      <td>[javax.annotation.Nonnull, org.slf4j.LoggerFac...</td>
      <td>jobrunr</td>
      <td>org.axonframework.deadline.jobrunr.JobRunrDead...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.deadletter.jpa</td>
      <td>JpaSequencedDeadLetterQueue</td>
      <td>7</td>
      <td>74</td>
      <td>3</td>
      <td>7</td>
      <td>[javax.annotation, jakarta.persistence, org.sl...</td>
      <td>[javax.annotation.Nonnull, jakarta.persistence...</td>
      <td>jpa</td>
      <td>org.axonframework.eventhandling.deadletter.jpa...</td>
    </tr>
  </tbody>
</table>
</div>



### Table 6 - External package usage distribution per type

The next table shown here only includes the first 20 rows.
It shows how many types use one external package, how many use two, etc. .
This gives an overview of the distribution of external package calls and the overall coupling to external libraries. The higher the count of distinct external packages the lower should be the count of types that use them. Dependencies to external annotations are left out here.

Have a look above to find out which types have the highest external package dependency usage.

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
      <th>artifactTypes</th>
      <th>numberOfExternalPackages</th>
      <th>numberOfTypes</th>
      <th>numberOfTypesPercentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-configuration-4.7.5</td>
      <td>39</td>
      <td>1</td>
      <td>5</td>
      <td>12.820513</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.7.5</td>
      <td>22</td>
      <td>1</td>
      <td>2</td>
      <td>9.090909</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.7.5</td>
      <td>22</td>
      <td>2</td>
      <td>4</td>
      <td>18.181818</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.7.5</td>
      <td>22</td>
      <td>3</td>
      <td>3</td>
      <td>13.636364</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>130</td>
      <td>1</td>
      <td>12</td>
      <td>9.230769</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>130</td>
      <td>2</td>
      <td>3</td>
      <td>2.307692</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>130</td>
      <td>3</td>
      <td>2</td>
      <td>1.538462</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.7.5</td>
      <td>729</td>
      <td>1</td>
      <td>100</td>
      <td>13.717421</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.7.5</td>
      <td>729</td>
      <td>2</td>
      <td>29</td>
      <td>3.978052</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.7.5</td>
      <td>729</td>
      <td>3</td>
      <td>5</td>
      <td>0.685871</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.7.5</td>
      <td>729</td>
      <td>4</td>
      <td>4</td>
      <td>0.548697</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-messaging-4.7.5</td>
      <td>729</td>
      <td>5</td>
      <td>2</td>
      <td>0.274348</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-modelling-4.7.5</td>
      <td>149</td>
      <td>1</td>
      <td>10</td>
      <td>6.711409</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-modelling-4.7.5</td>
      <td>149</td>
      <td>2</td>
      <td>3</td>
      <td>2.013423</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-test-4.7.5</td>
      <td>85</td>
      <td>1</td>
      <td>28</td>
      <td>32.941176</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-test-4.7.5</td>
      <td>85</td>
      <td>2</td>
      <td>2</td>
      <td>2.352941</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-test-4.7.5</td>
      <td>85</td>
      <td>3</td>
      <td>3</td>
      <td>3.529412</td>
    </tr>
  </tbody>
</table>
</div>



### Table 7 - External package usage distribution in percentage

The following table uses the same data as Table 6 but has a column per internal artifact and a row for the number of different external packages used. The values are the percentages of types that fulfill both conditions so they belong to artifact and have the exact count of different external packages used. Dependencies to external annotations are left out here.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>artifactName</th>
      <th>axon-configuration-4.7.5</th>
      <th>axon-disruptor-4.7.5</th>
      <th>axon-eventsourcing-4.7.5</th>
      <th>axon-messaging-4.7.5</th>
      <th>axon-modelling-4.7.5</th>
      <th>axon-test-4.7.5</th>
    </tr>
    <tr>
      <th>numberOfExternalPackages</th>
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
      <th>1</th>
      <td>12.820513</td>
      <td>9.090909</td>
      <td>9.230769</td>
      <td>13.717421</td>
      <td>6.711409</td>
      <td>32.941176</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.000000</td>
      <td>18.181818</td>
      <td>2.307692</td>
      <td>3.978052</td>
      <td>2.013423</td>
      <td>2.352941</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.000000</td>
      <td>13.636364</td>
      <td>1.538462</td>
      <td>0.685871</td>
      <td>0.000000</td>
      <td>3.529412</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.548697</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.274348</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Chart 2 - External package usage distribution in percentage

The next chart shows the number of types per artifact that use the given number of different external packages as listed in Table 7. Dependencies to external annotations are left out here.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependencies_files/ExternalDependencies_27_1.png)
    


### Chart 3 - External package usage distribution in percentage stacked per artifact

The following chart shows a stacked bar for each artifact. Every color represents a different count of different external packages used. The y axis then shows how many percent of types (compared to all types of that artifact) use these external packages. By stacking them above each other it is easier to compare the artifacts and their external package usage. Dependencies to external annotations are left out here.


    <Figure size 640x480 with 0 Axes>



    
![png](ExternalDependencies_files/ExternalDependencies_29_1.png)
    


## Maven POMs


### Table 8 - Maven POMs and their declared dependencies

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
      <td>False</td>
      <td>${project.groupId}</td>
      <td>axon-messaging</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>test</td>
      <td>False</td>
      <td>org.hsqldb</td>
      <td>hsqldb</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>default</td>
      <td>True</td>
      <td>jakarta.annotation</td>
      <td>jakarta.annotation-api</td>
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
      <td>test</td>
      <td>False</td>
      <td>jakarta.persistence</td>
      <td>jakarta.persistence-api</td>
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
      <th>104</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>test</td>
      <td>False</td>
      <td>javax.inject</td>
      <td>javax.inject</td>
    </tr>
    <tr>
      <th>105</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>False</td>
      <td>org.junit.jupiter</td>
      <td>junit-jupiter</td>
    </tr>
    <tr>
      <th>106</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>True</td>
      <td>org.hamcrest</td>
      <td>hamcrest</td>
    </tr>
    <tr>
      <th>107</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>False</td>
      <td>${project.groupId}</td>
      <td>axon-eventsourcing</td>
    </tr>
    <tr>
      <th>108</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>True</td>
      <td>junit</td>
      <td>junit</td>
    </tr>
  </tbody>
</table>
<p>109 rows × 6 columns</p>
</div>


