with source as (
    SELECT
        client_id,
        first_name,
        last_name,
        email,
        cpf,
        age,
        country
    FROM {{ source ('db_ecommerce_k53u', 'Clients') }}        
),

silver_clients as (
    SELECT
        client_id,
        first_name || ' ' || last_name as full_name,
        email,
        cpf,
        age,
        CASE
            WHEN country = 'European Community' THEN 'Estonia' -- País da união europeia que não existe na lista original
            WHEN country = 'RSA' THEN 'South Africa'
            WHEN country = 'EIRE' THEN 'Ireland'
            WHEN country = 'USA' THEN 'United States of America'
            ELSE country
        END as country
    FROM source
)

SELECT * FROM silver_clients
