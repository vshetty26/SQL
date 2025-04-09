-- car rent 

create database Q123;
use Q123;

CREATE TABLE Car (
    CarID INT PRIMARY KEY,
    Model VARCHAR(255),
    Brand VARCHAR(255),
    Year INT,
    PricePerDay DECIMAL(10,2),
    Status VARCHAR(50)  -- Available, Rented, Under Maintenance
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(255),
    LicenseNumber VARCHAR(50) UNIQUE,
    Contact VARCHAR(20),
    Email VARCHAR(255) UNIQUE
);

CREATE TABLE Rental (
    RentalID INT PRIMARY KEY,
    CarID INT,
    CustomerID INT,
    StartDate DATE,
    EndDate DATE,
    TotalCost DECIMAL(10,2),
    FOREIGN KEY (CarID) REFERENCES Car(CarID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    RentalID INT,
    Amount DECIMAL(10,2),
    Date DATE,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (RentalID) REFERENCES Rental(RentalID)
);

INSERT INTO Car VALUES
(1, 'Civic', 'Honda', 2022, 50.00, 'Available'),
(2, 'Corolla', 'Toyota', 2021, 45.00, 'Rented'),
(3, 'Model S', 'Tesla', 2023, 100.00, 'Available'),
(4, 'Mustang', 'Ford', 2020, 80.00, 'Rented'),
(5, 'Camry', 'Toyota', 2019, 55.00, 'Available');

INSERT INTO Customer VALUES
(101, 'Alice Johnson', 'L1234567', '1234567890', 'alice@example.com'),
(102, 'Bob Williams', 'L9876543', '9876543210', 'bob@example.com'),
(103, 'Charlie Brown', 'L5555555', '5555555555', 'charlie@example.com'),
(104, 'David Lee', 'L6666666', '6666666666', 'david@example.com');

INSERT INTO Rental VALUES
(201, 1, 101, '2024-03-01', '2024-03-05', 250.00),
(202, 2, 102, '2024-03-10', '2024-03-15', 225.00),
(203, 3, 101, '2024-03-12', '2024-03-18', 600.00),
(204, 4, 103, '2024-03-15', '2024-03-20', 400.00),
(205, 2, 101, '2024-03-20', '2024-03-22', 90.00);

INSERT INTO Payment VALUES
(301, 201, 250.00, '2024-03-01', 'Credit Card'),
(302, 202, 225.00, '2024-03-10', 'PayPal'),
(303, 203, 600.00, '2024-03-12', 'Debit Card'),
(304, 204, 400.00, '2024-03-15', 'Cash'),
(305, 205, 90.00, '2024-03-20', 'Credit Card');


-- Retrieve All Cars Available for Rent
SELECT * FROM Car WHERE Status = 'Available';

-- Find Customers Who Have Rented a Car More Than Twice
SELECT CustomerID, Name, COUNT(*) AS RentalCount
FROM Rental
JOIN Customer ON Rental.CustomerID = Customer.CustomerID
GROUP BY CustomerID, Name
HAVING RentalCount > 2;

-- Retrieve Total Revenue Per Car Model
SELECT c.Model, SUM(r.TotalCost) AS TotalRevenue
FROM Rental r
JOIN Car c ON r.CarID = c.CarID
GROUP BY c.Model
ORDER BY TotalRevenue DESC;

-- Display Rental Details for the Past Month
SELECT * FROM Rental 
WHERE StartDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- Find Overdue Rentals (Where the Return Date Has Passed)
SELECT r.RentalID, c.Name AS CustomerName, car.Model, r.EndDate
FROM Rental r
JOIN Customer c ON r.CustomerID = c.CustomerID
JOIN Car car ON r.CarID = car.CarID
WHERE r.EndDate < CURDATE();
