{{ config(
    materialized = 'incremental',
    incremental_strategy = 'insert_overwrite',
    partition_by = {
        "field": "date",
        "data_type": "date"
    }
) }}

SELECT
  DATE(datehour) AS date,
  title,
  SUM(views) AS views,
  CURRENT_TIMESTAMP() AS insert_time
FROM {{ source('test_dataset', 'assignment5_input') }}
{% if is_incremental() %}
  WHERE DATE(datehour) >= _dbt_max_partition - 1
{% endif %}
GROUP BY 1, 2
