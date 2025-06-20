USE BikeStores;
GO

CREATE TABLE dbo.StagingCustomerData (
    CustomerID_Raw VARCHAR(10),
    FullName_Raw VARCHAR(300),
    Email_Raw VARCHAR(255),
    City_Raw VARCHAR(50),
    State_Abbreviation_Expected CHAR(2)
);
INSERT INTO dbo.StagingCustomerData (CustomerID_Raw, FullName_Raw, Email_Raw, City_Raw) VALUES
('CUST001', 'John Doe', 'john.doe@example.com', 'New York City'),
('CUST002', 'Jane Smith', 'jane.smith@example.org', 'Los Angeles'),
('BADREC', 'Invalid User', 'invalid-email', 'Unknown');

CREATE TABLE sales.ProcessedCustomers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(50),
    state CHAR(2)
);