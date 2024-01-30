CREATE DATABASE IF NOT EXISTS salesDataWalmart;
CREATE TABLE sales (
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(30) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    vat FLOAT(6,4) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_percentage FLOAT(11,9),
    gross_income DECIMAL(10,2) NOT NULL,
    rating FLOAT(2,1)
);

-- -----------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------
-- -------------------- FEATURE ENGINEERING ---------------------------
-- --------------------------------------------------------------------
-- ### time_of_day
-- create a new variable time_of_day which tells us whether its Morning, Afternoon or Evening.
-- The code below is an example of what procedure will be done. This is going to show us 
-- how the variable will look once added to the data set.
SELECT time,
	(CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
	END) AS time_of_date
FROM sales;
-- We will now create the variable time_of_day
-- add new column
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- Update table
UPDATE sales 
SET time_of_day = (
CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
END);

-- ### day_name
-- this variable will tell us if this is on a monday, tues, wed, etc
-- SQL function DAYNAME already tells us this
SELECT date,
DAYNAME(date) 
FROM sales;

-- Add the new variable into the dataset 
ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

-- Now update the variable to the values
UPDATE sales
SET day_name = (DAYNAME(date));

-- ### month_name
-- this variable will tell us the month name of the row
-- Function MONTHNAME helps us with this already
SELECT date,
MONTHNAME(date)
FROM sales;

-- Add the new variable to the dataset
ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

-- Update the column using MONTHNAME function
UPDATE sales
SET month_name = MONTHNAME(date);

-- ---------------------------- EDA ----------------------------------
-- --------------------------------------------------------------------
-- -------------------------- GENERIC ---------------------------------
-- --------------------------------------------------------------------
-- Q1) How many branches are within the dataset?
SELECT DISTINCT branch 
FROM sales;
-- A1) There are 3 distinct branches within the dataset.

-- Q2) How many cities are within the dataset?
SELECT DISTINCT city
FROM sales;
-- A2) There are 3 unique cities. 

-- Q3) How many product lines are within the dataset?
SELECT DISTINCT product_line
FROM sales;
-- A3) There are 6 unique product lines within the dataset

-- Q4) How many customer types are within the dataset?
SELECT DISTINCT customer_type
FROM sales;
-- A4) There are 2 unique membership types within the dataset: normal or member.

-- Q5) How many payment methods are within the dataset?
SELECT DISTINCT payment_method 
FROM sales;
-- A5) There are 3 different type of payment methods within the dataset.

-- Q6) Which city is associated with which branch?
SELECT DISTINCT city, branch
FROM sales
ORDER BY branch;
-- A6) Yangon ==> A, Naypyitaw ==> B, Mandalay ==> C  

-- --------------------------------------------------------------------
-- -------------------------- PRODUCT ---------------------------------
-- --------------------------------------------------------------------
-- Q1) Which product line had the most sales?
SELECT product_line, COUNT(product_line) AS num_of_sales
FROM sales
GROUP BY product_line
ORDER BY num_of_sales DESC;
-- A1) Fashion accessories were the product line that had the most sales with 178.

-- Q2) Which product line had the largest revenue?
SELECT product_line, SUM(total) AS revenue
FROM sales
GROUP BY product_line
ORDER BY revenue DESC;
-- A2) Food and beverages had the largest revenue. 

-- Q3) What is the average rating for each product line?
SELECT product_line, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
-- A3) The average rating for each product line is
-- Food and beverages = 7.11, Fashion accessories = 7.03, Health and beauty = 6.98,
-- Electronic accessories = 6.91, Sports and travel = 6.86, Home and lifestyle = 6.84

-- Q4) What is the most common product line for each gender?
SELECT product_line, gender, COUNT(gender) as total_count
FROM sales
GROUP BY gender, product_line
ORDER BY gender, total_count DESC;
-- A4) The most common product line for Females is fashion accessories where as the most common
-- product line for Males is Health and Beauty.

-- Q5) Which product lines were above the average sales for the entire dataset?
SELECT ROUND(AVG(total),2)
FROM sales;
-- The average sales amount is $322.50
SELECT product_line, ROUND(AVG(total),2) AS average_sales,
		(CASE 
			WHEN AVG(total) > (SELECT AVG(total) FROM sales) THEN 'Above average'
            ELSE 'Below Average'
		END) AS remark
FROM sales
GROUP BY product_line;
-- A5) Only 2 product lines were listed below average number of sales which 
-- are: electronic accessories and fashion accessories.
-- --------------------------------------------------------------------
-- ---------------------------- SALES ---------------------------------
-- --------------------------------------------------------------------
-- Q1) What is the total revenue for each month?
SELECT month_name as month, SUM(total) AS revenue
FROM sales
GROUP BY month_name
ORDER BY revenue DESC;
-- A1) The total revenue for Jan = $116292.11, Feb = $95727.58, March = $108867.38.

-- Q2) Which month has the largest COGS?
SELECT month_name AS month, SUM(cogs) AS cost_of_good_sold
FROM sales
GROUP BY month
ORDER BY cost_of_good_sold DESC;
-- A2) The month of Jan has the largest COGS.

-- Q3) What is the city with the largest revenue?
SELECT city, SUM(total) as total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;
-- A3) Naypyitaw has the largest revenue from all the cities with $110490.93.

-- Q4) Which product line had the largest VAT?
SELECT product_line, AVG(vat) AS average_value_added_tax
FROM sales
GROUP BY product_line
ORDER BY average_value_added_tax DESC;
-- A4) Home and lifestyle has the largest VAT. 

-- Q5) Which branch sold more products than average products sold?
SELECT branch, SUM(quantity) AS number_of_products_over_average
FROM sales
GROUP BY branch
HAVING number_of_products_over_average > (SELECT AVG(quantity) FROM sales)
ORDER BY number_of_products_over_average DESC;
-- A5) Branch A sold the most products that were above average products sold.

--  Q6) What are the number of sales made in each time of the day per weekday?
SELECT day_name, time_of_day, COUNT(invoice_id) AS number_of_sales
FROM sales
WHERE day_name IN ('Monday','Tuesday','Wednesday','Thursday','Friday')
GROUP BY day_name, time_of_day
ORDER BY (CASE
			WHEN day_name = 'Monday' THEN 0
            WHEN day_name = 'Tuesday' THEN 1
            WHEN day_name = 'Wednesday' THEN 2
            WHEN day_name = 'Thursday' THEN 3
            WHEN day_name = 'Friday' THEN 4
		 END),
         (CASE
			WHEN time_of_day = 'Moring' THEN 0
            WHEN time_of_day = 'Afternoon' THEN 1
            WHEN time_of_day = 'Evening' THEN 2
		 END);
-- A6) Some patterns we can see from the table is that during the weekdays, the number of sales
-- are low compared to the afternoon and evening. Both afternoon and evening sales are
-- relatively even. 

-- 7) During which time of day are the number of sales the largest during each weekend?
SELECT day_name, time_of_day, COUNT(invoice_id) AS number_of_sales
FROM sales
WHERE day_name IN ('Saturday','Sunday')
GROUP BY day_name,time_of_day
ORDER BY (CASE
			WHEN day_name = 'Saturday' THEN 0
            WHEN day_name = 'Sunday' THEN 1
		 END),
         (CASE
			WHEN time_of_day = 'Morning' THEN 0
            WHEN time_of_day = 'Afternoon' THEN 1
            WHEN time_of_day = 'Evening' THEN 2
		 END);
-- A7) View table.

-- Q8) Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city,  AVG(vat) AS average_value_tax_added
FROM sales
GROUP BY city
ORDER BY average_value_tax_added DESC;
-- A8) Naypyitaw has the largest VAT.

-- Q9) What is the highest average gross income for each branch based off the time of day?
SELECT branch, time_of_day, ROUND(AVG(gross_income),2) AS avg_gross_income
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch,
			(CASE
				WHEN time_of_day = 'Morning' THEN 0
                WHEN time_of_day = 'Afternoon' THEN 1
                ELSE 'Evening'
			END);
-- A9) For branch A ==> Afternoon, branch B ==> Afternoon, C ==> Evening.

-- Q10) What is the average sales based of each payment method?
SELECT payment_method, ROUND(AVG(total),2) AS avg_sales
FROM sales
GROUP BY payment_method
ORDER BY avg_sales DESC;
-- A10) Cash is actually the largest in average sales compared to every payment method. 
-- This is surprising because usually big purchases are used using credit cards or Ewallets.

-- Q11) Count the total amount of times a sale from each branch was above the average gross income
SELECT branch, COUNT(gross_income) AS frequency
FROM sales
WHERE gross_income > (SELECT AVG(gross_income) FROM sales)
GROUP BY branch
ORDER BY branch;
-- A11) Branch A was 130, branch B was 132 while branch C was 138

-- --------------------------------------------------------------------
-- ---------------------------- CUSTOMER ------------------------------
-- --------------------------------------------------------------------
-- Q1) How many customers are within each customer type?
SELECT DISTINCT customer_type, COUNT(customer_type) AS number_of_customers
FROM sales
GROUP BY customer_type;
-- A1) There are 499 members where as there are 496 normal customers. 

-- Q2) How many members are in each branch?
SELECT branch, COUNT(customer_type) AS num_of_members
FROM sales
WHERE customer_type = 'Member'
GROUP BY branch
ORDER BY num_of_members;
-- A2) It appears the number of members are distributed evenly. 

-- Q3) Which payment method was used the most amongst the customers?
SELECT DISTINCT payment_method, COUNT(payment_method) as number_of_customers
FROM sales
GROUP BY payment_method
ORDER BY number_of_customers DESC;
-- A3) Cash was the most used payment method amongst the customers. 

-- Q4) What is the gender distribution amongst the customers?
SELECT gender, COUNT(gender) AS number_of_customers
FROM sales
GROUP BY gender
ORDER BY number_of_customers DESC;
-- A4) It is fairly even but there is 1 more male customer.

-- Q5) What is the gender distribution per branch?
SELECT branch, gender, COUNT(gender) as customers
FROM sales
GROUP BY branch, gender
ORDER BY branch;
-- A5) Branch B is relatively even where as branch A has 19 more males whereas branch C 
-- has 27 more females.

-- Q6) Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;
-- A6) As expected, members provide the most revenue.

-- Q7) Which time of the day do customers give most ratings?
SELECT time_of_day, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- A7) It appears customers give the highest ratings during the afternoon

-- Q8) Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, (CASE WHEN time_of_day =  'Morning' THEN 0
					  WHEN time_of_day = 'Afternoon' THEN 1
                      WHEN time_of_day = 'Evening' THEN 2
				 END); 
-- A8) For branch A => Afternoon, branch B => Morning, branch C => Evening.

-- Q9) Which day of the week has the best avg ratings?
SELECT day_name, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC; 
-- A9) It appears that Monday has the highest avg rating whereas wednesday is the lowest.

-- Q10) Which day of the week has the best average ratings per branch?
SELECT branch, day_name, AVG(rating) as avg_rating
FROM sales
GROUP BY branch, day_name
ORDER BY branch, avg_rating DESC;
-- A10) For branch A => Friday, branch B => Monday, branch C => Saturday.

-- Q11) Sort the customers ratings into 3 unique bins where 0-5 ==> 'Poor', 5-7 ==> 'Decent', 7-10 ==> 'Great' and count the total
--     number of customers in each bin.
SELECT (CASE
			WHEN rating >= 0 AND rating <= 5 THEN 'Poor'
            WHEN rating > 5 AND rating <= 7 THEN 'Decent'
            ELSE 'Great'
		END) as review, COUNT(rating) as num_of_customers
FROM sales
GROUP BY review
ORDER BY (CASE
			WHEN review = 'Poor' THEN 2
            WHEN review = 'Decent' THEN 1
            WHEN review = 'Great' THEN 0
		END);
-- A11) It appears most customers fall within the Great column implying
-- that most reviews are above 7.

-- ----------------------------------------------------------------------------------- 



