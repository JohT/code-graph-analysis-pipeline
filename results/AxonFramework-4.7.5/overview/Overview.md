# Overview of Java Artifacts with Neo4j
<br>  

### References
- [jqassistant](https://jqassistant.org)
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

### Table 1 - Types per artifact




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
      <th>languageElement</th>
      <th>numberOfTypes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-test-4.7.5</td>
      <td>Interface</td>
      <td>16</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-test-4.7.5</td>
      <td>Class</td>
      <td>69</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-disruptor-4.7.5</td>
      <td>Class</td>
      <td>22</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>Interface</td>
      <td>31</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>Class</td>
      <td>96</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>Enum</td>
      <td>2</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>Annotation</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.7.5</td>
      <td>Class</td>
      <td>541</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.7.5</td>
      <td>Interface</td>
      <td>143</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-messaging-4.7.5</td>
      <td>Annotation</td>
      <td>26</td>
    </tr>
    <tr>
      <th>10</th>
      <td>axon-messaging-4.7.5</td>
      <td>Enum</td>
      <td>19</td>
    </tr>
    <tr>
      <th>11</th>
      <td>axon-modelling-4.7.5</td>
      <td>Interface</td>
      <td>26</td>
    </tr>
    <tr>
      <th>12</th>
      <td>axon-modelling-4.7.5</td>
      <td>Class</td>
      <td>108</td>
    </tr>
    <tr>
      <th>13</th>
      <td>axon-modelling-4.7.5</td>
      <td>Annotation</td>
      <td>12</td>
    </tr>
    <tr>
      <th>14</th>
      <td>axon-modelling-4.7.5</td>
      <td>Enum</td>
      <td>3</td>
    </tr>
    <tr>
      <th>15</th>
      <td>axon-configuration-4.7.5</td>
      <td>Class</td>
      <td>22</td>
    </tr>
    <tr>
      <th>16</th>
      <td>axon-configuration-4.7.5</td>
      <td>Interface</td>
      <td>15</td>
    </tr>
    <tr>
      <th>17</th>
      <td>axon-configuration-4.7.5</td>
      <td>Annotation</td>
      <td>1</td>
    </tr>
    <tr>
      <th>18</th>
      <td>axon-configuration-4.7.5</td>
      <td>Enum</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



### Table 2 - Types per artifact (grouped)




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
      <th>languageElement</th>
      <th>Class</th>
      <th>Interface</th>
      <th>Annotation</th>
      <th>Enum</th>
    </tr>
    <tr>
      <th>artifactName</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>axon-messaging-4.7.5</th>
      <td>541</td>
      <td>143</td>
      <td>26</td>
      <td>19</td>
    </tr>
    <tr>
      <th>axon-modelling-4.7.5</th>
      <td>108</td>
      <td>26</td>
      <td>12</td>
      <td>3</td>
    </tr>
    <tr>
      <th>axon-eventsourcing-4.7.5</th>
      <td>96</td>
      <td>31</td>
      <td>1</td>
      <td>2</td>
    </tr>
    <tr>
      <th>axon-test-4.7.5</th>
      <td>69</td>
      <td>16</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>axon-configuration-4.7.5</th>
      <td>22</td>
      <td>15</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>axon-disruptor-4.7.5</th>
      <td>22</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>




    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_13_1.png)
    


### Table 3 - Types per artifact (grouped and normalized in %)




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
      <th>languageElement</th>
      <th>Class</th>
      <th>Interface</th>
      <th>Annotation</th>
      <th>Enum</th>
    </tr>
    <tr>
      <th>artifactName</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>axon-messaging-4.7.5</th>
      <td>74.211248</td>
      <td>19.615912</td>
      <td>3.566529</td>
      <td>2.606310</td>
    </tr>
    <tr>
      <th>axon-modelling-4.7.5</th>
      <td>72.483221</td>
      <td>17.449664</td>
      <td>8.053691</td>
      <td>2.013423</td>
    </tr>
    <tr>
      <th>axon-eventsourcing-4.7.5</th>
      <td>73.846154</td>
      <td>23.846154</td>
      <td>0.769231</td>
      <td>1.538462</td>
    </tr>
    <tr>
      <th>axon-test-4.7.5</th>
      <td>81.176471</td>
      <td>18.823529</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>axon-configuration-4.7.5</th>
      <td>56.410256</td>
      <td>38.461538</td>
      <td>2.564103</td>
      <td>2.564103</td>
    </tr>
    <tr>
      <th>axon-disruptor-4.7.5</th>
      <td>100.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>




    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_17_1.png)
    


### Table 4 - Number of packages per artifact




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
      <th>numberOfPackages</th>
    </tr>
    <tr>
      <th>artifactName</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>axon-messaging-4.7.5</th>
      <td>61</td>
    </tr>
    <tr>
      <th>axon-modelling-4.7.5</th>
      <td>10</td>
    </tr>
    <tr>
      <th>axon-eventsourcing-4.7.5</th>
      <td>9</td>
    </tr>
    <tr>
      <th>axon-test-4.7.5</th>
      <td>8</td>
    </tr>
    <tr>
      <th>axon-disruptor-4.7.5</th>
      <td>1</td>
    </tr>
    <tr>
      <th>axon-configuration-4.7.5</th>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_20_1.png)
    


## Effective Method Line Count

### Table 5 - Effective method line count distribution

The table shown here only includes the first 10 rows which typically represents the most significant entries.
Have a look below to find out which packages and methods have the highest effective lines of code.




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
      <th>artifactName</th>
      <th>axon-configuration-4.7.5.jar</th>
      <th>axon-disruptor-4.7.5.jar</th>
      <th>axon-eventsourcing-4.7.5.jar</th>
      <th>axon-messaging-4.7.5.jar</th>
      <th>axon-modelling-4.7.5.jar</th>
      <th>axon-test-4.7.5.jar</th>
    </tr>
    <tr>
      <th>effectiveLineCount</th>
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
      <td>304</td>
      <td>84</td>
      <td>564</td>
      <td>2486</td>
      <td>473</td>
      <td>261</td>
    </tr>
    <tr>
      <th>2</th>
      <td>135</td>
      <td>31</td>
      <td>196</td>
      <td>720</td>
      <td>137</td>
      <td>147</td>
    </tr>
    <tr>
      <th>3</th>
      <td>33</td>
      <td>30</td>
      <td>123</td>
      <td>557</td>
      <td>127</td>
      <td>61</td>
    </tr>
    <tr>
      <th>4</th>
      <td>33</td>
      <td>8</td>
      <td>64</td>
      <td>245</td>
      <td>55</td>
      <td>48</td>
    </tr>
    <tr>
      <th>5</th>
      <td>14</td>
      <td>5</td>
      <td>38</td>
      <td>199</td>
      <td>46</td>
      <td>23</td>
    </tr>
    <tr>
      <th>6</th>
      <td>16</td>
      <td>6</td>
      <td>33</td>
      <td>133</td>
      <td>38</td>
      <td>17</td>
    </tr>
    <tr>
      <th>7</th>
      <td>2</td>
      <td>2</td>
      <td>31</td>
      <td>91</td>
      <td>23</td>
      <td>18</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>0</td>
      <td>11</td>
      <td>73</td>
      <td>11</td>
      <td>10</td>
    </tr>
    <tr>
      <th>9</th>
      <td>8</td>
      <td>4</td>
      <td>17</td>
      <td>65</td>
      <td>8</td>
      <td>10</td>
    </tr>
    <tr>
      <th>10</th>
      <td>4</td>
      <td>3</td>
      <td>8</td>
      <td>37</td>
      <td>7</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>



### Table 6 - Effective method line count distribution (normalized)

The table shown here only includes the first 10 rows which typically represents the most significant entries.
Have a look below to find out which packages and methods have the highest effective lines of code.




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
      <th>artifactName</th>
      <th>axon-configuration-4.7.5.jar</th>
      <th>axon-disruptor-4.7.5.jar</th>
      <th>axon-eventsourcing-4.7.5.jar</th>
      <th>axon-messaging-4.7.5.jar</th>
      <th>axon-modelling-4.7.5.jar</th>
      <th>axon-test-4.7.5.jar</th>
    </tr>
    <tr>
      <th>effectiveLineCount</th>
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
      <td>52.961672</td>
      <td>45.652174</td>
      <td>50.492390</td>
      <td>51.975747</td>
      <td>49.015544</td>
      <td>40.717629</td>
    </tr>
    <tr>
      <th>2</th>
      <td>23.519164</td>
      <td>16.847826</td>
      <td>17.547001</td>
      <td>15.053314</td>
      <td>14.196891</td>
      <td>22.932917</td>
    </tr>
    <tr>
      <th>3</th>
      <td>5.749129</td>
      <td>16.304348</td>
      <td>11.011638</td>
      <td>11.645411</td>
      <td>13.160622</td>
      <td>9.516381</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5.749129</td>
      <td>4.347826</td>
      <td>5.729633</td>
      <td>5.122308</td>
      <td>5.699482</td>
      <td>7.488300</td>
    </tr>
    <tr>
      <th>5</th>
      <td>2.439024</td>
      <td>2.717391</td>
      <td>3.401970</td>
      <td>4.160569</td>
      <td>4.766839</td>
      <td>3.588144</td>
    </tr>
    <tr>
      <th>6</th>
      <td>2.787456</td>
      <td>3.260870</td>
      <td>2.954342</td>
      <td>2.780682</td>
      <td>3.937824</td>
      <td>2.652106</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0.348432</td>
      <td>1.086957</td>
      <td>2.775291</td>
      <td>1.902572</td>
      <td>2.383420</td>
      <td>2.808112</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1.567944</td>
      <td>0.000000</td>
      <td>0.984781</td>
      <td>1.526239</td>
      <td>1.139896</td>
      <td>1.560062</td>
    </tr>
    <tr>
      <th>9</th>
      <td>1.393728</td>
      <td>2.173913</td>
      <td>1.521934</td>
      <td>1.358980</td>
      <td>0.829016</td>
      <td>1.560062</td>
    </tr>
    <tr>
      <th>10</th>
      <td>0.696864</td>
      <td>1.630435</td>
      <td>0.716204</td>
      <td>0.773573</td>
      <td>0.725389</td>
      <td>0.780031</td>
    </tr>
  </tbody>
</table>
</div>




    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_26_1.png)
    


### Table 7 - Cyclomatic method complexity distribution

The table shown here only includes the first 10 rows which typically represents the most significant entries.
Have a look below to find out which packages and methods have the highest effective lines of code.




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
      <th>artifactName</th>
      <th>axon-configuration-4.7.5.jar</th>
      <th>axon-disruptor-4.7.5.jar</th>
      <th>axon-eventsourcing-4.7.5.jar</th>
      <th>axon-messaging-4.7.5.jar</th>
      <th>axon-modelling-4.7.5.jar</th>
      <th>axon-test-4.7.5.jar</th>
    </tr>
    <tr>
      <th>cyclomaticComplexity</th>
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
      <td>515</td>
      <td>146</td>
      <td>920</td>
      <td>3817</td>
      <td>794</td>
      <td>474</td>
    </tr>
    <tr>
      <th>2</th>
      <td>37</td>
      <td>20</td>
      <td>92</td>
      <td>408</td>
      <td>70</td>
      <td>58</td>
    </tr>
    <tr>
      <th>3</th>
      <td>13</td>
      <td>5</td>
      <td>54</td>
      <td>263</td>
      <td>35</td>
      <td>55</td>
    </tr>
    <tr>
      <th>4</th>
      <td>3</td>
      <td>4</td>
      <td>24</td>
      <td>129</td>
      <td>27</td>
      <td>21</td>
    </tr>
    <tr>
      <th>5</th>
      <td>3</td>
      <td>3</td>
      <td>9</td>
      <td>65</td>
      <td>22</td>
      <td>12</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>43</td>
      <td>11</td>
      <td>8</td>
    </tr>
    <tr>
      <th>7</th>
      <td>2</td>
      <td>2</td>
      <td>7</td>
      <td>19</td>
      <td>2</td>
      <td>4</td>
    </tr>
    <tr>
      <th>8</th>
      <td>0</td>
      <td>2</td>
      <td>7</td>
      <td>10</td>
      <td>1</td>
      <td>3</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>7</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>10</th>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>4</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



### Table 8 - Cyclomatic method complexity distribution (normalized)

The table shown here only includes the first 10 rows which typically represents the most significant entries.
Have a look below to find out which packages and methods have the highest effective lines of code.




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
      <th>artifactName</th>
      <th>axon-configuration-4.7.5.jar</th>
      <th>axon-disruptor-4.7.5.jar</th>
      <th>axon-eventsourcing-4.7.5.jar</th>
      <th>axon-messaging-4.7.5.jar</th>
      <th>axon-modelling-4.7.5.jar</th>
      <th>axon-test-4.7.5.jar</th>
    </tr>
    <tr>
      <th>cyclomaticComplexity</th>
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
      <td>89.721254</td>
      <td>79.347826</td>
      <td>82.363474</td>
      <td>79.803471</td>
      <td>82.279793</td>
      <td>73.946958</td>
    </tr>
    <tr>
      <th>2</th>
      <td>6.445993</td>
      <td>10.869565</td>
      <td>8.236347</td>
      <td>8.530211</td>
      <td>7.253886</td>
      <td>9.048362</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2.264808</td>
      <td>2.717391</td>
      <td>4.834378</td>
      <td>5.498641</td>
      <td>3.626943</td>
      <td>8.580343</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.522648</td>
      <td>2.173913</td>
      <td>2.148612</td>
      <td>2.697052</td>
      <td>2.797927</td>
      <td>3.276131</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0.522648</td>
      <td>1.630435</td>
      <td>0.805730</td>
      <td>1.358980</td>
      <td>2.279793</td>
      <td>1.872075</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.174216</td>
      <td>1.086957</td>
      <td>0.268577</td>
      <td>0.899017</td>
      <td>1.139896</td>
      <td>1.248050</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0.348432</td>
      <td>1.086957</td>
      <td>0.626679</td>
      <td>0.397240</td>
      <td>0.207254</td>
      <td>0.624025</td>
    </tr>
    <tr>
      <th>8</th>
      <td>0.000000</td>
      <td>1.086957</td>
      <td>0.626679</td>
      <td>0.209074</td>
      <td>0.103627</td>
      <td>0.468019</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.146352</td>
      <td>0.207254</td>
      <td>0.156006</td>
    </tr>
    <tr>
      <th>10</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.083630</td>
      <td>0.000000</td>
      <td>0.156006</td>
    </tr>
  </tbody>
</table>
</div>




    <Figure size 640x480 with 0 Axes>



    
![png](Overview_files/Overview_31_1.png)
    


### Table 9 - Top 10 packages with highest effective line counts




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
      <th>fullPackageName</th>
      <th>linesInPackage</th>
      <th>methodCount</th>
      <th>maxLinesMethod</th>
      <th>maxLinesMethodName</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling</td>
      <td>2213</td>
      <td>793</td>
      <td>64</td>
      <td>processBatch</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-configuration-4.7.5</td>
      <td>org.axonframework.config</td>
      <td>1474</td>
      <td>574</td>
      <td>42</td>
      <td>&lt;init&gt;</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.pooled</td>
      <td>939</td>
      <td>308</td>
      <td>70</td>
      <td>run</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.7.5</td>
      <td>org.axonframework.test.aggregate</td>
      <td>937</td>
      <td>249</td>
      <td>45</td>
      <td>appendEventOverview</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-modelling-4.7.5</td>
      <td>org.axonframework.modelling.command</td>
      <td>784</td>
      <td>315</td>
      <td>17</td>
      <td>lambda$initializeHandler$7</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.queryhandling</td>
      <td>723</td>
      <td>285</td>
      <td>36</td>
      <td>doQuery</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>694</td>
      <td>256</td>
      <td>21</td>
      <td>peekPrivateStream</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>673</td>
      <td>239</td>
      <td>23</td>
      <td>&lt;init&gt;</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-disruptor-4.7.5</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>605</td>
      <td>184</td>
      <td>32</td>
      <td>&lt;init&gt;</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing</td>
      <td>582</td>
      <td>236</td>
      <td>20</td>
      <td>doScheduleSnapshot</td>
    </tr>
  </tbody>
</table>
</div>



### Table 10 - Top 10 methods with highest effective line counts




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
      <th>fullPackageName</th>
      <th>maxLinesMethodType</th>
      <th>maxLinesMethodName</th>
      <th>maxLinesMethod</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.pooled</td>
      <td>Coordinator$CoordinationTask</td>
      <td>run</td>
      <td>70</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling</td>
      <td>TrackingEventProcessor</td>
      <td>processBatch</td>
      <td>64</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.commandhandling.gateway</td>
      <td>CommandGatewayFactory</td>
      <td>createGateway</td>
      <td>50</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-test-4.7.5</td>
      <td>org.axonframework.test.aggregate</td>
      <td>Reporter</td>
      <td>appendEventOverview</td>
      <td>45</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-configuration-4.7.5</td>
      <td>org.axonframework.config</td>
      <td>EventProcessingModule</td>
      <td>&lt;init&gt;</td>
      <td>42</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.deadline.quartz</td>
      <td>DeadlineJob</td>
      <td>execute</td>
      <td>42</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-modelling-4.7.5</td>
      <td>org.axonframework.modelling.saga.repository.jdbc</td>
      <td>JdbcSagaStore</td>
      <td>updateSaga</td>
      <td>38</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.queryhandling</td>
      <td>SimpleQueryBus</td>
      <td>doQuery</td>
      <td>36</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.deadletter</td>
      <td>InMemorySequencedDeadLetterQueue</td>
      <td>process</td>
      <td>33</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-disruptor-4.7.5</td>
      <td>org.axonframework.disruptor.commandhandling</td>
      <td>DisruptorCommandBus</td>
      <td>&lt;init&gt;</td>
      <td>32</td>
    </tr>
  </tbody>
</table>
</div>



### Table 11 - Top 10 methods with highest cyclomatic complexity




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
      <th>fullPackageName</th>
      <th>maxComplexityType</th>
      <th>maxComplexityMethod</th>
      <th>maxComplexity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.scheduling.job...</td>
      <td>JobRunrEventScheduler</td>
      <td>$deserializeLambda$</td>
      <td>40</td>
    </tr>
    <tr>
      <th>1</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling</td>
      <td>TrackingEventProcessor</td>
      <td>processBatch</td>
      <td>21</td>
    </tr>
    <tr>
      <th>2</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.pooled</td>
      <td>Coordinator$CoordinationTask</td>
      <td>run</td>
      <td>21</td>
    </tr>
    <tr>
      <th>3</th>
      <td>axon-modelling-4.7.5</td>
      <td>org.axonframework.modelling.saga.repository</td>
      <td>AssociationValueMap$AssociationValueComparator</td>
      <td>compare</td>
      <td>16</td>
    </tr>
    <tr>
      <th>4</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.eventhandling.deadletter.jpa</td>
      <td>DeadLetterEventEntry</td>
      <td>equals</td>
      <td>15</td>
    </tr>
    <tr>
      <th>5</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.messaging.annotation</td>
      <td>AnnotatedMessageHandlingMember</td>
      <td>handle</td>
      <td>14</td>
    </tr>
    <tr>
      <th>6</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.commandhandling.distributed....</td>
      <td>CommandNameFilter</td>
      <td>$deserializeLambda$</td>
      <td>13</td>
    </tr>
    <tr>
      <th>7</th>
      <td>axon-messaging-4.7.5</td>
      <td>org.axonframework.deadline.jobrunr</td>
      <td>JobRunrDeadlineManager</td>
      <td>$deserializeLambda$</td>
      <td>13</td>
    </tr>
    <tr>
      <th>8</th>
      <td>axon-eventsourcing-4.7.5</td>
      <td>org.axonframework.eventsourcing.eventstore</td>
      <td>ConcatenatingDomainEventStream</td>
      <td>hasNext</td>
      <td>13</td>
    </tr>
    <tr>
      <th>9</th>
      <td>axon-test-4.7.5</td>
      <td>org.axonframework.test.aggregate</td>
      <td>AggregateTestFixture</td>
      <td>ensureValuesEqual</td>
      <td>13</td>
    </tr>
  </tbody>
</table>
</div>


