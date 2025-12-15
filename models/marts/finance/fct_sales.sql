{{
  config(
    enabled = (target.name != 'dev')
  )
}}

with orders as (

    select *
    from {{ ref('stg_orders') }}

),

order_items as (

    select *
    from {{ ref('stg_order_items') }}

),

products as (

    select *
    from {{ ref('stg_products') }}

)

select
    o.order_id,
    o.order_date,
    o.customer_id,
    oi.product_id,
    p.product_name,
    p.category,
    oi.quantity,
    oi.line_total,
    o.total_amount
from orders o
join order_items oi
    on o.order_id = oi.order_id
join products p
    on oi.product_id = p.product_id