select
    store_id,
    order_date,
    count(*) as row_count
from {{ ref('task_2_fct_store_daily_buggy') }}
group by
    store_id,
    order_date
having
    store_id is null
    or order_date is null
    or count(*) != 1
