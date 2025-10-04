##### Anomalies

This plot visualizes code units in a 2D space derived from the graph structure. Clusters are highlighted in light colors and shaded in grey. Top anomalies appear in red, while top non-anomalous code units are shown in green. Both groups are labeled by rank for easy identification. Light grey dots represent noise points that do not belong to any cluster.

* **Best for:** Understanding the overall distribution of anomalies in relation to clusters.
* **Adds:** Context of clusters and outliers.
* **Why:** Helps to see if anomalies are isolated or part of a cluster, which can inform investigation strategies.

![Anomalies](./{{deep_dive_directory}}/Anomalies.svg)

---

##### Global feature importance SHAP summary plots

With [SHAP](https://github.com/shap/shap) (Shapley Additive Explanations) we can explain the output of the anomaly detection model by ranking the global feature importance (mean absolute SHAP value) and visualizing the impact of each feature on the model output across all anomalies.

* **Best for:** Global understanding of which features drive anomalies.
* **Adds:** Direction of impact (color shows feature value).
* **Why:** Useful when you want to see how values push predictions toward normal or anomalous.

![Anomaly feature importance explained (global)](./{{deep_dive_directory}}/Anomaly_feature_importance_explained.svg)

---

##### Local feature importance SHAP force plots for top anomalies

Additionally to the global feature importance, we can also visualize the local feature importance for top individual anomalies using SHAP force plots. These plots show how each feature contributes to pushing the model output from the base value (average model output over the training dataset) to the model output for that specific anomaly.

* **Best for:** Explaining *why a specific data point* is anomalous.
* **Adds:** Visual breakdown of how each feature contributes to the score.
* **Why:** Highly interpretable for debugging single anomalies.

![Top 1 anomaly - local feature importance](./{{deep_dive_directory}}/Anomaly_1_shap_explanation.svg)
![Top 2 anomaly - local feature importance](./{{deep_dive_directory}}/Anomaly_2_shap_explanation.svg)
![Top 3 anomaly - local feature importance](./{{deep_dive_directory}}/Anomaly_3_shap_explanation.svg)
![Top 4 anomaly - local feature importance](./{{deep_dive_directory}}/Anomaly_4_shap_explanation.svg)
![Top 5 anomaly - local feature importance](./{{deep_dive_directory}}/Anomaly_5_shap_explanation.svg)
![Top 6 anomaly - local feature importance](./{{deep_dive_directory}}/Anomaly_6_shap_explanation.svg)

---

##### Feature dependence plots for top important features

These plots show how the value of a specific feature affects the anomaly score. Low (negative) y values indicate a high contribution to anomalousness, while high (positive) y values indicate a contribution to normality. Each point represents a code unit, colored by the value of another feature to show potential interactions. Plots the go from high to low mean that high feature values contribute to anomalousness more likely.

* **Best for:** Understanding how *one feature* affects anomaly scores.
* **Adds:** Color can show interaction with another feature.
* **Why:** Helps discover *nonlinear effects or interaction terms*.

![Anomaly feature dependence explained (global)](./{{deep_dive_directory}}/Anomaly_feature_dependence_explained.svg)

---
