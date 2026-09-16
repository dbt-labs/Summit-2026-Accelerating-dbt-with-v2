select *
from {{ ref('task_2_fct_store_daily_buggy') }}
where
    orders_count is null
    or orders_count <= 0
    or avg_order_total is null
    or abs(avg_order_total - (daily_order_total / orders_count)) > 0.001
