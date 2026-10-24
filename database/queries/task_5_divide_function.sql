DROP FUNCTION IF EXISTS divide_float;

CREATE FUNCTION divide_float(dividend FLOAT, divisor FLOAT)
RETURNS FLOAT
DETERMINISTIC
NO SQL
RETURN dividend / divisor;

SELECT
    id,
    order_id,
    quantity,
    divide_float(quantity, 3) AS quantity_divided_by_3
FROM order_details;
