# Internal Dependencies
<br>  

### References
- [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html)
- [Calculate metrics](https://101.jqassistant.org/calculate-metrics/index.html)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)





## Artifacts

List the artifacts this notebook is based on. Different sorting variations help finding artifacts by their features and support larger code bases where the list of all artifacts gets too long.

Only the top 30 entries are shown. The whole table can be found in the following CSV report:  
`List_all_Java_artifacts`

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
      <td>axon-messaging-4.10.3.jar</td>
      <td>64</td>
      <td>787</td>
      <td>8</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-server-connector-4.10.3.jar</td>
      <td>11</td>
      <td>136</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-modelling-4.10.3.jar</td>
      <td>10</td>
      <td>158</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.10.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-spring-boot-autoconfigure-4.10.3.jar</td>
      <td>9</td>
      <td>75</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-test-4.10.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-configuration-4.10.3.jar</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-disruptor-4.10.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-tracing-opentelemetry-4.10.3.jar</td>
      <td>1</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
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
      <td>axon-messaging-4.10.3.jar</td>
      <td>64</td>
      <td>787</td>
      <td>8</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.10.3.jar</td>
      <td>10</td>
      <td>158</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-server-connector-4.10.3.jar</td>
      <td>11</td>
      <td>136</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.10.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-spring-boot-autoconfigure-4.10.3.jar</td>
      <td>9</td>
      <td>75</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-configuration-4.10.3.jar</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-disruptor-4.10.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-tracing-opentelemetry-4.10.3.jar</td>
      <td>1</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
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
      <td>axon-messaging-4.10.3.jar</td>
      <td>64</td>
      <td>787</td>
      <td>8</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.10.3.jar</td>
      <td>10</td>
      <td>158</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.10.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-configuration-4.10.3.jar</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.10.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-server-connector-4.10.3.jar</td>
      <td>11</td>
      <td>136</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-test-4.10.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-tracing-opentelemetry-4.10.3.jar</td>
      <td>1</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-spring-boot-autoconfigure-4.10.3.jar</td>
      <td>9</td>
      <td>75</td>
      <td>0</td>
      <td>7</td>
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
      <td>axon-spring-boot-autoconfigure-4.10.3.jar</td>
      <td>9</td>
      <td>75</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.10.3.jar</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-server-connector-4.10.3.jar</td>
      <td>11</td>
      <td>136</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.10.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-eventsourcing-4.10.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-modelling-4.10.3.jar</td>
      <td>10</td>
      <td>158</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-tracing-opentelemetry-4.10.3.jar</td>
      <td>1</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.10.3.jar</td>
      <td>64</td>
      <td>787</td>
      <td>8</td>
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
      <td>axon-configuration-4.10.3.jar</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.10.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-tracing-opentelemetry-4.10.3.jar</td>
      <td>1</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.10.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-eventsourcing-4.10.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-spring-boot-autoconfigure-4.10.3.jar</td>
      <td>9</td>
      <td>75</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-modelling-4.10.3.jar</td>
      <td>10</td>
      <td>158</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-server-connector-4.10.3.jar</td>
      <td>11</td>
      <td>136</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.10.3.jar</td>
      <td>64</td>
      <td>787</td>
      <td>8</td>
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
      <td>axon-tracing-opentelemetry-4.10.3.jar</td>
      <td>1</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.10.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-configuration-4.10.3.jar</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-spring-boot-autoconfigure-4.10.3.jar</td>
      <td>9</td>
      <td>75</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-eventsourcing-4.10.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-server-connector-4.10.3.jar</td>
      <td>11</td>
      <td>136</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-modelling-4.10.3.jar</td>
      <td>10</td>
      <td>158</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.10.3.jar</td>
      <td>64</td>
      <td>787</td>
      <td>8</td>
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
      <td>axon-spring-boot-autoconfigure-4.10.3.jar</td>
      <td>9</td>
      <td>75</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.10.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-server-connector-4.10.3.jar</td>
      <td>11</td>
      <td>136</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.10.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-tracing-opentelemetry-4.10.3.jar</td>
      <td>1</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-configuration-4.10.3.jar</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>4</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-eventsourcing-4.10.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-modelling-4.10.3.jar</td>
      <td>10</td>
      <td>158</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.10.3.jar</td>
      <td>64</td>
      <td>787</td>
      <td>8</td>
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
      <td>axon-messaging-4.10.3.jar</td>
      <td>64</td>
      <td>787</td>
      <td>8</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.10.3.jar</td>
      <td>10</td>
      <td>158</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-tracing-opentelemetry-4.10.3.jar</td>
      <td>1</td>
      <td>5</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.10.3.jar</td>
      <td>9</td>
      <td>133</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.10.3.jar</td>
      <td>1</td>
      <td>22</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-test-4.10.3.jar</td>
      <td>8</td>
      <td>87</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-configuration-4.10.3.jar</td>
      <td>1</td>
      <td>41</td>
      <td>2</td>
      <td>4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-server-connector-4.10.3.jar</td>
      <td>11</td>
      <td>136</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-spring-boot-autoconfigure-4.10.3.jar</td>
      <td>9</td>
      <td>75</td>
      <td>0</td>
      <td>7</td>
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
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
      <td>[EventProcessorSpanFactory-&gt;Span, AbstractEventBus$Builder-&gt;SpanFactory, AbstractEventBus$Builder-&gt;NoOpSpanFactory, AbstractEventBus-&gt;Span, AbstractEventBus-&gt;SpanScope, DefaultEventProcessorSpanFactory-&gt;NoOpSpanFactory$NoOpSpan, DefaultEventProcessorSpanFactory-&gt;Span, DefaultEventProcessorSpanFa...</td>
      <td>[NestingSpanFactory-&gt;EventMessage]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
      <td>[StreamingQueryMessage-&gt;ResponseType, GenericStreamingQueryMessage-&gt;PublisherResponseType, GenericStreamingQueryMessage-&gt;ResponseType, QueryGateway-&gt;ResponseTypes, QueryGateway-&gt;ResponseType, SimpleQueryUpdateEmitter-&gt;OptionalResponseType, SimpleQueryUpdateEmitter-&gt;PublisherResponseType, SimpleQ...</td>
      <td>[ConvertingResponseMessage-&gt;QueryResponseMessage]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>0.875000</td>
      <td>15</td>
      <td>1</td>
      <td>[DefaultQueryBusSpanFactory$Builder-&gt;SpanFactory, SimpleQueryUpdateEmitter-&gt;Span, DefaultQueryBusSpanFactory-&gt;SpanFactory, DefaultQueryBusSpanFactory-&gt;Span, DefaultQueryUpdateEmitterSpanFactory-&gt;Span, DefaultQueryUpdateEmitterSpanFactory-&gt;SpanFactory, SimpleQueryUpdateEmitter$Builder-&gt;SpanFactor...</td>
      <td>[SpanUtils-&gt;QueryMessage]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging</td>
      <td>0.857143</td>
      <td>39</td>
      <td>3</td>
      <td>[EventBus-&gt;SubscribableMessageSource, EventBus-&gt;MessageDispatchInterceptorSupport, AnnotationEventHandlerAdapter-&gt;Message, ReplayToken-&gt;Message, TrackingTokenParameterResolverFactory$TrackingTokenParameterResolver-&gt;Message, GenericDomainEventMessage-&gt;GenericMessage, GenericDomainEventMessage-&gt;Me...</td>
      <td>[StreamableMessageSource-&gt;TrackingToken, Headers-&gt;DomainEventMessage, Headers-&gt;EventMessage]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>0.840000</td>
      <td>23</td>
      <td>2</td>
      <td>[AnnotationEventHandlerAdapter-&gt;ParameterResolverFactory, AnnotationEventHandlerAdapter-&gt;HandlerDefinition, AnnotationEventHandlerAdapter-&gt;ClasspathParameterResolverFactory, AnnotationEventHandlerAdapter-&gt;AnnotatedHandlerInspector, AnnotationEventHandlerAdapter-&gt;MessageHandlingMember, Annotation...</td>
      <td>[SourceIdParameterResolverFactory$SourceIdParameterResolver-&gt;DomainEventMessage, AggregateTypeParameterResolverFactory$AggregateTypeParameterResolver-&gt;DomainEventMessage]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.deadline</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>0.800000</td>
      <td>9</td>
      <td>1</td>
      <td>[SimpleDeadlineManager-&gt;Span, DefaultDeadlineManagerSpanFactory-&gt;SpanFactory, DefaultDeadlineManagerSpanFactory-&gt;Span, SimpleDeadlineManager$DeadlineTask-&gt;Span, SimpleDeadlineManager$DeadlineTask-&gt;SpanScope, DefaultDeadlineManagerSpanFactory$Builder-&gt;SpanFactory, DeadlineManagerSpanFactory-&gt;Span...</td>
      <td>[SpanUtils-&gt;DeadlineMessage]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>0.777778</td>
      <td>8</td>
      <td>1</td>
      <td>[DefaultCommandBusSpanFactory$Builder-&gt;SpanFactory, SimpleCommandBus-&gt;Span, AsynchronousCommandBus$Builder-&gt;SpanFactory, DefaultCommandBusSpanFactory-&gt;SpanFactory, DefaultCommandBusSpanFactory-&gt;Span, SimpleCommandBus$Builder-&gt;NoOpSpanFactory, SimpleCommandBus$Builder-&gt;SpanFactory, CommandBusSpan...</td>
      <td>[SpanUtils-&gt;CommandMessage]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>0.777778</td>
      <td>16</td>
      <td>2</td>
      <td>[AggregateSnapshotter$Builder-&gt;EventStore, AggregateCacheEntry-&gt;EventStore, AbstractSnapshotter$Builder-&gt;EventStore, AggregateSnapshotter-&gt;DomainEventStream, AbstractSnapshotter$CreateSnapshotTask-&gt;EventStore, AbstractSnapshotter$CreateSnapshotTask-&gt;DomainEventStream, EventSourcingRepository-&gt;Do...</td>
      <td>[AbstractEventStorageEngine-&gt;EventStreamUtils, DomainEventStream-&gt;EventStreamUtils]</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>0.733333</td>
      <td>13</td>
      <td>2</td>
      <td>[FailureLoggingCallback-&gt;CommandResultMessage, FailureLoggingCallback-&gt;CommandCallback, FailureLoggingCallback-&gt;CommandMessage, NoOpCallback-&gt;CommandResultMessage, NoOpCallback-&gt;CommandCallback, NoOpCallback-&gt;CommandMessage, LoggingCallback-&gt;CommandResultMessage, LoggingCallback-&gt;CommandCallback...</td>
      <td>[SimpleCommandBus$Builder-&gt;LoggingCallback, SimpleCommandBus$Builder-&gt;NoOpCallback]</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>0.666667</td>
      <td>5</td>
      <td>1</td>
      <td>[FlowControllingStreamObserver-&gt;AxonServerConfiguration, FlowControllingStreamObserver-&gt;AxonServerConfiguration$FlowControlConfiguration, PriorityExecutorService-&gt;PriorityCallable, PriorityExecutorService-&gt;PriorityRunnable, ExecutorServiceBuilder-&gt;AxonServerConfiguration]</td>
      <td>[ErrorCode-&gt;ExceptionSerializer]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.serialization</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
      <td>[AbstractSequencedDomainEventEntry-&gt;Serializer, AbstractDomainEventEntry-&gt;Serializer, EventUtils-&gt;LazyDeserializingObject, EventUtils-&gt;Serializer, EventUtils-&gt;SerializedMessage, TrackedDomainEventData-&gt;SerializedObject, GenericEventMessage-&gt;CachingSupplier, AbstractEventEntry-&gt;SerializedMetaData...</td>
      <td>[AbstractXStreamSerializer-&gt;GenericDomainEventMessage, AbstractXStreamSerializer-&gt;GenericEventMessage, GapAwareTrackingTokenConverter-&gt;GapAwareTrackingToken]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
      <td>[BatchingUnitOfWork-&gt;ResultMessage, BatchingUnitOfWork-&gt;Message, BatchingUnitOfWork-&gt;GenericResultMessage, AbstractUnitOfWork-&gt;Message, AbstractUnitOfWork-&gt;MetaData, CurrentUnitOfWork-&gt;MetaData, ExecutionResult-&gt;ResultMessage, UnitOfWork-&gt;Message, UnitOfWork-&gt;ResultMessage]</td>
      <td>[GenericMessage-&gt;CurrentUnitOfWork, DefaultInterceptorChain-&gt;UnitOfWork, MessageHandlerInterceptor-&gt;UnitOfWork]</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>0.615385</td>
      <td>21</td>
      <td>5</td>
      <td>[AxonServerEventStore$AxonIQEventStorageEngine$1-&gt;AxonServerConfiguration, AxonServerEventStore$AxonIQEventStorageEngine$1-&gt;AxonServerConnectionManager, AxonServerEventScheduler$Builder-&gt;AxonServerConnectionManager, EventBuffer-&gt;ErrorCode, EventBuffer-&gt;AxonServerException, AxonServerEventSchedul...</td>
      <td>[ServerConnectorConfigurerModule-&gt;AxonServerEventStoreFactory$Builder, ServerConnectorConfigurerModule-&gt;AxonServerEventStoreFactory, ServerConnectorConfigurerModule-&gt;AxonServerEventStore, ServerConnectorConfigurerModule-&gt;EventProcessorInfoConfiguration, ServerConnectorConfigurerModule-&gt;AxonServe...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>0.571429</td>
      <td>22</td>
      <td>6</td>
      <td>[QuerySerializer-&gt;ErrorCode, QuerySerializer-&gt;AxonServerConfiguration, AxonServerQueryBus$LocalSegmentAdapter-&gt;PriorityRunnable, AxonServerQueryBus$LocalSegmentAdapter-&gt;ErrorCode, AxonServerQueryBus$LocalSegmentAdapter-&gt;AxonServerConfiguration, StreamableFluxResponse$SendingSubscriber-&gt;ErrorCode...</td>
      <td>[ErrorCode-&gt;AxonServerQueryDispatchException, ErrorCode-&gt;AxonServerNonTransientRemoteQueryHandlingException, ErrorCode-&gt;AxonServerRemoteQueryHandlingException, ServerConnectorConfigurerModule-&gt;AxonServerQueryBus, ServerConnectorConfigurerModule-&gt;QueryPriorityCalculator, ServerConnectorConfigurer...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>0.538462</td>
      <td>10</td>
      <td>3</td>
      <td>[PropertySequencingPolicy$Builder-&gt;EventMessage, FullConcurrencyPolicy-&gt;EventMessage, EventProcessorTask$ProcessingTask-&gt;EventMessage, EventProcessorTask-&gt;EventMessage, AsynchronousEventProcessingStrategy-&gt;EventMessage, AsynchronousEventProcessingStrategy-&gt;EventProcessingStrategy, PropertySequen...</td>
      <td>[SimpleEventHandlerInvoker$Builder-&gt;SequencingPolicy, SimpleEventHandlerInvoker$Builder-&gt;SequentialPerAggregatePolicy, SimpleEventHandlerInvoker-&gt;SequencingPolicy]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling.replay</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>0.454545</td>
      <td>8</td>
      <td>3</td>
      <td>[ReplayAwareMessageHandlerWrapper-&gt;AllowReplay, ReplayAwareMessageHandlerWrapper$ReplayBlockingMessageHandlingMember-&gt;ReplayToken, ReplayParameterResolverFactory$ReplayParameterResolver-&gt;ReplayStatus, ReplayParameterResolverFactory$ReplayParameterResolver-&gt;ReplayToken, ReplayContextParameterReso...</td>
      <td>[AnnotationEventHandlerAdapter-&gt;GenericResetContext, AnnotationEventHandlerAdapter-&gt;ResetContext, ResetHandler-&gt;ResetContext]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.event.util</td>
      <td>0.333333</td>
      <td>2</td>
      <td>1</td>
      <td>[AxonServerConfiguration-&gt;EventCipher, AxonServerConfiguration$Builder-&gt;EventCipher]</td>
      <td>[GrpcExceptionParser-&gt;ErrorCode]</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query.subscription</td>
      <td>0.333333</td>
      <td>4</td>
      <td>2</td>
      <td>[AxonServerQueryBus$LocalSegmentAdapter-&gt;SubscriptionMessageSerializer, AxonServerQueryBus-&gt;SubscriptionMessageSerializer, AxonServerQueryBus-&gt;AxonServerSubscriptionQueryResult, AxonServerQueryBus$Builder-&gt;SubscriptionMessageSerializer]</td>
      <td>[GrpcBackedSubscriptionQueryMessage-&gt;GrpcBackedQueryMessage, SubscriptionMessageSerializer-&gt;GrpcBackedResponseMessage]</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.serialization.upcasting.event</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>0.333333</td>
      <td>6</td>
      <td>3</td>
      <td>[UpcastedEventRepresentation-&gt;TrackingToken, IntermediateEventRepresentation-&gt;TrackingToken, InitialEventRepresentation-&gt;DomainEventData, InitialEventRepresentation-&gt;EventData, InitialEventRepresentation-&gt;TrackedEventData, InitialEventRepresentation-&gt;TrackingToken]</td>
      <td>[EventUtils-&gt;IntermediateEventRepresentation, EventUtils-&gt;EventUpcaster, EventUtils-&gt;InitialEventRepresentation]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc.statements</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
      <td>[JdbcEventStorageEngine$Builder-&gt;AppendSnapshotStatementBuilder, JdbcEventStorageEngine$Builder-&gt;ReadEventDataWithGapsStatementBuilder, JdbcEventStorageEngine$Builder-&gt;ReadEventDataWithoutGapsStatementBuilder, JdbcEventStorageEngine$Builder-&gt;CreateTokenAtStatementBuilder, JdbcEventStorageEngine$...</td>
      <td>[ReadEventDataForAggregateStatementBuilder-&gt;EventSchema, CleanGapsStatementBuilder-&gt;EventSchema, ReadEventDataWithoutGapsStatementBuilder-&gt;EventSchema, DeleteSnapshotsStatementBuilder-&gt;EventSchema, CreateTailTokenStatementBuilder-&gt;EventSchema, CreateHeadTokenStatementBuilder-&gt;EventSchema, FetchT...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling.tokenstore</td>
      <td>0.285714</td>
      <td>9</td>
      <td>5</td>
      <td>[TrackingEventProcessor$MergeSegmentInstruction-&gt;TokenStore, TrackingEventProcessor$WorkerLauncher-&gt;UnableToClaimTokenException, TrackingEventProcessor$WorkerLauncher-&gt;TokenStore, TrackingEventProcessor$SplitSegmentInstruction-&gt;TokenStore, TrackingEventProcessor$ClaimSegmentInstruction-&gt;TokenSto...</td>
      <td>[ConfigToken-&gt;TrackingToken, GenericTokenEntry-&gt;TrackingToken, AbstractTokenEntry-&gt;TrackingToken, TokenStore-&gt;TrackingToken, TokenStore-&gt;Segment]</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-modelling-4.10.3</td>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>axon-modelling-4.10.3</td>
      <td>org.axonframework.modelling.command</td>
      <td>0.250000</td>
      <td>20</td>
      <td>12</td>
      <td>[AggregateMemberAnnotatedChildEntityMapDefinition-&gt;ForwardingMode, MethodCreationPolicyDefinition-&gt;CreationPolicy, AggregateMemberAnnotatedChildEntityDefinition-&gt;ForwardingMode, AbstractChildEntityDefinition-&gt;ForwardingMode, AbstractChildEntityDefinition-&gt;AggregateMember, MethodCommandHandlerInt...</td>
      <td>[AggregateAnnotationCommandHandler-&gt;AggregateModel, AggregateAnnotationCommandHandler-&gt;CreationPolicyMember, AbstractRepository-&gt;AggregateModel, GenericJpaRepository$Builder-&gt;AggregateModel, AggregateAnnotationCommandHandler$Builder-&gt;AnnotatedAggregateMetaModelFactory, AggregateAnnotationCommand...</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling.registration</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>0.250000</td>
      <td>5</td>
      <td>3</td>
      <td>[DuplicateQueryHandlerResolution-&gt;QuerySubscription, FailingDuplicateQueryHandlerResolver-&gt;QuerySubscription, DuplicateQueryHandlerSubscriptionException-&gt;QuerySubscription, DuplicateQueryHandlerResolver-&gt;QuerySubscription, LoggingDuplicateQueryHandlerResolver-&gt;QuerySubscription]</td>
      <td>[SimpleQueryBus-&gt;DuplicateQueryHandlerResolver, SimpleQueryBus$Builder-&gt;DuplicateQueryHandlerResolver, SimpleQueryBus$Builder-&gt;DuplicateQueryHandlerResolution]</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.serialization</td>
      <td>0.238095</td>
      <td>13</td>
      <td>8</td>
      <td>[GenericMessage-&gt;SerializedObject, GenericMessage-&gt;SerializedObjectHolder, GenericMessage-&gt;Serializer, Message-&gt;Serializer, Message-&gt;SerializedObject, ResultMessage-&gt;Serializer, ResultMessage-&gt;SerializedObject, Headers-&gt;SerializedObject, Headers-&gt;SerializedType]</td>
      <td>[SerializedMessage-&gt;GenericMessage, SerializedMessage-&gt;MetaData, SerializedMessage-&gt;AbstractMessage, SerializedMessage-&gt;Message, SerializedObjectHolder-&gt;Message, AbstractXStreamSerializer$MetaDataConverter-&gt;MetaData, AbstractXStreamSerializer-&gt;MetaData, SerializedMetaData-&gt;MetaData]</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.command</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>0.222222</td>
      <td>11</td>
      <td>7</td>
      <td>[AxonServerCommandBus$Builder-&gt;AxonServerConnectionManager, AxonServerCommandBus$Builder-&gt;AxonServerConfiguration, AxonServerCommandBus$Builder-&gt;TargetContextResolver, CommandSerializer-&gt;ErrorCode, CommandSerializer-&gt;AxonServerConfiguration, AxonServerCommandBus-&gt;TargetContextResolver, AxonServe...</td>
      <td>[ErrorCode-&gt;AxonServerCommandDispatchException, ErrorCode-&gt;AxonServerNonTransientRemoteCommandHandlingException, ErrorCode-&gt;AxonServerRemoteCommandHandlingException, ServerConnectorConfigurerModule-&gt;CommandPriorityCalculator, ServerConnectorConfigurerModule-&gt;AxonServerCommandBus, ServerConnector...</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.interceptors</td>
      <td>0.200000</td>
      <td>3</td>
      <td>2</td>
      <td>[ResultParameterResolverFactory-&gt;ResultHandler, MessageHandlerInterceptorDefinition-&gt;MessageHandlerInterceptor, MessageHandlerInterceptorDefinition-&gt;ResultHandler]</td>
      <td>[MessageHandlerInterceptor-&gt;MessageHandler, ResultHandler-&gt;HasHandlerAttributes]</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-modelling-4.10.3</td>
      <td>org.axonframework.modelling.saga</td>
      <td>axon-modelling-4.10.3</td>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>0.142857</td>
      <td>4</td>
      <td>3</td>
      <td>[AnnotatedSagaManager$Builder-&gt;SagaModel, AnnotatedSagaManager$Builder-&gt;AnnotationSagaMetaModelFactory, AnnotatedSagaManager-&gt;SagaModel, AnnotatedSaga-&gt;SagaModel]</td>
      <td>[SagaModel-&gt;AssociationValue, AnnotationSagaMetaModelFactory$InspectedSagaModel-&gt;AssociationValue, AnnotationSagaMetaModelFactory$InspectedSagaModel-&gt;SagaMethodMessageHandlingMember]</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling.distributed.commandfilter</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>0.076923</td>
      <td>7</td>
      <td>6</td>
      <td>[AndCommandMessageFilter-&gt;CommandMessageFilter, AcceptAll-&gt;CommandMessageFilter, NegateCommandMessageFilter-&gt;CommandMessageFilter, DenyAll-&gt;CommandMessageFilter, DenyCommandNameFilter-&gt;CommandMessageFilter, OrCommandMessageFilter-&gt;CommandMessageFilter, CommandNameFilter-&gt;CommandMessageFilter]</td>
      <td>[CommandMessageFilter-&gt;NegateCommandMessageFilter, CommandMessageFilter-&gt;OrCommandMessageFilter, CommandMessageFilter-&gt;AndCommandMessageFilter, DistributedCommandBus-&gt;CommandNameFilter, DistributedCommandBus-&gt;DenyAll, DistributedCommandBus-&gt;DenyCommandNameFilter]</td>
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
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>TrackingEventProcessor$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>SimpleEventBus$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventProcessorSpanFactory-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>EventMessage&lt;-NestingSpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventBusSpanFactory-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventProcessorSpanFactory-&gt;NoOpSpanFactory$NoOpSpan</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventProcessorSpanFactory$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor$Builder-&gt;NoOpSpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventProcessorSpanFactory-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>EventProcessorSpanFactory-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>EventBusSpanFactory-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus$Builder-&gt;NoOpSpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventBusSpanFactory-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus-&gt;SpanScope</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor-&gt;Span</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultEventBusSpanFactory$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>SubscribingEventProcessor$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor$Builder-&gt;SpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryBus-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericSubscriptionQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;PublisherResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;MultipleInstancesResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryGateway-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QuerySubscription-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>DefaultQueryGateway-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryGateway-&gt;ResponseTypes</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;OptionalResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SubscriptionQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryResponseMessage&lt;-ConvertingResponseMessage</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>StreamingQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericStreamingQueryMessage-&gt;PublisherResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericStreamingQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>QueryMessage&lt;-SpanUtils</td>
      <td>0.875000</td>
      <td>15</td>
      <td>1</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>DefaultQueryBusSpanFactory$Builder-&gt;SpanFactory</td>
      <td>0.875000</td>
      <td>15</td>
      <td>1</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>SimpleQueryUpdateEmitter-&gt;Span</td>
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
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>EventMessage&lt;-NestingSpanFactory</td>
      <td>0.900000</td>
      <td>19</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryResponseMessage&lt;-ConvertingResponseMessage</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.queryhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>QueryMessage&lt;-SpanUtils</td>
      <td>0.875000</td>
      <td>15</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging</td>
      <td>TrackingToken&lt;-StreamableMessageSource</td>
      <td>0.857143</td>
      <td>39</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging</td>
      <td>EventMessage&lt;-Headers</td>
      <td>0.857143</td>
      <td>39</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging</td>
      <td>DomainEventMessage&lt;-Headers</td>
      <td>0.857143</td>
      <td>39</td>
      <td>3</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>DomainEventMessage&lt;-SourceIdParameterResolverFactory$SourceIdParameterResolver</td>
      <td>0.840000</td>
      <td>23</td>
      <td>2</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>DomainEventMessage&lt;-AggregateTypeParameterResolverFactory$AggregateTypeParameterResolver</td>
      <td>0.840000</td>
      <td>23</td>
      <td>2</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.deadline</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>DeadlineMessage&lt;-SpanUtils</td>
      <td>0.800000</td>
      <td>9</td>
      <td>1</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.tracing</td>
      <td>CommandMessage&lt;-SpanUtils</td>
      <td>0.777778</td>
      <td>8</td>
      <td>1</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>EventStreamUtils&lt;-AbstractEventStorageEngine</td>
      <td>0.777778</td>
      <td>16</td>
      <td>2</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.eventsourcing</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>EventStreamUtils&lt;-DomainEventStream</td>
      <td>0.777778</td>
      <td>16</td>
      <td>2</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>LoggingCallback&lt;-SimpleCommandBus$Builder</td>
      <td>0.733333</td>
      <td>13</td>
      <td>2</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.commandhandling</td>
      <td>NoOpCallback&lt;-SimpleCommandBus$Builder</td>
      <td>0.733333</td>
      <td>13</td>
      <td>2</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.util</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>ExceptionSerializer&lt;-ErrorCode</td>
      <td>0.666667</td>
      <td>5</td>
      <td>1</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.serialization</td>
      <td>GapAwareTrackingToken&lt;-GapAwareTrackingTokenConverter</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.serialization</td>
      <td>GenericDomainEventMessage&lt;-AbstractXStreamSerializer</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.serialization</td>
      <td>GenericEventMessage&lt;-AbstractXStreamSerializer</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging</td>
      <td>CurrentUnitOfWork&lt;-GenericMessage</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging</td>
      <td>UnitOfWork&lt;-DefaultInterceptorChain</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.messaging</td>
      <td>UnitOfWork&lt;-MessageHandlerInterceptor</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerEventStore$Builder&lt;-ServerConnectorConfigurerModule</td>
      <td>0.615385</td>
      <td>21</td>
      <td>5</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>EventProcessorInfoConfiguration&lt;-ServerConnectorConfigurerModule</td>
      <td>0.615385</td>
      <td>21</td>
      <td>5</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerEventStore&lt;-ServerConnectorConfigurerModule</td>
      <td>0.615385</td>
      <td>21</td>
      <td>5</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerEventStoreFactory&lt;-ServerConnectorConfigurerModule</td>
      <td>0.615385</td>
      <td>21</td>
      <td>5</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerEventStoreFactory$Builder&lt;-ServerConnectorConfigurerModule</td>
      <td>0.615385</td>
      <td>21</td>
      <td>5</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerNonTransientRemoteQueryHandlingException&lt;-ErrorCode</td>
      <td>0.571429</td>
      <td>22</td>
      <td>6</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerQueryDispatchException&lt;-ErrorCode</td>
      <td>0.571429</td>
      <td>22</td>
      <td>6</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerQueryBus$Builder&lt;-ServerConnectorConfigurerModule</td>
      <td>0.571429</td>
      <td>22</td>
      <td>6</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>QueryPriorityCalculator&lt;-ServerConnectorConfigurerModule</td>
      <td>0.571429</td>
      <td>22</td>
      <td>6</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerQueryBus&lt;-ServerConnectorConfigurerModule</td>
      <td>0.571429</td>
      <td>22</td>
      <td>6</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>AxonServerRemoteQueryHandlingException&lt;-ErrorCode</td>
      <td>0.571429</td>
      <td>22</td>
      <td>6</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>SequentialPerAggregatePolicy&lt;-SimpleEventHandlerInvoker$Builder</td>
      <td>0.538462</td>
      <td>10</td>
      <td>3</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>SequencingPolicy&lt;-SimpleEventHandlerInvoker$Builder</td>
      <td>0.538462</td>
      <td>10</td>
      <td>3</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>SequencingPolicy&lt;-SimpleEventHandlerInvoker</td>
      <td>0.538462</td>
      <td>10</td>
      <td>3</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling.replay</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>ResetContext&lt;-AnnotationEventHandlerAdapter</td>
      <td>0.454545</td>
      <td>8</td>
      <td>3</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling.replay</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>GenericResetContext&lt;-AnnotationEventHandlerAdapter</td>
      <td>0.454545</td>
      <td>8</td>
      <td>3</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling.replay</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventhandling</td>
      <td>ResetContext&lt;-ResetHandler</td>
      <td>0.454545</td>
      <td>8</td>
      <td>3</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.event.util</td>
      <td>ErrorCode&lt;-GrpcExceptionParser</td>
      <td>0.333333</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query</td>
      <td>axon-server-connector-4.10.3</td>
      <td>org.axonframework.axonserver.connector.query.subscription</td>
      <td>GrpcBackedResponseMessage&lt;-SubscriptionMessageSerializer</td>
      <td>0.333333</td>
      <td>4</td>
      <td>2</td>
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
      <td>20</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>9</td>
      <td>[getTimestamp, getIdentifier]</td>
      <td>2</td>
      <td>11</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventhandling.DomainEventMessage</td>
      <td>10</td>
      <td>[getSequenceNumber]</td>
      <td>1</td>
      <td>9</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>9</td>
      <td>[getIdentifier]</td>
      <td>1</td>
      <td>9</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventhandling.TrackedEventMessage</td>
      <td>10</td>
      <td>[trackingToken]</td>
      <td>1</td>
      <td>8</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.commandhandling.GenericCommandResultMessage</td>
      <td>14</td>
      <td>[asCommandResultMessage]</td>
      <td>1</td>
      <td>6</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.eventhandling.DomainEventMessage</td>
      <td>10</td>
      <td>[getSequenceNumber, getAggregateIdentifier, getType]</td>
      <td>3</td>
      <td>6</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.messaging.ResultMessage</td>
      <td>9</td>
      <td>[exceptionResult, isExceptional]</td>
      <td>2</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.eventhandling.ReplayToken</td>
      <td>13</td>
      <td>[createReplayToken]</td>
      <td>1</td>
      <td>5</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.deadline.GenericDeadlineMessage</td>
      <td>11</td>
      <td>[asDeadlineMessage]</td>
      <td>1</td>
      <td>5</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.eventhandling.DomainEventMessage</td>
      <td>10</td>
      <td>[getAggregateIdentifier]</td>
      <td>1</td>
      <td>5</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.eventhandling.TrackedEventMessage</td>
      <td>12</td>
      <td>[trackingToken]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.deadline.DeadlineMessage</td>
      <td>10</td>
      <td>[getDeadlineName]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.eventhandling.DomainEventMessage</td>
      <td>10</td>
      <td>[getType]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.eventhandling.GenericEventMessage</td>
      <td>10</td>
      <td>[asEventMessage]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>9</td>
      <td>[getTimestamp]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.deadline.DefaultDeadlineManagerSpanFactory</td>
      <td>8</td>
      <td>[builder]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.common.transaction.NoTransactionManager</td>
      <td>4</td>
      <td>[instance]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.queryhandling.SimpleQueryUpdateEmitter</td>
      <td>17</td>
      <td>[builder]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.commandhandling.GenericCommandResultMessage</td>
      <td>15</td>
      <td>[asCommandResultMessage]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>20</th>
      <td>org.axonframework.modelling.command.inspection.AggregateModel</td>
      <td>13</td>
      <td>[type]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>21</th>
      <td>org.axonframework.queryhandling.SubscriptionQueryMessage</td>
      <td>12</td>
      <td>[getUpdateResponseType]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>22</th>
      <td>org.axonframework.eventhandling.DomainEventMessage</td>
      <td>11</td>
      <td>[getSequenceNumber, getAggregateIdentifier, getType]</td>
      <td>3</td>
      <td>3</td>
    </tr>
    <tr>
      <th>23</th>
      <td>org.axonframework.eventhandling.GenericEventMessage</td>
      <td>11</td>
      <td>[asEventMessage]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>24</th>
      <td>org.axonframework.queryhandling.SimpleQueryBus</td>
      <td>11</td>
      <td>[builder]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>25</th>
      <td>org.axonframework.eventhandling.DomainEventMessage</td>
      <td>10</td>
      <td>[getSequenceNumber, getAggregateIdentifier]</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>26</th>
      <td>org.axonframework.eventhandling.GapAwareTrackingToken</td>
      <td>10</td>
      <td>[withGapsTruncatedAt, getGaps, advanceTo, getIndex, newInstance]</td>
      <td>5</td>
      <td>3</td>
    </tr>
    <tr>
      <th>27</th>
      <td>org.axonframework.queryhandling.DefaultQueryBusSpanFactory</td>
      <td>10</td>
      <td>[builder]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>28</th>
      <td>org.axonframework.commandhandling.gateway.DefaultCommandGateway</td>
      <td>9</td>
      <td>[builder]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>29</th>
      <td>org.axonframework.config.Configuration</td>
      <td>9</td>
      <td>[upcasterChain, snapshotFilter]</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>30</th>
      <td>org.axonframework.config.Configuration</td>
      <td>9</td>
      <td>[getComponent]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>31</th>
      <td>org.axonframework.messaging.MessageDecorator</td>
      <td>9</td>
      <td>[describeTo]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>32</th>
      <td>org.axonframework.queryhandling.QueryMessage</td>
      <td>9</td>
      <td>[getResponseType, getQueryName]</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>33</th>
      <td>org.axonframework.commandhandling.DefaultCommandBusSpanFactory</td>
      <td>5</td>
      <td>[builder]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>34</th>
      <td>org.axonframework.eventhandling.TrackedEventData</td>
      <td>5</td>
      <td>[trackingToken]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>35</th>
      <td>org.axonframework.eventhandling.tokenstore.ConfigToken</td>
      <td>5</td>
      <td>[get]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>36</th>
      <td>org.axonframework.eventhandling.DefaultEventBusSpanFactory</td>
      <td>4</td>
      <td>[builder]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>37</th>
      <td>org.axonframework.queryhandling.DefaultQueryUpdateEmitterSpanFactory</td>
      <td>4</td>
      <td>[builder]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>38</th>
      <td>org.axonframework.eventhandling.TrackerStatus</td>
      <td>17</td>
      <td>[split, getSegment, getTrackingToken]</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>39</th>
      <td>org.axonframework.modelling.command.inspection.AnnotatedAggregate</td>
      <td>17</td>
      <td>[initialize, getAggregateRoot, initSequence]</td>
      <td>4</td>
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
      <td>[Type, File, Java, ByteCode, Class, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>49</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.common.AxonConfigurationException</td>
      <td>AxonConfigurationException</td>
      <td>[Type, File, Java, ByteCode, Class, Throwable, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>42</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.messaging.Message</td>
      <td>Message</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityBetweenness, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInduce...</td>
      <td>41</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.messaging.MetaData</td>
      <td>MetaData</td>
      <td>[Type, File, Java, ByteCode, Class, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityBetweenness, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>39</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.serialization.Serializer</td>
      <td>Serializer</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityBetweenness, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>36</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>EventMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>35</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.messaging.unitofwork.UnitOfWork</td>
      <td>UnitOfWork</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityArticleRank, Mark4TopCentralityBetweenness, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>32</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.common.transaction.TransactionManager</td>
      <td>TransactionManager</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>31</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.common.Assert</td>
      <td>Assert</td>
      <td>[Type, File, Java, ByteCode, Class, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>29</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.serialization.SerializedObject</td>
      <td>SerializedObject</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityBetweenness, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInduce...</td>
      <td>27</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.serialization.SerializedType</td>
      <td>SerializedType</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>27</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.messaging.unitofwork.CurrentUnitOfWork</td>
      <td>CurrentUnitOfWork</td>
      <td>[Type, File, Java, ByteCode, Class, Mark4TopCentralityBetweenness, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness]</td>
      <td>22</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.common.Registration</td>
      <td>Registration</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>22</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.tracing.SpanFactory</td>
      <td>SpanFactory</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityArticleRank, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>22</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.lifecycle.Lifecycle</td>
      <td>Lifecycle</td>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>20</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.lifecycle.Lifecycle$LifecycleRegistry</td>
      <td>Lifecycle$LifecycleRegistry</td>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>20</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.common.ObjectUtils</td>
      <td>ObjectUtils</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>20</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.eventhandling.TrackingToken</td>
      <td>TrackingToken</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>20</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.eventhandling.DomainEventMessage</td>
      <td>DomainEventMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>19</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.messaging.annotation.ParameterResolverFactory</td>
      <td>ParameterResolverFactory</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>19</td>
    </tr>
    <tr>
      <th>20</th>
      <td>org.axonframework.common.AxonNonTransientException</td>
      <td>AxonNonTransientException</td>
      <td>[Type, File, Java, ByteCode, Class, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness]</td>
      <td>18</td>
    </tr>
    <tr>
      <th>21</th>
      <td>org.axonframework.eventhandling.GenericEventMessage</td>
      <td>GenericEventMessage</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDeclaration, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>18</td>
    </tr>
    <tr>
      <th>22</th>
      <td>org.axonframework.messaging.MessageDispatchInterceptor</td>
      <td>MessageDispatchInterceptor</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>18</td>
    </tr>
    <tr>
      <th>23</th>
      <td>org.axonframework.messaging.MessageHandlerInterceptor</td>
      <td>MessageHandlerInterceptor</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityBetweenness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>18</td>
    </tr>
    <tr>
      <th>24</th>
      <td>org.axonframework.serialization.SimpleSerializedObject</td>
      <td>SimpleSerializedObject</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDeclaration, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness]</td>
      <td>18</td>
    </tr>
    <tr>
      <th>25</th>
      <td>org.axonframework.tracing.NoOpSpanFactory</td>
      <td>NoOpSpanFactory</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>17</td>
    </tr>
    <tr>
      <th>26</th>
      <td>org.axonframework.commandhandling.CommandMessage</td>
      <td>CommandMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>16</td>
    </tr>
    <tr>
      <th>27</th>
      <td>org.axonframework.eventhandling.EventBus</td>
      <td>EventBus</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>15</td>
    </tr>
    <tr>
      <th>28</th>
      <td>org.axonframework.messaging.annotation.HandlerDefinition</td>
      <td>HandlerDefinition</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>15</td>
    </tr>
    <tr>
      <th>29</th>
      <td>org.axonframework.common.transaction.NoTransactionManager</td>
      <td>NoTransactionManager</td>
      <td>[Type, File, Java, ByteCode, Enum]</td>
      <td>15</td>
    </tr>
    <tr>
      <th>30</th>
      <td>org.axonframework.messaging.ResultMessage</td>
      <td>ResultMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityArticleRank, Mark4TopCentralityBetweenness, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness]</td>
      <td>15</td>
    </tr>
    <tr>
      <th>31</th>
      <td>org.axonframework.tracing.Span</td>
      <td>Span</td>
      <td>[Type, File, Java, ByteCode, Interface, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>15</td>
    </tr>
    <tr>
      <th>32</th>
      <td>org.axonframework.messaging.unitofwork.DefaultUnitOfWork</td>
      <td>DefaultUnitOfWork</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDeclaration]</td>
      <td>14</td>
    </tr>
    <tr>
      <th>33</th>
      <td>org.axonframework.common.ReflectionUtils</td>
      <td>ReflectionUtils</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>14</td>
    </tr>
    <tr>
      <th>34</th>
      <td>org.axonframework.eventhandling.TrackedEventMessage</td>
      <td>TrackedEventMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaration, Interface, Mark4TopCentralityArticleRank, Mark4TopCentralityHyperlinkInducedTopicSearchAuthority, Mark4TopCentralityHyperlinkInducedTopicSearchHub]</td>
      <td>13</td>
    </tr>
    <tr>
      <th>35</th>
      <td>org.axonframework.common.AxonException</td>
      <td>AxonException</td>
      <td>[Type, File, Java, ByteCode, Class, Mark4TopCentralityPageRank, Mark4TopCentralityArticleRank, Mark4TopCentralityHarmonic, Mark4TopCentralityCloseness]</td>
      <td>12</td>
    </tr>
    <tr>
      <th>36</th>
      <td>org.axonframework.common.DateTimeUtils</td>
      <td>DateTimeUtils</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>12</td>
    </tr>
    <tr>
      <th>37</th>
      <td>org.axonframework.messaging.DefaultInterceptorChain</td>
      <td>DefaultInterceptorChain</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDeclaration]</td>
      <td>12</td>
    </tr>
    <tr>
      <th>38</th>
      <td>org.axonframework.eventhandling.GenericDomainEventMessage</td>
      <td>GenericDomainEventMessage</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDeclaration]</td>
      <td>12</td>
    </tr>
    <tr>
      <th>39</th>
      <td>org.axonframework.messaging.InterceptorChain</td>
      <td>InterceptorChain</td>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>12</td>
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
      <td>axon-tracing-opentelemetry-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>3</td>
      <td>64</td>
      <td>0.046875</td>
      <td>[org.axonframework.tracing, org.axonframework.messaging, org.axonframework.common]</td>
      <td>[tracing, messaging, common]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>1</td>
      <td>10</td>
      <td>0.100000</td>
      <td>[org.axonframework.modelling.command]</td>
      <td>[command]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-test-4.10.3</td>
      <td>1</td>
      <td>8</td>
      <td>0.125000</td>
      <td>[org.axonframework.test.server]</td>
      <td>[server]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>9</td>
      <td>64</td>
      <td>0.140625</td>
      <td>[org.axonframework.messaging, org.axonframework.common.caching, org.axonframework.commandhandling.callbacks, org.axonframework.monitoring, org.axonframework.messaging.annotation, org.axonframework.common, org.axonframework.common.transaction, org.axonframework.messaging.unitofwork, org.axonframe...</td>
      <td>[messaging, caching, callbacks, monitoring, annotation, common, transaction, unitofwork, commandhandling]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>10</td>
      <td>64</td>
      <td>0.156250</td>
      <td>[org.axonframework.eventhandling, org.axonframework.messaging.annotation, org.axonframework.deadline, org.axonframework.commandhandling, org.axonframework.common, org.axonframework.common.stream, org.axonframework.messaging.unitofwork, org.axonframework.messaging, org.axonframework.commandhandli...</td>
      <td>[eventhandling, annotation, deadline, commandhandling, common, stream, unitofwork, messaging, gateway, scheduling]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>2</td>
      <td>10</td>
      <td>0.200000</td>
      <td>[org.axonframework.modelling.command, org.axonframework.modelling.command.inspection]</td>
      <td>[command, inspection]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-disruptor-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>2</td>
      <td>10</td>
      <td>0.200000</td>
      <td>[org.axonframework.modelling.command.inspection, org.axonframework.modelling.command]</td>
      <td>[inspection, command]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-test-4.10.3</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>2</td>
      <td>9</td>
      <td>0.222222</td>
      <td>[org.axonframework.eventsourcing, org.axonframework.eventsourcing.eventstore]</td>
      <td>[eventsourcing, eventstore]</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-disruptor-4.10.3</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>2</td>
      <td>9</td>
      <td>0.222222</td>
      <td>[org.axonframework.eventsourcing, org.axonframework.eventsourcing.eventstore]</td>
      <td>[eventsourcing, eventstore]</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-modelling-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>18</td>
      <td>64</td>
      <td>0.281250</td>
      <td>[org.axonframework.common.annotation, org.axonframework.deadline, org.axonframework.messaging.unitofwork, org.axonframework.messaging, org.axonframework.commandhandling, org.axonframework.eventhandling, org.axonframework.messaging.annotation, org.axonframework.tracing, org.axonframework.messagin...</td>
      <td>[annotation, deadline, unitofwork, messaging, commandhandling, eventhandling, tracing, interceptors, lock, common, property, jpa, caching, serialization, xml, jdbc, legacyjpa]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>20</td>
      <td>64</td>
      <td>0.312500</td>
      <td>[org.axonframework.common.jdbc, org.axonframework.common.transaction, org.axonframework.serialization, org.axonframework.serialization.upcasting.event, org.axonframework.eventhandling, org.axonframework.common.jpa, org.axonframework.common.io, org.axonframework.common, org.axonframework.messagin...</td>
      <td>[jdbc, transaction, serialization, event, eventhandling, jpa, io, common, unitofwork, caching, annotation, lock, messaging, tracing, lifecycle, stream, xml, monitoring, commandhandling, legacyjpa]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>3</td>
      <td>9</td>
      <td>0.333333</td>
      <td>[org.axonframework.eventsourcing.eventstore, org.axonframework.eventsourcing.snapshotting, org.axonframework.eventsourcing]</td>
      <td>[eventstore, snapshotting, eventsourcing]</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-server-connector-4.10.3</td>
      <td>4</td>
      <td>11</td>
      <td>0.363636</td>
      <td>[org.axonframework.axonserver.connector, org.axonframework.axonserver.connector.event.axon, org.axonframework.axonserver.connector.query, org.axonframework.axonserver.connector.command]</td>
      <td>[connector, axon, query, command]</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>25</td>
      <td>64</td>
      <td>0.390625</td>
      <td>[org.axonframework.messaging.unitofwork, org.axonframework.common.jdbc, org.axonframework.common, org.axonframework.serialization.upcasting.event, org.axonframework.eventhandling.async, org.axonframework.serialization.xml, org.axonframework.lifecycle, org.axonframework.eventhandling.scheduling, ...</td>
      <td>[unitofwork, jdbc, common, event, async, xml, lifecycle, scheduling, eventhandling, tracing, stream, messaging, monitoring, serialization, java, responsetypes, queryhandling, pooled, tokenstore, transaction, commandhandling, callbacks, distributed, util, inmemory]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-configuration-4.10.3</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>4</td>
      <td>9</td>
      <td>0.444444</td>
      <td>[org.axonframework.eventsourcing.snapshotting, org.axonframework.eventsourcing.eventstore, org.axonframework.eventsourcing.eventstore.jpa, org.axonframework.eventsourcing]</td>
      <td>[snapshotting, eventstore, jpa, eventsourcing]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-test-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>5</td>
      <td>10</td>
      <td>0.500000</td>
      <td>[org.axonframework.modelling.command.inspection, org.axonframework.modelling.command, org.axonframework.modelling.saga.repository, org.axonframework.modelling.saga, org.axonframework.modelling.saga.repository.inmemory]</td>
      <td>[inspection, command, repository, saga, inmemory]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-configuration-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>34</td>
      <td>64</td>
      <td>0.531250</td>
      <td>[org.axonframework.eventhandling.tokenstore.jpa, org.axonframework.serialization.xml, org.axonframework.commandhandling, org.axonframework.common.lock, org.axonframework.common.jpa, org.axonframework.eventhandling.async, org.axonframework.eventhandling, org.axonframework.util, org.axonframework....</td>
      <td>[jpa, xml, commandhandling, lock, async, eventhandling, util, gateway, unitofwork, annotation, monitoring, correlation, tracing, jdbc, tokenstore, scheduling, serialization, deadline, deadletter, lifecycle, interceptors, inmemory, pooled, caching, transaction, common, messaging, queryhandling, e...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>5</td>
      <td>9</td>
      <td>0.555556</td>
      <td>[org.axonframework.eventsourcing.eventstore.legacyjpa, org.axonframework.eventsourcing.eventstore, org.axonframework.eventsourcing, org.axonframework.eventsourcing.eventstore.jpa, org.axonframework.eventsourcing.eventstore.jdbc]</td>
      <td>[legacyjpa, eventstore, eventsourcing, jpa, jdbc]</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>6</td>
      <td>10</td>
      <td>0.600000</td>
      <td>[org.axonframework.modelling.saga.repository.legacyjpa, org.axonframework.modelling.saga.repository, org.axonframework.modelling.saga.repository.jpa, org.axonframework.modelling.saga, org.axonframework.modelling.command, org.axonframework.modelling.saga.repository.jdbc]</td>
      <td>[legacyjpa, repository, jpa, saga, command, jdbc]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-modelling-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>6</td>
      <td>10</td>
      <td>0.600000</td>
      <td>[org.axonframework.modelling.command.inspection, org.axonframework.modelling.saga, org.axonframework.modelling.saga.metamodel, org.axonframework.modelling.saga.repository, org.axonframework.modelling.saga.repository.jpa, org.axonframework.modelling.command]</td>
      <td>[inspection, saga, metamodel, repository, jpa, command]</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-configuration-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>6</td>
      <td>10</td>
      <td>0.600000</td>
      <td>[org.axonframework.modelling.command.inspection, org.axonframework.modelling.saga.repository.jpa, org.axonframework.modelling.saga.repository.inmemory, org.axonframework.modelling.saga.repository, org.axonframework.modelling.command, org.axonframework.modelling.saga]</td>
      <td>[inspection, jpa, inmemory, repository, command, saga]</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>39</td>
      <td>64</td>
      <td>0.609375</td>
      <td>[org.axonframework.messaging.deadletter, org.axonframework.eventhandling, org.axonframework.common.jpa, org.axonframework.common.legacyjpa, org.axonframework.eventhandling.tokenstore, org.axonframework.serialization, org.axonframework.eventhandling.deadletter.legacyjpa, org.axonframework.eventha...</td>
      <td>[deadletter, eventhandling, jpa, legacyjpa, tokenstore, serialization, transaction, jdbc, gateway, dbscheduler, annotation, deadline, common, queryhandling, async, jobrunr, lifecycle, pooled, json, scheduling, correlation, interceptors, distributed, tracing, xml, attributes, messaging, event, co...</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-test-4.10.3</td>
      <td>axon-test-4.10.3</td>
      <td>5</td>
      <td>8</td>
      <td>0.625000</td>
      <td>[org.axonframework.test, org.axonframework.test.matchers, org.axonframework.test.deadline, org.axonframework.test.utils, org.axonframework.test.eventscheduler]</td>
      <td>[test, matchers, deadline, utils, eventscheduler]</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>41</td>
      <td>64</td>
      <td>0.640625</td>
      <td>[org.axonframework.common, org.axonframework.messaging.annotation, org.axonframework.messaging.correlation, org.axonframework.messaging.unitofwork, org.axonframework.messaging, org.axonframework.common.transaction, org.axonframework.eventhandling, org.axonframework.monitoring, org.axonframework....</td>
      <td>[common, annotation, correlation, unitofwork, messaging, transaction, eventhandling, monitoring, tracing, responsetypes, interceptors, registration, jpa, legacyjpa, tokenstore, serialization, io, stream, lifecycle, deadline, deadletter, jdbc, async, replay, event, upcasting, xml, scheduling, pro...</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>7</td>
      <td>9</td>
      <td>0.777778</td>
      <td>[org.axonframework.eventsourcing.snapshotting, org.axonframework.eventsourcing.eventstore, org.axonframework.eventsourcing.eventstore.jdbc, org.axonframework.eventsourcing.eventstore.jdbc.statements, org.axonframework.eventsourcing.conflictresolution, org.axonframework.eventsourcing, org.axonfra...</td>
      <td>[snapshotting, eventstore, jdbc, statements, conflictresolution, eventsourcing, jpa]</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-server-connector-4.10.3</td>
      <td>9</td>
      <td>11</td>
      <td>0.818182</td>
      <td>[org.axonframework.axonserver.connector, org.axonframework.axonserver.connector.util, org.axonframework.axonserver.connector.event.util, org.axonframework.axonserver.connector.processor, org.axonframework.axonserver.connector.query, org.axonframework.axonserver.connector.query.subscription, org....</td>
      <td>[connector, util, processor, query, subscription, command, heartbeat, axon]</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>8</td>
      <td>9</td>
      <td>0.888889</td>
      <td>[org.axonframework.springboot, org.axonframework.springboot.autoconfig, org.axonframework.springboot.util, org.axonframework.springboot.util.legacyjpa, org.axonframework.springboot.util.jpa, org.axonframework.actuator.axonserver, org.axonframework.springboot.service.connection, org.axonframework...</td>
      <td>[springboot, autoconfig, util, legacyjpa, jpa, axonserver, connection, actuator]</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-configuration-4.10.3</td>
      <td>1</td>
      <td>1</td>
      <td>1.000000</td>
      <td>[org.axonframework.config]</td>
      <td>[config]</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-configuration-4.10.3</td>
      <td>axon-disruptor-4.10.3</td>
      <td>1</td>
      <td>1</td>
      <td>1.000000</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[commandhandling]</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-configuration-4.10.3</td>
      <td>1</td>
      <td>1</td>
      <td>1.000000</td>
      <td>[org.axonframework.config]</td>
      <td>[config]</td>
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
      <td>axon-test-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>100</td>
      <td>0.010000</td>
      <td>[org.axonframework.eventhandling.EventMessage]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>100</td>
      <td>0.010000</td>
      <td>[org.axonframework.eventhandling.EventBusSpanFactory]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.springboot.util</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>100</td>
      <td>0.010000</td>
      <td>[org.axonframework.eventhandling.EventMessage]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-modelling-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>100</td>
      <td>0.010000</td>
      <td>[org.axonframework.eventhandling.EventMessage]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.springboot.autoconfig.legacyjpa</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>100</td>
      <td>0.010000</td>
      <td>[org.axonframework.eventhandling.EventBus]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventsourcing.snapshotting</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>100</td>
      <td>0.010000</td>
      <td>[org.axonframework.eventhandling.DomainEventData]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>org.axonframework.eventsourcing.conflictresolution</td>
      <td>org.axonframework.modelling.command</td>
      <td>1</td>
      <td>56</td>
      <td>0.017857</td>
      <td>[org.axonframework.modelling.command.ConflictingAggregateVersionException]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>org.axonframework.modelling.command</td>
      <td>1</td>
      <td>56</td>
      <td>0.017857</td>
      <td>[org.axonframework.modelling.command.ConcurrencyException]</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>org.axonframework.modelling.command</td>
      <td>1</td>
      <td>56</td>
      <td>0.017857</td>
      <td>[org.axonframework.modelling.command.ConcurrencyException]</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-modelling-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>100</td>
      <td>0.020000</td>
      <td>[org.axonframework.eventhandling.EventBus, org.axonframework.eventhandling.DomainEventSequenceAware]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-modelling-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.modelling.command</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>100</td>
      <td>0.020000</td>
      <td>[org.axonframework.eventhandling.EventBus, org.axonframework.eventhandling.DomainEventSequenceAware]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-test-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.test.eventscheduler</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>100</td>
      <td>0.020000</td>
      <td>[org.axonframework.eventhandling.EventMessage, org.axonframework.eventhandling.GenericEventMessage]</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventsourcing.conflictresolution</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>100</td>
      <td>0.020000</td>
      <td>[org.axonframework.eventhandling.EventMessage, org.axonframework.eventhandling.DomainEventMessage]</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.axonserver.connector.event.axon</td>
      <td>org.axonframework.eventsourcing</td>
      <td>1</td>
      <td>42</td>
      <td>0.023810</td>
      <td>[org.axonframework.eventsourcing.EventStreamUtils]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-configuration-4.10.3</td>
      <td>org.axonframework.springboot.autoconfig.legacyjpa</td>
      <td>org.axonframework.config</td>
      <td>1</td>
      <td>41</td>
      <td>0.024390</td>
      <td>[org.axonframework.config.Configuration]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-configuration-4.10.3</td>
      <td>org.axonframework.springboot</td>
      <td>org.axonframework.config</td>
      <td>1</td>
      <td>41</td>
      <td>0.024390</td>
      <td>[org.axonframework.config.TagsConfiguration]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-configuration-4.10.3</td>
      <td>org.axonframework.axonserver.connector.processor</td>
      <td>org.axonframework.config</td>
      <td>1</td>
      <td>41</td>
      <td>0.024390</td>
      <td>[org.axonframework.config.EventProcessingConfiguration]</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-test-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.Message]</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventsourcing.conflictresolution</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.Message]</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.StreamableMessageSource]</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-test-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.test</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.Message]</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-spring-boot-autoconfigure-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.springboot.autoconfig.legacyjpa</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore.legacyjpa</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc.statements</td>
      <td>org.axonframework.eventhandling</td>
      <td>3</td>
      <td>100</td>
      <td>0.030000</td>
      <td>[org.axonframework.eventhandling.GenericDomainEventMessage, org.axonframework.eventhandling.EventMessage, org.axonframework.eventhandling.DomainEventMessage]</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-test-4.10.3</td>
      <td>axon-modelling-4.10.3</td>
      <td>org.axonframework.test.utils</td>
      <td>org.axonframework.modelling.saga</td>
      <td>1</td>
      <td>33</td>
      <td>0.030303</td>
      <td>[org.axonframework.modelling.saga.SimpleResourceInjector]</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-eventsourcing-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.eventsourcing.conflictresolution</td>
      <td>org.axonframework.commandhandling</td>
      <td>1</td>
      <td>32</td>
      <td>0.031250</td>
      <td>[org.axonframework.commandhandling.CommandMessage]</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-test-4.10.3</td>
      <td>axon-messaging-4.10.3</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.axonframework.commandhandling</td>
      <td>1</td>
      <td>32</td>
      <td>0.031250</td>
      <td>[org.axonframework.commandhandling.CommandMessage]</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-server-connector-4.10.3</td>
      <td>axon-eventsourcing-4.10.3</td>
      <td>org.axonframework.axonserver.connector</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>1</td>
      <td>31</td>
      <td>0.032258</td>
      <td>[org.axonframework.eventsourcing.eventstore.EventStoreException]</td>
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
      <td>1617</td>
      <td>[org.axonframework.axonserver.connector.util.PriorityExecutorService.awaitTermination(1), org.axonframework.axonserver.connector.util.PriorityExecutorService.submit(0), org.axonframework.axonserver.connector.util.PriorityExecutorService.invokeAll(0), org.axonframework.axonserver.connector.util.P...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>java.lang.Deprecated</td>
      <td>Method</td>
      <td>132</td>
      <td>[org.axonframework.axonserver.connector.AxonServerConfiguration$FlowControlConfiguration.getInitialNrOfPermits, org.axonframework.axonserver.connector.AxonServerConfiguration$FlowControlConfiguration.setInitialNrOfPermits, org.axonframework.axonserver.connector.AxonServerConfiguration$Builder.se...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.springframework.context.annotation.Bean</td>
      <td>Method</td>
      <td>111</td>
      <td>[org.axonframework.springboot.autoconfig.InfraConfiguration.springSagaLookup, org.axonframework.springboot.autoconfig.InfraConfiguration.springAxonConfiguration, org.axonframework.springboot.autoconfig.InfraConfiguration.springAxonConfigurer, org.axonframework.springboot.autoconfig.InfraConfigur...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean</td>
      <td>Method</td>
      <td>78</td>
      <td>[org.axonframework.springboot.autoconfig.InfraConfiguration.springAxonConfiguration, org.axonframework.springboot.autoconfig.InfraConfiguration.springAxonConfigurer, org.axonframework.springboot.autoconfig.InfraConfiguration.resourceInjector, org.axonframework.springboot.autoconfig.MetricsAutoCo...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>java.lang.FunctionalInterface</td>
      <td>Interface</td>
      <td>65</td>
      <td>[org.axonframework.axonserver.connector.util.ExecutorServiceBuilder, org.axonframework.axonserver.connector.ErrorCode$ExceptionBuilder, org.axonframework.axonserver.connector.query.QueryPriorityCalculator, org.axonframework.axonserver.connector.ManagedChannelCustomizer, org.axonframework.axonser...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>javax.annotation.Nullable</td>
      <td>Parameter</td>
      <td>61</td>
      <td>[org.axonframework.commandhandling.GenericCommandResultMessage.&lt;init&gt;(0), org.axonframework.commandhandling.GenericCommandResultMessage.&lt;init&gt;(1), org.axonframework.commandhandling.MonitorAwareCallback.&lt;init&gt;(0), org.axonframework.deadline.GenericDeadlineMessage.asDeadlineMessage(1), org.axonfra...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>javax.annotation.Nonnull</td>
      <td>Method</td>
      <td>50</td>
      <td>[org.axonframework.axonserver.connector.util.PriorityExecutorService.shutdownNow, org.axonframework.axonserver.connector.util.PriorityExecutorService.submit, org.axonframework.axonserver.connector.util.PriorityExecutorService.invokeAll, org.axonframework.axonserver.connector.util.PriorityExecuto...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>java.lang.Deprecated</td>
      <td>Class</td>
      <td>43</td>
      <td>[org.axonframework.axonserver.connector.util.TokenAddingInterceptor, org.axonframework.axonserver.connector.util.GrpcBufferingInterceptor, org.axonframework.axonserver.connector.util.ResubscribableStreamObserver, org.axonframework.axonserver.connector.util.FlowControllingStreamObserver, org.axon...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>java.lang.annotation.Retention</td>
      <td>Annotation</td>
      <td>43</td>
      <td>[org.axonframework.config.ProcessingGroup, org.axonframework.commandhandling.CommandHandler, org.axonframework.commandhandling.RoutingKey, org.axonframework.commandhandling.gateway.Timeout, org.axonframework.common.Priority, org.axonframework.deadline.annotation.DeadlineHandler, org.axonframewor...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>java.lang.annotation.Target</td>
      <td>Annotation</td>
      <td>43</td>
      <td>[org.axonframework.config.ProcessingGroup, org.axonframework.commandhandling.CommandHandler, org.axonframework.commandhandling.RoutingKey, org.axonframework.commandhandling.gateway.Timeout, org.axonframework.common.Priority, org.axonframework.deadline.annotation.DeadlineHandler, org.axonframewor...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>javax.persistence.Basic</td>
      <td>Field</td>
      <td>39</td>
      <td>[org.axonframework.eventhandling.AbstractDomainEventEntry.type, org.axonframework.eventhandling.AbstractDomainEventEntry.aggregateIdentifier, org.axonframework.eventhandling.AbstractDomainEventEntry.sequenceNumber, org.axonframework.eventhandling.AbstractEventEntry.timeStamp, org.axonframework.e...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>jakarta.persistence.Basic</td>
      <td>Field</td>
      <td>33</td>
      <td>[org.axonframework.eventhandling.AbstractDomainEventEntry.type, org.axonframework.eventhandling.AbstractDomainEventEntry.aggregateIdentifier, org.axonframework.eventhandling.AbstractDomainEventEntry.sequenceNumber, org.axonframework.eventhandling.AbstractEventEntry.timeStamp, org.axonframework.e...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>com.fasterxml.jackson.annotation.JsonProperty</td>
      <td>Parameter</td>
      <td>32</td>
      <td>[org.axonframework.commandhandling.distributed.commandfilter.AndCommandMessageFilter.&lt;init&gt;(0), org.axonframework.commandhandling.distributed.commandfilter.AndCommandMessageFilter.&lt;init&gt;(1), org.axonframework.commandhandling.distributed.commandfilter.CommandNameFilter.&lt;init&gt;(0), org.axonframewor...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>java.lang.annotation.Documented</td>
      <td>Annotation</td>
      <td>23</td>
      <td>[org.axonframework.config.ProcessingGroup, org.axonframework.commandhandling.CommandHandler, org.axonframework.eventhandling.DisallowReplay, org.axonframework.eventhandling.EventHandler, org.axonframework.eventhandling.AllowReplay, org.axonframework.lifecycle.ShutdownHandler, org.axonframework.l...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.springframework.boot.autoconfigure.AutoConfiguration</td>
      <td>Class</td>
      <td>22</td>
      <td>[org.axonframework.springboot.autoconfig.AxonServerBusAutoConfiguration, org.axonframework.springboot.autoconfig.legacyjpa.JpaJavaxAutoConfiguration, org.axonframework.springboot.autoconfig.JpaAutoConfiguration, org.axonframework.springboot.autoconfig.legacyjpa.JpaJavaxEventStoreAutoConfiguratio...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>java.beans.ConstructorProperties</td>
      <td>Constructor</td>
      <td>21</td>
      <td>[org.axonframework.commandhandling.distributed.commandfilter.CommandNameFilter.&lt;init&gt;, org.axonframework.commandhandling.distributed.commandfilter.DenyCommandNameFilter.&lt;init&gt;, org.axonframework.commandhandling.distributed.commandfilter.AndCommandMessageFilter.&lt;init&gt;, org.axonframework.commandha...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.springframework.beans.factory.annotation.Qualifier</td>
      <td>Parameter</td>
      <td>20</td>
      <td>[org.axonframework.springboot.autoconfig.AxonServerBusAutoConfiguration.axonServerCommandBus(2), org.axonframework.springboot.autoconfig.AxonServerBusAutoConfiguration.axonServerCommandBus(3), org.axonframework.springboot.autoconfig.AxonServerBusAutoConfiguration.queryBus(4), org.axonframework.s...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>java.lang.Deprecated</td>
      <td>Constructor</td>
      <td>20</td>
      <td>[org.axonframework.axonserver.connector.query.subscription.AxonServerSubscriptionQueryResult.&lt;init&gt;, org.axonframework.axonserver.connector.processor.EventProcessorControlService.&lt;init&gt;, org.axonframework.commandhandling.callbacks.FailureLoggingCallback.&lt;init&gt;, org.axonframework.commandhandling....</td>
    </tr>
    <tr>
      <th>18</th>
      <td>com.fasterxml.jackson.annotation.JsonCreator</td>
      <td>Constructor</td>
      <td>16</td>
      <td>[org.axonframework.eventhandling.GapAwareTrackingToken.&lt;init&gt;, org.axonframework.eventhandling.GlobalSequenceTrackingToken.&lt;init&gt;, org.axonframework.eventhandling.MergedTrackingToken.&lt;init&gt;, org.axonframework.eventhandling.MultiSourceTrackingToken.&lt;init&gt;, org.axonframework.eventhandling.ReplayTo...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.springframework.boot.autoconfigure.AutoConfigureAfter</td>
      <td>Class</td>
      <td>16</td>
      <td>[org.axonframework.springboot.autoconfig.AxonServerBusAutoConfiguration, org.axonframework.springboot.autoconfig.legacyjpa.JpaJavaxAutoConfiguration, org.axonframework.springboot.autoconfig.JpaAutoConfiguration, org.axonframework.springboot.autoconfig.legacyjpa.JpaJavaxEventStoreAutoConfiguratio...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>org.springframework.boot.autoconfigure.condition.ConditionalOnProperty</td>
      <td>Method</td>
      <td>15</td>
      <td>[org.axonframework.springboot.autoconfig.MetricsAutoConfiguration.metricsConfigurerModule, org.axonframework.springboot.autoconfig.AxonServerBusAutoConfiguration.eventStore, org.axonframework.springboot.autoconfig.AxonServerBusAutoConfiguration.axonServerEventStoreFactory, org.axonframework.spri...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>org.springframework.boot.autoconfigure.AutoConfigureBefore</td>
      <td>Class</td>
      <td>14</td>
      <td>[org.axonframework.springboot.autoconfig.AxonServerBusAutoConfiguration, org.axonframework.springboot.autoconfig.legacyjpa.JpaJavaxAutoConfiguration, org.axonframework.springboot.autoconfig.legacyjpa.JpaJavaxEventStoreAutoConfiguration, org.axonframework.springboot.autoconfig.JpaEventStoreAutoCo...</td>
    </tr>
    <tr>
      <th>22</th>
      <td>javax.persistence.Column</td>
      <td>Field</td>
      <td>12</td>
      <td>[org.axonframework.eventhandling.AbstractEventEntry.eventIdentifier, org.axonframework.eventhandling.AbstractEventEntry.payload, org.axonframework.eventhandling.AbstractEventEntry.metaData, org.axonframework.eventhandling.deadletter.jpa.DeadLetterEntry.causeMessage, org.axonframework.eventhandli...</td>
    </tr>
    <tr>
      <th>23</th>
      <td>org.springframework.boot.autoconfigure.condition.ConditionalOnClass</td>
      <td>Class</td>
      <td>12</td>
      <td>[org.axonframework.springboot.autoconfig.AxonServerBusAutoConfiguration, org.axonframework.springboot.autoconfig.AxonServerAutoConfiguration$ConnectionDetailsConnectionManagerConfiguration, org.axonframework.springboot.autoconfig.MicrometerMetricsAutoConfiguration, org.axonframework.springboot.a...</td>
    </tr>
    <tr>
      <th>24</th>
      <td>jakarta.persistence.Column</td>
      <td>Field</td>
      <td>11</td>
      <td>[org.axonframework.eventhandling.AbstractEventEntry.eventIdentifier, org.axonframework.eventhandling.AbstractEventEntry.payload, org.axonframework.eventhandling.AbstractEventEntry.metaData, org.axonframework.eventhandling.deadletter.jpa.DeadLetterEntry.causeMessage, org.axonframework.eventhandli...</td>
    </tr>
    <tr>
      <th>25</th>
      <td>org.axonframework.common.Priority</td>
      <td>Class</td>
      <td>11</td>
      <td>[org.axonframework.config.ConfigurationParameterResolverFactory, org.axonframework.commandhandling.CurrentUnitOfWorkParameterResolverFactory, org.axonframework.eventhandling.SequenceNumberParameterResolverFactory, org.axonframework.eventhandling.TimestampParameterResolverFactory, org.axonframewo...</td>
    </tr>
    <tr>
      <th>26</th>
      <td>org.springframework.boot.context.properties.EnableConfigurationProperties</td>
      <td>Class</td>
      <td>11</td>
      <td>[org.axonframework.springboot.autoconfig.legacyjpa.JpaJavaxAutoConfiguration, org.axonframework.springboot.autoconfig.JpaAutoConfiguration, org.axonframework.springboot.autoconfig.MicrometerMetricsAutoConfiguration, org.axonframework.springboot.autoconfig.MetricsAutoConfiguration, org.axonframew...</td>
    </tr>
    <tr>
      <th>27</th>
      <td>javax.persistence.Id</td>
      <td>Field</td>
      <td>10</td>
      <td>[org.axonframework.eventhandling.AbstractSequencedDomainEventEntry.globalIndex, org.axonframework.eventhandling.deadletter.jpa.DeadLetterEntry.deadLetterId, org.axonframework.eventhandling.tokenstore.jpa.TokenEntry.processorName, org.axonframework.eventhandling.tokenstore.jpa.TokenEntry.segment,...</td>
    </tr>
    <tr>
      <th>28</th>
      <td>javax.persistence.Lob</td>
      <td>Field</td>
      <td>10</td>
      <td>[org.axonframework.eventhandling.AbstractEventEntry.payload, org.axonframework.eventhandling.AbstractEventEntry.metaData, org.axonframework.eventhandling.deadletter.jpa.DeadLetterEntry.diagnostics, org.axonframework.eventhandling.deadletter.jpa.DeadLetterEventEntry.payload, org.axonframework.eve...</td>
    </tr>
    <tr>
      <th>29</th>
      <td>org.springframework.boot.autoconfigure.condition.ConditionalOnBean</td>
      <td>Method</td>
      <td>10</td>
      <td>[org.axonframework.springboot.autoconfig.MetricsAutoConfiguration.globalMetricRegistry, org.axonframework.springboot.autoconfig.MetricsAutoConfiguration.metricsConfigurerModule, org.axonframework.springboot.autoconfig.legacyjpa.JpaJavaxAutoConfiguration.persistenceExceptionResolver, org.axonfram...</td>
    </tr>
  </tbody>
</table>
</div>



### Table 10 - Distance distribution between dependent files

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
      <td>2618</td>
      <td>1029</td>
      <td>1164</td>
      <td>[/axon-spring-boot-autoconfigure-4.10.3.jar uses /axon-server-connector-4.10.3.jar, /org/axonframework/axonserver/connector/command uses /org/axonframework/axonserver/connector/util, /org/axonframework/axonserver/connector/query uses /org/axonframework/axonserver/connector/util, /org/axonframewo...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>90</td>
      <td>82</td>
      <td>38</td>
      <td>[/org/axonframework/axonserver/connector/heartbeat uses /org/axonframework/axonserver/connector, /org/axonframework/axonserver/connector/command uses /org/axonframework/axonserver/connector, /org/axonframework/axonserver/connector/query uses /org/axonframework/axonserver/connector, /org/axonfram...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>2503</td>
      <td>760</td>
      <td>472</td>
      <td>[/org/axonframework/axonserver/connector/event/axon uses /org/axonframework/axonserver/connector, /org/axonframework/axonserver/connector/heartbeat/source uses /org/axonframework/axonserver/connector, /org/axonframework/axonserver/connector/query/subscription uses /org/axonframework/axonserver/c...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>2594</td>
      <td>449</td>
      <td>540</td>
      <td>[/org/axonframework/springboot/service/connection uses /org/axonframework/axonserver/connector, /org/axonframework/springboot/autoconfig uses /org/axonframework/axonserver/connector, /org/axonframework/actuator/axonserver uses /org/axonframework/axonserver/connector, /org/axonframework/springboo...</td>
    </tr>
  </tbody>
</table>
</div>


