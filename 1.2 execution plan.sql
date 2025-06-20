-- POOR: Non-SARGable query on sales.orders
USE BikeStores;
GO
SELECT order_id, order_date, customer_id
FROM sales.orders
WHERE YEAR(order_date) = 2017;

-- BETTER: SARGable query
USE BikeStores;
GO
SELECT order_id, order_date, customer_id
FROM sales.orders
WHERE order_date >= '2017-01-01' AND order_date < '2018-01-01';

--ctrl+l