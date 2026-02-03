CREATE TABLE retail_sales
			(
					transactions_id INT PRIMARY KEY,
					sale_date DATE,
					sale_time TIME,
					customer_id INT,
					gender VARCHAR(15),
					age INT,
					category VARCHAR(15),
					quantity INT,
					price_per_unit FLOAT,
					cogs FLOAT,
					total_sale FLOAT
			);
SELECT * FROM retail_sales;
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
-- 
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

SELECT
	COUNT(*)
FROM retail_sales

-- Data exploration

-- How many sales we have? 
SELECT COUNT (*) as total_sale FROM retail_sales

-- How many unique customers we have?
SELECT COUNT (DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

-- Data Analysis & Business Key Problems & ANswers

-- SQL query to retrieve columns for sales made on 2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- SQL query to retrieve transactions where cateogry is Clothing and quantity is more than 4 in the month Nov-2022
SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantity >= 4

-- SQL query for total sales in each category
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- SQL query for avg age who purchase 'Beauty'

SELECT
	AVG(age) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- SQL query to find all transactions where total sales > 1000

SELECT * FROM retail_sales
WHERE total_sale > 1000

-- SQL query for total number of transactions done by each gender
SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP 
	BY 
	category,
	gender
-- SQL query to calculate the avg sale for each month and its best selling month

SELECT
	year,
	month,
avg_sale
FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1,2
)as t1
WHERE rank = 1

-- SQL query to create each shift and number of orders (before 12, between 12&17, and after 17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- End of Project