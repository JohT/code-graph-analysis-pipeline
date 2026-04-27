<!-- include:JavaReportFrontMatter.md -->

# ☕ Java Report

## 1. Overview

This report analyses the **Java codebase** loaded in the graph database. It covers:

- **Artifact dependencies** — which artifacts depend on which, and how widely internal dependencies are spread
- **Method metrics** — effective lines of method code per type and package, and the overall line count distribution
- **Java code quality** — annotation usage, deprecated element usages, and reflection usage
- **Web framework annotations** — Spring Web and Jakarta EE REST endpoint annotations

> **Reading the tables**: Rows are sorted by priority — the **first rows are the most critical**.  
> High dependency counts may indicate coupling hotspots.  
> Deprecated element usages should be migrated to their replacements.

## 📚 Table of Contents

1. [Overview](#1-overview)
1. [Artifact Dependencies](#2-artifact-dependencies)
1. [Method Metrics](#3-method-metrics)
1. [Java Code Quality](#4-java-code-quality)
1. [Web Framework Annotations](#5-web-framework-annotations)
1. [Duplicate Package Names](#6-duplicate-package-names)
1. [Dependency Spread](#7-dependency-spread)
1. [Glossary and Column Definitions](#8-glossary-and-column-definitions)

---

## 2. Artifact Dependencies

Shows direct dependency relationships between Maven artifacts (JARs). High incoming dependency counts indicate central, widely-used modules. High outgoing dependency counts indicate modules that depend on many others.

### 2.1 Incoming Artifact Dependencies

<!-- include:IncomingDependencies.md|report_no_java_data.template.md -->

### 2.2 Outgoing Artifact Dependencies

<!-- include:OutgoingDependencies.md|report_no_java_data.template.md -->

### 2.3 Most Used Internal Dependencies

<!-- include:MostUsedDependenciesAcrossArtifacts.md|report_no_java_data.template.md -->

### 2.4 All Artifact Dependencies

<!-- include:DependenciesAcrossArtifacts.md|report_no_java_data.template.md -->

### 2.5 Artifact Dependency Charts

<!-- include:ArtifactDependenciesCharts.md|empty.md -->

---

## 3. Method Metrics

Summarises the effective lines of method code (LOC) across types and packages. High values highlight the most complex or largest parts of the codebase.

### 3.1 Effective Method Line Count Distribution

<!-- include:EffectiveMethodLineCountDistribution.md|report_no_java_data.template.md -->

### 3.2 Top Types by Effective LOC

<!-- include:EffectiveLinesOfMethodCodePerType.md|report_no_java_data.template.md -->

### 3.3 Top Packages by Effective LOC

<!-- include:EffectiveLinesOfMethodCodePerPackage.md|report_no_java_data.template.md -->

### 3.4 Method Metrics Charts

<!-- include:MethodMetricsCharts.md|empty.md -->

---

## 4. Java Code Quality

Highlights annotations used across the codebase, deprecated API usages, and reflection calls that may be fragile or hard to analyse statically.

### 4.1 Annotated Code Elements

<!-- include:AnnotatedCodeElements.md|report_no_java_data.template.md -->

### 4.2 Annotated Code Elements per Artifact

<!-- include:AnnotatedCodeElementsPerArtifact.md|report_no_java_data.template.md -->

### 4.3 Deprecated Element Usages

<!-- include:DeprecatedElementUsage.md|empty.md -->

### 4.4 Reflection Usages

<!-- include:ReflectionUsage.md|empty.md -->

### 4.5 Java Code Quality Charts

<!-- include:JavaCodeQualityCharts.md|empty.md -->

---

## 5. Web Framework Annotations

Lists methods annotated with HTTP mapping annotations from Spring Web and Jakarta EE REST. These are the declared REST endpoints of the application.

### 5.1 Spring Web Request Annotations

<!-- include:SpringWebRequestAnnotations.md|empty.md -->

### 5.2 Jakarta EE REST Annotations

<!-- include:JakartaEE_REST_Annotations.md|empty.md -->

### 5.3 Web Framework Charts

<!-- include:WebFrameworksCharts.md|empty.md -->

---

## 6. Duplicate Package Names

Package names that appear in more than one artifact. Duplicate packages can cause split-package issues on the module path and often indicate unintended copying of code.

<!-- include:DuplicatePackageNamesAcrossArtifacts.md|empty.md -->

---

## 7. Dependency Spread

Shows how many distinct artifacts each internal module is depended on by (spread), and vice versa. Highly spread dependencies are critical infrastructure modules.

### 7.1 Spread per Dependency (most used by others)

<!-- include:InternalArtifactUsageSpreadPerDependency.md|empty.md -->

### 7.2 Spread per Dependent (depends on most others)

<!-- include:InternalArtifactUsageSpreadPerDependent.md|empty.md -->

---

## 8. Glossary and Column Definitions

| Term | Definition |
|------|-----------|
| `a.fileName` | File path of the artifact (JAR/WAR/EAR) |
| `incomingDependencies` | Number of other artifacts that depend on this artifact |
| `outgoingDependencies` | Number of artifacts this artifact depends on |
| `dependency` | Name of an internal artifact that others depend upon |
| `usedByPackages` | Number of distinct packages depending on this artifact |
| `dependencyArtifactName` | Name of the dependency artifact in a spread analysis |
| `usedInArtifacts` | Number of distinct artifacts using this dependency (spread) |
| `artifactDependencies` | Number of distinct dependency artifacts used by this artifact (spread) |
| `effectiveLineCount` | Effective line count of a method (non-blank, non-comment lines) |
| `methods` | Number of methods at a given effective line count |
| `typeName` | Simple name of a Java class, interface, enum, or annotation type |
| `packageName` | Simple (last-segment) name of a Java package |
| `fullPackageName` | Fully qualified name of a Java package |
| `sumEffectiveLinesOfMethodCode` | Sum of effective lines of method code in a type |
| `linesInPackage` | Sum of effective lines of method code across all methods in a package |
| `annotationName` | Fully qualified name of a Java annotation type |
| `languageElement` | Kind of code element annotated (Class, Method, Field, Type, Parameter, etc.) |
| `numberOfAnnotatedElements` | Count of distinct elements annotated with a particular annotation |
| `artifactName` | Name of the Maven artifact (JAR/WAR/EAR) |
| `deprecatedElement` | Kind of deprecated code element (Class, Method, Field, etc.) |
| `numberOfElementsUsingDeprecatedElements` | Count of distinct non-deprecated elements using a deprecated element |
| `httpMethod` | HTTP method or mapping annotation (e.g., GET, POST, RequestMapping) |
