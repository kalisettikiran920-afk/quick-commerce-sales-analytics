USE q_commerce

/*
DROP TABLE IF EXISTS df_q_commerce;

CREATE TABLE df_q_commerce (
	order_id INT PRIMARY KEY,
	customer_id INT,
	platform VARCHAR(20),
	delivery_time INT,
	product_category VARCHAR(20),
	order_value INT,
	customer_feedback VARCHAR(100),
	service_rating INT,
	delivery_delay VARCHAR(20),
	refund_requested VARCHAR(20),
	order_value_segmentation VARCHAR(20)
)
*/

SELECT TOP 1000 * FROM df_q_commerce

------------------------------------------------------------------------------------------

/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Total orders 
SELECT COUNT(1) AS total_orders FROM df_q_commerce;

-- Total customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM df_q_commerce;

-- Total Sales (including all platforms)
SELECT FORMAT(SUM(order_value),'N0') AS total_sales FROM df_q_commerce;

-- Average Sales (including all platforms)
SELECT AVG(order_value) AS average_order_value FROM df_q_commerce;

-- Average Service Rating (including all platforms)
SELECT ROUND(AVG(CAST(service_rating AS DECIMAL(5,2))) ,2) AS average_rating FROM df_q_commerce

-- Average Delivery Time (including all platforms)
SELECT ROUND(AVG(CAST(delivery_time AS DECIMAL(5,2))) ,2) AS average_delivery_time FROM df_q_commerce

/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Platform wise total orders, total sales, average rating, average_delivery_time and average_order_value
SELECT 
	platform,
	COUNT(1) AS total_orders,
	FORMAT(SUM(order_value),'N0') AS total_sales,
	ROUND(AVG(CAST(service_rating AS DECIMAL(5,2))) ,2) AS average_rating,
	ROUND(AVG(CAST(delivery_time AS DECIMAL(5,2))) ,2) AS average_delivery_time,
	AVG(order_value) AS average_order_value
FROM df_q_commerce
GROUP BY platform;

-- Product category wise total orders, total sales, average rating, average_delivery_time and average_order_value
SELECT 
	product_category,
	COUNT(1) AS total_orders,
	FORMAT(SUM(order_value),'N0') AS total_sales,
	ROUND(AVG(CAST(service_rating AS DECIMAL(5,2))) ,2) AS average_rating,
	ROUND(AVG(CAST(delivery_time AS DECIMAL(5,2))) ,2) AS average_delivery_time,
	AVG(order_value) AS average_order_value
FROM df_q_commerce
GROUP BY product_category
ORDER BY SUM(order_value) DESC;

-- Customer feedback wise total orders, total sales, average rating, average_delivery_time and average_order_value
SELECT 
	customer_feedback,
	COUNT(1) AS total_orders,
	FORMAT(SUM(order_value),'N0') AS total_sales,
	ROUND(AVG(CAST(service_rating AS DECIMAL(5,2))) ,2) AS average_rating,
	ROUND(AVG(CAST(delivery_time AS DECIMAL(5,2))) ,2) AS average_delivery_time,
	AVG(order_value) AS average_order_value
FROM df_q_commerce
GROUP BY customer_feedback;

-- Service rating wise total orders, total sales, average rating, average_delivery_time and average_order_value
SELECT 
	service_rating,
	COUNT(1) AS total_orders,
	FORMAT(SUM(order_value),'N0') AS total_sales,
	ROUND(AVG(CAST(service_rating AS DECIMAL(5,2))) ,2) AS average_rating,
	ROUND(AVG(CAST(delivery_time AS DECIMAL(5,2))) ,2) AS average_delivery_time,
	AVG(order_value) AS average_order_value
FROM df_q_commerce
GROUP BY service_rating
ORDER BY SUM(order_value) DESC;

-- Delivery delay wise total orders, total sales, average rating, average_delivery_time and average_order_value
-- To know whether order delivered on time or not as promised to the customers
SELECT 
	delivery_delay,
	COUNT(1) AS total_orders,
	FORMAT(SUM(order_value),'N0') AS total_sales,
	ROUND(AVG(CAST(service_rating AS DECIMAL(5,2))) ,2) AS average_rating,
	ROUND(AVG(CAST(delivery_time AS DECIMAL(5,2))) ,2) AS average_delivery_time,
	AVG(order_value) AS average_order_value
FROM df_q_commerce
GROUP BY delivery_delay
ORDER BY SUM(order_value) DESC;

-- Refund requested wise total orders, total sales, average rating, average_delivery_time and average_order_value
SELECT 
	refund_requested,
	COUNT(1) AS total_orders,
	FORMAT(SUM(order_value),'N0') AS total_sales,
	ROUND(AVG(CAST(service_rating AS DECIMAL(5,2))) ,2) AS average_rating,
	ROUND(AVG(CAST(delivery_time AS DECIMAL(5,2))) ,2) AS average_delivery_time,
	AVG(order_value) AS average_order_value
FROM df_q_commerce
GROUP BY refund_requested
ORDER BY SUM(order_value) DESC;

-- Order value segmentation wise total orders, total sales, average rating, average_delivery_time and average_order_value
SELECT 
	order_value_segmentation,
	COUNT(1) AS total_orders,
	FORMAT(SUM(order_value),'N0') AS total_sales,
	ROUND(AVG(CAST(service_rating AS DECIMAL(5,2))) ,2) AS average_rating,
	ROUND(AVG(CAST(delivery_time AS DECIMAL(5,2))) ,2) AS average_delivery_time,
	AVG(order_value) AS average_order_value
FROM df_q_commerce
GROUP BY order_value_segmentation
ORDER BY SUM(order_value) DESC;

/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., product_categories, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Top 5 highest-value orders per platform (exploratory)
SELECT 
	platform,
	order_id,
	order_value
FROM (
	SELECT 
		platform,
		order_id,
		order_value,
		DENSE_RANK() OVER(PARTITION BY platform ORDER BY order_value DESC) AS rnk
	FROM df_q_commerce
)t
WHERE rnk <= 5;

-- Top 5 customers (including all platforms)
SELECT TOP 5
	customer_id,
	SUM(order_value) AS total_sales
FROM df_q_commerce
GROUP BY customer_id
ORDER BY total_sales DESC
-- or
SELECT TOP 5 -- Non-refunded orders only
	customer_id,
	SUM(order_value) AS total_sales
FROM df_q_commerce
WHERE refund_requested = 'No'
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Top 5 customers for each platform
SELECT 
	platform,
	customer_id,
	total_sales
FROM (
	SELECT 
		platform,
		customer_id,
		SUM(order_value) AS total_sales,
		DENSE_RANK() OVER(PARTITION BY platform ORDER BY SUM(order_value) DESC) AS rnk
	FROM df_q_commerce
	GROUP BY platform, customer_id
)t
WHERE rnk <= 5;

-- Top 5 customers for each product category (Used for product recommendations and marketing the particular segment)
SELECT 
	product_category,
	customer_id,
	total_sales
FROM (
	SELECT 
		product_category,
		customer_id,
		SUM(order_value) AS total_sales,
		DENSE_RANK() OVER(PARTITION BY product_category ORDER BY SUM(order_value) DESC) AS rnk
	FROM df_q_commerce
	GROUP BY product_category, customer_id
)t
WHERE rnk <= 5;

-- Top 5 customers who made more orders & sales(when total orders are same) within each budget range (order_value_segmentation) --> Budget, Standard, VIP
-- Used for product recommendations and marketing the particular segment of customers based on their economical soundness

SELECT
	order_value_segmentation, 
	customer_id,
	total_orders,
	total_sales
FROM (
	SELECT
		order_value_segmentation, 
		customer_id,
		COUNT(1) AS total_orders,
		SUM(order_value) AS total_sales,
		DENSE_RANK() OVER(PARTITION BY order_value_segmentation ORDER BY COUNT(1) DESC, SUM(order_value) DESC) AS rnk
	FROM df_q_commerce
	GROUP BY order_value_segmentation, customer_id
)t
WHERE rnk <= 5;

/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- Classifying the customer feedbacks into positive and negative for every order
SELECT DISTINCT customer_feedback FROM df_q_commerce

SELECT 
	customer_feedback_segmentation,
	COUNT(1) AS total_orders,
	CAST(COUNT(1) * 100.0/ (SELECT COUNT(1) FROM df_q_commerce) AS DECIMAL(5,2)) AS orders_percentage
FROM (
	SELECT 
		order_id,
		CASE WHEN customer_feedback IN ('Excellent experience!','Easy to order, loved it!','Very satisfied with the service.',
					'Good quality products.','Quick and reliable!','Fast delivery, great service!') THEN 'Positive'
			 WHEN customer_feedback IS NULL THEN 'Unknown' --If customers don't give feedback. So this query can be executed in the future as well
			 ELSE 'Negative'
		END AS customer_feedback_segmentation
	FROM df_q_commerce
)t
GROUP BY customer_feedback_segmentation;

/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods(we don't have here).
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

-- Which platforms contribute the most to overall orders and sales?

WITH cte_platform AS (
	SELECT 
		platform,
		COUNT(1) AS num_of_orders,
		SUM(order_value) AS sales
	FROM df_q_commerce
	GROUP BY platform
)
SELECT 
	platform,
	num_of_orders,
	SUM(num_of_orders) OVER() AS total_orders,
	CAST(num_of_orders * 100.0 / SUM(num_of_orders) OVER() AS DECIMAL(5,2)) AS orders_percentage,
	sales,
	SUM(sales) OVER() AS total_sales,
	CAST(sales * 100.0 / SUM(sales) OVER() AS DECIMAL(5,2)) AS sales_percentage
FROM cte_platform;

-- Which product_category contribute the most to overall orders and sales?

WITH cte_product_category AS (
	SELECT 
		product_category,
		COUNT(1) AS num_of_orders,
		SUM(order_value) AS sales
	FROM df_q_commerce
	GROUP BY product_category
)
SELECT 
	product_category,
	num_of_orders,
	SUM(num_of_orders) OVER() AS total_orders,
	CAST(num_of_orders * 100.0 / SUM(num_of_orders) OVER() AS DECIMAL(5,2)) AS orders_percentage,
	sales,
	SUM(sales) OVER() AS total_sales,
	CAST(sales * 100.0 / SUM(sales) OVER() AS DECIMAL(5,2)) AS sales_percentage
FROM cte_product_category;

-- Which service rating contribute the most to overall orders and sales?

WITH cte_service_rating AS (
	SELECT 
		service_rating,
		COUNT(1) AS num_of_orders,
		SUM(order_value) AS sales
	FROM df_q_commerce
	GROUP BY service_rating
)
SELECT 
	service_rating,
	num_of_orders,
	SUM(num_of_orders) OVER() AS total_orders,
	CAST(num_of_orders * 100.0 / SUM(num_of_orders) OVER() AS DECIMAL(5,2)) AS orders_percentage,
	sales,
	SUM(sales) OVER() AS total_sales,
	CAST(sales * 100.0 / SUM(sales) OVER() AS DECIMAL(5,2)) AS sales_percentage
FROM cte_service_rating
ORDER BY service_rating;

-- Which customer segmentation contribute the most to overall orders and sales?

WITH cte_order_segmentation AS (
	SELECT 
		order_value_segmentation,
		COUNT(1) AS num_of_orders,
		SUM(order_value) AS sales
	FROM df_q_commerce
	GROUP BY order_value_segmentation
)
SELECT 
	order_value_segmentation,
	num_of_orders,
	SUM(num_of_orders) OVER() AS total_orders,
	CAST(num_of_orders * 100.0 / SUM(num_of_orders) OVER() AS DECIMAL(5,2)) AS orders_percentage,
	SUM(sales) OVER() AS total_sales,
	CAST(sales * 100.0 / SUM(sales) OVER() AS DECIMAL(5,2)) AS sales_percentage
FROM cte_order_segmentation;


/*
===============================================================================
Performance Analysis
===============================================================================
*/

-- Platform wise ratings
SELECT 
	platform,
	SUM(CASE WHEN service_rating = 1 THEN 1 ELSE 0 END) AS Rated_1,
	SUM(CASE WHEN service_rating = 2 THEN 1 ELSE 0 END) AS Rated_2,
	SUM(CASE WHEN service_rating = 3 THEN 1 ELSE 0 END) AS Rated_3,
	SUM(CASE WHEN service_rating = 4 THEN 1 ELSE 0 END) AS Rated_4,
	SUM(CASE WHEN service_rating = 5 THEN 1 ELSE 0 END) AS Rated_5	
FROM df_q_commerce
GROUP BY platform;

-- Product category wise ratings
SELECT 
	product_category,
	SUM(CASE WHEN service_rating = 1 THEN 1 ELSE 0 END) AS Rated_1,
	SUM(CASE WHEN service_rating = 2 THEN 1 ELSE 0 END) AS Rated_2,
	SUM(CASE WHEN service_rating = 3 THEN 1 ELSE 0 END) AS Rated_3,
	SUM(CASE WHEN service_rating = 4 THEN 1 ELSE 0 END) AS Rated_4,
	SUM(CASE WHEN service_rating = 5 THEN 1 ELSE 0 END) AS Rated_5	
FROM df_q_commerce
GROUP BY product_category;

-- Customer feedback wise ratings
SELECT 
	customer_feedback,
	SUM(CASE WHEN service_rating = 1 THEN 1 ELSE 0 END) AS Rated_1,
	SUM(CASE WHEN service_rating = 2 THEN 1 ELSE 0 END) AS Rated_2,
	SUM(CASE WHEN service_rating = 3 THEN 1 ELSE 0 END) AS Rated_3,
	SUM(CASE WHEN service_rating = 4 THEN 1 ELSE 0 END) AS Rated_4,
	SUM(CASE WHEN service_rating = 5 THEN 1 ELSE 0 END) AS Rated_5	
FROM df_q_commerce
GROUP BY customer_feedback;

-- Budget category wise ratings
SELECT 
	order_value_segmentation,
	SUM(CASE WHEN service_rating = 1 THEN 1 ELSE 0 END) AS Rated_1,
	SUM(CASE WHEN service_rating = 2 THEN 1 ELSE 0 END) AS Rated_2,
	SUM(CASE WHEN service_rating = 3 THEN 1 ELSE 0 END) AS Rated_3,
	SUM(CASE WHEN service_rating = 4 THEN 1 ELSE 0 END) AS Rated_4,
	SUM(CASE WHEN service_rating = 5 THEN 1 ELSE 0 END) AS Rated_5	
FROM df_q_commerce
GROUP BY order_value_segmentation;

/*
===============================================================================
Customer Report
===============================================================================
*/

SELECT 
	customer_id,
	COUNT(1) AS total_orders,
	SUM(order_value) AS total_sales,
	SUM(CASE WHEN platform = 'JioMart' THEN 1 ELSE 0 END) AS jio_mart,
	SUM(CASE WHEN platform = 'Swiggy Instamart' THEN 1 ELSE 0 END) AS swiggy_instamart,
	SUM(CASE WHEN platform = 'Blinkit' THEN 1 ELSE 0 END) AS blinkit,
	SUM(CASE WHEN product_category = 'Fruits & Vegetables' THEN 1 ELSE 0 END) AS fruits_and_vegetables,
	SUM(CASE WHEN product_category = 'Dairy' THEN 1 ELSE 0 END) AS dairy,
	SUM(CASE WHEN product_category = 'Beverages' THEN 1 ELSE 0 END) AS beverages,
	SUM(CASE WHEN product_category = 'Personal Care' THEN 1 ELSE 0 END) AS personal_care,
	SUM(CASE WHEN product_category = 'Grocery' THEN 1 ELSE 0 END) AS grocery,
	SUM(CASE WHEN product_category = 'Snacks' THEN 1 ELSE 0 END) AS snacks,
	SUM(CASE WHEN service_rating = 1 THEN 1 ELSE 0 END) AS rated_1,
	SUM(CASE WHEN service_rating = 2 THEN 1 ELSE 0 END) AS rated_2,
	SUM(CASE WHEN service_rating = 3 THEN 1 ELSE 0 END) AS rated_3,
	SUM(CASE WHEN service_rating = 4 THEN 1 ELSE 0 END) AS rated_4,
	SUM(CASE WHEN service_rating = 5 THEN 1 ELSE 0 END) AS rated_5,
	SUM(CASE WHEN delivery_delay = 'Yes' THEN 1 ELSE 0 END) AS delivery_delayed,
	SUM(CASE WHEN delivery_delay = 'No' THEN 1 ELSE 0 END) AS delivery_ontime,
	SUM(CASE WHEN refund_requested = 'Yes' THEN 1 ELSE 0 END) AS refund_requested,
	SUM(CASE WHEN refund_requested = 'No' THEN 1 ELSE 0 END) AS refund_not_requested
FROM df_q_commerce
GROUP BY customer_id;

/*
===============================================================================
Product Category Report
===============================================================================
*/

SELECT 
	product_category,
	COUNT(1) AS total_orders,
	SUM(order_value) AS total_sales,
	SUM(CASE WHEN platform = 'JioMart' THEN 1 ELSE 0 END) AS jio_mart,
	SUM(CASE WHEN platform = 'Swiggy Instamart' THEN 1 ELSE 0 END) AS swiggy_instamart,
	SUM(CASE WHEN platform = 'Blinkit' THEN 1 ELSE 0 END) AS blinkit,
	SUM(CASE WHEN delivery_delay = 'Yes' THEN 1 ELSE 0 END) AS delivery_delayed,
	SUM(CASE WHEN delivery_delay = 'No' THEN 1 ELSE 0 END) AS delivery_ontime,
	SUM(CASE WHEN refund_requested = 'Yes' THEN 1 ELSE 0 END) AS refund_requested,
	SUM(CASE WHEN refund_requested = 'No' THEN 1 ELSE 0 END) AS refund_not_requested
FROM df_q_commerce
GROUP BY product_category;

