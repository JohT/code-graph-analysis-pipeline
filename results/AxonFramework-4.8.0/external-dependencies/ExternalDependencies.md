# External Dependencies
<br>  

### References
- [jqassistant](https://jqassistant.org)
- [py2neo](https://py2neo.org/2021.1/)





## External Package Usage

### External Package

An external type has no `byteCodeVersion` since it only occurs as a dependency but wasn't analyzed itself (missing bytecode). Core Java types like `java.lang.Integer` and primitives like `int` are considered "build-in" and therefore aren't interpreted as "external" even though their byte code is also missing. A package is categorized as "external" if the types it contains are classified as external.

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
      <td>339</td>
      <td>1565</td>
      <td>2584</td>
      <td>[Nonnull, Nullable, PreDestroy]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.slf4j</td>
      <td>201</td>
      <td>579</td>
      <td>2584</td>
      <td>[LoggerFactory, Logger]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.persistence</td>
      <td>78</td>
      <td>340</td>
      <td>2584</td>
      <td>[TypedQuery, EntityManager, MappedSuperclass, ...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>jakarta.persistence</td>
      <td>69</td>
      <td>328</td>
      <td>2584</td>
      <td>[EntityManager, TypedQuery, Basic, MappedSuper...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.hamcrest</td>
      <td>61</td>
      <td>498</td>
      <td>2584</td>
      <td>[Description, StringDescription, CoreMatchers,...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>com.fasterxml.jackson.annotation</td>
      <td>57</td>
      <td>87</td>
      <td>2584</td>
      <td>[JsonGetter, JsonProperty, JsonTypeInfo$Id, Js...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.quartz</td>
      <td>37</td>
      <td>226</td>
      <td>2584</td>
      <td>[Scheduler, JobDetail, SchedulerContext, JobEx...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>reactor.core.publisher</td>
      <td>35</td>
      <td>157</td>
      <td>2584</td>
      <td>[Mono, Flux, FluxSink$OverflowStrategy, FluxSi...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.databind</td>
      <td>15</td>
      <td>73</td>
      <td>2584</td>
      <td>[DeserializationContext, JsonDeserializer, Obj...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.reactivestreams</td>
      <td>13</td>
      <td>41</td>
      <td>2584</td>
      <td>[Publisher]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>10</td>
      <td>50</td>
      <td>2584</td>
      <td>[Task, TaskInstance, ExecutionContext, TaskWit...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>com.lmax.disruptor</td>
      <td>9</td>
      <td>29</td>
      <td>2584</td>
      <td>[RingBuffer, LifecycleAware, EventHandler, Blo...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.thoughtworks.xstream.io</td>
      <td>9</td>
      <td>46</td>
      <td>2584</td>
      <td>[HierarchicalStreamWriter, HierarchicalStreamR...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>javax.cache.event</td>
      <td>8</td>
      <td>34</td>
      <td>2584</td>
      <td>[CacheEntryRemovedListener, CacheEntryEventFil...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.ehcache.event</td>
      <td>8</td>
      <td>33</td>
      <td>2584</td>
      <td>[EventType, EventOrdering, CacheEventListener,...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>com.github.kagkarlsson.scheduler</td>
      <td>7</td>
      <td>54</td>
      <td>2584</td>
      <td>[Scheduler, SchedulerState, ScheduledExecution]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.thoughtworks.xstream.converters</td>
      <td>6</td>
      <td>12</td>
      <td>2584</td>
      <td>[MarshallingContext, UnmarshallingContext]</td>
    </tr>
    <tr>
      <th>17</th>
      <td>javax.sql</td>
      <td>6</td>
      <td>24</td>
      <td>2584</td>
      <td>[DataSource]</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.jobrunr.scheduling</td>
      <td>6</td>
      <td>37</td>
      <td>2584</td>
      <td>[JobScheduler, JobBuilder]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.lmax.disruptor.dsl</td>
      <td>5</td>
      <td>22</td>
      <td>2584</td>
      <td>[ProducerType, EventHandlerGroup, Disruptor]</td>
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
      <td>reactor.core</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.junit.runner</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.jobrunr.jobs</td>
      <td>2</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.ehcache.config</td>
      <td>2</td>
    </tr>
    <tr>
      <th>6</th>
      <td>javax.xml.stream</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.quartz.impl.matchers</td>
      <td>2</td>
    </tr>
    <tr>
      <th>8</th>
      <td>com.fasterxml.jackson.datatype.jsr310</td>
      <td>2</td>
    </tr>
    <tr>
      <th>9</th>
      <td>com.fasterxml.jackson.databind.jsontype</td>
      <td>3</td>
    </tr>
    <tr>
      <th>10</th>
      <td>com.fasterxml.jackson.databind.type</td>
      <td>3</td>
    </tr>
    <tr>
      <th>11</th>
      <td>reactor.util.concurrent</td>
      <td>3</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.fasterxml.jackson.databind.module</td>
      <td>3</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.dom4j.io</td>
      <td>3</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.testcontainers.containers.wait.strategy</td>
      <td>5</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.junit.jupiter.api.extension</td>
      <td>6</td>
    </tr>
    <tr>
      <th>16</th>
      <td>com.thoughtworks.xstream.converters.collections</td>
      <td>7</td>
    </tr>
    <tr>
      <th>17</th>
      <td>reactor.util.context</td>
      <td>7</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.junit.runners.model</td>
      <td>8</td>
    </tr>
    <tr>
      <th>19</th>
      <td>com.google.gson</td>
      <td>9</td>
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
      <td>axon-configuration-4.8.0</td>
      <td>javax.annotation</td>
      <td>12</td>
      <td>104</td>
      <td>39</td>
      <td>[Nonnull]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.8.0</td>
      <td>org.slf4j</td>
      <td>9</td>
      <td>28</td>
      <td>39</td>
      <td>[LoggerFactory, Logger]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.8.0</td>
      <td>org.slf4j</td>
      <td>12</td>
      <td>22</td>
      <td>22</td>
      <td>[Logger, LoggerFactory]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.8.0</td>
      <td>com.lmax.disruptor</td>
      <td>9</td>
      <td>29</td>
      <td>22</td>
      <td>[ExceptionHandler, EventHandler, RingBuffer, L...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.8.0</td>
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
      <th>69</th>
      <td>axon-test-4.8.0</td>
      <td>org.junit.jupiter.api.extension</td>
      <td>3</td>
      <td>6</td>
      <td>87</td>
      <td>[AfterEachCallback, BeforeEachCallback, Extens...</td>
    </tr>
    <tr>
      <th>70</th>
      <td>axon-test-4.8.0</td>
      <td>org.junit.runners.model</td>
      <td>2</td>
      <td>8</td>
      <td>87</td>
      <td>[Statement]</td>
    </tr>
    <tr>
      <th>71</th>
      <td>axon-test-4.8.0</td>
      <td>org.junit.jupiter.api</td>
      <td>1</td>
      <td>1</td>
      <td>87</td>
      <td>[Assertions]</td>
    </tr>
    <tr>
      <th>72</th>
      <td>axon-test-4.8.0</td>
      <td>org.junit.rules</td>
      <td>1</td>
      <td>1</td>
      <td>87</td>
      <td>[TestRule]</td>
    </tr>
    <tr>
      <th>73</th>
      <td>axon-test-4.8.0</td>
      <td>org.junit.runner</td>
      <td>1</td>
      <td>2</td>
      <td>87</td>
      <td>[Description]</td>
    </tr>
  </tbody>
</table>
<p>74 rows × 6 columns</p>
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
      <td>axon-test-4.8.0</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.hamcrest</td>
      <td>38</td>
      <td>188</td>
      <td>24</td>
      <td>[Matcher, Description, TypeSafeMatcher, BaseMa...</td>
      <td>matchers</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.queryhandling</td>
      <td>reactor.core.publisher</td>
      <td>28</td>
      <td>123</td>
      <td>42</td>
      <td>[Mono, MonoSink, Flux, FluxSink, FluxSink$Over...</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.eventhandling.scheduling.quartz</td>
      <td>org.quartz</td>
      <td>19</td>
      <td>95</td>
      <td>6</td>
      <td>[JobDataMap, JobDetail, JobExecutionException,...</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.deadline.quartz</td>
      <td>org.quartz</td>
      <td>18</td>
      <td>131</td>
      <td>4</td>
      <td>[Scheduler, TriggerBuilder, JobDataMap, JobKey...</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.serialization.json</td>
      <td>com.fasterxml.jackson.databind</td>
      <td>15</td>
      <td>73</td>
      <td>7</td>
      <td>[ObjectWriter, JsonNode, ObjectMapper, ObjectR...</td>
      <td>json</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-disruptor-4.8.0</td>
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
      <td>axon-configuration-4.8.0</td>
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
      <td>axon-disruptor-4.8.0</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>com.lmax.disruptor</td>
      <td>9</td>
      <td>29</td>
      <td>22</td>
      <td>[LifecycleAware, EventHandler, RingBuffer, Exc...</td>
      <td>commandhandling</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-test-4.8.0</td>
      <td>org.axonframework.test.saga</td>
      <td>org.hamcrest</td>
      <td>9</td>
      <td>91</td>
      <td>21</td>
      <td>[Description, Matcher, StringDescription, Core...</td>
      <td>saga</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-eventsourcing-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.common.caching</td>
      <td>org.ehcache.event</td>
      <td>8</td>
      <td>33</td>
      <td>15</td>
      <td>[EventType, CacheEvent, CacheEventListener, Ev...</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.common.caching</td>
      <td>javax.cache.event</td>
      <td>8</td>
      <td>34</td>
      <td>15</td>
      <td>[CacheEntryRemovedListener, CacheEntryEventFil...</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>org.slf4j</td>
      <td>8</td>
      <td>15</td>
      <td>54</td>
      <td>[LoggerFactory, Logger]</td>
      <td>annotation</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>reactor.core.publisher</td>
      <td>7</td>
      <td>34</td>
      <td>8</td>
      <td>[Flux, Mono]</td>
      <td>responsetypes</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.queryhandling</td>
      <td>org.reactivestreams</td>
      <td>7</td>
      <td>27</td>
      <td>42</td>
      <td>[Publisher]</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.queryhandling</td>
      <td>org.slf4j</td>
      <td>7</td>
      <td>16</td>
      <td>42</td>
      <td>[LoggerFactory, Logger]</td>
      <td>queryhandling</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-test-4.8.0</td>
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
      <td>axon-eventsourcing-4.8.0</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>org.slf4j</td>
      <td>6</td>
      <td>9</td>
      <td>31</td>
      <td>[Logger, LoggerFactory]</td>
      <td>eventstore</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>org.reactivestreams</td>
      <td>6</td>
      <td>14</td>
      <td>8</td>
      <td>[Publisher]</td>
      <td>responsetypes</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.serialization</td>
      <td>com.thoughtworks.xstream.converters</td>
      <td>6</td>
      <td>12</td>
      <td>34</td>
      <td>[UnmarshallingContext, MarshallingContext]</td>
      <td>serialization</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-modelling-4.8.0</td>
      <td>org.axonframework.modelling.saga.repository.jpa</td>
      <td>jakarta.persistence</td>
      <td>6</td>
      <td>68</td>
      <td>7</td>
      <td>[Index, Query, EntityManager, EntityManagerFac...</td>
      <td>jpa</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-disruptor-4.8.0</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>com.lmax.disruptor.dsl</td>
      <td>5</td>
      <td>22</td>
      <td>22</td>
      <td>[EventHandlerGroup, Disruptor, ProducerType]</td>
      <td>commandhandling</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-eventsourcing-4.8.0</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>jakarta.persistence</td>
      <td>5</td>
      <td>42</td>
      <td>7</td>
      <td>[EntityExistsException, Index, TypedQuery, Que...</td>
      <td>jpa</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.common</td>
      <td>org.slf4j</td>
      <td>5</td>
      <td>15</td>
      <td>28</td>
      <td>[Logger, LoggerFactory]</td>
      <td>common</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.common.caching</td>
      <td>net.sf.ehcache</td>
      <td>5</td>
      <td>63</td>
      <td>15</td>
      <td>[Ehcache, CacheException, Element]</td>
      <td>caching</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.deadline.dbscheduler</td>
      <td>com.github.kagkarlsson.scheduler.task</td>
      <td>5</td>
      <td>25</td>
      <td>6</td>
      <td>[Task, TaskInstance, ExecutionContext, TaskWit...</td>
      <td>dbscheduler</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>org.slf4j</td>
      <td>5</td>
      <td>16</td>
      <td>15</td>
      <td>[Logger, LoggerFactory]</td>
      <td>async</td>
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
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.deadline.dbscheduler</td>
      <td>DbSchedulerDeadlineManager</td>
      <td>12</td>
      <td>91</td>
      <td>5</td>
      <td>12</td>
      <td>[javax.annotation, org.slf4j, com.github.kagka...</td>
      <td>[javax.annotation.Nonnull, javax.annotation.Nu...</td>
      <td>dbscheduler</td>
      <td>org.axonframework.deadline.dbscheduler.DbSched...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-disruptor-4.8.0</td>
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
      <th>5</th>
      <td>axon-disruptor-4.8.0</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>DisruptorCommandBus</td>
      <td>6</td>
      <td>34</td>
      <td>4</td>
      <td>6</td>
      <td>[org.slf4j, com.lmax.disruptor, javax.annotati...</td>
      <td>[org.slf4j.Logger, com.lmax.disruptor.RingBuff...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Di...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.8.0</td>
      <td>org.axonframework.deadline.jobrunr</td>
      <td>JobRunrDeadlineManager</td>
      <td>7</td>
      <td>28</td>
      <td>4</td>
      <td>7</td>
      <td>[javax.annotation, org.slf4j, org.jobrunr.sche...</td>
      <td>[javax.annotation.Nonnull, javax.annotation.Nu...</td>
      <td>jobrunr</td>
      <td>org.axonframework.deadline.jobrunr.JobRunrDead...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-messaging-4.8.0</td>
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
      <th>14</th>
      <td>axon-messaging-4.8.0</td>
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
      <th>15</th>
      <td>axon-messaging-4.8.0</td>
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
      <td>axon-disruptor-4.8.0</td>
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
      <th>17</th>
      <td>axon-disruptor-4.8.0</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>BlacklistDetectingCallback</td>
      <td>4</td>
      <td>11</td>
      <td>3</td>
      <td>4</td>
      <td>[org.slf4j, com.lmax.disruptor, javax.annotation]</td>
      <td>[org.slf4j.Logger, com.lmax.disruptor.RingBuff...</td>
      <td>commandhandling</td>
      <td>org.axonframework.disruptor.commandhandling.Bl...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-eventsourcing-4.8.0</td>
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
      <td>axon-eventsourcing-4.8.0</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>SQLErrorCodesResolver</td>
      <td>4</td>
      <td>12</td>
      <td>3</td>
      <td>4</td>
      <td>[org.slf4j, javax.sql, jakarta.persistence]</td>
      <td>[org.slf4j.Logger, org.slf4j.LoggerFactory, ja...</td>
      <td>jpa</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa...</td>
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
      <td>axon-configuration-4.8.0</td>
      <td>39</td>
      <td>1</td>
      <td>12</td>
      <td>30.769231</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.8.0</td>
      <td>22</td>
      <td>1</td>
      <td>6</td>
      <td>27.272727</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.8.0</td>
      <td>130</td>
      <td>1</td>
      <td>28</td>
      <td>21.538462</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.8.0</td>
      <td>130</td>
      <td>2</td>
      <td>3</td>
      <td>2.307692</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.8.0</td>
      <td>762</td>
      <td>1</td>
      <td>227</td>
      <td>29.790026</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.8.0</td>
      <td>762</td>
      <td>2</td>
      <td>13</td>
      <td>1.706037</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-modelling-4.8.0</td>
      <td>150</td>
      <td>1</td>
      <td>35</td>
      <td>23.333333</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-modelling-4.8.0</td>
      <td>150</td>
      <td>2</td>
      <td>2</td>
      <td>1.333333</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-test-4.8.0</td>
      <td>87</td>
      <td>1</td>
      <td>10</td>
      <td>11.494253</td>
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
      <th>axon-configuration-4.8.0</th>
      <th>axon-disruptor-4.8.0</th>
      <th>axon-eventsourcing-4.8.0</th>
      <th>axon-messaging-4.8.0</th>
      <th>axon-modelling-4.8.0</th>
      <th>axon-test-4.8.0</th>
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
      <td>30.769231</td>
      <td>27.272727</td>
      <td>21.538462</td>
      <td>29.790026</td>
      <td>23.333333</td>
      <td>11.494253</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2.307692</td>
      <td>1.706037</td>
      <td>1.333333</td>
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
      <td>org.quartz-scheduler</td>
      <td>quartz</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>test</td>
      <td>False</td>
      <td>jakarta.persistence</td>
      <td>jakarta.persistence-api</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>provided</td>
      <td>False</td>
      <td>com.google.code.findbugs</td>
      <td>jsr305</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>default</td>
      <td>False</td>
      <td>org.axonframework</td>
      <td>axon-modelling</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration</td>
      <td>Axon Framework - Configuration</td>
      <td>test</td>
      <td>True</td>
      <td>io.projectreactor</td>
      <td>reactor-core</td>
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
      <th>109</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>True</td>
      <td>org.hamcrest</td>
      <td>hamcrest</td>
    </tr>
    <tr>
      <th>110</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>True</td>
      <td>com.google.code.gson</td>
      <td>gson</td>
    </tr>
    <tr>
      <th>111</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>provided</td>
      <td>False</td>
      <td>com.google.code.findbugs</td>
      <td>jsr305</td>
    </tr>
    <tr>
      <th>112</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>test</td>
      <td>False</td>
      <td>jakarta.persistence</td>
      <td>jakarta.persistence-api</td>
    </tr>
    <tr>
      <th>113</th>
      <td>axon-test</td>
      <td>Axon Framework - Test Fixtures</td>
      <td>default</td>
      <td>True</td>
      <td>org.hamcrest</td>
      <td>hamcrest-library</td>
    </tr>
  </tbody>
</table>
<p>114 rows × 6 columns</p>
</div>


