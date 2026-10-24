SELECT
    od.*,
    (SELECT o.customer_id FROM orders AS o WHERE o.id = od.order_id) AS customer_id
FROM order_details AS od;
