with orders as (

    select
        order_id,
        store_id,
        ordered_at,
        date_trunc('day', ordered_at) as order_date,
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
        opened_at--,
        --is_open
    from {{ ref('stg_jaffle_shop__stores') }}

),

daily_rollup as (

    select
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        orders.order_date,

        count(orders.order_id) as orders_count,
        sum(coalesce(orders.subtotal,0)) as daily_subtotal,
        sum(coalesce(orders.tax_paid,0)) as daily_tax_paid,
        sum(coalesce(orders.order_total,0)) as daily_order_total,

        daily_order_total / orders_count as avg_order_total,

        datediff('day',  stores.opened_at, orders.ordered_at) as days_since_store_open

    from orders
    left join stores
        on orders.store_id = stores.store_id

    group by
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        orders.order_date,
        datediff('day',  stores.opened_at, orders.ordered_at)

)

select *
from daily_rollup
order by order_date desc, store_id
