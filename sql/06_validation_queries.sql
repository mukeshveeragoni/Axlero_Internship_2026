-- =====================================================
-- MetricMind
-- Data Quality and Validation Queries
-- =====================================================


-- =====================================================
-- 1. CUSTOMER VALIDATION
-- =====================================================

-- 1.1 Check for missing customer IDs
SELECT *
FROM CUSTOMERS
WHERE customer_id IS NULL
   OR TRIM(customer_id) = '';


-- 1.2 Check for missing customer names
SELECT *
FROM CUSTOMERS
WHERE customer_name IS NULL
   OR TRIM(customer_name) = '';


-- 1.3 Check for duplicate customer IDs
SELECT customer_id, COUNT(*) AS duplicate_count
FROM CUSTOMERS
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 1.4 Check for customers with invalid region IDs
SELECT c.*
FROM CUSTOMERS c
LEFT JOIN REGIONS r
    ON c.region_id = r.region_id
WHERE r.region_id IS NULL;


-- =====================================================
-- 2. PRODUCT VALIDATION
-- =====================================================

-- 2.1 Check for duplicate product IDs
SELECT product_id, COUNT(*) AS duplicate_count
FROM PRODUCTS
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 2.2 Check for missing product information
SELECT *
FROM PRODUCTS
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL;


-- 2.3 Check for invalid product costs
SELECT *
FROM PRODUCTS
WHERE unit_cost IS NULL
   OR unit_cost <= 0;


-- 2.4 Check for invalid selling prices
SELECT *
FROM PRODUCTS
WHERE unit_price IS NULL
   OR unit_price <= 0;


-- 2.5 Check where selling price is less than cost
SELECT *
FROM PRODUCTS
WHERE unit_price < unit_cost;


-- =====================================================
-- 3. REGION VALIDATION
-- =====================================================

-- 3.1 Check for duplicate region IDs
SELECT region_id, COUNT(*) AS duplicate_count
FROM REGIONS
GROUP BY region_id
HAVING COUNT(*) > 1;


-- 3.2 Check for missing region information
SELECT *
FROM REGIONS
WHERE region_id IS NULL
   OR region_name IS NULL
   OR country IS NULL
   OR continent IS NULL;


-- =====================================================
-- 4. ORDER VALIDATION
-- =====================================================

-- 4.1 Check for duplicate order IDs
SELECT order_id, COUNT(*) AS duplicate_count
FROM ORDERS
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 4.2 Check for missing order information
SELECT *
FROM ORDERS
WHERE order_id IS NULL
   OR order_date IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL
   OR region_id IS NULL;


-- 4.3 Check for orders with invalid customer IDs
SELECT o.*
FROM ORDERS o
LEFT JOIN CUSTOMERS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 4.4 Check for orders with invalid product IDs
SELECT o.*
FROM ORDERS o
LEFT JOIN PRODUCTS p
    ON o.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 4.5 Check for orders with invalid region IDs
SELECT o.*
FROM ORDERS o
LEFT JOIN REGIONS r
    ON o.region_id = r.region_id
WHERE r.region_id IS NULL;


-- 4.6 Check for invalid quantities
SELECT *
FROM ORDERS
WHERE quantity IS NULL
   OR quantity <= 0;


-- 4.7 Check for invalid order prices
SELECT *
FROM ORDERS
WHERE unit_price IS NULL
   OR unit_price <= 0;


-- =====================================================
-- 5. SALES VALIDATION
-- =====================================================

-- 5.1 Check for duplicate sale IDs
SELECT sale_id, COUNT(*) AS duplicate_count
FROM SALES
GROUP BY sale_id
HAVING COUNT(*) > 1;


-- 5.2 Check for missing sales information
SELECT *
FROM SALES
WHERE sale_id IS NULL
   OR order_id IS NULL
   OR sale_date IS NULL
   OR revenue IS NULL
   OR sales_channel IS NULL;


-- 5.3 Check for sales with invalid order IDs
SELECT s.*
FROM SALES s
LEFT JOIN ORDERS o
    ON s.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 5.4 Check for invalid revenue
SELECT *
FROM SALES
WHERE revenue IS NULL
   OR revenue <= 0;


-- 5.5 Check whether sales revenue matches order value
SELECT
    s.sale_id,
    s.order_id,
    s.revenue,
    (o.quantity * o.unit_price) AS expected_revenue
FROM SALES s
JOIN ORDERS o
    ON s.order_id = o.order_id
WHERE s.revenue <> (o.quantity * o.unit_price);


-- =====================================================
-- 6. COST VALIDATION
-- =====================================================

-- 6.1 Check for duplicate cost IDs
SELECT cost_id, COUNT(*) AS duplicate_count
FROM COSTS
GROUP BY cost_id
HAVING COUNT(*) > 1;


-- 6.2 Check for missing cost information
SELECT *
FROM COSTS
WHERE cost_id IS NULL
   OR order_id IS NULL
   OR cost_type IS NULL
   OR cost_amount IS NULL;


-- 6.3 Check for costs with invalid order IDs
SELECT c.*
FROM COSTS c
LEFT JOIN ORDERS o
    ON c.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 6.4 Check for invalid cost amounts
SELECT *
FROM COSTS
WHERE cost_amount IS NULL
   OR cost_amount <= 0;