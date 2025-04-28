SET IDENTITY_INSERT production.categories ON;
INSERT INTO production.categories(category_id,category_name) VALUES(8,'Other Bikes')

SET IDENTITY_INSERT production.categories OFF;
SELECT *FROM production.categories;