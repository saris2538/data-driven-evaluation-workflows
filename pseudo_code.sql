-- ============================================================
-- Infill Well Evaluation Workflow (Pseudo SQL)
-- Focus: data integration + simulation orchestration
-- All tables and values are illustrative
-- ============================================================

WITH candidates AS (
    SELECT
        candidate_id
    FROM infill_well_candidates
),

-- ------------------------------------------------------------
-- Step 2) Automated integration of multiple data sources
-- Includes sand-level lookup + well-level proxies (simulator inputs)
-- This integration step can be rerun whenever new reservoir data arrives,
-- ensuring that simulator inputs and downstream profit comparisons remain up to date.
-- ------------------------------------------------------------

integrated_inputs AS (
    SELECT
        c.candidate_id,

        -- Reservoir performance indicators
        r.pressure,
        r.water_cut,
        r.permeability,
        r.observation_date,

        -- Sand-level mapping (needed for sand-level revenue)
        s.sand_id,

        -- Well-level production proxies (also passed into simulator)
        w.well_depth,
        w.well_path          -- e.g., trajectory class / encoded representation

    FROM candidates c
    LEFT JOIN reservoir_indicators r
        ON c.candidate_id = r.candidate_id

    -- Lookup producing sands at the time the indicator was recorded
    LEFT JOIN producing_sands s
        ON c.candidate_id = s.candidate_id
       AND r.observation_date BETWEEN s.prod_start_date AND s.prod_end_date

    -- Well design / geometry proxies
    LEFT JOIN well_design_proxies w
        ON c.candidate_id = w.candidate_id

)

-- ============================================================
-- NOTE:
-- Rows in `integrated_inputs` are sent directly to an external
-- simulator via an API call.
--
-- The simulator computes sand-level revenue using:
-- - pressure, water_cut, permeability
-- - sand association (sand_id)
-- - well-level proxies (well_depth, well_path, etc.)
--
-- Simulator outputs are written back to the database.
-- ============================================================

, simulator_outputs AS (
    SELECT
        candidate_id,
        sand_id,
        sand_revenue
    FROM simulator_results
),

, well_revenue AS (
    SELECT
        candidate_id,
        SUM(sand_revenue) AS total_revenue
    FROM simulator_outputs
    GROUP BY candidate_id
),

-- ------------------------------------------------------------
-- Economic evaluation (cost derived from well-level proxies)
-- ------------------------------------------------------------

economic_evaluation AS (
    SELECT
        wr.candidate_id,
        wr.total_revenue,

        -- Cost derived from well-level proxies (example signature)
        cost_fn(w.well_depth, w.well_path) AS total_cost,

        -- Expected profit
        wr.total_revenue - cost_fn(w.well_depth, w.well_path) AS expected_profit

    FROM well_revenue wr
    LEFT JOIN well_design_proxies w
        ON wr.candidate_id = w.candidate_id
)

SELECT
    candidate_id,
    total_revenue,
    expected_profit
FROM economic_evaluation
ORDER BY expected_profit DESC;
