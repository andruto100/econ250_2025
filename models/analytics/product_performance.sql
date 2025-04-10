{{ config(materialized='view') }}

select
  product_category_name_english,
  count(distinct order_id) as total_orders,
  round(sum(total_payment_value), 2) as total_revenue,
  round(avg(total_payment_value), 2) as avg_order_value
from {{ ref('fp_sales_full') }}
group by product_category_name_english
order by total_revenue desc
