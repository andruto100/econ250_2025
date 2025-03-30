{{ config(materialized='table') }}

select
  title,
  src,
  count(*) as views
from {{ ref('int_assignment3_uk_wiki') }}
where not is_meta_page
group by title, src
order by views desc
