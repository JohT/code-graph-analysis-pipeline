# Documentation for Anomaly Detection Domain

This directory contains resources and documentation related to the Anomaly Detection domain within the Code Graph Analysis Pipeline project.

## Generate Architecture Diagram

To generate the architecture diagram for the Anomaly Detection domain, you can use the [renderArchitecture.sh](./renderArchitecture.sh) script in this directory. It utilizes Graphviz to create a visual representations of the anomaly detection pipeline architecture described in [Architecture.gv](./Architecture.gv) to render a SVG file.

The generated SVG file will also be added to the summary report Appendix section.

:warning: Currently, the architecture description in `Architecture.gv` is manually maintained. The same applies to the SVG file, that needs to be regenerated manually when changes are made to the `.gv` file.
