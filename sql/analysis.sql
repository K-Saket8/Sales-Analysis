/*
===============================================================================
Business Analysis
===============================================================================
Purpose:
    Answer the six business questions defined for this project, using the
    gold schema (dim_customers, dim_products, fact_sales).
===============================================================================
*/

-- ===========================================================================
-- Q1: Which countries generate the most revenue, and how 
--     concentrated is it?
-- ===========================================================================
select 
    c.country,
    sum(s.sales_amount) as total_sales,
    round(100.0 * sum(s.sales_amount) / sum(sum(s.sales_amount)) over (), 2) as pct_of_total
from gold.dim_customers c
join gold.fact_sales s
    on c.customer_key = s.customer_key
group by c.country
order by total_sales desc;


select 
    c.country,
    count(distinct c.customer_key) as num_customers,
    round(100.0 * count(distinct c.customer_key) / sum(count(distinct c.customer_key)) over (), 2) as pct_of_customers,
    sum(s.sales_amount) as total_sales,
    round(100.0 * sum(s.sales_amount) / sum(sum(s.sales_amount)) over (), 2) as pct_of_sales
from gold.dim_customers c
join gold.fact_sales s
    on c.customer_key = s.customer_key
group by c.country
order by total_sales desc;


select 
    c.country,
    round(avg(s.sales_amount), 2) as avg_sales_per_line_item,
    round(avg(s.quantity), 2) as avg_quantity_per_line_item,
    count(distinct s.order_number) as total_orders,
    round(sum(s.sales_amount)::numeric / count(distinct s.order_number), 2) as avg_revenue_per_order
from gold.dim_customers c
join gold.fact_sales s
    on c.customer_key = s.customer_key
group by c.country
order by avg_revenue_per_order desc;


-- ===========================================================================
-- Q2: Who are the top customers by spend, and how does the customer base 
--     break down when segmented by spend?
-- ===========================================================================
select 
    spend_tier,
    count(*) as num_customers,
    sum(total_spend) as tier_revenue,
    round(100.0 * sum(total_spend) / sum(sum(total_spend)) over (), 2) as pct_of_total_revenue
from (
    select 
        customer_key,
        total_spend,
        case ntile
            when 1 then 'Low'
            when 2 then 'Medium'
            when 3 then 'High'
        end as spend_tier
    from (
        select 
            c.customer_key,
            sum(s.sales_amount) as total_spend,
            ntile(3) over (order by sum(s.sales_amount)) as ntile
        from gold.dim_customers c
        join gold.fact_sales s
            on c.customer_key = s.customer_key
        group by c.customer_key
    ) ranked
) tiered
group by spend_tier
order by tier_revenue desc;



select 
    case ntile
        when 1 then 'Low'
        when 2 then 'Medium'
        when 3 then 'High'
    end as spend_tier,
    count(*) as num_customers,
    sum(total_spend) as tier_revenue,
    round(avg(total_spend), 2) as avg_spend_per_customer,
    round(avg(num_orders), 2) as avg_orders_per_customer,
    round(sum(total_spend) / sum(num_orders), 2) as avg_revenue_per_order
from (
    select 
        c.customer_key,
        sum(s.sales_amount) as total_spend,
        count(distinct s.order_number) as num_orders,
        ntile(3) over (order by sum(s.sales_amount)) as ntile
    from gold.dim_customers c
    join gold.fact_sales s
        on c.customer_key = s.customer_key
    group by c.customer_key
) ranked
group by ntile
order by tier_revenue desc;

