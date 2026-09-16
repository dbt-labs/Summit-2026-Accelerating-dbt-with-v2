with
    orders as (

        select order_id, store_id, ordered_at, subtotal, tax_paid, order_total
        from {{ ref("stg_jaffle_shop__orders") }}

    ),

    stores as (

        select
            store_id,
            store_location,
            cast(tax_rate as numeric(16, 4)) as tax_rate,
            opened_at
        from {{ ref("stg_jaffle_shop__stores") }}

    ),

    daily_rollup as (

        select
            orders.store_id,
            stores.store_location,
            stores.tax_rate,
            cast(orders.ordered_at as date) as order_date,
            stores.opened_at,

            count(orders.order_id) as orders_count,
            sum(coalesce(orders.subtotal, 0)) as daily_subtotal,
            sum(coalesce(orders.tax_paid, 0)) as daily_tax_paid,
            sum(coalesce(orders.order_total, 0)) as daily_order_total

        from orders
        left join stores on orders.store_id = stores.store_id
        group by
            orders.store_id,
            stores.store_location,
            stores.tax_rate,
            cast(orders.ordered_at as date),
            stores.opened_at

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
            cast(daily_order_total / nullif(orders_count, 0) as numeric(16, 2)) as avg_order_total,
            greatest(datediff('day', cast(opened_at as date), order_date), 0) as days_since_store_open
        from daily_rollup

    )

select *
from final
order by order_date desc, store_id
