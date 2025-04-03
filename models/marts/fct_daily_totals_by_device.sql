{{ config(
    materialized='incremental',
    partition_by='date',
    cluster_by='deviceCategory',
    incremental_strategy='insert_overwrite'
) }}

SELECT
  date,
  deviceCategory,
  COUNTIF(eventCategory IS NULL) AS pageviews,
  COUNTIF(eventCategory IS NOT NULL) AS events
FROM {{ source('adatsiv_us', 'week5_hits') }}
GROUP BY date, deviceCategory

{% if is_incremental() %}
  AND date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
{% endif %}
