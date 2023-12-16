# Visibility Metrics
<br>  

### References
- [Visibility Metrics and the Importance of Hiding Things](https://dzone.com/articles/visibility-metrics-and-the-importance-of-hiding-th)
- [Calculate metrics](https://101.jqassistant.org/calculate-metrics/index.html)
- [Controlling Access to Members of a Class](https://docs.oracle.com/javase/tutorial/java/javaOO/accesscontrol.html)
- [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver/current)









## Relative Visibility Of Types

A Java class or interface may be declared with the modifier public, in which case it is visible to all classes everywhere. If a class or interface has no modifier (the default, also known as package-private), it is visible only within its own package.

The relative visibility is the number of inner components that are visible outside (public) divided by the number of all types:

$$ relative visibility = \frac{public\:types}{all\:types} $$

Using package protected types is one of many ways to improve encapsulation and implementation detail hiding.

### How to apply the results

The relative visibility is between zero (all types are package protected) and one (all types are public). A value lower than one means that there are types that are declared package protected. The lower the value is, the better implementation details are hidden. 

Non public classes can't be accessed from another package so they can be changed without affecting code in other packages. They clearly indicate functionality that only belongs to one package. This also motivates to use more classes and to split up code into smaller pieces with a single responsibility and reason to change.

### Table 1a - Top 40 artifacts with lowest median of package protection encapsulation

This table shows the relative visibility statistics aggregated for all packages per artifact and focusses on artifacts with many packages and hardly any package protected types (lowest median, high visibility). Package protected types would help to  improve encapsulation.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Global_relative_visibility_statistics_for_types`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifact</th>
      <th>all</th>
      <th>public</th>
      <th>min</th>
      <th>max</th>
      <th>average</th>
      <th>percentile25</th>
      <th>percentile50</th>
      <th>percentile75</th>
      <th>percentile90</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.6.8</td>
      <td>700</td>
      <td>567</td>
      <td>0.100000</td>
      <td>1.000000</td>
      <td>0.849854</td>
      <td>0.726381</td>
      <td>0.914286</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-test-4.6.8</td>
      <td>85</td>
      <td>64</td>
      <td>0.473684</td>
      <td>1.000000</td>
      <td>0.812336</td>
      <td>0.650000</td>
      <td>0.879167</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>120</td>
      <td>90</td>
      <td>0.500000</td>
      <td>1.000000</td>
      <td>0.802803</td>
      <td>0.653226</td>
      <td>0.821429</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-modelling-4.6.8</td>
      <td>144</td>
      <td>124</td>
      <td>0.500000</td>
      <td>1.000000</td>
      <td>0.797619</td>
      <td>0.745833</td>
      <td>0.813187</td>
      <td>0.883987</td>
      <td>0.922222</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.6.8</td>
      <td>39</td>
      <td>26</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-disruptor-4.6.8</td>
      <td>22</td>
      <td>9</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1b - Top 40 artifacts with highest median of package protection encapsulation

This table shows the relative visibility statistics aggregated for all packages per artifact and focusses on artifacts with many packages and the highest median of package protected types (low visibility). Package protected types help to improve encapsulation.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Global_relative_visibility_statistics_for_types`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifact</th>
      <th>all</th>
      <th>public</th>
      <th>min</th>
      <th>max</th>
      <th>average</th>
      <th>percentile25</th>
      <th>percentile50</th>
      <th>percentile75</th>
      <th>percentile90</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-disruptor-4.6.8</td>
      <td>22</td>
      <td>9</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
      <td>0.409091</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.6.8</td>
      <td>39</td>
      <td>26</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.666667</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-modelling-4.6.8</td>
      <td>144</td>
      <td>124</td>
      <td>0.500000</td>
      <td>1.000000</td>
      <td>0.797619</td>
      <td>0.745833</td>
      <td>0.813187</td>
      <td>0.883987</td>
      <td>0.922222</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>120</td>
      <td>90</td>
      <td>0.500000</td>
      <td>1.000000</td>
      <td>0.802803</td>
      <td>0.653226</td>
      <td>0.821429</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-test-4.6.8</td>
      <td>85</td>
      <td>64</td>
      <td>0.473684</td>
      <td>1.000000</td>
      <td>0.812336</td>
      <td>0.650000</td>
      <td>0.879167</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.6.8</td>
      <td>700</td>
      <td>567</td>
      <td>0.100000</td>
      <td>1.000000</td>
      <td>0.849854</td>
      <td>0.726381</td>
      <td>0.914286</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Table 1 Chart 1 - Relative visibility in artifacts

    /opt/homebrew/Caskroom/miniforge/base/envs/codegraph/lib/python3.11/site-packages/pandas/plotting/_matplotlib/core.py:1259: UserWarning: No data for colormapping provided via 'c'. Parameters 'cmap' will be ignored
      scatter = ax.scatter(



    <Figure size 640x480 with 0 Axes>



    
![png](VisibilityMetrics_files/VisibilityMetrics_17_2.png)
    


### Table 2a - Top 40 packages with the highest visibility and lowest encapsulation

This table shows the relative visibility statistics per packages and artifact and focusses on packages with many types, hardly any package protected ones and therefore the highest relative visibility (lowest encapsulation). Package protected types would help to improve encapsulation.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Relative_visibility_public_types_to_all_types_per_package`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>fullQualifiedPackageName</th>
      <th>packageName</th>
      <th>publicTypes</th>
      <th>allTypes</th>
      <th>relativeVisibility</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-modelling-4.6.8</td>
      <td>org.axonframework.modelling.saga</td>
      <td>saga</td>
      <td>30</td>
      <td>30</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.messaging.deadletter</td>
      <td>deadletter</td>
      <td>17</td>
      <td>17</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>statements</td>
      <td>15</td>
      <td>15</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.serialization.upcasting.event</td>
      <td>event</td>
      <td>12</td>
      <td>12</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.lifecycle</td>
      <td>lifecycle</td>
      <td>10</td>
      <td>10</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>org.axonframework.eventsourcing.conflictresolu...</td>
      <td>conflictresolution</td>
      <td>9</td>
      <td>9</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.property</td>
      <td>property</td>
      <td>9</td>
      <td>9</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.messaging.interceptors</td>
      <td>interceptors</td>
      <td>8</td>
      <td>8</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.messaging.responsetypes</td>
      <td>responsetypes</td>
      <td>8</td>
      <td>8</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>7</td>
      <td>7</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.serialization.json</td>
      <td>json</td>
      <td>7</td>
      <td>7</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.tokenstore</td>
      <td>tokenstore</td>
      <td>7</td>
      <td>7</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.serialization.xml</td>
      <td>xml</td>
      <td>7</td>
      <td>7</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.tracing.attributes</td>
      <td>attributes</td>
      <td>6</td>
      <td>6</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.scheduling.quartz</td>
      <td>quartz</td>
      <td>6</td>
      <td>6</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.serialization.upcasting</td>
      <td>upcasting</td>
      <td>6</td>
      <td>6</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.serialization.converters</td>
      <td>converters</td>
      <td>5</td>
      <td>5</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.gateway</td>
      <td>gateway</td>
      <td>5</td>
      <td>5</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.queryhandling.registration</td>
      <td>registration</td>
      <td>5</td>
      <td>5</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-test-4.6.8</td>
      <td>org.axonframework.test.eventscheduler</td>
      <td>eventscheduler</td>
      <td>5</td>
      <td>5</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>4</td>
      <td>4</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.messaging.correlation</td>
      <td>correlation</td>
      <td>4</td>
      <td>4</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.jpa</td>
      <td>jpa</td>
      <td>4</td>
      <td>4</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.tokenstore.jpa</td>
      <td>jpa</td>
      <td>4</td>
      <td>4</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.deadline.quartz</td>
      <td>quartz</td>
      <td>4</td>
      <td>4</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-test-4.6.8</td>
      <td>org.axonframework.test.deadline</td>
      <td>deadline</td>
      <td>4</td>
      <td>4</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>org.axonframework.eventsourcing.snapshotting</td>
      <td>snapshotting</td>
      <td>3</td>
      <td>3</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.scheduling</td>
      <td>scheduling</td>
      <td>3</td>
      <td>3</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.util</td>
      <td>util</td>
      <td>3</td>
      <td>3</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-test-4.6.8</td>
      <td>org.axonframework.test.server</td>
      <td>server</td>
      <td>2</td>
      <td>2</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.digest</td>
      <td>digest</td>
      <td>1</td>
      <td>1</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.interceptors</td>
      <td>interceptors</td>
      <td>1</td>
      <td>1</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.io</td>
      <td>io</td>
      <td>1</td>
      <td>1</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-test-4.6.8</td>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>23</td>
      <td>24</td>
      <td>0.958333</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>distributed</td>
      <td>24</td>
      <td>26</td>
      <td>0.923077</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.messaging</td>
      <td>messaging</td>
      <td>32</td>
      <td>35</td>
      <td>0.914286</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>26</td>
      <td>29</td>
      <td>0.896552</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.tokenstore.jdbc</td>
      <td>jdbc</td>
      <td>8</td>
      <td>9</td>
      <td>0.888889</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.deadletter.jpa</td>
      <td>jpa</td>
      <td>8</td>
      <td>9</td>
      <td>0.888889</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-modelling-4.6.8</td>
      <td>org.axonframework.modelling.saga.repository.jdbc</td>
      <td>jdbc</td>
      <td>8</td>
      <td>9</td>
      <td>0.888889</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2b - Top 40 packages with the lowest visibility and highest encapsulation

This table shows the relative visibility statistics per packages and artifact and focusses on packages with many types, many package protected ones and therefore the lowest relative visibility (highest encapsulation). Package protected types help to improve encapsulation. Zero percent visibility and therefore packages with no public visible type are suspicious to be dead code.

Only the top 40 entries are shown. The whole table can be found in the following CSV report:  
`Relative_visibility_public_types_to_all_types_per_package`




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>fullQualifiedPackageName</th>
      <th>packageName</th>
      <th>publicTypes</th>
      <th>allTypes</th>
      <th>relativeVisibility</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.pooled</td>
      <td>pooled</td>
      <td>2</td>
      <td>20</td>
      <td>0.100000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.6.8</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>9</td>
      <td>22</td>
      <td>0.409091</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-test-4.6.8</td>
      <td>org.axonframework.test.aggregate</td>
      <td>aggregate</td>
      <td>9</td>
      <td>19</td>
      <td>0.473684</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.deadletter</td>
      <td>deadletter</td>
      <td>2</td>
      <td>4</td>
      <td>0.500000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>1</td>
      <td>2</td>
      <td>0.500000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.tokenstore.inm...</td>
      <td>inmemory</td>
      <td>1</td>
      <td>2</td>
      <td>0.500000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-modelling-4.6.8</td>
      <td>org.axonframework.modelling.saga.repository.in...</td>
      <td>inmemory</td>
      <td>1</td>
      <td>2</td>
      <td>0.500000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>gateway</td>
      <td>19</td>
      <td>36</td>
      <td>0.527778</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.async</td>
      <td>async</td>
      <td>9</td>
      <td>15</td>
      <td>0.600000</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.replay</td>
      <td>replay</td>
      <td>6</td>
      <td>10</td>
      <td>0.600000</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.deadline.annotation</td>
      <td>annotation</td>
      <td>3</td>
      <td>5</td>
      <td>0.600000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-test-4.6.8</td>
      <td>org.axonframework.test</td>
      <td>test</td>
      <td>3</td>
      <td>5</td>
      <td>0.600000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>eventstore</td>
      <td>19</td>
      <td>31</td>
      <td>0.612903</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-configuration-4.6.8</td>
      <td>org.axonframework.config</td>
      <td>config</td>
      <td>26</td>
      <td>39</td>
      <td>0.666667</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>org.axonframework.eventsourcing</td>
      <td>eventsourcing</td>
      <td>26</td>
      <td>39</td>
      <td>0.666667</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-test-4.6.8</td>
      <td>org.axonframework.test.saga</td>
      <td>saga</td>
      <td>14</td>
      <td>21</td>
      <td>0.666667</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.caching</td>
      <td>caching</td>
      <td>8</td>
      <td>12</td>
      <td>0.666667</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.annotation</td>
      <td>annotation</td>
      <td>2</td>
      <td>3</td>
      <td>0.666667</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.stream</td>
      <td>stream</td>
      <td>2</td>
      <td>3</td>
      <td>0.666667</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.tracing</td>
      <td>tracing</td>
      <td>11</td>
      <td>16</td>
      <td>0.687500</td>
    </tr>
    <tr>
      <th>20</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.deadline</td>
      <td>deadline</td>
      <td>7</td>
      <td>10</td>
      <td>0.700000</td>
    </tr>
    <tr>
      <th>21</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>unitofwork</td>
      <td>10</td>
      <td>14</td>
      <td>0.714286</td>
    </tr>
    <tr>
      <th>22</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>annotation</td>
      <td>37</td>
      <td>51</td>
      <td>0.725490</td>
    </tr>
    <tr>
      <th>23</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.lock</td>
      <td>lock</td>
      <td>8</td>
      <td>11</td>
      <td>0.727273</td>
    </tr>
    <tr>
      <th>24</th>
      <td>axon-modelling-4.6.8</td>
      <td>org.axonframework.modelling.saga.repository</td>
      <td>repository</td>
      <td>11</td>
      <td>15</td>
      <td>0.733333</td>
    </tr>
    <tr>
      <th>25</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.queryhandling.annotation</td>
      <td>annotation</td>
      <td>3</td>
      <td>4</td>
      <td>0.750000</td>
    </tr>
    <tr>
      <th>26</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling.scheduling.java</td>
      <td>java</td>
      <td>3</td>
      <td>4</td>
      <td>0.750000</td>
    </tr>
    <tr>
      <th>27</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.transaction</td>
      <td>transaction</td>
      <td>3</td>
      <td>4</td>
      <td>0.750000</td>
    </tr>
    <tr>
      <th>28</th>
      <td>axon-modelling-4.6.8</td>
      <td>org.axonframework.modelling.saga.metamodel</td>
      <td>metamodel</td>
      <td>3</td>
      <td>4</td>
      <td>0.750000</td>
    </tr>
    <tr>
      <th>29</th>
      <td>axon-modelling-4.6.8</td>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>inspection</td>
      <td>20</td>
      <td>26</td>
      <td>0.769231</td>
    </tr>
    <tr>
      <th>30</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>jdbc</td>
      <td>11</td>
      <td>14</td>
      <td>0.785714</td>
    </tr>
    <tr>
      <th>31</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common.jdbc</td>
      <td>jdbc</td>
      <td>12</td>
      <td>15</td>
      <td>0.800000</td>
    </tr>
    <tr>
      <th>32</th>
      <td>axon-test-4.6.8</td>
      <td>org.axonframework.test.utils</td>
      <td>utils</td>
      <td>4</td>
      <td>5</td>
      <td>0.800000</td>
    </tr>
    <tr>
      <th>33</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.queryhandling</td>
      <td>queryhandling</td>
      <td>33</td>
      <td>40</td>
      <td>0.825000</td>
    </tr>
    <tr>
      <th>34</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.monitoring</td>
      <td>monitoring</td>
      <td>5</td>
      <td>6</td>
      <td>0.833333</td>
    </tr>
    <tr>
      <th>35</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.eventhandling</td>
      <td>eventhandling</td>
      <td>78</td>
      <td>93</td>
      <td>0.838710</td>
    </tr>
    <tr>
      <th>36</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.serialization</td>
      <td>serialization</td>
      <td>27</td>
      <td>32</td>
      <td>0.843750</td>
    </tr>
    <tr>
      <th>37</th>
      <td>axon-messaging-4.6.8</td>
      <td>org.axonframework.common</td>
      <td>common</td>
      <td>24</td>
      <td>28</td>
      <td>0.857143</td>
    </tr>
    <tr>
      <th>38</th>
      <td>axon-eventsourcing-4.6.8</td>
      <td>org.axonframework.eventsourcing.eventstore.jpa</td>
      <td>jpa</td>
      <td>6</td>
      <td>7</td>
      <td>0.857143</td>
    </tr>
    <tr>
      <th>39</th>
      <td>axon-modelling-4.6.8</td>
      <td>org.axonframework.modelling.saga.repository.jpa</td>
      <td>jpa</td>
      <td>6</td>
      <td>7</td>
      <td>0.857143</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2 Chart 1 - Relative visibility of packages

    /opt/homebrew/Caskroom/miniforge/base/envs/codegraph/lib/python3.11/site-packages/pandas/plotting/_matplotlib/core.py:1259: UserWarning: No data for colormapping provided via 'c'. Parameters 'cmap' will be ignored
      scatter = ax.scatter(



    <Figure size 640x480 with 0 Axes>



    
![png](VisibilityMetrics_files/VisibilityMetrics_24_2.png)
    

