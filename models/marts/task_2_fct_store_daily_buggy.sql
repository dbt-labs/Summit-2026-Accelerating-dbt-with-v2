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
        --is_open
    from {{ ref('stg_jaffle_shop__stores') }}

),

daily_rollup as (

    select
        orders.store_id,
        max(stores.store_location) as store_location,
        avg(stores.tax_rate) as tax_rate,
        date_trunc('day', orders.ordered_at) as order_date,

        count(orders.order_id) as orders_count,
        sum(coalesce(orders.subtotal, 0.0)) as daily_subtotal,
        sum(orders.tax_paid) as daily_tax_paid,
        sum(orders.order_total) as daily_order_total,

        daily_order_total / orders_count as avg_order_total,

        datediff('day', orders.ordered_at, stores.opened_at) as days_since_store_open

    from orders
    left join stores
        on orders.store_id = stores.store_id

    group by
        orders.store_id,
        order_date,
        orders.ordered_at,
        stores.opened_at


)

-- select *
-- from daily_rollup
-- order by order_date desc, store_id
select store_id, order_date, count(*) from daily_rollup group by store_id, order_date having count(*) > 1
