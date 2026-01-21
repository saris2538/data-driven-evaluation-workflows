# Sample Tables (Illustrative Only)

This document provides simplified example schemas and mock rows to illustrate how data
flows through the infill well evaluation workflow.

All tables and values are synthetic and intended only to demonstrate structure and logic.

---

## 1) infill_well_candidates

Defines the set of candidate wells to be evaluated.

| candidate_id |
|--------------|
| CAND_001     |
| CAND_002     |
| CAND_003     |

---

## 2) reservoir_indicators

Stores reservoir performance indicators measured or interpreted at specific times.
These indicators are **not directly linked to sand layers**.

| candidate_id | observation_date | pressure | water_cut | permeability |
|--------------|------------------|----------|-----------|--------------|
| CAND_001     | 2023-06-01       | 3200     | 0.35      | 150          |
| CAND_001     | 2023-07-01       | 3150     | 0.38      | 145          |
| CAND_002     | 2023-06-15       | 3400     | 0.25      | 180          |

---

## 3) producing_sands

Maps wells to sand layers that were producing during specific time windows.

This table is used to associate reservoir indicators with contributing sands
based on observation date.

| candidate_id | sand_id | prod_start_date | prod_end_date |
|--------------|---------|-----------------|---------------|
| CAND_001     | SAND_A  | 2023-01-01      | 2023-06-30    |
| CAND_001     | SAND_B  | 2023-07-01      | 2023-12-31    |
| CAND_002     | SAND_A  | 2023-01-01      | 2023-12-31    |

---

## 4) well_design_proxies

Contains well-level design and geometry attributes used as production proxies.
These proxies are passed into the simulator and are also used to derive cost terms.

| candidate_id | well_depth | well_path        |
|--------------|------------|------------------|
| CAND_001     | 10500      | long_horizontal  |
| CAND_002     | 9800       | medium_horizontal|
| CAND_003     | 8700       | deviated         |

Notes:
- `well_path` represents a categorical or encoded description of the well trajectory.
- Horizontal length and other geometry details are assumed to be embedded in `well_path`.

---

## 5) integrated_inputs (Derived Table)

This table is produced by joining the tables above.
Each row represents a reservoir indicator mapped to a contributing sand and enriched
with well-level proxies.

This table is sent directly to the external simulator via API.

| candidate_id | sand_id | observation_date | pressure | water_cut | permeability | well_depth | well_path |
|--------------|---------|------------------|----------|-----------|--------------|------------|-----------|
| CAND_001     | SAND_A  | 2023-06-01       | 3200     | 0.35      | 150          | 10500      | long_horizontal |
| CAND_001     | SAND_B  | 2023-07-01       | 3150     | 0.38      | 145          | 10500      | long_horizontal |
| CAND_002     | SAND_A  | 2023-06-15       | 3400     | 0.25      | 180          | 9800       | medium_horizontal |

---

## 6) simulator_results

Stores outputs returned by the external simulator.
Revenue is calculated at the **sand level**.

| candidate_id | sand_id | sand_revenue |
|--------------|---------|--------------|
| CAND_001     | SAND_A  | 1,200,000    |
| CAND_001     | SAND_B  |   850,000    |
| CAND_002     | SAND_A  | 1,500,000    |

---

## 7) economic_evaluation (Final Output)

Sand-level revenue is aggregated to the well level and combined with cost logic
derived from well-level proxies.

| candidate_id | total_revenue | expected_profit |
|--------------|---------------|-----------------|
| CAND_002     | 1,500,000     | 1,020,000       |
| CAND_001     | 2,050,000     |   980,000       |
| CAND_003     |      NULL     |      NULL       |

Notes:
- Cost is derived from well-level proxies such as `well_depth` and `well_path`.
- Candidates with insufficient data may appear with NULL values.
