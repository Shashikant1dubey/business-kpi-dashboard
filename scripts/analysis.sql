# Create Database:
CREATE DATABASE sales_project;
USE sales_project;

# Create Table:
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    row_id INT,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DOUBLE
);

-- ✅ Fix (clean, working approach):

-- ⚡ Step 1: Enable LOCAL INFILE on server
-- Login to MySQL:
-- mysql -u root -p
-- Then run:
-- SET GLOBAL local_infile = 1;
-- Check:
-- SHOW VARIABLES LIKE 'local_infile';
-- 👉 Should show:
-- ON

-- ⚡ Step 2: Enable it on client (VERY IMPORTANT)
-- Exit MySQL and reconnect like this:
-- mysql --local-infile=1 -u root -p
-- 👉 This is what most people miss

-- ⚡ Step 3: Run your query again
# Load the file
LOAD DATA LOCAL INFILE '/Users/shashikant/Documents/Job/Project/Business-KPI-Dashboard/data/processed/cleaned_sales.csv'
INTO TABLE sales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# For Error: 
-- SHOW WARNINGS LIMIT 20;

# To TRUNCATE the table
-- TRUNCATE TABLE sales_project.sales;

#To VERIFY data
SELECT * FROM sales LIMIT 10;

# COUNT total number of rows
SELECT COUNT(*) FROM sales_project.sales;


SELECT 
    COUNT(*) AS total_rows,
    COUNT(order_date) AS valid_dates,
    SUM(sales) AS total_sales
FROM sales;


USE sales_project;


-- --------- ----------- ----------- 

-- 📊 1. Total Sales (Basic KPI)
SELECT ROUND(SUM(sales), 2) AS total_sales
FROM sales;

-- 📊 2. Sales by Region (Business Insight)
SELECT 
    region,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY region
ORDER BY total_sales DESC;


-- 📊 3. Sales by Category
SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- 📊 4. Top 10 Products by Sales
SELECT 
    product_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- 📈 5. Monthly Sales Trend (VERY IMPORTANT)
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(sales), 2) AS monthly_sales
FROM sales
GROUP BY month
ORDER BY month;
-- 👉 This is used in Power BI line chart


-- 📊 6. Sales by Segment
SELECT 
    segment,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY segment
ORDER BY total_sales DESC;

-- 📊 7. Top 10 Customers (High Value Insight)
SELECT 
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- 📊 8. Sales by State (Geo Insight)
SELECT 
    state,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY state
ORDER BY total_sales DESC;

-- ⚡ 9. Average Order Value (ADVANCED KPI)
SELECT 
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM sales;

-- 🚀 10. Sales Contribution % by Category (TOP 1% QUERY)
SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(sales) * 100 / (SELECT SUM(sales) FROM sales), 2) AS contribution_percent
FROM sales
GROUP BY category
ORDER BY total_sales DESC;
-- 🔥 This is interview-level query;

-- 🧠 11. Yearly Growth (ADVANCED)
SELECT 
    YEAR(order_date) AS year,
    ROUND(SUM(sales), 2) AS yearly_sales
FROM sales
GROUP BY year
ORDER BY year;

-- 🔥 12. Shipping Delay Analysis (VERY IMPRESSIVE)
SELECT 
    AVG(DATEDIFF(ship_date, order_date)) AS avg_shipping_days
FROM sales;









