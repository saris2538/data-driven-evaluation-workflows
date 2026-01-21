# Data-Driven Infill Well Evaluation (Methodology Demo)

This repository demonstrates a data-driven workflow for infill well evaluation, focusing on how
multiple technical and economic data sources can be integrated and automated into a single,
consistent evaluation process.

The project revolutionizes infill well evaluation by developing a single, user-friendly platform
that processes the latest reservoir data into automated economic analysis.
By eliminating manual data cross-referencing and cumbersome workflows, this approach dramatically
reduces evaluation time, establishes a standardized workflow for reserves estimation, and empowers
engineers to focus on high-value production optimization activities.

All data and examples in this repository are synthetic and used purely for illustration.

---

## What This Repo Shows

This repo focuses on **workflow logic and system design**, not domain-specific results.

It demonstrates:
- how fragmented production and reservoir data sources are integrated automatically,
- how reservoir performance indicators are continuously updated,
- how these indicators are sent directly to a simulator,
- and how candidates are compared using up-to-date expected profit.

The goal is to make the system understandable even to readers outside the petroleum domain.

---

## High-Level Workflow

At a high level, the evaluation automates the transformation of raw data into
comparable economic outcomes for candidate infill wells.

reservoir_indicators  
+  
producing_sands  
+  
well_design_proxies  
↓  
integrated_inputs  
↓  
simulator (API)  
↓  
sand_level_revenue  
↓  
well_level_revenue  
↓  
expected_profit

The detailed logic is documented in:
- [`workflow_overview.md`](workflow_overview.md)
- [`pseudo_code.sql`](pseudo_code.sql)

---

## Automated Integration of Multiple Data Sources

In practice, production and reservoir data are continuously updated as new measurements,
interpretations, and operational data become available.

This workflow automates the integration of multiple data sources so that:
- the **latest reservoir performance indicators** are always reflected,
- updated data is immediately aligned to the correct candidate wells and producing sands,
- and refreshed inputs can be sent directly to the simulator without manual intervention.

As a result, the simulator always evaluates candidates using the most current information,
producing **real-time revenue and profit estimates**.

This ensures that comparisons between infill well candidates remain **current and consistent**,
even as underlying data changes over time.

---

## Scope and Limitations

- This repository does **not** contain real field data.
- All schemas, variable names, and values are simplified.
- The focus is on system structure, data flow, and automation logic rather than numerical accuracy.

This makes the repo suitable as a reference for:
- data integration pipelines,
- simulation-driven evaluation workflows,
- and decision-support system design.
