{{ config(
    materialized='table',
    partition_by={"field": "order_purchase_ts", "data_type": "timestamp"},
    cluster_by=["customer_id", "product_category_name_english"]
) }}

with orders as (
  select * from {{ ref('stg_orders') }}
),

customers_cte as (
  select * from {{ ref('stg_customers') }}
),

items as (
  select
    order_id,
    array_agg(struct(
      product_id,
      seller_id,
      shipping_limit_ts,
      price,
      freight_value
    )) as item_details
  from {{ ref('stg_order_items') }}
  group by order_id
),

payments as (
  select
    order_id,
    sum(payment_value) as total_payment_value,
    array_agg(distinct payment_type) as payment_methods
  from {{ ref('stg_order_payments') }}
  group by order_id
),

products as (
  select
    p.product_id,
    coalesce(t.product_category_name_english, p.product_category_name) as product_category_name_english
  from {{ ref('stg_products') }} p
  left join {{ ref('stg_product_translation') }} t
    on p.product_category_name = t.product_category_name
),

reviews as (
  select
    order_id,
    max(review_score) as review_score
  from {{ ref('stg_order_reviews') }}
  group by order_id
),

sellers as (
  select
    seller_id,
    seller_city,
    seller_state
  from {{ ref('stg_sellers') }}
)

select
  o.order_id,
  o.customer_id,
  c.customer_city,
  c.customer_state,
  o.order_status,
  o.order_purchase_ts,
  o.delivered_to_customer_ts,
  o.delivery_days,
  o.is_delivered,
  i.item_details,
  p.total_payment_value,
  p.payment_methods,
  r.review_score,
  pr.product_category_name_english
from orders o
left join customers_cte c on o.customer_id = c.customer_id
left join items i on o.order_id = i.order_id
left join payments p on o.order_id = p.order_id
left join reviews r on o.order_id = r.order_id
left join products pr on pr.product_id = i.item_details[OFFSET(0)].product_id
