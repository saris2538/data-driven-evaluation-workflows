# Workflow Overview

This document describes a data-driven workflow for evaluating infill well candidates by
automating data integration and economic analysis.

The workflow is designed to replace manual, spreadsheet-based evaluation with a consistent
and repeatable process, while remaining flexible enough to incorporate simulation-based
performance modeling.

---

## 1) Infill Well Candidates

The evaluation starts with a set of **infill well candidates**.

Each candidate represents a potential well to be evaluated and compared.
All candidates are identified by a unique `candidate_id` and are processed uniformly.

---

## 2) Automated Integration of Multiple Data Sources

For each candidate well, relevant inputs are gathered by integrating multiple data sources.

These sources typically include:
- reservoir performance indicators (e.g., pressure, water cut, permeability),
- well-design proxies (e.g., well depth, well path / trajectory),
- and metadata required to align performance indicators with producing intervals.

A key challenge in this step is that existing reservoir performance indicator databases
lack direct links to contributing sand layers. As a result, integration requires additional
lookup logic to determine which sand layers were actively producing at the time each
performance indicator was recorded.

The integration is automated using database joins so that all relevant inputs for a candidate
are aligned into a single table that can be sent directly to the simulator.

Because these source datasets are continuously updated over time, automation ensures that
the most recent reservoir performance indicators are always integrated and ready for simulation,
without manual rework.

---

## 3) Simulation-Based Revenue Calculation

Integrated inputs are sent to an external simulator through an API call.

The simulator uses:
- reservoir performance indicators (pressure, water cut, permeability) and their sand associations,
- plus well-level production proxies (e.g., depth and well path),

to compute sand-level revenue for each contributing sand.

The workflow then aggregates revenue across all producing sands to obtain total revenue for each
candidate well.

Production proxies are included as simulator inputs but are not broken down by sand.

The simulator focuses solely on technical performance and revenue generation; cost and profit calculations are handled separately in the economic evaluation step.

---

## 4) Economic Evaluation

Total revenue returned by the simulator is combined with cost logic to compute expected profit.

Cost terms (e.g., base cost, complexity adjustments) are derived from well-level proxies and applied
at the well level.

The resulting expected profit provides a single, comparable metric for evaluating and ranking infill
well candidates.

This step replaces manual spreadsheet-based economic analysis with a consistent calculation flow.

---

## 5) Outputs

The final output is a structured evaluation table containing:
- one row per candidate well,
- expected revenue,
- and expected profit

These outputs are designed to be easily reviewed, visualized, or exported for downstream use.
