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

store_daily_rollup as (

    select
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        to_date(orders.ordered_at) as order_date,
        to_date(stores.opened_at) as store_open_date,
        count(orders.order_id) as orders_count,
        sum(orders.subtotal) as daily_subtotal,
        sum(orders.tax_paid) as daily_tax_paid,
        sum(orders.order_total) as daily_order_total,
        avg(orders.order_total) as avg_order_total
    from orders
    inner join stores
        on orders.store_id = stores.store_id
    group by
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        order_date,
        store_open_date

),

final as (

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
        datediff('day', store_open_date, order_date) as days_since_store_open
    from store_daily_rollup

)

select *
from final
order by order_date desc, store_id
