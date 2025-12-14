with order_lines as (

    select
        order_id,
        sum(line_total) as calculated_total
    from {{ ref('fct_sales') }}
    group by order_id

),

orders as (

    select
        order_id,
        total_amount
    from {{ ref('stg_orders') }}

)

select
    o.order_id,
    o.total_amount,
    ol.calculated_total
from orders o
join order_lines ol
    on o.order_id = ol.order_id
where o.total_amount != ol.calculated_total
