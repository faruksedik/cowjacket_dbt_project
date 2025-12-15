{{ config(materialized='view') }}

with customers as (

    select *
    from {{ ref('stg_customers') }}

),

loyalty as (

    select *
    from {{ ref('stg_loyalty_points') }}

),

joined as (

    select
        l.loyalty_id,
        l.customer_id,
        c.full_name,
        c.email,

        l.points_earned,
        l.transaction_date,
        l.points_source
    from loyalty l
    left join customers c
        on l.customer_id = c.customer_id

)

select * from joined
