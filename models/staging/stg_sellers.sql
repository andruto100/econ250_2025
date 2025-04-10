{{ config(materialized='view') }}

with source as (
  select * from {{ source('adatsiv_us', 'fp_sellers') }}
)

select
  seller_id,
  seller_zip_code_prefix,
  seller_city,
  seller_state
from source
