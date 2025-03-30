{{ config(materialized='table') }}

with base as (
    select
        title,
        src,
        count(*) as views
    from {{ ref('int_assignment3_uk_wiki') }}
    where coalesce(is_meta_page, false) = false
    group by title, src
),

aggregated as (
    select
        title,
        sum(case when src = 'desktop' then views else 0 end) as total_desktop_views,
        sum(case when src = 'mobile' then views else 0 end) as total_mobile_views
    from base
    group by title
),

final as (
    select
        title,
        (total_desktop_views + total_mobile_views) as total_views,
        total_mobile_views,
        safe_divide(total_mobile_views, (total_desktop_views + total_mobile_views)) * 100 as mobile_percentage
    from aggregated
)

select *
from final
order by mobile_percentage asc
limit 200
