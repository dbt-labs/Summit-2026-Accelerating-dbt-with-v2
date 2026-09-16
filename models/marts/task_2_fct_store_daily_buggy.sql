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
        opened_at
    from {{ ref('stg_jaffle_shop__stores') }}

),

store_daily_orders as (

    select
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        cast(date_trunc('day', orders.ordered_at) as date) as order_date,
        count(*) as orders_count,
        sum(orders.subtotal) as daily_subtotal,
        sum(orders.tax_paid) as daily_tax_paid,
        sum(orders.order_total) as daily_order_total,
        avg(orders.order_total) as avg_order_total,
        greatest(
            datediff(
                'day',
                cast(stores.opened_at as date),
                cast(orders.ordered_at as date)
            ),
            0
        ) as days_since_store_open
    from orders
    inner join stores
        on orders.store_id = stores.store_id
    group by
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        cast(date_trunc('day', orders.ordered_at) as date),
        greatest(
            datediff(
                'day',
                cast(stores.opened_at as date),
                cast(orders.ordered_at as date)
            ),
            0
        )

)

select
    store_id,
    store_location,
    tax_rate,
    order_date,
    orders_count,
    daily_subtotal,
    daily_tax_paid,
    daily_order_total,
    avg_order_total,
    days_since_store_open
from store_daily_orders
order by order_date desc, store_id
