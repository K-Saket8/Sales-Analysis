/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    Sanity-checking the gold schema after loading data into Postgres, and get
    familiarized to the dataset before answering the business questions
    (e.g. what countries/categories exist, what time period the data covers).

Tables used:
    - information_schema.tables   -> confirms tables exist and loaded correctly
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales
===============================================================================
*/

-- ------------------------------------------------------------------
-- Checking all the tables in the schema
-- ------------------------------------------------------------------
select table_name,table_schema,table_type
from information_schema.tables
where table_schema='gold';


/*
===============================================================================
Exploring dim_products
===============================================================================
*/

-- Quick look at the full table and row count
select * from gold.dim_products;
select count(*) from gold.dim_products;

-- Checking the distinct values in each column to understand the data
select distinct product_number from gold.dim_products;
select distinct category from gold.dim_products;
select distinct category_id from gold.dim_products;
select distinct subcategory from gold.dim_products;
select distinct maintenance from gold.dim_products;
select distinct product_line from gold.dim_products;
select distinct start_date from gold.dim_products;

-- Checking datatypes of columns
select column_name, data_type, is_nullable, character_maximum_length
from information_schema.columns
where table_name = 'dim_products'
order by ordinal_position;

-- Checking if each category_id is unique for each subcategory
select category_id, category, subcategory
from gold.dim_products
group by category_id, category, subcategory
order by category_id;

-- Counting if there are any duplicates in product_id
select product_id, count(*)
from gold.dim_products
group by product_id
having count(*) > 1;

-- Where are categories and subcategories null? (earlier founded 1 null category and 1 null subcategory)
select p.product_key, p.product_name, p.category, p.subcategory
from gold.dim_products p
where category is null or subcategory is null;

-- Checking number of nulls in each column
select
    count(*) as total_rows,
    count(*) - count(product_key) as null_product_key,
    count(*) - count(product_id) as null_product_id,
    count(*) - count(product_number) as null_product_number,
    count(*) - count(product_name) as null_name,
    count(*) - count(category_id) as null_category_id,
    count(*) - count(category) as null_category,
    count(*) - count(subcategory) as null_subcategory,
    count(*) - count(maintenance) as null_maintenance,
    count(*) - count(cost) as null_cost,
    count(*) - count(product_line) as null_product_line,
    count(*) - count(start_date) as null_start_date
from gold.dim_products;

-- Checking if any duplicate rows exist
select product_name, count(*)
from gold.dim_products
group by product_name
having count(*) > 1;


/*
===============================================================================
Exploring dim_customers
===============================================================================
*/

-- Quick look at the full table and row count
select * from gold.dim_customers;
select count(*) from gold.dim_customers;

-- customer_key checks: nulls, distinct count, duplicates
select customer_key from gold.dim_customers;
select count(distinct customer_key) from gold.dim_customers;
select customer_key from gold.dim_customers where customer_key is null;
select customer_key, count(*)
from gold.dim_customers
group by customer_key
having count(*) > 1;

-- customer_id checks: nulls, distinct count, duplicates
select customer_id from gold.dim_customers;
select count(distinct customer_id) from gold.dim_customers;
select customer_id from gold.dim_customers where customer_id is null;
select customer_id, count(*)
from gold.dim_customers
group by customer_id
having count(*) > 1;

-- customer_number checks: nulls, distinct count, duplicates
select customer_number from gold.dim_customers;
select count(distinct customer_number) from gold.dim_customers;
select customer_key from gold.dim_customers where customer_key is null;
select customer_number, count(*)
from gold.dim_customers
group by customer_number
having count(*) > 1;

-- Checking if multiple entries exist with same names and cross checking if they are same person or different people
select *
from gold.dim_customers
where (first_name, last_name) in (
    select first_name, last_name
    from gold.dim_customers
    group by first_name, last_name
    having count(*) > 1
)
order by first_name, last_name;

-- Checking how many countries are there
select distinct country from gold.dim_customers;

-- Checking values in marital_status column
select distinct marital_status from gold.dim_customers;

-- Checking values in gender column
select distinct gender from gold.dim_customers;

-- birthdate checks: nulls, distinct count, duplicates
select birthdate from gold.dim_customers;
select count(birthdate) from gold.dim_customers;
select birthdate from gold.dim_customers where birthdate is null;
select count(distinct birthdate) from gold.dim_customers;
select birthdate, count(*)
from gold.dim_customers
group by birthdate
having count(*) > 1;

-- Checking ranges of birthdate (oldest / youngest customer)
select 
    min(birthdate) as oldest_birthdate,
    max(birthdate) as youngest_birthdate,
    extract(year from age(min(birthdate))) as oldest_age,
    extract(year from age(max(birthdate))) as youngest_age
from gold.dim_customers;

-- create_date checks: nulls, distinct count, duplicates
select create_date from gold.dim_customers;
select count(create_date) from gold.dim_customers;
select create_date from gold.dim_customers where birthdate is null;
select count(distinct create_date) from gold.dim_customers;
select create_date, count(*)
from gold.dim_customers
group by create_date
having count(*) > 1;

-- Checking ranges of create_date
select 
    min(create_date) as oldest_create_date,
    max(create_date) as youngest_create_date
from gold.dim_customers;


/*
===============================================================================
Exploring fact_sales
===============================================================================
*/

-- Quick look at the full table and row count
select * from gold.fact_sales;
select count(*) from gold.fact_sales;

-- Checking details about columns
select column_name, data_type, is_nullable, character_maximum_length
from information_schema.columns
where table_name = 'fact_sales'
order by ordinal_position;

-- order_number checks: nulls, distinct count, duplicates
select order_number from gold.fact_sales;
select count(order_number) from gold.fact_sales;
select count(distinct order_number) from gold.fact_sales;
select order_number, count(*)
from gold.fact_sales
group by order_number
having count(*) > 1;

-- product_key checks: nulls, distinct count, duplicates
select product_key from gold.fact_sales;
select count(product_key) from gold.fact_sales;
select count(distinct product_key) from gold.fact_sales;
select count(*) from gold.fact_sales where product_key is null;
select product_key,count(*)
from gold.fact_sales 
group by product_key
having count(*)>1;

-- Checking if a product_key actually exists in the dim_products table
select product_key from gold.fact_sales where product_key not in
(select product_key from gold.dim_products);
-- this will only work when the result of inner subquery doesn't have any NULLs, which in this case hasn't
-- use join instead

-- customer_key checks: nulls, distinct count, duplicates
select customer_key from gold.fact_sales;
select count(Customer_key) from gold.fact_sales;
select count(distinct Customer_key) from gold.fact_sales;
select count(*) from gold.fact_sales where Customer_key is null;
select Customer_key,count(*)
from gold.fact_sales 
group by Customer_key
having count(*)>1;

-- Checking if a customer_key actually exists in dim_customers
select customer_key from gold.fact_sales where customer_key not in
(select customer_key from gold.dim_customers);
-- same as before

-- order_date checks: nulls, distinct count, duplicates, range
select Order_Date from gold.fact_sales;
select count(order_date) from gold.fact_sales;
select count(distinct order_date) from gold.fact_sales;
select count(*) from gold.fact_sales where order_date is null;
select min(order_date) as oldestorder,
       max(order_date) as latestorder
from gold.fact_sales;
select Order_Date,count(*)
from gold.fact_sales 
group by Order_Date
having count(*)>1;

-- shipping_date checks: nulls, distinct count, duplicates
select shipping_date from gold.fact_sales;
select count(shipping_date) from gold.fact_sales;
select count(distinct shipping_date) from gold.fact_sales;
select count(*) from gold.fact_sales where shipping_date is null;
select shipping_date,count(*)
from gold.fact_sales 
group by shipping_date
having count(*)>1;

-- due_date checks: nulls, distinct count, duplicates
select due_date from gold.fact_sales;
select count(due_date) from gold.fact_sales;
select count(distinct due_date) from gold.fact_sales;
select count(*) from gold.fact_sales where due_date is null;
select due_date,count(*)
from gold.fact_sales 
group by due_date 
having count(*)>1;

-- Checking if there are any inconsistencies in logical order of dates
select * from gold.fact_sales where order_date>shipping_date and shipping_date>due_date;

-- sales_amount: range and average
select sales_amount from gold.fact_sales;
select count(sales_amount) from gold.fact_sales;
select min(sales_amount) as minsale,
       max(sales_amount) as maxsale,
       round(avg(sales_amount),2) as avgsale
from gold.fact_sales;

-- quantity: range and average
select quantity from gold.fact_sales;
select count(quantity) from gold.fact_sales;
select min(quantity) as minquantity,
       max(quantity) as maxquantity,
       round(avg(quantity),2) as avgquantity
from gold.fact_sales;

-- price: range and average
select price from gold.fact_sales;
select count(price) from gold.fact_sales;
select min(price) as minprice,
       max(price) as maxprice,
       round(avg(price),2) as avgprice
from gold.fact_sales;

-- Verifying reason for the duplication of order_number
select order_number, product_key, customer_key, quantity, price, sales_amount
from gold.fact_sales
where order_number in (
    select order_number
    from gold.fact_sales
    group by order_number
    having count(*) > 1
)
order by order_number
limit 20;

-- Checking any inconsistency in time (orders per month)
select 
    date_trunc('month', order_date) as order_month,
    count(*) as num_orders
from gold.fact_sales
where order_date is not null
group by date_trunc('month', order_date)
order by order_month;


/*
===============================================================================
Magnitude Analysis
===============================================================================
*/

-- Evaluating significance of cost of products to the total sales contribution (sales by product)
select p.product_key, p.product_name, p.cost, f.totalsales, f.totalunits
from gold.dim_products p
join (
    select product_key,
           sum(sales_amount) as totalsales,
           sum(quantity) as totalunits
    from gold.fact_sales
    group by product_key
    order by totalsales desc
    limit 11
) f on p.product_key = f.product_key
order by f.totalsales desc;

-- Sales by country
select 
    c.country,
    sum(sales_amount) as totalsales,
    sum(quantity) as totalunits
from gold.dim_customers c
left join gold.fact_sales s
on c.customer_key=s.customer_key
group by c.country
order by totalsales desc;


/*
===============================================================================
Ranking Analysis
===============================================================================
*/

-- Top 5 customers by spend
select 
    c.customer_key,
    c.first_name,
    c.last_name,
    sum(s.sales_amount) as totalsales
from gold.dim_customers c
join gold.fact_sales s
    on c.customer_key = s.customer_key
group by c.customer_key, c.first_name, c.last_name
order by totalsales desc
limit 5;

-- Bottom 5 customers by spend
select 
    c.customer_key,
    c.first_name,
    c.last_name,
    sum(s.sales_amount) as totalsales
from gold.dim_customers c
join gold.fact_sales s
    on c.customer_key = s.customer_key
group by c.customer_key, c.first_name, c.last_name
order by totalsales asc
limit 5;