--yeni bir kisi eklemek istiyoruz

INSERT INTO sales.customers (first_name, last_name, email) VALUES ('" + userInput_FirstName + "', '" + userInput_LastName + "', '" + userInput_Email + "');
--bu sekil bir insert, sql injectiona karsi savunmasizlik yaratir !!!

--template ile alinmasi daha güvenlidir
INSERT INTO sales.customers (first_name, last_name, email, city, state)
VALUES (?, ?, ?, ?, ?);