-- AugBridge Commerce - schema of the SIMULATED analysis dataset (SQLite)
-- Used only for the evidence in BRD section 5.1 (queries in analysis_queries.sql).
-- This is NOT the To-Be data model. The To-Be model (Product Type, Product/SKU, Order,
-- Order Line, Supplier, Supplier Mapping, Exception, Issue Case) is in FRD section 7.
-- The dataset is simulated, so it is not evidence for SKU-shop or SKU-supplier relationships.
-- Full dataset: 12 weeks, 6 shops, 3 suppliers, 15 SKUs, 10,685 orders (Simulated).
-- Files (in ../data/): augbridge_simulated.db (SQLite, all four tables), orders.csv, issues.csv.

CREATE TABLE stores (
    store_id      INTEGER PRIMARY KEY,      -- 1 to 6 (the 6 Etsy shops)
    store_name    TEXT NOT NULL
);

CREATE TABLE suppliers (
    supplier_id   INTEGER PRIMARY KEY,      -- 1 to 3
    supplier_name TEXT NOT NULL
);

CREATE TABLE orders (
    order_id        INTEGER PRIMARY KEY,
    store_id        INTEGER NOT NULL REFERENCES stores(store_id),
    supplier_id     INTEGER NOT NULL REFERENCES suppliers(supplier_id),
    sku             TEXT    NOT NULL,       -- one SKU per order in the simulation
    week_number     INTEGER NOT NULL,       -- 1 to 12
    is_peak_season  INTEGER NOT NULL,       -- 1 = weeks 8 to 11, 0 = other weeks
    order_date      TEXT    NOT NULL,       -- YYYY-MM-DD
    delivered_date  TEXT,                   -- YYYY-MM-DD
    cycle_time_days INTEGER,                -- business days from order to delivery
    is_overdue      INTEGER NOT NULL        -- 1 if cycle_time_days > 10, else 0
);

CREATE TABLE issues (
    issue_id        INTEGER PRIMARY KEY,
    order_id        INTEGER NOT NULL REFERENCES orders(order_id),
    root_cause      TEXT    NOT NULL,       -- 'Design' or 'Supplier' in the simulated data
    reported_date   TEXT    NOT NULL,
    resolved_date   TEXT,
    resolution_days INTEGER                 -- days from reported to resolved
);
