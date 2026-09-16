with orders as (

    select
        order_id,
        store_id,
        ordered_at,
        subtotal_cents,
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

daily_rollup as (

    select
        stores.store_id,
        stores.store_location,
        stores.tax_rate,
        date_trunc('day', orders.ordered_at) as order_date,

        count(orders.order_id) as orders_count,
        sum(coalesce(orders.subtotal_cents, 0)) as daily_subtotal,
        sum(orders.tax_paid) as daily_tax_paid,
        sum(orders.order_total) as daily_order_total,

        daily_order_total / orders_count as avg_order_total,

        MAX(datediff('day', current_date(), stores.opened_at)) as days_since_store_open

    from stores
    left join orders
        on orders.store_id = stores.store_id

    group by
        stores.store_id,
        stores.store_location,
        stores.tax_rate,
        order_date

)

select *
from daily_rollup
order by order_date desc, store_id
