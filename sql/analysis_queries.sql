-- AugBridge Commerce - analysis queries used in BRD section 5.1
-- Data: SIMULATED 12-week dataset (10,685 orders). Tables: see schema.sql.
-- Full dataset (in ../data/): augbridge_simulated.db (SQLite), or orders.csv and issues.csv.
-- sample_orders.csv only shows the format of the orders table (3 rows per week).
-- The results below are the actual output of each query on the full dataset.
-- BRD section 5.1 shows Q2 only, because Q2 returns both the weekly volume
-- and the overdue rate. Q1 and Q3 are kept here as supporting queries.
--
-- Labels (same as the BRD):
--   By design  = the result comes from a value set in the simulation
--   Downstream = calculated from values set in the simulation, but not set directly
-- None of these results is a real-world finding.

-- Q1. Weekly order volume (By design)
-- Supports: ~7x peak volume (week 10 = 2,750 orders vs 400/week average).
SELECT week_number,
       CASE WHEN is_peak_season = 1 THEN 'Peak' ELSE 'Normal' END AS season,
       COUNT(*) AS order_count
FROM orders
GROUP BY week_number
ORDER BY week_number;
-- Result:
--   week_number | season | order_count
--             1 | Normal |         380
--             2 | Normal |         410
--             3 | Normal |         395
--             4 | Normal |         420
--             5 | Normal |         430
--             6 | Normal |         460
--             7 | Normal |         520
--             8 | Peak   |         900
--             9 | Peak   |       1,900
--            10 | Peak   |       2,750
--            11 | Peak   |       1,600
--            12 | Normal |         520
-- Total 10,685 orders; weeks 8-11 hold 7,150 of them.

-- Q2. Overdue rate by week (Downstream)
-- Overdue = order-to-delivery time above 10 business days.
-- Context only: it includes internal, supplier and carrier time, which this
-- dataset cannot separate. It is not a target for the project.
SELECT week_number,
       COUNT(*) AS total_orders,
       SUM(is_overdue) AS overdue_orders,
       ROUND(100.0 * SUM(is_overdue) / COUNT(*), 1) AS overdue_rate_pct
FROM orders
GROUP BY week_number
ORDER BY week_number;
-- Result:
--   week_number | total_orders | overdue_orders | overdue_rate_pct
--             1 |          380 |             23 |              6.1
--             2 |          410 |             25 |              6.1
--             3 |          395 |             28 |              7.1
--             4 |          420 |             22 |              5.2
--             5 |          430 |             28 |              6.5
--             6 |          460 |             30 |              6.5
--             7 |          520 |             36 |              6.9
--             8 |          900 |            729 |             81.0
--             9 |        1,900 |          1,590 |             83.7
--            10 |        2,750 |          2,246 |             81.7
--            11 |        1,600 |          1,318 |             82.4
--            12 |          520 |             32 |              6.2
-- Normal weeks 5.2%-7.1%; peak weeks 81.0%-83.7%.
-- Week 8 (900 orders) = 81.0% and week 10 (2,750 orders) = 81.7%:
-- the rate follows the peak setting, not the number of orders.

-- Q3. Issue rate: peak vs normal weeks (By design)
-- Context only. It is not used as evidence in the BRD: the need for a shared
-- issue record (AP-10) comes from the process, not from this simulated rate.
SELECT CASE WHEN o.is_peak_season = 1 THEN 'Peak' ELSE 'Non-Peak' END AS season,
       COUNT(DISTINCT o.order_id) AS total_orders,
       COUNT(DISTINCT i.issue_id) AS issue_count,
       ROUND(100.0 * COUNT(DISTINCT i.issue_id) / COUNT(DISTINCT o.order_id), 2) AS issue_rate_pct
FROM orders o
LEFT JOIN issues i ON o.order_id = i.order_id
GROUP BY season;
-- Result:
--   season   | total_orders | issue_count | issue_rate_pct
--   Non-Peak |        3,535 |         156 |           4.41
--   Peak     |        7,150 |         637 |           8.91
