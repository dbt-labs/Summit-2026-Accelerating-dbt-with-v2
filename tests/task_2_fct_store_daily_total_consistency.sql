select *
from {{ ref('task_2_fct_store_daily_buggy') }}
where
    daily_order_total is null
    or daily_subtotal is null
    or daily_tax_paid is null
    or abs(daily_order_total - (daily_subtotal + daily_tax_paid)) > 0.001
