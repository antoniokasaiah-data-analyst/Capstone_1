-- ============================================================
--  Sales Territory Analysis
--  Capstone Project  ·  MySQL  ·  Data Storytelling/Excel
-- 	Northeast,South,East,West
--  Date: April 27, 2026
-- ============================================================

USE sample_sales;


/* ============================================================
 Query 1 — Total Sales Revenue by Region
 Business Question: 
 What is total revenue overall for sales in the assigned territory, 
 plus the start date and end date
 ============================================================ */

SELECT 
	t2.region AS Region,
	MIN(t3.transaction_date) AS Start_Date,
	MAX(t3.transaction_date) AS End_Date,
	SUM(t3.sale_amount) AS Total_In_Store_Sales_Revenue
FROM store_locations AS t1
JOIN management AS t2 ON t1.state =t2.state
JOIN store_sales AS t3 ON t1.storeid = t3.store_id
GROUP BY 
	t2.region
ORDER BY 
	SUM(t3.sale_amount) DESC;

SELECT 
	shiptostate,
    SUM(SALESTOTAL) AS Total_online_sales,
	MIN(date) AS End_Date,
	MAX(date) AS Start_Date
FROM ONLINE_SALES
GROUP BY 
	shiptostate;

/* ============================================================
  Question 1 Analysis
  In store sales revenue varied from region to region, with the Northeast generating the highest total revenue of $24,237,526.98,
  followed by the Southern region at 7,996,850.12. The data collected covers periods from 01-01-2022 to 12-31-2025.
  This highlights that the Northeast region is best performing territory, suggesting higher customer demand or better store performance in that region.
  EmporiUM should prioritize investment in the Northeast region, 
  while replicating sales strategies implemented in the northeast region in the lesser 
  performing territories to improve sales performance.

 Note:
 Online sales could not be allocated to regions due to the absence 
 of a shared key linking them to geographic data, so they were analyzed separately.
 ============================================================ */

/* ============================================================
 Query 2 — Month By Month Sales Revenue by Region
 Business Question:  
 What is the month by month revenue breakdown for the sales territory?
 ============================================================ */

SELECT 
	REGION AS Region,
	Year,
    Month,
    Total_Sales 
FROM(SELECT 
	   t3.region AS Region,
	   YEAR(transaction_date) AS Year,
       DATE_FORMAT(transaction_date, '%M') AS Month,
       MONTH(transaction_date) AS MONTH1,
       SUM(SALE_AMOUNT) AS Total_Sales    
FROM store_sales AS t1
JOIN store_locations AS t2 ON t1.store_id = t2.storeid
JOIN management AS t3 ON t2.state =t3.state
GROUP BY 
	t3.region, 
    YEAR(transaction_date),
	DATE_FORMAT(transaction_date, '%M'),
	MONTH(transaction_date)
ORDER BY 
	MONTH ASC) AS e1
ORDER BY 
	Year ASC,
    Month1 ASC;

/* ============================================================
 Question 2 Analysis
 Revenue rises throughout the year, peaking in October with$4,500,000 in 
 revenue and remaining strong through December with $3,970,000 in revenue, 
 while early months like February with $3,400,000 in revenue show the lowest performance.
 This indicates strong seasonality, with demand concentrated in Q4 and a noticeable 
 slowdown after the holiday period.
 EmporiUM should scale operations ahead of Q4 to maximize revenue and use 
 promotions early in the year to offset slower sales periods.
 ============================================================ */

/* ============================================================
 Query 3 — Sales territory and Region Comparison
 Business Question:  
 Provide a comparison of total revenue for the specific sales territory and the 
 region it belongs to.
 ============================================================ */

SELECT 
	A.Region,
	A.Territory,
	A.Territory_Revenue,
    B.Region_Revenue 
FROM (SELECT 
	   t1.region AS Region,
	   t1.state AS Territory,
       SUM(t3.sale_amount) AS Territory_Revenue  
FROM management AS t1
JOIN store_locations AS t2 ON t1.state =t2.state
JOIN store_sales AS t3 ON t2.storeid =t3.store_id
GROUP BY 
	t1.region,
    t1.state
ORDER BY 
	region ASC,
	Territory ASC) AS A
JOIN (
SELECT 
	t1.region AS Region,
	SUM(sale_amount) Region_Revenue
FROM management AS t1
JOIN store_locations AS t2 ON t1.state =t2.state
JOIN store_sales AS t3 ON t2.storeid =t3.store_id
GROUP BY 
	t1.region) AS B
ON A.region = B.Region
ORDER BY 
	A.region ASC,
	A.Territory ASC;

/* ============================================================
 Question 3 Analysis
 Territory-level revenue varies within each region, for example Oregon generated 
 approximately $500,000 compared to the West region’s total of about $2,000,000, 
 showing it contributes roughly 25% of regional revenue.
 This indicates uneven performance across territories, so EmporiUm should 
 invest more in high-performing states while identifying and improving underperforming 
 ones to balance regional growth.
 ============================================================ */

/* ============================================================
 Query 4 — Count total transactions and average revenue per transaction by month
 Business Question:  
 What is the number of transactions per month and average transaction size by 
 product category for the sales territory? 
 ============================================================ */


SELECT 
    t4.state AS Sales_Territory,
    t3.category AS Product_Category,
    YEAR(t1.transaction_date) AS Year,
    MONTH(t1.transaction_date) AS Month_Num,
    DATE_FORMAT(t1.transaction_date, '%M') AS Month,
    COUNT(*) AS Total_Transactions,
    AVG(t1.sale_amount) AS Average_Transaction_Size
FROM store_sales t1
JOIN products t2 ON t1.prod_num = t2.prodnum
JOIN inventory_categories t3 ON t2.categoryid = t3.categoryid
JOIN store_locations t4 ON t1.store_id = t4.storeid
GROUP BY 
    t4.state,
    t3.category,
    Year,
    Month_Num
ORDER BY 
	t4.state,
    t3.category,
    Year,
    Month_Num;

/* ============================================================
 Question 4 Analysis
 This analysis calculates key metrics, including the total number of transactions 
 and the average transaction size, broken down by sales territory, product category,
 and time period (year and month), for example showing values like 120 transactions 
 with an average sale amount of $45 in a given category and region.
 These results highlight which regions and product categories are performing well or 
 underperforming, as well as any seasonal trends in customer purchasing behavior.
 EmporiUM can use these insights to optimize inventory, focus marketing efforts 
 on high-performing areas, and implement strategies to improve revenue in weaker segments.
 ============================================================ */


/* ============================================================
 Query 5 — Ranking in store sales performance by sales territory
 Business Question:  
 Can you provide a ranking of in-store sales performance by each store in the 
 sales territory, or a ranking of online sales performance by state within
 an online sales territory?
 ============================================================ */

SELECT 
	Store_id,
    Territory,
    Sales_Performance,
    Rank () OVER (partition by Territory order by sales_performance) AS Territory_Sales_Ranking
FROM 
	(SELECT 
	t1.store_id AS Store_ID, 
    t2.state AS Territory,
    SUM(t1.sale_amount) AS Sales_Performance
FROM store_sales AS t1
JOIN store_locations AS t2 ON t1.store_id = t2.storeid
GROUP BY 
	t1.store_id,
    t2.state) AS A;

/* ============================================================
 Question 5 Analysis
 This analysis calculates total in-store sales performance for each store by summing sales amounts 
 and ranks each store within its sales territory, for example showing a store generating $50,000 
 in sales ranked 1st in its state.
 This reveals which stores are top performers and which are underperforming within each territory, 
 helping identify performance gaps and competitive positioning at the store level.
 The business can use these insights to reward high-performing stores, investigate and improve 
 low-performing locations, and adjust operational or marketing strategies to drive overall sales growth.
============================================================ */

-- ============================================================
/* Question 6 Question and Analysis
 What is your recommendation for where to focus sales attention in the next quarter?
 ============================================================
 
 The analysis shows variation in sales performance across territories, product categories, 
 and individual stores, with examples such as one territory generating over 300 transactions 
 with an average sale of $60, while another has fewer than 100 transactions with a $35 average, 
 and top-ranked stores reaching around $50,000 in sales compared to lower-ranked stores below 
 $15,000 within the same territory.
 This indicates that some territories generate strong demand but have underperforming stores or 
 lower average transaction values, while certain product categories are not fully maximizing 
 revenue potential.
 Sales efforts should focus on improving low-performing stores in high-demand territories, 
 increasing average transaction size through upselling and promotions, and optimizing underperforming 
 product categories to drive growth in the next quarter */
