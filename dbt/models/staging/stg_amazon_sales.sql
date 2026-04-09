with source as (
    SELECT 
    *
    FROM {{source('ecommerce','raw_amazon_sales')}}
),

renamed as (
    SELECT
        `index` as row_index,
        order_id,
        parse_date('%m-%d-%y', date) as order_date,
        status as order_status,
        fulfilment,
        sales_channel_ sales_channel,
        `ship-service-level` as ship_service_level,
        style,
        sku,
        category,
        size,
        asin,
        courier_status,
        qty as quantity,
        currency,
        amount,
        `ship-city` as ship_city,
        `ship-state` as ship_state,
        cast(`ship-postal-code` as string) as ship_postal_code,
        `ship-country` as ship_country,
        `promotion-ids` as promotion_ids,
        b2b,
        `fulfilled-by` as fulfilled_by,
        `unnamed:_22` as unnamed_22

    FROM source
),


cleaned as(
    SELECT 
    *
    FROM renamed
    WHERE order_id is not null
        and order_date is not null
        and category is not null
        and quantity is not null
        and quantity > 0
        and amount is not null
        and amount >= 0

)

SELECT
*
FROM cleaned