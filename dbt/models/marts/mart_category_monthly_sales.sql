
SELECT 
    format_date('%Y-%m', order_date) as year_month,
    category,

    sum(amount) as total_sales,
    sum(quantity) as total_qty,
    count(distinct order_id) as order_count,

    round(
        sum(amount) / count(distinct order_id),
        2
    ) as avg_order_value

FROM {{ref('stg_amazon_sales')}}

WHERE amount is not null
    AND quantity is not null
    AND category is not null

GROUP BY 1, 2
