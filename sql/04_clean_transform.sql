-- ============================================================
-- MetricMind
-- Corporate Data Warehouse
-- 04 - Clean and Transform Data
-- Snowflake Version
-- ============================================================


-- ============================================================
-- 1. CLEAN REGIONS
-- ============================================================

CREATE OR REPLACE TABLE STAGING.STG_REGIONS AS
SELECT
    TRIM(region_id)       AS region_id,
    TRIM(region_name)     AS region_name,
    TRIM(country)         AS country,
    TRIM(continent)       AS continent
FROM RAW.REGIONS
WHERE region_id IS NOT NULL
  AND TRIM(region_id) <> ''
  AND region_name IS NOT NULL
  AND country IS NOT NULL
  AND continent IS NOT NULL;


-- ============================================================
-- 2. CLEAN CUSTOMERS
-- ============================================================

CREATE OR REPLACE TABLE STAGING.STG_CUSTOMERS AS
SELECT
    TRIM(customer_id)     AS customer_id,
    TRIM(customer_name)   AS customer_name,
    TRIM(customer_type)   AS customer_type,
    TRIM(region_id)       AS region_id,
    TRIM(country)         AS country,
    signup_date
FROM RAW.CUSTOMERS
WHERE customer_id IS NOT NULL
  AND TRIM(customer_id) <> ''
  AND customer_name IS NOT NULL
  AND TRIM(customer_name) <> ''
  AND region_id IS NOT NULL;


-- ============================================================
-- 3. CLEAN PRODUCTS
-- ============================================================

CREATE OR REPLACE TABLE STAGING.STG_PRODUCTS AS
SELECT
    TRIM(product_id)      AS product_id,
    TRIM(product_name)    AS product_name,
    TRIM(category)        AS category,
    TRIM(sub_category)    AS sub_category,
    unit_cost,
    unit_price
FROM RAW.PRODUCTS
WHERE product_id IS NOT NULL
  AND TRIM(product_id) <> ''
  AND product_name IS NOT NULL
  AND TRIM(product_name) <> ''
  AND unit_cost IS NOT NULL
  AND unit_cost > 0
  AND unit_price IS NOT NULL
  AND unit_price > 0
  AND unit_price >= unit_cost;


-- ============================================================
-- 4. CLEAN ORDERS
-- ============================================================

CREATE OR REPLACE TABLE STAGING.STG_ORDERS AS
SELECT
    TRIM(order_id)        AS order_id,
    order_date,
    TRIM(customer_id)     AS customer_id,
    TRIM(product_id)      AS product_id,
    TRIM(region_id)       AS region_id,
    quantity,
    unit_price,
    quantity * unit_price AS order_value
FROM RAW.ORDERS
WHERE order_id IS NOT NULL
  AND TRIM(order_id) <> ''
  AND order_date IS NOT NULL
  AND customer_id IS NOT NULL
  AND product_id IS NOT NULL
  AND region_id IS NOT NULL
  AND quantity IS NOT NULL
  AND quantity > 0
  AND unit_price IS NOT NULL
  AND unit_price > 0;


-- ============================================================
-- 5. CLEAN SALES
-- ============================================================

CREATE OR REPLACE TABLE STAGING.STG_SALES AS
SELECT
    TRIM(sale_id)         AS sale_id,
    TRIM(order_id)        AS order_id,
    sale_date,
    revenue,
    TRIM(sales_channel)   AS sales_channel
FROM RAW.SALES
WHERE sale_id IS NOT NULL
  AND TRIM(sale_id) <> ''
  AND order_id IS NOT NULL
  AND sale_date IS NOT NULL
  AND revenue IS NOT NULL
  AND revenue > 0
  AND sales_channel IS NOT NULL
  AND TRIM(sales_channel) <> '';


-- ============================================================
-- 6. CLEAN COSTS
-- ============================================================

CREATE OR REPLACE TABLE STAGING.STG_COSTS AS
SELECT
    TRIM(cost_id)         AS cost_id,
    TRIM(order_id)        AS order_id,
    TRIM(cost_type)       AS cost_type,
    cost_amount
FROM RAW.COSTS
WHERE cost_id IS NOT NULL
  AND TRIM(cost_id) <> ''
  AND order_id IS NOT NULL
  AND cost_type IS NOT NULL
  AND TRIM(cost_type) <> ''
  AND cost_amount IS NOT NULL
  AND cost_amount > 0;


-- ============================================================
-- 7. ORDER + SALES TRANSFORMATION
-- ============================================================

CREATE OR REPLACE TABLE STAGING.STG_ORDER_SALES AS
SELECT
    o.order_id,
    s.sale_id,
    o.order_date,
    s.sale_date,
    o.customer_id,
    o.product_id,
    o.region_id,
    o.quantity,
    o.unit_price,
    o.order_value,
    s.revenue,
    s.sales_channel
FROM STAGING.STG_ORDERS o
INNER JOIN STAGING.STG_SALES s
    ON o.order_id = s.order_id;


-- ============================================================
-- 8. AGGREGATE ORDER COSTS
-- ============================================================

CREATE OR REPLACE TABLE STAGING.STG_ORDER_COSTS AS
SELECT
    order_id,
    SUM(cost_amount) AS total_cost
FROM STAGING.STG_COSTS
GROUP BY order_id;


-- ============================================================
-- 9. FINAL CLEAN SALES DATA
-- ============================================================

CREATE OR REPLACE TABLE STAGING.STG_FINAL_SALES AS
SELECT
    os.order_id,
    os.sale_id,
    os.order_date,
    os.sale_date,
    os.customer_id,
    os.product_id,
    os.region_id,
    os.quantity,
    os.unit_price,
    os.order_value,
    os.revenue,
    COALESCE(oc.total_cost, 0) AS total_cost,

    os.revenue - COALESCE(oc.total_cost, 0) AS gross_profit,

    CASE
        WHEN os.revenue > 0 THEN
            ROUND(
                (
                    (os.revenue - COALESCE(oc.total_cost, 0))
                    / os.revenue
                ) * 100,
                2
            )
        ELSE 0
    END AS profit_margin_pct,

    os.sales_channel

FROM STAGING.STG_ORDER_SALES os

LEFT JOIN STAGING.STG_ORDER_COSTS oc
    ON os.order_id = oc.order_id;


-- ============================================================
-- 10. VALIDATION OF TRANSFORMED DATA
-- ============================================================

SELECT *
FROM STAGING.STG_FINAL_SALES
ORDER BY sale_date, order_id;
