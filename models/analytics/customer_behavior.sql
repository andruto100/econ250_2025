{{ config(materialized='view') }}

select
  customer_id,
  count(order_id) as total_orders,
  round(sum(total_payment_value), 2) as total_spent,
  round(avg(total_payment_value), 2) as avg_order_value
from {{ ref('fp_sales_full') }}
group by customer_id
order by total_spent desc
