{{ config(materialized='view') }}

with source as (
  select * from {{ source('adatsiv_us', 'fp_order_items') }}
)

select
  order_id,
  order_item_id,
  product_id,
  seller_id,
  cast(shipping_limit_date as timestamp) as shipping_limit_ts,
  price,
  freight_value
from source
