-- ============================================================
-- MetricMind
-- Corporate Data Warehouse
-- 06 - Data Quality and Validation Queries
-- Snowflake Version
-- ============================================================


-- ============================================================
-- 1. RAW - REGION VALIDATION
-- ============================================================

-- 1.1 Duplicate region IDs
SELECT
    region_id,
    COUNT(*) AS duplicate_count
FROM RAW.REGIONS
GROUP BY region_id
HAVING COUNT(*) > 1;


-- 1.2 Missing region information
SELECT *
FROM RAW.REGIONS
WHERE region_id IS NULL
   OR region_name IS NULL
   OR country IS NULL
   OR continent IS NULL;


-- ============================================================
-- 2. RAW - CUSTOMER VALIDATION
-- ============================================================

-- 2.1 Missing customer IDs
SELECT *
FROM RAW.CUSTOMERS
WHERE customer_id IS NULL
   OR TRIM(customer_id) = '';


-- 2.2 Missing customer names
SELECT *
FROM RAW.CUSTOMERS
WHERE customer_name IS NULL
   OR TRIM(customer_name) = '';


-- 2.3 Duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM RAW.CUSTOMERS
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 2.4 Invalid region IDs
SELECT c.*
FROM RAW.CUSTOMERS c
LEFT JOIN RAW.REGIONS r
    ON c.region_id = r.region_id
WHERE r.region_id IS NULL;


-- ============================================================
-- 3. RAW - PRODUCT VALIDATION
-- ============================================================

-- 3.1 Duplicate product IDs
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM RAW.PRODUCTS
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 3.2 Missing product information
SELECT *
FROM RAW.PRODUCTS
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL;


-- 3.3 Invalid product costs
SELECT *
FROM RAW.PRODUCTS
WHERE unit_cost IS NULL
   OR unit_cost <= 0;


-- 3.4 Invalid selling prices
SELECT *
FROM RAW.PRODUCTS
WHERE unit_price IS NULL
   OR unit_price <= 0;


-- 3.5 Selling price lower than cost
SELECT *
FROM RAW.PRODUCTS
WHERE unit_price < unit_cost;


-- ============================================================
-- 4. RAW - ORDER VALIDATION
-- ============================================================

-- 4.1 Duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM RAW.ORDERS
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 4.2 Missing order information
SELECT *
FROM RAW.ORDERS
WHERE order_id IS NULL
   OR order_date IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL
   OR region_id IS NULL;


-- 4.3 Invalid customer IDs
SELECT o.*
FROM RAW.ORDERS o
LEFT JOIN RAW.CUSTOMERS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 4.4 Invalid product IDs
SELECT o.*
FROM RAW.ORDERS o
LEFT JOIN RAW.PRODUCTS p
    ON o.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 4.5 Invalid region IDs
SELECT o.*
FROM RAW.ORDERS o
LEFT JOIN RAW.REGIONS r
    ON o.region_id = r.region_id
WHERE r.region_id IS NULL;


-- 4.6 Invalid quantities
SELECT *
FROM RAW.ORDERS
WHERE quantity IS NULL
   OR quantity <= 0;


-- 4.7 Invalid order prices
SELECT *
FROM RAW.ORDERS
WHERE unit_price IS NULL
   OR unit_price <= 0;


-- ============================================================
-- 5. RAW - SALES VALIDATION
-- ============================================================

-- 5.1 Duplicate sale IDs
SELECT
    sale_id,
    COUNT(*) AS duplicate_count
FROM RAW.SALES
GROUP BY sale_id
HAVING COUNT(*) > 1;


-- 5.2 Missing sales information
SELECT *
FROM RAW.SALES
WHERE sale_id IS NULL
   OR order_id IS NULL
   OR sale_date IS NULL
   OR revenue IS NULL
   OR sales_channel IS NULL;


-- 5.3 Invalid order IDs
SELECT s.*
FROM RAW.SALES s
LEFT JOIN RAW.ORDERS o
    ON s.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 5.4 Invalid revenue
SELECT *
FROM RAW.SALES
WHERE revenue IS NULL
   OR revenue <= 0;


-- 5.5 Revenue consistency check
SELECT
    s.sale_id,
    s.order_id,
    s.revenue,
    o.quantity * o.unit_price AS expected_revenue
FROM RAW.SALES s
JOIN RAW.ORDERS o
    ON s.order_id = o.order_id
WHERE s.revenue <> (o.quantity * o.unit_price);


-- ============================================================
-- 6. RAW - COST VALIDATION
-- ============================================================

-- 6.1 Duplicate cost IDs
SELECT
    cost_id,
    COUNT(*) AS duplicate_count
FROM RAW.COSTS
GROUP BY cost_id
HAVING COUNT(*) > 1;


-- 6.2 Missing cost information
SELECT *
FROM RAW.COSTS
WHERE cost_id IS NULL
   OR order_id IS NULL
   OR cost_type IS NULL
   OR cost_amount IS NULL;


-- 6.3 Invalid order IDs
SELECT c.*
FROM RAW.COSTS c
LEFT JOIN RAW.ORDERS o
    ON c.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 6.4 Invalid cost amounts
SELECT *
FROM RAW.COSTS
WHERE cost_amount IS NULL
   OR cost_amount <= 0;


-- ============================================================
-- 7. STAGING VALIDATION
-- ============================================================

-- Check final transformed sales
SELECT *
FROM STAGING.STG_FINAL_SALES
ORDER BY sale_date, order_id;


-- Check negative gross profit
SELECT *
FROM STAGING.STG_FINAL_SALES
WHERE gross_profit < 0;


-- Check invalid profit margin
SELECT *
FROM STAGING.STG_FINAL_SALES
WHERE profit_margin_pct < 0
   OR profit_margin_pct > 100;


-- ============================================================
-- 8. WAREHOUSE VALIDATION
-- ============================================================

-- Check dimension counts
SELECT 'DIM_DATE' AS table_name, COUNT(*) AS row_count
FROM WAREHOUSE.DIM_DATE

UNION ALL

SELECT 'DIM_REGION', COUNT(*)
FROM WAREHOUSE.DIM_REGION

UNION ALL

SELECT 'DIM_CUSTOMER', COUNT(*)
FROM WAREHOUSE.DIM_CUSTOMER

UNION ALL

SELECT 'DIM_PRODUCT', COUNT(*)
FROM WAREHOUSE.DIM_PRODUCT

UNION ALL

SELECT 'FACT_SALES', COUNT(*)
FROM WAREHOUSE.FACT_SALES;


-- ============================================================
-- 9. FACT TABLE - ORPHAN KEY CHECK
-- ============================================================

SELECT *
FROM WAREHOUSE.FACT_SALES
WHERE customer_key IS NULL
   OR product_key IS NULL
   OR region_key IS NULL
   OR date_key IS NULL;


-- ============================================================
-- 10. FACT SALES - BASIC KPI CHECK
-- ============================================================

SELECT
    COUNT(*) AS total_sales,
    SUM(quantity) AS total_quantity,
    SUM(revenue) AS total_revenue,
    SUM(total_cost) AS total_cost,
    SUM(gross_profit) AS total_gross_profit,
    ROUND(
        (SUM(gross_profit) / NULLIF(SUM(revenue), 0)) * 100,
        2
    ) AS overall_profit_margin_pct
FROM WAREHOUSE.FACT_SALES;
