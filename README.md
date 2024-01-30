# <p style = "text-align: center;"> **Walmart Sales Data Analysis Project** </p>

## **Overview**

This repository comprises of an analysis of Walmart Sales in the country of **Myanmar**. This project is exclusively completed using SQL where we will answer several questions in regards to the dataset. The goal of this project is to get a better understating of the dataset by examining the branches, product lines, membership types and several other variables that could affect customer sales.

### **Variables**

Below is a table consisting of the variables we will be working with to answer several questions about the dataset.

| Column | Description | Data Type |
| ------- | -------- | ------ |
| invoice_id | Id of the invoice of sale | VARCHAR |
| branch | Branch of the store where sale was made | VARCHAR |
| city | City of the store where sale was made | VARCHAR |
| customer_type | Type of customer | VARCHAR |
| gender | Gender of customer | VARCHAR |
| product_line | The line of the product that was sold | VARCHAR |
| unit_price | Price of each product | DECIMAL |
| quantity | Number of products sold | INT |
| vat | amount of tax added to the purchase | FLOAT |
| total | Total cost of the product | DECIMAL |
| date | The date of when product was purchased | DATETIME |
| time | The time of when product was purchased | TIME |
| payment_method | Type of method payment was made | VARCHAR |
| cogs | Cost of goods sold | DECIMAL |
| gross_margin_percentage | gross margin percentage | FLOAT |
| gross_income | Gross income | DECIMAL | 
| rating | Rating of customer review after purchase | FLOAT |

### **Feature Engineering**

We will also feature engineer 3 new columns: `time_of_day`, `day_name` and `month_name`. 

1) `time_of_day` ==> A VARCHAR variable which will tell us whether the sale occured during the morning, afternoon or evening. 

2) `day_name` ==> A VARCHAR variable which will tell us which day of the week the sale occured (Mon,Tues,ETC)

3) `month_name` ==> A VARCHAR variable which will tell us which month the sale occured. (Jan,Feb,etc)

Throughout this analysis we will answer questions in regards to products, sales, customers and as well as generic questions about the dataset. The questions that we will be answering within this repository will be listed below, however the answer swill be included in a seperate file within the repository.  The SQL code within the repository will also provide answers to the questions and as well as the table outputs for each question.

### **Generic Questions**

1) How many branches are within the dataset?
2) How many cities are within the dataset?
3) How many product lines are within the dataset?
4) How many customer types are within in the dataset?
5) How many payment methods are within the dataset?
6) Which city is associated with which branch?

### **Product Questions**
1) Which product line had the most sales?
2) Which product line has the largest revenue?
3) What is the average rating for each product line?
4) What is the most common product line for each gender?
5) Which product lines were above the average sales for the entire dataset?

### **Sales Qustions**
1) What is the total revenue for each month?
2) Which month has the largest COGS? 
3) Which city has the largest revenue?
4) Which product line had the largest VAT?
5) Which branch sold more products than average products sold?
6) During which time of day are the number of sales the largest during each weekdays?
7) During which time of day are the number of sales the largest during each weekend?
8) Which city has the largest tax percent / VAT (Value Added Tax)?
9) What is the average gross income for each branch based off the time of day?
10) What is the average sales based of each payment method?
11) Count the total amount of times a sale from each branch was above the average gross income.

### **Customer Questions**
1) How many customers are within each customer type?
2) How many members are in each branch?
3) Which payment method was used the most amongst the customers?
4) What is the gender distribution amongst the customers?
5) What is the gender distribution per branch?
6) Which of the customer types brings the most revenue?
7) Which time of the day do customers give most ratings?
8) Which time of the day do customers give most ratings per branch?
9) Which day of the week has the best avg ratings?
10) Which day of the week has the best average ratings per branch?
11) Sort the customers ratings into 3 unique bins where 0-5 ==> 'Poor', 5-7 ==> 'Decent', 7-10 ==> 'Great' and count the total number of customers in each bin.
