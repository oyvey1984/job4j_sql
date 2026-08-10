WITH order_totals AS (
    SELECT
        o.id,
        o.user_id,
        o.created_at,
        SUM(oi.quantity * oi.unit_price) AS order_amount
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.id
    GROUP BY
        o.id,
        o.user_id,
        o.created_at
)
SELECT
    id order_id,
    user_id,
    created_at,
    order_amount,
    FIRST_VALUE(order_amount) OVER w AS first_order_amount,
    LAST_VALUE(order_amount) OVER w AS last_order_amount,
    NTH_VALUE(order_amount, 2) OVER w AS second_order_amount
FROM order_totals
WINDOW w AS (
        PARTITION BY user_id
        ORDER BY created_at
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    )
ORDER BY user_id, created_at;