{{ config(materialized='table') }}

with raw_reviews as (
    select
        review_id,
        order_id,
        review_score,
        review_creation_date
    from {{ source('adatsiv_us', 'fp_order_reviews') }}
    where order_id is not null
      and review_id is not null
)

select
    review_id,
    order_id,
    review_score,
    review_creation_date
from raw_reviews
