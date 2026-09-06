-- =====================================================
-- MetricMind
-- Dimension and Fact Tables
-- SQLite
-- =====================================================


-- =====================================================
-- 1. CUSTOMER DIMENSION
-- =====================================================

DROP TABLE IF EXISTS DIM_CUSTOMER;

CREATE TABLE DIM_CUSTOMER AS
SELECT
    customer_id,
    customer_name,
    customer_type,
    region_id,
    country,
    signup_date
FROM CLEAN_CUSTOMERS;


-- =====================================================
-- 2. PRODUCT DIMENSION
-- =====================================================

DROP TABLE IF EXISTS DIM_PRODUCT;

CREATE TABLE DIM_PRODUCT AS
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    unit_cost,
    unit_price
FROM CLEAN_PRODUCTS;


-- =====================================================
-- 3. REGION DIMENSION
-- =====================================================

DROP TABLE IF EXISTS DIM_REGION;

CREATE TABLE DIM_REGION AS
SELECT
    region_id,
    region_name,
    country,
    continent
FROM CLEAN_REGIONS;


-- =====================================================
-- 4. SALES FACT
-- =====================================================

DROP TABLE IF EXISTS FACT_SALES;

CREATE TABLE FACT_SALES AS
SELECT
    s.sale_id,
    s.order_id,
    o.order_date,
    s.sale_date,

    o.customer_id,
    o.product_id,
    o.region_id,

    o.quantity,
    o.unit_price,

    s.revenue,

    ROUND(
        o.quantity * p.unit_cost,
        2
    ) AS total_cost,

    ROUND(
        s.revenue - (o.quantity * p.unit_cost),
        2
    ) AS gross_profit,

    s.sales_channel

FROM CLEAN_SALES s

JOIN CLEAN_ORDERS o
    ON s.order_id = o.order_id

JOIN CLEAN_PRODUCTS p
    ON o.product_id = p.product_id;


-- =====================================================
-- 5. COST FACT
-- =====================================================

DROP TABLE IF EXISTS FACT_COST;

CREATE TABLE FACT_COST AS
SELECT
    cost_id,
    order_id,
    cost_type,
    cost_amount
FROM CLEAN_COSTS;