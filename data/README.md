# Data

Simulated 12-week order dataset used for the evidence in [BRD §5.1](../docs/02-brd.md#51-sql-analysis-of-simulated-order-data). The queries are in [`sql/`](../sql).

> **Simulated data.** There is no central order database in the current process, so this dataset was created for the case study. It shows the problem as modeled. It does not prove what causes the delays, and none of the results is a real-world finding.

## Files

| File | What it is |
|---|---|
| `augbridge_simulated.db` | SQLite database with all four tables |
| `orders.csv` | The `orders` table (10,685 rows) |
| `issues.csv` | The `issues` table (793 rows) |
| `sample_orders.csv` | 36 sample rows (3 per week) that show the format of the `orders` table |

## Dataset at a glance

| Item | Value |
|---|---|
| Period | 12 weeks (order dates 2025-09-22 to 2025-12-14) |
| Peak season | Weeks 8–11 (7,150 of the 10,685 orders) |
| Shops | 6 |
| Suppliers | 3 |
| SKUs | 15 |
| Orders | 10,685 |
| Issues | 793 |

## Tables

Full definitions are in [`sql/schema.sql`](../sql/schema.sql).

**stores**

| Column | Type | Note |
|---|---|---|
| `store_id` | INTEGER, primary key | 1 to 6 (the 6 Etsy shops) |
| `store_name` | TEXT | |

**suppliers**

| Column | Type | Note |
|---|---|---|
| `supplier_id` | INTEGER, primary key | 1 to 3 |
| `supplier_name` | TEXT | |

**orders**

| Column | Type | Note |
|---|---|---|
| `order_id` | INTEGER, primary key | |
| `store_id` | INTEGER | Links to `stores` |
| `supplier_id` | INTEGER | Links to `suppliers` |
| `sku` | TEXT | One SKU per order in the simulation |
| `week_number` | INTEGER | 1 to 12 |
| `is_peak_season` | INTEGER | 1 = weeks 8 to 11, 0 = other weeks |
| `order_date` | TEXT | YYYY-MM-DD |
| `delivered_date` | TEXT | YYYY-MM-DD |
| `cycle_time_days` | INTEGER | Business days from order to delivery |
| `is_overdue` | INTEGER | 1 if `cycle_time_days` > 10, else 0 |

**issues**

| Column | Type | Note |
|---|---|---|
| `issue_id` | INTEGER, primary key | |
| `order_id` | INTEGER | Links to `orders` |
| `root_cause` | TEXT | `Design` or `Supplier` in the simulated data |
| `reported_date` | TEXT | YYYY-MM-DD |
| `resolved_date` | TEXT | YYYY-MM-DD |
| `resolution_days` | INTEGER | Days from reported to resolved |

## What the data cannot show

- It does not separate internal handling, supplier production, and carrier time.
- Supplier assignments were randomized, so it cannot be used to compare suppliers or estimate supplier workload.
- It is not evidence for SKU-shop or SKU-supplier relationships.
- This is not the To-Be data model. The To-Be model is in [FRD §7](../docs/03-frd.md#7-data-model).

## How to run the queries

With the SQLite command line, from the repository root:

```bash
sqlite3 data/augbridge_simulated.db < sql/analysis_queries.sql
```

Or open `augbridge_simulated.db` in a tool such as DB Browser for SQLite and paste a query from [`sql/analysis_queries.sql`](../sql/analysis_queries.sql). The expected output of each query is written under it in that file.
