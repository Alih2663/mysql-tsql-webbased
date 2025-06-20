USE BikeStores;
GO
-- Find duplicate customers
WITH CustomerCTE AS (
    SELECT customer_id, first_name, last_name, email,
           ROW_NUMBER() OVER(PARTITION BY first_name, last_name, email ORDER BY customer_id) as rn
    FROM sales.customers
)
SELECT * FROM CustomerCTE WHERE rn > 1;


WITH CustomerCTE AS (
    SELECT customer_id, first_name, last_name, email,
           ROW_NUMBER() OVER(PARTITION BY first_name, last_name, email ORDER BY customer_id) as rn
    FROM sales.customers
)
DELETE FROM CustomerCTE WHERE rn > 1;