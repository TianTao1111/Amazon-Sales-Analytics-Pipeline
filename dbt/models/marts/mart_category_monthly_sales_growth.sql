
WITH final as (
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
    FROM  {{ ref('mart_category_monthly_sales') }}
)

SELECT *
FROM final