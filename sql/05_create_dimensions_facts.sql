-- ============================================================
-- MetricMind
-- Corporate Data Warehouse
-- 05 - Create Dimension and Fact Tables
-- Snowflake Version
-- ============================================================


-- ============================================================
-- 1. DIM DATE
-- ============================================================

CREATE OR REPLACE TABLE DIM_DATE AS
SELECT DISTINCT
    TO_NUMBER(TO_CHAR(sale_date, 'YYYYMMDD')) AS date_key,
    sale_date AS full_date,
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    MONTHNAME(sale_date) AS month_name,
    QUARTER(sale_date) AS quarter,
    DAY(sale_date) AS day
FROM STG_FINAL_SALES;


-- ============================================================
-- 2. DIM REGION
-- ============================================================

CREATE OR REPLACE TABLE DIM_REGION AS
SELECT
    ROW_NUMBER() OVER (ORDER BY region_id) AS region_key,
    region_id,
    region_name,
    country,
    continent
FROM STG_REGIONS;


-- ============================================================
-- 3. DIM CUSTOMER
-- ============================================================

CREATE OR REPLACE TABLE DIM_CUSTOMER AS
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,
    customer_id,
    customer_name,
    customer_type,
    region_id,
    country,
    signup_date
FROM STG_CUSTOMERS;


-- ============================================================
-- 4. DIM PRODUCT
-- ============================================================

CREATE OR REPLACE TABLE DIM_PRODUCT AS
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
    product_id,
    product_name,
    category,
    sub_category,
    unit_cost,
    unit_price
FROM STG_PRODUCTS;


-- ============================================================
-- 5. FACT SALES
-- ============================================================

CREATE OR REPLACE TABLE FACT_SALES AS
SELECT
    s.order_id,
    s.sale_id,

    d.date_key,

    c.customer_key,
    p.product_key,
    r.region_key,

    s.quantity,
    s.unit_price,
    s.revenue,
    s.total_cost,
    s.gross_profit,
    s.profit_margin_pct,
    s.sales_channel

FROM STG_FINAL_SALES s

LEFT JOIN DIM_DATE d
    ON s.sale_date = d.full_date

LEFT JOIN DIM_CUSTOMER c
    ON s.customer_id = c.customer_id

LEFT JOIN DIM_PRODUCT p
    ON s.product_id = p.product_id

LEFT JOIN DIM_REGION r
    ON s.region_id = r.region_id;
