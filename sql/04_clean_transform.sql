-- =====================================================
-- MetricMind
-- Data Cleaning and Transformation
-- SQLite
-- =====================================================


-- =====================================================
-- 1. CLEAN REGIONS
-- =====================================================

DROP TABLE IF EXISTS CLEAN_REGIONS;

CREATE TABLE CLEAN_REGIONS AS
SELECT
    TRIM(region_id) AS region_id,
    TRIM(region_name) AS region_name,
    TRIM(country) AS country,
    TRIM(continent) AS continent
FROM REGIONS
WHERE region_id IS NOT NULL
  AND TRIM(region_id) <> ''
  AND region_name IS NOT NULL
  AND TRIM(region_name) <> ''
  AND country IS NOT NULL
  AND TRIM(country) <> '';


-- =====================================================
-- 2. CLEAN CUSTOMERS
-- =====================================================

DROP TABLE IF EXISTS CLEAN_CUSTOMERS;

CREATE TABLE CLEAN_CUSTOMERS AS
SELECT
    TRIM(customer_id) AS customer_id,
    TRIM(customer_name) AS customer_name,
    TRIM(customer_type) AS customer_type,
    TRIM(region_id) AS region_id,
    TRIM(country) AS country,
    signup_date
FROM CUSTOMERS
WHERE customer_id IS NOT NULL
  AND TRIM(customer_id) <> ''
  AND customer_name IS NOT NULL
  AND TRIM(customer_name) <> ''
  AND region_id IS NOT NULL
  AND TRIM(region_id) <> '';


-- =====================================================
-- 3. CLEAN PRODUCTS
-- =====================================================

DROP TABLE IF EXISTS CLEAN_PRODUCTS;

CREATE TABLE CLEAN_PRODUCTS AS
SELECT
    TRIM(product_id) AS product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    TRIM(sub_category) AS sub_category,
    ROUND(unit_cost, 2) AS unit_cost,
    ROUND(unit_price, 2) AS unit_price
FROM PRODUCTS
WHERE product_id IS NOT NULL
  AND TRIM(product_id) <> ''
  AND product_name IS NOT NULL
  AND TRIM(product_name) <> ''
  AND category IS NOT NULL
  AND TRIM(category) <> ''
  AND unit_cost IS NOT NULL
  AND unit_cost > 0
  AND unit_price IS NOT NULL
  AND unit_price > 0;


-- =====================================================
-- 4. CLEAN ORDERS
-- =====================================================

DROP TABLE IF EXISTS CLEAN_ORDERS;

CREATE TABLE CLEAN_ORDERS AS
SELECT
    TRIM(order_id) AS order_id,
    order_date,
    TRIM(customer_id) AS customer_id,
    TRIM(product_id) AS product_id,
    TRIM(region_id) AS region_id,
    quantity,
    ROUND(unit_price, 2) AS unit_price,
    ROUND(quantity * unit_price, 2) AS order_value
FROM ORDERS
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


-- =====================================================
-- 5. CLEAN SALES
-- =====================================================

DROP TABLE IF EXISTS CLEAN_SALES;

CREATE TABLE CLEAN_SALES AS
SELECT
    TRIM(sale_id) AS sale_id,
    TRIM(order_id) AS order_id,
    sale_date,
    ROUND(revenue, 2) AS revenue,
    TRIM(sales_channel) AS sales_channel
FROM SALES
WHERE sale_id IS NOT NULL
  AND TRIM(sale_id) <> ''
  AND order_id IS NOT NULL
  AND sale_date IS NOT NULL
  AND revenue IS NOT NULL
  AND revenue > 0
  AND sales_channel IS NOT NULL
  AND TRIM(sales_channel) <> '';


-- =====================================================
-- 6. CLEAN COSTS
-- =====================================================

DROP TABLE IF EXISTS CLEAN_COSTS;

CREATE TABLE CLEAN_COSTS AS
SELECT
    TRIM(cost_id) AS cost_id,
    TRIM(order_id) AS order_id,
    TRIM(cost_type) AS cost_type,
    ROUND(cost_amount, 2) AS cost_amount
FROM COSTS
WHERE cost_id IS NOT NULL
  AND TRIM(cost_id) <> ''
  AND order_id IS NOT NULL
  AND cost_type IS NOT NULL
  AND TRIM(cost_type) <> ''
  AND cost_amount IS NOT NULL
  AND cost_amount > 0;


-- =====================================================
-- 7. CREATE CLEAN ORDER DETAILS
-- =====================================================

DROP TABLE IF EXISTS CLEAN_ORDER_DETAILS;

CREATE TABLE CLEAN_ORDER_DETAILS AS
SELECT
    o.order_id,
    o.order_date,

    o.customer_id,
    c.customer_name,
    c.customer_type,

    o.product_id,
    p.product_name,
    p.category,
    p.sub_category,

    o.region_id,
    r.region_name,
    r.country,
    r.continent,

    o.quantity,
    o.unit_price,

    ROUND(o.quantity * o.unit_price, 2) AS order_value,

    p.unit_cost,

    ROUND(
        o.quantity * p.unit_cost,
        2
    ) AS product_cost,

    ROUND(
        (o.quantity * o.unit_price)
        - (o.quantity * p.unit_cost),
        2
    ) AS gross_profit

FROM CLEAN_ORDERS o

LEFT JOIN CLEAN_CUSTOMERS c
    ON o.customer_id = c.customer_id

LEFT JOIN CLEAN_PRODUCTS p
    ON o.product_id = p.product_id

LEFT JOIN CLEAN_REGIONS r
    ON o.region_id = r.region_id;