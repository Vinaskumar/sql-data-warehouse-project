
--------------- Change over time ------------------

-- Aggrigating data on year level
SELECT YEAR(order_date) as order_year,
	   SUM(sales) as total_sales,
	   COUNT(DISTINCT customer_key) as total_customers,
	   SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

-- Aggrigating data on month level
SELECT FORMAT(order_date, 'MMM-yyyy') as order_date,
	   SUM(sales) as total_sales,
	   COUNT(DISTINCT customer_key) as total_customers,
	   SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'MMM-yyyy')
ORDER BY FORMAT(order_date, 'MMM-yyyy')


--------------- Cumulative analysis ------------------

-- Calculate the total sales and average price per year
-- running total of sales and moving average price over time
SELECT order_date,
	   total_sales,
	   SUM(total_sales) OVER (ORDER BY order_date) as running_total_sales,
	   Avg(avg_price) OVER (ORDER BY order_date) as moving_avg_price
FROM(
	SELECT DATETRUNC(year, order_date) as order_date,
		   SUM(sales) as total_sales,
		   Avg(price) as avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(year, order_date)
	) as t


--------------- Performance analysis ------------------

/* Analyze the yearly performance of sales by comparing yearly sales 
to both its average sales over time and the previous year's sales */
WITH yearly_sales as (
	SELECT YEAR(order_date) as order_year,
		   SUM(sales) as total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(order_date)
	)
SELECT order_year,
	   total_sales,
	   total_sales - (SELECT AVG(total_sales) FROM yearly_sales) as comp_to_avg_sales,
	   total_sales - LAG(total_sales) OVER (ORDER BY order_year) as comp_to_pre_year
FROM yearly_sales

/* Analyze the yearly performance of products by comparing each product's sales 
to both its average sales and the previous year's sales */
WITH yearly_product_sales AS (
SELECT YEAR(s.order_date) as order_year,
	   p.product_name,
	   SUM(s.sales) as current_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(s.order_date), p.product_name
)
SELECT order_year,
	   product_name,
	   current_sales,
	   AVG(current_sales) OVER (PARTITION BY product_name) as avg_sales,
	   current_sales - AVG(current_sales) OVER (PARTITION BY product_name) as diff_avg,
	   CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
		    WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
			ELSE 'Avg'
	   END as avg_change,
	   LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) as py_sales,
	   current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) as diff_py,
	   CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increased'
		    WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decreased'
			ELSE 'No Change'
	   END as py_change
FROM yearly_product_sales
ORDER BY product_name, order_year


--------------- Part - to - whole ------------------

-- Which category contribute the most to overall sales
WITH category_sales AS(
SELECT p.category,
	   SUM(s.sales) as sales_amount
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
GROUP BY p.category
)

SELECT category,
	   sales_amount,
	   CONCAT(ROUND(CAST(sales_amount AS FLOAT) * 100 / (SELECT SUM(sales_amount) FROM category_sales) ,2), '%') as perc_sales
FROM category_sales
ORDER BY sales_amount DESC


--------------- Data segmentation ------------------

/* Segment products into cost ranges and
count how many products fall into each segment. */
SELECT cost_range,
	   COUNT(product_key) as total_products
FROM(
	SELECT product_key,
		   product_name,
		   cost,
		   CASE WHEN cost < 100 THEN 'Below 100'
				WHEN cost BETWEEN 100 AND 500 THEN '100-500'
				WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
				ELSE 'Above 1000'
		   END AS cost_range
	FROM gold.dim_products) t
GROUP BY cost_range
ORDER BY total_products DESC

/* Group customers into three segments based on their spending behaviour:
	- VIP : Customers with at least 12 months of history and spending more than 5000
	- Regular : Customers with at least 12 months of history but spending 5000 or less
	- New : Customers with a lifespan less than 12 months.
And find the total number of customers by each group */
WITH customer_history AS(
SELECT customer_key,
	   DATEDIFF(month, MIN(order_date), MAX(order_date)) as history_in_months,
	   SUM(sales) as total_spending
FROM gold.fact_sales
GROUP BY customer_key
),
customer_category AS(
SELECT customer_key,
	   history_in_months,
	   total_spending,
	   CASE WHEN history_in_months >= 12 AND total_spending > 5000 THEN 'VIP'
			WHEN history_in_months >= 12 AND total_spending <= 5000 THEN 'Regular'
			ELSE 'New'
	   END AS customer_group
FROM customer_history
)

SELECT customer_group,
	   COUNT(customer_key) as total_customers
FROM customer_category
GROUP BY customer_group
ORDER BY total_customers DESC
