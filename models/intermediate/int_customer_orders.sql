{{ config(materialized='view') }}

with customers as (

    select *
    from {{ ref('stg_customers') }}

),

orders as (

    select *
    from {{ ref('stg_orders') }}

),

order_items as (

    select *
    from {{ ref('stg_order_items') }}

),

joined as (

    select
        o.order_id,
        o.order_date,
        o.customer_id,
        c.full_name,
        c.email,

        oi.product_id,
        oi.quantity,
        oi.line_total,

        o.total_amount
    from orders o
    left join customers c
        on o.customer_id = c.customer_id
    left join order_items oi
        on o.order_id = oi.order_id

)

select * from joined
