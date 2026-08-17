-- ============================================================
-- MetricMind - Insert Mock Data
-- SQLite Version
-- ============================================================


-- ============================================================
-- 1. REGIONS
-- ============================================================

INSERT INTO REGIONS
(region_id, region_name, country)
VALUES
('R01', 'South', 'India'),
('R02', 'North', 'India'),
('R03', 'East', 'India'),
('R04', 'West', 'India'),
('R05', 'Central', 'India');


-- ============================================================
-- 2. CUSTOMERS
-- ============================================================

INSERT INTO CUSTOMERS
(customer_id, customer_name, customer_type, region_id, country, signup_date)
VALUES
('C001', 'ABC Technologies', 'Enterprise', 'R01', 'India', '2025-01-10'),
('C002', 'Bright Solutions', 'SMB', 'R02', 'India', '2025-02-15'),
('C003', 'CloudWorks Pvt Ltd', 'Enterprise', 'R03', 'India', '2025-03-20'),
('C004', 'DataSphere Ltd', 'Enterprise', 'R04', 'India', '2025-04-12'),
('C005', 'Eagle Systems', 'SMB', 'R05', 'India', '2025-05-18'),
('C006', 'FutureTech', 'Enterprise', 'R01', 'India', '2025-06-25'),
('C007', 'Global Enterprises', 'Enterprise', 'R02', 'India', '2025-07-14'),
('C008', 'Innovate Solutions', 'SMB', 'R03', 'India', '2025-08-22'),
('C009', 'NextGen Corp', 'Enterprise', 'R04', 'India', '2025-09-10'),
('C010', 'Prime Industries', 'SMB', 'R05', 'India', '2025-10-05');


-- ============================================================
-- 3. PRODUCTS
-- ============================================================

INSERT INTO PRODUCTS
(product_id, product_name, category, sub_category, unit_cost, unit_price)
VALUES
('P001', 'Laptop', 'Electronics', 'Computers', 500.00, 750.00),
('P002', 'Wireless Mouse', 'Electronics', 'Accessories', 15.00, 30.00),
('P003', 'Mechanical Keyboard', 'Electronics', 'Accessories', 35.00, 70.00),
('P004', 'Office Chair', 'Furniture', 'Chairs', 100.00, 180.00),
('P005', 'Office Desk', 'Furniture', 'Desks', 180.00, 300.00),
('P006', '27 Inch Monitor', 'Electronics', 'Monitors', 180.00, 300.00),
('P007', 'USB-C Dock', 'Electronics', 'Accessories', 75.00, 140.00),
('P008', 'Laser Printer', 'Electronics', 'Printers', 200.00, 350.00),
('P009', 'Web Camera', 'Electronics', 'Cameras', 45.00, 90.00),
('P010', 'Headset', 'Electronics', 'Audio', 40.00, 80.00);


-- ============================================================
-- 4. ORDERS
-- ============================================================

INSERT INTO ORDERS
(order_id, order_date, customer_id, product_id, region_id, quantity, unit_price)
VALUES
('O001', '2026-01-05', 'C001', 'P001', 'R01', 5, 750.00),
('O002', '2026-01-08', 'C002', 'P002', 'R02', 20, 30.00),
('O003', '2026-01-12', 'C003', 'P006', 'R03', 10, 300.00),
('O004', '2026-01-15', 'C004', 'P004', 'R04', 15, 180.00),
('O005', '2026-01-18', 'C005', 'P003', 'R05', 25, 70.00),
('O006', '2026-01-22', 'C006', 'P008', 'R01', 12, 350.00),
('O007', '2026-02-02', 'C007', 'P005', 'R02', 6, 300.00),
('O008', '2026-02-07', 'C008', 'P009', 'R03', 15, 90.00),
('O009', '2026-02-11', 'C009', 'P007', 'R04', 18, 140.00),
('O010', '2026-02-16', 'C010', 'P010', 'R05', 30, 80.00),
('O011', '2026-02-20', 'C001', 'P006', 'R01', 7, 300.00),
('O012', '2026-02-25', 'C002', 'P001', 'R02', 4, 750.00);


-- ============================================================
-- 5. SALES
-- ============================================================

INSERT INTO SALES
(sale_id, order_id, sale_date, revenue, sales_channel)
VALUES
('S001', 'O001', '2026-01-05', 3750.00, 'Online'),
('S002', 'O002', '2026-01-08', 600.00, 'Retail'),
('S003', 'O003', '2026-01-12', 3000.00, 'Online'),
('S004', 'O004', '2026-01-15', 2700.00, 'Direct'),
('S005', 'O005', '2026-01-18', 1750.00, 'Online'),
('S006', 'O006', '2026-01-22', 4200.00, 'Direct'),
('S007', 'O007', '2026-02-02', 1800.00, 'Retail'),
('S008', 'O008', '2026-02-07', 1350.00, 'Online'),
('S009', 'O009', '2026-02-11', 2520.00, 'Direct'),
('S010', 'O010', '2026-02-16', 2400.00, 'Retail'),
('S011', 'O011', '2026-02-20', 2100.00, 'Online'),
('S012', 'O012', '2026-02-25', 3000.00, 'Direct');


-- ============================================================
-- 6. COSTS
-- ============================================================

INSERT INTO COSTS
(cost_id, order_id, cost_type, cost_amount)
VALUES
('CO001', 'O001', 'Product Cost', 2500.00),
('CO002', 'O002', 'Product Cost', 300.00),
('CO003', 'O003', 'Product Cost', 1800.00),
('CO004', 'O004', 'Product Cost', 1500.00),
('CO005', 'O005', 'Product Cost', 875.00),
('CO006', 'O006', 'Product Cost', 2400.00),
('CO007', 'O007', 'Product Cost', 1080.00),
('CO008', 'O008', 'Product Cost', 1200.00),
('CO009', 'O009', 'Product Cost', 1350.00),
('CO010', 'O010', 'Product Cost', 1200.00),
('CO011', 'O011', 'Product Cost', 1260.00),
('CO012', 'O012', 'Product Cost', 2000.00);