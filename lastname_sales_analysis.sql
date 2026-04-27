-- ============================================================
--  Sales Territory Analysis
--  Capstone Project  ·  MySQL  ·  Data Storytelling/Excel
-- 	Northeast,South,East,West
--  Date: April 27, 2026
-- ============================================================

USE sample_sales;


-- ============================================================
-- Query 1 — Total Sales Revenue by Region
-- Business Question: 
-- What is total revenue overall for sales in the assigned territory, 
-- plus the start date and end date
-- Chart: Horizontal Bar Chart — region vs Total_Revenue
-- ============================================================

SELECT * FROM information_schema.key_column_usage
WHERE TABLE_NAME = 'management';

SELECT t2.region FROM store_locations AS t1
JOIN management AS t2 ON t1.state =t2.state
JOIN store_sales AS t3 ON t1.storeid = t3.store_id
JOIN online_sales AS t4 ON t3.prod_num = t4.prodnum
GROUP BY t2.region;

