{{ config(materialized='view') }}

with source as (
  select * from {{ source('adatsiv_us', 'fp_orders') }}
),

renamed as (
  select
    order_id,
    customer_id,
    order_status,
    cast(order_purchase_timestamp as timestamp) as order_purchase_ts,
    cast(order_approved_at as timestamp) as order_approved_ts,
    cast(order_delivered_carrier_date as timestamp) as delivered_to_carrier_ts,
    cast(order_delivered_customer_date as timestamp) as delivered_to_customer_ts,
    cast(order_estimated_delivery_date as timestamp) as estimated_delivery_ts,
    date_diff(order_delivered_customer_date, order_purchase_timestamp, day) as delivery_days,
    order_status = 'delivered' as is_delivered

  from source
)

select * from renamed
