{% macro get_normal_revenue(revenue_column) %}
  {{ revenue_column }} / 1e6
{% endmacro %}
