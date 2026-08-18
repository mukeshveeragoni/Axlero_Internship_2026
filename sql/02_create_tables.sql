-- =====================================================
-- MetricMind
-- Corporate Data Warehouse - Raw Table Definitions
-- =====================================================

-- -----------------------------------------------------
-- 1. REGIONS TABLE
-- -----------------------------------------------------


CREATE TABLE IF NOT EXISTS REGIONS (
    region_id      VARCHAR(10),
    region_name    VARCHAR(100),
    country        VARCHAR(100),
    continent      VARCHAR(50)
);


-- -----------------------------------------------------
-- 2. CUSTOMERS TABLE
-- -----------------------------------------------------

CREATE TABLE CUSTOMERS (
    customer_id      VARCHAR(10),
    customer_name    VARCHAR(200),
    customer_type    VARCHAR(50),
    region_id        VARCHAR(10),
    country          VARCHAR(100),
    signup_date      DATE
);


-- -----------------------------------------------------
-- 3. PRODUCTS TABLE
-- -----------------------------------------------------

CREATE TABLE PRODUCTS (
    product_id       VARCHAR(10),
    product_name     VARCHAR(200),
    category         VARCHAR(100),
    sub_category     VARCHAR(100),
    unit_cost        NUMBER(12,2),
    unit_price       NUMBER(12,2)
);


-- -----------------------------------------------------
-- 4. ORDERS TABLE
-- -----------------------------------------------------

CREATE TABLE ORDERS (
    order_id         VARCHAR(15),
    order_date       DATE,
    customer_id      VARCHAR(10),
    product_id       VARCHAR(10),
    region_id        VARCHAR(10),
    quantity         INTEGER,
    unit_price       NUMBER(12,2)
);


-- -----------------------------------------------------
-- 5. SALES TABLE
-- -----------------------------------------------------


CREATE TABLE SALES (
    sale_id          VARCHAR(15),
    order_id         VARCHAR(15),
    sale_date        DATE,
    revenue          NUMBER(14,2),
    sales_channel    VARCHAR(50)
);


-- -----------------------------------------------------
-- 6. COSTS TABLE
-- -----------------------------------------------------

CREATE TABLE COSTS (
    cost_id          VARCHAR(20),
    order_id         VARCHAR(15),
    cost_type        VARCHAR(50),
    cost_amount      NUMBER(14,2)
);
