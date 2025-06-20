--temizleme oncesi ve sonrasi kayit sayilari
USE BikeStores;
GO
-- degisiklikler
--bu ornekte bir NULL telefon numarasi atanir
SELECT 'Before Cleaning', COUNT(*) AS NullPhoneCount FROM sales.customers WHERE phone IS NULL;
UPDATE sales.customers SET phone = 'N/A' WHERE phone IS NULL;
SELECT 'After Cleaning', COUNT(*) AS NullPhoneCount FROM sales.customers WHERE phone IS NULL;

--donusum ozeti
USE BikeStores;
GO
SELECT
    CASE
        WHEN list_price > 1000 THEN 'Premium'
        WHEN list_price > 500 THEN 'Mid-Range'
        ELSE 'Standard'
    END AS PriceCategory,
    COUNT(*) AS NumberOfProducts
FROM production.products
GROUP BY
    CASE
        WHEN list_price > 1000 THEN 'Premium'
        WHEN list_price > 500 THEN 'Mid-Range'
        ELSE 'Standard'
    END;