-- veri donusturme

-- verilerden hesaplama ile yeni veri bloklari olusturma
USE BikeStores;
GO
SELECT
    order_id,
    item_id,
    product_id,
    quantity,
    list_price,
    discount,
    (list_price * (1 - discount)) * quantity AS NetAmount
FROM sales.order_items;

-- mail adreslerinden kullanici adi olusturma
USE BikeStores;
GO
SELECT
    email,
    SUBSTRING(email, 1, CHARINDEX('@', email) - 1) AS UserName,
    SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS DomainName
FROM sales.customers
WHERE CHARINDEX('@', email) > 0;

--verilerden mantik elemanlari ile yeni veri bloklari olusturma
USE BikeStores;
GO
SELECT
    product_name,
    list_price,
    CASE
        WHEN list_price > 1000 THEN 'Premium'
        WHEN list_price > 500 THEN 'Mid-Range'
        ELSE 'Standard'
    END AS PriceCategory
FROM production.products;