{{ config(materialized='view') }}

with source as (
  select * from {{ source('adatsiv_us', 'fp_order_payments') }}
)

select
  order_id,
  payment_sequential,
  payment_type,
  payment_installments,
  payment_value
from source
