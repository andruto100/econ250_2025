{{ config(
    materialized='incremental',
    unique_key='visitId',
    incremental_strategy='merge'
) }}

SELECT
  visitId,
  page
FROM {{ source('adatsiv_us', 'week5_hits') }}
WHERE hitNumber = 1

{% if is_incremental() %}
  AND date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
{% endif %}
