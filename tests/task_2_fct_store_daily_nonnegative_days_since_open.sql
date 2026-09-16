select *
from {{ ref('task_2_fct_store_daily_buggy') }}
where
    days_since_store_open is null
    or days_since_store_open < 0
