{{ config(materialized='view') }}

select
  format_date('%Y-%m', order_purchase_ts) as order_month,
  count(distinct order_id) as total_orders,
  count(distinct customer_id) as unique_customers,
  round(sum(total_payment_value), 2) as total_revenue,
  avg(delivery_days) as avg_delivery_days
from {{ ref('fp_sales_full') }}
group by order_month
order by order_month
