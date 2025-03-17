CREATE DATABASE walmart;
USE walmart;
CREATE TABLE sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
     branch VARCHAR(5) NOT NULL,
     city VARCHAR(30) NOT NULL,
     customer_id VARCHAR(30) NOT NULL,
     gender VARCHAR(10) NOT NULL,
     product_line VARCHAR(100) NOT NULL,
     unit_price DECIMAL(10, 2) NOT NULL,
     quantity INT NOT NULL,
     tax_percentage FLOAT NOT NULL,
     total DECIMAL(10, 2) NOT NULL,
     date DATE NOT NULL,
     time TIME NOT NULL,
     payment_method VARCHAR(15) NOT NULL,
     cogs DECIMAL(10, 2) NOT NULL,
     gross_margin_percentage FLOAT NOT NULL,
     gross_income DECIMAL(10, 2) NOT NULL,
     rating DECIMAL(2, 1)
     );
     
     -- 1st step is analyzing the data which means seeing any null values and removing it
     -- as we dont have any null values we dont require cleaning of our data.
     -- -----------------------------------------------------------------------------------
     -- ------------------- FEATURE ENGINEERING--------------------------------------------
     
     -- TIME_OF_DAY
     
     -- when time is 03:00:00 to 11:00:00 that is MORNING
     -- when time is 11:00:01 to 15:00:00 that is AFTERNOON
     -- when time is 15:00:01 to 20:00:00 that is EVENING
     -- when time is 20:00:00 to 02:00:00 that is NIGHT
     
     SELECT TIME, 
     (CASE 
         WHEN time BETWEEN "03:00:00" AND "11:00:00" THEN "MORNING"
         WHEN time BETWEEN "11:00:01" AND "15:00:00" THEN "AFTERNOON"
		 WHEN time BETWEEN "15:00:01" AND "20:00:00" THEN "EVENING"
         ELSE "NIGHT"
         END 
     ) AS time_of_date 
     FROM sales;
     
     ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
     
     UPDATE sales 
     SET time_of_day = ( CASE
		 WHEN time BETWEEN "03:00:00" AND "11:00:00" THEN "MORNING"
         WHEN time BETWEEN "11:00:01" AND "15:00:00" THEN "AFTERNOON"
		 WHEN time BETWEEN "15:00:01" AND "20:00:00" THEN "EVENING"
         ELSE "NIGHT"
         END 
		);
      ALTER TABLE table_sales 
     DROP COLUMN time_of_data;
     
     -- DAY NAME
     SELECT date,
     DAYNAME(date)AS day_name
     FROM sales;
     ALTER TABLE sales ADD COLUMN day_name VARCHAR(10)
     
     UPDATE sales
     SET dat_name = (date);
     
      -- MONTH NAME 
	SELECT date,
    MONTHNAME(date)AS month_name
    FROM sales;
    ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
    
    UPDATE sales
    SET month_name = (date);
    
    ALTER TABLE sales
    DROP COLUMN MONTHNAME;
    
-- ----------------------------------------------------------------------------------------
--                                  DATA ANALYSIS
-- ----------------------------------------------------------------------------------------

-- HOW MANY UNIQUE CITY DOES THE DATA HAVE?
SELECT 
DISTINCT city
FROM sales;

-- IN WHICH CITY IS EACH BRANCH?
SELECT 
DISTINCT city,
branch
FROM sales;

--  HOW MANY UNIQUE PRODUCT LINES DOES THE DATA HAVE?
SELECT 
DISTINCT product_line
FROM sales;

-- WHAT IS THE COMMON PAYMENT METHOD?
SELECT 
COUNT(payment_method),
payment_method
FROM sales
GROUP BY payment_method;

-- WHAT IS THE MOST COMMON PRODUCT LINE 
SELECT 
 product_line
FROM sales
GROUP BY product_line;

-- WHAT MONTH HAD THE LARGEST COGS?
SELECT month_name AS month,
 SUM(cogs)AS cogs
 FROM sales
 GROUP BY month_name
 ORDER BY cogs;
 
 -- WHAT IS THE TOTAL REVENUE BY MONTH?
 SELECT month_name AS month,
 SUM(total)AS total_revenue
 FROM SALES 
 GROUP BY month_name
 
 -- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;


-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- WHAT IS THE AVG RATING OF EACH PRODUCT LINE?
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- HOW MANY UNIQUE COSTOMER TYPES DOES DATA HAVE?
SELECT
	DISTINCT customer_type
FROM sales;

-- HOW MANY UNIQUE PAYMENT TYPES DOES DATA HAVE?
SELECT
	DISTINCT payment
FROM sales;


-- WHAT IS THE MOST COMMON CUSTOMER TYPE?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type;

-- WHICH CUSTOMER TYPE BUYS THE MOST?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


-- WHAT IS THEGENDER OF MOST OF THE CUSTOMERS?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;

 

