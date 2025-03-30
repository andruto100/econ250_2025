{{ config(materialized='view') }}

select
  *,
  regexp_contains(title, r'^([^:]+):') as is_meta_page,
  regexp_extract(title, r'^([^:]+):') as meta_page_type
from {{ ref('stg_assignment3_uk_wiki') }}
