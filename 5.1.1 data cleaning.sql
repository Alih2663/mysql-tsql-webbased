-- eksik verileri bulma
USE BikeStores;
GO
-- telefon infosu olmayan customer bulma
SELECT customer_id, first_name, last_name, email, phone FROM sales.customers WHERE phone IS NULL;

-- placeholder atama
UPDATE sales.customers
SET phone = 'N/A'
WHERE phone IS NULL AND email NOT LIKE '%+.com'; -- Example condition

--tutarsiz verileri duzeltme
USE BikeStores;
GO
--  'state' degiskeninde tutarsizlik bulma
SELECT state, COUNT(*) FROM sales.customers GROUP BY state ORDER BY state;

-- 'New York' u 'NY' ye cevirme
UPDATE sales.customers
SET state = 'NY'
WHERE state = 'New York';