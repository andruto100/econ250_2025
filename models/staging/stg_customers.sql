{{ config(materialized='view') }}

with source as (
  select * from {{ source('adatsiv_us', 'fp_customers') }}
)

select
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix,
  customer_city,
  customer_state
from source
