-- Car

CREATE DATABASE I123;
USE I123;

CREATE TABLE Car (
    CarID INT PRIMARY KEY,
    Brand VARCHAR(50),
    Model VARCHAR(50),
    Year INT,
    Price DECIMAL(10,2),
    Availability BOOLEAN
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Phone VARCHAR(20),
    Email VARCHAR(255) UNIQUE,
    Address TEXT
);

CREATE TABLE Sale (
    SaleID INT PRIMARY KEY,
    CarID INT,
    CustomerID INT,
    SaleDate DATE,
    SaleAmount DECIMAL(10,2),
    FOREIGN KEY (CarID) REFERENCES Car(CarID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);


INSERT INTO Car VALUES 
(1, 'Toyota', 'Camry', 2023, 30000, TRUE),
(2, 'Honda', 'Civic', 2022, 25000, TRUE),
(3, 'BMW', 'X5', 2023, 60000, TRUE),
(4, 'Audi', 'A6', 2021, 55000, FALSE),
(5, 'Ford', 'Mustang', 2022, 45000, FALSE);

INSERT INTO Customer VALUES 
(1, 'John Doe', '1234567890', 'john@example.com', '123 Main St'),
(2, 'Alice Smith', '9876543210', 'alice@example.com', '456 Elm St'),
(3, 'Bob Brown', '4567891230', 'bob@example.com', '789 Pine St');

INSERT INTO Sale VALUES 
(1, 4, 1, '2024-02-10', 55000),
(2, 5, 2, '2024-03-15', 45000),
(3, 3, 1, '2024-01-20', 60000),
(4, 5, 3, '2024-04-01', 45000),
(5, 2, 2, '2024-02-25', 25000);


-- Retrieve Available Cars for Sale
SELECT * FROM Car
WHERE Availability = TRUE;

-- Find Customers Who Have Purchased More Than One Car
SELECT c.CustomerID, c.Name, COUNT(s.SaleID) AS CarsPurchased
FROM Sale s
JOIN Customer c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.Name
HAVING COUNT(s.SaleID) > 1;

-- Display the Total Sales Amount Per Car Brand
SELECT c.Brand, SUM(s.SaleAmount) AS TotalSales
FROM Sale s
JOIN Car c ON s.CarID = c.CarID
GROUP BY c.Brand
ORDER BY TotalSales DESC;

-- Retrieve Details of Sales Made in the Last 3 Months
SELECT * FROM Sale
WHERE SaleDate >= CURDATE() - INTERVAL 3 MONTH;

-- Find the Most Expensive Car Sold
SELECT c.CarID, c.Brand, c.Model, c.Year, s.SaleAmount
FROM Sale s
JOIN Car c ON s.CarID = c.CarID
ORDER BY s.SaleAmount DESC
LIMIT 1;