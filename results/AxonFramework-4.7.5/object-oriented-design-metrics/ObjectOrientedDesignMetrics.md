# Object Oriented Design Quality Metrics for Java with Neo4j
<br>  

### References
- [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html)
- [Calculate metrics](https://101.jqassistant.org/calculate-metrics/index.html)
- [jqassistant](https://jqassistant.org)
- [notebook walks through examples for integrating various packages with Neo4j](https://nicolewhite.github.io/neo4j-jupyter/hello-world.html)
- [OO Design Quality Metrics](https://api.semanticscholar.org/CorpusID:18246616)
- [py2neo](https://py2neo.org/2021.1/)


<style>
/* CSS style for smaller dataframe tables. */
.dataframe th {
    font-size: 8px;
}
.dataframe td {
    font-size: 8px;
}
</style>



## Artifacts

#### Table 1

- List all the artifacts this notebook is based on




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
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
      <td>axon-test-4.7.5.jar</td>
      <td>8</td>
      <td>85</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-disruptor-4.7.5.jar</td>
      <td>1</td>
      <td>22</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.7.5.jar</td>
      <td>9</td>
      <td>130</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-messaging-4.7.5.jar</td>
      <td>61</td>
      <td>729</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-modelling-4.7.5.jar</td>
      <td>10</td>
      <td>149</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-configuration-4.7.5.jar</td>
      <td>1</td>
      <td>39</td>
    </tr>
  </tbody>
</table>
</div>



## Incoming Dependencies

Incoming dependencies are also denoted as "Fan-in", "Afferent Couplings" or "in-degree".
These are the ones that use the listed package. 
   
If these packages get changed, the incoming dependencies might be affected by the change. The more incoming dependencies, the harder it gets to change the code without the need to adapt the dependent code (“rigid code”). Even worse, it might affect the behavior of the dependent code in an unwanted way (“fragile code”).
     
#### Table 2
- Show the top 20 packages with the most incoming dependencies
- Set the "incomingDependencies" properties on Package nodes.




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>packageName</th>
      <th>incomingDependencies</th>
      <th>incomingDependenciesWeight</th>
      <th>incomingDependentTypes</th>
      <th>incomingDependentInterfaces</th>
      <th>incomingDependentPackages</th>
      <th>incomingDependentArtifacts</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.messaging</td>
      <td>8344</td>
      <td>32781</td>
      <td>306</td>
      <td>64</td>
      <td>50</td>
      <td>6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.eventhandling</td>
      <td>4329</td>
      <td>27236</td>
      <td>277</td>
      <td>52</td>
      <td>44</td>
      <td>5</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.commandhandling</td>
      <td>1533</td>
      <td>7481</td>
      <td>121</td>
      <td>18</td>
      <td>18</td>
      <td>6</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.serialization</td>
      <td>1066</td>
      <td>5563</td>
      <td>124</td>
      <td>15</td>
      <td>30</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.messaging.annotation</td>
      <td>1017</td>
      <td>5095</td>
      <td>147</td>
      <td>18</td>
      <td>25</td>
      <td>6</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.common</td>
      <td>862</td>
      <td>2018</td>
      <td>311</td>
      <td>12</td>
      <td>74</td>
      <td>6</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.common.transaction</td>
      <td>275</td>
      <td>1059</td>
      <td>66</td>
      <td>5</td>
      <td>24</td>
      <td>4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.modelling.command</td>
      <td>251</td>
      <td>987</td>
      <td>74</td>
      <td>8</td>
      <td>10</td>
      <td>5</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>247</td>
      <td>1359</td>
      <td>79</td>
      <td>5</td>
      <td>33</td>
      <td>6</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.modelling.saga</td>
      <td>228</td>
      <td>1404</td>
      <td>55</td>
      <td>11</td>
      <td>10</td>
      <td>3</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>218</td>
      <td>1404</td>
      <td>26</td>
      <td>14</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.monitoring</td>
      <td>183</td>
      <td>608</td>
      <td>38</td>
      <td>6</td>
      <td>10</td>
      <td>4</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.tracing</td>
      <td>169</td>
      <td>662</td>
      <td>64</td>
      <td>4</td>
      <td>16</td>
      <td>4</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>168</td>
      <td>811</td>
      <td>59</td>
      <td>5</td>
      <td>10</td>
      <td>4</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.deadline</td>
      <td>159</td>
      <td>1331</td>
      <td>32</td>
      <td>8</td>
      <td>11</td>
      <td>4</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.queryhandling</td>
      <td>155</td>
      <td>729</td>
      <td>46</td>
      <td>10</td>
      <td>9</td>
      <td>2</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.messaging.deadletter</td>
      <td>135</td>
      <td>978</td>
      <td>28</td>
      <td>7</td>
      <td>5</td>
      <td>2</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.eventsourcing</td>
      <td>134</td>
      <td>657</td>
      <td>41</td>
      <td>6</td>
      <td>5</td>
      <td>4</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.config</td>
      <td>115</td>
      <td>1483</td>
      <td>34</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>98</td>
      <td>403</td>
      <td>34</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



## Outgoing Dependencies

Outcoming dependencies are also denoted as "Fan-out", "Efferent Couplings" or "out-degree".
These are the ones that are used by the listed package. 

Code from other packages and libraries you’re depending on (outgoing) might change over time. The more outgoing changes, the more likely and frequently code changes are needed. This involves time and effort which can be reduced by automation of tests and version updates. Automated tests are crucial to reveal updates, that change the behavior of the code unexpectedly (“fragile code”). As soon as more effort is required, keeping up becomes difficult (“rigid code”). Not being able to use a newer version might not only restrict features, it can get problematic if there are security issues. This might force you to take “fast but ugly” solutions into account which further increases technical dept.
  
#### Table 3

- Show the top 20 packages with the most outgoing dependencies
- Set the "outgoingDependencies" properties on Package nodes.




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>packageName</th>
      <th>outgoingDependencies</th>
      <th>outgoingDependentTypes</th>
      <th>outgoingDependentInterfaces</th>
      <th>outgoingDependentPackages</th>
      <th>outgoingDependentArtifacts</th>
      <th>outgoingDependenciesWeight</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.config</td>
      <td>7942</td>
      <td>212</td>
      <td>84</td>
      <td>46</td>
      <td>5</td>
      <td>34762</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.test.aggregate</td>
      <td>2223</td>
      <td>92</td>
      <td>34</td>
      <td>16</td>
      <td>4</td>
      <td>9766</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.eventhandling</td>
      <td>1557</td>
      <td>151</td>
      <td>54</td>
      <td>16</td>
      <td>1</td>
      <td>7770</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>1487</td>
      <td>85</td>
      <td>31</td>
      <td>14</td>
      <td>4</td>
      <td>7444</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventsourcing.eventstore.jdbc</td>
      <td>1340</td>
      <td>51</td>
      <td>27</td>
      <td>11</td>
      <td>3</td>
      <td>8129</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.eventhandling.pooled</td>
      <td>1022</td>
      <td>57</td>
      <td>26</td>
      <td>12</td>
      <td>1</td>
      <td>5590</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.eventsourcing</td>
      <td>976</td>
      <td>91</td>
      <td>31</td>
      <td>16</td>
      <td>3</td>
      <td>4142</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.modelling.command</td>
      <td>827</td>
      <td>91</td>
      <td>33</td>
      <td>15</td>
      <td>2</td>
      <td>4151</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.modelling.command.inspection</td>
      <td>649</td>
      <td>64</td>
      <td>27</td>
      <td>10</td>
      <td>2</td>
      <td>3150</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.commandhandling</td>
      <td>642</td>
      <td>70</td>
      <td>28</td>
      <td>9</td>
      <td>1</td>
      <td>2295</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.queryhandling</td>
      <td>628</td>
      <td>65</td>
      <td>26</td>
      <td>10</td>
      <td>1</td>
      <td>2494</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.commandhandling.distributed</td>
      <td>603</td>
      <td>67</td>
      <td>23</td>
      <td>11</td>
      <td>1</td>
      <td>2368</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>590</td>
      <td>62</td>
      <td>25</td>
      <td>16</td>
      <td>3</td>
      <td>2462</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.deadline.quartz</td>
      <td>481</td>
      <td>38</td>
      <td>18</td>
      <td>10</td>
      <td>1</td>
      <td>2187</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>447</td>
      <td>58</td>
      <td>11</td>
      <td>10</td>
      <td>1</td>
      <td>1622</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.test.saga</td>
      <td>413</td>
      <td>50</td>
      <td>22</td>
      <td>15</td>
      <td>3</td>
      <td>1513</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.modelling.saga</td>
      <td>386</td>
      <td>58</td>
      <td>21</td>
      <td>9</td>
      <td>2</td>
      <td>1799</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>375</td>
      <td>47</td>
      <td>17</td>
      <td>15</td>
      <td>2</td>
      <td>1870</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.deadline.jobrunr</td>
      <td>348</td>
      <td>31</td>
      <td>15</td>
      <td>8</td>
      <td>1</td>
      <td>1611</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.deadline</td>
      <td>347</td>
      <td>43</td>
      <td>21</td>
      <td>8</td>
      <td>1</td>
      <td>1281</td>
    </tr>
  </tbody>
</table>
</div>



## Instability

$$ Instability = \frac{Outgoing\:Dependencies}{Outgoing\:Dependencies + Incoming\:Dependencies} $$

*Instability* is expressed as the ratio of the number of outgoing dependencies of a module (i.e., the number of packages that depend on it) to the total number of dependencies (i.e., the sum of incoming and outgoing dependencies).

Small values near zero indicate low *Instability*. With no outgoing but some incoming dependencies the Instability is zero which is denoted as maximally stable. Such code units are more rigid and difficult to change without impacting other parts of the system. If they are changed less because of that, they are considered stable.

Conversely, high values approaching one indicate high *Instability*. With some outgoing dependencies but no incoming ones the *Instability* is denoted as maximally unstable. Such code units are easier to change without affecting other modules, making them more flexible and less prone to cascading changes throughout the system. If they are changed more often because of that, they are considered unstable.

#### Table 4

- Show the top 20 packages with the lowest *Instability*




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>p.fqn</th>
      <th>p.name</th>
      <th>instability</th>
      <th>instabilityTypes</th>
      <th>instabilityInterfaces</th>
      <th>instabilityPackages</th>
      <th>instabilityArtifacts</th>
      <th>p.outgoingDependencies</th>
      <th>p.incomingDependencies</th>
      <th>p.outgoingDependentTypes</th>
      <th>p.incomingDependentTypes</th>
      <th>p.outgoingDependentInterfaces</th>
      <th>p.incomingDependentInterfaces</th>
      <th>p.outgoingDependentPackages</th>
      <th>p.incomingDependentPackages</th>
      <th>p.outgoingDependentArtifacts</th>
      <th>p.incomingDependentArtifacts</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.messaging</td>
      <td>messaging</td>
      <td>0.015690</td>
      <td>0.102639</td>
      <td>0.189873</td>
      <td>0.107143</td>
      <td>0.142857</td>
      <td>133</td>
      <td>8344</td>
      <td>35</td>
      <td>306</td>
      <td>15</td>
      <td>64</td>
      <td>6</td>
      <td>50</td>
      <td>1</td>
      <td>6</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.common.transaction</td>
      <td>transaction</td>
      <td>0.021352</td>
      <td>0.057143</td>
      <td>0.000000</td>
      <td>0.040000</td>
      <td>0.200000</td>
      <td>6</td>
      <td>275</td>
      <td>4</td>
      <td>66</td>
      <td>0</td>
      <td>5</td>
      <td>1</td>
      <td>24</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.common</td>
      <td>common</td>
      <td>0.025989</td>
      <td>0.046012</td>
      <td>0.000000</td>
      <td>0.013333</td>
      <td>0.142857</td>
      <td>23</td>
      <td>862</td>
      <td>15</td>
      <td>311</td>
      <td>0</td>
      <td>12</td>
      <td>1</td>
      <td>74</td>
      <td>1</td>
      <td>6</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.monitoring</td>
      <td>monitoring</td>
      <td>0.102941</td>
      <td>0.155556</td>
      <td>0.333333</td>
      <td>0.230769</td>
      <td>0.200000</td>
      <td>21</td>
      <td>183</td>
      <td>7</td>
      <td>38</td>
      <td>3</td>
      <td>6</td>
      <td>3</td>
      <td>10</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.eventhandling.scheduling</td>
      <td>scheduling</td>
      <td>0.111111</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.250000</td>
      <td>0.250000</td>
      <td>2</td>
      <td>16</td>
      <td>2</td>
      <td>10</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>6</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.common.annotation</td>
      <td>annotation</td>
      <td>0.125000</td>
      <td>0.125000</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>0.250000</td>
      <td>3</td>
      <td>21</td>
      <td>3</td>
      <td>21</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>10</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.serialization</td>
      <td>serialization</td>
      <td>0.136143</td>
      <td>0.270588</td>
      <td>0.318182</td>
      <td>0.230769</td>
      <td>0.200000</td>
      <td>168</td>
      <td>1066</td>
      <td>46</td>
      <td>124</td>
      <td>7</td>
      <td>15</td>
      <td>9</td>
      <td>30</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.lifecycle</td>
      <td>lifecycle</td>
      <td>0.138889</td>
      <td>0.259259</td>
      <td>0.000000</td>
      <td>0.214286</td>
      <td>0.250000</td>
      <td>10</td>
      <td>62</td>
      <td>7</td>
      <td>20</td>
      <td>0</td>
      <td>3</td>
      <td>3</td>
      <td>11</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.common.stream</td>
      <td>stream</td>
      <td>0.147059</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.125000</td>
      <td>0.250000</td>
      <td>5</td>
      <td>29</td>
      <td>3</td>
      <td>15</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
      <td>7</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.messaging.annotation</td>
      <td>annotation</td>
      <td>0.228376</td>
      <td>0.313084</td>
      <td>0.419355</td>
      <td>0.218750</td>
      <td>0.142857</td>
      <td>301</td>
      <td>1017</td>
      <td>67</td>
      <td>147</td>
      <td>13</td>
      <td>18</td>
      <td>7</td>
      <td>25</td>
      <td>1</td>
      <td>6</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.eventhandling</td>
      <td>eventhandling</td>
      <td>0.264526</td>
      <td>0.352804</td>
      <td>0.509434</td>
      <td>0.266667</td>
      <td>0.166667</td>
      <td>1557</td>
      <td>4329</td>
      <td>151</td>
      <td>277</td>
      <td>54</td>
      <td>52</td>
      <td>16</td>
      <td>44</td>
      <td>1</td>
      <td>5</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.common.jpa</td>
      <td>jpa</td>
      <td>0.272727</td>
      <td>0.250000</td>
      <td>1.000000</td>
      <td>0.300000</td>
      <td>0.200000</td>
      <td>6</td>
      <td>16</td>
      <td>5</td>
      <td>15</td>
      <td>2</td>
      <td>0</td>
      <td>3</td>
      <td>7</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.commandhandling</td>
      <td>commandhandling</td>
      <td>0.295172</td>
      <td>0.366492</td>
      <td>0.608696</td>
      <td>0.333333</td>
      <td>0.142857</td>
      <td>642</td>
      <td>1533</td>
      <td>70</td>
      <td>121</td>
      <td>28</td>
      <td>18</td>
      <td>9</td>
      <td>18</td>
      <td>1</td>
      <td>6</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.common.legacyjpa</td>
      <td>legacyjpa</td>
      <td>0.300000</td>
      <td>0.277778</td>
      <td>1.000000</td>
      <td>0.333333</td>
      <td>0.250000</td>
      <td>6</td>
      <td>14</td>
      <td>5</td>
      <td>13</td>
      <td>2</td>
      <td>0</td>
      <td>3</td>
      <td>6</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.serialization.upcasting</td>
      <td>upcasting</td>
      <td>0.312500</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.333333</td>
      <td>0.500000</td>
      <td>5</td>
      <td>11</td>
      <td>1</td>
      <td>11</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>unitofwork</td>
      <td>0.332432</td>
      <td>0.202020</td>
      <td>0.583333</td>
      <td>0.131579</td>
      <td>0.142857</td>
      <td>123</td>
      <td>247</td>
      <td>20</td>
      <td>79</td>
      <td>7</td>
      <td>5</td>
      <td>5</td>
      <td>33</td>
      <td>1</td>
      <td>6</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.common.lock</td>
      <td>lock</td>
      <td>0.352113</td>
      <td>0.363636</td>
      <td>0.500000</td>
      <td>0.222222</td>
      <td>0.200000</td>
      <td>25</td>
      <td>46</td>
      <td>12</td>
      <td>21</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>7</td>
      <td>1</td>
      <td>4</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.messaging.correlation</td>
      <td>correlation</td>
      <td>0.358974</td>
      <td>0.230769</td>
      <td>0.400000</td>
      <td>0.333333</td>
      <td>0.333333</td>
      <td>14</td>
      <td>25</td>
      <td>3</td>
      <td>10</td>
      <td>2</td>
      <td>3</td>
      <td>2</td>
      <td>4</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.eventhandling.tokenstore</td>
      <td>tokenstore</td>
      <td>0.378378</td>
      <td>0.342105</td>
      <td>0.571429</td>
      <td>0.333333</td>
      <td>0.333333</td>
      <td>42</td>
      <td>69</td>
      <td>13</td>
      <td>25</td>
      <td>4</td>
      <td>3</td>
      <td>4</td>
      <td>8</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.common.property</td>
      <td>property</td>
      <td>0.394737</td>
      <td>0.380952</td>
      <td>1.000000</td>
      <td>0.285714</td>
      <td>0.333333</td>
      <td>15</td>
      <td>23</td>
      <td>8</td>
      <td>13</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>5</td>
      <td>1</td>
      <td>2</td>
    </tr>
  </tbody>
</table>
</div>



## Abstractness

$$ Abstractness = \frac{abstract\:classes\:in\:category}{total\:number\:of\:classes\:in\:category} $$

Package *Abstractness* is expressed as the ratio of the number of abstract classes and interfaces to the total number of classes of a package.

Zero *Abstractness* means that there are no abstract types or interfaces in the package. On the other hand, a value of one means that there are only abstract types.

#### Table 5

- Show the top 30 packages with the lowest *Abstractness*




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>fullQualifiedPackageName</th>
      <th>packageName</th>
      <th>abstractness</th>
      <th>numberAbstractTypes</th>
      <th>numberTypes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>org.axonframework.eventsourcing.eventstore.leg...</td>
      <td>legacyjpa</td>
      <td>0.000000</td>
      <td>0</td>
      <td>10</td>
    </tr>
    <tr>
      <th>1</th>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>commandfilter</td>
      <td>0.000000</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>2</th>
      <td>org.axonframework.serialization.json</td>
      <td>json</td>
      <td>0.000000</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>3</th>
      <td>org.axonframework.serialization.xml</td>
      <td>xml</td>
      <td>0.000000</td>
      <td>0</td>
      <td>7</td>
    </tr>
    <tr>
      <th>4</th>
      <td>org.axonframework.tracing.attributes</td>
      <td>attributes</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
    </tr>
    <tr>
      <th>5</th>
      <td>org.axonframework.serialization.converters</td>
      <td>converters</td>
      <td>0.000000</td>
      <td>0</td>
      <td>5</td>
    </tr>
    <tr>
      <th>6</th>
      <td>org.axonframework.commandhandling.callbacks</td>
      <td>callbacks</td>
      <td>0.000000</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>org.axonframework.deadline.quartz</td>
      <td>quartz</td>
      <td>0.000000</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>8</th>
      <td>org.axonframework.eventhandling.deadletter</td>
      <td>deadletter</td>
      <td>0.000000</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>9</th>
      <td>org.axonframework.eventhandling.scheduling.java</td>
      <td>java</td>
      <td>0.000000</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>10</th>
      <td>org.axonframework.eventhandling.tokenstore.jpa</td>
      <td>jpa</td>
      <td>0.000000</td>
      <td>0</td>
      <td>4</td>
    </tr>
    <tr>
      <th>11</th>
      <td>org.axonframework.deadline.jobrunr</td>
      <td>jobrunr</td>
      <td>0.000000</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>12</th>
      <td>org.axonframework.eventhandling.scheduling.job...</td>
      <td>jobrunr</td>
      <td>0.000000</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>13</th>
      <td>org.axonframework.util</td>
      <td>util</td>
      <td>0.000000</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>14</th>
      <td>org.axonframework.modelling.saga.repository.le...</td>
      <td>legacyjpa</td>
      <td>0.000000</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>15</th>
      <td>org.axonframework.test.server</td>
      <td>server</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>16</th>
      <td>org.axonframework.eventsourcing.eventstore.inm...</td>
      <td>inmemory</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>17</th>
      <td>org.axonframework.eventhandling.tokenstore.inm...</td>
      <td>inmemory</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>18</th>
      <td>org.axonframework.eventhandling.tokenstore.leg...</td>
      <td>legacyjpa</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>19</th>
      <td>org.axonframework.messaging.interceptors.legac...</td>
      <td>legacyvalidation</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>20</th>
      <td>org.axonframework.modelling.command.legacyjpa</td>
      <td>legacyjpa</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>21</th>
      <td>org.axonframework.modelling.saga.repository.in...</td>
      <td>inmemory</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>22</th>
      <td>org.axonframework.common.digest</td>
      <td>digest</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>23</th>
      <td>org.axonframework.common.io</td>
      <td>io</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>24</th>
      <td>org.axonframework.eventhandling.interceptors</td>
      <td>interceptors</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>25</th>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>commandhandling</td>
      <td>0.045455</td>
      <td>1</td>
      <td>22</td>
    </tr>
    <tr>
      <th>26</th>
      <td>org.axonframework.eventhandling.deadletter.jpa</td>
      <td>jpa</td>
      <td>0.111111</td>
      <td>1</td>
      <td>9</td>
    </tr>
    <tr>
      <th>27</th>
      <td>org.axonframework.eventhandling.tokenstore.jdbc</td>
      <td>jdbc</td>
      <td>0.111111</td>
      <td>1</td>
      <td>9</td>
    </tr>
    <tr>
      <th>28</th>
      <td>org.axonframework.modelling.saga.repository.jdbc</td>
      <td>jdbc</td>
      <td>0.111111</td>
      <td>1</td>
      <td>9</td>
    </tr>
    <tr>
      <th>29</th>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>0.125000</td>
      <td>3</td>
      <td>24</td>
    </tr>
  </tbody>
</table>
</div>



## Distance from the main sequence

The *main sequence* is a imaginary line that represents a good compromise between *Abstractness* and *Instability*. A high distance to this line may indicate problems. For example is very *stable* (rigid) code with low abstractness hard to change.

Read more details on that in [OO Design Quality Metrics](https://api.semanticscholar.org/CorpusID:18246616) and [Calculate metrics](https://101.jqassistant.org/calculate-metrics/index.html).

#### Table 6

- Show the top 20 packages with the highest distance from the "main sequence"




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artifactName</th>
      <th>fullQualifiedPackageName</th>
      <th>packageName</th>
      <th>distance</th>
      <th>abstractness</th>
      <th>instability</th>
      <th>typesInPackage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-test-4.7.5</td>
      <td>org.axonframework.test.server</td>
      <td>server</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.common.io</td>
      <td>io</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore.jdb...</td>
      <td>statements</td>
      <td>0.727273</td>
      <td>1.000000</td>
      <td>0.727273</td>
      <td>15</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-modelling-4.7.5</td>
      <td>org.axonframework.modelling.saga.repository.in...</td>
      <td>inmemory</td>
      <td>0.600000</td>
      <td>0.000000</td>
      <td>0.400000</td>
      <td>2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization</td>
      <td>serialization</td>
      <td>0.569740</td>
      <td>0.294118</td>
      <td>0.136143</td>
      <td>34</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.monitoring</td>
      <td>monitoring</td>
      <td>0.563725</td>
      <td>0.333333</td>
      <td>0.102941</td>
      <td>6</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.common.digest</td>
      <td>digest</td>
      <td>0.500000</td>
      <td>0.000000</td>
      <td>0.500000</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>annotation</td>
      <td>0.493846</td>
      <td>0.277778</td>
      <td>0.228376</td>
      <td>54</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.common.transaction</td>
      <td>transaction</td>
      <td>0.478648</td>
      <td>0.500000</td>
      <td>0.021352</td>
      <td>4</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.common.jpa</td>
      <td>jpa</td>
      <td>0.477273</td>
      <td>0.250000</td>
      <td>0.272727</td>
      <td>4</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.common.lock</td>
      <td>lock</td>
      <td>0.466069</td>
      <td>0.181818</td>
      <td>0.352113</td>
      <td>11</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.common.legacyjpa</td>
      <td>legacyjpa</td>
      <td>0.450000</td>
      <td>0.250000</td>
      <td>0.300000</td>
      <td>4</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.gateway</td>
      <td>gateway</td>
      <td>0.425397</td>
      <td>0.600000</td>
      <td>0.825397</td>
      <td>5</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-configuration-4.7.5</td>
      <td>org.axonframework.config</td>
      <td>config</td>
      <td>0.421624</td>
      <td>0.435897</td>
      <td>0.985727</td>
      <td>39</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-test-4.7.5</td>
      <td>org.axonframework.test.matchers</td>
      <td>matchers</td>
      <td>0.407110</td>
      <td>0.125000</td>
      <td>0.467890</td>
      <td>24</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.correlation</td>
      <td>correlation</td>
      <td>0.391026</td>
      <td>0.250000</td>
      <td>0.358974</td>
      <td>4</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging</td>
      <td>messaging</td>
      <td>0.384310</td>
      <td>0.600000</td>
      <td>0.015690</td>
      <td>35</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.unitofwork</td>
      <td>unitofwork</td>
      <td>0.381853</td>
      <td>0.285714</td>
      <td>0.332432</td>
      <td>14</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.serialization.xml</td>
      <td>xml</td>
      <td>0.377778</td>
      <td>0.000000</td>
      <td>0.622222</td>
      <td>7</td>
    </tr>
    <tr>
      <th>19</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.tracing</td>
      <td>tracing</td>
      <td>0.358534</td>
      <td>0.222222</td>
      <td>0.419244</td>
      <td>18</td>
    </tr>
  </tbody>
</table>
</div>



### *Abstractness* vs. *Instability* Plot with "Main Sequence" line as reference

#### Figure 1
- Plot *Abstractness* vs. *Instability* of all packages
- Draw the "main sequence" as dashed green line 
- Scale the packages by the number of types they contain
- Color the packages by their distance to the "main sequence" (blue=near, red=far)


    
![png](ObjectOrientedDesignMetrics_files/ObjectOrientedDesignMetrics_21_0.png)
    

