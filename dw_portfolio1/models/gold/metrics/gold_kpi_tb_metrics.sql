{{ config(
    schema='public_gold',
    materialized='table'
) }}

WITH source AS(
    SELECT
        *,
    FROM {{ref silver_products_metrics}}
)

SELECT * FROM source;

