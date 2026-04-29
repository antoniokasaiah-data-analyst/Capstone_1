SELECT *
FROM store_locations AS t1
JOIN management AS t2 ON t1.state =t2.state
JOIN store_sales AS t3 ON t1.storeid = t3.store_id
JOIN online_sales AS t4 ON t3.prod_num = t4.prodnum;

SELECT * FROM online_sales AS t1
JOIN store_sales AS t2 ON t1.ProdNum = t2.prod_num;
