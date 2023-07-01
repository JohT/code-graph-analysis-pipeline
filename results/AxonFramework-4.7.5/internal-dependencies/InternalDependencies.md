# Package Dependencies for Java with Neo4j
<br>  

### References
- [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html)
- [Calculate metrics](https://101.jqassistant.org/calculate-metrics/index.html)
- [py2neo](https://py2neo.org/2021.1/)





## Artifacts

### Table 1

- List all the artifacts this notebook is based on




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>packages</th>
      <th>types</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-eventsourcing-4.7.5.jar</td>
      <td>9</td>
      <td>130</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.7.5.jar</td>
      <td>10</td>
      <td>149</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-configuration-4.7.5.jar</td>
      <td>1</td>
      <td>39</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.7.5.jar</td>
      <td>61</td>
      <td>729</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.7.5.jar</td>
      <td>1</td>
      <td>22</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-test-4.7.5.jar</td>
      <td>8</td>
      <td>85</td>
    </tr>
  </tbody>
</table>
</div>



## Cyclic Dependencies

Cyclic dependencies occur when one package uses a class of another package and vice versa. 
These dependencies can lead to a lot of trouble when one of these packages needs to be changed.

### Table 2
- List packages with cyclic dependencies




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>packageName</th>
      <th>dependentPackageName</th>
      <th>forwardToBackwardBalance</th>
      <th>numberForward</th>
      <th>numberBackward</th>
      <th>forwardDependencies</th>
      <th>backwardDependencies</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
      <td>[QueryMessage-&gt;ResponseType, SimpleQueryUpdate...</td>
      <td>[ConvertingResponseMessage-&gt;QueryResponseMessage]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
      <td>[TrackingEventProcessor-&gt;Span, TrackingEventPr...</td>
      <td>[NestingSpanFactory-&gt;EventMessage]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
      <td>[SubscribingEventProcessor-&gt;SubscribableMessag...</td>
      <td>[Headers-&gt;EventMessage, Headers-&gt;DomainEventMe...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>0.840000</td>
      <td>23</td>
      <td>2</td>
      <td>[AllowReplay-&gt;HasHandlerAttributes, TimestampP...</td>
      <td>[SourceIdParameterResolverFactory$SourceIdPara...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.tracing</td>
      <td>0.800000</td>
      <td>9</td>
      <td>1</td>
      <td>[SimpleQueryUpdateEmitter-&gt;Span, SimpleQueryUp...</td>
      <td>[SpanUtils-&gt;QueryMessage]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.eventsourcing</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>0.777778</td>
      <td>16</td>
      <td>2</td>
      <td>[AbstractSnapshotter$Builder-&gt;EventStore, Aggr...</td>
      <td>[DomainEventStream-&gt;EventStreamUtils, Abstract...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.deadline</td>
      <td>org.axonframework.tracing</td>
      <td>0.750000</td>
      <td>7</td>
      <td>1</td>
      <td>[SimpleDeadlineManager-&gt;Span, SimpleDeadlineMa...</td>
      <td>[SpanUtils-&gt;DeadlineMessage]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>org.axonframework.commandhandling</td>
      <td>0.733333</td>
      <td>13</td>
      <td>2</td>
      <td>[NoOpCallback-&gt;CommandMessage, NoOpCallback-&gt;C...</td>
      <td>[SimpleCommandBus$Builder-&gt;NoOpCallback, Simpl...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.commandhandling</td>
      <td>org.axonframework.tracing</td>
      <td>0.666667</td>
      <td>5</td>
      <td>1</td>
      <td>[SimpleCommandBus$Builder-&gt;SpanFactory, Simple...</td>
      <td>[SpanUtils-&gt;CommandMessage]</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.serialization</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
      <td>[GenericEventMessage-&gt;CachingSupplier, Tracked...</td>
      <td>[AbstractXStreamSerializer-&gt;GenericEventMessag...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>org.axonframework.messaging</td>
      <td>0.647059</td>
      <td>14</td>
      <td>3</td>
      <td>[MessageProcessingContext-&gt;Message, BatchingUn...</td>
      <td>[GenericMessage-&gt;CurrentUnitOfWork, MessageHan...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.eventhandling.async</td>
      <td>org.axonframework.eventhandling</td>
      <td>0.538462</td>
      <td>10</td>
      <td>3</td>
      <td>[PropertySequencingPolicy$Builder-&gt;EventMessag...</td>
      <td>[SimpleEventHandlerInvoker$Builder-&gt;Sequential...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.eventhandling.replay</td>
      <td>org.axonframework.eventhandling</td>
      <td>0.454545</td>
      <td>8</td>
      <td>3</td>
      <td>[ReplayParameterResolverFactory-&gt;ReplayStatus,...</td>
      <td>[ResetHandler-&gt;ResetContext, AnnotationEventHa...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.serialization.upcasting.event</td>
      <td>org.axonframework.eventhandling</td>
      <td>0.333333</td>
      <td>6</td>
      <td>3</td>
      <td>[InitialEventRepresentation-&gt;DomainEventData, ...</td>
      <td>[EventUtils-&gt;EventUpcaster, EventUtils-&gt;Initia...</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>0.317073</td>
      <td>27</td>
      <td>14</td>
      <td>[JdbcEventStorageEngine-&gt;AppendSnapshotStateme...</td>
      <td>[CleanGapsStatementBuilder-&gt;EventSchema, Creat...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>org.axonframework.modelling.command</td>
      <td>0.250000</td>
      <td>20</td>
      <td>12</td>
      <td>[AggregateMemberAnnotatedChildEntityCollection...</td>
      <td>[ForwardingMode-&gt;EntityModel, ForwardMatchingI...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.queryhandling.registration</td>
      <td>org.axonframework.queryhandling</td>
      <td>0.250000</td>
      <td>5</td>
      <td>3</td>
      <td>[DuplicateQueryHandlerResolution-&gt;QuerySubscri...</td>
      <td>[SimpleQueryBus$Builder-&gt;DuplicateQueryHandler...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.messaging</td>
      <td>org.axonframework.serialization</td>
      <td>0.238095</td>
      <td>13</td>
      <td>8</td>
      <td>[GenericResultMessage-&gt;Serializer, GenericResu...</td>
      <td>[SerializedMessage-&gt;GenericMessage, Serialized...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.eventhandling.tokenstore</td>
      <td>0.230769</td>
      <td>8</td>
      <td>5</td>
      <td>[TrackingEventProcessor-&gt;TokenStore, TrackingE...</td>
      <td>[TokenStore-&gt;Segment, TokenStore-&gt;TrackingToke...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.messaging.annotation</td>
      <td>org.axonframework.messaging.interceptors</td>
      <td>0.200000</td>
      <td>3</td>
      <td>2</td>
      <td>[MessageHandlerInterceptorDefinition-&gt;MessageH...</td>
      <td>[ResultHandler-&gt;HasHandlerAttributes, MessageH...</td>
    </tr>
    <tr>
      <th>20</th>
      <td>org.axonframework.modelling.saga</td>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>0.142857</td>
      <td>4</td>
      <td>3</td>
      <td>[AnnotatedSagaManager$Builder-&gt;AnnotationSagaM...</td>
      <td>[SagaModel-&gt;AssociationValue, AnnotationSagaMe...</td>
    </tr>
    <tr>
      <th>21</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>0.076923</td>
      <td>7</td>
      <td>6</td>
      <td>[OrCommandMessageFilter-&gt;CommandMessageFilter,...</td>
      <td>[CommandMessageFilter-&gt;OrCommandMessageFilter,...</td>
    </tr>
  </tbody>
</table>
</div>



### Table 3
- List packages with cyclic dependencies with every dependency in a separate row sorted by the easiest and most valuable to resolve




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>packageName</th>
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
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryResponseMessage&lt;-ConvertingResponseMessage</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;OptionalResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;MultipleInstancesRes...</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;PublisherResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryUpdateEmitter-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericSubscriptionQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericStreamingQueryMessage-&gt;PublisherRespons...</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericStreamingQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>GenericQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>StreamingQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>DefaultQueryGateway-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SubscriptionQueryMessage-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryGateway-&gt;ResponseTypes</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QueryGateway-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>SimpleQueryBus-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.queryhandling</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>QuerySubscription-&gt;ResponseType</td>
      <td>0.882353</td>
      <td>16</td>
      <td>1</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>EventMessage&lt;-NestingSpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>TrackingEventProcessor-&gt;Span</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>TrackingEventProcessor-&gt;SpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>20</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor$Builder-&gt;NoOpSpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>21</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor$Builder-&gt;SpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>22</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>SubscribingEventProcessor$Builder-&gt;SpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>23</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor-&gt;Span</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>24</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventProcessor-&gt;SpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>25</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>SimpleEventBus$Builder-&gt;SpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>26</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>TrackingEventProcessor$Builder-&gt;SpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>27</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus$Builder-&gt;NoOpSpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>28</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus$Builder-&gt;SpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>29</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus-&gt;Span</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>30</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.tracing</td>
      <td>AbstractEventBus-&gt;SpanFactory</td>
      <td>0.857143</td>
      <td>13</td>
      <td>1</td>
    </tr>
    <tr>
      <th>31</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>EventMessage&lt;-Headers</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>32</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>DomainEventMessage&lt;-Headers</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>33</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>TrackingToken&lt;-StreamableMessageSource</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>34</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>SubscribingEventProcessor-&gt;SubscribableMessage...</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>35</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>EventMessage-&gt;Message</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>36</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>GenericEventMessage-&gt;MetaData</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>37</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>GenericEventMessage-&gt;MessageDecorator</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>38</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>GenericEventMessage-&gt;GenericMessage</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>39</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>GenericEventMessage-&gt;Message</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>40</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>TrackingEventProcessor-&gt;StreamableMessageSource</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>41</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>TrackingEventProcessor-&gt;InterceptorChain</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>42</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>TrackingEventProcessor-&gt;Message</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>43</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>GenericTrackedDomainEventMessage-&gt;Message</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>44</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>SequenceNumberParameterResolverFactory$Sequenc...</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>45</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>MultiStreamableMessageSource-&gt;StreamableMessag...</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>46</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>SubscribingEventProcessor$Builder-&gt;Subscribabl...</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>47</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>GenericDomainEventMessage-&gt;MetaData</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>48</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>GenericDomainEventMessage-&gt;GenericMessage</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>49</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>GenericDomainEventMessage-&gt;Message</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>50</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>ConcludesBatchParameterResolverFactory-&gt;Message</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>51</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>DomainEventMessage-&gt;Message</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>52</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>MultiStreamableMessageSource$Builder-&gt;Streamab...</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>53</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>StreamingEventProcessor-&gt;StreamableMessageSource</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>54</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>AnnotationEventHandlerAdapter-&gt;Message</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>55</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>AbstractEventProcessor-&gt;DefaultInterceptorChain</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>56</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>AbstractEventProcessor-&gt;ResultMessage</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>57</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>AbstractEventProcessor-&gt;MessageHandlerInterceptor</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>58</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>EventBus-&gt;SubscribableMessageSource</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
    </tr>
    <tr>
      <th>59</th>
      <td>org.axonframework.eventhandling</td>
      <td>org.axonframework.messaging</td>
      <td>EventBus-&gt;MessageDispatchInterceptorSupport</td>
      <td>0.853659</td>
      <td>38</td>
      <td>3</td>
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

### Table 3
- List top 20 most used combinations of methods of larger Types that might benefit from *Interface Segregation*




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>dependentType.fqn</th>
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
      <td>[getIdentifier, getTimestamp]</td>
      <td>2</td>
      <td>8</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>9</td>
      <td>[getIdentifier]</td>
      <td>1</td>
      <td>8</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventhandling.TrackedEventMe...</td>
      <td>10</td>
      <td>[trackingToken]</td>
      <td>1</td>
      <td>7</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>10</td>
      <td>[getType, getAggregateIdentifier, getSequenceN...</td>
      <td>3</td>
      <td>5</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.messaging.ResultMessage</td>
      <td>9</td>
      <td>[exceptionResult, isExceptional]</td>
      <td>2</td>
      <td>5</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.commandhandling.GenericComma...</td>
      <td>15</td>
      <td>[asCommandResultMessage]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.commandhandling.GenericComma...</td>
      <td>14</td>
      <td>[asCommandResultMessage]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.eventhandling.TrackedEventMe...</td>
      <td>12</td>
      <td>[trackingToken]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.deadline.GenericDeadlineMessage</td>
      <td>11</td>
      <td>[asDeadlineMessage]</td>
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
      <td>[getType]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>10</td>
      <td>[getAggregateIdentifier]</td>
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
      <td>org.axonframework.common.transaction.NoTransac...</td>
      <td>4</td>
      <td>[instance]</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.modelling.command.inspection...</td>
      <td>13</td>
      <td>[type]</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>11</td>
      <td>[getType, getAggregateIdentifier, getSequenceN...</td>
      <td>3</td>
      <td>3</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>10</td>
      <td>[getAggregateIdentifier, getSequenceNumber]</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.eventhandling.GapAwareTracki...</td>
      <td>10</td>
      <td>[getGaps, withGapsTruncatedAt, advanceTo, getI...</td>
      <td>5</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



## Package Usage

### Types that are used by multiple packages

#### Table 4
- List the top 20 packages that are used by the highest count of different packages 




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>dependentType.fqn</th>
      <th>dependentType.name</th>
      <th>dependentTypeLabels</th>
      <th>numberOfUsingPackages</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.common.BuilderUtils</td>
      <td>BuilderUtils</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>41</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.messaging.Message</td>
      <td>Message</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>36</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.common.AxonConfigurationExce...</td>
      <td>AxonConfigurationException</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>35</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.eventhandling.EventMessage</td>
      <td>EventMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>30</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.messaging.MetaData</td>
      <td>MetaData</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>30</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.messaging.unitofwork.UnitOfWork</td>
      <td>UnitOfWork</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>29</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.common.Assert</td>
      <td>Assert</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>26</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.serialization.Serializer</td>
      <td>Serializer</td>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>26</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.common.transaction.Transacti...</td>
      <td>TransactionManager</td>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>23</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.serialization.SerializedObject</td>
      <td>SerializedObject</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>22</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.messaging.unitofwork.Current...</td>
      <td>CurrentUnitOfWork</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>21</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.serialization.SerializedType</td>
      <td>SerializedType</td>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>21</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.common.AxonNonTransientExcep...</td>
      <td>AxonNonTransientException</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>18</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.messaging.annotation.Paramet...</td>
      <td>ParameterResolverFactory</td>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>18</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.eventhandling.DomainEventMes...</td>
      <td>DomainEventMessage</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>17</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.eventhandling.TrackingToken</td>
      <td>TrackingToken</td>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>17</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.common.Registration</td>
      <td>Registration</td>
      <td>[Type, File, Java, ByteCode, Interface]</td>
      <td>16</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.eventhandling.GenericEventMe...</td>
      <td>GenericEventMessage</td>
      <td>[Type, File, Java, ByteCode, Class, GenericDec...</td>
      <td>16</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.common.ObjectUtils</td>
      <td>ObjectUtils</td>
      <td>[Type, File, Java, ByteCode, Class]</td>
      <td>15</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.messaging.MessageHandlerInte...</td>
      <td>MessageHandlerInterceptor</td>
      <td>[Type, File, Java, ByteCode, GenericDeclaratio...</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>



### Packages that are used by multiple artifacts

#### Table 5
- List the top 20 artifacts that only use a few (compared to all existing) packages of another artifact




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
      <td>axon-disruptor-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>9</td>
      <td>61</td>
      <td>0.147541</td>
      <td>[org.axonframework.monitoring, org.axonframewo...</td>
      <td>[monitoring, commandhandling, caching, unitofw...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-test-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>10</td>
      <td>61</td>
      <td>0.163934</td>
      <td>[org.axonframework.eventhandling.scheduling, o...</td>
      <td>[scheduling, eventhandling, common, annotation...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-modelling-4.7.5</td>
      <td>2</td>
      <td>10</td>
      <td>0.200000</td>
      <td>[org.axonframework.modelling.command, org.axon...</td>
      <td>[command, inspection]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-disruptor-4.7.5</td>
      <td>axon-modelling-4.7.5</td>
      <td>2</td>
      <td>10</td>
      <td>0.200000</td>
      <td>[org.axonframework.modelling.command, org.axon...</td>
      <td>[command, inspection]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-disruptor-4.7.5</td>
      <td>axon-eventsourcing-4.7.5</td>
      <td>2</td>
      <td>9</td>
      <td>0.222222</td>
      <td>[org.axonframework.eventsourcing, org.axonfram...</td>
      <td>[eventsourcing, eventstore]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-test-4.7.5</td>
      <td>axon-eventsourcing-4.7.5</td>
      <td>2</td>
      <td>9</td>
      <td>0.222222</td>
      <td>[org.axonframework.eventsourcing.eventstore, o...</td>
      <td>[eventstore, eventsourcing]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-modelling-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>18</td>
      <td>61</td>
      <td>0.295082</td>
      <td>[org.axonframework.messaging.annotation, org.a...</td>
      <td>[annotation, legacyjpa, common, tracing, event...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>20</td>
      <td>61</td>
      <td>0.327869</td>
      <td>[org.axonframework.messaging.annotation, org.a...</td>
      <td>[annotation, common, messaging, eventhandling,...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-configuration-4.7.5</td>
      <td>axon-eventsourcing-4.7.5</td>
      <td>4</td>
      <td>9</td>
      <td>0.444444</td>
      <td>[org.axonframework.eventsourcing.eventstore.jp...</td>
      <td>[jpa, eventstore, eventsourcing, snapshotting]</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-test-4.7.5</td>
      <td>axon-modelling-4.7.5</td>
      <td>5</td>
      <td>10</td>
      <td>0.500000</td>
      <td>[org.axonframework.modelling.saga, org.axonfra...</td>
      <td>[saga, repository, inmemory, inspection, command]</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-configuration-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>34</td>
      <td>61</td>
      <td>0.557377</td>
      <td>[org.axonframework.eventhandling.tokenstore, o...</td>
      <td>[tokenstore, lock, caching, gateway, deadlette...</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-modelling-4.7.5</td>
      <td>axon-modelling-4.7.5</td>
      <td>6</td>
      <td>10</td>
      <td>0.600000</td>
      <td>[org.axonframework.modelling.command.inspectio...</td>
      <td>[inspection, command, repository, saga, jpa, m...</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-configuration-4.7.5</td>
      <td>axon-modelling-4.7.5</td>
      <td>6</td>
      <td>10</td>
      <td>0.600000</td>
      <td>[org.axonframework.modelling.saga.repository, ...</td>
      <td>[repository, jpa, saga, inspection, inmemory, ...</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-test-4.7.5</td>
      <td>axon-test-4.7.5</td>
      <td>5</td>
      <td>8</td>
      <td>0.625000</td>
      <td>[org.axonframework.test, org.axonframework.tes...</td>
      <td>[test, utils, matchers, deadline, eventscheduler]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>40</td>
      <td>61</td>
      <td>0.655738</td>
      <td>[org.axonframework.messaging.annotation, org.a...</td>
      <td>[annotation, messaging, common, unitofwork, re...</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-eventsourcing-4.7.5</td>
      <td>7</td>
      <td>9</td>
      <td>0.777778</td>
      <td>[org.axonframework.eventsourcing.eventstore, o...</td>
      <td>[eventstore, snapshotting, jpa, conflictresolu...</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-configuration-4.7.5</td>
      <td>axon-disruptor-4.7.5</td>
      <td>1</td>
      <td>1</td>
      <td>1.000000</td>
      <td>[org.axonframework.disruptor.commandhandling]</td>
      <td>[commandhandling]</td>
    </tr>
  </tbody>
</table>
</div>



### Packages that are used by multiple artifacts

#### Table 6
- List the top 20 packages that only use a few (compared to all existing) types of another package 




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
      <td>axon-test-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>93</td>
      <td>0.010753</td>
      <td>[org.axonframework.eventhandling.EventMessage]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-modelling-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>93</td>
      <td>0.010753</td>
      <td>[org.axonframework.eventhandling.EventMessage]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventsourcing.snapshotting</td>
      <td>org.axonframework.eventhandling</td>
      <td>1</td>
      <td>93</td>
      <td>0.010753</td>
      <td>[org.axonframework.eventhandling.DomainEventData]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-modelling-4.7.5</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.modelling.command</td>
      <td>1</td>
      <td>51</td>
      <td>0.019608</td>
      <td>[org.axonframework.modelling.command.Conflicti...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-modelling-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>org.axonframework.modelling.command</td>
      <td>1</td>
      <td>51</td>
      <td>0.019608</td>
      <td>[org.axonframework.modelling.command.Concurren...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-modelling-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>93</td>
      <td>0.021505</td>
      <td>[org.axonframework.eventhandling.DomainEventSe...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-modelling-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.modelling.command</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>93</td>
      <td>0.021505</td>
      <td>[org.axonframework.eventhandling.DomainEventSe...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-test-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.test.eventscheduler</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>93</td>
      <td>0.021505</td>
      <td>[org.axonframework.eventhandling.EventMessage,...</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.eventhandling</td>
      <td>2</td>
      <td>93</td>
      <td>0.021505</td>
      <td>[org.axonframework.eventhandling.EventMessage,...</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.StreamableMessage...</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-test-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.Message]</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-test-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.test</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.Message]</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.messaging</td>
      <td>1</td>
      <td>35</td>
      <td>0.028571</td>
      <td>[org.axonframework.messaging.Message]</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>org.axonframework.serialization</td>
      <td>1</td>
      <td>34</td>
      <td>0.029412</td>
      <td>[org.axonframework.serialization.Serializer]</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>org.axonframework.eventhandling</td>
      <td>3</td>
      <td>93</td>
      <td>0.032258</td>
      <td>[org.axonframework.eventhandling.EventMessage,...</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-test-4.7.5</td>
      <td>axon-modelling-4.7.5</td>
      <td>org.axonframework.test.utils</td>
      <td>org.axonframework.modelling.saga</td>
      <td>1</td>
      <td>30</td>
      <td>0.033333</td>
      <td>[org.axonframework.modelling.saga.SimpleResour...</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-test-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.test.matchers</td>
      <td>org.axonframework.commandhandling</td>
      <td>1</td>
      <td>29</td>
      <td>0.034483</td>
      <td>[org.axonframework.commandhandling.CommandMess...</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>org.axonframework.commandhandling</td>
      <td>1</td>
      <td>29</td>
      <td>0.034483</td>
      <td>[org.axonframework.commandhandling.CommandMess...</td>
    </tr>
  </tbody>
</table>
</div>


