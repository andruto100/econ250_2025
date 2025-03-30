{{ config(materialized='view') }}

select
    hour_of_day,
    count(*) as total_views,
    sum(case when src = 'mobile' then 1 else 0 end) as total_mobile_views
from {{ ref('int_assignment3_uk_wiki') }}
where title = 'Пюльне'
group by hour_of_day
order by hour_of_day
