-- E-Commerce

CREATE DATABASE L123;
USE L123;

CREATE TABLE User (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    RegistrationDate DATE,
    Address VARCHAR(255)
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(255),
    Category VARCHAR(100),
    Price DECIMAL(10, 2),
    Stock INT
);

CREATE TABLE Order1 (
    OrderID INT PRIMARY KEY,
    UserID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Subtotal DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Order1(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

INSERT INTO User VALUES 
(1, 'John Doe', 'john@example.com', '2024-01-15', '123 Elm St'),
(2, 'Jane Smith', 'jane@example.com', '2023-12-20', '456 Oak Ave'),
(3, 'Alice Johnson', 'alice@example.com', '2024-02-05', '789 Pine Rd');

INSERT INTO Product VALUES 
(1, 'Laptop', 'Electronics', 1200.00, 10),
(2, 'Headphones', 'Electronics', 150.00, 50),
(3, 'T-shirt', 'Clothing', 20.00, 100),
(4, 'Coffee Maker', 'Appliances', 80.00, 5);

INSERT INTO Order1 VALUES 
(1, 1, '2024-03-01', 1300.00),
(2, 2, '2024-03-05', 220.00),
(3, 1, '2024-03-10', 1200.00);

INSERT INTO OrderDetails VALUES 
(1, 1, 1, 1, 1200.00),
(2, 2, 2, 1, 150.00),
(3, 3, 1, 1, 1200.00);

-- Retrieve Total Sales per Product
SELECT p.Name, SUM(od.Subtotal) AS TotalSales
FROM Product p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.Name;

-- Find the Most Purchased Product Category
SELECT p.Category, SUM(od.Quantity) AS TotalQuantity
FROM Product p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalQuantity DESC
LIMIT 1;

-- Display Users Who Have Placed More Than 5 Orders
SELECT u.UserID, u.Name, COUNT(o.OrderID) AS OrderCount
FROM User u
JOIN Order o ON u.UserID = o.UserID
GROUP BY u.UserID, u.Name
HAVING OrderCount > 5;

-- Retrieve Products with Less Than 5 Stock Remaining
SELECT ProductID, Name, Stock
FROM Product
WHERE Stock < 5;

-- Find Orders Placed in the Last 30 Days
SELECT OrderID, UserID, OrderDate, TotalAmount
FROM Order
WHERE OrderDate BETWEEN CURDATE() - INTERVAL 30 DAY AND CURDATE();


