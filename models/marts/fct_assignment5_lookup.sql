{{ config(
    materialized = 'incremental',
    unique_key = 'title'
) }}

SELECT
  title,
  MIN(DATE(datehour)) AS min_date,
  MAX(DATE(datehour)) AS max_date,
  SUM(views) AS total_views
FROM {{ source('test_dataset', 'assignment5_input') }}
{% if is_incremental() %}
  WHERE DATE(datehour) >= (SELECT MAX(max_date) FROM {{ this }}) - 1
{% endif %}
GROUP BY 1
