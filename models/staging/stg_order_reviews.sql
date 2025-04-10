{{ config(materialized='view') }}

with source as (
  select * from {{ source('adatsiv_us', 'fp_order_reviews') }}
)

select
  review_id,
  order_id,
  review_score,
  review_comment_title,
  review_comment_message,
  cast(review_creation_date as date) as review_creation_date,
  cast(review_answer_timestamp as timestamp) as review_answer_ts
from source
