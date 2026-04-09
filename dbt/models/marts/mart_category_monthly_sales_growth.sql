
with base as (
    SELECT 
        format_date('%Y-%m', order_date) as year_month,
        category,
        sum(amount) as total_sales,
        sum(quantity) as total_qty,
        count(distinct order_id) as order_count,
        round(sum(amount)/count(distinct order_id), 2) as avg_order_value
    FROM {{ref('stg_amazon_sales')}}
    WHERE amount is not null
        AND quantity is not null
        AND category is not null
    GROUP BY 1, 2
),

final as (
    SELECT
        year_month,
        category,
        total_sales,
        total_qty,
        order_count,
        avg_order_value,

        lag(total_sales) over (
            partition by category
            ORDER BY year_month
        ) as previous_month_sales,

        round(
            100*(
                total_sales - lag(total_sales) over (
                    partition by category
                    ORDER BY year_month
                )
            ) / nullif(
                lag(total_sales) over (
                    partition by category
                    ORDER BY year_month
                ),
                0
            ),
            2
        )
        as sales_month_growth_pct
    FROM base
)

SELECT *
FROM final