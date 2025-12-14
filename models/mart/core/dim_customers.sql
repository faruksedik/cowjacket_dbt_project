{{
  config(
    materialized = 'table',
    schema = target.schema ~ '_marts',
    enabled = (target.name != 'dev')
  )
}}

with customers as (

    select *
    from {{ ref('stg_customers') }}

),

orders as (

    select *
    from {{ ref('stg_orders') }}

),

loyalty as (

    select *
    from {{ ref('stg_loyalty_points') }}

),

order_agg as (

    select
        customer_id,
        count(order_id) as total_orders,
        sum(total_amount) as lifetime_spend
    from orders
    group by customer_id

),

loyalty_agg as (

    select
        customer_id,
        sum(points_earned) as total_loyalty_points
    from loyalty
    group by customer_id

)

select
    c.customer_id,
    c.full_name,
    c.email,
    c.join_date,
    coalesce(o.total_orders, 0) as total_orders,
    coalesce(o.lifetime_spend, 0) as lifetime_spend,
    coalesce(l.total_loyalty_points, 0) as total_loyalty_points
from customers c
left join order_agg o
    on c.customer_id = o.customer_id
left join loyalty_agg l
    on c.customer_id = l.customer_id
