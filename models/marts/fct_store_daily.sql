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

final as (

    select
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        cast(date_trunc('day', orders.ordered_at) as date) as order_date,
        count(orders.order_id) as orders_count,
        sum(orders.subtotal) as daily_subtotal,
        sum(orders.tax_paid) as daily_tax_paid,
        sum(orders.order_total) as daily_order_total,
        avg(orders.order_total) as avg_order_total,
        datediff(
            'day',
            cast(stores.opened_at as date),
            cast(date_trunc('day', orders.ordered_at) as date)
        ) as days_since_store_open
    from orders
    inner join stores
        on orders.store_id = stores.store_id
    group by
        orders.store_id,
        stores.store_location,
        stores.tax_rate,
        cast(stores.opened_at as date),
        cast(date_trunc('day', orders.ordered_at) as date)

)

select * from final
