# Internal Dependencies
<br>  

### References
- [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html)
- [Calculate metrics](https://101.jqassistant.org/calculate-metrics/index.html)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)





## Artifacts

List the artifacts this notebook is based on. Different sorting variations help finding artifacts by their features and support larger code bases where the list of all artifacts gets too long.

Only the top 30 entries are shown. The whole table can be found in the following CSV report:  
`List_all_existing_artifacts`

### Table 1a - Top 30 artifacts with the highest package count




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packages</th>
      <th>types</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3.jar</td>
      <td>64</td>
      <td>786</td>
      <td>5</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3.jar</td>
      <td>10</td>
      <td>156</td>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.9.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.9.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.9.3.jar</td>
      <td>1</td>
      <td>40</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1b - Top 30 artifacts with the highest type count




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packages</th>
      <th>types</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3.jar</td>
      <td>64</td>
      <td>786</td>
      <td>5</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3.jar</td>
      <td>10</td>
      <td>156</td>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.9.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.9.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.9.3.jar</td>
      <td>1</td>
      <td>40</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.9.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1c - Top 30 artifacts with the highest number of incoming dependencies

The following table lists the top 30 artifacts that are used the most by other artifacts (highest count of incoming dependencies, highest in-degree).




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packages</th>
      <th>types</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3.jar</td>
      <td>64</td>
      <td>786</td>
      <td>5</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3.jar</td>
      <td>10</td>
      <td>156</td>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.9.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.9.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.9.3.jar</td>
      <td>1</td>
      <td>40</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-test-4.9.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>0</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1d - Top 30 artifacts with the highest number of outgoing dependencies

The following table lists the top 30 artifacts that are depending on the highest number of other artifacts (highest count of outgoing dependencies, highest out-degree).




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packages</th>
      <th>types</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-configuration-4.9.3.jar</td>
      <td>1</td>
      <td>40</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.9.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-test-4.9.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.9.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-modelling-4.9.3.jar</td>
      <td>10</td>
      <td>156</td>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.9.3.jar</td>
      <td>64</td>
      <td>786</td>
      <td>5</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1e - Top 30 artifacts with the lowest package count




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packages</th>
      <th>types</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-configuration-4.9.3.jar</td>
      <td>1</td>
      <td>40</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.9.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-test-4.9.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.9.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-modelling-4.9.3.jar</td>
      <td>10</td>
      <td>156</td>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.9.3.jar</td>
      <td>64</td>
      <td>786</td>
      <td>5</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1f - Top 30 artifacts with the lowest type count




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packages</th>
      <th>types</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-disruptor-4.9.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.9.3.jar</td>
      <td>1</td>
      <td>40</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-test-4.9.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.9.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-modelling-4.9.3.jar</td>
      <td>10</td>
      <td>156</td>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.9.3.jar</td>
      <td>64</td>
      <td>786</td>
      <td>5</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1g - Top 30 artifacts with the lowest number of incoming dependencies

The following table lists the top 30 artifacts that are used the least by other artifacts (lowest count of incoming dependencies, lowest in-degree).




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packages</th>
      <th>types</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-configuration-4.9.3.jar</td>
      <td>1</td>
      <td>40</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-test-4.9.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.9.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.9.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-modelling-4.9.3.jar</td>
      <td>10</td>
      <td>156</td>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.9.3.jar</td>
      <td>64</td>
      <td>786</td>
      <td>5</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1h - Top 30 artifacts with the lowest number of outgoing dependencies

The following table lists the top 30 artifacts that are depending on the lowest number of other artifacts (lowest count of outgoing dependencies, lowest out-degree).




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packages</th>
      <th>types</th>
      <th>incomingDependencies</th>
      <th>outgoingDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3.jar</td>
      <td>64</td>
      <td>786</td>
      <td>5</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3.jar</td>
      <td>10</td>
      <td>156</td>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.9.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.9.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.9.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-configuration-4.9.3.jar</td>
      <td>1</td>
      <td>40</td>
      <td>0</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>



## Cyclic Dependencies

Cyclic dependencies occur when one package uses a class of another package and vice versa. 
These dependencies can lead to problems when one of these packages needs to be changed.

## Table 2a - Cyclic Dependencies Overview

Show the top 40 cyclic dependencies sorted by the most promising to resolve first. This is done by calculating the number of forward dependencies (first cycle participant to second cycle participant) in relation to backward dependencies (second cycle participant back to first cycle participant). The higher this rate (approaching 1), the easier it should be to resolve the cycle by focussing on the few backward dependencies.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Cyclic_Dependencies`

**Columns:**
- *artifactName* identifies the artifact of the first participant of the cycle
- *packageName* identifies the package of the first participant of the cycle
- *dependentArtifactName* identifies the artifact of the second participant of the cycle
- *dependentPackageName* identifies the package of the second participant of the cycle
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
      <th>artifactName</th>
      <th>packageName</th>
      <th>dependentArtifactName</th>
      <th>dependentPackageName</th>
      <th>forwardToBackwardBalance</th>
      <th>numberForward</th>
      <th>numberBackward</th>
      <th>someForwardDependencies</th>
      <th>backwardDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
      <td>[AbstractEventProcessor-&gt;Span, AbstractEventBu...</td>
      <td>[NestingSpanFactory-&gt;EventMessage]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
      <td>[GenericStreamingQueryMessage-&gt;PublisherRespon...</td>
      <td>[ConvertingResponseMessage-&gt;QueryResponseMessage]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>0.875000</td>
      <td>15</td>
      <td>1</td>
      <td>[SimpleQueryUpdateEmitter$Builder-&gt;SpanFactory...</td>
      <td>[SpanUtils-&gt;QueryMessage]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging</td>
      <td>0.857143</td>
      <td>39</td>
      <td>3</td>
      <td>[GenericTrackedEventMessage-&gt;Message, Tracking...</td>
      <td>[Headers-&gt;EventMessage, Headers-&gt;DomainEventMe...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>0.840000</td>
      <td>23</td>
      <td>2</td>
      <td>[TrackingTokenParameterResolverFactory$Trackin...</td>
      <td>[SourceIdParameterResolverFactory$SourceIdPara...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.deadline</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>0.800000</td>
      <td>9</td>
      <td>1</td>
      <td>[DeadlineManagerSpanFactory-&gt;Span, DefaultDead...</td>
      <td>[SpanUtils-&gt;DeadlineMessage]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>0.777778</td>
      <td>8</td>
      <td>1</td>
      <td>[DefaultCommandBusSpanFactory$Builder-&gt;SpanFac...</td>
      <td>[SpanUtils-&gt;CommandMessage]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>0.777778</td>
      <td>16</td>
      <td>2</td>
      <td>[EventStreamUtils-&gt;DomainEventStream, Abstract...</td>
      <td>[DomainEventStream-&gt;EventStreamUtils, Abstract...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>0.733333</td>
      <td>13</td>
      <td>2</td>
      <td>[FailureLoggingCallback-&gt;CommandCallback, Fail...</td>
      <td>[SimpleCommandBus$Builder-&gt;NoOpCallback, Simpl...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
      <td>[AbstractSequencedDomainEventEntry-&gt;Serializer...</td>
      <td>[GapAwareTrackingTokenConverter-&gt;GapAwareTrack...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
      <td>[ExecutionResult-&gt;ResultMessage, DefaultUnitOf...</td>
      <td>[DefaultInterceptorChain-&gt;UnitOfWork, MessageH...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>0.538462</td>
      <td>10</td>
      <td>3</td>
      <td>[FullConcurrencyPolicy-&gt;EventMessage, Sequenti...</td>
      <td>[SimpleEventHandlerInvoker-&gt;SequencingPolicy, ...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.replay</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>0.454545</td>
      <td>8</td>
      <td>3</td>
      <td>[ReplayParameterResolverFactory-&gt;ReplayStatus,...</td>
      <td>[AnnotationEventHandlerAdapter-&gt;ResetContext, ...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization.upcasting.event</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>0.333333</td>
      <td>6</td>
      <td>3</td>
      <td>[UpcastedEventRepresentation-&gt;TrackingToken, I...</td>
      <td>[EventUtils-&gt;IntermediateEventRepresentation, ...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
      <td>[JdbcEventStorageEngine$Builder-&gt;AppendSnapsho...</td>
      <td>[AppendSnapshotStatementBuilder-&gt;EventSchema, ...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.tokenstore</td>
      <td>0.285714</td>
      <td>9</td>
      <td>5</td>
      <td>[TrackingEventProcessor$ClaimSegmentInstructio...</td>
      <td>[GenericTokenEntry-&gt;TrackingToken, TokenStore-...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.modelling.command</td>
      <td>0.250000</td>
      <td>20</td>
      <td>12</td>
      <td>[MethodCreationPolicyDefinition$MethodCreation...</td>
      <td>[ForwardingMode-&gt;EntityModel, AggregateAnnotat...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling.registration</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>0.250000</td>
      <td>5</td>
      <td>3</td>
      <td>[FailingDuplicateQueryHandlerResolver-&gt;QuerySu...</td>
      <td>[SimpleQueryBus$Builder-&gt;DuplicateQueryHandler...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>0.238095</td>
      <td>13</td>
      <td>8</td>
      <td>[Message-&gt;SerializedObject, Message-&gt;Serialize...</td>
      <td>[SerializedMessage-&gt;AbstractMessage, Serialize...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.interceptors</td>
      <td>0.200000</td>
      <td>3</td>
      <td>2</td>
      <td>[MessageHandlerInterceptorDefinition-&gt;MessageH...</td>
      <td>[ResultHandler-&gt;HasHandlerAttributes, MessageH...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>0.142857</td>
      <td>4</td>
      <td>3</td>
      <td>[AnnotatedSaga-&gt;SagaModel, AnnotatedSagaManage...</td>
      <td>[AnnotationSagaMetaModelFactory$InspectedSagaM...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>0.076923</td>
      <td>7</td>
      <td>6</td>
      <td>[DenyCommandNameFilter-&gt;CommandMessageFilter, ...</td>
      <td>[CommandMessageFilter-&gt;AndCommandMessageFilter...</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2b - Cyclic Dependencies Break Down

Lists packages with cyclic dependencies with every dependency in a separate row sorted by the most promising  dependency first.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Cyclic_Dependencies_Breakdown`

**Columns in addition to Table 2a:**
- *dependency* shows the cycle dependency in the text format "type1 -> type2" (forward) or "type2<-type1" (backward)




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packageName</th>
      <th>dependentArtifactName</th>
      <th>dependentPackageName</th>
      <th>dependency</th>
      <th>forwardToBackwardBalance</th>
      <th>numberForward</th>
      <th>numberBackward</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventProcessorSpanFactory-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventProcessorSpanFactory$Builder-&gt;Span...</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>TrackingEventProcessor$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus-&gt;SpanScope</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>EventMessage&lt;-NestingSpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventBusSpanFactory-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventProcessorSpanFactory-&gt;NoOpSpanFact...</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>SubscribingEventProcessor$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>EventBusSpanFactory-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventBusSpanFactory$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus$Builder-&gt;NoOpSpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventProcessorSpanFactory-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventBusSpanFactory-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor$Builder-&gt;NoOpSpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>SimpleEventBus$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>EventProcessorSpanFactory-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericSubscriptionQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;MultipleInstancesRes...</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;PublisherResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryBus-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;OptionalResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SubscriptionQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryGateway-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryGateway-&gt;ResponseTypes</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QuerySubscription-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>StreamingQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryResponseMessage&lt;-ConvertingResponseMessage</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericStreamingQueryMessage-&gt;PublisherRespons...</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericStreamingQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>DefaultQueryGateway-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>QueryMessage&lt;-SpanUtils</td>
      <td>0.875000</td>
      <td>15</td>
      <td>1</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>SimpleQueryUpdateEmitter$Builder-&gt;SpanFactory</td>
      <td>0.875000</td>
      <td>15</td>
      <td>1</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>SimpleQueryUpdateEmitter$Builder-&gt;NoOpSpanFactory</td>
      <td>0.875000</td>
      <td>15</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2c - Cyclic Dependencies Break Down - Backward Dependencies Only

Lists packages with cyclic dependencies with every dependency in a separate row sorted by the most promising  dependency first. This table only contains the backward dependencies from the second participant of the cycle back to the first one that are the most promising to resolve.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Cyclic_Dependencies_Breakdown_BackwardOnly`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packageName</th>
      <th>dependentArtifactName</th>
      <th>dependentPackageName</th>
      <th>dependency</th>
      <th>forwardToBackwardBalance</th>
      <th>numberForward</th>
      <th>numberBackward</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>EventMessage&lt;-NestingSpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryResponseMessage&lt;-ConvertingResponseMessage</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>QueryMessage&lt;-SpanUtils</td>
      <td>0.875000</td>
      <td>15</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging</td>
      <td>EventMessage&lt;-Headers</td>
      <td>0.857143</td>
      <td>39</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging</td>
      <td>DomainEventMessage&lt;-Headers</td>
      <td>0.857143</td>
      <td>39</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging</td>
      <td>TrackingToken&lt;-StreamableMessageSource</td>
      <td>0.857143</td>
      <td>39</td>
      <td>3</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>DomainEventMessage&lt;-SourceIdParameterResolverF...</td>
      <td>0.840000</td>
      <td>23</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>DomainEventMessage&lt;-AggregateTypeParameterReso...</td>
      <td>0.840000</td>
      <td>23</td>
      <td>2</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.deadline</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>DeadlineMessage&lt;-SpanUtils</td>
      <td>0.800000</td>
      <td>9</td>
      <td>1</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.tracing</td>
      <td>CommandMessage&lt;-SpanUtils</td>
      <td>0.777778</td>
      <td>8</td>
      <td>1</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>EventStreamUtils&lt;-DomainEventStream</td>
      <td>0.777778</td>
      <td>16</td>
      <td>2</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>EventStreamUtils&lt;-AbstractEventStorageEngine</td>
      <td>0.777778</td>
      <td>16</td>
      <td>2</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>LoggingCallback&lt;-SimpleCommandBus$Builder</td>
      <td>0.733333</td>
      <td>13</td>
      <td>2</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>NoOpCallback&lt;-SimpleCommandBus$Builder</td>
      <td>0.733333</td>
      <td>13</td>
      <td>2</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>GenericEventMessage&lt;-AbstractXStreamSerializer</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>GenericDomainEventMessage&lt;-AbstractXStreamSeri...</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization</td>
      <td>GapAwareTrackingToken&lt;-GapAwareTrackingTokenCo...</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging</td>
      <td>UnitOfWork&lt;-DefaultInterceptorChain</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging</td>
      <td>UnitOfWork&lt;-MessageHandlerInterceptor</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.messaging</td>
      <td>CurrentUnitOfWork&lt;-GenericMessage</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>SequentialPerAggregatePolicy&lt;-SimpleEventHandl...</td>
      <td>0.538462</td>
      <td>10</td>
      <td>3</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>SequencingPolicy&lt;-SimpleEventHandlerInvoker$Bu...</td>
      <td>0.538462</td>
      <td>10</td>
      <td>3</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>SequencingPolicy&lt;-SimpleEventHandlerInvoker</td>
      <td>0.538462</td>
      <td>10</td>
      <td>3</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.replay</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>ResetContext&lt;-ResetHandler</td>
      <td>0.454545</td>
      <td>8</td>
      <td>3</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.replay</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>GenericResetContext&lt;-AnnotationEventHandlerAda...</td>
      <td>0.454545</td>
      <td>8</td>
      <td>3</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling.replay</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>ResetContext&lt;-AnnotationEventHandlerAdapter</td>
      <td>0.454545</td>
      <td>8</td>
      <td>3</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization.upcasting.event</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>EventUpcaster&lt;-EventUtils</td>
      <td>0.333333</td>
      <td>6</td>
      <td>3</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization.upcasting.event</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>InitialEventRepresentation&lt;-EventUtils</td>
      <td>0.333333</td>
      <td>6</td>
      <td>3</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.serialization.upcasting.event</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>IntermediateEventRepresentation&lt;-EventUtils</td>
      <td>0.333333</td>
      <td>6</td>
      <td>3</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-CreateTokenAtStatementBuilder</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-ReadEventDataWithoutGapsStatement...</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-LastSequenceNumberForStatementBui...</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-ReadEventDataWithGapsStatementBui...</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-DeleteSnapshotsStatementBuilder</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-CreateHeadTokenStatementBuilder</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-ReadEventDataForAggregateStatemen...</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-FetchTrackedEventsStatementBuilder</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-JdbcEventStorageEngineStatements</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-AppendEventsStatementBuilder</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>EventSchema&lt;-CleanGapsStatementBuilder</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
    </tr>
  </tbody>
</table>
</div>



## Interface Segregation Candidates

Well known from [Design Principles and Design Patterns by Robert C. Martin](http://staff.cs.utu.fi/~jounsmed/doos_06/material/DesignPrinciplesAndPatterns.pdf), the *Interface Segregation Principle* suggests that software components should have narrow, focused interfaces rather than large, general-purpose ones. The goal is to minimize the dependencies between components and increase modularity, flexibility, and maintainability.

Smaller, focused and purpose-driven interfaces

- make it easier to modify individual components without affecting the rest of the system.
- make it clearer which client is affected by which change.
- don’t force their clients to depend on methods they don’t need.
- reduce the scope of changes since a change to one component doesn’t affect others.
- lead to a more loosely coupled architecture that is easier to understand and maintain.

Reference: [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html#interface-segregation)

### How to apply the results

If just one method of a type is used, especially in many places, then the result of this method can be used to call e.g. a method or constuct an object instead of using the whole object and then just calling that single method.

If there are a couple of methods that are used for a distinct purpose, those could be factored out into a separate interface. The original type can extended/implement the new interface so that there are no breaking changes. Then all the callers, that use only this group of methods, can be changed to the new interface.


### Table 4 - Top 40 most used combinations of methods

The following table shows the top 40 most used combinations of methods of larger types that might benefit from applying the *Interface Segregation Principle*. The whole table can be found in the CSV report `Candidates_for_Interface_Segregation`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>fullDependentTypeName</th>
      <th>declaredMethods</th>
      <th>calledMethodNames</th>
      <th>calledMethods</th>
      <th>callerTypes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.commandhandling.CommandMessage</td>
      <td>9</td>
      <td>[getCommandName]</td>
      <td>1</td>
      <td>18</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>10</td>
      <td>[getSequenceNumber]</td>
      <td>1</td>
      <td>9</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>9</td>
      <td>[getTimestamp, getIdentifier]</td>
      <td>2</td>
      <td>9</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventhandling.TrackedEventMe...</td>
      <td>10</td>
      <td>[trackingToken]</td>
      <td>1</td>
      <td>8</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>9</td>
      <td>[getIdentifier]</td>
      <td>1</td>
      <td>7</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>10</td>
      <td>[getAggregateIdentifier, getSequenceNumber, ge...</td>
      <td>3</td>
      <td>6</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.messaging.ResultMessage</td>
      <td>9</td>
      <td>[isExceptional, exceptionResult]</td>
      <td>2</td>
      <td>6</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.commandhandling.GenericComma...</td>
      <td>14</td>
      <td>[asCommandResultMessage]</td>
      <td>1</td>
      <td>5</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.deadline.GenericDeadlineMessage</td>
      <td>11</td>
      <td>[asDeadlineMessage]</td>
      <td>1</td>
      <td>5</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.eventhandling.ReplayToken</td>
      <td>13</td>
      <td>[createReplayToken]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.eventhandling.TrackedEventMe...</td>
      <td>12</td>
      <td>[trackingToken]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.deadline.DeadlineMessage</td>
      <td>10</td>
      <td>[getDeadlineName]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>10</td>
      <td>[getAggregateIdentifier]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>10</td>
      <td>[getType]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.eventhandling.GenericEventMe...</td>
      <td>10</td>
      <td>[asEventMessage]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.deadline.DefaultDeadlineMana...</td>
      <td>8</td>
      <td>[builder]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.common.transaction.NoTransac...</td>
      <td>4</td>
      <td>[instance]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.commandhandling.GenericComma...</td>
      <td>15</td>
      <td>[asCommandResultMessage]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.modelling.command.inspection...</td>
      <td>13</td>
      <td>[type]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>11</td>
      <td>[getAggregateIdentifier, getSequenceNumber, ge...</td>
      <td>3</td>
      <td>3</td>
    </tr>
    <tr>
      <th>20</th>
      <td>org.axonframework.eventhandling.GenericEventMe...</td>
      <td>11</td>
      <td>[asEventMessage]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>21</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>10</td>
      <td>[getAggregateIdentifier, getSequenceNumber]</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>22</th>
      <td>org.axonframework.eventhandling.GapAwareTracki...</td>
      <td>10</td>
      <td>[advanceTo, newInstance, getIndex, withGapsTru...</td>
      <td>5</td>
      <td>3</td>
    </tr>
    <tr>
      <th>23</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>9</td>
      <td>[getTimestamp]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>24</th>
      <td>org.axonframework.messaging.MessageDecorator</td>
      <td>9</td>
      <td>[describeTo]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>25</th>
      <td>org.axonframework.eventhandling.TrackedEventData</td>
      <td>5</td>
      <td>[trackingToken]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>26</th>
      <td>org.axonframework.eventhandling.tokenstore.Con...</td>
      <td>5</td>
      <td>[get]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>27</th>
      <td>org.axonframework.eventhandling.TrackerStatus</td>
      <td>17</td>
      <td>[getSegment, getTrackingToken, split]</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>28</th>
      <td>org.axonframework.modelling.command.inspection...</td>
      <td>17</td>
      <td>[initialize, getAggregateRoot, initSequence]</td>
      <td>4</td>
      <td>2</td>
    </tr>
    <tr>
      <th>29</th>
      <td>org.axonframework.queryhandling.SimpleQueryUpd...</td>
      <td>17</td>
      <td>[builder]</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>30</th>
      <td>org.axonframework.commandhandling.CommandMessa...</td>
      <td>14</td>
      <td>[commandName, isFactoryHandler]</td>
      <td>2</td>
      <td>2</td>
    </tr>
    <tr>
      <th>31</th>
      <td>org.axonframework.commandhandling.GenericComma...</td>
      <td>14</td>
      <td>[asCommandResultMessage]</td>
      <td>2</td>
      <td>2</td>
    </tr>
    <tr>
      <th>32</th>
      <td>org.axonframework.deadline.DeadlineMessage</td>
      <td>14</td>
      <td>[getDeadlineName]</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>33</th>
      <td>org.axonframework.messaging.GenericResultMessage</td>
      <td>14</td>
      <td>[asResultMessage]</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>34</th>
      <td>org.axonframework.messaging.annotation.Wrapped...</td>
      <td>14</td>
      <td>[handle]</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>35</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>13</td>
      <td>[getAggregateIdentifier, getSequenceNumber]</td>
      <td>2</td>
      <td>2</td>
    </tr>
    <tr>
      <th>36</th>
      <td>org.axonframework.eventhandling.ReplayToken</td>
      <td>13</td>
      <td>[isReplay]</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>37</th>
      <td>org.axonframework.modelling.command.inspection...</td>
      <td>13</td>
      <td>[types]</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>38</th>
      <td>org.axonframework.queryhandling.SubscriptionQu...</td>
      <td>12</td>
      <td>[getUpdateResponseType]</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>39</th>
      <td>org.axonframework.commandhandling.GenericComma...</td>
      <td>11</td>
      <td>[asCommandMessage]</td>
      <td>1</td>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div>



## Package Usage

### Table 5 - Types that are used by multiple packages

This table shows the top 40 packages that are used by the highest number of different packages. The whole table can be found in the CSV report `List_types_that_are_used_by_many_different_packages`.





<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>fullQualifiedDependentTypeName</th>
      <th>dependentTypeName</th>
      <th>dependentTypeLabels</th>
      <th>numberOfUsingPackages</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.common.BuilderUtils</td>
      <td>BuilderUtils</td>
      <td>[Type, File, Java, ByteCode, Class, TopCentral...</td>
      <td>44</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.common.AxonConfigurationExce...</td>
      <td>AxonConfigurationException</td>
      <td>[Type, File, Java, ByteCode, Class, TopCentral...</td>
      <td>37</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.messaging.Message</td>
      <td>Message</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>34</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.messaging.MetaData</td>
      <td>MetaData</td>
      <td>[Type, File, Java, ByteCode, Class, TopCentral...</td>
      <td>33</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>EventMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>32</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.messaging.unitofwork.UnitOfWork</td>
      <td>UnitOfWork</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>31</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.serialization.Serializer</td>
      <td>Serializer</td>
      <td>[Type, File, Java, ByteCode, Interface, TopCen...</td>
      <td>29</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.common.Assert</td>
      <td>Assert</td>
      <td>[Type, File, Java, ByteCode, Class, TopCentral...</td>
      <td>27</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.common.transaction.Transacti...</td>
      <td>TransactionManager</td>
      <td>[Type, File, Java, ByteCode, Interface, TopCen...</td>
      <td>27</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.serialization.SerializedObject</td>
      <td>SerializedObject</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>25</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.serialization.SerializedType</td>
      <td>SerializedType</td>
      <td>[Type, File, Java, ByteCode, Interface, TopCen...</td>
      <td>24</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.messaging.unitofwork.Current...</td>
      <td>CurrentUnitOfWork</td>
      <td>[Type, File, Java, ByteCode, Class, TopCentral...</td>
      <td>21</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.common.AxonNonTransientExcep...</td>
      <td>AxonNonTransientException</td>
      <td>[Type, File, Java, ByteCode, Class, TopCentral...</td>
      <td>18</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>DomainEventMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>18</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.eventhandling.GenericEventMe...</td>
      <td>GenericEventMessage</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>18</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.messaging.annotation.Paramet...</td>
      <td>ParameterResolverFactory</td>
      <td>[Type, File, Java, ByteCode, Interface, TopCen...</td>
      <td>18</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.eventhandling.TrackingToken</td>
      <td>TrackingToken</td>
      <td>[Type, File, Java, ByteCode, Interface, TopCen...</td>
      <td>18</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.common.Registration</td>
      <td>Registration</td>
      <td>[Type, File, Java, ByteCode, Interface, TypeWe...</td>
      <td>17</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.serialization.SimpleSerializ...</td>
      <td>SimpleSerializedObject</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>17</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.messaging.MessageHandlerInte...</td>
      <td>MessageHandlerInterceptor</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>16</td>
    </tr>
    <tr>
      <th>20</th>
      <td>org.axonframework.common.ObjectUtils</td>
      <td>ObjectUtils</td>
      <td>[Type, File, Java, ByteCode, Class, TypeWeakly...</td>
      <td>16</td>
    </tr>
    <tr>
      <th>21</th>
      <td>org.axonframework.tracing.SpanFactory</td>
      <td>SpanFactory</td>
      <td>[Type, File, Java, ByteCode, Interface, TopCen...</td>
      <td>16</td>
    </tr>
    <tr>
      <th>22</th>
      <td>org.axonframework.messaging.MessageDispatchInt...</td>
      <td>MessageDispatchInterceptor</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>15</td>
    </tr>
    <tr>
      <th>23</th>
      <td>org.axonframework.commandhandling.CommandMessage</td>
      <td>CommandMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>14</td>
    </tr>
    <tr>
      <th>24</th>
      <td>org.axonframework.messaging.unitofwork.Default...</td>
      <td>DefaultUnitOfWork</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>14</td>
    </tr>
    <tr>
      <th>25</th>
      <td>org.axonframework.messaging.annotation.Handler...</td>
      <td>HandlerDefinition</td>
      <td>[Type, File, Java, ByteCode, Interface, TopCen...</td>
      <td>14</td>
    </tr>
    <tr>
      <th>26</th>
      <td>org.axonframework.common.ReflectionUtils</td>
      <td>ReflectionUtils</td>
      <td>[Type, File, Java, ByteCode, Class, TypeWeakly...</td>
      <td>14</td>
    </tr>
    <tr>
      <th>27</th>
      <td>org.axonframework.eventhandling.EventBus</td>
      <td>EventBus</td>
      <td>[Type, File, Java, ByteCode, Interface, TopCen...</td>
      <td>13</td>
    </tr>
    <tr>
      <th>28</th>
      <td>org.axonframework.lifecycle.Lifecycle</td>
      <td>Lifecycle</td>
      <td>[Type, File, Java, ByteCode, Interface, TypeWe...</td>
      <td>13</td>
    </tr>
    <tr>
      <th>29</th>
      <td>org.axonframework.lifecycle.Lifecycle$Lifecycl...</td>
      <td>Lifecycle$LifecycleRegistry</td>
      <td>[Type, File, Java, ByteCode, Interface, TypeWe...</td>
      <td>13</td>
    </tr>
    <tr>
      <th>30</th>
      <td>org.axonframework.common.transaction.NoTransac...</td>
      <td>NoTransactionManager</td>
      <td>[Type, File, Java, ByteCode, Enum, TypeWeaklyC...</td>
      <td>13</td>
    </tr>
    <tr>
      <th>31</th>
      <td>org.axonframework.messaging.ResultMessage</td>
      <td>ResultMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>13</td>
    </tr>
    <tr>
      <th>32</th>
      <td>org.axonframework.common.DateTimeUtils</td>
      <td>DateTimeUtils</td>
      <td>[Type, File, Java, ByteCode, Class, TypeWeakly...</td>
      <td>12</td>
    </tr>
    <tr>
      <th>33</th>
      <td>org.axonframework.messaging.DefaultInterceptor...</td>
      <td>DefaultInterceptorChain</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>12</td>
    </tr>
    <tr>
      <th>34</th>
      <td>org.axonframework.messaging.InterceptorChain</td>
      <td>InterceptorChain</td>
      <td>[Type, File, Java, ByteCode, Interface, TypeWe...</td>
      <td>12</td>
    </tr>
    <tr>
      <th>35</th>
      <td>org.axonframework.tracing.NoOpSpanFactory</td>
      <td>NoOpSpanFactory</td>
      <td>[Type, File, Java, ByteCode, Class, TypeWeakly...</td>
      <td>12</td>
    </tr>
    <tr>
      <th>36</th>
      <td>org.axonframework.messaging.ScopeDescriptor</td>
      <td>ScopeDescriptor</td>
      <td>[Type, File, Java, ByteCode, Interface, TypeWe...</td>
      <td>12</td>
    </tr>
    <tr>
      <th>37</th>
      <td>org.axonframework.common.AxonTransientException</td>
      <td>AxonTransientException</td>
      <td>[Type, File, Java, ByteCode, Class, TypeWeakly...</td>
      <td>11</td>
    </tr>
    <tr>
      <th>38</th>
      <td>org.axonframework.messaging.annotation.Classpa...</td>
      <td>ClasspathHandlerDefinition</td>
      <td>[Type, File, Java, ByteCode, Class, TypeWeakly...</td>
      <td>11</td>
    </tr>
    <tr>
      <th>39</th>
      <td>org.axonframework.messaging.annotation.Classpa...</td>
      <td>ClasspathParameterResolverFactory</td>
      <td>[Type, File, Java, ByteCode, Class, TypeWeakly...</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



### Table 6 - Packages that are used by multiple artifacts

This table shows the top 30 artifacts that only use a few (compared to all existing) packages of another artifact.
The whole table can be found in the CSV report `ArtifactPackageUsage`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>dependentArtifactName</th>
      <th>dependentPackages</th>
      <th>dependentArtifactPackages</th>
      <th>packageUsagePercentage</th>
      <th>dependentFullQualifiedPackageNames</th>
      <th>dependentPackageNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-modelling-4.9.3</td>
      <td>axon-modelling-4.9.3</td>
      <td>6</td>
      <td>10</td>
      <td>0.600000</td>
      <td>[org.axonframework.modelling.saga, org.axonfra...</td>
      <td>[saga, metamodel, repository, jpa, inspection,...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-test-4.9.3</td>
      <td>axon-test-4.9.3</td>
      <td>5</td>
      <td>8</td>
      <td>0.625000</td>
      <td>[org.axonframework.test.matchers, org.axonfram...</td>
      <td>[matchers, test, deadline, utils, eventscheduler]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>41</td>
      <td>64</td>
      <td>0.640625</td>
      <td>[org.axonframework.deadline, org.axonframework...</td>
      <td>[deadline, annotation, messaging, distributed,...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-eventsourcing-4.9.3</td>
      <td>7</td>
      <td>9</td>
      <td>0.777778</td>
      <td>[org.axonframework.eventsourcing.eventstore, o...</td>
      <td>[eventstore, jpa, snapshotting, eventsourcing,...</td>
    </tr>
  </tbody>
</table>
</div>



### Table 7 - Types that are used by multiple artifacts

This table shows the top 30 types that only use a few (compared to all existing) types of another artifact. The whole table can be found in the CSV report `ClassesPerPackageUsageAcrossArtifacts`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>dependentArtifactName</th>
      <th>packageName</th>
      <th>dependentPackage.fqn</th>
      <th>dependentTypes</th>
      <th>dependentPackageTypes</th>
      <th>typeUsagePercentage</th>
      <th>dependentTypeNames</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-test-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>100</td>
      <td>0.010000</td>
      <td>[org.axonframework.eventhandling.EventMessage]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>100</td>
      <td>0.010000</td>
      <td>[org.axonframework.eventhandling.EventMessage]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.snapshotting</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>100</td>
      <td>0.010000</td>
      <td>[org.axonframework.eventhandling.DomainEventData]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.modelling.command</td>
      <td>1</td>
      <td>54</td>
      <td>0.018519</td>
      <td>[org.axonframework.modelling.command.Conflicti...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>org.axonframework.modelling.command</td>
      <td>1</td>
      <td>54</td>
      <td>0.018519</td>
      <td>[org.axonframework.modelling.command.Concurren...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-test-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.test.eventscheduler</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>100</td>
      <td>0.020000</td>
      <td>[org.axonframework.eventhandling.GenericEventM...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>100</td>
      <td>0.020000</td>
      <td>[org.axonframework.eventhandling.EventMessage,...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-modelling-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>100</td>
      <td>0.020000</td>
      <td>[org.axonframework.eventhandling.DomainEventSe...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-modelling-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.modelling.command</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>100</td>
      <td>0.020000</td>
      <td>[org.axonframework.eventhandling.DomainEventSe...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.Message]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.StreamableMessage...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-test-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.test</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.Message]</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-test-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.Message]</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>org.axonframework.eventhandling</td>
      <td>3</td>
      <td>100</td>
      <td>0.030000</td>
      <td>[org.axonframework.eventhandling.EventMessage,...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-test-4.9.3</td>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.test.utils</td>
      <td>org.axonframework.modelling.saga</td>
      <td>1</td>
      <td>33</td>
      <td>0.030303</td>
      <td>[org.axonframework.modelling.saga.SimpleResour...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-test-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.axonframework.commandhandling</td>
      <td>1</td>
      <td>32</td>
      <td>0.031250</td>
      <td>[org.axonframework.commandhandling.CommandMess...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.commandhandling</td>
      <td>1</td>
      <td>32</td>
      <td>0.031250</td>
      <td>[org.axonframework.commandhandling.CommandMess...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-test-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.test.eventscheduler</td>
      <td>org.axonframework.common</td>
      <td>1</td>
      <td>28</td>
      <td>0.035714</td>
      <td>[org.axonframework.common.DateTimeUtils]</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.common</td>
      <td>1</td>
      <td>28</td>
      <td>0.035714</td>
      <td>[org.axonframework.common.Assert]</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-test-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.test.utils</td>
      <td>org.axonframework.common</td>
      <td>1</td>
      <td>28</td>
      <td>0.035714</td>
      <td>[org.axonframework.common.Registration]</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>org.axonframework.common</td>
      <td>1</td>
      <td>28</td>
      <td>0.035714</td>
      <td>[org.axonframework.common.DateTimeUtils]</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-test-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.test.server</td>
      <td>org.axonframework.common</td>
      <td>1</td>
      <td>28</td>
      <td>0.035714</td>
      <td>[org.axonframework.common.Assert]</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-modelling-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>org.axonframework.common</td>
      <td>1</td>
      <td>28</td>
      <td>0.035714</td>
      <td>[org.axonframework.common.BuilderUtils]</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.snapshotting</td>
      <td>org.axonframework.common</td>
      <td>1</td>
      <td>28</td>
      <td>0.035714</td>
      <td>[org.axonframework.common.BuilderUtils]</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-modelling-4.9.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>org.axonframework.modelling.command</td>
      <td>2</td>
      <td>54</td>
      <td>0.037037</td>
      <td>[org.axonframework.modelling.command.Aggregate...</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-eventsourcing-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>2</td>
      <td>54</td>
      <td>0.037037</td>
      <td>[org.axonframework.messaging.annotation.Parame...</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-modelling-4.9.3</td>
      <td>axon-messaging-4.9.3</td>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>2</td>
      <td>54</td>
      <td>0.037037</td>
      <td>[org.axonframework.messaging.annotation.Parame...</td>
    </tr>
  </tbody>
</table>
</div>



### Table 8 - Duplicate package names across artifacts

This table shows the top 30 duplicate package names across artifacts. They are ordered by the number of duplicates descending.

This might lead to confusion, makes importing more error prone and might even lead to duplicate classes where only one of them will be loaded by the class loader. If a package is named the same way in two or more artifacts this even allows another artifact to access package protected classes, methods or members which might not be intended. 

The whole table can be found in the CSV report `DuplicatePackageNamesAcrossArtifacts`.




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>packageName</th>
      <th>duplicates</th>
      <th>artifactNames</th>
    </tr>
  </thead>
  <tbody>
  </tbody>
</table>
</div>



### Table 9 - Annotated elements

This table shows 30 most used Java Annotations including some examples where they are used.





<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>annotationName</th>
      <th>languageElement</th>
      <th>numberOfAnnotatedElements</th>
      <th>examples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>javax.annotation.Nonnull</td>
      <td>Parameter</td>
      <td>1501</td>
      <td>[org.axonframework.test.aggregate.ResultValida...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>java.lang.Deprecated</td>
      <td>Method</td>
      <td>96</td>
      <td>[org.axonframework.test.aggregate.ResultValida...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>javax.annotation.Nullable</td>
      <td>Parameter</td>
      <td>61</td>
      <td>[org.axonframework.eventsourcing.eventstore.Ev...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>java.lang.FunctionalInterface</td>
      <td>Interface</td>
      <td>54</td>
      <td>[org.axonframework.test.matchers.FieldFilter, ...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>java.lang.annotation.Retention</td>
      <td>Annotation</td>
      <td>40</td>
      <td>[org.axonframework.eventsourcing.EventSourcing...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>java.lang.annotation.Target</td>
      <td>Annotation</td>
      <td>40</td>
      <td>[org.axonframework.eventsourcing.EventSourcing...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>javax.persistence.Basic</td>
      <td>Field</td>
      <td>39</td>
      <td>[org.axonframework.modelling.saga.repository.j...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>javax.annotation.Nonnull</td>
      <td>Method</td>
      <td>37</td>
      <td>[org.axonframework.test.aggregate.AggregateTes...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>jakarta.persistence.Basic</td>
      <td>Field</td>
      <td>33</td>
      <td>[org.axonframework.modelling.saga.repository.j...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>com.fasterxml.jackson.annotation.JsonProperty</td>
      <td>Parameter</td>
      <td>32</td>
      <td>[org.axonframework.modelling.command.Aggregate...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>java.lang.Deprecated</td>
      <td>Class</td>
      <td>25</td>
      <td>[org.axonframework.test.aggregate.StubAggregat...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>java.lang.annotation.Documented</td>
      <td>Annotation</td>
      <td>21</td>
      <td>[org.axonframework.eventsourcing.EventSourcing...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>java.beans.ConstructorProperties</td>
      <td>Constructor</td>
      <td>21</td>
      <td>[org.axonframework.modelling.command.Aggregate...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>java.lang.Deprecated</td>
      <td>Constructor</td>
      <td>17</td>
      <td>[org.axonframework.eventsourcing.MultiStreamab...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>com.fasterxml.jackson.annotation.JsonCreator</td>
      <td>Constructor</td>
      <td>16</td>
      <td>[org.axonframework.modelling.command.Aggregate...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>javax.persistence.Column</td>
      <td>Field</td>
      <td>12</td>
      <td>[org.axonframework.modelling.saga.repository.j...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>jakarta.persistence.Column</td>
      <td>Field</td>
      <td>11</td>
      <td>[org.axonframework.modelling.saga.repository.j...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.common.Priority</td>
      <td>Class</td>
      <td>11</td>
      <td>[org.axonframework.test.FixtureResourceParamet...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>javax.persistence.Id</td>
      <td>Field</td>
      <td>10</td>
      <td>[org.axonframework.eventsourcing.eventstore.Ab...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>javax.persistence.Lob</td>
      <td>Field</td>
      <td>10</td>
      <td>[org.axonframework.modelling.saga.repository.j...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>jakarta.persistence.Id</td>
      <td>Field</td>
      <td>9</td>
      <td>[org.axonframework.eventsourcing.eventstore.Ab...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>java.lang.SafeVarargs</td>
      <td>Constructor</td>
      <td>9</td>
      <td>[org.axonframework.test.matchers.ListMatcher.&lt;...</td>
    </tr>
    <tr>
      <th>22</th>
      <td>com.fasterxml.jackson.annotation.JsonGetter</td>
      <td>Method</td>
      <td>9</td>
      <td>[org.axonframework.commandhandling.distributed...</td>
    </tr>
    <tr>
      <th>23</th>
      <td>jakarta.persistence.Lob</td>
      <td>Field</td>
      <td>8</td>
      <td>[org.axonframework.modelling.saga.repository.j...</td>
    </tr>
    <tr>
      <th>24</th>
      <td>org.axonframework.messaging.annotation.HasHand...</td>
      <td>Annotation</td>
      <td>8</td>
      <td>[org.axonframework.modelling.command.CreationP...</td>
    </tr>
    <tr>
      <th>25</th>
      <td>javax.persistence.Entity</td>
      <td>Class</td>
      <td>6</td>
      <td>[org.axonframework.eventsourcing.eventstore.jp...</td>
    </tr>
    <tr>
      <th>26</th>
      <td>jakarta.persistence.Entity</td>
      <td>Class</td>
      <td>6</td>
      <td>[org.axonframework.eventsourcing.eventstore.jp...</td>
    </tr>
    <tr>
      <th>27</th>
      <td>javax.persistence.MappedSuperclass</td>
      <td>Class</td>
      <td>6</td>
      <td>[org.axonframework.eventsourcing.eventstore.Ab...</td>
    </tr>
    <tr>
      <th>28</th>
      <td>java.lang.SafeVarargs</td>
      <td>Method</td>
      <td>6</td>
      <td>[org.axonframework.test.aggregate.AggregateTes...</td>
    </tr>
    <tr>
      <th>29</th>
      <td>org.axonframework.messaging.annotation.Message...</td>
      <td>Annotation</td>
      <td>6</td>
      <td>[org.axonframework.commandhandling.CommandHand...</td>
    </tr>
  </tbody>
</table>
</div>


