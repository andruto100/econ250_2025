{{ config(materialized='view') }}

with desktop as (
    select
        title,
        datehour,
        'desktop' as src
    from {{ source('test_dataset', 'assignment3_input_uk') }}
),

mobile as (
    select
        title,
        datehour,
        'mobile' as src
    from {{ source('test_dataset', 'assignment3_input_uk_m') }}
)

select
    title,
    datehour,
    src,
    date(datehour) as date,
    extract(dayofweek from datehour) as day_of_week,
    extract(hour from datehour) as hour_of_day
from desktop
union all
select
    title,
    datehour,
    src,
    date(datehour) as date,
    extract(dayofweek from datehour) as day_of_week,
    extract(hour from datehour) as hour_of_day
from mobile
