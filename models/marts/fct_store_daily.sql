with orders as (

    select
        order_id,
        store_id,
        ordered_at,
        subtotal,
        tax_paid,
        order_total
    from {{ ref('stg_jaffle_shop__orders') }}

),

stores as (

    select
        store_id,
        store_location,
        tax_rate,
        opened_at,
        datediff('day', opened_at, current_date()) as days_since_store_open
    from {{ ref('stg_jaffle_shop__stores') }}

),

daily_rollup as (

    select
        store_id,
        date_trunc('day', orders.ordered_at) as order_date,

        count(order_id) as orders_count,
        sum(subtotal) as daily_subtotal,
        sum(tax_paid) as daily_tax_paid,
        sum(order_total) as daily_order_total,

        daily_order_total / orders_count as avg_order_total,


    from orders

    group by
    store_id,
        order_date

),

joined as (
    select 
        daily_rollup.store_id,
        stores.store_location,
        stores.tax_rate,
        daily_rollup.order_date,
        daily_rollup.orders_count,
        daily_rollup.daily_subtotal,
        daily_rollup.daily_tax_paid,
        daily_rollup.daily_order_total,
        daily_rollup.avg_order_total,
        stores.days_since_store_open
    from daily_rollup
    left join stores
        on daily_rollup.store_id = stores.store_id
)

select *
from joined
order by order_date desc, store_id
