-- Step 1: Create schema (run this in a new database you create manually in pgAdmin)
DROP SCHEMA IF EXISTS gold CASCADE;
CREATE SCHEMA gold;

-- Step 2: Create tables
CREATE TABLE gold.dim_customers(
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);
COPY gold.dim_customers FROM 'D:\Sales-Analysis1\Data\dim_customers.csv' WITH (FORMAT csv, HEADER true);

CREATE TABLE gold.dim_products(
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);
COPY gold.dim_products FROM 'D:\Sales-Analysis1\Data\dim_products.csv' WITH (FORMAT csv, HEADER true);

CREATE TABLE gold.fact_sales(
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity SMALLINT,
    price INT
);

COPY gold.fact_sales FROM 'D:\Sales-Analysis1\Data\fact_sales.csv' WITH (FORMAT csv, HEADER true);









