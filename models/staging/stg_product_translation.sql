{{ config(materialized='view') }}

with source as (
  select * from {{ source('adatsiv_us', 'fp_product_category_name_translation') }}
)

select
  string_field_0 as product_category_name,
  string_field_1 as product_category_name_english
from {{ source('adatsiv_us', 'fp_product_category_name_translation') }}
