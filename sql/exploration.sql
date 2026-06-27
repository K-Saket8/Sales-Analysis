/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    Sanity-check the gold schema after loading data into Postgres, and get
    oriented in the dataset before answering the business questions
    (e.g. what countries/categories exist, what time period the data covers).

Tables used:
    - information_schema.tables   -> confirms tables exist and loaded correctly
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales
===============================================================================
*/

--Checking all the tables in the schema
select table_name,table_schema,table_type
from information_schema.tables
where table_schema='gold';

--checking individual tables

--exploring table dim_products
select * from gold.dim_products;
select count(*) from gold.dim_products;
select distinct product_number from gold.dim_products;
select distinct category from gold.dim_products;
select distinct category_id from gold.dim_products;
select distinct subcategory from gold.dim_products;
select distinct maintenance from gold.dim_products;
select distinct product_line from gold.dim_products;
select distinct start_date from gold.dim_products;
--checking datatypes of columns
select column_name, data_type, is_nullable, character_maximum_length
from information_schema.columns
where table_name = 'dim_products'
order by ordinal_position;
--checking if each category_id is unique for each subcategory
select category_id, category, subcategory
from gold.dim_products
group by category_id, category, subcategory
order by category_id;
--counting if there are any duplicates in product_id
SELECT product_id, COUNT(*)
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1;
--where are categories and subcategories null?(earlier founded 1 null category and 1 null subcategory)
select p.product_key, p.product_name, p.category, p.subcategory
from gold.dim_products p
where category is null or subcategory is null;
--checking number of nulls in each column
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
--checking if any duplicate rows exist
select product_name, count(*)
from gold.dim_products
group by product_name
having count(*) > 1;











--exploring table dim_customers
select * from gold.dim_customers;
select count(*) from gold.dim_customers;

select customer_key from gold.dim_customers;
select count(distinct customer_key) from gold.dim_customers;
select customer_key from gold.dim_customers where customer_key is null;
select customer_key, count(*)
from gold.dim_customers
group by customer_key
having count(*) > 1;

select customer_id from gold.dim_customers;
select count(distinct customer_id) from gold.dim_customers;
select customer_id from gold.dim_customers where customer_id is null;
select customer_id, count(*)
from gold.dim_customers
group by customer_id
having count(*) > 1;

select customer_number from gold.dim_customers;
select count(distinct customer_number) from gold.dim_customers;
select customer_key from gold.dim_customers where customer_key is null;
select customer_number, count(*)
from gold.dim_customers
group by customer_number
having count(*) > 1;
--checking if multiple entries exist with same names and cross checking if they are same person or different people
select *
from gold.dim_customers
where (first_name, last_name) in (
    select first_name, last_name
    from gold.dim_customers
    group by first_name, last_name
    having count(*) > 1
)
order by first_name, last_name;

--checking how many countries are there
select distinct country from gold.dim_customers;
--checking values in marital_status column
select distinct marital_status from gold.dim_customers;
--checking values in gender column
select distinct gender from gold.dim_customers;
--checking birthdate column
select birthdate from gold.dim_customers;
select count(birthdate) from gold.dim_customers;
select birthdate from gold.dim_customers where birthdate is null;
select count(distinct birthdate) from gold.dim_customers;
select birthdate, count(*)
from gold.dim_customers
group by birthdate
having count(*) > 1;
--checking ranges of birthdate
select 
    min(birthdate) as oldest_birthdate,
    max(birthdate) as youngest_birthdate,
    extract(year from age(min(birthdate))) as oldest_age,
    extract(year from age(max(birthdate))) as youngest_age
from gold.dim_customers;
--checking create_date
select create_date from gold.dim_customers;
select count(create_date) from gold.dim_customers;
select create_date from gold.dim_customers where birthdate is null;
select count(distinct create_date) from gold.dim_customers;
select create_date, count(*)
from gold.dim_customers
group by create_date
having count(*) > 1;
--checking ranges of create_date
select 
    min(create_date) as oldest_create_date,
    max(create_date) as youngest_create_date
from gold.dim_customers;




